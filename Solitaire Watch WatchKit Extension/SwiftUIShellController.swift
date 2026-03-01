import SwiftUI
import WatchKit
import ImageIO

final class SwiftUIShellController: WKHostingController<SwiftUIShellView> {
    override var body: SwiftUIShellView {
        SwiftUIShellView()
    }

    override func willActivate() {
        super.willActivate()
        setTitle("")
    }
}

private struct BridgeSnapshot {
    let flipCards: Int
    let hasSavedBoard: Bool

    static func load() -> BridgeSnapshot {
        let dict = LegacyGameBridge.snapshot()
        return BridgeSnapshot(
            flipCards: (dict["flipCards"] as? NSNumber)?.intValue ?? 3,
            hasSavedBoard: (dict["hasSavedBoard"] as? NSNumber)?.boolValue ?? false
        )
    }
}

private struct CardMetrics {
    let width: CGFloat
    let height: CGFloat
    let deckDepthWidth: CGFloat
    let fanOffset: CGFloat
    let hiddenStep: CGFloat
    let sizeSuffix: String
}

private struct ResolvedImageKey {
    let filename: String
    let bundle: Bundle
}

private func metrics(for proxy: GeometryProxy) -> CardMetrics {
    if proxy.size.width <= 176 {
        return CardMetrics(width: 19, height: 25, deckDepthWidth: 3, fanOffset: 4, hiddenStep: 5, sizeSuffix: "38mm")
    }
    return CardMetrics(width: 22, height: 30, deckDepthWidth: 6, fanOffset: 5, hiddenStep: 6, sizeSuffix: "44mm")
}

private enum CardSuit: String, CaseIterable {
    case spade
    case club
    case diamond
    case heart

    var isRed: Bool {
        self == .diamond || self == .heart
    }
}

private struct SwiftCard: Equatable {
    let suit: CardSuit
    let rank: Int
}

private struct TableauPile {
    var hidden: [SwiftCard]
    var faceUp: [SwiftCard]

    var hiddenCount: Int {
        hidden.count
    }
}

private struct BoardState {
    var stock: [SwiftCard]
    var waste: [SwiftCard]
    var wasteDiscard: [SwiftCard]
    var foundations: [[SwiftCard]]
    var tableau: [TableauPile]
}

private enum Selection: Equatable {
    case waste
    case tableau(Int)
    case foundation(Int)
}

private enum InteractionMode: String, CaseIterable {
    case voiceAndMoves = "voiceandmoves"
    case voiceOnly = "voiceonly"
    case touchTwo = "touchtwo"
    case touchOne = "touchone"

    var title: String {
        switch self {
        case .voiceAndMoves: return "Voice + Moves"
        case .voiceOnly: return "Voice Only"
        case .touchTwo: return "Touch (2-Tap)"
        case .touchOne: return "Touch (1-Tap)"
        }
    }
}

private let interactionDefaultsKey = "solitairesetting"

private func loadInteractionMode() -> InteractionMode {
    let raw = UserDefaults.standard.string(forKey: interactionDefaultsKey) ?? InteractionMode.touchTwo.rawValue
    return InteractionMode(rawValue: raw) ?? .touchTwo
}

private func saveInteractionMode(_ mode: InteractionMode) {
    UserDefaults.standard.set(mode.rawValue, forKey: interactionDefaultsKey)
    UserDefaults.standard.synchronize()
}

private func rankToken(_ rank: Int) -> String {
    switch rank {
    case 1: return "A"
    case 11: return "J"
    case 12: return "Q"
    case 13: return "K"
    default: return "\(rank)"
    }
}

private func cardImageName(_ card: SwiftCard, sizeSuffix: String) -> String {
    _ = sizeSuffix
    return "\(card.suit.rawValue)\(rankToken(card.rank)).png"
}

private func normalizedAssetName(_ name: String) -> String {
    if name.hasSuffix(".png") {
        return String(name.dropLast(4))
    }
    return name
}

