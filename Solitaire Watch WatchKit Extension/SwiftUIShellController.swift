import SwiftUI
import WatchKit

final class SwiftUIShellController: WKHostingController<SwiftUIShellView> {
    override var body: SwiftUIShellView {
        SwiftUIShellView()
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
    "\(card.suit.rawValue)\(rankToken(card.rank))_\(sizeSuffix).png"
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
    }

    var body: some View {
        GeometryReader { proxy in
            let card = metrics(for: proxy)
            let facedown = "facedown_\(card.sizeSuffix).png"
            let cardback = "cardback_\(card.sizeSuffix).png"

            VStack(spacing: 0) {
                HStack {
                    DeckStackView(card: card, imageName: facedown, stockCount: stock.count, selected: selection == .waste && waste.isEmpty)
                        .onTapGesture {
                            drawFromStock(count: snapshot.flipCards == 1 ? 1 : 3)
                        }

                    Spacer(minLength: 6)

                    WasteFanView(card: card, cards: Array(waste.suffix(3)), selected: selection == .waste)
                        .onTapGesture {
                            if !waste.isEmpty {
                                selection = selection == .waste ? nil : .waste
                            }
                        }
                }
                .padding(.horizontal, 2)
                .padding(.top, 2)
                .frame(height: card.height + 8)
                .background(Color(red: 0.20, green: 0.53, blue: 0.28))

                HStack(spacing: 0) {
                    ForEach(0..<4, id: \.self) { i in
                        FoundationSlot(
                            card: card,
                            imageName: foundations[i].last.map { cardImageName($0, sizeSuffix: card.sizeSuffix) } ?? cardback,
                            highlighted: selection == .foundation(i)
                        )
                        .onTapGesture {
                            foundationTapped(i)
                        }
                    }
                }
                .frame(height: card.height + 10)
                .background(Color(red: 0.31, green: 0.60, blue: 0.23))
                .padding(.top, 2)
                .padding(.horizontal, 1)

                HStack(alignment: .top, spacing: 2) {
                    ForEach(0..<7, id: \.self) { i in
                        TableauColumn(
                            card: card,
                            hiddenCount: tableau[i].hiddenCount,
                            hiddenImage: facedown,
                            topImage: tableau[i].faceUp.last.map { cardImageName($0, sizeSuffix: card.sizeSuffix) } ?? cardback,
                            highlighted: selection == .tableau(i)
                        )
                        .onTapGesture {
                            tableauTapped(i)
                        }
                    }
                }
                .padding(.horizontal, 2)
                .padding(.top, 2)

                Spacer(minLength: 4)

                VStack(spacing: 3) {
                    if winBannerVisible {
                        Text("You won")
                            .font(.footnote)
                            .foregroundStyle(.yellow)
                    }
                    Text("Flip: \(snapshot.flipCards)-Card | Saved: \(snapshot.hasSavedBoard ? "Yes" : "No")")
                        .font(.caption2)

                    Button(snapshot.flipCards == 1 ? "Flip Mode: 1-Card" : "Flip Mode: 3-Card") {
                        let next = snapshot.flipCards == 1 ? 3 : 1
                        LegacyGameBridge.setFlipCardsNumber(next)
                        snapshot = BridgeSnapshot.load()
                    }
                    .buttonStyle(.bordered)
                    .font(.footnote)

                    Button("New Deal") {
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
                    .buttonStyle(.bordered)
                    .font(.footnote)

                    Button("Auto Move") {
                        autoMoveToFoundations()
                    }
                    .buttonStyle(.bordered)
                    .font(.footnote)
                }
                .padding(.bottom, 2)
            }
            .background(Color(red: 0.08, green: 0.49, blue: 0.22))
            .ignoresSafeArea()
            .onAppear {
                snapshot = BridgeSnapshot.load()
            }
        }
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

        if case .waste = selection {
            // Waste cards only move to foundation/tableau, not between foundation piles.
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

    var body: some View {
        Image(name)
            .resizable()
            .interpolation(.none)
            .antialiased(false)
            .aspectRatio(card.width / card.height, contentMode: .fit)
            .frame(width: card.width, height: card.height)
    }
}

private struct CardStrip: View {
    let name: String
    let card: CardMetrics
    let stripWidth: CGFloat

    var body: some View {
        PixelCard(name: name, card: card)
            .frame(width: stripWidth, height: card.height, alignment: .leading)
            .clipped()
    }
}

private struct DeckStackView: View {
    let card: CardMetrics
    let imageName: String
    let stockCount: Int
    let selected: Bool

    var body: some View {
        ZStack(alignment: .leading) {
            PixelCard(name: imageName, card: card)
            CardStrip(name: imageName, card: card, stripWidth: card.deckDepthWidth)
                .offset(x: card.deckDepthWidth)
            CardStrip(name: imageName, card: card, stripWidth: card.deckDepthWidth)
                .offset(x: card.deckDepthWidth * 2)
            if stockCount == 0 {
                Rectangle().stroke(Color.white.opacity(0.45), lineWidth: 1)
                    .frame(width: card.width, height: card.height)
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

    var body: some View {
        ZStack(alignment: .leading) {
            ForEach(Array(cards.enumerated()), id: \.offset) { idx, c in
                PixelCard(name: cardImageName(c, sizeSuffix: card.sizeSuffix), card: card)
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
    let highlighted: Bool

    var body: some View {
        ZStack {
            Color.clear
            PixelCard(name: imageName, card: card)
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
    let topImage: String
    let highlighted: Bool

    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(0..<hiddenCount, id: \.self) { idx in
                PixelCard(name: hiddenImage, card: card)
                    .offset(y: CGFloat(idx) * card.hiddenStep)
            }
            PixelCard(name: topImage, card: card)
                .offset(y: CGFloat(hiddenCount) * card.hiddenStep)
        }
        .frame(width: card.width, height: CGFloat(hiddenCount) * card.hiddenStep + card.height, alignment: .top)
        .overlay(
            RoundedRectangle(cornerRadius: 2).stroke(highlighted ? Color.yellow : Color.clear, lineWidth: 1)
        )
    }
}
