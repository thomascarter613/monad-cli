#!/usr/bin/env bash
set -euo pipefail

mkdir -p .monad/sbom

echo "[sbom] generating SBOM when supported tools are available"

if command -v syft >/dev/null 2>&1; then
  syft dir:. -o cyclonedx-json > .monad/sbom/syft.cyclonedx.json
  echo "[sbom] wrote .monad/sbom/syft.cyclonedx.json"
elif command -v cyclonedx-bom >/dev/null 2>&1; then
  cyclonedx-bom -o .monad/sbom/cyclonedx.json
  echo "[sbom] wrote .monad/sbom/cyclonedx.json"
else
  cat > .monad/sbom/README.md <<'SBOM'
# SBOM Placeholder

Install Syft or CycloneDX tooling to generate a full SBOM.

Recommended:

```bash
syft dir:. -o cyclonedx-json > .monad/sbom/syft.cyclonedx.json
```
SBOM
  echo "[sbom] no SBOM tool found; wrote placeholder"
fi