private func normalizedSkinName(_ skin: String?) -> String {
    guard let skin, !skin.isEmpty, skin != "1" else {
        return "classic"
    }
    return skin
}

private func candidateResourceBundles() -> [Bundle] {
    var bundles: [Bundle] = [Bundle.main]
    let mainPath = Bundle.main.bundlePath as NSString
    let pluginsPath = mainPath.deletingLastPathComponent as NSString
    let watchAppPath = pluginsPath.deletingLastPathComponent
    if let watchAppBundle = Bundle(path: watchAppPath), watchAppBundle.bundlePath != Bundle.main.bundlePath {
        bundles.append(watchAppBundle)
    }
    return bundles
}

private func bundleHasImage(named filename: String, in bundle: Bundle) -> Bool {
    if filename.isEmpty {
        return false
    }

    let ns = filename as NSString
    var ext = ns.pathExtension
    var base = ns.deletingPathExtension
    if ext.isEmpty {
        ext = "png"
        base = filename
    }

    var candidates = [base, "\(base)@2x", "\(base)@3x"]
    if (base.hasSuffix("@2x") || base.hasSuffix("@3x")), let at = base.lastIndex(of: "@") {
        let stripped = String(base[..<at])
        if !stripped.isEmpty {
            candidates.append(stripped)
        }
    }

    for candidate in candidates {
        if bundle.path(forResource: candidate, ofType: ext) != nil {
            return true
        }
    }
    return false
}

private func buildFilename(baseFilename: String, suffix: String) -> String {
    let ns = baseFilename as NSString
    let ext = ns.pathExtension.isEmpty ? "png" : ns.pathExtension
    let root = ns.deletingPathExtension
    return "\(root)\(suffix).\(ext)"
}

private func resolveImage(for baseFilename: String, preferLarge: Bool, skin: String?) -> ResolvedImageKey {
    let normalizedSkin = normalizedSkinName(skin)
    let sizeTokens = preferLarge ? ["44mm", "38mm"] : ["38mm", "44mm"]
    var candidates: [String] = [baseFilename, buildFilename(baseFilename: baseFilename, suffix: "_\(normalizedSkin)")]

    for token in sizeTokens {
        candidates.append(buildFilename(baseFilename: baseFilename, suffix: "_\(token)\(normalizedSkin)"))
        candidates.append(buildFilename(baseFilename: baseFilename, suffix: "_\(token)"))
        candidates.append(buildFilename(baseFilename: baseFilename, suffix: "_\(token)classic"))
    }

    let bundles = candidateResourceBundles()
    var seen = Set<String>()
    for candidate in candidates where !seen.contains(candidate) {
        seen.insert(candidate)
        for bundle in bundles where bundleHasImage(named: candidate, in: bundle) {
            return ResolvedImageKey(filename: candidate, bundle: bundle)
        }
    }

    return ResolvedImageKey(filename: baseFilename, bundle: Bundle.main)
}

private func candidateResourceNames(for filename: String) -> (names: [String], ext: String) {
    let ns = filename as NSString
    var ext = ns.pathExtension
    var base = ns.deletingPathExtension
    if ext.isEmpty {
        ext = "png"
        base = filename
    }

    var names = [base, "\(base)@2x", "\(base)@3x"]
    if (base.hasSuffix("@2x") || base.hasSuffix("@3x")), let at = base.lastIndex(of: "@") {
        let stripped = String(base[..<at])
        if !stripped.isEmpty {
            names.append(stripped)
        }
    }
    return (names: names, ext: ext)
}

private func loadCGImage(named filename: String, in bundle: Bundle) -> CGImage? {
    let parts = candidateResourceNames(for: filename)
    for name in parts.names {
        guard let path = bundle.path(forResource: name, ofType: parts.ext) else {
            continue
        }
        let url = URL(fileURLWithPath: path) as CFURL
        guard let source = CGImageSourceCreateWithURL(url, nil) else {
            continue
        }
        if let image = CGImageSourceCreateImageAtIndex(source, 0, nil) {
            return image
        }
    }
    return nil
}

