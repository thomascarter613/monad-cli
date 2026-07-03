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

fn command_paths() -> BTreeSet<String> {
    let command = monad_cli::build_cli();
    let mut paths = BTreeSet::new();
    collect_command_paths(&command, "", &mut paths);
    paths
}

#[test]
fn exposes_approved_top_level_v1_command_surface() {
    let paths = command_paths();

    for expected in [
        "init",
        "add",
        "remove",
        "rename",
        "move",
        "list",
        "inspect",
        "check",
        "doctor",
        "plan",
        "apply",
        "diff",
        "generate",
        "sync",
        "run",
        "build",
        "test",
        "lint",
        "format",
        "graph",
        "clean",
        "migrate",
        "upgrade",
        "context",
        "config",
        "version",
        "policy",
        "template",
        "pack",
        "plugin",
        "release",
        "docs",
        "adr",
        "workpacket",
    ] {
        assert!(paths.contains(expected), "missing `{expected}` command");
    }
}

#[test]
fn exposes_approved_namespaced_v1_command_surface() {
    let paths = command_paths();

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
        assert!(
            paths.contains(expected),
            "missing `{expected}` command path"
        );
    }
}
