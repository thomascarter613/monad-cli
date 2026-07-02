# Contributing

Monad is currently pre-v1. All work should be driven by work packets under `docs/workpackets/`.

## Contribution flow

1. Read the relevant work packet.
2. Confirm scope and non-goals.
3. Implement tasks in order.
4. Run validation commands from the packet.
5. Update completion evidence only with real results.
6. Open a PR with the work packet ID in the title.

## Quality expectations

- Rust code is formatted with `cargo fmt`.
- Rust code passes `cargo clippy --workspace --all-targets -- -D warnings`.
- Tests pass with `cargo test --workspace`.
- Docs are updated when behavior changes.
