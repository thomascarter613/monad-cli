#!/usr/bin/env bash
set -euo pipefail

required=(
  "README.md"
  "AGENTS.md"
  "docs/00-index.md"
  "docs/product/v1-command-reference.md"
  "docs/workpackets/WP-0000-work-packet-specification-and-schema.md"
  "docs/workpackets/schema.md"
  "schemas/workpacket.schema.json"
)

for path in "${required[@]}"; do
  test -f "$path" || {
    echo "Missing required documentation: $path" >&2
    exit 1
  }
done

python -m json.tool schemas/workpacket.schema.json >/dev/null
python -m json.tool schemas/epic.schema.json >/dev/null
python -m json.tool schemas/sprint.schema.json >/dev/null
