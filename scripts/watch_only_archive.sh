#!/usr/bin/env bash
set -euo pipefail

PROJECT="Solitaire Watch.xcodeproj"
SCHEME="Solitaire Watch Watch-Only"
DESTINATION="generic/platform=watchOS"
DERIVED_DATA_PATH="${DERIVED_DATA_PATH:-/tmp/solitaire-watch-dd}"
ARCHIVE_PATH="${ARCHIVE_PATH:-/tmp/solitaire-watch-watchonly.xcarchive}"

# Default to unsigned archive checks for fast CLI iteration.
CODE_SIGNING_ALLOWED_VALUE="${CODE_SIGNING_ALLOWED_VALUE:-NO}"

xcodebuild \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -configuration Release \
  -destination "$DESTINATION" \
  -derivedDataPath "$DERIVED_DATA_PATH" \
  -archivePath "$ARCHIVE_PATH" \
  CODE_SIGNING_ALLOWED="$CODE_SIGNING_ALLOWED_VALUE" \
  archive
