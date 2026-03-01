#!/usr/bin/env bash
set -euo pipefail

# Hybrid issue workflow helper for autonomous411/solitaire
# Usage examples:
#   set -a; source .env; set +a
#   bash scripts/hybrid_issue_ops.sh list
#   bash scripts/hybrid_issue_ops.sh comment
#   bash scripts/hybrid_issue_ops.sh close-ready
#   bash scripts/hybrid_issue_ops.sh full
#
# Optional:
#   REPO="owner/repo" bash scripts/hybrid_issue_ops.sh list
#   DRY_RUN=1 bash scripts/hybrid_issue_ops.sh full

REPO="${REPO:-autonomous411/solitaire}"
API_ROOT="https://api.github.com/repos/${REPO}"
DRY_RUN="${DRY_RUN:-0}"

if [[ -z "${GITHUB_TOKEN:-}" ]]; then
  echo "GITHUB_TOKEN is not set."
  echo "Run: set -a; source .env; set +a"
  exit 1
fi

api_get() {
  local path="$1"
  curl -sS \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    -H "Accept: application/vnd.github+json" \
    "${API_ROOT}${path}"
}

api_post_json() {
  local path="$1"
  local payload="$2"
  if [[ "$DRY_RUN" == "1" ]]; then
    echo "[DRY_RUN] POST ${API_ROOT}${path}"
    echo "$payload" | jq . >/dev/null
    return 0
  fi
  curl -sS -X POST \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    -H "Accept: application/vnd.github+json" \
    -H "Content-Type: application/json" \
    "${API_ROOT}${path}" \
    -d "$payload"
}

api_patch_json() {
  local path="$1"
  local payload="$2"
  if [[ "$DRY_RUN" == "1" ]]; then
    echo "[DRY_RUN] PATCH ${API_ROOT}${path}"
    echo "$payload" | jq . >/dev/null
    return 0
  fi
  curl -sS -X PATCH \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    -H "Accept: application/vnd.github+json" \
    -H "Content-Type: application/json" \
    "${API_ROOT}${path}" \
    -d "$payload"
}

list_open_issues() {
  echo "Open issues in ${REPO}:"
  api_get "/issues?state=open&per_page=100" \
    | jq -r '.[] | select(.pull_request|not) | [.number,.title,.state] | @tsv'
}

issue_commits() {
  local issue="$1"
  git log --oneline --grep "Issue #${issue}:" | awk '{print $1}' | tr '\n' ' ' | sed 's/[[:space:]]*$//'
}

post_comment() {
  local issue="$1"
  local body="$2"
  local payload
  payload="$(jq -Rn --arg body "$body" '{body:$body}')"
  local response
  response="$(api_post_json "/issues/${issue}/comments" "$payload")"
  if [[ "$DRY_RUN" == "1" ]]; then
    echo "[DRY_RUN] comment prepared for #${issue}"
  else
    echo "$response" | jq -r '.html_url // .message'
  fi
}

close_issue() {
  local issue="$1"
  local payload='{"state":"closed","state_reason":"completed"}'
  local response
  response="$(api_patch_json "/issues/${issue}" "$payload")"
  if [[ "$DRY_RUN" == "1" ]]; then
    echo "[DRY_RUN] close prepared for #${issue}"
  else
    echo "$response" | jq -r '"#" + (.number|tostring) + " -> " + .state + " (" + (.html_url // "") + ")"'
  fi
}

build_comment_issue_10() {
  local commits="$1"
  cat <<TXT
Issue #10 closeout update

What shipped:
- Runtime renderer switch with persisted mode (legacy/swiftui)
- Storyboard routing for legacyRoot and swiftuiRoot
- In-app renderer toggle for rapid fallback/testing

Why this is complete:
- SwiftUI route can be enabled/disabled at runtime without removing legacy path
- Migration can continue incrementally while preserving a known-good renderer

Commits:
${commits}

Status recommendation: Close
TXT
}

