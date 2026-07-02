#!/usr/bin/env bash
set -euo pipefail

echo "[graph] checking graph invariant inputs"

required_files=(
  "governance/graph-invariants.toml"
  "governance/boundaries.toml"
  "domains/domain-map.toml"
  "docs/workpackets/index.md"
)

for file in "${required_files[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "[graph] missing required file: $file" >&2
    exit 1
  fi
done

if command -v monad >/dev/null 2>&1; then
  monad graph projects --format json >/tmp/monad-project-graph.json || true
  monad graph deps --format json >/tmp/monad-dependency-graph.json || true
  monad graph tasks --format json >/tmp/monad-task-graph.json || true
fi

echo "[graph] ok"
