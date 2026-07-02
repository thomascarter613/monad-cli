# Debugging Runbook

## First Checks

```bash
git status --short
cargo check --workspace
cargo test --workspace
scripts/drift-check.sh
```

## CLI Help Surface

```bash
cargo run -p monad-cli -- --help
cargo run -p monad-cli -- version --verbose
```

## Common Failure Classes

| Symptom | Likely Cause | First Action |
|---|---|---|
| Workspace not found | Missing `monad.toml` | Run from repo root |
| Generated docs stale | Context/doc drift | Run docs/context generation |
| Policy failures | Missing file or expired waiver | Inspect finding and waiver |
| Native tool failure | Missing Bun/Turbo/Moon/Biome | Run doctor/check scripts |

## Rule

Do not fix by deleting generated state blindly. Prefer plan, diff, apply.
