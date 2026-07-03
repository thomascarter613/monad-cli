#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"
cd "$ROOT"

if [ ! -f "monad.toml" ]; then
  echo "ERROR: monad.toml not found. Run from repo root." >&2
  exit 1
fi

if [ ! -f "Cargo.toml" ]; then
  echo "ERROR: Cargo.toml not found." >&2
  exit 1
fi

for crate in monad-core monad-plans monad-packs monad-policy monad-context monad-graph; do
  if [ ! -d "crates/$crate" ]; then
    echo "ERROR: crates/$crate not found." >&2
    exit 1
  fi

  mkdir -p "crates/$crate/src"

  if [ -f "crates/$crate/src/lib.rs" ]; then
    cp "crates/$crate/src/lib.rs" "crates/$crate/src/lib.rs.bak.layer-0002-hotfix-0006"
  fi
done

cat > crates/monad-core/src/lib.rs <<'RS'
//! Core domain primitives for the Monad monorepo operating-system runtime.
//!
//! WP-0001 keeps this crate intentionally small: stable constants and value
//! types that other Monad crates can depend on without pulling in CLI concerns.

pub const CLI_NAME: &str = "monad";
pub const CANONICAL_MANIFEST: &str = "monad.toml";
pub const COMPATIBILITY_MANIFEST: &str = "workspace.toml";
pub const LOCKFILE: &str = "monad.lock";
pub const STATE_DIR: &str = ".monad";
pub const DEFAULT_PACKAGE_MANAGER: &str = "bun";
pub const DEFAULT_SCOPE: &str = "@monad";
pub const DEFAULT_INIT_PRESET: &str = "governed";

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct RuntimeDefaults {
    pub cli_name: &'static str,
    pub canonical_manifest: &'static str,
    pub compatibility_manifest: &'static str,
    pub lockfile: &'static str,
    pub state_dir: &'static str,
    pub package_manager: &'static str,
    pub scope: &'static str,
    pub init_preset: &'static str,
}