private func shuffledDeck() -> [SwiftCard] {
    var deck: [SwiftCard] = []
    for suit in CardSuit.allCases {
        for rank in 1...13 {
            deck.append(SwiftCard(suit: suit, rank: rank))
        }
    }
    return deck.shuffled()
}

private func makeInitialBoard() -> BoardState {
    var deck = shuffledDeck()
    var tableau: [TableauPile] = []
    for i in 0..<7 {
        var pile: [SwiftCard] = []
        for _ in 0...i {
            if let c = deck.popLast() { pile.append(c) }
        }
        let faceUp = pile.isEmpty ? [] : [pile.removeLast()]
        tableau.append(TableauPile(hidden: pile, faceUp: faceUp))
    }
    return BoardState(
        stock: deck,
        waste: [],
        wasteDiscard: [],
        foundations: Array(repeating: [], count: 4),
        tableau: tableau
    )
}

private func dealInitialWaste(_ board: inout BoardState, flipCount: Int) {
    let drawCount = (flipCount == 1) ? 1 : 3
    moveCardsStacked(&board.stock, to: &board.waste, count: drawCount)
}

private func canMoveToFoundation(_ card: SwiftCard, foundation: [SwiftCard]) -> Bool {
    if let top = foundation.last {
        return top.suit == card.suit && card.rank == top.rank + 1
    }
    return card.rank == 1
}

private func canMoveToTableau(_ card: SwiftCard, pile: TableauPile) -> Bool {
    guard let top = pile.faceUp.last else {
        return card.rank == 13
    }
    return top.suit.isRed != card.suit.isRed && card.rank == top.rank - 1
}

private func isValidTableauRun(_ run: [SwiftCard]) -> Bool {
    guard run.count > 1 else { return !run.isEmpty }
    for i in 0..<(run.count - 1) {
        let upper = run[i]
        let lower = run[i + 1]
        if upper.suit.isRed == lower.suit.isRed { return false }
        if upper.rank != lower.rank + 1 { return false }
    }
    return true
}

struct SwiftUIShellView: View {
    @State private var snapshot: BridgeSnapshot
    @State private var stock: [SwiftCard]
    @State private var waste: [SwiftCard]
    @State private var wasteDiscard: [SwiftCard]
    @State private var foundations: [[SwiftCard]]
    @State private var tableau: [TableauPile]
    @State private var selection: Selection?
    @State private var winBannerVisible = false
    @State private var settingsPresented = false
    @State private var interactionMode: InteractionMode

    init() {
        let initialSnapshot = BridgeSnapshot.load()
        var initialBoard = makeInitialBoard()
        dealInitialWaste(&initialBoard, flipCount: initialSnapshot.flipCards)
        _snapshot = State(initialValue: initialSnapshot)
        _stock = State(initialValue: initialBoard.stock)
        _waste = State(initialValue: initialBoard.waste)
        _wasteDiscard = State(initialValue: initialBoard.wasteDiscard)
        _foundations = State(initialValue: initialBoard.foundations)
        _tableau = State(initialValue: initialBoard.tableau)
        _interactionMode = State(initialValue: loadInteractionMode())
    }

