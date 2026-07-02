#!/usr/bin/env bash
set -euo pipefail

# layer-0002-rust-workspace-and-cli-skeleton.sh
#
# Implements WP-0001: Rust Workspace and CLI Skeleton.
#
# This layer creates a compilable Rust workspace and locks the approved Monad
# v1 command surface in a real `monad` binary using Clap.
#
# Usage:
#   ./layer-0002-rust-workspace-and-cli-skeleton.sh .
#   ./layer-0002-rust-workspace-and-cli-skeleton.sh monad
#
# Options:
#   --force                       overwrite without backup
#   --allow-missing-layer-0000     do not require monad.toml
#   --skip-cargo-checks            write files but skip cargo fmt/check/test
#   -h, --help                    show help

usage() {
  cat <<'USAGE'
Usage:
  layer-0002-rust-workspace-and-cli-skeleton.sh [repo-dir] [options]

Options:
  --force                       overwrite without creating .layer0002.bak files
  --allow-missing-layer-0000     do not require monad.toml
  --skip-cargo-checks            write files but do not run cargo checks
  -h, --help                    show help

Examples:
  ./layer-0002-rust-workspace-and-cli-skeleton.sh .
  ./layer-0002-rust-workspace-and-cli-skeleton.sh monad
  ./layer-0002-rust-workspace-and-cli-skeleton.sh monad --skip-cargo-checks
USAGE
}

REPO_DIR="."
FORCE=0
ALLOW_MISSING_LAYER_0000=0
SKIP_CARGO_CHECKS=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --force) FORCE=1 ;;
    --allow-missing-layer-0000) ALLOW_MISSING_LAYER_0000=1 ;;
    --skip-cargo-checks) SKIP_CARGO_CHECKS=1 ;;
    -h|--help) usage; exit 0 ;;
    *) REPO_DIR="$1" ;;
  esac
  shift
done

mkdir -p "$REPO_DIR"
cd "$REPO_DIR"

log() { printf '[layer-0002] %s\n' "$*"; }

if [[ ! -f "monad.toml" && "$ALLOW_MISSING_LAYER_0000" != "1" ]]; then
  cat >&2 <<'ERR'
ERROR: monad.toml was not found.

This layer is intended to be applied after layer-0000 and layer-0001.
Run this script from the Monad repo root, or pass --allow-missing-layer-0000.
ERR
  exit 1
fi

ensure_dir() {
  mkdir -p "$1"
  log "dir  $1"
}

write_file() {
  local path="$1"
  mkdir -p "$(dirname "$path")"
  if [[ -e "$path" && "$FORCE" != "1" ]]; then
    local backup="${path}.layer0002.bak"
    if [[ ! -e "$backup" ]]; then
      cp "$path" "$backup"
      log "backup $backup"
    fi
  fi
  cat > "$path"
  log "write $path"
}

for dir in \
  crates/monad-cli/src \
  crates/monad-cli/tests \
  crates/monad-core/src \
  crates/monad-plans/src \
  crates/monad-packs/src \
  crates/monad-policy/src \
  crates/monad-context/src \
  crates/monad-graph/src \
  docs/commands \
  scripts
do
  ensure_dir "$dir"
done

# ---------------------------------------------------------------------------
# Root Rust workspace
# ---------------------------------------------------------------------------

write_file "Cargo.toml" <<'EOF'
[workspace]
members = [
  "crates/monad-cli",
  "crates/monad-core",
  "crates/monad-plans",
  "crates/monad-packs",
  "crates/monad-policy",
  "crates/monad-context",
  "crates/monad-graph",
]
resolver = "2"

[workspace.package]
version = "0.1.0"
edition = "2021"
rust-version = "1.80"
license = "MIT"
authors = ["Monad Contributors"]
description = "Monad is a governed monorepo operating-system CLI."

[workspace.dependencies]
clap = "4"
serde = { version = "1", features = ["derive"] }
serde_json = "1"
thiserror = "2"
EOF

write_file "rust-toolchain.toml" <<'EOF'
[toolchain]
channel = "stable"
components = ["rustfmt", "clippy"]
EOF

write_file "rustfmt.toml" <<'EOF'
edition = "2021"
max_width = 100
newline_style = "Unix"
EOF

write_file "clippy.toml" <<'EOF'
avoid-breaking-exported-api = false
EOF

# ---------------------------------------------------------------------------
# Shared crates
# ---------------------------------------------------------------------------

write_file "crates/monad-core/Cargo.toml" <<'EOF'
[package]
name = "monad-core"
version.workspace = true
edition.workspace = true
rust-version.workspace = true
license.workspace = true
authors.workspace = true
description = "Core workspace model and shared types for Monad."

[dependencies]
serde.workspace = true
thiserror.workspace = true
EOF

write_file "crates/monad-core/src/lib.rs" <<'EOF'
//! Core workspace model and shared constants for Monad.

use serde::{Deserialize, Serialize};

