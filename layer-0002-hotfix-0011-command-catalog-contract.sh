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

if [ ! -f "crates/monad-cli/src/lib.rs" ]; then
  echo "ERROR: crates/monad-cli/src/lib.rs not found. Expected lib+bin normalized CLI crate." >&2
  exit 1
fi

mkdir -p crates/monad-cli/tests

cp crates/monad-core/src/lib.rs crates/monad-core/src/lib.rs.bak.layer-0002-hotfix-0011

cat > crates/monad-core/src/command_catalog.rs <<'RS'
//! Approved Monad command catalog.
//!
//! This module is intentionally boring and explicit. It gives WP-0001 a stable
//! command-surface contract that can be tested independently of Clap wiring.

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum CommandKind {
    ReadOnly,
    Mutating,
    Planning,
    Execution,
    Governance,
    Documentation,
    Context,
    Graph,
    Release,
    Extension,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct CommandSpec {
    pub path: &'static str,
    pub kind: CommandKind,
    pub plan_backed: bool,
    pub supports_dry_run: bool,
}

impl CommandSpec {
    pub const fn new(
        path: &'static str,
        kind: CommandKind,
        plan_backed: bool,
        supports_dry_run: bool,
    ) -> Self {
        Self {
            path,
            kind,
            plan_backed,
            supports_dry_run,
        }
    }

    pub const fn read_only(path: &'static str) -> Self {
        Self::new(path, CommandKind::ReadOnly, false, false)
    }

    pub const fn mutating(path: &'static str) -> Self {
        Self::new(path, CommandKind::Mutating, true, true)
    }
}

pub const APPROVED_TOP_LEVEL_COMMANDS: &[CommandSpec] = &[
    CommandSpec::mutating("init"),
    CommandSpec::mutating("add"),
    CommandSpec::mutating("remove"),
    CommandSpec::mutating("rename"),
    CommandSpec::mutating("move"),
    CommandSpec::read_only("list"),
    CommandSpec::read_only("inspect"),
    CommandSpec::read_only("check"),
    CommandSpec::read_only("doctor"),
    CommandSpec::new("plan", CommandKind::Planning, true, true),
    CommandSpec::new("apply", CommandKind::Mutating, true, false),
    CommandSpec::read_only("diff"),
    CommandSpec::new("generate", CommandKind::Mutating, true, true),
    CommandSpec::new("sync", CommandKind::Mutating, true, true),
    CommandSpec::new("run", CommandKind::Execution, false, false),
    CommandSpec::new("build", CommandKind::Execution, false, false),
    CommandSpec::new("test", CommandKind::Execution, false, false),
    CommandSpec::new("lint", CommandKind::Execution, false, false),
    CommandSpec::new("format", CommandKind::Execution, false, false),
    CommandSpec::new("graph", CommandKind::Graph, false, false),
    CommandSpec::new("clean", CommandKind::Mutating, true, true),
    CommandSpec::new("migrate", CommandKind::Mutating, true, true),
    CommandSpec::new("upgrade", CommandKind::Mutating, true, true),
    CommandSpec::new("context", CommandKind::Context, false, false),
    CommandSpec::read_only("config"),
    CommandSpec::read_only("version"),
];

pub const APPROVED_NAMESPACED_COMMANDS: &[CommandSpec] = &[
    CommandSpec::new("policy check", CommandKind::Governance, false, false),
    CommandSpec::new("policy waive", CommandKind::Governance, true, true),
    CommandSpec::new("policy explain", CommandKind::Governance, false, false),
    CommandSpec::new("template list", CommandKind::Extension, false, false),
    CommandSpec::new("template add", CommandKind::Extension, true, true),
    CommandSpec::new("template inspect", CommandKind::Extension, false, false),
    CommandSpec::new("pack list", CommandKind::Extension, false, false),
    CommandSpec::new("pack install", CommandKind::Extension, true, true),
    CommandSpec::new("pack update", CommandKind::Extension, true, true),
    CommandSpec::new("plugin list", CommandKind::Extension, false, false),
    CommandSpec::new("plugin install", CommandKind::Extension, true, true),
    CommandSpec::new("plugin remove", CommandKind::Extension, true, true),
    CommandSpec::new("release plan", CommandKind::Release, true, true),
    CommandSpec::new("release apply", CommandKind::Release, true, false),
    CommandSpec::new("release publish", CommandKind::Release, true, true),
    CommandSpec::new("context pack", CommandKind::Context, false, false),
    CommandSpec::new("context verify", CommandKind::Context, false, false),
    CommandSpec::new("context handoff", CommandKind::Context, false, false),
    CommandSpec::new("graph projects", CommandKind::Graph, false, false),
    CommandSpec::new("graph tasks", CommandKind::Graph, false, false),
    CommandSpec::new("graph deps", CommandKind::Graph, false, false),
    CommandSpec::new("docs generate", CommandKind::Documentation, true, true),
    CommandSpec::new("docs check", CommandKind::Documentation, false, false),
    CommandSpec::new("adr new", CommandKind::Documentation, true, true),
    CommandSpec::new("adr list", CommandKind::Documentation, false, false),
    CommandSpec::new("adr supersede", CommandKind::Documentation, true, true),
    CommandSpec::new("workpacket new", CommandKind::Planning, true, true),
    CommandSpec::new("workpacket list", CommandKind::Planning, false, false),
    CommandSpec::new("workpacket plan", CommandKind::Planning, true, true),
];

pub fn approved_top_level_command_paths() -> Vec<&'static str> {
    APPROVED_TOP_LEVEL_COMMANDS
        .iter()
        .map(|command| command.path)
        .collect()
}

