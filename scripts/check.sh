#!/usr/bin/env bash
set -euo pipefail

echo "[check] monad repository checks"

if command -v cargo >/dev/null 2>&1; then
  cargo fmt --all --check
  cargo check --workspace
  cargo test --workspace
else
  echo "[check] cargo is required for layer-0002 and later" >&2
  exit 1
fi

if [[ -x scripts/drift-check.sh ]]; then
  scripts/drift-check.sh
fi

if [[ -x scripts/graph-integrity.sh ]]; then
  scripts/graph-integrity.sh
fi

echo "[check] ok"
