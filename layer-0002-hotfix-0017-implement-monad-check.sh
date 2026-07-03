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

cp crates/monad-cli/src/lib.rs crates/monad-cli/src/lib.rs.bak.layer-0002-hotfix-0017

python3 - <<'PY'
from pathlib import Path

path = Path("crates/monad-cli/src/lib.rs")
text = path.read_text()

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

if 'Some(("check", sub)) => emit_check(sub, json),' not in text:
    marker = 'Some(("version", sub)) => emit_version(sub, json),'
    if marker not in text:
        raise SystemExit("ERROR: could not find version dispatch arm")
    text = text.replace(marker, marker + '\n        Some(("check", sub)) => emit_check(sub, json),', 1)

check_cmd = r'''fn check_cmd() -> Command {
    Command::new("check")
        .about("Run baseline Monad repository correctness checks")
        .arg(arg("target", "Target repository path").required(false))
        .arg(flag("strict", "Treat warnings as blocking failures"))
        .arg(flag("fix", "Preview safe fixes where supported; WP-0001 does not mutate"))
        .arg(fmt_arg().value_parser(["text", "json"]))
}'''

text = replace_function(text, "check_cmd", check_cmd)

insert_before_candidates = [
    '\n#[derive(Debug, Serialize)]\nstruct PlanCommandOutput',
    '\n#[derive(Debug, Serialize)]\nstruct ApplyCommandOutput',
    '\n#[derive(Debug, Serialize)]\nstruct PlaceholderOutput',
]

insert_before = None
for candidate in insert_before_candidates:
    if candidate in text:
        insert_before = candidate
        break

if insert_before is None:
    raise SystemExit("ERROR: could not find insertion point for check command code")