pub fn approved_namespaced_command_paths() -> Vec<&'static str> {
    APPROVED_NAMESPACED_COMMANDS
        .iter()
        .map(|command| command.path)
        .collect()
}

pub fn approved_command_paths() -> Vec<&'static str> {
    APPROVED_TOP_LEVEL_COMMANDS
        .iter()
        .chain(APPROVED_NAMESPACED_COMMANDS.iter())
        .map(|command| command.path)
        .collect()
}

pub fn approved_commands() -> Vec<CommandSpec> {
    APPROVED_TOP_LEVEL_COMMANDS
        .iter()
        .chain(APPROVED_NAMESPACED_COMMANDS.iter())
        .copied()
        .collect()
}

pub fn command_spec(path: &str) -> Option<CommandSpec> {
    APPROVED_TOP_LEVEL_COMMANDS
        .iter()
        .chain(APPROVED_NAMESPACED_COMMANDS.iter())
        .find(|command| command.path == path)
        .copied()
}

pub fn is_approved_command(path: &str) -> bool {
    command_spec(path).is_some()
}

pub fn is_plan_backed(path: &str) -> bool {
    command_spec(path)
        .map(|command| command.plan_backed)
        .unwrap_or(false)
}

pub fn supports_dry_run(path: &str) -> bool {
    command_spec(path)
        .map(|command| command.supports_dry_run)
        .unwrap_or(false)
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::collections::BTreeSet;

    #[test]
    fn catalog_contains_approved_top_level_v1_surface() {
        let paths = approved_top_level_command_paths();

        for expected in [
            "init", "add", "remove", "rename", "move", "list", "inspect", "check", "doctor",
            "plan", "apply", "diff", "generate", "sync", "run", "build", "test", "lint",
            "format", "graph", "clean", "migrate", "upgrade", "context", "config", "version",
        ] {
            assert!(paths.contains(&expected), "missing `{expected}`");
        }
    }

    #[test]
    fn catalog_contains_approved_namespaced_v1_surface() {
        let paths = approved_namespaced_command_paths();

        for expected in [
            "policy check",
            "policy waive",
            "policy explain",
            "template list",
            "template add",
            "template inspect",
            "pack list",
            "pack install",
            "pack update",
            "plugin list",
            "plugin install",
            "plugin remove",
            "release plan",
            "release apply",
            "release publish",
            "context pack",
            "context verify",
            "context handoff",
            "graph projects",
            "graph tasks",
            "graph deps",
            "docs generate",
            "docs check",
            "adr new",
            "adr list",
            "adr supersede",
            "workpacket new",
            "workpacket list",
            "workpacket plan",
        ] {
            assert!(paths.contains(&expected), "missing `{expected}`");
        }
    }

    #[test]
    fn catalog_has_no_duplicate_paths() {
        let paths = approved_command_paths();
        let unique = paths.iter().copied().collect::<BTreeSet<_>>();

        assert_eq!(paths.len(), unique.len());
    }

    #[test]
    fn mutating_generation_commands_are_plan_backed_and_dry_runnable() {
        for path in ["init", "add", "remove", "rename", "move", "generate", "sync"] {
            assert!(is_plan_backed(path), "`{path}` should be plan-backed");
            assert!(supports_dry_run(path), "`{path}` should support --dry-run");
        }
    }

    #[test]
    fn read_only_commands_are_not_plan_backed() {
        for path in ["list", "inspect", "check", "doctor", "diff", "version"] {
            assert!(!is_plan_backed(path), "`{path}` should not be plan-backed");
            assert!(!supports_dry_run(path), "`{path}` should not support --dry-run");
        }
    }
}
RS

python3 - <<'PY'
from pathlib import Path

lib = Path("crates/monad-core/src/lib.rs")
text = lib.read_text()

if "pub mod command_catalog;" not in text:
    text = "pub mod command_catalog;\n\n" + text

lib.write_text(text)
PY

cat > crates/monad-cli/tests/command_catalog_contract.rs <<'RS'
use std::collections::BTreeSet;

fn collect_command_paths(command: &clap::Command, prefix: &str, paths: &mut BTreeSet<String>) {
    for subcommand in command.get_subcommands() {
        let path = if prefix.is_empty() {
            subcommand.get_name().to_owned()
        } else {
            format!("{prefix} {}", subcommand.get_name())
        };

        paths.insert(path.clone());
        collect_command_paths(subcommand, &path, paths);
    }
}

fn clap_command_paths() -> BTreeSet<String> {
    let command = monad_cli::build_cli();
    let mut paths = BTreeSet::new();
    collect_command_paths(&command, "", &mut paths);
    paths
}

#[test]
fn clap_surface_exposes_every_catalog_command() {
    let actual = clap_command_paths();

    for expected in monad_core::command_catalog::approved_command_paths() {
        assert!(
            actual.contains(expected),
            "Clap command tree is missing catalog command `{expected}`"
        );
    }
}

#[test]
fn catalog_does_not_claim_unknown_example_commands() {
    assert!(!monad_core::command_catalog::is_approved_command("deploy"));
    assert!(!monad_core::command_catalog::is_approved_command("graph everything"));
}
RS

cargo fmt --all

echo
echo "Applied layer-0002-hotfix-0011-command-catalog-contract"
echo
echo "Added:"
echo "  - monad_core::command_catalog"
echo "  - command catalog unit tests"
echo "  - monad-cli Clap/catalog integration test"
