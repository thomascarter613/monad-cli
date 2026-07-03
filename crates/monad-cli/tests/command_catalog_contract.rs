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
    assert!(!monad_core::command_catalog::is_approved_command(
        "graph everything"
    ));
}