check_code = r'''
#[derive(Debug, Clone, Serialize)]
struct CheckFinding {
    severity: &'static str,
    code: &'static str,
    path: String,
    message: String,
}

impl CheckFinding {
    fn info(path: impl Into<String>, code: &'static str, message: impl Into<String>) -> Self {
        Self {
            severity: "info",
            code,
            path: path.into(),
            message: message.into(),
        }
    }

    fn warning(path: impl Into<String>, code: &'static str, message: impl Into<String>) -> Self {
        Self {
            severity: "warning",
            code,
            path: path.into(),
            message: message.into(),
        }
    }

    fn error(path: impl Into<String>, code: &'static str, message: impl Into<String>) -> Self {
        Self {
            severity: "error",
            code,
            path: path.into(),
            message: message.into(),
        }
    }
}

#[derive(Debug, Serialize)]
struct CheckCommandOutput {
    schema_version: u32,
    command: &'static str,
    status: &'static str,
    target: String,
    strict: bool,
    fix_requested: bool,
    did_mutate: bool,
    error_count: usize,
    warning_count: usize,
    info_count: usize,
    findings: Vec<CheckFinding>,
}

impl CheckCommandOutput {
    fn has_blocking_findings(&self) -> bool {
        self.error_count > 0 || (self.strict && self.warning_count > 0)
    }
}

fn emit_check(matches: &ArgMatches, json: bool) -> Result<(), String> {
    let target = matches
        .get_one::<String>("target")
        .map(String::as_str)
        .unwrap_or(".");

    let strict = matches.get_flag("strict");
    let fix_requested = matches.get_flag("fix");

    let format = matches
        .get_one::<String>("format")
        .map(String::as_str)
        .unwrap_or("text");

    let output = build_check_output(target, strict, fix_requested);
    let rendered = render_check_output(&output, if json { "json" } else { format })?;

    println!("{rendered}");

    if output.has_blocking_findings() {
        Err(format!(
            "check failed with {} error(s) and {} warning(s)",
            output.error_count, output.warning_count
        ))
    } else {
        Ok(())
    }
}

fn build_check_output(target: &str, strict: bool, fix_requested: bool) -> CheckCommandOutput {
    let root = std::path::Path::new(target);
    let mut findings = Vec::new();

    check_required_file(root, "monad.toml", "MONAD_CHECK_CANONICAL_MANIFEST", &mut findings);
    check_required_file(
        root,
        "workspace.toml",
        "MONAD_CHECK_COMPATIBILITY_MANIFEST",
        &mut findings,
    );
    check_required_file(root, "monad.lock", "MONAD_CHECK_LOCKFILE", &mut findings);
    check_required_dir(root, ".monad", "MONAD_CHECK_STATE_DIR", &mut findings);
    check_required_file(root, "Cargo.toml", "MONAD_CHECK_CARGO_WORKSPACE", &mut findings);

    check_workspace_manifest(root, &mut findings);
    check_manifest_relationship(root, &mut findings);
    check_wp_0001_crates(root, &mut findings);

    if fix_requested {
        findings.push(CheckFinding::warning(
            target,
            "MONAD_CHECK_FIX_NOT_IMPLEMENTED",
            "`monad check --fix` is accepted, but WP-0001 does not mutate the repository.",
        ));
    }

    let error_count = findings
        .iter()
        .filter(|finding| finding.severity == "error")
        .count();
    let warning_count = findings
        .iter()
        .filter(|finding| finding.severity == "warning")
        .count();
    let info_count = findings
        .iter()
        .filter(|finding| finding.severity == "info")
        .count();

    let status = if error_count > 0 || (strict && warning_count > 0) {
        "failed"
    } else {
        "passed"
    };

    CheckCommandOutput {
        schema_version: monad_core::MANIFEST_SCHEMA_VERSION,
        command: "check",
        status,
        target: target.to_string(),
        strict,
        fix_requested,
        did_mutate: false,
        error_count,
        warning_count,
        info_count,
        findings,
    }
}

fn check_required_file(
    root: &std::path::Path,
    relative: &str,
    code: &'static str,
    findings: &mut Vec<CheckFinding>,
) {
    let path = root.join(relative);
    if path.is_file() {
        findings.push(CheckFinding::info(
            relative,
            code,
            format!("required file `{relative}` exists"),
        ));
    } else {
        findings.push(CheckFinding::error(
            relative,
            code,
            format!("required file `{relative}` is missing"),
        ));
    }
}

fn check_required_dir(
    root: &std::path::Path,
    relative: &str,
    code: &'static str,
    findings: &mut Vec<CheckFinding>,
) {
    let path = root.join(relative);
    if path.is_dir() {
        findings.push(CheckFinding::info(
            relative,
            code,
            format!("required directory `{relative}` exists"),
        ));
    } else {
        findings.push(CheckFinding::error(
            relative,
            code,
            format!("required directory `{relative}` is missing"),
        ));
    }
}

fn check_workspace_manifest(root: &std::path::Path, findings: &mut Vec<CheckFinding>) {
    let cargo_toml = root.join("Cargo.toml");
    let Ok(contents) = std::fs::read_to_string(&cargo_toml) else {
        return;
    };

    if contents.contains("[workspace]") {
        findings.push(CheckFinding::info(
            "Cargo.toml",
            "MONAD_CHECK_CARGO_WORKSPACE_SECTION",
            "Cargo.toml declares a Cargo workspace",
        ));
    } else {
        findings.push(CheckFinding::error(
            "Cargo.toml",
            "MONAD_CHECK_CARGO_WORKSPACE_SECTION",
            "Cargo.toml does not declare a [workspace] section",
        ));
    }

    for member in [
        "crates/monad-cli",
        "crates/monad-core",
        "crates/monad-plans",
        "crates/monad-packs",
        "crates/monad-policy",
        "crates/monad-context",
        "crates/monad-graph",
    ] {
        if contents.contains(member) {
            findings.push(CheckFinding::info(
                "Cargo.toml",
                "MONAD_CHECK_CARGO_MEMBER_DECLARED",
                format!("Cargo workspace declares member `{member}`"),
            ));
        } else {
            findings.push(CheckFinding::error(
                "Cargo.toml",
                "MONAD_CHECK_CARGO_MEMBER_DECLARED",
                format!("Cargo workspace does not declare member `{member}`"),
            ));
        }
    }
}

fn check_manifest_relationship(root: &std::path::Path, findings: &mut Vec<CheckFinding>) {
    let monad_toml = root.join("monad.toml");
    let workspace_toml = root.join("workspace.toml");

    let Ok(monad_contents) = std::fs::read_to_string(&monad_toml) else {
        return;
    };

    let Ok(workspace_contents) = std::fs::read_to_string(&workspace_toml) else {
        return;
    };

    if workspace_contents.contains("monad.toml")
        || workspace_contents.to_lowercase().contains("compatibility")
        || workspace_contents.to_lowercase().contains("mirror")
    {
        findings.push(CheckFinding::info(
            "workspace.toml",
            "MONAD_CHECK_COMPATIBILITY_MIRROR_MARKER",
            "workspace.toml identifies itself as a compatibility mirror or references monad.toml",
        ));
    } else {
        findings.push(CheckFinding::warning(
            "workspace.toml",
            "MONAD_CHECK_COMPATIBILITY_MIRROR_MARKER",
            "workspace.toml exists but does not clearly identify itself as a compatibility mirror of monad.toml",
        ));
    }

    if !monad_contents.trim().is_empty() && !workspace_contents.trim().is_empty() {
        findings.push(CheckFinding::info(
            "monad.toml",
            "MONAD_CHECK_MANIFESTS_NON_EMPTY",
            "monad.toml and workspace.toml are non-empty",
        ));
    }
}

fn check_wp_0001_crates(root: &std::path::Path, findings: &mut Vec<CheckFinding>) {
    for crate_path in [
        "crates/monad-cli/Cargo.toml",
        "crates/monad-core/Cargo.toml",
        "crates/monad-plans/Cargo.toml",
        "crates/monad-packs/Cargo.toml",
        "crates/monad-policy/Cargo.toml",
        "crates/monad-context/Cargo.toml",
        "crates/monad-graph/Cargo.toml",
    ] {
        let path = root.join(crate_path);
        if path.is_file() {
            findings.push(CheckFinding::info(
                crate_path,
                "MONAD_CHECK_WP_0001_CRATE_MANIFEST",
                format!("WP-0001 crate manifest `{crate_path}` exists"),
            ));
        } else {
            findings.push(CheckFinding::error(
                crate_path,
                "MONAD_CHECK_WP_0001_CRATE_MANIFEST",
                format!("WP-0001 crate manifest `{crate_path}` is missing"),
            ));
        }
    }
}

fn render_check_output(output: &CheckCommandOutput, format: &str) -> Result<String, String> {
    match format {
        "json" => serde_json::to_string_pretty(output).map_err(|error| error.to_string()),
        "text" => Ok(render_check_text(output)),
        other => Err(format!("unsupported check output format `{other}`")),
    }
}

fn render_check_text(output: &CheckCommandOutput) -> String {
    let mut rendered = String::new();

    rendered.push_str("Monad Repository Check\n");
    rendered.push_str("======================\n\n");
    rendered.push_str(&format!("status: {}\n", output.status));
    rendered.push_str(&format!("target: {}\n", output.target));
    rendered.push_str(&format!("strict: {}\n", output.strict));
    rendered.push_str(&format!("fix requested: {}\n", output.fix_requested));
    rendered.push_str(&format!("did mutate: {}\n", output.did_mutate));
    rendered.push_str(&format!("errors: {}\n", output.error_count));
    rendered.push_str(&format!("warnings: {}\n", output.warning_count));
    rendered.push_str(&format!("info: {}\n", output.info_count));
    rendered.push_str("\nfindings:\n");

    for finding in &output.findings {
        rendered.push_str(&format!(
            "  - [{}] {} {}: {}\n",
            finding.severity, finding.code, finding.path, finding.message
        ));
    }

    rendered
}

'''

