# AGENTS.md

This repository is designed to be understandable by human contributors and coding-assistant LLMs.

## Required reading order for AI implementers

1. `README.md`
2. `docs/00-index.md`
3. `docs/product/v1-scope.md`
4. `docs/product/v1-command-reference.md`
5. `docs/architecture/cli-doctrine.md`
6. `docs/workpackets/schema.md`
7. `docs/workpackets/index.md`
8. The active work packet file

## Implementation rules

- Follow work packets in sequence and dependency order.
- Do not implement non-goals.
- Do not silently change public command contracts.
- Prefer simple, testable Rust over clever abstractions.
- Every mutating command must eventually route through the plan engine.
- Preserve `default_scope = "@monad"`.
- Markdown work packets are canonical; generated JSON indexes are derived artifacts.
- If a work packet conflicts with an ADR or prior packet, stop and report the conflict.
- Do not fabricate completion evidence.

## Validation before claiming completion

```bash
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
scripts/check.sh
```
