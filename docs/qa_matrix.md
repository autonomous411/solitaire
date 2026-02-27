# Watch QA Matrix and Regression Checklist (Phase 8)

## Goals
- Validate gameplay correctness after modernization phases.
- Validate layout/art fidelity across modern watch sizes.
- Validate persistence + solved-deal behavior across relaunch and upgrade paths.

## Environment capture (per session)
- Date/time
- Tester
- Xcode version
- watchOS version
- Device model / screen class
- Build SHA
- Build lane used (`watch_only_build.sh`, `watch_only_archive.sh`, device run)

## Device matrix
| Lane | Device | Screen class | watchOS | Status | Notes |
| --- | --- | --- | --- | --- | --- |
| A | Apple Watch SE (2nd gen) | 40mm | latest supported | Pending | Baseline small-size touch target/layout |
| B | Apple Watch Series 9 | 45mm | latest supported | Pending | Mainline regression |
| C | Apple Watch Series 7/8/9 | 41mm | latest supported | Pending | Mid-size layout and spacing |
| D | Apple Watch Ultra/Ultra 2 | 49mm | latest supported | Pending | Largest-size art sharpness and spacing |
| E | Legacy upgrade lane | Any existing install device | existing -> latest | Pending | Upgrade persistence + migration |

## Core regression scenarios
### 1. Board initialization / deal
- [ ] New board deals correctly: 1..7 tableau stacks, top card face-up, stock count expected.
- [ ] `redeal` resets board and state cleanly.
- [ ] No duplicate/missing cards after initial deal.

### 2. Move logic parity (Issue #5)
- [ ] Valid tableau-to-tableau moves accepted.
- [ ] Invalid moves rejected.
- [ ] Foundation moves obey suit and ascending rules.
- [ ] King-to-empty-tableau behavior correct.

### 3. Deck/flip behavior (1-card and 3-card)
- [ ] Toggle 1-card mode persists and applies.
- [ ] Toggle 3-card mode persists and applies.
- [ ] Stock/waste cycling behavior correct when stock empties.

### 4. Solved-deal behavior (Issue #6)
- [ ] `fixed` mode repeats same deal index.
- [ ] `round_robin` mode advances deterministically.
- [ ] Invalid `solved_deals` payload triggers safe fallback.
- [ ] `solved_deal_last_index` updates as expected.

### 5. Save/load and migration (Issue #7)
- [ ] Relaunch restores board state exactly.
- [ ] Upgrade from pre-migration install retains playable state/settings.
- [ ] Corrupt save payload recovery avoids crash loop and rebuilds board.
- [ ] `savedata_schema_version` set to `2` after migration rewrite.
- [ ] `flipcardnumber` preserved on upgrade/relaunch.

### 6. Responsive layout and card art (Issues #3/#4)
- [ ] Tableau spacing and overlap remain legible on all sizes.
- [ ] Deck/discard rows aligned; no clipping.
- [ ] Card face/back assets are sharp and proportionate.
- [ ] Touch targets remain reliable (deck/discard/tableau).

### 7. Performance and stability
- [ ] Cold launch time acceptable.
- [ ] No UI hangs during rapid move/redeal loops.
- [ ] Memory pressure or crash symptoms not observed.

## Command-line validation lanes
- `bash scripts/watch_only_build.sh`
- `bash scripts/watch_only_archive.sh`

Record artifacts:
- command output summary
- failure step/stage
- associated screenshots/logs

## Known blockers to track during QA
- Codex sandbox/CoreSimulator instability (`supportedRuntimes=[]`, `simdiskimaged` connection errors).
- Asset catalog compile failure at `CompileAssetCatalogVariant` in current environment.

If blockers persist on stable local hosts, open linked defects and mark release impact severity.
