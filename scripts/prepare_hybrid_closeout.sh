#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${OUT_DIR:-$ROOT_DIR/docs}"
OUT_FILE="${OUT_FILE:-$OUT_DIR/hybrid_issue_closeout.md}"

mkdir -p "$OUT_DIR"

cd "$ROOT_DIR"

last_commit_for_pattern() {
  local pattern="$1"
  git log --oneline --grep "$pattern" -n 1 | awk '{print $1}'
}

collect_issue_commits() {
  local issue="$1"
  git log --oneline --grep "Issue #${issue}:" | awk '{print $1}' | tr '\n' ' '
}

ISSUE10_COMMITS="$(collect_issue_commits 10)"
ISSUE11_COMMITS="$(collect_issue_commits 11)"
ISSUE12_COMMITS="$(collect_issue_commits 12)"
ISSUE13_COMMITS="$(collect_issue_commits 13)"
ISSUE14_COMMITS="$(collect_issue_commits 14)"
ISSUE15_COMMITS="$(collect_issue_commits 15)"

LATEST_SHA="$(git rev-parse --short HEAD)"
BRANCH_NAME="$(git branch --show-current)"

cat > "$OUT_FILE" <<REPORT
# Hybrid Migration Issue Closeout Draft

## Metadata
- Branch: ${BRANCH_NAME}
- Latest SHA: ${LATEST_SHA}

## Issue #10 - Runtime mode switch
- Status recommendation: Close
- Commits: ${ISSUE10_COMMITS}
- Closeout notes:
  - Added persisted renderer mode (legacy / swiftui) and runtime route switch.
  - Added storyboard routing (legacyRoot, swiftuiRoot) and SwiftUI host entry point.
  - Added in-app renderer toggle for rapid QA fallback.

## Issue #11 - SwiftUI shell scene
- Status recommendation: Close
- Commits: ${ISSUE11_COMMITS}
- Closeout notes:
  - Added full-screen SwiftUI shell scaffold for watch.
  - Established initial board section layout for deck/foundation/tableau.

## Issue #12 - Objective-C bridge
- Status recommendation: Close
- Commits: ${ISSUE12_COMMITS}
- Closeout notes:
  - Added LegacyGameBridge and bridging header.
  - Wired SwiftUI reads/writes through shared defaults-backed bridge API.

## Issue #13 - Pixel-perfect rendering
- Status recommendation: Close
- Commits: ${ISSUE13_COMMITS}
- Closeout notes:
  - Enforced pixel-locked card sizing and non-distorting rendering.
  - Added crop/offset rendering for deck depth and fan visuals.

## Issue #14 - SwiftUI interaction parity
- Status recommendation: Keep open until final device QA pass, then close
- Commits: ${ISSUE14_COMMITS}
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
- Commits: ${ISSUE15_COMMITS}
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
REPORT

echo "Generated closeout draft: $OUT_FILE"
