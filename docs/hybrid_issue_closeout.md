# Hybrid Migration Issue Closeout Draft

## Metadata
- Branch: main
- Latest SHA: 80271c4

## Issue #10 - Runtime mode switch
- Status recommendation: Close
- Commits: c563c45 
- Closeout notes:
  - Added persisted renderer mode (legacy / swiftui) and runtime route switch.
  - Added storyboard routing (legacyRoot, swiftuiRoot) and SwiftUI host entry point.
  - Added in-app renderer toggle for rapid QA fallback.

## Issue #11 - SwiftUI shell scene
- Status recommendation: Close
- Commits: 7df224e 
- Closeout notes:
  - Added full-screen SwiftUI shell scaffold for watch.
  - Established initial board section layout for deck/foundation/tableau.

## Issue #12 - Objective-C bridge
- Status recommendation: Close
- Commits: 401a3f0 
- Closeout notes:
  - Added LegacyGameBridge and bridging header.
  - Wired SwiftUI reads/writes through shared defaults-backed bridge API.

## Issue #13 - Pixel-perfect rendering
- Status recommendation: Close
- Commits: 5e6e93b 
- Closeout notes:
  - Enforced pixel-locked card sizing and non-distorting rendering.
  - Added crop/offset rendering for deck depth and fan visuals.

## Issue #14 - SwiftUI interaction parity
- Status recommendation: Keep open until final device QA pass, then close
- Commits: 1c675f1 c476470 ca5d267 f579454 e2d977e 4cd0c39 1ddc086 e5f33b4 4d22faa 
- Closeout notes:
  - Implemented playable interaction scaffold (deck draw/recycle, selection, legal moves).
  - Added multi-card tableau run moves and run validation.
  - Aligned stock/waste/waste-discard cycling semantics with legacy logic.
  - Added shared flip-mode parity, new-deal reset, auto-move helper, and win detection.
- Remaining checks before close:
  - Device-level parity sweep on 40/46/49 mm for edge interactions.
  - Confirm no regression in selection/no-op behavior under rapid taps.

## Issue #15 - Dual-mode QA / release decision
- Status recommendation: Keep open
- Commits: 80271c4 e0b52aa 
- Closeout notes:
  - Added release-gate doc and dual-mode QA tooling.
  - Added parity smoke tooling and parity status tracking doc.
- Remaining checks before close:
  - Complete dual-mode matrix with on-device evidence.
  - Decide default renderer for submission and record rationale.

## Suggested Issue Workflow
1. Post this closeout summary as an issue comment on #10-#15 (split per issue).
2. Close #10, #11, #12, #13 after comment confirmation.
3. Keep #14 and #15 open until device QA matrix is complete.
4. Roll final status and submission decision into #9 before release.
