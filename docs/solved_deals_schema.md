# Solved Deals Dataset Schema

Issue #6 integrates solved-deal selection through app-group defaults.

## Defaults keys

- `solved_deals`
  - Type: `[[Int]]`
  - Each record: array of 52 unique integers in range `0...51`
  - Meaning: canonical master-deck index order for a new game.

- `solved_deal_selection_mode`
  - Type: `String`
  - Supported values:
    - `random` (default)
    - `round_robin`
    - `fixed`

- `solved_deal_fixed_index`
  - Type: `Int`
  - Used only when mode is `fixed`.

- `solved_deal_round_robin_index`
  - Type: `Int`
  - Internal cursor used when mode is `round_robin`.

- `solved_deal_last_index`
  - Type: `Int`
  - Last selected deal index (observability/debug).

## Fallback behavior

- Invalid records are ignored.
- If no valid records exist, provider uses internal bootstrap deal set.
- If deal application fails unexpectedly, board generation falls back to shuffle path.

## Compatibility notes

- Save/load format remains unchanged.
- Deal provider affects only new-game deck ordering before initial deal.