text = text.replace(insert_before, "\n" + check_code + insert_before, 1)
path.write_text(text)
PY

mkdir -p crates/monad-cli/tests

cat > crates/monad-cli/tests/check_command.rs <<'RS'
use std::fs;
use std::process::Command;
use std::time::{SystemTime, UNIX_EPOCH};

fn temp_repo_path(name: &str) -> std::path::PathBuf {
    let nanos = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .expect("clock should be after unix epoch")
        .as_nanos();

    let mut path = std::env::temp_dir();
    path.push(format!("monad-check-test-{}-{nanos}-{name}", std::process::id()));
    path
}

fn write_file(path: &std::path::Path, contents: &str) {
    if let Some(parent) = path.parent() {
        fs::create_dir_all(parent).expect("should create parent dirs");
    }

    fs::write(path, contents).expect("should write file");
}

fn create_baseline_repo(name: &str) -> std::path::PathBuf {
    let root = temp_repo_path(name);

    fs::create_dir_all(root.join(".monad")).expect("should create state dir");

    write_file(&root.join("monad.toml"), "[workspace]\nname = \"test\"\n");
    write_file(
        &root.join("workspace.toml"),
        "# compatibility mirror of monad.toml\n[workspace]\nname = \"test\"\n",
    );
    write_file(&root.join("monad.lock"), "# test lockfile\n");

    write_file(
        &root.join("Cargo.toml"),
        r#"[workspace]
resolver = "2"
members = [
    "crates/monad-cli",
    "crates/monad-core",
    "crates/monad-plans",
    "crates/monad-packs",
    "crates/monad-policy",
    "crates/monad-context",
    "crates/monad-graph",
]
"#,
    );

    for crate_name in [
        "monad-cli",
        "monad-core",
        "monad-plans",
        "monad-packs",
        "monad-policy",
        "monad-context",
        "monad-graph",
    ] {
        write_file(
            &root.join(format!("crates/{crate_name}/Cargo.toml")),
            &format!(
                r#"[package]
name = "{crate_name}"
version = "0.1.0"
edition = "2021"
"#
            ),
        );
    }

    root
}

