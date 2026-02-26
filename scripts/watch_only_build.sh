#!/usr/bin/env bash
set -euo pipefail

PROJECT="Solitaire Watch.xcodeproj"
SCHEME="Solitaire Watch Watch-Only"
DESTINATION="generic/platform=watchOS Simulator"
DERIVED_DATA_PATH="${DERIVED_DATA_PATH:-/tmp/solitaire-watch-dd}"

xcodebuild \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -configuration Debug \
  -destination "$DESTINATION" \
  -derivedDataPath "$DERIVED_DATA_PATH" \
  CODE_SIGNING_ALLOWED=NO \
  build
