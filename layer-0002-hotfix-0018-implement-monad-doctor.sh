#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"
cd "$ROOT"

if [ ! -f "monad.toml" ]; then
  echo "ERROR: monad.toml not found. Run from repo root." >&2
  exit 1
fi

CLI_RS="crates/monad-cli/src/lib.rs"

if [ ! -f "$CLI_RS" ]; then
  echo "ERROR: $CLI_RS not found." >&2
  exit 1
fi

cp "$CLI_RS" "$CLI_RS.bak.layer-0002-hotfix-0018"

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

if 'Some(("doctor", sub)) => emit_doctor(sub, json),' not in text:
    marker = 'Some(("check", sub)) => emit_check(sub, json),'
    if marker not in text:
        raise SystemExit("ERROR: could not find check dispatch arm. Run layer-0002-hotfix-0017 first.")
    text = text.replace(marker, marker + '\n        Some(("doctor", sub)) => emit_doctor(sub, json),', 1)

doctor_cmd = r'''fn doctor_cmd() -> Command {
    Command::new("doctor")
        .about("Diagnose local environment, tooling, repository, cache, and policy readiness")
        .arg(flag("fix", "Preview safe fixes where supported; WP-0001 does not mutate"))
        .arg(opt("include", "Comma-separated diagnostic areas to focus on"))
        .arg(fmt_arg().value_parser(["text", "json", "markdown"]))
}'''

text = replace_function(text, "doctor_cmd", doctor_cmd)

insert_before_candidates = [
    '\n#[derive(Debug, Clone, Serialize)]\nstruct CheckFinding',
    '\n#[derive(Debug, Serialize)]\nstruct CheckCommandOutput',
    '\n#[derive(Debug, Serialize)]\nstruct PlanCommandOutput',
    '\n#[derive(Debug, Serialize)]\nstruct PlaceholderOutput',
]

insert_before = None
for candidate in insert_before_candidates:
    if candidate in text:
        insert_before = candidate
        break

if insert_before is None:
    raise SystemExit("ERROR: could not find insertion point for doctor command code")

