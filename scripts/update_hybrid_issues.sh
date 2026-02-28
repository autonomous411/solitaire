#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${GITHUB_TOKEN:-}" ]]; then
  echo "Set GITHUB_TOKEN first."
  echo "Example: export GITHUB_TOKEN='<pat>'"
  exit 1
fi

REPO="autonomous411/solitaire"

post_comment() {
  local issue="$1"
  local body="$2"
  curl -sS -X POST \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    -H "Accept: application/vnd.github+json" \
    -H "Content-Type: application/json" \
    "https://api.github.com/repos/${REPO}/issues/${issue}/comments" \
    -d "$(jq -Rn --arg body "$body" '{body:$body}')" \
    | jq -r '.html_url // .message'
}

post_comment 10 "Issue #10 progress update:\n\nImplemented and shipped hybrid runtime renderer switch.\n\nCompleted:\n- Added persisted mode flag (legacy/swiftui) in defaults\n- Added runtime route from legacy controller to SwiftUI host\n- Added storyboard identifiers/scenes for legacyRoot + swiftuiRoot\n- Added in-app menu toggle to switch renderers\n- Added Swift file + project wiring (Swift version, source inclusion)\n\nVerification:\n- watchOS simulator build passes\n\nRelated commit:\n- c563c45"

post_comment 11 "Issue #11 progress update:\n\nCompleted SwiftUI watch shell with full-screen board scaffold.\n\nCompleted:\n- Replaced placeholder SwiftUI view with structured board sections\n- Added full-screen layout behavior in SwiftUI host\n- Added initial board scaffolding for deck/foundation/tableau zones\n\nVerification:\n- watchOS simulator build passes\n\nRelated commit:\n- 7df224e"

post_comment 12 "Issue #12 progress update:\n\nObjective-C bridge layer is implemented and in use from SwiftUI.\n\nCompleted:\n- Added LegacyGameBridge (ObjC) for snapshot + mode updates\n- Added Watch extension bridging header\n- Configured SWIFT_OBJC_BRIDGING_HEADER in project\n- Migrated SwiftUI mode/snapshot reads to bridge APIs\n\nVerification:\n- watchOS simulator build passes\n\nRelated commit:\n- 401a3f0"

post_comment 13 "Issue #13 progress update:\n\nPixel-perfect rendering improvements shipped in SwiftUI path.\n\nCompleted:\n- Enforced fixed card dimensions (19x25 and 22x30)\n- Removed fractional card scaling causing distortion\n- Added crop/offset-based deck depth and fan rendering\n- Added pixel-safe tableau stacking layout\n\nVerification:\n- watchOS simulator build passes\n\nRelated commit:\n- 5e6e93b"

post_comment 14 "Issue #14 progress update:\n\nInteractive SwiftUI gameplay scaffold is implemented.\n\nCompleted:\n- Added board state model (stock/waste/foundation/tableau)\n- Added deck draw/recycle interaction\n- Added selection and move interactions (waste/tableau/foundation)\n- Added core single-card move validation rules\n- Preserved pixel-locked rendering path\n\nVerification:\n- watchOS simulator build passes\n\nRelated commit:\n- 4d22faa\n\nNote:\n- This is an interaction scaffold; full legacy-engine parity and state persistence wiring are next."

echo "Done posting issue updates."