    var body: some View {
        GeometryReader { proxy in
            let card = metrics(for: proxy)
            let preferLarge = card.sizeSuffix == "44mm"
            let skin = UserDefaults(suiteName: "group.solitaire")?.string(forKey: "cardskin")
            let facedown = "facedown.png"
            let cardback = "cardback.png"

            ZStack {
                Color(red: 0.08, green: 0.49, blue: 0.22)
                    .ignoresSafeArea()

                VStack(spacing: 1) {
                    let topInset: CGFloat = 4

                    HStack(spacing: 10) {
                        WasteFanView(card: card, cards: Array(waste.suffix(3)), selected: selection == .waste, preferLarge: preferLarge, skin: skin)
                            .onTapGesture {
                                if !waste.isEmpty {
                                    selection = selection == .waste ? nil : .waste
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .center)

                        DeckStackView(card: card, imageName: facedown, stockCount: stock.count, selected: selection == .waste && waste.isEmpty, preferLarge: preferLarge, skin: skin)
                            .onTapGesture {
                                drawFromStock(count: snapshot.flipCards == 1 ? 1 : 3)
                            }
                    }
                    .padding(.leading, 18)
                    .padding(.trailing, 8)
                    .padding(.top, topInset)
                    .frame(height: card.height + 4)

                    HStack(spacing: 0) {
                        ForEach(0..<4, id: \.self) { i in
                            FoundationSlot(
                                card: card,
                                imageName: foundations[i].last.map { cardImageName($0, sizeSuffix: card.sizeSuffix) } ?? cardback,
                                preferLarge: preferLarge,
                                skin: skin,
                                highlighted: selection == .foundation(i)
                            )
                            .onTapGesture {
                                foundationTapped(i)
                            }
                        }
                    }
                    .frame(height: card.height + 6)
                    .padding(.top, 1)
                    .padding(.horizontal, 4)

                    HStack(alignment: .top, spacing: 2) {
                        ForEach(0..<7, id: \.self) { i in
                            TableauColumn(
                                card: card,
                                hiddenCount: tableau[i].hiddenCount,
                                hiddenImage: facedown,
                                faceUpImages: tableau[i].faceUp.map { cardImageName($0, sizeSuffix: card.sizeSuffix) },
                                emptyImage: cardback,
                                preferLarge: preferLarge,
                                skin: skin,
                                highlighted: selection == .tableau(i)
                            )
                            .onTapGesture {
                                tableauTapped(i)
                            }
                        }
                    }
                    .padding(.horizontal, 2)
                    .padding(.top, 1)

                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .ignoresSafeArea(edges: .top)

                VStack {
                    Spacer()
                    HStack {
                        Button {
                            settingsPresented = true
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 12, weight: .bold))
                                .frame(width: 28, height: 28)
                                .background(Color.black.opacity(0.28))
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)

                        Spacer()
                    }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 6)
                }
            }
            .onAppear {
                snapshot = BridgeSnapshot.load()
                interactionMode = loadInteractionMode()
            }
            .sheet(isPresented: $settingsPresented) {
                SwiftUISettingsView(
                    flipCards: snapshot.flipCards,
                    interactionMode: interactionMode,
                    onFlipCardsChanged: { next in
                        LegacyGameBridge.setFlipCardsNumber(next)
                        snapshot = BridgeSnapshot.load()
                    },
                    onInteractionModeChanged: { mode in
                        interactionMode = mode
                        saveInteractionMode(mode)
                    },
                    onNewDeal: {
                        newDeal()
                    },
                    onAutoMove: {
                        autoMoveToFoundations()
                    }
                )
            }
        }
    }

    private func newDeal() {
        var board = makeInitialBoard()
        dealInitialWaste(&board, flipCount: snapshot.flipCards)
        stock = board.stock
        waste = board.waste
        wasteDiscard = board.wasteDiscard
        foundations = board.foundations
        tableau = board.tableau
        selection = nil
        winBannerVisible = false
    }

    private func drawFromStock(count: Int) {
        if stock.isEmpty {
            moveCardsPreserved(&waste, to: &wasteDiscard, count: waste.count)
            moveCardsStacked(&wasteDiscard, to: &stock, count: wasteDiscard.count)
        }
        if stock.isEmpty { return }

        let flipCount = count == 1 ? 1 : 3
        if flipCount == 3 {
            moveCardsPreserved(&waste, to: &wasteDiscard, count: waste.count)
            moveCardsStacked(&stock, to: &waste, count: 3)
        } else {
            if waste.count < 3 {
                moveCardsStacked(&stock, to: &waste, count: 1)
            } else {
                moveCardsPreserved(&waste, to: &wasteDiscard, count: waste.count)
                moveCardsStacked(&stock, to: &waste, count: 1)
            }
        }
        selection = nil
        updateWinState()
    }

    private func selectedCard() -> SwiftCard? {
        switch selection {
        case .waste:
            return waste.last
        case .tableau(let i):
            return tableau[i].faceUp.last
        case .foundation(let i):
            return foundations[i].last
        case .none:
            return nil
        }
    }

    private func popOneFromSource(_ source: Selection) {
        switch source {
        case .waste:
            _ = waste.popLast()
        case .tableau(let i):
            _ = tableau[i].faceUp.popLast()
            revealIfNeeded(afterTableauRemovalAt: i)
        case .foundation(let i):
            _ = foundations[i].popLast()
        }
    }

    private func revealIfNeeded(afterTableauRemovalAt index: Int) {
        if tableau[index].faceUp.isEmpty, let revealed = tableau[index].hidden.popLast() {
            tableau[index].faceUp = [revealed]
        }
    }

    private func moveSelectedRun(from sourceIndex: Int, to targetIndex: Int) -> Bool {
        guard sourceIndex != targetIndex else { return false }
        let movingRun = tableau[sourceIndex].faceUp
        guard let lead = movingRun.first else { return false }
        guard isValidTableauRun(movingRun) else { return false }
        guard canMoveToTableau(lead, pile: tableau[targetIndex]) else { return false }
        tableau[targetIndex].faceUp.append(contentsOf: movingRun)
        tableau[sourceIndex].faceUp.removeAll()
        revealIfNeeded(afterTableauRemovalAt: sourceIndex)
        return true
    }

    private func foundationTapped(_ index: Int) {
        if selection == .foundation(index) {
            selection = nil
            return
        }

        guard let moving = selectedCard() else {
            if !foundations[index].isEmpty {
                selection = .foundation(index)
            }
            return
        }

        if case .foundation = selection {
            // Legacy allows foundation -> tableau, but not foundation -> foundation.
            if !foundations[index].isEmpty {
                selection = .foundation(index)
            }
            return
        }

        if canMoveToFoundation(moving, foundation: foundations[index]) {
            if let source = selection {
                popOneFromSource(source)
            }
            foundations[index].append(moving)
            selection = nil
            updateWinState()
        } else if !foundations[index].isEmpty {
            selection = .foundation(index)
        }
    }

    private func tableauTapped(_ index: Int) {
        if case .waste = selection, tableau[index].faceUp.isEmpty {
            // In legacy flow, tapping empty tableau while waste selected only works for a legal King move.
            guard let wasteTop = waste.last, canMoveToTableau(wasteTop, pile: tableau[index]) else {
                return
            }
        }

        if selection == .tableau(index) {
            selection = nil
            return
        }

        guard let moving = selectedCard() else {
            if !tableau[index].faceUp.isEmpty {
                selection = .tableau(index)
            }
            return
        }

        if case .foundation = selection, tableau[index].faceUp.isEmpty, moving.rank != 13 {
            // Foundation card can only go to empty tableau if it is a King.
            return
        }

        if case .tableau(let sourceIndex) = selection {
            if moveSelectedRun(from: sourceIndex, to: index) {
                selection = nil
                return
            }
        }

        if canMoveToTableau(moving, pile: tableau[index]), let source = selection {
            popOneFromSource(source)
            tableau[index].faceUp.append(moving)
            selection = nil
            updateWinState()
        } else if !tableau[index].faceUp.isEmpty {
            selection = .tableau(index)
        }
    }

    private func updateWinState() {
        let total = foundations.reduce(0) { $0 + $1.count }
        winBannerVisible = (total == 52)
    }

    private func autoMoveToFoundations() {
        var movedAny = true
        while movedAny {
            movedAny = false

            if let wasteCard = waste.last {
                for i in 0..<4 where canMoveToFoundation(wasteCard, foundation: foundations[i]) {
                    _ = waste.popLast()
                    foundations[i].append(wasteCard)
                    movedAny = true
                    break
                }
                if movedAny { continue }
            }

            for t in 0..<7 {
                guard let card = tableau[t].faceUp.last else { continue }
                var movedFromTableau = false
                for i in 0..<4 where canMoveToFoundation(card, foundation: foundations[i]) {
                    _ = tableau[t].faceUp.popLast()
                    revealIfNeeded(afterTableauRemovalAt: t)
                    foundations[i].append(card)
                    movedAny = true
                    movedFromTableau = true
                    break
                }
                if movedFromTableau { break }
            }
        }
        selection = nil
        updateWinState()
    }
}

