#!/usr/bin/env bash
set -euo pipefail

echo "[drift] checking required governance surfaces"

required_files=(
  "monad.toml"
  "workspace.toml"
  ".monorepo.json"
  "docs.json"
  "engines.registry.json"
  "governance/engines.toml"
  "governance/boundaries.toml"
  "governance/graph-invariants.toml"
  "governance/lifecycle.toml"
  "governance/policies.toml"
  "automation/drift/drift-rules.toml"
  "environments/dev.toml"
  "environments/stage.toml"
  "environments/prod.toml"
)

for file in "${required_files[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "[drift] missing required file: $file" >&2
    exit 1
  fi
done

if command -v python >/dev/null 2>&1; then
  python - <<'PY'
import json
from pathlib import Path

for path in [".monorepo.json", "docs.json", "engines.registry.json"]:
    with open(path, "r", encoding="utf-8") as f:
        json.load(f)

mirror = json.loads(Path(".monorepo.json").read_text(encoding="utf-8"))
if mirror.get("canonicalManifest") != "monad.toml":
    raise SystemExit(".monorepo.json must declare monad.toml as canonicalManifest")

workspace_toml = Path("workspace.toml").read_text(encoding="utf-8")
if "monad.toml is the canonical Monad workspace manifest" not in workspace_toml:
    raise SystemExit("workspace.toml must be marked as a generated compatibility mirror")
PY
fi

echo "[drift] ok"
