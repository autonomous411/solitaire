# Watch-Only CLI Path

This repository now includes a shared watch-only scheme:

- `Solitaire Watch Watch-Only`

The scheme builds only watch targets:

- `Solitaire Watch WatchKit App`
- `Solitaire Watch WatchKit Extension`

## Build (unsigned simulator)

```bash
bash scripts/watch_only_build.sh
```

## Archive (default unsigned)

```bash
bash scripts/watch_only_archive.sh
```

For signed archive attempts, set:

```bash
CODE_SIGNING_ALLOWED_VALUE=YES bash scripts/watch_only_archive.sh
```

## Notes

- This path intentionally avoids the iOS host target for faster watch-only iteration.
- Current known warnings/blockers (tracked in issues):
  - Watch storyboard deprecation warning on modern watchOS (migration tracked separately).
  - Watch app icon catalog requires modern App Store icon completeness.
  - Local CoreSimulator stability can affect CLI validation runs independent of project config.
