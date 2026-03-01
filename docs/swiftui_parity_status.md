# SwiftUI Parity Status

This tracks migration parity between legacy WatchKit UI and SwiftUI hybrid mode.

## Implemented
- Runtime renderer switch (`legacy` / `swiftui`) with persisted setting.
- SwiftUI full-screen board scaffold with pixel-locked card sizing.
- Objective-C bridge (`LegacyGameBridge`) for shared mode/flip settings.
- Core move interactions in SwiftUI:
  - deck draw/recycle
  - waste selection
  - tableau/foundation selections
  - legal single-card moves
- Multi-card tableau run transfer (validated alternating-color descending run).
- Shared flip mode toggle (1-card / 3-card) persisted through bridge.
- Stock/waste/waste-discard cycle semantics aligned to legacy flow.
- Auto-move helper to foundations and win banner.
- New deal reset action in SwiftUI mode.

## Remaining / Verification Needed
- Device QA against all target screen classes (40/46/49 mm) for layout clipping.
- Confirm exact legacy parity for all edge move semantics (especially source selection order and no-op taps).
- Confirm solved-deal/state restore behavior strategy for SwiftUI path.
- Performance and battery sanity check on-device during longer sessions.

## Release Gate Guidance
- Keep `legacy` as default until dual-mode QA matrix is green.
- Keep runtime switch enabled until first approved submission with hybrid code present.
