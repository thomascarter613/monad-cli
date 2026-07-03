#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"
cd "$ROOT"

if [ ! -f "monad.toml" ]; then
  echo "ERROR: monad.toml not found. Run from repo root." >&2
  exit 1
fi

if [ ! -f "Cargo.toml" ]; then
  echo "ERROR: Cargo.toml not found. WP-0001 requires a real Cargo workspace." >&2
  exit 1
fi

MAIN_RS="crates/monad-cli/src/main.rs"
LIB_RS="crates/monad-cli/src/lib.rs"
SMOKE_RS="crates/monad-cli/tests/smoke.rs"
SURFACE_RS="crates/monad-cli/tests/command_surface.rs"

if [ ! -f "$MAIN_RS" ]; then
  echo "ERROR: $MAIN_RS not found." >&2
  exit 1
fi

if [ -f "$LIB_RS" ]; then
  echo "ERROR: $LIB_RS already exists. Refusing to overwrite." >&2
  exit 1
fi

mkdir -p "crates/monad-cli/tests"

python3 - <<'PY'
from pathlib import Path

main_path = Path("crates/monad-cli/src/main.rs")
lib_path = Path("crates/monad-cli/src/lib.rs")
smoke_path = Path("crates/monad-cli/tests/smoke.rs")
surface_path = Path("crates/monad-cli/tests/command_surface.rs")

text = main_path.read_text()

needle = "fn main() -> std::process::ExitCode {"
if needle not in text:
    raise SystemExit("ERROR: could not find `fn main() -> std::process::ExitCode {` in main.rs")

text = text.replace(needle, "pub fn main_entry() -> std::process::ExitCode {", 1)

old_guard = '''println!("monad\\n\\nDefault scope: @monad\\n\\nUsage: monad <COMMAND>\\n\\nRun `monad --help` for full command help.");
        std::process::exit(0);'''

new_guard = '''let mut command = build_cli();
        if let Err(error) = command.print_help() {
            eprintln!("error: {error}");
            return std::process::ExitCode::from(1);
        }
        println!("\\n\\nDefault scope: @monad");
        return std::process::ExitCode::SUCCESS;'''

if old_guard in text:
    text = text.replace(old_guard, new_guard, 1)
else:
    print("WARN: manual no-args banner was not found exactly; leaving existing no-args body unchanged.")

text = text.replace("let matches = cli().get_matches();", "let matches = build_cli().get_matches();", 1)

cli_needle = "fn cli() -> Command {"
if cli_needle not in text:
    raise SystemExit("ERROR: could not find `fn cli() -> Command {` in transformed lib text")

text = text.replace(
    cli_needle,
    '''pub fn build_cli() -> Command {
    cli()
}

fn cli() -> Command {''',
    1,
)

lib_path.write_text(text)

main_path.write_text('''fn main() -> std::process::ExitCode {
    monad_cli::main_entry()
}
''')

if smoke_path.exists():
    smoke = smoke_path.read_text()
    smoke = smoke.replace(
        'assert!(stdout.contains("@monad"));',
        'assert!(stdout.contains("Default scope: @monad"));',
    )
    smoke_path.write_text(smoke)

surface_path.write_text(r'''use std::collections::BTreeSet;

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
        assert!(paths.contains(expected), "missing `{expected}` command path");
    }
}
''')
PY

cargo fmt --all

echo
echo "Applied layer-0002-hotfix-0004-normalize-monad-cli-lib-bin"
echo
echo "Changed:"
echo "  - crates/monad-cli/src/lib.rs now owns CLI construction, dispatch, and main_entry()"
echo "  - crates/monad-cli/src/main.rs is now a thin binary wrapper"
echo "  - no-args invocation now prints Clap-generated root help plus Default scope: @monad"
echo "  - command surface integration tests added"