impl RuntimeDefaults {
    pub const fn monad() -> Self {
        Self {
            cli_name: CLI_NAME,
            canonical_manifest: CANONICAL_MANIFEST,
            compatibility_manifest: COMPATIBILITY_MANIFEST,
            lockfile: LOCKFILE,
            state_dir: STATE_DIR,
            package_manager: DEFAULT_PACKAGE_MANAGER,
            scope: DEFAULT_SCOPE,
            init_preset: DEFAULT_INIT_PRESET,
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct WorkspaceIdentity {
    pub name: String,
    pub scope: String,
}

impl WorkspaceIdentity {
    pub fn new(name: impl Into<String>, scope: impl Into<String>) -> Self {
        Self {
            name: name.into(),
            scope: scope.into(),
        }
    }

    pub fn default_for(name: impl Into<String>) -> Self {
        Self::new(name, DEFAULT_SCOPE)
    }

    pub fn scoped_package_name(&self, package_name: &str) -> String {
        format!("{}/{}", self.scope, package_name)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn monad_defaults_match_approved_wp_0001_defaults() {
        let defaults = RuntimeDefaults::monad();

        assert_eq!(defaults.cli_name, "monad");
        assert_eq!(defaults.canonical_manifest, "monad.toml");
        assert_eq!(defaults.compatibility_manifest, "workspace.toml");
        assert_eq!(defaults.lockfile, "monad.lock");
        assert_eq!(defaults.state_dir, ".monad");
        assert_eq!(defaults.package_manager, "bun");
        assert_eq!(defaults.scope, "@monad");
        assert_eq!(defaults.init_preset, "governed");
    }

    #[test]
    fn workspace_identity_formats_scoped_packages() {
        let identity = WorkspaceIdentity::default_for("example");
        assert_eq!(identity.scoped_package_name("web"), "@monad/web");
    }
}
RS

cat > crates/monad-plans/src/lib.rs <<'RS'
//! Plan primitives for mutating Monad operations.
//!
//! Monad mutating commands are expected to become plan-backed. At WP-0001 this
//! crate provides the minimal stable data model for representing a plan.

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PlanMode {
    DryRun,
    Apply,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum PlanStepKind {
    CreateFile,
    UpdateFile,
    DeleteFile,
    CreateDirectory,
    RunCommand,
    Validate,
    Other(String),
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PlanStep {
    pub kind: PlanStepKind,
    pub summary: String,
}

impl PlanStep {
    pub fn new(kind: PlanStepKind, summary: impl Into<String>) -> Self {
        Self {
            kind,
            summary: summary.into(),
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ChangePlan {
    pub operation: String,
    pub mode: PlanMode,
    pub steps: Vec<PlanStep>,
}

impl ChangePlan {
    pub fn dry_run(operation: impl Into<String>) -> Self {
        Self {
            operation: operation.into(),
            mode: PlanMode::DryRun,
            steps: Vec::new(),
        }
    }

    pub fn apply(operation: impl Into<String>) -> Self {
        Self {
            operation: operation.into(),
            mode: PlanMode::Apply,
            steps: Vec::new(),
        }
    }

    pub fn push_step(&mut self, step: PlanStep) {
        self.steps.push(step);
    }

    pub fn is_empty(&self) -> bool {
        self.steps.is_empty()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn dry_run_plan_starts_empty_and_accepts_steps() {
        let mut plan = ChangePlan::dry_run("add app web");
        assert_eq!(plan.mode, PlanMode::DryRun);
        assert!(plan.is_empty());

        plan.push_step(PlanStep::new(
            PlanStepKind::CreateDirectory,
            "create apps/web",
        ));

        assert!(!plan.is_empty());
        assert_eq!(plan.steps.len(), 1);
    }
}
RS

cat > crates/monad-packs/src/lib.rs <<'RS'
//! Pack primitives for Monad template and capability distribution.

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PackId(String);

impl PackId {
    pub fn new(value: impl Into<String>) -> Self {
        Self(value.into())
    }

    pub fn as_str(&self) -> &str {
        &self.0
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PackManifest {
    pub id: PackId,
    pub name: String,
    pub version: String,
    pub capabilities: Vec<String>,
}

impl PackManifest {
    pub fn new(id: impl Into<String>, name: impl Into<String>, version: impl Into<String>) -> Self {
        Self {
            id: PackId::new(id),
            name: name.into(),
            version: version.into(),
            capabilities: Vec::new(),
        }
    }

    pub fn with_capability(mut self, capability: impl Into<String>) -> Self {
        self.capabilities.push(capability.into());
        self
    }

    pub fn provides(&self, capability: &str) -> bool {
        self.capabilities.iter().any(|item| item == capability)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn pack_manifest_tracks_capabilities() {
        let pack = PackManifest::new("official.typescript", "Official TypeScript", "0.1.0")
            .with_capability("app")
            .with_capability("package");

        assert_eq!(pack.id.as_str(), "official.typescript");
        assert!(pack.provides("app"));
        assert!(pack.provides("package"));
        assert!(!pack.provides("database"));
    }
}
RS

cat > crates/monad-policy/src/lib.rs <<'RS'
//! Policy primitives for Monad governance checks.

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub enum Severity {
    Info,
    Warning,
    Error,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PolicyFinding {
    pub code: String,
    pub severity: Severity,
    pub message: String,
}

impl PolicyFinding {
    pub fn new(
        code: impl Into<String>,
        severity: Severity,
        message: impl Into<String>,
    ) -> Self {
        Self {
            code: code.into(),
            severity,
            message: message.into(),
        }
    }

    pub fn is_blocking(&self) -> bool {
        self.severity == Severity::Error
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Default)]
pub struct PolicyCheckResult {
    pub findings: Vec<PolicyFinding>,
}

impl PolicyCheckResult {
    pub fn push(&mut self, finding: PolicyFinding) {
        self.findings.push(finding);
    }

    pub fn has_blocking_findings(&self) -> bool {
        self.findings.iter().any(PolicyFinding::is_blocking)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn errors_are_blocking_policy_findings() {
        let mut result = PolicyCheckResult::default();
        assert!(!result.has_blocking_findings());

        result.push(PolicyFinding::new(
            "MONAD_POLICY_TEST",
            Severity::Error,
            "test finding",
        ));

        assert!(result.has_blocking_findings());
    }
}
RS

cat > crates/monad-context/src/lib.rs <<'RS'
//! Context and handoff primitives for Monad.
//!
//! Monad is AI-ready but AI-optional. This crate owns neutral context packaging
//! concepts that can be used by humans, scripts, and AI tools.

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ContextFile {
    pub path: String,
    pub purpose: String,
}

impl ContextFile {
    pub fn new(path: impl Into<String>, purpose: impl Into<String>) -> Self {
        Self {
            path: path.into(),
            purpose: purpose.into(),
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ContextPack {
    pub title: String,
    pub files: Vec<ContextFile>,
}

impl ContextPack {
    pub fn new(title: impl Into<String>) -> Self {
        Self {
            title: title.into(),
            files: Vec::new(),
        }
    }

    pub fn include_file(mut self, file: ContextFile) -> Self {
        self.files.push(file);
        self
    }

    pub fn file_count(&self) -> usize {
        self.files.len()
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct HandoffSummary {
    pub current_workpacket: String,
    pub summary: String,
    pub next_actions: Vec<String>,
}

impl HandoffSummary {
    pub fn new(current_workpacket: impl Into<String>, summary: impl Into<String>) -> Self {
        Self {
            current_workpacket: current_workpacket.into(),
            summary: summary.into(),
            next_actions: Vec::new(),
        }
    }

    pub fn with_next_action(mut self, action: impl Into<String>) -> Self {
        self.next_actions.push(action.into());
        self
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn context_pack_counts_included_files() {
        let pack = ContextPack::new("WP-0001")
            .include_file(ContextFile::new("monad.toml", "canonical manifest"))
            .include_file(ContextFile::new("Cargo.toml", "workspace manifest"));

        assert_eq!(pack.file_count(), 2);
    }

    #[test]
    fn handoff_summary_tracks_next_actions() {
        let handoff = HandoffSummary::new("WP-0001", "CLI skeleton")
            .with_next_action("run cargo test --workspace");

        assert_eq!(handoff.current_workpacket, "WP-0001");
        assert_eq!(handoff.next_actions.len(), 1);
    }
}
RS

cat > crates/monad-graph/src/lib.rs <<'RS'
//! Graph primitives for Monad workspace introspection.

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum GraphFormat {
    Text,
    Json,
    Mermaid,
    Dot,
    Svg,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct GraphNode {
    pub id: String,
    pub kind: String,
}

impl GraphNode {
    pub fn new(id: impl Into<String>, kind: impl Into<String>) -> Self {
        Self {
            id: id.into(),
            kind: kind.into(),
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct GraphEdge {
    pub from: String,
    pub to: String,
    pub kind: String,
}

impl GraphEdge {
    pub fn new(from: impl Into<String>, to: impl Into<String>, kind: impl Into<String>) -> Self {
        Self {
            from: from.into(),
            to: to.into(),
            kind: kind.into(),
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Default)]
pub struct WorkspaceGraph {
    pub nodes: Vec<GraphNode>,
    pub edges: Vec<GraphEdge>,
}

impl WorkspaceGraph {
    pub fn add_node(&mut self, node: GraphNode) {
        self.nodes.push(node);
    }

    pub fn add_edge(&mut self, edge: GraphEdge) {
        self.edges.push(edge);
    }

    pub fn node_count(&self) -> usize {
        self.nodes.len()
    }

    pub fn edge_count(&self) -> usize {
        self.edges.len()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn workspace_graph_tracks_nodes_and_edges() {
        let mut graph = WorkspaceGraph::default();

        graph.add_node(GraphNode::new("apps/web", "app"));
        graph.add_node(GraphNode::new("packages/ui", "package"));
        graph.add_edge(GraphEdge::new("apps/web", "packages/ui", "depends_on"));

        assert_eq!(graph.node_count(), 2);
        assert_eq!(graph.edge_count(), 1);
    }
}
RS

cargo fmt --all

echo
echo "Applied layer-0002-hotfix-0006-normalize-workspace-crate-apis"
echo
echo "Backups created as:"
echo "  crates/*/src/lib.rs.bak.layer-0002-hotfix-0006"