doctor_code = r'''
#[derive(Debug, Clone, Serialize)]
struct DoctorDiagnostic {
    area: &'static str,
    name: String,
    required: bool,
    available: bool,
    version: Option<String>,
    severity: &'static str,
    message: String,
}

#[derive(Debug, Serialize)]
struct DoctorCommandOutput {
    schema_version: u32,
    command: &'static str,
    status: &'static str,
    fix_requested: bool,
    include: Option<String>,
    did_mutate: bool,
    required_missing_count: usize,
    optional_missing_count: usize,
    available_count: usize,
    diagnostics: Vec<DoctorDiagnostic>,
    notes: Vec<String>,
}

fn emit_doctor(matches: &ArgMatches, json: bool) -> Result<(), String> {
    let fix_requested = matches.get_flag("fix");
    let include = matches.get_one::<String>("include").cloned();

    let format = matches
        .get_one::<String>("format")
        .map(String::as_str)
        .unwrap_or("text");

    let output = build_doctor_output(fix_requested, include);
    let rendered = render_doctor_output(&output, if json { "json" } else { format })?;

    println!("{rendered}");

    // WP-0001 doctor is diagnostic-only. It reports missing tools but does not
    // fail the command because many governance/runtime tools are optional.
    Ok(())
}

fn build_doctor_output(fix_requested: bool, include: Option<String>) -> DoctorCommandOutput {
    let mut diagnostics = Vec::new();

    diagnostics.push(tool_diagnostic(
        "rust",
        "rustc",
        &["--version"],
        true,
        "Rust compiler is required to build Monad.",
    ));
    diagnostics.push(tool_diagnostic(
        "rust",
        "cargo",
        &["--version"],
        true,
        "Cargo is required to build and test the Rust workspace.",
    ));
    diagnostics.push(tool_diagnostic(
        "vcs",
        "git",
        &["--version"],
        false,
        "Git is recommended for repository operations, status checks, and future plan/apply safety gates.",
    ));
    diagnostics.push(tool_diagnostic(
        "package-manager",
        "bun",
        &["--version"],
        false,
        "Bun is the approved default package manager, but WP-0001 does not require it to compile the Rust CLI.",
    ));
    diagnostics.push(tool_diagnostic(
        "governance",
        "cargo-deny",
        &["--version"],
        false,
        "cargo-deny is optional for dependency hygiene and license/advisory checks.",
    ));
    diagnostics.push(tool_diagnostic(
        "governance",
        "cargo-audit",
        &["--version"],
        false,
        "cargo-audit is optional for Rust advisory checks.",
    ));
    diagnostics.push(tool_diagnostic(
        "governance",
        "gitleaks",
        &["version"],
        false,
        "gitleaks is optional for secret scanning.",
    ));
    diagnostics.push(tool_diagnostic(
        "governance",
        "trivy",
        &["--version"],
        false,
        "Trivy is optional for filesystem/container vulnerability scanning.",
    ));
    diagnostics.push(tool_diagnostic(
        "governance",
        "syft",
        &["version"],
        false,
        "Syft is optional for SBOM generation.",
    ));
    diagnostics.push(tool_diagnostic(
        "typescript",
        "biome",
        &["--version"],
        false,
        "Biome is optional until TypeScript workspace generation is implemented.",
    ));
    diagnostics.push(tool_diagnostic(
        "hooks",
        "lefthook",
        &["version"],
        false,
        "Lefthook is optional until repository hook installation is implemented.",
    ));

    diagnostics.push(path_diagnostic(
        "repository",
        "monad.toml",
        true,
        std::path::Path::new("monad.toml").is_file(),
        "Canonical Monad manifest.",
    ));
    diagnostics.push(path_diagnostic(
        "repository",
        "workspace.toml",
        true,
        std::path::Path::new("workspace.toml").is_file(),
        "Compatibility mirror of monad.toml.",
    ));
    diagnostics.push(path_diagnostic(
        "repository",
        "monad.lock",
        true,
        std::path::Path::new("monad.lock").is_file(),
        "Monad lockfile.",
    ));
    diagnostics.push(path_diagnostic(
        "repository",
        ".monad",
        true,
        std::path::Path::new(".monad").is_dir(),
        "Monad state directory.",
    ));
    diagnostics.push(path_diagnostic(
        "repository",
        "Cargo.toml",
        true,
        std::path::Path::new("Cargo.toml").is_file(),
        "Cargo workspace manifest.",
    ));

    if fix_requested {
        diagnostics.push(DoctorDiagnostic {
            area: "doctor",
            name: "--fix".to_string(),
            required: false,
            available: false,
            version: None,
            severity: "warning",
            message: "`monad doctor --fix` is accepted, but WP-0001 does not mutate the environment or install tools.".to_string(),
        });
    }

    if let Some(include_filter) = include.as_deref() {
        let requested = include_filter
            .split(',')
            .map(str::trim)
            .filter(|part| !part.is_empty())
            .collect::<Vec<_>>();

        if !requested.is_empty() {
            diagnostics.retain(|diagnostic| {
                requested
                    .iter()
                    .any(|area| diagnostic.area.eq_ignore_ascii_case(area))
            });
        }
    }

    let required_missing_count = diagnostics
        .iter()
        .filter(|diagnostic| diagnostic.required && !diagnostic.available)
        .count();

    let optional_missing_count = diagnostics
        .iter()
        .filter(|diagnostic| !diagnostic.required && !diagnostic.available)
        .count();

    let available_count = diagnostics
        .iter()
        .filter(|diagnostic| diagnostic.available)
        .count();

    let status = if required_missing_count > 0 {
        "needs_required_tools"
    } else if optional_missing_count > 0 {
        "needs_optional_tools"
    } else {
        "passed"
    };

    DoctorCommandOutput {
        schema_version: monad_core::MANIFEST_SCHEMA_VERSION,
        command: "doctor",
        status,
        fix_requested,
        include,
        did_mutate: false,
        required_missing_count,
        optional_missing_count,
        available_count,
        diagnostics,
        notes: vec![
            "Missing optional tools are reported as warnings and do not mean the Rust CLI workspace is broken.".to_string(),
            "Use `monad check` for repository baseline validation and `cargo test --workspace` for Rust test validation.".to_string(),
            "Future work packets can add install suggestions, version constraints, cache checks, and tool-specific remediation plans.".to_string(),
        ],
    }
}

fn tool_diagnostic(
    area: &'static str,
    name: &str,
    args: &[&str],
    required: bool,
    purpose: &str,
) -> DoctorDiagnostic {
    match std::process::Command::new(name).args(args).output() {
        Ok(output) => {
            let stdout = String::from_utf8_lossy(&output.stdout);
            let stderr = String::from_utf8_lossy(&output.stderr);
            let version = stdout
                .lines()
                .chain(stderr.lines())
                .map(str::trim)
                .find(|line| !line.is_empty())
                .map(ToOwned::to_owned);

            if output.status.success() {
                DoctorDiagnostic {
                    area,
                    name: name.to_string(),
                    required,
                    available: true,
                    version,
                    severity: "info",
                    message: format!("{purpose} `{name}` is available."),
                }
            } else {
                DoctorDiagnostic {
                    area,
                    name: name.to_string(),
                    required,
                    available: false,
                    version,
                    severity: if required { "error" } else { "warning" },
                    message: format!(
                        "{purpose} `{name}` exists but did not exit successfully for version probe."
                    ),
                }
            }
        }
        Err(error) => DoctorDiagnostic {
            area,
            name: name.to_string(),
            required,
            available: false,
            version: None,
            severity: if required { "error" } else { "warning" },
            message: format!("{purpose} `{name}` is not available on PATH: {error}"),
        },
    }
}

fn path_diagnostic(
    area: &'static str,
    name: &str,
    required: bool,
    available: bool,
    purpose: &str,
) -> DoctorDiagnostic {
    DoctorDiagnostic {
        area,
        name: name.to_string(),
        required,
        available,
        version: None,
        severity: if available {
            "info"
        } else if required {
            "error"
        } else {
            "warning"
        },
        message: if available {
            format!("{purpose} `{name}` exists.")
        } else {
            format!("{purpose} `{name}` is missing.")
        },
    }
}

fn render_doctor_output(output: &DoctorCommandOutput, format: &str) -> Result<String, String> {
    match format {
        "json" => serde_json::to_string_pretty(output).map_err(|error| error.to_string()),
        "markdown" => Ok(render_doctor_markdown(output)),
        "text" => Ok(render_doctor_text(output)),
        other => Err(format!("unsupported doctor output format `{other}`")),
    }
}

fn render_doctor_text(output: &DoctorCommandOutput) -> String {
    let mut rendered = String::new();

    rendered.push_str("Monad Doctor\n");
    rendered.push_str("============\n\n");
    rendered.push_str(&format!("status: {}\n", output.status));
    rendered.push_str(&format!("fix requested: {}\n", output.fix_requested));
    rendered.push_str(&format!(
        "include: {}\n",
        output.include.as_deref().unwrap_or("all")
    ));
    rendered.push_str(&format!("did mutate: {}\n", output.did_mutate));
    rendered.push_str(&format!(
        "required missing: {}\n",
        output.required_missing_count
    ));
    rendered.push_str(&format!(
        "optional missing: {}\n",
        output.optional_missing_count
    ));
    rendered.push_str(&format!("available: {}\n", output.available_count));
    rendered.push_str("\ndiagnostics:\n");

    for diagnostic in &output.diagnostics {
        rendered.push_str(&format!(
            "  - [{}] {} {} required={} available={}",
            diagnostic.severity,
            diagnostic.area,
            diagnostic.name,
            diagnostic.required,
            diagnostic.available
        ));

        if let Some(version) = &diagnostic.version {
            rendered.push_str(&format!(" version=\"{}\"", version));
        }

        rendered.push_str(&format!(": {}\n", diagnostic.message));
    }

    rendered.push_str("\nnotes:\n");
    for note in &output.notes {
        rendered.push_str(&format!("  - {note}\n"));
    }

    rendered
}

fn render_doctor_markdown(output: &DoctorCommandOutput) -> String {
    let mut rendered = String::new();

    rendered.push_str("# Monad Doctor\n\n");
    rendered.push_str(&format!("- **Status:** `{}`\n", output.status));
    rendered.push_str(&format!("- **Fix requested:** `{}`\n", output.fix_requested));
    rendered.push_str(&format!(
        "- **Include:** `{}`\n",
        output.include.as_deref().unwrap_or("all")
    ));
    rendered.push_str(&format!("- **Did mutate:** `{}`\n", output.did_mutate));
    rendered.push_str(&format!(
        "- **Required missing:** `{}`\n",
        output.required_missing_count
    ));
    rendered.push_str(&format!(
        "- **Optional missing:** `{}`\n",
        output.optional_missing_count
    ));
    rendered.push_str(&format!("- **Available:** `{}`\n\n", output.available_count));

    rendered.push_str("## Diagnostics\n\n");
    for diagnostic in &output.diagnostics {
        rendered.push_str(&format!(
            "- **{} / {}** — severity `{}`, required `{}`, available `{}`",
            diagnostic.area,
            diagnostic.name,
            diagnostic.severity,
            diagnostic.required,
            diagnostic.available
        ));

        if let Some(version) = &diagnostic.version {
            rendered.push_str(&format!(", version `{}`", version));
        }

        rendered.push_str(&format!(". {}\n", diagnostic.message));
    }

    rendered.push_str("\n## Notes\n\n");
    for note in &output.notes {
        rendered.push_str(&format!("- {note}\n"));
    }

    rendered
}

'''

