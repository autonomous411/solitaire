# Hybrid Release Gate

This checklist decides which renderer is the default for the next release while keeping a rollback path.

## Gate Inputs
- Latest main branch commit passes watch simulator build.
- Dual-mode report generated with `scripts/hybrid_dual_mode_check.sh`.
- At least one physical-device pass for each target screen class.

## Required Pass Conditions
1. Legacy mode launches and plays with no regressions in known baseline flows.
2. SwiftUI mode launches and supports the targeted interaction set for the release.
3. Card rendering remains pixel-locked (19x25 or 22x30 points, no distortion).
4. Full-screen layout uses available vertical space without clipping controls.
5. No blocker defects remain open for Issue #15 and Issue #9.

## Decision Policy
- If SwiftUI mode fails any required pass condition, keep `legacy` as default.
- If SwiftUI mode passes all required conditions and has no blocker defects, switch default to `swiftui` for release candidate testing.
- Keep runtime switch available until after first successful submission and review.

## Closeout Evidence
- Link latest dual-mode report in `docs/qa_sessions/`.
- Link commits included in the release candidate.
- Link issue closeout note on Issue #15 and summary note on Issue #9.