private struct SwiftUISettingsView: View {
    @Environment(\.dismiss) private var dismiss
    let flipCards: Int
    let interactionMode: InteractionMode
    let onFlipCardsChanged: (Int) -> Void
    let onInteractionModeChanged: (InteractionMode) -> Void
    let onNewDeal: () -> Void
    let onAutoMove: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Settings")
                    .font(.headline)
                Spacer()
                Button("Close") {
                    dismiss()
                }
                .buttonStyle(.bordered)
                .font(.caption)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Flip Cards")
                    .font(.caption2)
                HStack(spacing: 6) {
                    Button("1-Card") {
                        onFlipCardsChanged(1)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(flipCards == 1 ? .green : .gray)
                    .font(.caption2)

                    Button("3-Card") {
                        onFlipCardsChanged(3)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(flipCards == 3 ? .green : .gray)
                    .font(.caption2)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Interaction")
                    .font(.caption2)
                ForEach(InteractionMode.allCases, id: \.self) { mode in
                    Button(mode.title) {
                        onInteractionModeChanged(mode)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(interactionMode == mode ? .green : .gray)
                    .font(.caption2)
                }
            }

            HStack(spacing: 6) {
                Button("New Deal") {
                    onNewDeal()
                    dismiss()
                }
                .buttonStyle(.bordered)
                .font(.caption2)

                Button("Auto Move") {
                    onAutoMove()
                    dismiss()
                }
                .buttonStyle(.bordered)
                .font(.caption2)
            }

            Spacer(minLength: 0)
        }
        .padding(8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.black.opacity(0.90))
    }
}

private func moveCardsPreserved(_ from: inout [SwiftCard], to: inout [SwiftCard], count: Int) {
    guard count > 0, from.count >= count else { return }
    let start = from.count - count
    let segment = Array(from[start...])
    from.removeSubrange(start...)
    to.append(contentsOf: segment)
}

private func moveCardsStacked(_ from: inout [SwiftCard], to: inout [SwiftCard], count: Int) {
    guard count > 0 else { return }
    for _ in 0..<count {
        guard let c = from.popLast() else { break }
        to.append(c)
    }
}

private struct PixelCard: View {
    let name: String
    let card: CardMetrics
    let preferLarge: Bool
    let skin: String?

