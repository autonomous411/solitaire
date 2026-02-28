import SwiftUI
import WatchKit

private let watchUIModeKey = "watch_ui_mode"
private let watchUIModeLegacy = "legacy"
private let watchUIModeSwiftUI = "swiftui"

final class SwiftUIShellController: WKHostingController<SwiftUIShellView> {
    override var body: SwiftUIShellView {
        SwiftUIShellView()
    }
}

private struct BridgeSnapshot {
    let flipCards: Int
    let uiMode: String
    let hasSavedBoard: Bool

    static func load() -> BridgeSnapshot {
        let dict = LegacyGameBridge.snapshot()
        return BridgeSnapshot(
            flipCards: (dict["flipCards"] as? NSNumber)?.intValue ?? 3,
            uiMode: (dict["uiMode"] as? String) ?? watchUIModeSwiftUI,
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
}

private func metrics(for proxy: GeometryProxy) -> CardMetrics {
    // Keep card raster dimensions fixed to legacy sizes.
    if proxy.size.width <= 176 {
        return CardMetrics(width: 19, height: 25, deckDepthWidth: 3, fanOffset: 4, hiddenStep: 5)
    }
    return CardMetrics(width: 22, height: 30, deckDepthWidth: 6, fanOffset: 5, hiddenStep: 6)
}

private struct ArtSet {
    let faceDown: String
    let cardBack: String
    let sampleA: String
    let sampleB: String
    let sampleC: String
}

private func art(for card: CardMetrics) -> ArtSet {
    if card.width == 19 {
        return ArtSet(
            faceDown: "facedown_38mm.png",
            cardBack: "cardback_38mm.png",
            sampleA: "heart10_38mm.png",
            sampleB: "club2_38mm.png",
            sampleC: "heart2_38mm.png"
        )
    }
    return ArtSet(
        faceDown: "facedown_44mm.png",
        cardBack: "cardback_44mm.png",
        sampleA: "heart10_44mm.png",
        sampleB: "club2_44mm.png",
        sampleC: "heart2_44mm.png"
    )
}

struct SwiftUIShellView: View {
    @State private var snapshot = BridgeSnapshot.load()

    var body: some View {
        GeometryReader { proxy in
            let card = metrics(for: proxy)
            let assets = art(for: card)
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack {
                        HStack(spacing: 0) {
                            PixelCard(name: assets.faceDown, card: card)
                            CardStrip(name: assets.faceDown, card: card, stripWidth: card.deckDepthWidth)
                            CardStrip(name: assets.faceDown, card: card, stripWidth: card.deckDepthWidth)
                        }
                        Spacer(minLength: 6)
                        DeckFlipFan(card: card, assets: assets)
                    }
                    .padding(.horizontal, 2)
                    .frame(height: card.height + 6)
                    .background(Color(red: 0.20, green: 0.53, blue: 0.28))

                    HStack(spacing: 0) {
                        FoundationSlot(card: card, imageName: assets.cardBack)
                        FoundationSlot(card: card, imageName: assets.cardBack)
                        FoundationSlot(card: card, imageName: assets.cardBack)
                        FoundationSlot(card: card, imageName: assets.cardBack)
                    }
                    .frame(height: card.height + 10)
                    .background(Color(red: 0.31, green: 0.60, blue: 0.23))
                    .padding(.top, 2)
                }
                .padding(.top, 2)
                .padding(.horizontal, 1)

                HStack(alignment: .top, spacing: 2) {
                    ForEach(0..<7, id: \.self) { index in
                        TableauColumn(
                            card: card,
                            hiddenCount: index,
                            hiddenImage: assets.faceDown,
                            faceImage: index % 2 == 0 ? assets.sampleC : assets.sampleA
                        )
                    }
                }
                .padding(.horizontal, 2)
                .padding(.top, 2)

                Spacer(minLength: 4)

                VStack(spacing: 4) {
                    Text("Flip: \(snapshot.flipCards)-Card | Saved: \(snapshot.hasSavedBoard ? "Yes" : "No")")
                        .font(.caption2)
                    Text("Mode: \(snapshot.uiMode)")
                        .font(.caption2)

                    Button("Switch To Legacy") {
                        LegacyGameBridge.setUIModeToLegacy()
                        snapshot = BridgeSnapshot.load()
                        WKInterfaceController.reloadRootPageControllers(withNames: ["legacyRoot"], contexts: nil, orientation: .horizontal, pageIndex: 0)
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.footnote)

                    Button("Keep SwiftUI") {
                        LegacyGameBridge.setUIModeToSwiftUI()
                        snapshot = BridgeSnapshot.load()
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
}

private struct FoundationSlot: View {
    let card: CardMetrics
    let imageName: String

    var body: some View {
        ZStack {
            Color.clear
            PixelCard(name: imageName, card: card)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct DeckFlipFan: View {
    let card: CardMetrics
    let assets: ArtSet

    var body: some View {
        ZStack(alignment: .leading) {
            PixelCard(name: assets.sampleC, card: card)
                .offset(x: card.fanOffset * 2)
            PixelCard(name: assets.sampleB, card: card)
                .offset(x: card.fanOffset)
            PixelCard(name: assets.sampleA, card: card)
        }
        .frame(width: card.width + (card.fanOffset * 2), height: card.height, alignment: .leading)
    }
}

private struct TableauColumn: View {
    let card: CardMetrics
    let hiddenCount: Int
    let hiddenImage: String
    let faceImage: String

    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(0..<hiddenCount, id: \.self) { idx in
                PixelCard(name: hiddenImage, card: card)
                    .offset(y: CGFloat(idx) * card.hiddenStep)
            }
            PixelCard(name: faceImage, card: card)
                .offset(y: CGFloat(hiddenCount) * card.hiddenStep)
        }
        .frame(width: card.width, height: CGFloat(hiddenCount) * card.hiddenStep + card.height, alignment: .top)
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
