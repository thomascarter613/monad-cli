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
    CommandSpec::new("config list", CommandKind::ReadOnly, false, false),
    CommandSpec::new("config validate", CommandKind::ReadOnly, false, false),
    CommandSpec::new("config get", CommandKind::ReadOnly, false, false),
    CommandSpec::new("config set", CommandKind::Mutating, true, true),
    CommandSpec::new("config unset", CommandKind::Mutating, true, true),
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

pub fn is_mutating_command(path: &str) -> bool {
    command_spec(path)
        .map(|command| {
            command.plan_backed
                && matches!(
                    command.kind,
                    CommandKind::Mutating
                        | CommandKind::Planning
                        | CommandKind::Governance
                        | CommandKind::Documentation
                        | CommandKind::Release
                        | CommandKind::Extension
                )
        })
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
            "plan", "apply", "diff", "generate", "sync", "run", "build", "test", "lint", "format",
            "graph", "clean", "migrate", "upgrade", "context", "config", "version",
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
        for path in [
            "init", "add", "remove", "rename", "move", "generate", "sync",
        ] {
            assert!(is_plan_backed(path), "`{path}` should be plan-backed");
            assert!(supports_dry_run(path), "`{path}` should support --dry-run");
        }
    }

    #[test]
    fn placeholder_metadata_matches_command_contract() {
        assert!(is_mutating_command("add"));
        assert!(is_mutating_command("policy waive"));
        assert!(is_mutating_command("workpacket plan"));
        assert!(!is_mutating_command("list"));
        assert!(!is_mutating_command("policy check"));
        assert!(!is_mutating_command("docs check"));
    }

    #[test]
    fn read_only_commands_are_not_plan_backed() {
        for path in ["list", "inspect", "check", "doctor", "diff", "version"] {
            assert!(!is_plan_backed(path), "`{path}` should not be plan-backed");
            assert!(
                !supports_dry_run(path),
                "`{path}` should not support --dry-run"
            );
        }
    }
}
