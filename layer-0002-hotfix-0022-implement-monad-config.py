#!/usr/bin/env python3
from pathlib import Path
import shutil
import sys


ROOT = Path(__file__).resolve().parent
CLI_RS = ROOT / "crates/monad-cli/src/lib.rs"
TEST_RS = ROOT / "crates/monad-cli/tests/config_command.rs"


def fail(message: str) -> None:
    print(f"ERROR: {message}", file=sys.stderr)
    raise SystemExit(1)


def replace_function(source: str, function_name: str, replacement: str) -> str:
    needle = f"fn {function_name}"
    start = source.find(needle)

    if start == -1:
        fail(f"could not find function `{function_name}`")

    brace = source.find("{", start)

    if brace == -1:
        fail(f"could not find opening brace for `{function_name}`")

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

    fail(f"could not find end of `{function_name}`")


def insert_once_after_marker(source: str, line_to_insert: str, markers: list[str]) -> str:
    if line_to_insert in source:
        return source

    for marker in markers:
        if marker in source:
            return source.replace(marker, marker + "\n        " + line_to_insert, 1)

    fail("could not find dispatch insertion point")


def insert_code_once(source: str, unique_needle: str, code: str, markers: list[str]) -> str:
    if unique_needle in source:
        return source

    for marker in markers:
        if marker in source:
            return source.replace(marker, "\n" + code + marker, 1)

    fail("could not find insertion point for config command code")


