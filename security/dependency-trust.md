# Dependency Trust Rules

## Registry Rules

Allowed registries are declared in `compliance/licenses.toml`.

## Dependency Addition Rules

New dependencies should have:

- Clear purpose.
- Active maintenance or acceptable stability.
- Compatible license.
- No known critical unresolved vulnerability.
- Minimal transitive risk.
- Work packet or task justification when nontrivial.

## Rust

- Prefer well-maintained crates.
- Use `cargo deny` where available.
- Keep features minimal.

## JavaScript/TypeScript

- Prefer packages with active maintenance.
- Use lockfiles.
- Use Syncpack for version consistency.
- Use Knip for unused dependency detection.

## Docker

- Avoid `latest`.
- Prefer pinned image tags.
- Prefer official or trusted images.
