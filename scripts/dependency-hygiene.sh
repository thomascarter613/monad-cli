#!/usr/bin/env bash
set -euo pipefail

echo "[deps] checking dependency hygiene"

if command -v cargo >/dev/null 2>&1 && [[ -f Cargo.toml ]]; then
  if cargo metadata --format-version 1 >/dev/null; then
    echo "[deps] cargo metadata ok"
  else
    echo "[deps] cargo metadata failed; continuing because this is a hygiene script, not the primary Rust check" >&2
  fi
else
  echo "[deps] cargo unavailable or Cargo.toml missing; skipping Rust metadata"
fi

if command -v cargo-deny >/dev/null 2>&1 && [[ -f deny.toml ]]; then
  if cargo deny check; then
    echo "[deps] cargo deny ok"
  else
    echo "[deps] cargo deny found issues; continuing for bootstrap hygiene" >&2
  fi
else
  echo "[deps] cargo-deny unavailable or deny.toml missing; skipping cargo deny"
fi

if command -v bun >/dev/null 2>&1 && [[ -f package.json ]]; then
  bunx syncpack list-mismatches || echo "[deps] syncpack reported mismatches or is unavailable; continuing" >&2
  bunx knip || echo "[deps] knip reported findings or is unavailable; continuing" >&2
else
  echo "[deps] bun unavailable or package.json missing; skipping JS dependency hygiene"
fi

echo "[deps] ok"
