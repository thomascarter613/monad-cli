# Monad

Monad is a Rust monorepo initializer, modifier, evolver, manager, and governance CLI.

Monad's v1 goal is to safely initialize, understand, modify, validate, document,
graph, govern, and hand off serious monorepos using a stable Rust CLI.

## Locked v1 defaults

```txt
canonical_manifest = "monad.toml"
canonical_lockfile = "monad.lock"
state_directory = ".monad/"
default_package_manager = "bun"
default_scope = "@monad"
default_init_preset = "governed"
```

## v1 doctrine

```txt
Commands that inspect should not mutate.
Commands that mutate should support --dry-run.
Commands that produce changes should be plannable.
Commands that apply plans should be auditable.
Commands used in CI should support machine-readable output.
```

## Work packet standard

Monad work packets are first-class repo artifacts and repo-native implementation contracts.
They are human-readable, machine-readable, LLM-ingestible, serializable, ordered, testable,
validatable, relationship-aware, and explicit about scope, non-goals, outcomes, and completion evidence.

Start here:

- `docs/workpackets/WP-0000-work-packet-specification-and-schema.md`
- `docs/workpackets/schema.md`
- `docs/product/v1-command-reference.md`
- `docs/product/v1-scope.md`

## Local validation

```bash
scripts/check.sh
```