    var body: some View {
        let resolved = resolveImage(for: name, preferLarge: preferLarge, skin: skin)
        if let cg = loadCGImage(named: resolved.filename, in: resolved.bundle) {
            Image(decorative: cg, scale: 1, orientation: .up)
                .resizable()
                .interpolation(.none)
                .antialiased(false)
                .aspectRatio(card.width / card.height, contentMode: .fit)
                .frame(width: card.width, height: card.height)
        } else {
            Rectangle()
                .fill(Color.clear)
                .frame(width: card.width, height: card.height)
        }
    }
}

private struct CardStrip: View {
    let name: String
    let card: CardMetrics
    let stripWidth: CGFloat
    let preferLarge: Bool
    let skin: String?

    var body: some View {
        PixelCard(name: name, card: card, preferLarge: preferLarge, skin: skin)
            .frame(width: stripWidth, height: card.height, alignment: .leading)
            .clipped()
    }
}

private struct DeckStackView: View {
    let card: CardMetrics
    let imageName: String
    let stockCount: Int
    let selected: Bool
    let preferLarge: Bool
    let skin: String?

    var body: some View {
        ZStack(alignment: .leading) {
            CardStrip(name: imageName, card: card, stripWidth: card.deckDepthWidth, preferLarge: preferLarge, skin: skin)
                .offset(x: 0)
            CardStrip(name: imageName, card: card, stripWidth: card.deckDepthWidth, preferLarge: preferLarge, skin: skin)
                .offset(x: card.deckDepthWidth)
            PixelCard(name: imageName, card: card, preferLarge: preferLarge, skin: skin)
                .offset(x: card.deckDepthWidth * 2)
            if stockCount == 0 {
                Rectangle().stroke(Color.white.opacity(0.45), lineWidth: 1)
                    .frame(width: card.width, height: card.height)
                    .offset(x: card.deckDepthWidth * 2)
            }
        }
        .frame(width: card.width + (card.deckDepthWidth * 2), height: card.height, alignment: .leading)
        .overlay(
            RoundedRectangle(cornerRadius: 2).stroke(selected ? Color.yellow : Color.clear, lineWidth: 1)
        )
    }
}

private struct WasteFanView: View {
    let card: CardMetrics
    let cards: [SwiftCard]
    let selected: Bool
    let preferLarge: Bool
    let skin: String?

