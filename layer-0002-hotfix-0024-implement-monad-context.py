#!/usr/bin/env python3
from pathlib import Path
import shutil
import sys


ROOT = Path(__file__).resolve().parent
CLI_RS = ROOT / "crates/monad-cli/src/lib.rs"
TEST_RS = ROOT / "crates/monad-cli/tests/context_command.rs"


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

    fail("could not find insertion point for context command code")


def main() -> None:
    if not (ROOT / "monad.toml").is_file():
        fail("monad.toml not found. Save and run this file from the repo root.")

    if not CLI_RS.is_file():
        fail(f"{CLI_RS.relative_to(ROOT)} not found")

    backup = CLI_RS.with_suffix(CLI_RS.suffix + ".bak.layer-0002-hotfix-0024")
    shutil.copyfile(CLI_RS, backup)

    text = CLI_RS.read_text()

    text = insert_once_after_marker(
        text,
        'Some(("context", sub)) => emit_context(sub, json),',
        [
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

    context_cmd = r'''fn context_cmd() -> Command {
    let format = || {
        opt("format", "Output format")
            .value_parser(["text", "json", "markdown"])
            .default_value("text")
    };

    Command::new("context")
        .about("Package, verify, and summarize Monad repository context for humans, scripts, and AI tools")
        .arg(format())
        .subcommand(
            Command::new("pack")
                .about("Create a read-only context pack summary")
                .arg(opt(
                    "include",
                    "Comma-separated context categories: manifests,cli,crates,docs,governance,all",
                ))
                .arg(
                    opt("max-files", "Maximum context files to include")
                        .default_value("40"),
                )
                .arg(format()),
        )
        .subcommand(
            Command::new("verify")
                .about("Verify that required context handoff files exist")
                .arg(flag("strict", "Treat warnings as blocking failures"))
                .arg(format()),
        )
        .subcommand(
            Command::new("handoff")
                .about("Generate a compact handoff summary for continuing work")
                .arg(
                    opt("workpacket", "Current work packet")
                        .default_value("WP-0001"),
                )
                .arg(opt("summary", "Optional one-line handoff summary"))
                .arg(format()),
        )
}'''

    text = replace_function(text, "context_cmd", context_cmd)

    context_code = r'''
#[derive(Debug, Clone, Serialize)]
struct ContextFileEntry {
    category: &'static str,
    path: String,
    exists: bool,
    bytes: Option<u64>,
    purpose: String,
}

#[derive(Debug, Serialize)]
struct ContextPackOutput {
    schema_version: u32,
    command: &'static str,
    subcommand: &'static str,
    status: &'static str,
    workspace_root: String,
    include: String,
    max_files: usize,
    did_mutate: bool,
    file_count: usize,
    existing_file_count: usize,
    missing_file_count: usize,
    files: Vec<ContextFileEntry>,
    notes: Vec<String>,
}

#[derive(Debug, Clone, Serialize)]
struct ContextVerifyFinding {
    severity: &'static str,
    code: &'static str,
    path: String,
    message: String,
}

#[derive(Debug, Serialize)]
struct ContextVerifyOutput {
    schema_version: u32,
    command: &'static str,
    subcommand: &'static str,
    status: &'static str,
    workspace_root: String,
    strict: bool,
    did_mutate: bool,
    error_count: usize,
    warning_count: usize,
    info_count: usize,
    findings: Vec<ContextVerifyFinding>,
    notes: Vec<String>,
}

#[derive(Debug, Serialize)]
struct ContextHandoffOutput {
    schema_version: u32,
    command: &'static str,
    subcommand: &'static str,
    status: &'static str,
    workspace_root: String,
    current_workpacket: String,
    summary: String,
    did_mutate: bool,
    command_surface_total: usize,
    command_surface_plan_backed: usize,
    implemented_read_only_commands: Vec<&'static str>,
    important_files: Vec<ContextFileEntry>,
    next_actions: Vec<String>,
    notes: Vec<String>,
}

fn emit_context(matches: &ArgMatches, json: bool) -> Result<(), String> {
    match matches.subcommand() {
        Some(("pack", sub)) => emit_context_pack(sub, json),
        Some(("verify", sub)) => emit_context_verify(sub, json),
        Some(("handoff", sub)) => emit_context_handoff(sub, json),
        Some((other, _)) => Err(format!("unsupported context subcommand `{other}`")),
        None => emit_context_overview(matches, json),
    }
}

fn emit_context_overview(matches: &ArgMatches, json: bool) -> Result<(), String> {
    let format = matches
        .get_one::<String>("format")
        .map(String::as_str)
        .unwrap_or("text");

    let root = context_workspace_root();
    let output = build_context_pack_output(&root, "all", 12);
    let rendered = render_context_pack_output(&output, if json { "json" } else { format })?;

    println!("{rendered}");

    Ok(())
}

fn emit_context_pack(matches: &ArgMatches, json: bool) -> Result<(), String> {
    let include = matches
        .get_one::<String>("include")
        .map(String::as_str)
        .unwrap_or("all");

    let max_files = matches
        .get_one::<String>("max-files")
        .and_then(|value| value.parse::<usize>().ok())
        .unwrap_or(40);

    let format = matches
        .get_one::<String>("format")
        .map(String::as_str)
        .unwrap_or("text");

    let root = context_workspace_root();
    let output = build_context_pack_output(&root, include, max_files);
    let rendered = render_context_pack_output(&output, if json { "json" } else { format })?;

    println!("{rendered}");

    Ok(())
}

fn emit_context_verify(matches: &ArgMatches, json: bool) -> Result<(), String> {
    let strict = matches.get_flag("strict");

    let format = matches
        .get_one::<String>("format")
        .map(String::as_str)
        .unwrap_or("text");

    let root = context_workspace_root();
    let output = build_context_verify_output(&root, strict);
    let rendered = render_context_verify_output(&output, if json { "json" } else { format })?;

    println!("{rendered}");

    if output.error_count > 0 || (strict && output.warning_count > 0) {
        Err(format!(
            "context verify failed with {} error(s) and {} warning(s)",
            output.error_count, output.warning_count
        ))
    } else {
        Ok(())
    }
}

fn emit_context_handoff(matches: &ArgMatches, json: bool) -> Result<(), String> {
    let workpacket = matches
        .get_one::<String>("workpacket")
        .cloned()
        .unwrap_or_else(|| "WP-0001".to_string());

    let summary = matches
        .get_one::<String>("summary")
        .cloned()
        .unwrap_or_else(|| "Continue Monad CLI WP-0001 Rust workspace and CLI skeleton implementation.".to_string());

    let format = matches
        .get_one::<String>("format")
        .map(String::as_str)
        .unwrap_or("text");

    let root = context_workspace_root();
    let output = build_context_handoff_output(&root, workpacket, summary);
    let rendered = render_context_handoff_output(&output, if json { "json" } else { format })?;

    println!("{rendered}");

    Ok(())
}

fn context_workspace_root() -> std::path::PathBuf {
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

fn context_file(
    root: &std::path::Path,
    category: &'static str,
    path: &str,
    purpose: &str,
) -> ContextFileEntry {
    let absolute = root.join(path);
    let metadata = std::fs::metadata(&absolute).ok();

    ContextFileEntry {
        category,
        path: path.to_string(),
        exists: absolute.is_file(),
        bytes: metadata.map(|metadata| metadata.len()),
        purpose: purpose.to_string(),
    }
}

fn context_candidate_files(root: &std::path::Path) -> Vec<ContextFileEntry> {
    let mut files = vec![
        context_file(root, "manifests", "monad.toml", "canonical Monad manifest"),
        context_file(root, "manifests", "workspace.toml", "compatibility mirror manifest"),
        context_file(root, "manifests", "monad.lock", "Monad lockfile"),
        context_file(root, "manifests", "Cargo.toml", "Cargo workspace manifest"),
        context_file(root, "manifests", "deny.toml", "cargo-deny configuration"),
        context_file(root, "cli", "crates/monad-cli/Cargo.toml", "CLI crate manifest"),
        context_file(root, "cli", "crates/monad-cli/src/lib.rs", "CLI implementation"),
        context_file(root, "cli", "crates/monad-cli/src/main.rs", "CLI binary entrypoint"),
        context_file(root, "cli", "crates/monad-cli/tests/smoke.rs", "CLI smoke test"),
        context_file(root, "crates", "crates/monad-core/src/lib.rs", "core runtime defaults"),
        context_file(root, "crates", "crates/monad-core/src/command_catalog.rs", "approved command catalog"),
        context_file(root, "crates", "crates/monad-plans/src/lib.rs", "plan primitives"),
        context_file(root, "crates", "crates/monad-packs/src/lib.rs", "pack catalog primitives"),
        context_file(root, "crates", "crates/monad-policy/src/lib.rs", "policy primitives"),
        context_file(root, "crates", "crates/monad-context/src/lib.rs", "context primitives"),
        context_file(root, "crates", "crates/monad-graph/src/lib.rs", "graph primitives"),
        context_file(root, "docs", "README.md", "repository README"),
        context_file(root, "docs", "AGENTS.md", "agent/operator instructions"),
        context_file(root, "governance", "governance/README.md", "governance surface entrypoint"),
        context_file(root, "governance", "docs/work-packets/WP-0001.md", "current WP-0001 work packet, if present"),
    ];

    files.sort_by(|left, right| {
        left.category
            .cmp(right.category)
            .then_with(|| left.path.cmp(&right.path))
    });

    files
}

fn context_include_matches(include: &str, category: &str) -> bool {
    if include == "all" {
        return true;
    }

    include
        .split(',')
        .map(str::trim)
        .filter(|part| !part.is_empty())
        .any(|part| part.eq_ignore_ascii_case(category) || part.eq_ignore_ascii_case("all"))
}

fn build_context_pack_output(
    root: &std::path::Path,
    include: &str,
    max_files: usize,
) -> ContextPackOutput {
    let mut files = context_candidate_files(root)
        .into_iter()
        .filter(|file| context_include_matches(include, file.category))
        .collect::<Vec<_>>();

    files.truncate(max_files);

    let existing_file_count = files.iter().filter(|file| file.exists).count();
    let missing_file_count = files.iter().filter(|file| !file.exists).count();

    ContextPackOutput {
        schema_version: monad_core::MANIFEST_SCHEMA_VERSION,
        command: "context",
        subcommand: "pack",
        status: "implemented",
        workspace_root: root.display().to_string(),
        include: include.to_string(),
        max_files,
        did_mutate: false,
        file_count: files.len(),
        existing_file_count,
        missing_file_count,
        files,
        notes: vec![
            "`monad context pack` is read-only and emits an inventory, not a bundled archive, in WP-0001.".to_string(),
            "The output is designed to help humans, scripts, and AI tools understand which files matter for handoff.".to_string(),
        ],
    }
}

fn build_context_verify_output(root: &std::path::Path, strict: bool) -> ContextVerifyOutput {
    let mut findings = Vec::new();

    for required in [
        ("monad.toml", "MONAD_CONTEXT_CANONICAL_MANIFEST", "canonical Monad manifest"),
        ("workspace.toml", "MONAD_CONTEXT_COMPATIBILITY_MANIFEST", "compatibility manifest mirror"),
        ("Cargo.toml", "MONAD_CONTEXT_CARGO_WORKSPACE", "Cargo workspace manifest"),
        ("crates/monad-cli/src/lib.rs", "MONAD_CONTEXT_CLI_LIB", "CLI library implementation"),
        ("crates/monad-core/src/command_catalog.rs", "MONAD_CONTEXT_COMMAND_CATALOG", "approved command catalog"),
    ] {
        let exists = root.join(required.0).is_file();

        findings.push(ContextVerifyFinding {
            severity: if exists { "info" } else { "error" },
            code: required.1,
            path: required.0.to_string(),
            message: if exists {
                format!("required context file `{}` exists ({})", required.0, required.2)
            } else {
                format!("required context file `{}` is missing ({})", required.0, required.2)
            },
        });
    }

    for recommended in [
        ("README.md", "MONAD_CONTEXT_README", "repository README"),
        ("AGENTS.md", "MONAD_CONTEXT_AGENTS", "agent/operator instructions"),
        ("docs", "MONAD_CONTEXT_DOCS_DIR", "documentation directory"),
        ("governance", "MONAD_CONTEXT_GOVERNANCE_DIR", "governance directory"),
    ] {
        let exists = root.join(recommended.0).exists();

        findings.push(ContextVerifyFinding {
            severity: if exists { "info" } else { "warning" },
            code: recommended.1,
            path: recommended.0.to_string(),
            message: if exists {
                format!("recommended context path `{}` exists ({})", recommended.0, recommended.2)
            } else {
                format!("recommended context path `{}` is missing ({})", recommended.0, recommended.2)
            },
        });
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

    ContextVerifyOutput {
        schema_version: monad_core::MANIFEST_SCHEMA_VERSION,
        command: "context",
        subcommand: "verify",
        status,
        workspace_root: root.display().to_string(),
        strict,
        did_mutate: false,
        error_count,
        warning_count,
        info_count,
        findings,
        notes: vec![
            "`monad context verify` checks handoff/context readiness only; use `monad check` for repository correctness.".to_string(),
            "Warnings are non-blocking unless --strict is provided.".to_string(),
        ],
    }
}

fn build_context_handoff_output(
    root: &std::path::Path,
    workpacket: String,
    summary: String,
) -> ContextHandoffOutput {
    let important_files = context_candidate_files(root)
        .into_iter()
        .filter(|file| {
            matches!(
                file.path.as_str(),
                "monad.toml"
                    | "workspace.toml"
                    | "Cargo.toml"
                    | "crates/monad-cli/src/lib.rs"
                    | "crates/monad-core/src/command_catalog.rs"
                    | "crates/monad-plans/src/lib.rs"
                    | "crates/monad-packs/src/lib.rs"
            )
        })
        .collect::<Vec<_>>();

    let commands = monad_core::command_catalog::approved_commands();
    let command_surface_total = commands.len();
    let command_surface_plan_backed = commands.iter().filter(|command| command.plan_backed).count();

    ContextHandoffOutput {
        schema_version: monad_core::MANIFEST_SCHEMA_VERSION,
        command: "context",
        subcommand: "handoff",
        status: "implemented",
        workspace_root: root.display().to_string(),
        current_workpacket: workpacket,
        summary,
        did_mutate: false,
        command_surface_total,
        command_surface_plan_backed,
        implemented_read_only_commands: vec![
            "version",
            "pack list",
            "plan",
            "apply preview",
            "check",
            "doctor",
            "inspect",
            "list",
            "graph",
            "config",
            "diff",
            "context",
        ],
        important_files,
        next_actions: vec![
            "Run cargo fmt --all --check, cargo check --workspace, and cargo test --workspace.".to_string(),
            "Continue replacing placeholder command surfaces with safe read-only or plan-backed behavior.".to_string(),
            "Keep mutating commands dry-run/plan-backed before allowing real repository writes.".to_string(),
        ],
        notes: vec![
            "`monad context handoff` is read-only and intended for session continuation.".to_string(),
            "Monad remains AI-ready but AI-optional; this handoff format is useful without any AI provider.".to_string(),
        ],
    }
}

fn render_context_pack_output(output: &ContextPackOutput, format: &str) -> Result<String, String> {
    match format {
        "json" => serde_json::to_string_pretty(output).map_err(|error| error.to_string()),
        "markdown" => Ok(render_context_pack_markdown(output)),
        "text" => Ok(render_context_pack_text(output)),
        other => Err(format!("unsupported context pack output format `{other}`")),
    }
}

fn render_context_verify_output(output: &ContextVerifyOutput, format: &str) -> Result<String, String> {
    match format {
        "json" => serde_json::to_string_pretty(output).map_err(|error| error.to_string()),
        "markdown" => Ok(render_context_verify_markdown(output)),
        "text" => Ok(render_context_verify_text(output)),
        other => Err(format!("unsupported context verify output format `{other}`")),
    }
}

fn render_context_handoff_output(output: &ContextHandoffOutput, format: &str) -> Result<String, String> {
    match format {
        "json" => serde_json::to_string_pretty(output).map_err(|error| error.to_string()),
        "markdown" => Ok(render_context_handoff_markdown(output)),
        "text" => Ok(render_context_handoff_text(output)),
        other => Err(format!("unsupported context handoff output format `{other}`")),
    }
}

fn render_context_pack_text(output: &ContextPackOutput) -> String {
    let mut rendered = String::new();

    rendered.push_str("Monad Context Pack\n");
    rendered.push_str("==================\n\n");
    rendered.push_str(&format!("status: {}\n", output.status));
    rendered.push_str(&format!("workspace root: {}\n", output.workspace_root));
    rendered.push_str(&format!("include: {}\n", output.include));
    rendered.push_str(&format!("max files: {}\n", output.max_files));
    rendered.push_str(&format!("did mutate: {}\n", output.did_mutate));
    rendered.push_str(&format!("files: {}\n", output.file_count));
    rendered.push_str(&format!("existing: {}\n", output.existing_file_count));
    rendered.push_str(&format!("missing: {}\n", output.missing_file_count));
    rendered.push_str("\nfiles:\n");

    for file in &output.files {
        rendered.push_str(&format!(
            "  - [{}] {} exists={} bytes={} — {}\n",
            file.category,
            file.path,
            file.exists,
            file.bytes
                .map(|bytes| bytes.to_string())
                .unwrap_or_else(|| "n/a".to_string()),
            file.purpose
        ));
    }

    rendered.push_str("\nnotes:\n");
    for note in &output.notes {
        rendered.push_str(&format!("  - {note}\n"));
    }

    rendered
}

fn render_context_pack_markdown(output: &ContextPackOutput) -> String {
    let mut rendered = String::new();

    rendered.push_str("# Monad Context Pack\n\n");
    rendered.push_str(&format!("- **Status:** `{}`\n", output.status));
    rendered.push_str(&format!("- **Workspace root:** `{}`\n", output.workspace_root));
    rendered.push_str(&format!("- **Include:** `{}`\n", output.include));
    rendered.push_str(&format!("- **Max files:** `{}`\n", output.max_files));
    rendered.push_str(&format!("- **Did mutate:** `{}`\n", output.did_mutate));
    rendered.push_str(&format!("- **Files:** `{}`\n", output.file_count));
    rendered.push_str(&format!("- **Existing:** `{}`\n", output.existing_file_count));
    rendered.push_str(&format!("- **Missing:** `{}`\n\n", output.missing_file_count));

    rendered.push_str("## Files\n\n");
    rendered.push_str("| Category | Path | Exists | Bytes | Purpose |\n");
    rendered.push_str("|---|---|---|---:|---|\n");

    for file in &output.files {
        rendered.push_str(&format!(
            "| `{}` | `{}` | `{}` | `{}` | {} |\n",
            file.category,
            file.path,
            file.exists,
            file.bytes
                .map(|bytes| bytes.to_string())
                .unwrap_or_else(|| "n/a".to_string()),
            file.purpose.replace('|', "\\|")
        ));
    }

    rendered.push_str("\n## Notes\n\n");
    for note in &output.notes {
        rendered.push_str(&format!("- {note}\n"));
    }

    rendered
}

fn render_context_verify_text(output: &ContextVerifyOutput) -> String {
    let mut rendered = String::new();

    rendered.push_str("Monad Context Verify\n");
    rendered.push_str("====================\n\n");
    rendered.push_str(&format!("status: {}\n", output.status));
    rendered.push_str(&format!("workspace root: {}\n", output.workspace_root));
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

fn render_context_verify_markdown(output: &ContextVerifyOutput) -> String {
    let mut rendered = String::new();

    rendered.push_str("# Monad Context Verify\n\n");
    rendered.push_str(&format!("- **Status:** `{}`\n", output.status));
    rendered.push_str(&format!("- **Workspace root:** `{}`\n", output.workspace_root));
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

fn render_context_handoff_text(output: &ContextHandoffOutput) -> String {
    let mut rendered = String::new();

    rendered.push_str("Monad Context Handoff\n");
    rendered.push_str("=====================\n\n");
    rendered.push_str(&format!("status: {}\n", output.status));
    rendered.push_str(&format!("workspace root: {}\n", output.workspace_root));
    rendered.push_str(&format!("current workpacket: {}\n", output.current_workpacket));
    rendered.push_str(&format!("summary: {}\n", output.summary));
    rendered.push_str(&format!("did mutate: {}\n", output.did_mutate));
    rendered.push_str(&format!("command surface total: {}\n", output.command_surface_total));
    rendered.push_str(&format!(
        "plan-backed commands: {}\n",
        output.command_surface_plan_backed
    ));

    rendered.push_str("\nimplemented read-only/safe commands:\n");
    for command in &output.implemented_read_only_commands {
        rendered.push_str(&format!("  - {command}\n"));
    }

    rendered.push_str("\nimportant files:\n");
    for file in &output.important_files {
        rendered.push_str(&format!(
            "  - [{}] {} exists={} — {}\n",
            file.category, file.path, file.exists, file.purpose
        ));
    }

    rendered.push_str("\nnext actions:\n");
    for action in &output.next_actions {
        rendered.push_str(&format!("  - {action}\n"));
    }

    rendered.push_str("\nnotes:\n");
    for note in &output.notes {
        rendered.push_str(&format!("  - {note}\n"));
    }

    rendered
}

fn render_context_handoff_markdown(output: &ContextHandoffOutput) -> String {
    let mut rendered = String::new();

    rendered.push_str("# Monad Context Handoff\n\n");
    rendered.push_str(&format!("- **Status:** `{}`\n", output.status));
    rendered.push_str(&format!("- **Workspace root:** `{}`\n", output.workspace_root));
    rendered.push_str(&format!(
        "- **Current workpacket:** `{}`\n",
        output.current_workpacket
    ));
    rendered.push_str(&format!("- **Summary:** {}\n", output.summary));
    rendered.push_str(&format!("- **Did mutate:** `{}`\n", output.did_mutate));
    rendered.push_str(&format!(
        "- **Command surface total:** `{}`\n",
        output.command_surface_total
    ));
    rendered.push_str(&format!(
        "- **Plan-backed commands:** `{}`\n\n",
        output.command_surface_plan_backed
    ));

    rendered.push_str("## Implemented Read-only/Safe Commands\n\n");
    for command in &output.implemented_read_only_commands {
        rendered.push_str(&format!("- `{command}`\n"));
    }

    rendered.push_str("\n## Important Files\n\n");
    for file in &output.important_files {
        rendered.push_str(&format!(
            "- `{}` — category `{}`, exists `{}`, purpose: {}\n",
            file.path, file.category, file.exists, file.purpose
        ));
    }

    rendered.push_str("\n## Next Actions\n\n");
    for action in &output.next_actions {
        rendered.push_str(&format!("- {action}\n"));
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
        "struct ContextFileEntry",
        context_code,
        [
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
fn context_pack_outputs_text_inventory() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .current_dir(workspace_root())
        .args(["context", "pack"])
        .output()
        .expect("monad context pack should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("Monad Context Pack"));
    assert!(stdout.contains("status: implemented"));
    assert!(stdout.contains("did mutate: false"));
    assert!(stdout.contains("monad.toml"));
    assert!(stdout.contains("crates/monad-cli/src/lib.rs"));
}

#[test]
fn context_pack_outputs_json_inventory() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .current_dir(workspace_root())
        .args(["context", "pack", "--include", "manifests", "--format", "json"])
        .output()
        .expect("monad context pack --format json should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains(r#""command": "context""#));
    assert!(stdout.contains(r#""subcommand": "pack""#));
    assert!(stdout.contains(r#""include": "manifests""#));
    assert!(stdout.contains(r#""did_mutate": false"#));
    assert!(stdout.contains(r#""path": "monad.toml""#));
}

#[test]
fn context_verify_passes_for_workspace() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .current_dir(workspace_root())
        .args(["context", "verify"])
        .output()
        .expect("monad context verify should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("Monad Context Verify");
    assert!(stdout.contains("status: passed"));
    assert!(stdout.contains("did mutate: false"));
    assert!(stdout.contains("MONAD_CONTEXT_CANONICAL_MANIFEST"));
}

#[test]
fn context_handoff_outputs_handoff_summary() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .current_dir(workspace_root())
        .args(["context", "handoff", "--workpacket", "WP-0001"])
        .output()
        .expect("monad context handoff should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("Monad Context Handoff"));
    assert!(stdout.contains("current workpacket: WP-0001"));
    assert!(stdout.contains("command surface total:"));
    assert!(stdout.contains("next actions:"));
}

#[test]
fn context_handoff_outputs_markdown() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .current_dir(workspace_root())
        .args(["context", "handoff", "--format", "markdown"])
        .output()
        .expect("monad context handoff --format markdown should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("# Monad Context Handoff"));
    assert!(stdout.contains("## Important Files"));
    assert!(stdout.contains("## Next Actions"));
}
'''
    )

    print("Applied layer-0002-hotfix-0024-implement-monad-context")
    print()
    print("Changed:")
    print("  - crates/monad-cli/src/lib.rs")
    print("  - crates/monad-cli/tests/context_command.rs")
    print("Backup:")
    print(f"  - {backup.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
