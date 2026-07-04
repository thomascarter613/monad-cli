#!/usr/bin/env python3
from pathlib import Path
import shutil
import sys


ROOT = Path(__file__).resolve().parent
CLI_RS = ROOT / "crates/monad-cli/src/lib.rs"
TEST_RS = ROOT / "crates/monad-cli/tests/docs_command.rs"


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

    fail("could not find insertion point for docs command code")


def main() -> None:
    if not (ROOT / "monad.toml").is_file():
        fail("monad.toml not found. Save and run this file from the repo root.")

    if not CLI_RS.is_file():
        fail(f"{CLI_RS.relative_to(ROOT)} not found")

    backup = CLI_RS.with_suffix(CLI_RS.suffix + ".bak.layer-0002-hotfix-0025")
    shutil.copyfile(CLI_RS, backup)

    text = CLI_RS.read_text()

    text = insert_once_after_marker(
        text,
        'Some(("docs", sub)) => emit_docs(sub, json),',
        [
            'Some(("context", sub)) => emit_context(sub, json),',
            'Some(("diff", sub)) => emit_diff(sub, json),',
            'Some(("config", sub)) => emit_config(sub, json),',
            'Some(("graph", sub)) => emit_graph(sub, json),',
            'Some(("list", sub)) => emit_list(sub, json),',
            'Some(("inspect", sub)) => emit_inspect(sub, json),',
            'Some(("doctor", sub)) => emit_doctor(sub, json),',
            'Some(("check", sub)) => emit_check(sub, json),',
            'Some(("version", sub)) => emit_version(sub, json),',
        ],
    )

    docs_cmd = r'''fn docs_cmd() -> Command {
    let format = || {
        opt("format", "Output format")
            .value_parser(["text", "json", "markdown"])
            .default_value("text")
    };

    Command::new("docs")
        .about("Check and preview generation of Monad documentation surfaces")
        .subcommand(
            Command::new("check")
                .about("Check required and recommended documentation surfaces")
                .arg(flag("strict", "Treat documentation warnings as failures"))
                .arg(format()),
        )
        .subcommand(
            Command::new("generate")
                .about("Preview generated documentation index content without mutating the repository in WP-0001")
                .arg(
                    opt("section", "Documentation section to generate")
                        .value_parser(["index", "commands", "workspace", "handoff", "all"])
                        .default_value("all"),
                )
                .arg(flag("dry-run", "Preview generated docs without writing files"))
                .arg(format()),
        )
}'''

    text = replace_function(text, "docs_cmd", docs_cmd)

    docs_code = r'''
#[derive(Debug, Clone, Serialize)]
struct DocsFinding {
    severity: &'static str,
    code: &'static str,
    path: String,
    message: String,
}

#[derive(Debug, Serialize)]
struct DocsCheckOutput {
    schema_version: u32,
    command: &'static str,
    subcommand: &'static str,
    status: &'static str,
    strict: bool,
    did_mutate: bool,
    error_count: usize,
    warning_count: usize,
    info_count: usize,
    findings: Vec<DocsFinding>,
    notes: Vec<String>,
}

#[derive(Debug, Clone, Serialize)]
struct DocsGeneratedSection {
    name: &'static str,
    target_path: String,
    would_write: bool,
    title: String,
    body: String,
}

#[derive(Debug, Serialize)]
struct DocsGenerateOutput {
    schema_version: u32,
    command: &'static str,
    subcommand: &'static str,
    status: &'static str,
    section: String,
    dry_run: bool,
    did_mutate: bool,
    section_count: usize,
    sections: Vec<DocsGeneratedSection>,
    notes: Vec<String>,
}

fn emit_docs(matches: &ArgMatches, json: bool) -> Result<(), String> {
    match matches.subcommand() {
        Some(("check", sub)) => emit_docs_check(sub, json),
        Some(("generate", sub)) => emit_docs_generate(sub, json),
        Some((other, _)) => Err(format!("unsupported docs subcommand `{other}`")),
        None => emit_docs_overview(json),
    }
}

fn emit_docs_overview(json: bool) -> Result<(), String> {
    let output = build_docs_check_output(false);
    let rendered = render_docs_check_output(&output, if json { "json" } else { "text" })?;

    println!("{rendered}");

    Ok(())
}

fn emit_docs_check(matches: &ArgMatches, json: bool) -> Result<(), String> {
    let strict = matches.get_flag("strict");

    let format = matches
        .get_one::<String>("format")
        .map(String::as_str)
        .unwrap_or("text");

    let output = build_docs_check_output(strict);
    let rendered = render_docs_check_output(&output, if json { "json" } else { format })?;

    println!("{rendered}");

    if output.error_count > 0 || (strict && output.warning_count > 0) {
        Err(format!(
            "docs check failed with {} error(s) and {} warning(s)",
            output.error_count, output.warning_count
        ))
    } else {
        Ok(())
    }
}

fn emit_docs_generate(matches: &ArgMatches, json: bool) -> Result<(), String> {
    let section = matches
        .get_one::<String>("section")
        .map(String::as_str)
        .unwrap_or("all");

    let dry_run = matches.get_flag("dry-run");

    let format = matches
        .get_one::<String>("format")
        .map(String::as_str)
        .unwrap_or("text");

    let output = build_docs_generate_output(section, dry_run);
    let rendered = render_docs_generate_output(&output, if json { "json" } else { format })?;

    println!("{rendered}");

    Ok(())
}

fn docs_workspace_root() -> std::path::PathBuf {
    let mut current = std::env::current_dir().unwrap_or_else(|_| std::path::PathBuf::from("."));

    loop {
        if current.join("monad.toml").is_file() {
            return current;
        }

        if !current.pop() {
            return std::path::PathBuf::from(".");
        }
    }
}

fn docs_path_exists(root: &std::path::Path, path: &str) -> bool {
    root.join(path).exists()
}

fn docs_file_exists(root: &std::path::Path, path: &str) -> bool {
    root.join(path).is_file()
}

fn docs_dir_exists(root: &std::path::Path, path: &str) -> bool {
    root.join(path).is_dir()
}

fn docs_finding(
    severity: &'static str,
    code: &'static str,
    path: &str,
    message: impl Into<String>,
) -> DocsFinding {
    DocsFinding {
        severity,
        code,
        path: path.to_string(),
        message: message.into(),
    }
}

fn build_docs_check_output(strict: bool) -> DocsCheckOutput {
    let root = docs_workspace_root();
    let mut findings = Vec::new();

    for (path, code, purpose) in [
        ("README.md", "MONAD_DOCS_README", "repository README"),
        ("AGENTS.md", "MONAD_DOCS_AGENTS", "agent/operator instructions"),
        ("docs", "MONAD_DOCS_DIR", "documentation directory"),
        ("docs/work-packets", "MONAD_DOCS_WORKPACKETS_DIR", "work packet documentation directory"),
    ] {
        let exists = docs_path_exists(&root, path);

        findings.push(docs_finding(
            if exists { "info" } else { "warning" },
            code,
            path,
            if exists {
                format!("recommended documentation path `{path}` exists ({purpose})")
            } else {
                format!("recommended documentation path `{path}` is missing ({purpose})")
            },
        ));
    }

    for (path, code, purpose) in [
        ("monad.toml", "MONAD_DOCS_CANONICAL_MANIFEST", "canonical manifest"),
        ("Cargo.toml", "MONAD_DOCS_CARGO_WORKSPACE", "Cargo workspace manifest"),
        ("crates/monad-core/src/command_catalog.rs", "MONAD_DOCS_COMMAND_CATALOG", "command catalog source"),
        ("crates/monad-cli/src/lib.rs", "MONAD_DOCS_CLI_SOURCE", "CLI source"),
    ] {
        let exists = docs_file_exists(&root, path);

        findings.push(docs_finding(
            if exists { "info" } else { "error" },
            code,
            path,
            if exists {
                format!("required documentation input `{path}` exists ({purpose})")
            } else {
                format!("required documentation input `{path}` is missing ({purpose})")
            },
        ));
    }

    for (path, code, purpose) in [
        ("governance", "MONAD_DOCS_GOVERNANCE_SURFACE", "governance surface"),
        ("schemas", "MONAD_DOCS_SCHEMA_SURFACE", "schema surface"),
        ("policies", "MONAD_DOCS_POLICY_SURFACE", "policy surface"),
    ] {
        let exists = docs_dir_exists(&root, path);

        findings.push(docs_finding(
            if exists { "info" } else { "warning" },
            code,
            path,
            if exists {
                format!("documentation-adjacent surface `{path}` exists ({purpose})")
            } else {
                format!("documentation-adjacent surface `{path}` is missing ({purpose})")
            },
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

    DocsCheckOutput {
        schema_version: monad_core::MANIFEST_SCHEMA_VERSION,
        command: "docs",
        subcommand: "check",
        status,
        strict,
        did_mutate: false,
        error_count,
        warning_count,
        info_count,
        findings,
        notes: vec![
            "`monad docs check` is read-only and checks documentation readiness.".to_string(),
            "Warnings are non-blocking unless --strict is supplied.".to_string(),
            "Future work packets can parse docs indexes, validate links, and enforce documentation coverage.".to_string(),
        ],
    }
}

fn build_docs_generate_output(section: &str, dry_run: bool) -> DocsGenerateOutput {
    let mut sections = Vec::new();

    if section == "all" || section == "index" {
        sections.push(DocsGeneratedSection {
            name: "index",
            target_path: "docs/00-index.md".to_string(),
            would_write: false,
            title: "Monad Documentation Index".to_string(),
            body: "Generated index preview for Monad repository documentation, work packets, command surfaces, governance, and runtime metadata.".to_string(),
        });
    }

    if section == "all" || section == "commands" {
        sections.push(DocsGeneratedSection {
            name: "commands",
            target_path: "docs/reference/commands.md".to_string(),
            would_write: false,
            title: "Monad Command Reference".to_string(),
            body: format!(
                "Approved command surface contains {} commands, including {} namespaced commands.",
                monad_core::command_catalog::approved_command_paths().len(),
                monad_core::command_catalog::approved_namespaced_command_paths().len()
            ),
        });
    }

    if section == "all" || section == "workspace" {
        sections.push(DocsGeneratedSection {
            name: "workspace",
            target_path: "docs/reference/workspace.md".to_string(),
            would_write: false,
            title: "Monad Workspace Reference".to_string(),
            body: "Workspace reference preview for monad.toml, workspace.toml, monad.lock, .monad state, crates, and managed repository surfaces.".to_string(),
        });
    }

    if section == "all" || section == "handoff" {
        sections.push(DocsGeneratedSection {
            name: "handoff",
            target_path: "docs/handoff/current.md".to_string(),
            would_write: false,
            title: "Monad Handoff Summary".to_string(),
            body: "Handoff preview for continuing WP-0001 work safely across sessions.".to_string(),
        });
    }

    DocsGenerateOutput {
        schema_version: monad_core::MANIFEST_SCHEMA_VERSION,
        command: "docs",
        subcommand: "generate",
        status: "preview",
        section: section.to_string(),
        dry_run,
        did_mutate: false,
        section_count: sections.len(),
        sections,
        notes: vec![
            "`monad docs generate` is preview-only in WP-0001 and does not write files.".to_string(),
            "The command accepts --dry-run for command-surface consistency; output is non-mutating even without it in WP-0001.".to_string(),
            "Future work packets can make generation plan-backed and write files through monad plan/apply.".to_string(),
        ],
    }
}

fn render_docs_check_output(output: &DocsCheckOutput, format: &str) -> Result<String, String> {
    match format {
        "json" => serde_json::to_string_pretty(output).map_err(|error| error.to_string()),
        "markdown" => Ok(render_docs_check_markdown(output)),
        "text" => Ok(render_docs_check_text(output)),
        other => Err(format!("unsupported docs check output format `{other}`")),
    }
}

fn render_docs_generate_output(output: &DocsGenerateOutput, format: &str) -> Result<String, String> {
    match format {
        "json" => serde_json::to_string_pretty(output).map_err(|error| error.to_string()),
        "markdown" => Ok(render_docs_generate_markdown(output)),
        "text" => Ok(render_docs_generate_text(output)),
        other => Err(format!("unsupported docs generate output format `{other}`")),
    }
}

fn render_docs_check_text(output: &DocsCheckOutput) -> String {
    let mut rendered = String::new();

    rendered.push_str("Monad Docs Check\n");
    rendered.push_str("================\n\n");
    rendered.push_str(&format!("status: {}\n", output.status));
    rendered.push_str(&format!("strict: {}\n", output.strict));
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

    rendered.push_str("\nnotes:\n");
    for note in &output.notes {
        rendered.push_str(&format!("  - {note}\n"));
    }

    rendered
}

fn render_docs_check_markdown(output: &DocsCheckOutput) -> String {
    let mut rendered = String::new();

    rendered.push_str("# Monad Docs Check\n\n");
    rendered.push_str(&format!("- **Status:** `{}`\n", output.status));
    rendered.push_str(&format!("- **Strict:** `{}`\n", output.strict));
    rendered.push_str(&format!("- **Did mutate:** `{}`\n", output.did_mutate));
    rendered.push_str(&format!("- **Errors:** `{}`\n", output.error_count));
    rendered.push_str(&format!("- **Warnings:** `{}`\n", output.warning_count));
    rendered.push_str(&format!("- **Info:** `{}`\n\n", output.info_count));

    rendered.push_str("## Findings\n\n");
    for finding in &output.findings {
        rendered.push_str(&format!(
            "- **{}** `{}` `{}` — {}\n",
            finding.severity, finding.code, finding.path, finding.message
        ));
    }

    rendered.push_str("\n## Notes\n\n");
    for note in &output.notes {
        rendered.push_str(&format!("- {note}\n"));
    }

    rendered
}

fn render_docs_generate_text(output: &DocsGenerateOutput) -> String {
    let mut rendered = String::new();

    rendered.push_str("Monad Docs Generate Preview\n");
    rendered.push_str("===========================\n\n");
    rendered.push_str(&format!("status: {}\n", output.status));
    rendered.push_str(&format!("section: {}\n", output.section));
    rendered.push_str(&format!("dry-run: {}\n", output.dry_run));
    rendered.push_str(&format!("did mutate: {}\n", output.did_mutate));
    rendered.push_str(&format!("sections: {}\n", output.section_count));
    rendered.push_str("\npreview sections:\n");

    for section in &output.sections {
        rendered.push_str(&format!(
            "  - {} -> {} would_write={} title={}\n      {}\n",
            section.name, section.target_path, section.would_write, section.title, section.body
        ));
    }

    rendered.push_str("\nnotes:\n");
    for note in &output.notes {
        rendered.push_str(&format!("  - {note}\n"));
    }

    rendered
}

fn render_docs_generate_markdown(output: &DocsGenerateOutput) -> String {
    let mut rendered = String::new();

    rendered.push_str("# Monad Docs Generate Preview\n\n");
    rendered.push_str(&format!("- **Status:** `{}`\n", output.status));
    rendered.push_str(&format!("- **Section:** `{}`\n", output.section));
    rendered.push_str(&format!("- **Dry-run:** `{}`\n", output.dry_run));
    rendered.push_str(&format!("- **Did mutate:** `{}`\n", output.did_mutate));
    rendered.push_str(&format!("- **Sections:** `{}`\n\n", output.section_count));

    rendered.push_str("## Preview Sections\n\n");
    for section in &output.sections {
        rendered.push_str(&format!(
            "### {}\n\n- Target: `{}`\n- Would write: `{}`\n\n{}\n\n",
            section.title, section.target_path, section.would_write, section.body
        ));
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
        "struct DocsFinding",
        docs_code,
        [
            "\n#[derive(Debug, Clone, Serialize)]\nstruct ContextFileEntry",
            "\n#[derive(Debug, Clone, Serialize)]\nstruct DiffLineChange",
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
        r'''use std::path::PathBuf;