def main() -> None:
    if not (ROOT / "monad.toml").is_file():
        fail("monad.toml not found. Save and run this file from the repo root.")

    if not CLI_RS.is_file():
        fail(f"{CLI_RS.relative_to(ROOT)} not found")

    backup = CLI_RS.with_suffix(CLI_RS.suffix + ".bak.layer-0002-hotfix-0022")
    shutil.copyfile(CLI_RS, backup)

    text = CLI_RS.read_text()

    text = insert_once_after_marker(
        text,
        'Some(("config", sub)) => emit_config(sub, json),',
        [
            'Some(("graph", sub)) => emit_graph(sub, json),',
            'Some(("list", sub)) => emit_list(sub, json),',
            'Some(("inspect", sub)) => emit_inspect(sub, json),',
            'Some(("doctor", sub)) => emit_doctor(sub, json),',
            'Some(("check", sub)) => emit_check(sub, json),',
            'Some(("version", sub)) => emit_version(sub, json),',
        ],
    )

    config_cmd = r'''fn config_cmd() -> Command {
    Command::new("config")
        .about("Show approved Monad defaults, schema versions, manifest paths, and runtime configuration")
        .arg(fmt_arg().value_parser(["text", "json", "markdown"]))
}'''

    text = replace_function(text, "config_cmd", config_cmd)

    config_code = r'''
#[derive(Debug, Clone, Serialize)]
struct ConfigEntry {
    key: String,
    value: String,
    source: &'static str,
    description: String,
}

#[derive(Debug, Serialize)]
struct ConfigCommandOutput {
    schema_version: u32,
    command: &'static str,
    status: &'static str,
    did_mutate: bool,
    entry_count: usize,
    entries: Vec<ConfigEntry>,
    notes: Vec<String>,
}

fn emit_config(matches: &ArgMatches, json: bool) -> Result<(), String> {
    let format = matches
        .get_one::<String>("format")
        .map(String::as_str)
        .unwrap_or("text");

    let output = build_config_output();
    let rendered = render_config_output(&output, if json { "json" } else { format })?;

    println!("{rendered}");

    Ok(())
}

fn build_config_output() -> ConfigCommandOutput {
    let defaults = monad_core::RuntimeDefaults::monad();

    let entries = vec![
        ConfigEntry {
            key: "cli.name".to_string(),
            value: defaults.cli_name.to_string(),
            source: "approved-default",
            description: "Canonical CLI binary name.".to_string(),
        },
        ConfigEntry {
            key: "manifest.canonical".to_string(),
            value: defaults.canonical_manifest.to_string(),
            source: "approved-default",
            description: "Canonical Monad source-of-truth manifest.".to_string(),
        },
        ConfigEntry {
            key: "manifest.compatibility".to_string(),
            value: defaults.compatibility_manifest.to_string(),
            source: "approved-default",
            description: "Generated compatibility mirror of monad.toml.".to_string(),
        },
        ConfigEntry {
            key: "lockfile".to_string(),
            value: defaults.lockfile.to_string(),
            source: "approved-default",
            description: "Monad lockfile path.".to_string(),
        },
        ConfigEntry {
            key: "state.dir".to_string(),
            value: defaults.state_dir.to_string(),
            source: "approved-default",
            description: "Monad local state directory.".to_string(),
        },
        ConfigEntry {
            key: "package_manager.default".to_string(),
            value: defaults.package_manager.to_string(),
            source: "approved-default",
            description: "Default package manager for generated JavaScript/TypeScript surfaces.".to_string(),
        },
        ConfigEntry {
            key: "scope.default".to_string(),
            value: defaults.scope.to_string(),
            source: "approved-default",
            description: "Default package scope for generated package names.".to_string(),
        },
        ConfigEntry {
            key: "init.preset.default".to_string(),
            value: defaults.init_preset.to_string(),
            source: "approved-default",
            description: "Default init preset.".to_string(),
        },
        ConfigEntry {
            key: "schema.manifest.version".to_string(),
            value: monad_core::MANIFEST_SCHEMA_VERSION.to_string(),
            source: "monad-core",
            description: "Manifest schema version exposed by monad-core.".to_string(),
        },
        ConfigEntry {
            key: "schema.plan.version".to_string(),
            value: monad_core::PLAN_SCHEMA_VERSION.to_string(),
            source: "monad-core",
            description: "Plan schema version exposed by monad-core.".to_string(),
        },
        ConfigEntry {
            key: "behavior.mutating_commands.plan_backed".to_string(),
            value: "true".to_string(),
            source: "approved-behavior",
            description: "Mutating commands are expected to be plan-backed.".to_string(),
        },
        ConfigEntry {
            key: "behavior.mutating_commands.dry_run".to_string(),
            value: "true".to_string(),
            source: "approved-behavior",
            description: "Mutating commands should support --dry-run when safe.".to_string(),
        },
        ConfigEntry {
            key: "behavior.ai.optional".to_string(),
            value: "true".to_string(),
            source: "approved-behavior",
            description: "Monad is AI-ready but AI-optional.".to_string(),
        },
        ConfigEntry {
            key: "behavior.local_first".to_string(),
            value: "true".to_string(),
            source: "approved-behavior",
            description: "Monad is local-first and single-binary oriented.".to_string(),
        },
    ];

    ConfigCommandOutput {
        schema_version: monad_core::MANIFEST_SCHEMA_VERSION,
        command: "config",
        status: "implemented",
        did_mutate: false,
        entry_count: entries.len(),
        entries,
        notes: vec![
            "`monad config` is read-only in WP-0001 and reports approved defaults rather than editing configuration.".to_string(),
            "monad.toml remains canonical; workspace.toml is only a generated compatibility mirror.".to_string(),
            "Future work packets can add config get/set, validation, layered config sources, and environment overrides.".to_string(),
        ],
    }
}

fn render_config_output(output: &ConfigCommandOutput, format: &str) -> Result<String, String> {
    match format {
        "json" => serde_json::to_string_pretty(output).map_err(|error| error.to_string()),
        "markdown" => Ok(render_config_markdown(output)),
        "text" => Ok(render_config_text(output)),
        other => Err(format!("unsupported config output format `{other}`")),
    }
}

fn render_config_text(output: &ConfigCommandOutput) -> String {
    let mut rendered = String::new();

    rendered.push_str("Monad Config\n");
    rendered.push_str("============\n\n");
    rendered.push_str(&format!("status: {}\n", output.status));
    rendered.push_str(&format!("did mutate: {}\n", output.did_mutate));
    rendered.push_str(&format!("entries: {}\n", output.entry_count));
    rendered.push_str("\nvalues:\n");

    for entry in &output.entries {
        rendered.push_str(&format!(
            "  - {} = {} ({}) — {}\n",
            entry.key, entry.value, entry.source, entry.description
        ));
    }

    rendered.push_str("\nnotes:\n");
    for note in &output.notes {
        rendered.push_str(&format!("  - {note}\n"));
    }

    rendered
}

fn render_config_markdown(output: &ConfigCommandOutput) -> String {
    let mut rendered = String::new();

    rendered.push_str("# Monad Config\n\n");
    rendered.push_str(&format!("- **Status:** `{}`\n", output.status));
    rendered.push_str(&format!("- **Did mutate:** `{}`\n", output.did_mutate));
    rendered.push_str(&format!("- **Entries:** `{}`\n\n", output.entry_count));

    rendered.push_str("## Values\n\n");
    rendered.push_str("| Key | Value | Source | Description |\n");
    rendered.push_str("|---|---|---|---|\n");

    for entry in &output.entries {
        rendered.push_str(&format!(
            "| `{}` | `{}` | `{}` | {} |\n",
            entry.key,
            entry.value,
            entry.source,
            entry.description.replace('|', "\\|")
        ));
    }

    rendered.push_str("\n## Notes\n\n");
    for note in &output.notes {
        rendered.push_str(&format!("- {note}\n"));
    }

    rendered
}

'''

    text = insert_code_once(
        text,
        "struct ConfigEntry",
        config_code,
        [
            "\n#[derive(Debug, Clone, Serialize)]\nstruct GraphCommandNode",
            "\n#[derive(Debug, Clone, Serialize)]\nstruct ListItem",
            "\n#[derive(Debug, Clone, Serialize)]\nstruct InspectManifest",
            "\n#[derive(Debug, Clone, Serialize)]\nstruct DoctorDiagnostic",
            "\n#[derive(Debug, Clone, Serialize)]\nstruct CheckFinding",
            "\n#[derive(Debug, Serialize)]\nstruct PlanCommandOutput",
            "\n#[derive(Debug, Serialize)]\nstruct PlaceholderOutput",
        ],
    )

    CLI_RS.write_text(text)

    TEST_RS.parent.mkdir(parents=True, exist_ok=True)
    TEST_RS.write_text(
        r'''use std::process::Command;

#[test]
fn config_outputs_text_defaults() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .arg("config")
        .output()
        .expect("monad config should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("Monad Config"));
    assert!(stdout.contains("status: implemented"));
    assert!(stdout.contains("did mutate: false"));
    assert!(stdout.contains("cli.name = monad"));
    assert!(stdout.contains("manifest.canonical = monad.toml"));
    assert!(stdout.contains("manifest.compatibility = workspace.toml"));
    assert!(stdout.contains("scope.default = @monad"));
    assert!(stdout.contains("package_manager.default = bun"));
}

#[test]
fn config_outputs_json_defaults() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["config", "--format", "json"])
        .output()
        .expect("monad config --format json should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains(r#""command": "config""#));
    assert!(stdout.contains(r#""status": "implemented""#));
    assert!(stdout.contains(r#""did_mutate": false"#));
    assert!(stdout.contains(r#""key": "manifest.canonical""#));
    assert!(stdout.contains(r#""value": "monad.toml""#));
    assert!(stdout.contains(r#""key": "scope.default""#));
    assert!(stdout.contains(r#""value": "@monad""#));
}

#[test]
fn config_outputs_markdown_defaults() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["config", "--format", "markdown"])
        .output()
        .expect("monad config --format markdown should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("# Monad Config"));
    assert!(stdout.contains("| Key | Value | Source | Description |"));
    assert!(stdout.contains("`manifest.canonical`"));
    assert!(stdout.contains("`monad.toml`"));
}

#[test]
fn global_json_flag_overrides_config_format() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["--json", "config"])
        .output()
        .expect("monad --json config should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains(r#""command": "config""#));
    assert!(stdout.contains(r#""entries""#));
}
'''
    )

    print("Applied layer-0002-hotfix-0022-implement-monad-config")
    print()
    print("Changed:")
    print("  - crates/monad-cli/src/lib.rs")
    print("  - crates/monad-cli/tests/config_command.rs")
    print(f"Backup:")
    print(f"  - {backup.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
