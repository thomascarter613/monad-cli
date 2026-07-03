#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"
cd "$ROOT"

if [ ! -f "monad.toml" ]; then
  echo "ERROR: monad.toml not found. Run from repo root." >&2
  exit 1
fi

CORE_RS="crates/monad-core/src/lib.rs"
PACKS_RS="crates/monad-packs/src/lib.rs"

if [ ! -f "$CORE_RS" ]; then
  echo "ERROR: $CORE_RS not found." >&2
  exit 1
fi

if [ ! -f "$PACKS_RS" ]; then
  echo "ERROR: $PACKS_RS not found." >&2
  exit 1
fi

cp "$CORE_RS" "$CORE_RS.bak.layer-0002-hotfix-0010"
cp "$PACKS_RS" "$PACKS_RS.bak.layer-0002-hotfix-0010"

python3 - <<'PY'
from pathlib import Path
import re

core_path = Path("crates/monad-core/src/lib.rs")
core = core_path.read_text()

# The CLI's verbose version payload expects u32 schema versions, not strings.
core = re.sub(
    r'pub const MANIFEST_SCHEMA_VERSION:\s*&str\s*=\s*"([0-9]+)";',
    r'pub const MANIFEST_SCHEMA_VERSION: u32 = \1;',
    core,
)
core = re.sub(
    r'pub const PLAN_SCHEMA_VERSION:\s*&str\s*=\s*"([0-9]+)";',
    r'pub const PLAN_SCHEMA_VERSION: u32 = \1;',
    core,
)

if "pub const MANIFEST_SCHEMA_VERSION" not in core:
    insertion = 'pub const DEFAULT_INIT_PRESET: &str = "governed";'
    if insertion not in core:
        raise SystemExit("ERROR: could not find insertion point for MANIFEST_SCHEMA_VERSION")
    core = core.replace(
        insertion,
        insertion + "\npub const MANIFEST_SCHEMA_VERSION: u32 = 1;\npub const PLAN_SCHEMA_VERSION: u32 = 1;",
        1,
    )

if "pub const PLAN_SCHEMA_VERSION" not in core:
    insertion = 'pub const MANIFEST_SCHEMA_VERSION: u32 = 1;'
    if insertion not in core:
        raise SystemExit("ERROR: could not find insertion point for PLAN_SCHEMA_VERSION")
    core = core.replace(insertion, insertion + "\npub const PLAN_SCHEMA_VERSION: u32 = 1;", 1)

core_path.write_text(core)
PY

cat > "$PACKS_RS" <<'RS'
//! Pack primitives for Monad template and capability distribution.
//!
//! At WP-0001, packs are represented as a built-in catalog. Later work packets
//! can move this into installed pack registries, lockfiles, remote indexes, and
//! plugin-backed capability providers.

use serde::Serialize;
use std::fmt;

#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash, Serialize)]
pub struct PackId(String);

impl PackId {
    pub fn new(value: impl Into<String>) -> Self {
        Self(value.into())
    }

    pub fn as_str(&self) -> &str {
        &self.0
    }
}

impl fmt::Display for PackId {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        formatter.write_str(self.as_str())
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
pub struct PackManifest {
    pub id: PackId,
    pub name: String,
    pub kind: String,
    pub version: String,
    pub description: String,
    pub capabilities: Vec<String>,
}

impl PackManifest {
    pub fn new(id: impl Into<String>, name: impl Into<String>, version: impl Into<String>) -> Self {
        Self {
            id: PackId::new(id),
            name: name.into(),
            kind: "official".to_string(),
            version: version.into(),
            description: String::new(),
            capabilities: Vec::new(),
        }
    }

    pub fn with_kind(mut self, kind: impl Into<String>) -> Self {
        self.kind = kind.into();
        self
    }

    pub fn with_description(mut self, description: impl Into<String>) -> Self {
        self.description = description.into();
        self
    }

