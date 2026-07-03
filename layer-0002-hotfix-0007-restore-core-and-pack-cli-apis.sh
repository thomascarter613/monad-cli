#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"
cd "$ROOT"

if [ ! -f "monad.toml" ]; then
  echo "ERROR: monad.toml not found. Run from repo root." >&2
  exit 1
fi

if [ ! -f "crates/monad-core/src/lib.rs" ]; then
  echo "ERROR: crates/monad-core/src/lib.rs not found." >&2
  exit 1
fi

if [ ! -f "crates/monad-packs/src/lib.rs" ]; then
  echo "ERROR: crates/monad-packs/src/lib.rs not found." >&2
  exit 1
fi

cp crates/monad-core/src/lib.rs crates/monad-core/src/lib.rs.bak.layer-0002-hotfix-0007
cp crates/monad-packs/src/lib.rs crates/monad-packs/src/lib.rs.bak.layer-0002-hotfix-0007

python3 - <<'PY'
from pathlib import Path
import re

core = Path("crates/monad-core/src/lib.rs")
text = core.read_text()

insert_after = 'pub const DEFAULT_INIT_PRESET: &str = "governed";'
addition = '''
pub const MANIFEST_SCHEMA_VERSION: &str = "1";
pub const PLAN_SCHEMA_VERSION: &str = "1";
'''

if "MANIFEST_SCHEMA_VERSION" not in text:
    if insert_after not in text:
        raise SystemExit("ERROR: could not find DEFAULT_INIT_PRESET insertion point in monad-core")
    text = text.replace(insert_after, insert_after + "\n" + addition, 1)

core.write_text(text)

packs_cargo = Path("crates/monad-packs/Cargo.toml")
cargo_text = packs_cargo.read_text()

if "[dependencies]" not in cargo_text:
    cargo_text = cargo_text.rstrip() + "\n\n[dependencies]\n"

if not re.search(r"(?m)^\s*serde\s*=", cargo_text):
    cargo_text = cargo_text.rstrip() + '\nserde = { version = "1", features = ["derive"] }\n'

packs_cargo.write_text(cargo_text)
PY

cat > crates/monad-packs/src/lib.rs <<'RS'
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
    pub version: String,
    pub description: String,
    pub capabilities: Vec<String>,
}

impl PackManifest {
    pub fn new(id: impl Into<String>, name: impl Into<String>, version: impl Into<String>) -> Self {
        Self {
            id: PackId::new(id),
            name: name.into(),
            version: version.into(),
            description: String::new(),
            capabilities: Vec::new(),
        }
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
            .with_description("TypeScript, Bun, app, package, and service workspace defaults")
            .with_capability("typescript")
            .with_capability("javascript")
            .with_capability("app")
            .with_capability("package")
            .with_capability("service"),
        PackManifest::new("official.rust", "Official Rust", "0.1.0")
            .with_description("Rust crate and workspace defaults")
            .with_capability("rust")
            .with_capability("crate")
            .with_capability("cli")
            .with_capability("library"),
        PackManifest::new("official.go", "Official Go", "0.1.0")
            .with_description("Go service, module, and tool defaults")
            .with_capability("go")
            .with_capability("service")
            .with_capability("module"),
        PackManifest::new("official.python", "Official Python", "0.1.0")
            .with_description("Python service, package, automation, and AI/RAG defaults")
            .with_capability("python")
            .with_capability("service")
            .with_capability("package")
            .with_capability("ai"),
        PackManifest::new("official.java", "Official Java", "0.1.0")
            .with_description("Java service, library, and enterprise connector defaults")
            .with_capability("java")
            .with_capability("service")
            .with_capability("library")
            .with_capability("connector"),
        PackManifest::new("official.policy", "Official Policy", "0.1.0")
            .with_description("Governance, policy-as-code, waiver, and compliance defaults")
            .with_capability("policy")
            .with_capability("governance")
            .with_capability("compliance"),
        PackManifest::new("official.docs", "Official Docs", "0.1.0")
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
    fn pack_manifest_tracks_capabilities() {
        let pack = PackManifest::new("official.typescript", "Official TypeScript", "0.1.0")
            .with_description("TypeScript defaults")
            .with_capability("app")
            .with_capability("package");

        assert_eq!(pack.id.as_str(), "official.typescript");
        assert_eq!(pack.id.to_string(), "official.typescript");
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
        assert!(packs.iter().any(|pack| pack.provides("workpacket")));
    }
}
RS

cargo fmt --all

echo
echo "Applied layer-0002-hotfix-0007-restore-core-and-pack-cli-apis"
echo
echo "Restored:"
echo "  - monad_core::MANIFEST_SCHEMA_VERSION"
echo "  - monad_core::PLAN_SCHEMA_VERSION"
echo "  - monad_packs::builtin_packs()"
echo "  - serializable built-in pack catalog"