#[test]
fn check_passes_for_baseline_repo() {
    let root = create_baseline_repo("pass");

    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["check", root.to_str().expect("temp path should be utf-8")])
        .output()
        .expect("monad check should run");

    let _ = fs::remove_dir_all(&root);

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("Monad Repository Check"));
    assert!(stdout.contains("status: passed"));
    assert!(stdout.contains("errors: 0"));
    assert!(stdout.contains("MONAD_CHECK_CANONICAL_MANIFEST"));
    assert!(stdout.contains("MONAD_CHECK_WP_0001_CRATE_MANIFEST"));
}

#[test]
fn check_json_reports_passed_baseline_repo() {
    let root = create_baseline_repo("json");

    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args([
            "check",
            root.to_str().expect("temp path should be utf-8"),
            "--format",
            "json",
        ])
        .output()
        .expect("monad check --format json should run");

    let _ = fs::remove_dir_all(&root);

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains(r#""command": "check""#));
    assert!(stdout.contains(r#""status": "passed""#));
    assert!(stdout.contains(r#""error_count": 0"#));
    assert!(stdout.contains(r#""did_mutate": false"#));
}

#[test]
fn check_fails_for_missing_required_manifest() {
    let root = create_baseline_repo("missing-manifest");
    fs::remove_file(root.join("monad.toml")).expect("should remove monad.toml");

    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["check", root.to_str().expect("temp path should be utf-8")])
        .output()
        .expect("monad check should run");

    let _ = fs::remove_dir_all(&root);

    assert!(!output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);
    let stderr = String::from_utf8_lossy(&output.stderr);

    assert!(stdout.contains("status: failed"));
    assert!(stdout.contains("required file `monad.toml` is missing"));
    assert!(stderr.contains("check failed"));
}

#[test]
fn check_fix_is_accepted_but_non_mutating() {
    let root = create_baseline_repo("fix");

    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args([
            "check",
            root.to_str().expect("temp path should be utf-8"),
            "--fix",
        ])
        .output()
        .expect("monad check --fix should run");

    let _ = fs::remove_dir_all(&root);

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("fix requested: true"));
    assert!(stdout.contains("did mutate: false"));
    assert!(stdout.contains("MONAD_CHECK_FIX_NOT_IMPLEMENTED"));
}
RS

cargo fmt --all

echo
echo "Applied layer-0002-hotfix-0017-implement-monad-check"
echo
echo "Implemented:"
echo "  - monad check text/json output"
echo "  - manifest, lockfile, state dir, Cargo workspace, and WP-0001 crate checks"
echo "  - strict/fix flags with no mutation"
echo "  - check command integration tests"
