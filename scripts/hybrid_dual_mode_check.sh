#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TIMESTAMP="${TIMESTAMP:-$(date +%Y%m%d-%H%M%S)}"
OUT_DIR="${OUT_DIR:-$ROOT_DIR/docs/qa_sessions}"
LOG_DIR="${LOG_DIR:-$OUT_DIR/logs}"
REPORT_FILE="${REPORT_FILE:-$OUT_DIR/${TIMESTAMP}-hybrid-dual-mode.md}"
BUILD_LOG="${BUILD_LOG:-$LOG_DIR/${TIMESTAMP}-hybrid-build.log}"
DERIVED_DATA_PATH="${DERIVED_DATA_PATH:-$ROOT_DIR/.derived_data/hybrid-dual-mode}"

mkdir -p "$OUT_DIR" "$LOG_DIR" "$DERIVED_DATA_PATH"

run_build() {
  set +e
  (
    cd "$ROOT_DIR"
    xcodebuild \
      -project "Solitaire Watch.xcodeproj" \
      -scheme "Solitaire Watch WatchKit App" \
      -configuration Debug \
      -destination "generic/platform=watchOS Simulator" \
      -derivedDataPath "$DERIVED_DATA_PATH" \
      CODE_SIGNING_ALLOWED=NO \
      build
  ) >"$BUILD_LOG" 2>&1
  local code=$?
  set -e
  echo "$code"
}

BUILD_EXIT_CODE="$(run_build)"
if [[ "$BUILD_EXIT_CODE" == "0" ]]; then
  BUILD_STATUS="PASS"
else
  BUILD_STATUS="FAIL"
fi

BUILD_SHA="$(git -C "$ROOT_DIR" rev-parse --short HEAD)"
BRANCH_NAME="$(git -C "$ROOT_DIR" branch --show-current)"
XCODE_VERSION="$(xcodebuild -version | tr '\n' ' ' | sed 's/[[:space:]]\+/ /g')"

SUMMARY_LINE="$(rg -m 1 "\*\* BUILD SUCCEEDED \*\*|\*\* BUILD FAILED \*\*|error:|warning:" "$BUILD_LOG" || true)"
if [[ -z "$SUMMARY_LINE" ]]; then
  SUMMARY_LINE="$(tail -n 1 "$BUILD_LOG" || true)"
fi

cat > "$REPORT_FILE" <<REPORT
# Hybrid Dual-Mode QA Gate - ${TIMESTAMP}

## Metadata
- Date/time (UTC): $(date -u +"%Y-%m-%d %H:%M:%SZ")
- Build SHA: ${BUILD_SHA}
- Branch: ${BRANCH_NAME}
- Xcode: ${XCODE_VERSION}

## Build Gate
- watchOS simulator build: ${BUILD_STATUS} (exit ${BUILD_EXIT_CODE})
- Build summary: ${SUMMARY_LINE}
- Build log: ${BUILD_LOG}

## Mode Test Matrix
| Test | Legacy Mode | SwiftUI Mode | Notes |
| --- | --- | --- | --- |
| Launch to playable board |  |  |  |
| Deck draw/recycle behavior |  |  |  |
| Move to foundation |  |  |  |
| Move between tableau columns |  |  |  |
| Invalid move rejection |  |  |  |
| Redeal/reset behavior |  |  |  |
| Visual card fidelity (pixel-locked) |  |  |  |
| Full-screen layout usage |  |  |  |
| State restore after relaunch |  |  |  |

## Release Default Decision
- Recommended default mode for next TestFlight/App Store build:
- Rationale:
- Blocking gaps before choosing SwiftUI as default:

## Follow-up Actions
1. 
2. 
3. 
REPORT

echo "Generated hybrid QA report: $REPORT_FILE"
echo "Build log: $BUILD_LOG"
