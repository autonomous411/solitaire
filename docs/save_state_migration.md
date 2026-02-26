# Save State Migration (Phase 7)

## Goals
- Preserve existing `savedata` payload compatibility for installed users.
- Prevent crash loops from malformed or partial saved payloads.
- Keep app-group defaults (`group.solitaire`) as primary storage with safe legacy fallback.

## Keys
- `savedata`: JSON-encoded array payload (14 stacks) used by watch save/load and companion signaling.
- `savedata_schema_version`: integer schema version marker.
- `flipcardnumber`: cards-per-flip setting (`1` or `3`).
- Solved-deal keys (unchanged compatibility surface):
  - `solved_deals`
  - `solved_deal_selection_mode`
  - `solved_deal_fixed_index`
  - `solved_deal_round_robin_index`
  - `solved_deal_last_index`

## Schema version
- Current schema version: `2`.
- `savedata` remains an array for backward compatibility; versioning is tracked by `savedata_schema_version`.

## Save payload shape
- Array with exactly 14 arrays in this order:
  1. `deckStack`
  2. `deckFlip`
  3. `deckFlipDiscard`
  4. `hand0`
  5. `hand1`
  6. `hand2`
  7. `hand3`
  8. `hand4`
  9. `hand5`
  10. `hand6`
  11. `discard1`
  12. `discard2`
  13. `discard3`
  14. `discard4`

Card encoding:
- Each card is a signed integer index.
- Absolute value range: `1..52`.
- Sign indicates face direction (`>0` face up, `<0` face down).

Validation rules:
- All 14 stacks must exist and be arrays.
- Every card entry must be numeric and in range.
- No duplicate absolute indexes.
- Total cards across all stacks must be exactly 52.

## Migration behavior
- On init, values are copied from standard defaults to app-group defaults only when app-group keys are missing.
- On load:
  - If `savedata` is missing/non-data, a fresh board is created.
  - If JSON decode/validation fails, a fresh board is created and persisted to avoid repeated failures.
  - If payload is valid but schema version is older/missing, it is re-persisted with schema version `2`.

## Notes
- Companion sync behavior is unchanged for normal saves (`loadSavedStateNative` wormhole message still sent).
- Internal migration rewrites performed during load do not notify companion to avoid unnecessary traffic.
