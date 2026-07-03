#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"
cd "$ROOT"

CORE_RS="crates/monad-core/src/lib.rs"

if [ ! -f "monad.toml" ]; then
  echo "ERROR: monad.toml not found. Run from repo root." >&2
  exit 1
fi

if [ ! -f "$CORE_RS" ]; then
  echo "ERROR: $CORE_RS not found." >&2
  exit 1
fi

if [ ! -f "crates/monad-core/src/command_catalog.rs" ]; then
  echo "ERROR: crates/monad-core/src/command_catalog.rs not found. Re-run layer-0002-hotfix-0011 first if needed." >&2
  exit 1
fi

cp "$CORE_RS" "$CORE_RS.bak.layer-0002-hotfix-0012"

python3 - <<'PY'
from pathlib import Path

path = Path("crates/monad-core/src/lib.rs")
lines = path.read_text().splitlines()

# Remove existing command_catalog module declarations wherever the failed
# previous script placed them.
lines = [line for line in lines if line.strip() != "pub mod command_catalog;"]

# Preserve crate-level inner docs at the top. Inner docs must come before any
# item, including `pub mod`.
insert_at = 0
while insert_at < len(lines):
    stripped = lines[insert_at].strip()
    if stripped.startswith("//!") or stripped == "":
        insert_at += 1
        continue
    break

lines.insert(insert_at, "pub mod command_catalog;")
lines.insert(insert_at + 1, "")

path.write_text("\n".join(lines).rstrip() + "\n")
PY

cargo fmt --all

echo
echo "Applied layer-0002-hotfix-0012-fix-monad-core-inner-doc-order"
