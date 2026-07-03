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

cp "$PACKS_TOML" "$PACKS_TOML.bak.layer-0002-hotfix-0008"

python3 - <<'PY'
from pathlib import Path

path = Path("crates/monad-packs/Cargo.toml")
lines = path.read_text().splitlines()

serde_line = 'serde = { version = "1", features = ["derive"] }'
out = []
seen_serde = False

for line in lines:
    stripped = line.strip()

    if stripped.startswith("serde ="):
        if not seen_serde:
            out.append(serde_line)
            seen_serde = True
        continue

    out.append(line)

if not seen_serde:
    # Add serde under [dependencies], or create [dependencies] if missing.
    if any(line.strip() == "[dependencies]" for line in out):
        final = []
        inserted = False
        for index, line in enumerate(out):
            final.append(line)
            if line.strip() == "[dependencies]" and not inserted:
                final.append(serde_line)
                inserted = True
        out = final
    else:
        if out and out[-1].strip():
            out.append("")
        out.append("[dependencies]")
        out.append(serde_line)

path.write_text("\n".join(out).rstrip() + "\n")
PY

echo
echo "After cleanup:"
grep -n '^serde[[:space:]]*=' "$PACKS_TOML" || true

cargo metadata --no-deps >/dev/null
cargo fmt --all

echo
echo "Applied layer-0002-hotfix-0008-dedupe-monad-packs-serde"