use std::process::Command;

fn workspace_root() -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .join("../..")
        .canonicalize()
        .expect("workspace root should resolve")
}

#[test]
fn docs_check_outputs_text_status() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .current_dir(workspace_root())
        .args(["docs", "check"])
        .output()
        .expect("monad docs check should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("Monad Docs Check"));
    assert!(stdout.contains("did mutate: false"));
    assert!(stdout.contains("MONAD_DOCS_CANONICAL_MANIFEST"));
    assert!(stdout.contains("MONAD_DOCS_CLI_SOURCE"));
}

#[test]
fn docs_check_outputs_json_status() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .current_dir(workspace_root())
        .args(["docs", "check", "--format", "json"])
        .output()
        .expect("monad docs check --format json should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains(r#""command": "docs""#));
    assert!(stdout.contains(r#""subcommand": "check""#));
    assert!(stdout.contains(r#""did_mutate": false"#));
    assert!(stdout.contains(r#""findings""#));
}

#[test]
fn docs_generate_outputs_preview() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .current_dir(workspace_root())
        .args(["docs", "generate"])
        .output()
        .expect("monad docs generate should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("Monad Docs Generate Preview"));
    assert!(stdout.contains("status: preview"));
    assert!(stdout.contains("did mutate: false"));
    assert!(stdout.contains("docs/reference/commands.md"));
}

#[test]
fn docs_generate_outputs_markdown_preview() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .current_dir(workspace_root())
        .args([
            "docs",
            "generate",
            "--section",
            "commands",
            "--dry-run",
            "--format",
            "markdown",
        ])
        .output()
        .expect("monad docs generate --format markdown should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("# Monad Docs Generate Preview"));
    assert!(stdout.contains("Monad Command Reference"));
    assert!(stdout.contains("Would write: `false`"));
}

#[test]
fn docs_generate_outputs_json_preview() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .current_dir(workspace_root())
        .args(["docs", "generate", "--section", "workspace", "--format", "json"])
        .output()
        .expect("monad docs generate --format json should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains(r#""command": "docs""#));
    assert!(stdout.contains(r#""subcommand": "generate""#));
    assert!(stdout.contains(r#""status": "preview""#));
    assert!(stdout.contains(r#""did_mutate": false"#));
    assert!(stdout.contains(r#""target_path": "docs/reference/workspace.md""#));
}
'''
    )

    print("Applied layer-0002-hotfix-0025-implement-monad-docs")
    print()
    print("Changed:")
    print("  - crates/monad-cli/src/lib.rs")
    print("  - crates/monad-cli/tests/docs_command.rs")
    print("Backup:")
    print(f"  - {backup.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