build_comment_issue_11() {
  local commits="$1"
  cat <<TXT
Issue #11 closeout update

What shipped:
- SwiftUI watch shell scene and full-screen scaffold
- Deck/foundation/tableau zones established for hybrid path

Why this is complete:
- SwiftUI entry path is operational and provides a working surface for parity work

Commits:
${commits}

Status recommendation: Close
TXT
}

build_comment_issue_12() {
  local commits="$1"
  cat <<TXT
Issue #12 closeout update

What shipped:
- Objective-C bridge layer (LegacyGameBridge)
- Swift bridging header integration for WatchKit extension
- SwiftUI reads/writes routed through bridge for shared settings/state snapshot

Why this is complete:
- SwiftUI and legacy now share a stable interop boundary for migration

Commits:
${commits}

Status recommendation: Close
TXT
}

build_comment_issue_13() {
  local commits="$1"
  cat <<TXT
Issue #13 closeout update

What shipped:
- Pixel-locked card sizing (19x25 / 22x30)
- Non-distorting rendering via crop/offset fan/stack strategies
- Removed fractional scaling paths that caused card deformation

Why this is complete:
- SwiftUI rendering now preserves legacy art fidelity expectations

Commits:
${commits}

Status recommendation: Close
TXT
}

build_comment_issue_14() {
  local commits="$1"
  cat <<TXT
Issue #14 progress update

What shipped:
- Playable SwiftUI interaction scaffold (draw/recycle/select/move)
- Multi-card tableau run moves + run validation
- Shared flip mode parity (1-card/3-card) via bridge
- Legacy-aligned stock/waste/waste-discard cycle semantics
- New Deal reset, auto-move helper, win detection, and tap/no-op hardening

What remains before close:
- Final on-device parity sweep (40/46/49 mm)
- Confirm no regressions under rapid tap patterns and long sessions

Commits:
${commits}

Status recommendation: Keep open until final device QA is complete
TXT
}

build_comment_issue_15() {
  local commits="$1"
  cat <<TXT
Issue #15 progress update

What shipped:
- Dual-mode release gate doc and QA tooling
- Parity smoke script + parity status tracking doc
- Generated closeout-draft helper for #10-#15 workflow consistency

What remains before close:
- Complete dual-mode QA matrix with device evidence
- Final default renderer decision and rationale for submission

Commits:
${commits}

Status recommendation: Keep open until release decision is finalized
TXT
}

post_all_comments() {
  list_open_issues

  local c10 c11 c12 c13 c14 c15
  c10="$(issue_commits 10)"
  c11="$(issue_commits 11)"
  c12="$(issue_commits 12)"
  c13="$(issue_commits 13)"
  c14="$(issue_commits 14)"
  c15="$(issue_commits 15)"

  post_comment 10 "$(build_comment_issue_10 "$c10")"
  post_comment 11 "$(build_comment_issue_11 "$c11")"
  post_comment 12 "$(build_comment_issue_12 "$c12")"
  post_comment 13 "$(build_comment_issue_13 "$c13")"
  post_comment 14 "$(build_comment_issue_14 "$c14")"
  post_comment 15 "$(build_comment_issue_15 "$c15")"
}

close_ready_issues() {
  # Per current plan: close #10-#13, keep #14/#15 open.
  close_issue 10
  close_issue 11
  close_issue 12
  close_issue 13
}

usage() {
  cat <<TXT
Usage: bash scripts/hybrid_issue_ops.sh <command>

Commands:
  list        List open issues (read-only)
  comment     Post update/closeout comments to #10-#15
  close-ready Close #10-#13 (assumes comments already posted)
  full        Run list + comment + close-ready

Env:
  GITHUB_TOKEN (required)
  REPO (optional, default: autonomous411/solitaire)
  DRY_RUN=1 (optional, no network writes)
TXT
}

cmd="${1:-}"
case "$cmd" in
  list)
    list_open_issues
    ;;
  comment)
    post_all_comments
    ;;
  close-ready)
    close_ready_issues
    ;;
  full)
    list_open_issues
    post_all_comments
    close_ready_issues
    ;;
  *)
    usage
    exit 1
    ;;
esac
