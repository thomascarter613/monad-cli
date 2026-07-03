#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"
cd "$ROOT"

if [ ! -f "monad.toml" ]; then
  echo "ERROR: monad.toml not found. Run from repo root." >&2
  exit 1
fi

if [ ! -f "crates/monad-cli/src/lib.rs" ]; then
  echo "ERROR: crates/monad-cli/src/lib.rs not found." >&2
  exit 1
fi

if [ ! -f "crates/monad-core/src/command_catalog.rs" ]; then
  echo "ERROR: crates/monad-core/src/command_catalog.rs not found. Run the command catalog layer first." >&2
  exit 1
fi

cp crates/monad-cli/src/lib.rs crates/monad-cli/src/lib.rs.bak.layer-0002-hotfix-0013
cp crates/monad-core/src/command_catalog.rs crates/monad-core/src/command_catalog.rs.bak.layer-0002-hotfix-0013

python3 - <<'PY'
from pathlib import Path
import re

catalog_path = Path("crates/monad-core/src/command_catalog.rs")
catalog = catalog_path.read_text()

if "pub fn is_mutating_command" not in catalog:
    insertion = r'''
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
'''
    marker = "\n#[cfg(test)]"
    if marker not in catalog:
        raise SystemExit("ERROR: could not find #[cfg(test)] marker in command_catalog.rs")
    catalog = catalog.replace(marker, insertion + marker, 1)

if "placeholder_metadata_matches_command_contract" not in catalog:
    test_marker = "    #[test]\n    fn read_only_commands_are_not_plan_backed()"
    if test_marker not in catalog:
        raise SystemExit("ERROR: could not find command catalog test insertion point")
    extra_test = r'''
    #[test]
    fn placeholder_metadata_matches_command_contract() {
        assert!(is_mutating_command("add"));
        assert!(is_mutating_command("policy waive"));
        assert!(is_mutating_command("workpacket plan"));
        assert!(!is_mutating_command("list"));
        assert!(!is_mutating_command("policy check"));
        assert!(!is_mutating_command("docs check"));
    }

'''
    catalog = catalog.replace(test_marker, extra_test + test_marker, 1)

catalog_path.write_text(catalog)

cli_path = Path("crates/monad-cli/src/lib.rs")
text = cli_path.read_text()

old_call = '''Some((command, sub)) => {
            emit_placeholder(json, command_path(command, sub), mutates(command))
        }'''
new_call = '''Some((command, sub)) => {
            let path = command_path(command, sub);
            emit_placeholder(json, &path)
        }'''

if old_call in text:
    text = text.replace(old_call, new_call, 1)
else:
    # Try a whitespace-tolerant replacement.
    text, count = re.subn(
        r'''Some\(\(command,\s*sub\)\)\s*=>\s*\{\s*emit_placeholder\(\s*json,\s*command_path\(\s*command,\s*sub\s*\),\s*mutates\(\s*command\s*\)\s*\)\s*\}''',
        new_call,
        text,
        count=1,
        flags=re.S,
    )
    if count != 1:
        raise SystemExit("ERROR: could not replace placeholder dispatch call in monad-cli/src/lib.rs")

def replace_function(source: str, function_name: str, replacement: str) -> str:
    needle = f"fn {function_name}"
    start = source.find(needle)
    if start == -1:
        raise SystemExit(f"ERROR: could not find function `{function_name}`")

    brace = source.find("{", start)
    if brace == -1:
        raise SystemExit(f"ERROR: could not find opening brace for `{function_name}`")

    depth = 0
    for index in range(brace, len(source)):
        char = source[index]
        if char == "{":
            depth += 1
        elif char == "}":
            depth -= 1
            if depth == 0:
                end = index + 1
                return source[:start] + replacement + source[end:]

    raise SystemExit(f"ERROR: could not find end of `{function_name}`")

replacement = r'''#[derive(Debug, Serialize)]
struct PlaceholderOutput {
    command: String,
    status: &'static str,
    implemented: bool,
    mutating: bool,
    plan_backed: bool,
    supports_dry_run: bool,
    message: String,
    next: String,
}

fn emit_placeholder(json: bool, path: &str) -> Result<(), String> {
    let output = PlaceholderOutput {
        command: path.to_string(),
        status: "placeholder",
        implemented: false,
        mutating: monad_core::command_catalog::is_mutating_command(path),
        plan_backed: monad_core::command_catalog::is_plan_backed(path),
        supports_dry_run: monad_core::command_catalog::supports_dry_run(path),
        message: format!(
            "`monad {path}` is part of the approved WP-0001 command surface, but its full behavior is not implemented yet."
        ),
        next: "Future work packets will replace this placeholder with plan-backed command behavior, validation, and real repository changes.".to_string(),
    };

    if json {
        println!(
            "{}",
            serde_json::to_string_pretty(&output).map_err(|error| error.to_string())?
        );
    } else {
        println!("command: {}", output.command);
        println!("status: {}", output.status);
        println!("implemented: {}", output.implemented);
        println!("mutating: {}", output.mutating);
        println!("plan-backed: {}", output.plan_backed);
        println!("supports --dry-run: {}", output.supports_dry_run);
        println!();
        println!("{}", output.message);
        println!("{}", output.next);
    }

    Ok(())
}
'''

text = replace_function(text, "emit_placeholder", replacement)

cli_path.write_text(text)
PY

mkdir -p crates/monad-cli/tests

cat > crates/monad-cli/tests/placeholder_metadata.rs <<'RS'
use std::process::Command;

#[test]
fn placeholder_text_output_reports_plan_metadata_for_add() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["add", "app", "web", "--dry-run"])
        .output()
        .expect("monad add placeholder should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("command: add"));
    assert!(stdout.contains("status: placeholder"));
    assert!(stdout.contains("implemented: false"));
    assert!(stdout.contains("mutating: true"));
    assert!(stdout.contains("plan-backed: true"));
    assert!(stdout.contains("supports --dry-run: true"));
}

#[test]
fn placeholder_text_output_reports_read_only_metadata_for_inspect() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .arg("inspect")
        .output()
        .expect("monad inspect placeholder should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("command: inspect"));
    assert!(stdout.contains("status: placeholder"));
    assert!(stdout.contains("implemented: false"));
    assert!(stdout.contains("mutating: false"));
    assert!(stdout.contains("plan-backed: false"));
    assert!(stdout.contains("supports --dry-run: false"));
}

#[test]
fn placeholder_json_output_reports_command_metadata() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["--json", "add", "app", "web", "--dry-run"])
        .output()
        .expect("monad add --json placeholder should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains(r#""command": "add""#));
    assert!(stdout.contains(r#""status": "placeholder""#));
    assert!(stdout.contains(r#""implemented": false"#));
    assert!(stdout.contains(r#""mutating": true"#));
    assert!(stdout.contains(r#""plan_backed": true"#));
    assert!(stdout.contains(r#""supports_dry_run": true"#));
}
RS

cargo fmt --all

echo
echo "Applied layer-0002-hotfix-0013-placeholder-command-metadata"
echo
echo "Added:"
echo "  - command catalog mutating metadata helper"
echo "  - richer CLI placeholder output"
echo "  - placeholder metadata smoke tests"