    var body: some View {
        ZStack(alignment: .leading) {
            ForEach(Array(cards.enumerated()), id: \.offset) { idx, c in
                PixelCard(name: cardImageName(c, sizeSuffix: card.sizeSuffix), card: card, preferLarge: preferLarge, skin: skin)
                    .offset(x: CGFloat(idx) * card.fanOffset)
            }
        }
        .frame(width: card.width + (card.fanOffset * 2), height: card.height, alignment: .leading)
        .overlay(
            RoundedRectangle(cornerRadius: 2).stroke(selected ? Color.yellow : Color.clear, lineWidth: 1)
        )
    }
}

private struct FoundationSlot: View {
    let card: CardMetrics
    let imageName: String
    let preferLarge: Bool
    let skin: String?
    let highlighted: Bool

    var body: some View {
        ZStack {
            Color.clear
            PixelCard(name: imageName, card: card, preferLarge: preferLarge, skin: skin)
        }
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 2).stroke(highlighted ? Color.yellow : Color.clear, lineWidth: 1)
        )
    }
}

private struct TableauColumn: View {
    let card: CardMetrics
    let hiddenCount: Int
    let hiddenImage: String
    let faceUpImages: [String]
    let emptyImage: String
    let preferLarge: Bool
    let skin: String?
    let highlighted: Bool

    var body: some View {
        let faceUpStep = card.hiddenStep
        let visibleFaceUp = faceUpImages.isEmpty ? [emptyImage] : faceUpImages
        ZStack(alignment: .topLeading) {
            ForEach(0..<hiddenCount, id: \.self) { idx in
                PixelCard(name: hiddenImage, card: card, preferLarge: preferLarge, skin: skin)
                    .offset(y: CGFloat(idx) * card.hiddenStep)
            }

            ForEach(Array(visibleFaceUp.enumerated()), id: \.offset) { idx, name in
                PixelCard(name: name, card: card, preferLarge: preferLarge, skin: skin)
                    .offset(y: CGFloat(hiddenCount) * card.hiddenStep + CGFloat(idx) * faceUpStep)
            }
        }
        .frame(
            width: card.width,
            height: CGFloat(hiddenCount) * card.hiddenStep + CGFloat(max(visibleFaceUp.count - 1, 0)) * faceUpStep + card.height,
            alignment: .top
        )
        .overlay(
            RoundedRectangle(cornerRadius: 2).stroke(highlighted ? Color.yellow : Color.clear, lineWidth: 1)
        )
    }
}
