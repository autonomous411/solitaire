#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TIMESTAMP="${TIMESTAMP:-$(date +%Y%m%d-%H%M%S)}"
OUT_DIR="${OUT_DIR:-$ROOT_DIR/docs/qa_sessions}"
LOG_DIR="${LOG_DIR:-$OUT_DIR/logs}"
REPORT_FILE="${REPORT_FILE:-$OUT_DIR/${TIMESTAMP}-hybrid-parity-smoke.md}"
BUILD_LOG="${BUILD_LOG:-$LOG_DIR/${TIMESTAMP}-hybrid-parity-build.log}"
DERIVED_DATA_PATH="${DERIVED_DATA_PATH:-$ROOT_DIR/.derived_data/hybrid-parity-smoke}"

mkdir -p "$OUT_DIR" "$LOG_DIR" "$DERIVED_DATA_PATH"

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
BUILD_EXIT=$?
set -e

if [[ "$BUILD_EXIT" == "0" ]]; then
  BUILD_STATUS="PASS"
else
  BUILD_STATUS="FAIL"
fi

SUMMARY_LINE="$(rg -m 1 "\*\* BUILD SUCCEEDED \*\*|\*\* BUILD FAILED \*\*|error:" "$BUILD_LOG" || true)"
if [[ -z "$SUMMARY_LINE" ]]; then
  SUMMARY_LINE="$(tail -n 1 "$BUILD_LOG" || true)"
fi

HAS_BRIDGE=$(rg -n "setFlipCardsNumber|snapshot|setUIModeToLegacy|setUIModeToSwiftUI" "Solitaire Watch WatchKit Extension/LegacyGameBridge.m" >/dev/null && echo "yes" || echo "no")
HAS_MULTI_RUN=$(rg -n "moveSelectedRun\(|isValidTableauRun\(" "Solitaire Watch WatchKit Extension/SwiftUIShellController.swift" >/dev/null && echo "yes" || echo "no")
HAS_WASTE_DISCARD=$(rg -n "wasteDiscard" "Solitaire Watch WatchKit Extension/SwiftUIShellController.swift" >/dev/null && echo "yes" || echo "no")
HAS_AUTO_MOVE=$(rg -n "autoMoveToFoundations\(" "Solitaire Watch WatchKit Extension/SwiftUIShellController.swift" >/dev/null && echo "yes" || echo "no")

cat > "$REPORT_FILE" <<REPORT
# Hybrid Parity Smoke - ${TIMESTAMP}

## Build
- Status: ${BUILD_STATUS} (exit ${BUILD_EXIT})
- Summary: ${SUMMARY_LINE}
- Log: ${BUILD_LOG}

## Parity Signals (Static)
- Bridge APIs present: ${HAS_BRIDGE}
- Multi-card tableau run logic present: ${HAS_MULTI_RUN}
- Waste-discard cycle state present: ${HAS_WASTE_DISCARD}
- Auto-move helper present: ${HAS_AUTO_MOVE}

## Next Manual Checks
1. Verify 1-card mode and 3-card mode transitions on device.
2. Verify move/no-op parity for waste->tableau/foundation and foundation->tableau edge cases.
3. Capture screenshot evidence for 40/46/49 mm in both renderers.
REPORT

echo "Generated parity smoke report: $REPORT_FILE"
