#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SESSIONS_DIR="${SESSIONS_DIR:-$ROOT_DIR/docs/qa_sessions}"
LOG_DIR="${LOG_DIR:-$SESSIONS_DIR/logs}"
TIMESTAMP="${TIMESTAMP:-$(date +%Y%m%d-%H%M%S)}"
SESSION_FILE="${SESSION_FILE:-$SESSIONS_DIR/${TIMESTAMP}.md}"
BUILD_LOG="${BUILD_LOG:-$LOG_DIR/${TIMESTAMP}-watch_only_build.log}"
ARCHIVE_LOG="${ARCHIVE_LOG:-$LOG_DIR/${TIMESTAMP}-watch_only_archive.log}"

mkdir -p "$SESSIONS_DIR" "$LOG_DIR"

BUILD_SHA="$(git -C "$ROOT_DIR" rev-parse --short HEAD)"
BRANCH_NAME="$(git -C "$ROOT_DIR" branch --show-current)"
XCODE_VERSION="$(xcodebuild -version | tr '\n' ' ' | sed 's/[[:space:]]\+/ /g')"

run_lane() {
  local name="$1"
  local command="$2"
  local log_file="$3"
  set +e
  (
    cd "$ROOT_DIR"
    bash -lc "$command"
  ) >"$log_file" 2>&1
  local code=$?
  set -e
  echo "$code"
}

BUILD_EXIT_CODE="$(run_lane "watch_only_build" "bash scripts/watch_only_build.sh" "$BUILD_LOG")"
ARCHIVE_EXIT_CODE="$(run_lane "watch_only_archive" "bash scripts/watch_only_archive.sh" "$ARCHIVE_LOG")"

if [[ "$BUILD_EXIT_CODE" == "0" ]]; then
  BUILD_STATUS="PASS"
else
  BUILD_STATUS="FAIL"
fi

if [[ "$ARCHIVE_EXIT_CODE" == "0" ]]; then
  ARCHIVE_STATUS="PASS"
else
  ARCHIVE_STATUS="FAIL"
fi

extract_summary() {
  local log_file="$1"
  local summary
  summary="$(rg -m 1 'No available simulator runtimes|supportedRuntimes=\[\]|CompileAssetCatalogVariant|\*\* BUILD FAILED \*\*|\*\* ARCHIVE FAILED \*\*' "$log_file" || true)"
  if [[ -z "$summary" ]]; then
    summary="$(tail -n 1 "$log_file" || true)"
  fi
  printf "%s" "$summary"
}

BUILD_SUMMARY="$(extract_summary "$BUILD_LOG")"
ARCHIVE_SUMMARY="$(extract_summary "$ARCHIVE_LOG")"

cat >"$SESSION_FILE" <<EOF
# QA Session - ${TIMESTAMP}

## Session metadata
- Date/time: $(date -u +"%Y-%m-%d %H:%M:%SZ")
- Tester: ${TESTER:-TBD}
- Build SHA: ${BUILD_SHA}
- Branch: ${BRANCH_NAME}
- Xcode: ${XCODE_VERSION}
- watchOS: ${WATCH_OS_VERSION:-TBD}
- Device model/screen class: ${DEVICE_MODEL:-TBD}

## Build lanes
- \`watch_only_build.sh\`: ${BUILD_STATUS} (exit ${BUILD_EXIT_CODE})
- \`watch_only_archive.sh\`: ${ARCHIVE_STATUS} (exit ${ARCHIVE_EXIT_CODE})
- On-device launch/install: ${ON_DEVICE_STATUS:-TBD}

## Lane summaries
- Build summary: ${BUILD_SUMMARY}
- Archive summary: ${ARCHIVE_SUMMARY}
- Build log: \`${BUILD_LOG}\`
- Archive log: \`${ARCHIVE_LOG}\`

## Scenario results
| Scenario | Result | Notes / Evidence |
| --- | --- | --- |
| Initial deal correctness |  |  |
| Redeal/reset flow |  |  |
| 1-card mode behavior |  |  |
| 3-card mode behavior |  |  |
| Valid move acceptance |  |  |
| Invalid move rejection |  |  |
| Foundation progression |  |  |
| Solved deal \`fixed\` mode |  |  |
| Solved deal \`round_robin\` mode |  |  |
| Solved-deal invalid payload fallback |  |  |
| Relaunch state restoration |  |  |
| Legacy upgrade persistence |  |  |
| Corrupt save recovery |  |  |
| Responsive layout checks |  |  |
| Card art fidelity checks |  |  |
| Stability/performance check |  |  |

## Defects found
| ID/Link | Severity | Summary | Repro steps | Owner | Status |
| --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |

## Release confidence
- Overall confidence (High/Medium/Low):
- Blocking issues:
- Recommended next actions:
EOF

echo "Generated QA session: $SESSION_FILE"
echo "Build log: $BUILD_LOG"
echo "Archive log: $ARCHIVE_LOG"
