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

cp "$CLI_RS" "$CLI_RS.bak.layer-0002-hotfix-0019"

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

if 'Some(("inspect", sub)) => emit_inspect(sub, json),' not in text:
    marker_candidates = [
        'Some(("doctor", sub)) => emit_doctor(sub, json),',
        'Some(("check", sub)) => emit_check(sub, json),',
        'Some(("version", sub)) => emit_version(sub, json),',
    ]

    for marker in marker_candidates:
        if marker in text:
            text = text.replace(marker, marker + '\n        Some(("inspect", sub)) => emit_inspect(sub, json),', 1)
            break
    else:
        raise SystemExit("ERROR: could not find dispatch insertion point")

inspect_cmd = r'''fn inspect_cmd() -> Command {
    Command::new("inspect")
        .about("Inspect workspace structure, manifests, crates, command catalog, and managed surfaces")
        .arg(arg("target", "Target repository path").required(false))
        .arg(opt("depth", "Directory scan depth").default_value("2"))
        .arg(opt(
            "include",
            "Comma-separated sections: manifests,crates,commands,surfaces,summary",
        ))
        .arg(fmt_arg().value_parser(["text", "json", "markdown"]))
}'''

text = replace_function(text, "inspect_cmd", inspect_cmd)

insert_before_candidates = [
    '\n#[derive(Debug, Clone, Serialize)]\nstruct DoctorDiagnostic',
    '\n#[derive(Debug, Clone, Serialize)]\nstruct CheckFinding',
    '\n#[derive(Debug, Serialize)]\nstruct PlanCommandOutput',
    '\n#[derive(Debug, Serialize)]\nstruct PlaceholderOutput',
]

insert_before = None
for candidate in insert_before_candidates:
    if candidate in text:
        insert_before = candidate
        break

if insert_before is None:
    raise SystemExit("ERROR: could not find insertion point for inspect command code")

