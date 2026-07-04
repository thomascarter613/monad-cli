#!/usr/bin/env python3
from pathlib import Path
import shutil
import sys


ROOT = Path(__file__).resolve().parent
CLI_RS = ROOT / "crates/monad-cli/src/lib.rs"
TEST_RS = ROOT / "crates/monad-cli/tests/diff_command.rs"


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

    fail("could not find insertion point for diff command code")


def main() -> None:
    if not (ROOT / "monad.toml").is_file():
        fail("monad.toml not found. Save and run this file from the repo root.")

    if not CLI_RS.is_file():
        fail(f"{CLI_RS.relative_to(ROOT)} not found")

    backup = CLI_RS.with_suffix(CLI_RS.suffix + ".bak.layer-0002-hotfix-0023")
    shutil.copyfile(CLI_RS, backup)

    text = CLI_RS.read_text()

    text = insert_once_after_marker(
        text,
        'Some(("diff", sub)) => emit_diff(sub, json),',
        [
            'Some(("config", sub)) => emit_config(sub, json),',
            'Some(("graph", sub)) => emit_graph(sub, json),',
            'Some(("list", sub)) => emit_list(sub, json),',
            'Some(("inspect", sub)) => emit_inspect(sub, json),',
            'Some(("doctor", sub)) => emit_doctor(sub, json),',
            'Some(("check", sub)) => emit_check(sub, json),',
            'Some(("version", sub)) => emit_version(sub, json),',
        ],
    )

    diff_cmd = r'''fn diff_cmd() -> Command {
    Command::new("diff")
        .about("Compare Monad files, defaulting to monad.toml versus workspace.toml compatibility drift")
        .arg(
            arg("left", "Left/canonical file")
                .required(false)
                .default_value("monad.toml"),
        )
        .arg(
            arg("right", "Right/compatibility file")
                .required(false)
                .default_value("workspace.toml"),
        )
        .arg(flag("strict", "Exit with failure when differences are detected"))
        .arg(fmt_arg().value_parser(["text", "json", "markdown"]))
}'''

    text = replace_function(text, "diff_cmd", diff_cmd)

    diff_code = r'''
#[derive(Debug, Clone, Serialize)]
struct DiffLineChange {
    line: usize,
    left: Option<String>,
    right: Option<String>,
    kind: &'static str,
}

#[derive(Debug, Serialize)]
struct DiffCommandOutput {
    schema_version: u32,
    command: &'static str,
    status: &'static str,
    left: String,
    right: String,
    strict: bool,
    did_mutate: bool,
    left_exists: bool,
    right_exists: bool,
    equal: bool,
    left_bytes: Option<u64>,
    right_bytes: Option<u64>,
    changed_line_count: usize,
    compatibility_mirror_detected: bool,
    changes: Vec<DiffLineChange>,
    notes: Vec<String>,
}

fn emit_diff(matches: &ArgMatches, json: bool) -> Result<(), String> {
    let left = matches
        .get_one::<String>("left")
        .map(String::as_str)
        .unwrap_or("monad.toml");

    let right = matches
        .get_one::<String>("right")
        .map(String::as_str)
        .unwrap_or("workspace.toml");

    let strict = matches.get_flag("strict");

    let format = matches
        .get_one::<String>("format")
        .map(String::as_str)
        .unwrap_or("text");

    let output = build_diff_output(left, right, strict);
    let rendered = render_diff_output(&output, if json { "json" } else { format })?;

    println!("{rendered}");

    if strict && !output.equal {
        Err(format!(
            "diff detected differences between `{}` and `{}`",
            output.left, output.right
        ))
    } else if !output.left_exists || !output.right_exists {
        Err(format!(
            "diff could not read both files: left_exists={} right_exists={}",
            output.left_exists, output.right_exists
        ))
    } else {
        Ok(())
    }
}

fn build_diff_output(left: &str, right: &str, strict: bool) -> DiffCommandOutput {
    let left_path = std::path::Path::new(left);
    let right_path = std::path::Path::new(right);

    let left_contents = std::fs::read_to_string(left_path).ok();
    let right_contents = std::fs::read_to_string(right_path).ok();

    let left_exists = left_path.is_file();
    let right_exists = right_path.is_file();

    let left_bytes = std::fs::metadata(left_path).ok().map(|metadata| metadata.len());
    let right_bytes = std::fs::metadata(right_path).ok().map(|metadata| metadata.len());

    let compatibility_mirror_detected = right == "workspace.toml"
        && right_contents
            .as_deref()
            .map(|contents| {
                let lowered = contents.to_lowercase();
                lowered.contains("compatibility")
                    || lowered.contains("mirror")
                    || lowered.contains("monad.toml")
            })
            .unwrap_or(false);

    let changes = match (&left_contents, &right_contents) {
        (Some(left_contents), Some(right_contents)) => diff_line_changes(left_contents, right_contents),
        (Some(left_contents), None) => left_contents
            .lines()
            .enumerate()
            .map(|(index, line)| DiffLineChange {
                line: index + 1,
                left: Some(line.to_string()),
                right: None,
                kind: "right_missing",
            })
            .collect(),
        (None, Some(right_contents)) => right_contents
            .lines()
            .enumerate()
            .map(|(index, line)| DiffLineChange {
                line: index + 1,
                left: None,
                right: Some(line.to_string()),
                kind: "left_missing",
            })
            .collect(),
        (None, None) => Vec::new(),
    };

    let equal = left_exists && right_exists && left_contents == right_contents;
    let changed_line_count = changes.len();

    let status = if !left_exists || !right_exists {
        "missing_file"
    } else if equal {
        "equal"
    } else {
        "different"
    };

    let mut notes = vec![
        "`monad diff` is read-only and does not mutate either file.".to_string(),
        "By default it compares monad.toml against workspace.toml, where monad.toml remains canonical.".to_string(),
    ];

    if compatibility_mirror_detected {
        notes.push("workspace.toml appears to identify itself as a compatibility mirror.".to_string());
    } else if right == "workspace.toml" && right_exists {
        notes.push("workspace.toml exists but does not clearly identify itself as a compatibility mirror.".to_string());
    }

    if !equal && left_exists && right_exists {
        notes.push("Differences are informational unless --strict is provided.".to_string());
    }

    DiffCommandOutput {
        schema_version: monad_core::MANIFEST_SCHEMA_VERSION,
        command: "diff",
        status,
        left: left.to_string(),
        right: right.to_string(),
        strict,
        did_mutate: false,
        left_exists,
        right_exists,
        equal,
        left_bytes,
        right_bytes,
        changed_line_count,
        compatibility_mirror_detected,
        changes,
        notes,
    }
}

fn diff_line_changes(left: &str, right: &str) -> Vec<DiffLineChange> {
    let left_lines = left.lines().collect::<Vec<_>>();
    let right_lines = right.lines().collect::<Vec<_>>();
    let max = left_lines.len().max(right_lines.len());
    let mut changes = Vec::new();

    for index in 0..max {
        let left_line = left_lines.get(index).copied();
        let right_line = right_lines.get(index).copied();

        if left_line == right_line {
            continue;
        }

        let kind = match (left_line, right_line) {
            (Some(_), Some(_)) => "changed",
            (Some(_), None) => "removed",
            (None, Some(_)) => "added",
            (None, None) => "unchanged",
        };

        changes.push(DiffLineChange {
            line: index + 1,
            left: left_line.map(ToOwned::to_owned),
            right: right_line.map(ToOwned::to_owned),
            kind,
        });
    }

    changes
}

fn render_diff_output(output: &DiffCommandOutput, format: &str) -> Result<String, String> {
    match format {
        "json" => serde_json::to_string_pretty(output).map_err(|error| error.to_string()),
        "markdown" => Ok(render_diff_markdown(output)),
        "text" => Ok(render_diff_text(output)),
        other => Err(format!("unsupported diff output format `{other}`")),
    }
}

fn render_diff_text(output: &DiffCommandOutput) -> String {
    let mut rendered = String::new();

    rendered.push_str("Monad Diff\n");
    rendered.push_str("==========\n\n");
    rendered.push_str(&format!("status: {}\n", output.status));
    rendered.push_str(&format!("left: {}\n", output.left));
    rendered.push_str(&format!("right: {}\n", output.right));
    rendered.push_str(&format!("strict: {}\n", output.strict));
    rendered.push_str(&format!("did mutate: {}\n", output.did_mutate));
    rendered.push_str(&format!("left exists: {}\n", output.left_exists));
    rendered.push_str(&format!("right exists: {}\n", output.right_exists));
    rendered.push_str(&format!("equal: {}\n", output.equal));
    rendered.push_str(&format!(
        "left bytes: {}\n",
        output
            .left_bytes
            .map(|bytes| bytes.to_string())
            .unwrap_or_else(|| "n/a".to_string())
    ));
    rendered.push_str(&format!(
        "right bytes: {}\n",
        output
            .right_bytes
            .map(|bytes| bytes.to_string())
            .unwrap_or_else(|| "n/a".to_string())
    ));
    rendered.push_str(&format!(
        "compatibility mirror detected: {}\n",
        output.compatibility_mirror_detected
    ));
    rendered.push_str(&format!("changed lines: {}\n", output.changed_line_count));

    if !output.changes.is_empty() {
        rendered.push_str("\nchanges:\n");

        for change in output.changes.iter().take(40) {
            rendered.push_str(&format!(
                "  - line {} [{}]\n      left: {}\n      right: {}\n",
                change.line,
                change.kind,
                change.left.as_deref().unwrap_or("<missing>"),
                change.right.as_deref().unwrap_or("<missing>")
            ));
        }

        if output.changes.len() > 40 {
            rendered.push_str(&format!(
                "  - ... {} additional changed line(s) omitted\n",
                output.changes.len() - 40
            ));
        }
    }

    rendered.push_str("\nnotes:\n");
    for note in &output.notes {
        rendered.push_str(&format!("  - {note}\n"));
    }

    rendered
}

fn render_diff_markdown(output: &DiffCommandOutput) -> String {
    let mut rendered = String::new();

    rendered.push_str("# Monad Diff\n\n");
    rendered.push_str(&format!("- **Status:** `{}`\n", output.status));
    rendered.push_str(&format!("- **Left:** `{}`\n", output.left));
    rendered.push_str(&format!("- **Right:** `{}`\n", output.right));
    rendered.push_str(&format!("- **Strict:** `{}`\n", output.strict));
    rendered.push_str(&format!("- **Did mutate:** `{}`\n", output.did_mutate));
    rendered.push_str(&format!("- **Left exists:** `{}`\n", output.left_exists));
    rendered.push_str(&format!("- **Right exists:** `{}`\n", output.right_exists));
    rendered.push_str(&format!("- **Equal:** `{}`\n", output.equal));
    rendered.push_str(&format!(
        "- **Compatibility mirror detected:** `{}`\n",
        output.compatibility_mirror_detected
    ));
    rendered.push_str(&format!("- **Changed lines:** `{}`\n\n", output.changed_line_count));

    if !output.changes.is_empty() {
        rendered.push_str("## Changes\n\n");
        rendered.push_str("| Line | Kind | Left | Right |\n");
        rendered.push_str("|---:|---|---|---|\n");

        for change in output.changes.iter().take(40) {
            rendered.push_str(&format!(
                "| {} | `{}` | `{}` | `{}` |\n",
                change.line,
                change.kind,
                change
                    .left
                    .as_deref()
                    .unwrap_or("<missing>")
                    .replace('|', "\\|"),
                change
                    .right
                    .as_deref()
                    .unwrap_or("<missing>")
                    .replace('|', "\\|")
            ));
        }

        if output.changes.len() > 40 {
            rendered.push_str(&format!(
                "|  | `omitted` | `{} additional changed line(s)` |  |\n",
                output.changes.len() - 40
            ));
        }

        rendered.push('\n');
    }

    rendered.push_str("## Notes\n\n");
    for note in &output.notes {
        rendered.push_str(&format!("- {note}\n"));
    }

    rendered
}

'''

    text = insert_code_once(
        text,
        "struct DiffLineChange",
        diff_code,
        [
            "\n#[derive(Debug, Clone, Serialize)]\nstruct ConfigEntry",
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
        r'''use std::fs;
use std::process::Command;
use std::time::{SystemTime, UNIX_EPOCH};

fn temp_dir(name: &str) -> std::path::PathBuf {
    let nanos = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .expect("clock should be after unix epoch")
        .as_nanos();

    let mut path = std::env::temp_dir();
    path.push(format!("monad-diff-test-{}-{nanos}-{name}", std::process::id()));
    fs::create_dir_all(&path).expect("should create temp dir");
    path
}

#[test]
fn diff_defaults_to_monad_and_workspace_toml() {
    let root = temp_dir("default");

    fs::write(root.join("monad.toml"), "[workspace]\nname = \"demo\"\n")
        .expect("should write monad.toml");
    fs::write(
        root.join("workspace.toml"),
        "# compatibility mirror of monad.toml\n[workspace]\nname = \"demo\"\n",
    )
    .expect("should write workspace.toml");

    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .current_dir(&root)
        .arg("diff")
        .output()
        .expect("monad diff should run");

    let _ = fs::remove_dir_all(&root);

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("Monad Diff"));
    assert!(stdout.contains("left: monad.toml"));
    assert!(stdout.contains("right: workspace.toml"));
    assert!(stdout.contains("did mutate: false"));
    assert!(stdout.contains("compatibility mirror detected: true"));
}

#[test]
fn diff_reports_equal_files() {
    let root = temp_dir("equal");
    let left = root.join("left.toml");
    let right = root.join("right.toml");

    fs::write(&left, "[workspace]\nname = \"demo\"\n").expect("should write left");
    fs::write(&right, "[workspace]\nname = \"demo\"\n").expect("should write right");

    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args([
            "diff",
            left.to_str().expect("left path should be utf-8"),
            right.to_str().expect("right path should be utf-8"),
        ])
        .output()
        .expect("monad diff should run");

    let _ = fs::remove_dir_all(&root);

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("status: equal"));
    assert!(stdout.contains("equal: true"));
    assert!(stdout.contains("changed lines: 0"));
}

#[test]
fn diff_reports_different_files_as_json() {
    let root = temp_dir("json");
    let left = root.join("left.toml");
    let right = root.join("right.toml");

    fs::write(&left, "[workspace]\nname = \"left\"\n").expect("should write left");
    fs::write(&right, "[workspace]\nname = \"right\"\n").expect("should write right");

    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args([
            "diff",
            left.to_str().expect("left path should be utf-8"),
            right.to_str().expect("right path should be utf-8"),
            "--format",
            "json",
        ])
        .output()
        .expect("monad diff --format json should run");

    let _ = fs::remove_dir_all(&root);

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains(r#""command": "diff""#));
    assert!(stdout.contains(r#""status": "different""#));
    assert!(stdout.contains(r#""equal": false"#));
    assert!(stdout.contains(r#""did_mutate": false"#));
    assert!(stdout.contains(r#""changed_line_count": 1"#));
}

#[test]
fn diff_reports_markdown() {
    let root = temp_dir("markdown");
    let left = root.join("left.toml");
    let right = root.join("right.toml");

    fs::write(&left, "a\n").expect("should write left");
    fs::write(&right, "b\n").expect("should write right");

    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args([
            "diff",
            left.to_str().expect("left path should be utf-8"),
            right.to_str().expect("right path should be utf-8"),
            "--format",
            "markdown",
        ])
        .output()
        .expect("monad diff --format markdown should run");

    let _ = fs::remove_dir_all(&root);

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("# Monad Diff"));
    assert!(stdout.contains("## Changes"));
    assert!(stdout.contains("| Line | Kind | Left | Right |"));
}

#[test]
fn diff_strict_fails_when_files_differ() {
    let root = temp_dir("strict");
    let left = root.join("left.toml");
    let right = root.join("right.toml");

    fs::write(&left, "a\n").expect("should write left");
    fs::write(&right, "b\n").expect("should write right");

    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args([
            "diff",
            left.to_str().expect("left path should be utf-8"),
            right.to_str().expect("right path should be utf-8"),
            "--strict",
        ])
        .output()
        .expect("monad diff --strict should run and fail");

    let _ = fs::remove_dir_all(&root);

    assert!(!output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);
    let stderr = String::from_utf8_lossy(&output.stderr);

    assert!(stdout.contains("status: different"));
    assert!(stderr.contains("diff detected differences"));
}
'''
    )

    print("Applied layer-0002-hotfix-0023-implement-monad-diff")
    print()
    print("Changed:")
    print("  - crates/monad-cli/src/lib.rs")
    print("  - crates/monad-cli/tests/diff_command.rs")
    print("Backup:")
    print(f"  - {backup.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
