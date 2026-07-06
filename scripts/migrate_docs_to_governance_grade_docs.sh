#!/usr/bin/env bash
set -euo pipefail

DOCS="docs"

echo "== Starting governance-grade docs migration =="

# --- 1. Create all governance-grade directories ---
mkdir -p $DOCS/{docs-governance,epistemics,verification,validation,evolution,interoperability,infra-governance,ergonomics,safety,toolchain,artifacts,roles/philosophy,meta,data}

# --- 2. Fix compliance directory typo ---
if [ -d "$DOCS/governance/compliaance" ]; then
  mkdir -p "$DOCS/governance/compliance"
  mv "$DOCS/governance/compliaance/"* "$DOCS/governance/compliance/" || true
  rmdir "$DOCS/governance/compliaance" || true
fi

# --- 3. Move drift detection + licenses into docs-governance ---
for f in drift-detection.md open-source-licenses.md README.md; do
  if [ -f "$DOCS/governance/$f" ]; then
    mv "$DOCS/governance/$f" "$DOCS/docs-governance/$f"
  fi
done

# --- 4. Move risk register into safety ---
if [ -f "$DOCS/governance/risk-register.md" ]; then
  mv "$DOCS/governance/risk-register.md" "$DOCS/safety/risk-register.md"
fi

# --- 5. Move release evidence into artifacts ---
if [ -f "$DOCS/reference/release-evidence.md" ]; then
  mv "$DOCS/reference/release-evidence.md" "$DOCS/artifacts/release-evidence.md"
fi

# --- 6. Define all governance-grade expected files ---
declare -A EXPECTED

# docs-governance
EXPECTED["docs-governance"]="drift-detection.md documentation-invariants.md documentation-governance.md documentation-audit.md style-guide.md index.md"

# epistemics
EXPECTED["epistemics"]="meaning-preservation.md institutional-interpretation.md ambiguity-elimination.md semantic-stability.md index.md"

# verification
EXPECTED["verification"]="formal-methods.md correctness-proofs.md invariant-checkers.md governance-verification.md index.md"

# validation
EXPECTED["validation"]="institutional-validation.md domain-validation.md cross-domain-validation.md index.md"

# evolution
EXPECTED["evolution"]="architectural-evolution.md domain-evolution.md rule-evolution.md evolution-constraints.md anti-drift-mechanisms.md index.md"

# interoperability
EXPECTED["interoperability"]="cross-system-contracts.md federation-governance.md interoperability-invariants.md external-governance.md index.md"

# infra-governance
EXPECTED["infra-governance"]="infra-invariants.md provisioning-governance.md environment-contracts.md infra-drift-detection.md index.md"

# ergonomics
EXPECTED["ergonomics"]="cognitive-load-map.md steward-ergonomics.md complexity-controls.md safe-onboarding.md index.md"

# safety
EXPECTED["safety"]="harm-model.md institutional-safety.md governance-safety.md safety-invariants.md index.md"

# toolchain
EXPECTED["toolchain"]="toolchain-governance.md compiler-governance.md generator-governance.md ai-assistance-governance.md index.md"

# artifacts
EXPECTED["artifacts"]="artifact-lifecycle.md artifact-provenance-ledger.md artifact-governance.md artifact-audit.md release-evidence.md index.md"

# roles
EXPECTED["roles"]="role-charters.md authority-boundaries.md stewardship-contracts.md index.md"

# philosophy
EXPECTED["philosophy"]="system-philosophy.md design-rationale.md governance-rationale.md invariants-rationale.md stewardship-philosophy.md index.md"

# meta
EXPECTED["meta"]="glossary.md taxonomy.md definitions.md institutional-terms.md index.md"

# data
EXPECTED["data"]="canonical-schema.json archival-schema.json forensic-schema.json migration-governance.md migration-history.md migration-replay.md retention-policy.md archival-process.md index.md"

# --- 7. Create placeholder files for missing ones ---
for dir in "${!EXPECTED[@]}"; do
  mkdir -p "$DOCS/$dir"
  for file in ${EXPECTED[$dir]}; do
    TARGET="$DOCS/$dir/$file"
    if [ ! -f "$TARGET" ]; then
      echo "# $file" > "$TARGET"
      echo "Placeholder for governance-grade documentation." >> "$TARGET"
      echo "Created placeholder: $TARGET"
    fi
  done
done

echo "== Migration complete. All missing governance-grade files created. No content lost. =="
