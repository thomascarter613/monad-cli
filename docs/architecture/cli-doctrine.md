# CLI Doctrine

Monad is a Rust CLI for serious monorepo management.

## Core doctrine

```txt
Commands that inspect should not mutate.
Commands that mutate should support --dry-run.
Commands that produce changes should be plannable.
Commands that apply plans should be auditable.
Commands used in CI should support machine-readable output.
```

## Mutation doctrine

- Mutating commands produce plans.
- Plans can be diffed.
- Plans can be applied.
- Dry runs write nothing.
- Conflicts are reported before writes.
- User-modified files are not silently overwritten.

## Tooling doctrine

```txt
Monad owns intent.
Native tools own execution.
Monad coordinates, validates, and documents.
```
