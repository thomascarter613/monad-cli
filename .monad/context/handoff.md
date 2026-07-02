# Monad Handoff

## Summary

Monad is initialized as a Rust CLI monorepo with canonical docs, schemas, policies, and a complete v1 work packet sequence.

## Next work

1. Review `docs/workpackets/WP-0000-work-packet-specification-and-schema.md`.
2. Validate the repo with `scripts/check.sh`.
3. Begin implementing `WP-0001`.

## Important locked defaults

- Manifest: `monad.toml`
- Lock file: `monad.lock`
- State directory: `.monad/`
- Default scope: `@monad`
- Package manager: `bun`
- Init preset: `governed`