text = text.replace(insert_before, "\n" + doctor_code + insert_before, 1)
path.write_text(text)
PY

mkdir -p crates/monad-cli/tests

cat > crates/monad-cli/tests/doctor_command.rs <<'RS'
use std::process::Command;

#[test]
fn doctor_outputs_text_diagnostics_without_mutating() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .arg("doctor")
        .output()
        .expect("monad doctor should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("Monad Doctor"));
    assert!(stdout.contains("status:"));
    assert!(stdout.contains("did mutate: false"));
    assert!(stdout.contains("rustc"));
    assert!(stdout.contains("cargo"));
    assert!(stdout.contains("bun"));
    assert!(stdout.contains("Missing optional tools"));
}

#[test]
fn doctor_outputs_json_diagnostics() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["doctor", "--format", "json"])
        .output()
        .expect("monad doctor --format json should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains(r#""command": "doctor""#));
    assert!(stdout.contains(r#""did_mutate": false"#));
    assert!(stdout.contains(r#""required_missing_count""#));
    assert!(stdout.contains(r#""optional_missing_count""#));
    assert!(stdout.contains(r#""diagnostics""#));
}

#[test]
fn doctor_include_filters_diagnostic_area() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["doctor", "--include", "repository"])
        .output()
        .expect("monad doctor --include repository should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("include: repository"));
    assert!(stdout.contains("monad.toml"));
    assert!(stdout.contains("Cargo.toml"));
}

#[test]
fn doctor_fix_is_accepted_but_non_mutating() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["doctor", "--fix"])
        .output()
        .expect("monad doctor --fix should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("fix requested: true"));
    assert!(stdout.contains("did mutate: false"));
    assert!(stdout.contains("does not mutate the environment or install tools"));
}
RS

cargo fmt --all

echo
echo "Applied layer-0002-hotfix-0018-implement-monad-doctor"
echo
echo "Implemented:"
echo "  - monad doctor text/json/markdown output"
echo "  - Rust/Cargo/Git/Bun/governance tool probes"
echo "  - repository marker diagnostics"
echo "  - --include filtering"
echo "  - --fix accepted without mutation"
echo "  - doctor command integration tests"