    pub fn with_capability(mut self, capability: impl Into<String>) -> Self {
        self.capabilities.push(capability.into());
        self
    }

    pub fn provides(&self, capability: &str) -> bool {
        self.capabilities.iter().any(|item| item == capability)
    }
}

/// Return the WP-0001 built-in pack catalog.
///
/// These are not fully implemented generators yet. They are stable catalog
/// entries that let the CLI expose a real pack surface while later work packets
/// attach pack installers, templates, scaffolding engines, and registry sync.
pub fn builtin_packs() -> Vec<PackManifest> {
    vec![
        PackManifest::new("official.typescript", "Official TypeScript", "0.1.0")
            .with_kind("language")
            .with_description("TypeScript, Bun, app, package, and service workspace defaults")
            .with_capability("typescript")
            .with_capability("javascript")
            .with_capability("app")
            .with_capability("package")
            .with_capability("service"),
        PackManifest::new("official.rust", "Official Rust", "0.1.0")
            .with_kind("language")
            .with_description("Rust crate and workspace defaults")
            .with_capability("rust")
            .with_capability("crate")
            .with_capability("cli")
            .with_capability("library"),
        PackManifest::new("official.go", "Official Go", "0.1.0")
            .with_kind("language")
            .with_description("Go service, module, and tool defaults")
            .with_capability("go")
            .with_capability("service")
            .with_capability("module"),
        PackManifest::new("official.python", "Official Python", "0.1.0")
            .with_kind("language")
            .with_description("Python service, package, automation, and AI/RAG defaults")
            .with_capability("python")
            .with_capability("service")
            .with_capability("package")
            .with_capability("ai"),
        PackManifest::new("official.java", "Official Java", "0.1.0")
            .with_kind("language")
            .with_description("Java service, library, and enterprise connector defaults")
            .with_capability("java")
            .with_capability("service")
            .with_capability("library")
            .with_capability("connector"),
        PackManifest::new("official.policy", "Official Policy", "0.1.0")
            .with_kind("governance")
            .with_description("Governance, policy-as-code, waiver, and compliance defaults")
            .with_capability("policy")
            .with_capability("governance")
            .with_capability("compliance"),
        PackManifest::new("official.docs", "Official Docs", "0.1.0")
            .with_kind("governance")
            .with_description("Documentation, ADR, work packet, and handoff defaults")
            .with_capability("docs")
            .with_capability("adr")
            .with_capability("workpacket")
            .with_capability("handoff"),
    ]
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn pack_manifest_tracks_kind_and_capabilities() {
        let pack = PackManifest::new("official.typescript", "Official TypeScript", "0.1.0")
            .with_kind("language")
            .with_description("TypeScript defaults")
            .with_capability("app")
            .with_capability("package");

        assert_eq!(pack.id.as_str(), "official.typescript");
        assert_eq!(pack.id.to_string(), "official.typescript");
        assert_eq!(pack.kind, "language");
        assert!(pack.provides("app"));
        assert!(pack.provides("package"));
        assert!(!pack.provides("database"));
    }

    #[test]
    fn builtin_pack_catalog_contains_wp_0001_baseline_packs() {
        let packs = builtin_packs();
        let ids = packs
            .iter()
            .map(|pack| pack.id.as_str())
            .collect::<Vec<_>>();

        assert!(ids.contains(&"official.typescript"));
        assert!(ids.contains(&"official.rust"));
        assert!(ids.contains(&"official.policy"));
        assert!(packs.iter().any(|pack| pack.kind == "governance"));
        assert!(packs.iter().any(|pack| pack.provides("workpacket")));
    }
}
RS

cargo fmt --all

echo
echo "Applied layer-0002-hotfix-0010-align-core-packs-with-cli-contract"
echo
echo "Aligned:"
echo "  - monad_core::MANIFEST_SCHEMA_VERSION: u32"
echo "  - monad_core::PLAN_SCHEMA_VERSION: u32"
echo "  - monad_packs::PackManifest.kind"
