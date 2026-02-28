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
        guard let dict = LegacyGameBridge.snapshot() as? [String: Any] else {
            return BridgeSnapshot(flipCards: 3, uiMode: watchUIModeSwiftUI, hasSavedBoard: false)
        }
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
}

private func metrics(for proxy: GeometryProxy) -> CardMetrics {
    // Keep card raster dimensions fixed to legacy sizes.
    if proxy.size.width <= 176 {
        return CardMetrics(width: 19, height: 25, deckDepthWidth: 3)
    }
    return CardMetrics(width: 22, height: 30, deckDepthWidth: 6)
}

struct SwiftUIShellView: View {
    @State private var snapshot = BridgeSnapshot.load()

    var body: some View {
        GeometryReader { proxy in
            let card = metrics(for: proxy)
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack {
                        HStack(spacing: 0) {
                            CardFace(name: card.width == 19 ? "facedown_38mm.png" : "facedown_44mm.png", width: card.width, height: card.height)
                            CardFace(name: card.width == 19 ? "facedown_38mm.png" : "facedown_44mm.png", width: card.deckDepthWidth, height: card.height)
                            CardFace(name: card.width == 19 ? "facedown_38mm.png" : "facedown_44mm.png", width: card.deckDepthWidth, height: card.height)
                        }
                        Spacer(minLength: 6)
                        HStack(spacing: 0) {
                            CardFace(name: card.width == 19 ? "heart10_38mm.png" : "heart10_44mm.png", width: card.width * 0.75, height: card.height)
                            CardFace(name: card.width == 19 ? "club2_38mm.png" : "club2_44mm.png", width: card.width * 0.75, height: card.height)
                            CardFace(name: card.width == 19 ? "heart2_38mm.png" : "heart2_44mm.png", width: card.width, height: card.height)
                        }
                    }
                    .padding(.horizontal, 2)
                    .frame(height: card.height + 6)
                    .background(Color(red: 0.20, green: 0.53, blue: 0.28))

                    HStack(spacing: 0) {
                        FoundationSlot(card: card)
                        FoundationSlot(card: card)
                        FoundationSlot(card: card)
                        FoundationSlot(card: card)
                    }
                    .frame(height: card.height + 10)
                    .background(Color(red: 0.31, green: 0.60, blue: 0.23))
                    .padding(.top, 2)
                }
                .padding(.top, 2)
                .padding(.horizontal, 1)

                HStack(alignment: .top, spacing: 2) {
                    ForEach(0..<7, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 0) {
                            CardFace(name: index % 2 == 0 ? (card.width == 19 ? "heart2_38mm.png" : "heart2_44mm.png") : (card.width == 19 ? "heart10_38mm.png" : "heart10_44mm.png"), width: card.width, height: card.height)
                            ForEach(0..<5, id: \.self) { _ in
                                CardFace(name: card.width == 19 ? "facedown_38mm.png" : "facedown_44mm.png", width: card.width, height: card.height * 0.35)
                            }
                        }
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
                        WKInterfaceController.reloadRootControllers(withNames: ["legacyRoot"], contexts: nil)
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

    var body: some View {
        ZStack {
            Color.clear
            CardFace(name: "cardback_44mm.png", width: card.width, height: card.height)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct CardFace: View {
    let name: String
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        Image(name)
            .resizable()
            .interpolation(.none)
            .frame(width: width, height: height)
    }
}
