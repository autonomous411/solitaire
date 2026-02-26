# Card Art Pipeline Strategy

This phase keeps gameplay behavior unchanged while removing hard-coded art coupling.

## Resolver behavior

Card and board assets now use deterministic filename resolution with fallback:

1. Try device-agnostic names first (`base.png`, `base_<skin>.png`).
2. Try preferred legacy size family for current device preference (`38mm` or `44mm`).
3. Try the alternate legacy size family.
4. Return deterministic fallback even if assets are missing.

For each legacy family, resolver probes:

- `base_<size><skin>.png`
- `base_<size>.png`
- `base_<size>classic.png`

Skin normalization maps historic value `"1"` to `"classic"`.

## Existing asset strategy

- Reuse current raster assets as-is for this phase.
- Keep legacy skin names compatible.
- Prefer modern unsuffixed names when they are introduced later.

## Migration path

1. Add new resolution-independent asset naming (unsuffixed or tokenized by semantic role, not device size).
2. Keep legacy files during transition.
3. Remove legacy size families only after QA confirms visual parity across watch sizes.

## Validation

- `bash scripts/watch_only_build.sh`
- `bash scripts/watch_only_archive.sh`

Expected in this environment: CoreSimulator runtime-service errors may still block successful completion, but resolver logic and icon metadata changes should compile and remove prior AppIcon warnings.
