#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"
cd "$ROOT"

if [ ! -f "monad.toml" ]; then
  echo "ERROR: monad.toml not found. Run from repo root." >&2
  exit 1
fi

PACKS_TOML="crates/monad-packs/Cargo.toml"

if [ ! -f "$PACKS_TOML" ]; then
  echo "ERROR: $PACKS_TOML not found." >&2
  exit 1
fi

cp "$PACKS_TOML" "$PACKS_TOML.bak.layer-0002-hotfix-0009"

cat > "$PACKS_TOML" <<'TOML'
[package]
name = "monad-packs"
version = "0.1.0"
edition = "2021"
license = "MIT"
publish = false

[lib]
path = "src/lib.rs"

[dependencies]
serde = { version = "1", features = ["derive"] }
TOML

echo
echo "Rewritten $PACKS_TOML:"
cat "$PACKS_TOML"

echo
echo "Checking Cargo metadata..."
cargo metadata --no-deps >/dev/null

echo
echo "Formatting workspace..."
cargo fmt --all

echo
echo "Applied layer-0002-hotfix-0009-rewrite-monad-packs-cargo-toml"
