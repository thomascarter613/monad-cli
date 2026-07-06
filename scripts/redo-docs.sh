#!/usr/bin/env bash
set -euo pipefail

# Base docs dir
DOCS_DIR="docs"

echo "== Governance-grade docs migration (lossless) =="

# 1. Create new governance-grade directories
mkdir -p "$DOCS_DIR/docs-governance"
mkdir -p "$DOCS_DIR/epistemics"
mkdir -p "$DOCS_DIR/verification"
mkdir -p "$DOCS_DIR/validation"
mkdir -p "$DOCS_DIR/evolution"
mkdir -p "$DOCS_DIR/interoperability"
mkdir -p "$DOCS_DIR/infra-governance"
mkdir -p "$DOCS_DIR/ergonomics"
mkdir -p "$DOCS_DIR/safety"
mkdir -p "$DOCS_DIR/toolchain"
mkdir -p "$DOCS_DIR/artifacts"
mkdir -p "$DOCS_DIR/roles"
mkdir -p "$DOCS_DIR/philosophy"
mkdir -p "$DOCS_DIR/meta"

echo "Created governance-grade top-level directories."

# 2. Map a few obvious files into new layers (lossless, conservative)

# Docs governance: drift detection, licenses, README
if [ -f "$DOCS_DIR/governance/drift-detection.md" ]; then
  mv "$DOCS_DIR/governance/drift-detection.md" "$DOCS_DIR/docs-governance/drift-detection.md"
  echo "Moved governance/drift-detection.md -> docs-governance/drift-detection.md"
fi

if [ -f "$DOCS_DIR/governance/open-source-licenses.md" ]; then
  mv "$DOCS_DIR/governance/open-source-licenses.md" "$DOCS_DIR/docs-governance/open-source-licenses.md"
  echo "Moved governance/open-source-licenses.md -> docs-governance/open-source-licenses.md"
fi

if [ -f "$DOCS_DIR/governance/README.md" ]; then
  mv "$DOCS_DIR/governance/README.md" "$DOCS_DIR/docs-governance/README.md"
  echo "Moved governance/README.md -> docs-governance/README.md"
fi

# Safety: risk register
if [ -f "$DOCS_DIR/governance/risk-register.md" ]; then
  mv "$DOCS_DIR/governance/risk-register.md" "$DOCS_DIR/safety/risk-register.md"
  echo "Moved governance/risk-register.md -> safety/risk-register.md"
fi

# Compliance: keep existing structure but ensure directory name is correct
if [ -d "$DOCS_DIR/governance/compliaance" ]; then
  mkdir -p "$DOCS_DIR/governance/compliance"
  mv "$DOCS_DIR/governance/compliaance/"* "$DOCS_DIR/governance/compliance/" || true
  rmdir "$DOCS_DIR/governance/compliaance" || true
  echo "Renamed governance/compliaance -> governance/compliance"
fi

# Artifacts: release evidence
if [ -f "$DOCS_DIR/reference/release-evidence.md" ]; then
  mv "$DOCS_DIR/reference/release-evidence.md" "$DOCS_DIR/artifacts/release-evidence.md"
  echo "Moved reference/release-evidence.md -> artifacts/release-evidence.md"
fi

# Interfaces: keep existing, but ensure subdirs exist
mkdir -p "$DOCS_DIR/interfaces/api-specs"
mkdir -p "$DOCS_DIR/interfaces/schemas"

# 3. Leave planning, roadmap, product-and-domain, architecture, operations, development, testing, reference as-is
echo "Planning, roadmap, product-and-domain, architecture, operations, development, testing, reference left in place."

# 4. Create placeholder index files for new dirs (optional, non-destructive)
for d in docs-governance epistemics verification validation evolution interoperability infra-governance ergonomics safety toolchain artifacts roles philosophy meta; do
  IDX="$DOCS_DIR/$d/index.md"
  if [ ! -f "$IDX" ]; then
    cat > "$IDX" <<EOF
# $d

This is a placeholder index for the $d governance-grade documentation layer.
Content will be populated incrementally; existing documentation has not been deleted or modified.
EOF
    echo "Created placeholder $IDX"
  fi
done

echo "== Migration complete (no content deleted). =="