inspect_code = r'''
#[derive(Debug, Clone, Serialize)]
struct InspectManifest {
    path: String,
    exists: bool,
    bytes: Option<u64>,
    role: &'static str,
}

#[derive(Debug, Clone, Serialize)]
struct InspectCrate {
    path: String,
    name: Option<String>,
    has_lib: bool,
    has_bin_main: bool,
    has_tests_dir: bool,
}

#[derive(Debug, Clone, Serialize)]
struct InspectSurface {
    path: String,
    exists: bool,
    role: &'static str,
}

#[derive(Debug, Clone, Serialize)]
struct InspectCommandCatalogSummary {
    top_level_count: usize,
    namespaced_count: usize,
    total_count: usize,
    plan_backed_count: usize,
    dry_run_capable_count: usize,
}

#[derive(Debug, Serialize)]
struct InspectCommandOutput {
    schema_version: u32,
    command: &'static str,
    status: &'static str,
    target: String,
    depth: usize,
    include: Option<String>,
    did_mutate: bool,
    manifest_count: usize,
    crate_count: usize,
    existing_surface_count: usize,
    command_catalog: InspectCommandCatalogSummary,
    manifests: Vec<InspectManifest>,
    crates: Vec<InspectCrate>,
    surfaces: Vec<InspectSurface>,
    notes: Vec<String>,
}

fn emit_inspect(matches: &ArgMatches, json: bool) -> Result<(), String> {
    let target = matches
        .get_one::<String>("target")
        .map(String::as_str)
        .unwrap_or(".");

    let depth = matches
        .get_one::<String>("depth")
        .and_then(|value| value.parse::<usize>().ok())
        .unwrap_or(2);

    let include = matches.get_one::<String>("include").cloned();

    let format = matches
        .get_one::<String>("format")
        .map(String::as_str)
        .unwrap_or("text");

    let output = build_inspect_output(target, depth, include)?;
    let rendered = render_inspect_output(&output, if json { "json" } else { format })?;

    println!("{rendered}");

    Ok(())
}

fn build_inspect_output(
    target: &str,
    depth: usize,
    include: Option<String>,
) -> Result<InspectCommandOutput, String> {
    let root = std::path::Path::new(target);

    if !root.exists() {
        return Err(format!("inspect target `{target}` does not exist"));
    }

    if !root.is_dir() {
        return Err(format!("inspect target `{target}` is not a directory"));
    }

    let manifests = inspect_manifests(root);
    let crates = inspect_rust_crates(root, depth);
    let surfaces = inspect_surfaces(root);
    let command_catalog = inspect_command_catalog();

    let manifest_count = manifests.iter().filter(|manifest| manifest.exists).count();
    let crate_count = crates.len();
    let existing_surface_count = surfaces.iter().filter(|surface| surface.exists).count();

    Ok(InspectCommandOutput {
        schema_version: monad_core::MANIFEST_SCHEMA_VERSION,
        command: "inspect",
        status: "implemented",
        target: target.to_string(),
        depth,
        include,
        did_mutate: false,
        manifest_count,
        crate_count,
        existing_surface_count,
        command_catalog,
        manifests,
        crates,
        surfaces,
        notes: vec![
            "`monad inspect` is read-only and does not validate correctness; use `monad check` for pass/fail validation.".to_string(),
            "WP-0001 inspection uses conservative filesystem heuristics. Later work packets can parse manifests and build the full workspace graph.".to_string(),
        ],
    })
}

fn inspect_manifests(root: &std::path::Path) -> Vec<InspectManifest> {
    [
        ("monad.toml", "canonical Monad manifest"),
        ("workspace.toml", "compatibility manifest mirror"),
        ("monad.lock", "Monad lockfile"),
        ("Cargo.toml", "Cargo workspace manifest"),
        ("deny.toml", "cargo-deny configuration"),
        (".monorepo.json", "monorepo compatibility/introspection metadata"),
    ]
    .iter()
    .map(|(relative, role)| {
        let path = root.join(relative);
        let metadata = std::fs::metadata(&path).ok();

        InspectManifest {
            path: (*relative).to_string(),
            exists: path.is_file(),
            bytes: metadata.map(|metadata| metadata.len()),
            role,
        }
    })
    .collect()
}

fn inspect_rust_crates(root: &std::path::Path, depth: usize) -> Vec<InspectCrate> {
    let mut crates = Vec::new();

    let crates_root = root.join("crates");
    if !crates_root.is_dir() || depth == 0 {
        return crates;
    }

    let Ok(entries) = std::fs::read_dir(&crates_root) else {
        return crates;
    };

    for entry in entries.flatten() {
        let crate_dir = entry.path();

        if !crate_dir.is_dir() {
            continue;
        }

        let cargo_toml = crate_dir.join("Cargo.toml");
        if !cargo_toml.is_file() {
            continue;
        }

        let relative = crate_dir
            .strip_prefix(root)
            .unwrap_or(&crate_dir)
            .to_string_lossy()
            .replace('\\', "/");

        let cargo_contents = std::fs::read_to_string(&cargo_toml).unwrap_or_default();
        let name = parse_cargo_package_name(&cargo_contents);

        crates.push(InspectCrate {
            path: relative,
            name,
            has_lib: crate_dir.join("src/lib.rs").is_file(),
            has_bin_main: crate_dir.join("src/main.rs").is_file(),
            has_tests_dir: crate_dir.join("tests").is_dir(),
        });
    }

    crates.sort_by(|left, right| left.path.cmp(&right.path));
    crates
}

fn parse_cargo_package_name(contents: &str) -> Option<String> {
    for line in contents.lines() {
        let trimmed = line.trim();

        if let Some(rest) = trimmed.strip_prefix("name") {
            let rest = rest.trim_start();

            if let Some(value) = rest.strip_prefix('=') {
                let value = value.trim().trim_matches('"');

                if !value.is_empty() {
                    return Some(value.to_string());
                }
            }
        }
    }

    None
}

fn inspect_surfaces(root: &std::path::Path) -> Vec<InspectSurface> {
    [
        ("governance", "governance model, decision records, and operating rules"),
        ("domains", "domain ownership and bounded-context surfaces"),
        ("ops", "operations, runbooks, and production readiness surfaces"),
        ("observability", "metrics, logs, traces, and telemetry surfaces"),
        ("compliance", "compliance evidence and controls"),
        ("security", "security policy, threat model, and controls"),
        ("environments", "environment definitions and deployment topology"),
        ("devcontainers", "development container definitions"),
        ("docs", "documentation source of truth"),
        ("schemas", "machine-readable schemas"),
        ("policies", "repository and lifecycle policies"),
        ("crates", "Rust workspace crates"),
        (".github", "GitHub workflows, templates, and automation"),
        (".monad", "Monad state directory"),
    ]
    .iter()
    .map(|(relative, role)| InspectSurface {
        path: (*relative).to_string(),
        exists: root.join(relative).exists(),
        role,
    })
    .collect()
}

fn inspect_command_catalog() -> InspectCommandCatalogSummary {
    let commands = monad_core::command_catalog::approved_commands();

    InspectCommandCatalogSummary {
        top_level_count: monad_core::command_catalog::APPROVED_TOP_LEVEL_COMMANDS.len(),
        namespaced_count: monad_core::command_catalog::APPROVED_NAMESPACED_COMMANDS.len(),
        total_count: commands.len(),
        plan_backed_count: commands.iter().filter(|command| command.plan_backed).count(),
        dry_run_capable_count: commands
            .iter()
            .filter(|command| command.supports_dry_run)
            .count(),
    }
}

fn include_section(output: &InspectCommandOutput, section: &str) -> bool {
    let Some(include) = output.include.as_deref() else {
        return true;
    };

    include
        .split(',')
        .map(str::trim)
        .any(|item| item.eq_ignore_ascii_case(section))
}

fn render_inspect_output(output: &InspectCommandOutput, format: &str) -> Result<String, String> {
    match format {
        "json" => serde_json::to_string_pretty(output).map_err(|error| error.to_string()),
        "markdown" => Ok(render_inspect_markdown(output)),
        "text" => Ok(render_inspect_text(output)),
        other => Err(format!("unsupported inspect output format `{other}`")),
    }
}

fn render_inspect_text(output: &InspectCommandOutput) -> String {
    let mut rendered = String::new();

    rendered.push_str("Monad Workspace Inspect\n");
    rendered.push_str("=======================\n\n");
    rendered.push_str(&format!("status: {}\n", output.status));
    rendered.push_str(&format!("target: {}\n", output.target));
    rendered.push_str(&format!("depth: {}\n", output.depth));
    rendered.push_str(&format!(
        "include: {}\n",
        output.include.as_deref().unwrap_or("all")
    ));
    rendered.push_str(&format!("did mutate: {}\n", output.did_mutate));
    rendered.push_str(&format!("manifests found: {}\n", output.manifest_count));
    rendered.push_str(&format!("rust crates found: {}\n", output.crate_count));
    rendered.push_str(&format!(
        "managed surfaces found: {}\n",
        output.existing_surface_count
    ));

    if include_section(output, "summary") || include_section(output, "commands") {
        rendered.push_str("\ncommand catalog:\n");
        rendered.push_str(&format!(
            "  top-level: {}\n",
            output.command_catalog.top_level_count
        ));
        rendered.push_str(&format!(
            "  namespaced: {}\n",
            output.command_catalog.namespaced_count
        ));
        rendered.push_str(&format!("  total: {}\n", output.command_catalog.total_count));
        rendered.push_str(&format!(
            "  plan-backed: {}\n",
            output.command_catalog.plan_backed_count
        ));
        rendered.push_str(&format!(
            "  dry-run capable: {}\n",
            output.command_catalog.dry_run_capable_count
        ));
    }

    if include_section(output, "manifests") {
        rendered.push_str("\nmanifests:\n");
        for manifest in &output.manifests {
            rendered.push_str(&format!(
                "  - {} exists={} bytes={} role={}\n",
                manifest.path,
                manifest.exists,
                manifest
                    .bytes
                    .map(|bytes| bytes.to_string())
                    .unwrap_or_else(|| "n/a".to_string()),
                manifest.role
            ));
        }
    }

    if include_section(output, "crates") {
        rendered.push_str("\nrust crates:\n");
        for crate_info in &output.crates {
            rendered.push_str(&format!(
                "  - {} name={} lib={} bin={} tests={}\n",
                crate_info.path,
                crate_info.name.as_deref().unwrap_or("unknown"),
                crate_info.has_lib,
                crate_info.has_bin_main,
                crate_info.has_tests_dir
            ));
        }
    }

    if include_section(output, "surfaces") {
        rendered.push_str("\nmanaged surfaces:\n");
        for surface in &output.surfaces {
            rendered.push_str(&format!(
                "  - {} exists={} role={}\n",
                surface.path, surface.exists, surface.role
            ));
        }
    }

    rendered.push_str("\nnotes:\n");
    for note in &output.notes {
        rendered.push_str(&format!("  - {note}\n"));
    }

    rendered
}

fn render_inspect_markdown(output: &InspectCommandOutput) -> String {
    let mut rendered = String::new();

    rendered.push_str("# Monad Workspace Inspect\n\n");
    rendered.push_str(&format!("- **Status:** `{}`\n", output.status));
    rendered.push_str(&format!("- **Target:** `{}`\n", output.target));
    rendered.push_str(&format!("- **Depth:** `{}`\n", output.depth));
    rendered.push_str(&format!(
        "- **Include:** `{}`\n",
        output.include.as_deref().unwrap_or("all")
    ));
    rendered.push_str(&format!("- **Did mutate:** `{}`\n", output.did_mutate));
    rendered.push_str(&format!("- **Manifests found:** `{}`\n", output.manifest_count));
    rendered.push_str(&format!("- **Rust crates found:** `{}`\n", output.crate_count));
    rendered.push_str(&format!(
        "- **Managed surfaces found:** `{}`\n\n",
        output.existing_surface_count
    ));

    if include_section(output, "summary") || include_section(output, "commands") {
        rendered.push_str("## Command Catalog\n\n");
        rendered.push_str(&format!(
            "- Top-level commands: `{}`\n",
            output.command_catalog.top_level_count
        ));
        rendered.push_str(&format!(
            "- Namespaced commands: `{}`\n",
            output.command_catalog.namespaced_count
        ));
        rendered.push_str(&format!(
            "- Total commands: `{}`\n",
            output.command_catalog.total_count
        ));
        rendered.push_str(&format!(
            "- Plan-backed commands: `{}`\n",
            output.command_catalog.plan_backed_count
        ));
        rendered.push_str(&format!(
            "- Dry-run capable commands: `{}`\n\n",
            output.command_catalog.dry_run_capable_count
        ));
    }

    if include_section(output, "manifests") {
        rendered.push_str("## Manifests\n\n");
        for manifest in &output.manifests {
            rendered.push_str(&format!(
                "- `{}` — exists `{}`, bytes `{}`, role: {}\n",
                manifest.path,
                manifest.exists,
                manifest
                    .bytes
                    .map(|bytes| bytes.to_string())
                    .unwrap_or_else(|| "n/a".to_string()),
                manifest.role
            ));
        }
        rendered.push('\n');
    }

    if include_section(output, "crates") {
        rendered.push_str("## Rust Crates\n\n");
        for crate_info in &output.crates {
            rendered.push_str(&format!(
                "- `{}` — name `{}`, lib `{}`, bin `{}`, tests `{}`\n",
                crate_info.path,
                crate_info.name.as_deref().unwrap_or("unknown"),
                crate_info.has_lib,
                crate_info.has_bin_main,
                crate_info.has_tests_dir
            ));
        }
        rendered.push('\n');
    }

    if include_section(output, "surfaces") {
        rendered.push_str("## Managed Surfaces\n\n");
        for surface in &output.surfaces {
            rendered.push_str(&format!(
                "- `{}` — exists `{}`, role: {}\n",
                surface.path, surface.exists, surface.role
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

text = text.replace(insert_before, "\n" + inspect_code + insert_before, 1)
path.write_text(text)
PY

mkdir -p crates/monad-cli/tests

cat > crates/monad-cli/tests/inspect_command.rs <<'RS'
use std::fs;
use std::process::Command;
use std::time::{SystemTime, UNIX_EPOCH};

fn temp_repo_path(name: &str) -> std::path::PathBuf {
    let nanos = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .expect("clock should be after unix epoch")
        .as_nanos();

    let mut path = std::env::temp_dir();
    path.push(format!(
        "monad-inspect-test-{}-{nanos}-{name}",
        std::process::id()
    ));
    path
}

fn write_file(path: &std::path::Path, contents: &str) {
    if let Some(parent) = path.parent() {
        fs::create_dir_all(parent).expect("should create parent dirs");
    }

    fs::write(path, contents).expect("should write file");
}

fn create_inspect_repo(name: &str) -> std::path::PathBuf {
    let root = temp_repo_path(name);

    fs::create_dir_all(root.join(".monad")).expect("should create state dir");
    fs::create_dir_all(root.join("governance")).expect("should create governance dir");
    fs::create_dir_all(root.join("docs")).expect("should create docs dir");

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
]
"#,
    );

    write_file(
        &root.join("crates/monad-cli/Cargo.toml"),
        r#"[package]
name = "monad-cli"
version = "0.1.0"
edition = "2021"
"#,
    );
    write_file(&root.join("crates/monad-cli/src/main.rs"), "fn main() {}\n");
    fs::create_dir_all(root.join("crates/monad-cli/tests")).expect("should create tests dir");

    write_file(
        &root.join("crates/monad-core/Cargo.toml"),
        r#"[package]
name = "monad-core"
version = "0.1.0"
edition = "2021"
"#,
    );
    write_file(&root.join("crates/monad-core/src/lib.rs"), "pub fn test() {}\n");

    root
}

#[test]
fn inspect_outputs_text_summary() {
    let root = create_inspect_repo("text");

    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["inspect", root.to_str().expect("temp path should be utf-8")])
        .output()
        .expect("monad inspect should run");

    let _ = fs::remove_dir_all(&root);

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("Monad Workspace Inspect"));
    assert!(stdout.contains("status: implemented"));
    assert!(stdout.contains("did mutate: false"));
    assert!(stdout.contains("monad.toml"));
    assert!(stdout.contains("crates/monad-cli"));
    assert!(stdout.contains("command catalog:"));
}

#[test]
fn inspect_outputs_json_summary() {
    let root = create_inspect_repo("json");

    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args([
            "inspect",
            root.to_str().expect("temp path should be utf-8"),
            "--format",
            "json",
        ])
        .output()
        .expect("monad inspect --format json should run");

    let _ = fs::remove_dir_all(&root);

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains(r#""command": "inspect""#));
    assert!(stdout.contains(r#""status": "implemented""#));
    assert!(stdout.contains(r#""did_mutate": false"#));
    assert!(stdout.contains(r#""crate_count": 2"#));
    assert!(stdout.contains(r#""command_catalog""#));
}

#[test]
fn inspect_outputs_markdown_summary() {
    let root = create_inspect_repo("markdown");

    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args([
            "inspect",
            root.to_str().expect("temp path should be utf-8"),
            "--format",
            "markdown",
        ])
        .output()
        .expect("monad inspect --format markdown should run");

    let _ = fs::remove_dir_all(&root);

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("# Monad Workspace Inspect"));
    assert!(stdout.contains("## Command Catalog"));
    assert!(stdout.contains("## Manifests"));
    assert!(stdout.contains("## Rust Crates"));
}

#[test]
fn inspect_include_can_limit_sections() {
    let root = create_inspect_repo("include");

    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args([
            "inspect",
            root.to_str().expect("temp path should be utf-8"),
            "--include",
            "crates",
        ])
        .output()
        .expect("monad inspect --include crates should run");

    let _ = fs::remove_dir_all(&root);

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("include: crates"));
    assert!(stdout.contains("rust crates:"));
    assert!(!stdout.contains("managed surfaces:"));
}

#[test]
fn inspect_fails_for_missing_target() {
    let root = temp_repo_path("missing");

    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["inspect", root.to_str().expect("temp path should be utf-8")])
        .output()
        .expect("monad inspect missing target should run and fail cleanly");

    assert!(!output.status.success());

    let stderr = String::from_utf8_lossy(&output.stderr);
    assert!(stderr.contains("inspect target"));
    assert!(stderr.contains("does not exist"));
}
RS

cargo fmt --all

echo
echo "Applied layer-0002-hotfix-0019-implement-monad-inspect"
echo
echo "Implemented:"
echo "  - monad inspect text/json/markdown output"
echo "  - manifest, crate, command catalog, and managed surface introspection"
echo "  - --include section filtering"
echo "  - read-only behavior with did_mutate=false"
echo "  - inspect command integration tests"
