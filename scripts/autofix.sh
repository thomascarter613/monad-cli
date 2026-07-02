#!/usr/bin/env bash
set -euo pipefail

echo "[autofix] running safe local autofixers"

if command -v cargo >/dev/null 2>&1 && [[ -f Cargo.toml ]]; then
  cargo fmt --all
fi

if command -v bun >/dev/null 2>&1 && [[ -f package.json ]]; then
  bunx biome check --write . || true
  bunx syncpack fix-mismatches || true
fi

echo "[autofix] done"
