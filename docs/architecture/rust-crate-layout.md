# Rust Crate Layout

```txt
crates/
  monad-cli/
  monad-core/
  monad-plans/
  monad-packs/
  monad-policy/
  monad-context/
  monad-graph/
```

## Crate responsibilities

- `monad-cli`: CLI parsing and presentation.
- `monad-core`: workspace model, manifests, config, selectors, errors.
- `monad-plans`: plan, diff, apply, and safe filesystem operations.
- `monad-packs`: built-in packs and templates.
- `monad-policy`: policy checks, findings, and waivers.
- `monad-context`: context packs and handoff generation.
- `monad-graph`: project, dependency, task, and work packet graphs.
