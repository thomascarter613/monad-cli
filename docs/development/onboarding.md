# Onboarding and Doctor Contract

## Goal

A new developer or coding assistant should be able to enter the repo, understand the system, run checks, and find the next work packet.

## First Commands

```bash
git status --short
scripts/check.sh
scripts/graph-integrity.sh
scripts/drift-check.sh
```

## Required Reading

1. `README.md`
2. `AGENTS.md`
3. `docs/product/v1-scope.md`
4. `docs/workpackets/schema.md`
5. `docs/workpackets/index.md`
6. `governance/policies.toml`
7. `governance/boundaries.toml`

## Doctor Contract

`monad doctor` should eventually verify:

- Rust/Cargo availability.
- Bun availability.
- Git availability.
- Workspace root discovery.
- Manifest validity.
- Engine registry validity.
- Policy pack existence.
- Graph invariant files.
- Work packet index validity.
- Local infra availability when requested.