pub const CLI_NAME: &str = "monad";
pub const CANONICAL_MANIFEST: &str = "monad.toml";
pub const COMPATIBILITY_MANIFEST: &str = "workspace.toml";
pub const LOCKFILE: &str = "monad.lock";
pub const STATE_DIR: &str = ".monad";
pub const DEFAULT_PACKAGE_MANAGER: &str = "bun";
pub const DEFAULT_SCOPE: &str = "@monad";
pub const DEFAULT_INIT_PRESET: &str = "governed";
pub const MANIFEST_SCHEMA_VERSION: u32 = 1;
pub const PLAN_SCHEMA_VERSION: u32 = 1;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub enum WorkspaceUnitKind {
    App,
    Service,
    Package,
    Lib,
    Tool,
    Config,
    Policy,
    Infra,
    Docs,
    Contract,
    Test,
    Agent,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct WorkspaceDefaults {
    pub canonical_manifest: &'static str,
    pub compatibility_manifest: &'static str,
    pub lockfile: &'static str,
    pub state_dir: &'static str,
    pub default_package_manager: &'static str,
    pub default_scope: &'static str,
    pub default_init_preset: &'static str,
}

impl Default for WorkspaceDefaults {
    fn default() -> Self {
        Self {
            canonical_manifest: CANONICAL_MANIFEST,
            compatibility_manifest: COMPATIBILITY_MANIFEST,
            lockfile: LOCKFILE,
            state_dir: STATE_DIR,
            default_package_manager: DEFAULT_PACKAGE_MANAGER,
            default_scope: DEFAULT_SCOPE,
            default_init_preset: DEFAULT_INIT_PRESET,
        }
    }
}

#[derive(Debug, thiserror::Error)]
pub enum MonadError {
    #[error("workspace not found; expected {CANONICAL_MANIFEST}")]
    WorkspaceNotFound,

    #[error("unsupported operation: {0}")]
    UnsupportedOperation(String),

    #[error("validation failed: {0}")]
    Validation(String),
}

#[must_use]
pub fn workspace_defaults() -> WorkspaceDefaults {
    WorkspaceDefaults::default()
}
EOF

write_file "crates/monad-plans/Cargo.toml" <<'EOF'
[package]
name = "monad-plans"
version.workspace = true
edition.workspace = true
rust-version.workspace = true
license.workspace = true
authors.workspace = true
description = "Plan, diff, and apply primitives for Monad."

[dependencies]
monad-core = { path = "../monad-core" }
serde.workspace = true
EOF

write_file "crates/monad-plans/src/lib.rs" <<'EOF'
//! Plan, diff, and apply primitives for Monad.

use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct Plan {
    pub schema_version: u32,
    pub id: String,
    pub operation: String,
    pub steps: Vec<PlanStep>,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(tag = "kind", rename_all = "snake_case")]
pub enum PlanStep {
    CreateDir { path: String },
    CreateFile { path: String },
    UpdateFile { path: String },
    DeleteFile { path: String },
    MoveFile { from: String, to: String },
    CommandHint { command: String },
}

impl Plan {
    #[must_use]
    pub fn placeholder(operation: impl Into<String>) -> Self {
        let operation = operation.into();
        Self {
            schema_version: monad_core::PLAN_SCHEMA_VERSION,
            id: format!("plan_{operation}_placeholder"),
            operation,
            steps: Vec::new(),
        }
    }
}
EOF

write_file "crates/monad-packs/Cargo.toml" <<'EOF'
[package]
name = "monad-packs"
version.workspace = true
edition.workspace = true
rust-version.workspace = true
license.workspace = true
authors.workspace = true
description = "Built-in pack metadata for Monad."

[dependencies]
serde.workspace = true
EOF

write_file "crates/monad-packs/src/lib.rs" <<'EOF'
//! Built-in pack metadata for Monad.

use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct BuiltinPack {
    pub name: &'static str,
    pub kind: &'static str,
    pub description: &'static str,
}

#[must_use]
pub fn builtin_packs() -> Vec<BuiltinPack> {
    vec![
        BuiltinPack { name: "typescript-bun", kind: "language", description: "TypeScript projects using Bun." },
        BuiltinPack { name: "rust-crate", kind: "language", description: "Rust crates and workspace units." },
        BuiltinPack { name: "go-service", kind: "language", description: "Go service scaffold and checks." },
        BuiltinPack { name: "python-package", kind: "language", description: "Python package scaffold and checks." },
        BuiltinPack { name: "docs", kind: "documentation", description: "Documentation templates and indexes." },
        BuiltinPack { name: "adr", kind: "governance", description: "Architecture Decision Record workflows." },
        BuiltinPack { name: "workpacket", kind: "planning", description: "Governance-grade implementation work packets." },
        BuiltinPack { name: "policy", kind: "governance", description: "Policy and waiver primitives." },
        BuiltinPack { name: "github-actions", kind: "automation", description: "GitHub Actions workflows." },
        BuiltinPack { name: "docker", kind: "infrastructure", description: "Docker and Compose surfaces." },
    ]
}
EOF

write_file "crates/monad-policy/Cargo.toml" <<'EOF'
[package]
name = "monad-policy"
version.workspace = true
edition.workspace = true
rust-version.workspace = true
license.workspace = true
authors.workspace = true
description = "Policy and waiver primitives for Monad."

[dependencies]
serde.workspace = true
EOF

write_file "crates/monad-policy/src/lib.rs" <<'EOF'
//! Policy and waiver primitives for Monad.

use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct PolicyFinding {
    pub id: String,
    pub policy_id: String,
    pub severity: Severity,
    pub target: String,
    pub message: String,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub enum Severity {
    Error,
    Warn,
    Info,
}
EOF

write_file "crates/monad-context/Cargo.toml" <<'EOF'
[package]
name = "monad-context"
version.workspace = true
edition.workspace = true
rust-version.workspace = true
license.workspace = true
authors.workspace = true
description = "Context pack and handoff primitives for Monad."

[dependencies]
serde.workspace = true
EOF

write_file "crates/monad-context/src/lib.rs" <<'EOF'
//! Context pack and handoff primitives for Monad.

use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct ContextArtifact {
    pub kind: ContextArtifactKind,
    pub path: String,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub enum ContextArtifactKind {
    CurrentState,
    RepoMap,
    CommandCatalog,
    Handoff,
}
EOF

write_file "crates/monad-graph/Cargo.toml" <<'EOF'
[package]
name = "monad-graph"
version.workspace = true
edition.workspace = true
rust-version.workspace = true
license.workspace = true
authors.workspace = true
description = "Graph primitives for Monad."

[dependencies]
serde.workspace = true
EOF

write_file "crates/monad-graph/src/lib.rs" <<'EOF'
//! Graph primitives for Monad.

use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub enum GraphKind {
    Projects,
    Tasks,
    Deps,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct GraphSummary {
    pub kind: GraphKind,
    pub nodes: usize,
    pub edges: usize,
}
EOF

# ---------------------------------------------------------------------------
# monad-cli
# ---------------------------------------------------------------------------

write_file "crates/monad-cli/Cargo.toml" <<'EOF'
[package]
name = "monad-cli"
version.workspace = true
edition.workspace = true
rust-version.workspace = true
license.workspace = true
authors.workspace = true
description = "Monad command-line interface."

[[bin]]
name = "monad"
path = "src/main.rs"

[dependencies]
clap.workspace = true
monad-core = { path = "../monad-core" }
monad-packs = { path = "../monad-packs" }
serde.workspace = true
serde_json.workspace = true
EOF

write_file "crates/monad-cli/src/main.rs" <<'EOF'
use clap::{Arg, ArgAction, ArgMatches, Command};
use serde::Serialize;

fn main() -> std::process::ExitCode {
    match run() {
        Ok(()) => std::process::ExitCode::SUCCESS,
        Err(error) => {
            eprintln!("error: {error}");
            std::process::ExitCode::from(1)
        }
    }
}

fn run() -> Result<(), String> {
    let matches = cli().get_matches();
    let json = matches.get_flag("json");

    match matches.subcommand() {
        Some(("version", sub)) => emit_version(sub, json),
        Some(("pack", sub)) if matches_subcommand(sub, "list") => emit_pack_list(json),
        Some((command, sub)) => emit_placeholder(json, command_path(command, sub), mutates(command)),
        None => Ok(()),
    }
}

fn cli() -> Command {
    Command::new("monad")
        .version(env!("CARGO_PKG_VERSION"))
        .about("Governed monorepo operating-system CLI")
        .long_about("Monad initializes, modifies, evolves, validates, documents, graphs, governs, and manages serious monorepos.")
        .arg(flag("json", "Emit machine-readable JSON output").global(true))
        .arg(flag("no-color", "Disable color output").global(true))
        .subcommand(init_cmd())
        .subcommand(add_cmd())
        .subcommand(remove_cmd())
        .subcommand(rename_cmd())
        .subcommand(move_cmd())
        .subcommand(list_cmd())
        .subcommand(inspect_cmd())
        .subcommand(check_cmd())
        .subcommand(doctor_cmd())
        .subcommand(plan_cmd())
        .subcommand(apply_cmd())
        .subcommand(diff_cmd())
        .subcommand(generate_cmd())
        .subcommand(sync_cmd())
        .subcommand(run_cmd())
        .subcommand(build_cmd())
        .subcommand(test_cmd())
        .subcommand(lint_cmd())
        .subcommand(format_cmd())
        .subcommand(graph_cmd())
        .subcommand(clean_cmd())
        .subcommand(migrate_cmd())
        .subcommand(upgrade_cmd())
        .subcommand(context_cmd())
        .subcommand(config_cmd())
        .subcommand(version_cmd())
        .subcommand(policy_cmd())
        .subcommand(template_cmd())
        .subcommand(pack_cmd())
        .subcommand(plugin_cmd())
        .subcommand(release_cmd())
        .subcommand(docs_cmd())
        .subcommand(adr_cmd())
        .subcommand(workpacket_cmd())
}

fn arg(name: &'static str, help: &'static str) -> Arg {
    Arg::new(name).help(help)
}

fn flag(name: &'static str, help: &'static str) -> Arg {
    Arg::new(name).long(name).help(help).action(ArgAction::SetTrue)
}

fn opt(name: &'static str, help: &'static str) -> Arg {
    Arg::new(name).long(name).help(help).num_args(1)
}

fn fmt_arg() -> Arg {
    opt("format", "Output format").value_parser(["text", "json", "markdown"]).default_value("text")
}

fn graph_fmt_arg() -> Arg {
    opt("format", "Graph output format").value_parser(["text", "json", "mermaid", "dot", "svg"]).default_value("text")
}

fn init_cmd() -> Command {
    Command::new("init")
        .about("Initialize a new governed monorepo/workspace foundation")
        .arg(arg("path", "Target path").required(false))
        .arg(opt("name", "Workspace name").required(true))
        .arg(opt("preset", "Init preset").value_parser(["minimal", "standard", "governed", "ai-ready", "maximal"]).default_value("governed"))
        .arg(opt("package-manager", "Package manager").value_parser(["bun", "pnpm", "npm", "yarn"]).default_value("bun"))
        .arg(opt("template", "Template name"))
        .arg(flag("yes", "Skip safe confirmations"))
        .arg(flag("dry-run", "Preview without writing"))
}

fn add_cmd() -> Command {
    Command::new("add")
        .about("Add a workspace unit or managed capability")
        .arg(arg("kind", "Unit kind").required(true))
        .arg(arg("name", "Unit name").required(true))
        .arg(opt("to", "Destination path"))
        .arg(opt("language", "Language"))
        .arg(opt("framework", "Framework"))
        .arg(opt("template", "Template"))
        .arg(opt("scope", "Package scope").default_value("@monad"))
        .arg(flag("yes", "Skip safe confirmations"))
        .arg(flag("dry-run", "Preview without writing"))
}

fn remove_cmd() -> Command {
    Command::new("remove")
        .about("Safely remove a workspace unit or managed capability")
        .arg(arg("target", "Target entity").required(true))
        .arg(flag("keep-files", "Remove management metadata but keep files"))
        .arg(flag("force", "Force where safe"))
        .arg(flag("yes", "Skip safe confirmations"))
        .arg(flag("dry-run", "Preview without writing"))
}

fn rename_cmd() -> Command {
    Command::new("rename")
        .about("Rename a workspace entity while preserving references")
        .arg(arg("target", "Target entity").required(true))
        .arg(arg("new-name", "New name").required(true))
        .arg(flag("update-imports", "Update imports where supported"))
        .arg(flag("update-manifests", "Update manifests"))
        .arg(flag("yes", "Skip safe confirmations"))
        .arg(flag("dry-run", "Preview without writing"))
}

fn move_cmd() -> Command {
    Command::new("move")
        .about("Move a workspace entity while preserving metadata")
        .arg(arg("target", "Target entity").required(true))
        .arg(arg("destination", "Destination path").required(true))
        .arg(flag("update-imports", "Update imports where supported"))
        .arg(flag("update-manifests", "Update manifests"))
        .arg(flag("yes", "Skip safe confirmations"))
        .arg(flag("dry-run", "Preview without writing"))
}

fn list_cmd() -> Command {
    Command::new("list")
        .about("List workspace entities")
        .arg(arg("kind", "Entity kind").required(false))
        .arg(opt("scope", "Scope"))
        .arg(fmt_arg())
}

fn inspect_cmd() -> Command {
    Command::new("inspect")
        .about("Inspect workspace structure, metadata, dependencies, and tooling state")
        .arg(arg("target", "Target entity").required(false))
        .arg(opt("depth", "Depth"))
        .arg(opt("include", "Comma-separated sections"))
        .arg(fmt_arg())
}

fn check_cmd() -> Command {
    Command::new("check")
        .about("Run baseline correctness checks")
        .arg(arg("target", "Target entity").required(false))
        .arg(flag("strict", "Enable strict mode"))
        .arg(flag("fix", "Apply safe fixes where supported"))
        .arg(fmt_arg().value_parser(["text", "json"]))
}

fn doctor_cmd() -> Command {
    Command::new("doctor")
        .about("Diagnose environment, tooling, repo, cache, and policy problems")
        .arg(flag("fix", "Apply safe fixes where supported"))
        .arg(opt("include", "Comma-separated diagnostic areas"))
        .arg(fmt_arg().value_parser(["text", "json"]))
}

fn plan_cmd() -> Command {
    Command::new("plan")
        .about("Produce a change plan before modifying the repository")
        .arg(arg("operation", "Operation").required(true))
        .arg(arg("args", "Operation arguments").num_args(0..).trailing_var_arg(true))
        .arg(opt("out", "Output file"))
        .arg(fmt_arg())
}

fn apply_cmd() -> Command {
    Command::new("apply")
        .about("Apply a previously generated plan")
        .arg(arg("plan-file", "Plan file").required(true))
        .arg(flag("yes", "Skip safe confirmations"))
        .arg(flag("dry-run", "Preview without writing"))
        .arg(flag("rollback-on-error", "Rollback on error where possible"))
}

fn diff_cmd() -> Command {
    Command::new("diff")
        .about("Show proposed, staged, or actual repository changes")
        .arg(arg("plan-file", "Plan file").required(false))
        .arg(opt("against", "Diff target").value_parser(["git", "workspace", "snapshot"]))
        .arg(opt("format", "Output format").value_parser(["text", "json", "patch"]).default_value("text"))
}

fn generate_cmd() -> Command {
    Command::new("generate")
        .about("Generate code, configs, docs, manifests, scaffolds, or policies")
        .arg(arg("kind", "Generated artifact kind").required(true))
        .arg(arg("name", "Artifact name").required(true))
        .arg(opt("to", "Destination path"))
        .arg(opt("template", "Template"))
        .arg(opt("data", "Data file"))
        .arg(flag("yes", "Skip safe confirmations"))
        .arg(flag("dry-run", "Preview without writing"))
}

fn sync_cmd() -> Command {
    Command::new("sync")
        .about("Synchronize Monad intent with native tool configs")
        .arg(opt("from", "Source").value_parser(["monad", "native"]))
        .arg(opt("target", "Target tool"))
        .arg(flag("check", "Check only"))
        .arg(flag("write", "Write changes"))
        .arg(flag("dry-run", "Preview without writing"))
}

fn run_cmd() -> Command {
    Command::new("run")
        .about("Run a named workspace task")
        .arg(arg("task", "Task name").required(true))
        .arg(opt("filter", "Target selector"))
        .arg(flag("affected", "Only affected units"))
        .arg(opt("parallel", "Parallelism"))
        .arg(opt("since", "Git ref"))
}

fn build_cmd() -> Command {
    Command::new("build")
        .about("Build workspace units")
        .arg(arg("target", "Target").required(false))
        .arg(opt("filter", "Target selector"))
        .arg(flag("affected", "Only affected units"))
        .arg(flag("production", "Production build"))
        .arg(opt("parallel", "Parallelism"))
}

fn test_cmd() -> Command {
    Command::new("test")
        .about("Run tests")
        .arg(arg("target", "Target").required(false))
        .arg(opt("filter", "Target selector"))
        .arg(flag("affected", "Only affected units"))
        .arg(flag("unit", "Unit tests"))
        .arg(flag("integration", "Integration tests"))
        .arg(flag("e2e", "End-to-end tests"))
        .arg(flag("coverage", "Coverage"))
}

fn lint_cmd() -> Command {
    Command::new("lint")
        .about("Run linting and static analysis")
        .arg(arg("target", "Target").required(false))
        .arg(opt("filter", "Target selector"))
        .arg(flag("affected", "Only affected units"))
        .arg(flag("fix", "Apply safe fixes"))
        .arg(fmt_arg().value_parser(["text", "json"]))
}

fn format_cmd() -> Command {
    Command::new("format")
        .about("Format source files, configs, docs, and generated files")
        .arg(arg("target", "Target").required(false))
        .arg(flag("check", "Check formatting"))
        .arg(flag("write", "Write formatting changes"))
        .arg(opt("filter", "Target selector"))
}

fn graph_cmd() -> Command {
    Command::new("graph")
        .about("Produce workspace graphs")
        .arg(opt("type", "Graph type").long("type").value_parser(["projects", "tasks", "deps"]))
        .arg(opt("filter", "Target selector"))
        .arg(graph_fmt_arg())
        .arg(opt("out", "Output file"))
        .subcommand(graph_projects_cmd())
        .subcommand(graph_tasks_cmd())
        .subcommand(graph_deps_cmd())
}

fn graph_projects_cmd() -> Command {
    Command::new("projects")
        .about("Generate project graph")
        .arg(opt("filter", "Target selector"))
        .arg(graph_fmt_arg())
        .arg(opt("out", "Output file"))
}

fn graph_tasks_cmd() -> Command {
    Command::new("tasks")
        .about("Generate task graph")
        .arg(arg("task", "Task").required(false))
        .arg(opt("filter", "Target selector"))
        .arg(flag("affected", "Only affected units"))
        .arg(graph_fmt_arg())
        .arg(opt("out", "Output file"))
}

fn graph_deps_cmd() -> Command {
    Command::new("deps")
        .about("Generate dependency graph")
        .arg(opt("filter", "Target selector"))
        .arg(opt("include", "Dependency inclusion").value_parser(["external", "internal", "all"]).default_value("all"))
        .arg(graph_fmt_arg())
        .arg(opt("out", "Output file"))
}

fn clean_cmd() -> Command {
    Command::new("clean")
        .about("Remove generated state, caches, build output, or temp files")
        .arg(arg("target", "Target").required(false))
        .arg(flag("cache", "Clean cache"))
        .arg(flag("dist", "Clean dist/build outputs"))
        .arg(flag("temp", "Clean temporary files"))
        .arg(flag("state", "Clean Monad state"))
        .arg(flag("all", "Clean all supported generated outputs"))
        .arg(flag("yes", "Skip safe confirmations"))
        .arg(flag("dry-run", "Preview without writing"))
}

fn migrate_cmd() -> Command {
    Command::new("migrate")
        .about("Migrate repo structure, config formats, package managers, or schema versions")
        .arg(arg("migration", "Migration name").required(true))
        .arg(opt("from", "From version"))
        .arg(opt("to", "To version"))
        .arg(flag("yes", "Skip safe confirmations"))
        .arg(flag("dry-run", "Preview without writing"))
}

fn upgrade_cmd() -> Command {
    Command::new("upgrade")
        .about("Upgrade Monad-managed templates, packs, plugins, schemas, or conventions")
        .arg(arg("target", "Target").required(false))
        .arg(opt("to", "Version"))
        .arg(flag("templates", "Upgrade templates"))
        .arg(flag("packs", "Upgrade packs"))
        .arg(flag("plugins", "Upgrade plugins"))
        .arg(flag("schema", "Upgrade schema"))
        .arg(flag("yes", "Skip safe confirmations"))
        .arg(flag("dry-run", "Preview without writing"))
}

fn context_cmd() -> Command {
    Command::new("context")
        .about("Manage AI/developer context artifacts")
        .arg(fmt_arg())
        .subcommand(context_pack_cmd())
        .subcommand(context_verify_cmd())
        .subcommand(context_handoff_cmd())
}

fn context_pack_cmd() -> Command {
    Command::new("pack")
        .about("Generate context pack")
        .arg(opt("scope", "Scope selector"))
        .arg(opt("include", "Comma-separated included sections"))
        .arg(opt("out", "Output path"))
        .arg(opt("format", "Output format").value_parser(["markdown", "json"]).default_value("markdown"))
}

fn context_verify_cmd() -> Command {
    Command::new("verify")
        .about("Verify context freshness and completeness")
        .arg(opt("context", "Context path"))
        .arg(flag("strict", "Strict verification"))
        .arg(fmt_arg().value_parser(["text", "json"]))
}

fn context_handoff_cmd() -> Command {
    Command::new("handoff")
        .about("Generate handoff document")
        .arg(opt("scope", "Scope selector"))
        .arg(opt("from", "Git ref"))
        .arg(opt("out", "Output path"))
        .arg(opt("format", "Output format").value_parser(["markdown", "json"]).default_value("markdown"))
}

fn config_cmd() -> Command {
    Command::new("config")
        .about("Read, write, validate, or explain Monad configuration")
        .subcommand(Command::new("get").arg(arg("key", "Key").required(true)).arg(scope_flags()).arg(fmt_arg()))
        .subcommand(Command::new("set").arg(arg("key", "Key").required(true)).arg(arg("value", "Value").required(true)).arg(scope_flags()).arg(fmt_arg()))
        .subcommand(Command::new("unset").arg(arg("key", "Key").required(true)).arg(scope_flags()))
        .subcommand(Command::new("list").arg(scope_flags()).arg(fmt_arg()))
        .subcommand(Command::new("validate").arg(fmt_arg()))
}

fn scope_flags() -> Arg {
    // Clap cannot add a group of args through one helper. This placeholder arg
    // keeps config help compact in WP-0001; later packets can expand it.
    opt("scope", "Config scope: global or workspace").value_parser(["global", "workspace"])
}

fn version_cmd() -> Command {
    Command::new("version")
        .about("Print Monad CLI and workspace version information")
        .arg(flag("verbose", "Show verbose version information"))
}

fn policy_cmd() -> Command {
    Command::new("policy")
        .about("Manage governance policies")
        .subcommand(Command::new("check").arg(arg("target", "Target").required(false)).arg(opt("policy", "Policy ID")).arg(opt("severity", "Minimum severity").value_parser(["error", "warn", "info"])).arg(opt("format", "Output format").value_parser(["text", "json", "sarif"]).default_value("text")))
        .subcommand(Command::new("waive").arg(arg("policy-id", "Policy ID").required(true)).arg(opt("target", "Target").required(true)).arg(opt("reason", "Reason").required(true)).arg(opt("owner", "Owner").required(true)).arg(opt("expires", "Expiration date")).arg(flag("dry-run", "Preview without writing")))
        .subcommand(Command::new("explain").arg(arg("id", "Policy or finding ID").required(true)).arg(opt("target", "Target")).arg(fmt_arg()))
}

fn template_cmd() -> Command {
    Command::new("template")
        .about("Manage templates")
        .subcommand(Command::new("list").arg(opt("source", "Template source").value_parser(["local", "workspace", "official", "registry"])).arg(opt("kind", "Template kind")).arg(fmt_arg().value_parser(["text", "json"])))
        .subcommand(Command::new("add").arg(arg("source", "Template source").required(true)).arg(opt("name", "Name")).arg(opt("kind", "Kind")).arg(flag("global", "Install globally")).arg(flag("workspace", "Install in workspace")).arg(flag("yes", "Skip safe confirmations")))
        .subcommand(Command::new("inspect").arg(arg("template", "Template").required(true)).arg(fmt_arg()))
}

fn pack_cmd() -> Command {
    Command::new("pack")
        .about("Manage language, framework, and tooling packs")
        .subcommand(Command::new("list").arg(flag("installed", "Show installed packs")).arg(flag("available", "Show available packs")).arg(opt("registry", "Registry")).arg(fmt_arg().value_parser(["text", "json"])))
        .subcommand(Command::new("install").arg(arg("pack", "Pack").required(true)).arg(opt("version", "Version")).arg(opt("registry", "Registry")).arg(flag("yes", "Skip safe confirmations")).arg(flag("dry-run", "Preview without writing")))
        .subcommand(Command::new("update").arg(arg("pack", "Pack").required(false)).arg(opt("to", "Version")).arg(flag("all", "Update all")).arg(flag("yes", "Skip safe confirmations")).arg(flag("dry-run", "Preview without writing")))
}

fn plugin_cmd() -> Command {
    Command::new("plugin")
        .about("Manage declarative plugin adapters")
        .subcommand(Command::new("list").arg(flag("installed", "Show installed")).arg(flag("available", "Show available")).arg(flag("enabled", "Show enabled")).arg(fmt_arg().value_parser(["text", "json"])))
        .subcommand(Command::new("install").arg(arg("source", "Source").required(true)).arg(opt("name", "Name")).arg(opt("version", "Version")).arg(flag("enable", "Enable after install")).arg(flag("yes", "Skip safe confirmations")))
        .subcommand(Command::new("remove").arg(arg("plugin", "Plugin").required(true)).arg(flag("disable-only", "Disable but do not remove")).arg(flag("yes", "Skip safe confirmations")).arg(flag("dry-run", "Preview without writing")))
}

fn release_cmd() -> Command {
    Command::new("release")
        .about("Plan, apply, and publish releases")
        .subcommand(Command::new("plan").arg(opt("since", "Git ref")).arg(opt("version", "Version bump").value_parser(["major", "minor", "patch", "prerelease"])).arg(opt("out", "Output file")).arg(fmt_arg()))
        .subcommand(Command::new("apply").arg(arg("plan-file", "Plan file").required(true)).arg(flag("no-tag", "Do not tag")).arg(flag("no-changelog", "Do not update changelog")).arg(flag("yes", "Skip safe confirmations")).arg(flag("dry-run", "Preview without writing")))
        .subcommand(Command::new("publish").arg(arg("plan-file", "Plan file").required(false)).arg(opt("registry", "Registry")).arg(flag("dry-run", "Preview without writing")).arg(flag("yes", "Skip safe confirmations")))
}

fn docs_cmd() -> Command {
    Command::new("docs")
        .about("Generate and check documentation")
        .subcommand(Command::new("generate").arg(arg("kind", "Doc kind").required(false)).arg(opt("scope", "Scope selector")).arg(opt("out", "Output path")).arg(flag("yes", "Skip safe confirmations")).arg(flag("dry-run", "Preview without writing")))
        .subcommand(Command::new("check").arg(flag("strict", "Strict mode")).arg(flag("fix", "Apply safe fixes")).arg(fmt_arg().value_parser(["text", "json"])))
}

fn adr_cmd() -> Command {
    Command::new("adr")
        .about("Create, list, and supersede Architecture Decision Records")
        .subcommand(Command::new("new").arg(arg("title", "ADR title").required(true)).arg(opt("status", "Status").value_parser(["proposed", "accepted", "deprecated", "superseded"])).arg(opt("tags", "Comma-separated tags")).arg(flag("yes", "Skip safe confirmations")))
        .subcommand(Command::new("list").arg(opt("status", "Status")).arg(opt("tag", "Tag")).arg(fmt_arg()))
        .subcommand(Command::new("supersede").arg(arg("old-adr", "Old ADR").required(true)).arg(arg("new-adr", "New ADR").required(true)).arg(opt("reason", "Reason")).arg(flag("yes", "Skip safe confirmations")).arg(flag("dry-run", "Preview without writing")))
}

fn workpacket_cmd() -> Command {
    Command::new("workpacket")
        .about("Create, list, and plan implementation work packets")
        .subcommand(Command::new("new").arg(arg("title", "Work packet title").required(true)).arg(opt("epic", "Epic")).arg(opt("status", "Status")).arg(opt("priority", "Priority")).arg(flag("yes", "Skip safe confirmations")))
        .subcommand(Command::new("list").arg(opt("status", "Status")).arg(opt("epic", "Epic")).arg(opt("priority", "Priority")).arg(fmt_arg()))
        .subcommand(Command::new("plan").arg(arg("workpacket-ids", "Work packet IDs").num_args(0..)).arg(opt("milestone", "Milestone")).arg(opt("out", "Output file")).arg(fmt_arg()))
}

fn command_path(command: &str, sub: &ArgMatches) -> String {
    if let Some((nested, _)) = sub.subcommand() {
        format!("{command} {nested}")
    } else {
        command.to_string()
    }
}

fn matches_subcommand(sub: &ArgMatches, name: &str) -> bool {
    sub.subcommand().is_some_and(|(nested, _)| nested == name)
}

fn mutates(command: &str) -> bool {
    matches!(
        command,
        "init"
            | "add"
            | "remove"
            | "rename"
            | "move"
            | "apply"
            | "generate"
            | "sync"
            | "format"
            | "clean"
            | "migrate"
            | "upgrade"
            | "context"
            | "config"
            | "policy"
            | "template"
            | "pack"
            | "plugin"
            | "release"
            | "docs"
            | "adr"
            | "workpacket"
    )
}

#[derive(Serialize)]
struct CommandOutcome {
    ok: bool,
    command: String,
    status: &'static str,
    message: String,
    mutates_files: bool,
    plan_backed: bool,
}

fn emit_placeholder(json: bool, command: String, mutates_files: bool) -> Result<(), String> {
    let outcome = CommandOutcome {
        ok: true,
        command: command.clone(),
        status: "placeholder",
        message: format!("{command} is present in the WP-0001 CLI skeleton; behavior arrives in later work packets."),
        mutates_files,
        plan_backed: mutates_files,
    };

    if json {
        println!("{}", serde_json::to_string_pretty(&outcome).map_err(|error| error.to_string())?);
    } else {
        println!("{}", outcome.message);
    }

    Ok(())
}

fn emit_pack_list(json: bool) -> Result<(), String> {
    let packs = monad_packs::builtin_packs();

    if json {
        println!("{}", serde_json::to_string_pretty(&packs).map_err(|error| error.to_string())?);
    } else {
        for pack in packs {
            println!("{} ({}) - {}", pack.name, pack.kind, pack.description);
        }
    }

    Ok(())
}

fn emit_version(matches: &ArgMatches, json: bool) -> Result<(), String> {
    #[derive(Serialize)]
    struct VersionOutput {
        ok: bool,
        cli: &'static str,
        version: &'static str,
        manifest_schema_version: u32,
        plan_schema_version: u32,
        canonical_manifest: &'static str,
        compatibility_manifest: &'static str,
        default_scope: &'static str,
        verbose: bool,
    }

    let verbose = matches.get_flag("verbose");
    let output = VersionOutput {
        ok: true,
        cli: monad_core::CLI_NAME,
        version: env!("CARGO_PKG_VERSION"),
        manifest_schema_version: monad_core::MANIFEST_SCHEMA_VERSION,
        plan_schema_version: monad_core::PLAN_SCHEMA_VERSION,
        canonical_manifest: monad_core::CANONICAL_MANIFEST,
        compatibility_manifest: monad_core::COMPATIBILITY_MANIFEST,
        default_scope: monad_core::DEFAULT_SCOPE,
        verbose,
    };

    if json {
        println!("{}", serde_json::to_string_pretty(&output).map_err(|error| error.to_string())?);
    } else if verbose {
        println!("monad {}", env!("CARGO_PKG_VERSION"));
        println!("manifest schema {}", monad_core::MANIFEST_SCHEMA_VERSION);
        println!("plan schema {}", monad_core::PLAN_SCHEMA_VERSION);
        println!("canonical manifest {}", monad_core::CANONICAL_MANIFEST);
        println!("compatibility manifest {}", monad_core::COMPATIBILITY_MANIFEST);
        println!("default scope {}", monad_core::DEFAULT_SCOPE);
    } else {
        println!("monad {}", env!("CARGO_PKG_VERSION"));
    }

    Ok(())
}
EOF

# ---------------------------------------------------------------------------
# Smoke tests
# ---------------------------------------------------------------------------

write_file "crates/monad-cli/tests/help_smoke.rs" <<'EOF'
use std::process::Command;

fn monad(args: &[&str]) -> std::process::Output {
    Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(args)
        .output()
        .expect("failed to run monad binary")
}

fn assert_success(args: &[&str]) {
    let output = monad(args);
    assert!(
        output.status.success(),
        "expected `monad {}` to succeed\nstdout:\n{}\nstderr:\n{}",
        args.join(" "),
        String::from_utf8_lossy(&output.stdout),
        String::from_utf8_lossy(&output.stderr)
    );
}

#[test]
fn root_help_works() {
    assert_success(&["--help"]);
}

#[test]
fn version_works() {
    assert_success(&["version", "--verbose"]);
    assert_success(&["version", "--verbose", "--json"]);
}

#[test]
fn top_level_command_help_works() {
    let commands = [
        "init", "add", "remove", "rename", "move", "list", "inspect", "check", "doctor",
        "plan", "apply", "diff", "generate", "sync", "run", "build", "test", "lint",
        "format", "graph", "clean", "migrate", "upgrade", "context", "config", "version",
        "policy", "template", "pack", "plugin", "release", "docs", "adr", "workpacket",
    ];

    for command in commands {
        assert_success(&[command, "--help"]);
    }
}

#[test]
fn namespaced_command_help_works() {
    let commands: &[&[&str]] = &[
        &["policy", "check", "--help"],
        &["policy", "waive", "--help"],
        &["policy", "explain", "--help"],
        &["template", "list", "--help"],
        &["template", "add", "--help"],
        &["template", "inspect", "--help"],
        &["pack", "list", "--help"],
        &["pack", "install", "--help"],
        &["pack", "update", "--help"],
        &["plugin", "list", "--help"],
        &["plugin", "install", "--help"],
        &["plugin", "remove", "--help"],
        &["release", "plan", "--help"],
        &["release", "apply", "--help"],
        &["release", "publish", "--help"],
        &["context", "pack", "--help"],
        &["context", "verify", "--help"],
        &["context", "handoff", "--help"],
        &["graph", "projects", "--help"],
        &["graph", "tasks", "--help"],
        &["graph", "deps", "--help"],
        &["docs", "generate", "--help"],
        &["docs", "check", "--help"],
        &["adr", "new", "--help"],
        &["adr", "list", "--help"],
        &["adr", "supersede", "--help"],
        &["workpacket", "new", "--help"],
        &["workpacket", "list", "--help"],
        &["workpacket", "plan", "--help"],
        &["config", "get", "--help"],
        &["config", "set", "--help"],
        &["config", "unset", "--help"],
        &["config", "list", "--help"],
        &["config", "validate", "--help"],
    ];

    for args in commands {
        assert_success(args);
    }
}
EOF

# ---------------------------------------------------------------------------
# Docs and validation scripts
# ---------------------------------------------------------------------------

write_file "docs/commands/monad-cli.md" <<'EOF'
# Monad CLI Command Surface

This document is generated by `layer-0002-rust-workspace-and-cli-skeleton.sh`.

WP-0001 locks the Monad v1 command surface in Rust using Clap. Most command behavior is intentionally placeholder-only until later work packets implement the underlying systems.

## Top-Level Commands

```txt
monad init
monad add
monad remove
monad rename
monad move
monad list
monad inspect
monad check
monad doctor
monad plan
monad apply
monad diff
monad generate
monad sync
monad run
monad build
monad test
monad lint
monad format
monad graph
monad clean
monad migrate
monad upgrade
monad context
monad config
monad version
```

## Namespaced Commands

```txt
monad policy check
monad policy waive
monad policy explain

monad template list
monad template add
monad template inspect

monad pack list
monad pack install
monad pack update

monad plugin list
monad plugin install
monad plugin remove

monad release plan
monad release apply
monad release publish

monad context pack
monad context verify
monad context handoff

monad graph projects
monad graph tasks
monad graph deps

monad docs generate
monad docs check

monad adr new
monad adr list
monad adr supersede

monad workpacket new
monad workpacket list
monad workpacket plan
```

## WP-0001 Acceptance Commands

```bash
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
cargo run -p monad-cli -- --help
cargo run -p monad-cli -- version --verbose
cargo run -p monad-cli -- pack list
cargo run -p monad-cli -- policy check --help
cargo run -p monad-cli -- workpacket plan --help
```
EOF

write_file "scripts/check.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

echo "[check] monad repository checks"

if command -v cargo >/dev/null 2>&1; then
  cargo fmt --all --check
  cargo check --workspace
  cargo test --workspace
else
  echo "[check] cargo is required for layer-0002 and later" >&2
  exit 1
fi

if [[ -x scripts/drift-check.sh ]]; then
  scripts/drift-check.sh
fi

if [[ -x scripts/graph-integrity.sh ]]; then
  scripts/graph-integrity.sh
fi

echo "[check] ok"
EOF

write_file "scripts/smoke.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

cargo run -p monad-cli -- --help
cargo run -p monad-cli -- version --verbose
cargo run -p monad-cli -- pack list
cargo run -p monad-cli -- policy check --help
cargo run -p monad-cli -- workpacket plan --help
EOF

chmod +x scripts/check.sh scripts/smoke.sh

bash -n scripts/check.sh
bash -n scripts/smoke.sh

if [[ "$SKIP_CARGO_CHECKS" == "1" ]]; then
  log "skipping cargo checks by request"
else
  if command -v cargo >/dev/null 2>&1; then
    log "running cargo fmt"
    cargo fmt --all

    log "running cargo check"
    cargo check --workspace

    log "running cargo test"
    cargo test --workspace
  else
    log "cargo not found; wrote files but skipped cargo checks"
  fi
fi

log "WP-0001 CLI skeleton layer complete"

cat <<'NEXT'

Next suggested commands:

  cargo fmt --all --check
  cargo check --workspace
  cargo test --workspace
  cargo run -p monad-cli -- --help
  cargo run -p monad-cli -- version --verbose
  cargo run -p monad-cli -- pack list
  scripts/check.sh

Then commit:

  git add .
  git commit -m "feat(cli): add rust workspace and v1 command surface skeleton"

NEXT
