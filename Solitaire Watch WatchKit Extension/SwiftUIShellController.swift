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

struct SwiftUIShellView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("SwiftUI Renderer")
                .font(.headline)
            Text("Hybrid mode is active. Use this screen while we migrate rendering and gameplay.")
                .font(.footnote)
                .multilineTextAlignment(.center)
            Button("Switch To Legacy") {
                let defaults = UserDefaults(suiteName: "group.solitaire") ?? .standard
                defaults.set(watchUIModeLegacy, forKey: watchUIModeKey)
                defaults.synchronize()
                WKInterfaceController.reloadRootControllers(withNames: ["legacyRoot"], contexts: nil)
            }
            .buttonStyle(.borderedProminent)

            Button("Stay In SwiftUI") {
                let defaults = UserDefaults(suiteName: "group.solitaire") ?? .standard
                defaults.set(watchUIModeSwiftUI, forKey: watchUIModeKey)
                defaults.synchronize()
            }
            .buttonStyle(.bordered)
        }
        .padding(12)
    }
}
