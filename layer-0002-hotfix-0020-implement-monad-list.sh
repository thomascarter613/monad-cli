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

cp "$CLI_RS" "$CLI_RS.bak.layer-0002-hotfix-0020"

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

if 'Some(("list", sub)) => emit_list(sub, json),' not in text:
    marker_candidates = [
        'Some(("inspect", sub)) => emit_inspect(sub, json),',
        'Some(("doctor", sub)) => emit_doctor(sub, json),',
        'Some(("check", sub)) => emit_check(sub, json),',
        'Some(("version", sub)) => emit_version(sub, json),',
    ]

    for marker in marker_candidates:
        if marker in text:
            text = text.replace(marker, marker + '\n        Some(("list", sub)) => emit_list(sub, json),', 1)
            break
    else:
        raise SystemExit("ERROR: could not find dispatch insertion point")

list_cmd = r'''fn list_cmd() -> Command {
    Command::new("list")
        .about("List workspace inventory: crates, manifests, commands, packs, and managed surfaces")
        .arg(
            arg("kind", "Inventory kind to list")
                .required(false)
                .value_parser(["all", "crates", "manifests", "commands", "packs", "surfaces"]),
        )
        .arg(opt("scope", "Optional scope filter reserved for future workspace units"))
        .arg(fmt_arg().value_parser(["text", "json", "markdown"]))
}'''

text = replace_function(text, "list_cmd", list_cmd)

insert_before_candidates = [
    '\n#[derive(Debug, Clone, Serialize)]\nstruct InspectManifest',
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
    raise SystemExit("ERROR: could not find insertion point for list command code")

list_code = r'''
#[derive(Debug, Clone, Serialize)]
struct ListItem {
    kind: String,
    name: String,
    path: Option<String>,
    status: String,
    description: String,
}

#[derive(Debug, Serialize)]
struct ListCommandOutput {
    schema_version: u32,
    command: &'static str,
    status: &'static str,
    requested_kind: String,
    scope: Option<String>,
    did_mutate: bool,
    total_count: usize,
    items: Vec<ListItem>,
    notes: Vec<String>,
}

fn emit_list(matches: &ArgMatches, json: bool) -> Result<(), String> {
    let requested_kind = matches
        .get_one::<String>("kind")
        .map(String::as_str)
        .unwrap_or("all");

    let scope = matches.get_one::<String>("scope").cloned();

    let format = matches
        .get_one::<String>("format")
        .map(String::as_str)
        .unwrap_or("text");

    let output = build_list_output(requested_kind, scope);
    let rendered = render_list_output(&output, if json { "json" } else { format })?;

    println!("{rendered}");

    Ok(())
}

fn build_list_output(requested_kind: &str, scope: Option<String>) -> ListCommandOutput {
    let mut items = Vec::new();

    if list_includes(requested_kind, "manifests") {
        items.extend(list_manifest_items(std::path::Path::new(".")));
    }

    if list_includes(requested_kind, "crates") {
        items.extend(list_crate_items(std::path::Path::new(".")));
    }

    if list_includes(requested_kind, "commands") {
        items.extend(list_command_items());
    }

    if list_includes(requested_kind, "packs") {
        items.extend(list_pack_items());
    }

    if list_includes(requested_kind, "surfaces") {
        items.extend(list_surface_items(std::path::Path::new(".")));
    }

    if let Some(scope_filter) = scope.as_deref() {
        let lowered = scope_filter.to_lowercase();
        items.retain(|item| {
            item.name.to_lowercase().contains(&lowered)
                || item
                    .path
                    .as_deref()
                    .unwrap_or_default()
                    .to_lowercase()
                    .contains(&lowered)
                || item.description.to_lowercase().contains(&lowered)
        });
    }

    items.sort_by(|left, right| {
        left.kind
            .cmp(&right.kind)
            .then_with(|| left.name.cmp(&right.name))
            .then_with(|| left.path.cmp(&right.path))
    });

    ListCommandOutput {
        schema_version: monad_core::MANIFEST_SCHEMA_VERSION,
        command: "list",
        status: "implemented",
        requested_kind: requested_kind.to_string(),
        scope,
        did_mutate: false,
        total_count: items.len(),
        items,
        notes: vec![
            "`monad list` is read-only and reports the current local inventory using WP-0001 filesystem/catalog heuristics.".to_string(),
            "Use `monad inspect` for a structured workspace summary and `monad check` for pass/fail validation.".to_string(),
        ],
    }
}

fn list_includes(requested_kind: &str, section: &str) -> bool {
    requested_kind == "all" || requested_kind == section
}

fn list_manifest_items(root: &std::path::Path) -> Vec<ListItem> {
    [
        ("monad.toml", "canonical Monad manifest"),
        ("workspace.toml", "compatibility manifest mirror"),
        ("monad.lock", "Monad lockfile"),
        ("Cargo.toml", "Cargo workspace manifest"),
        ("deny.toml", "cargo-deny configuration"),
        (".monorepo.json", "monorepo compatibility/introspection metadata"),
    ]
    .iter()
    .map(|(relative, description)| {
        let exists = root.join(relative).is_file();

        ListItem {
            kind: "manifest".to_string(),
            name: (*relative).to_string(),
            path: Some((*relative).to_string()),
            status: if exists { "present" } else { "missing" }.to_string(),
            description: (*description).to_string(),
        }
    })
    .collect()
}

fn list_crate_items(root: &std::path::Path) -> Vec<ListItem> {
    let mut items = Vec::new();
    let crates_root = root.join("crates");

    let Ok(entries) = std::fs::read_dir(&crates_root) else {
        return items;
    };

    for entry in entries.flatten() {
        let crate_dir = entry.path();

        if !crate_dir.is_dir() || !crate_dir.join("Cargo.toml").is_file() {
            continue;
        }

        let relative = crate_dir
            .strip_prefix(root)
            .unwrap_or(&crate_dir)
            .to_string_lossy()
            .replace('\\', "/");

        let cargo_contents = std::fs::read_to_string(crate_dir.join("Cargo.toml")).unwrap_or_default();

        let name = cargo_contents
            .lines()
            .map(str::trim)
            .find_map(|line| {
                let rest = line.strip_prefix("name")?.trim_start();
                let value = rest.strip_prefix('=')?.trim().trim_matches('"');
                (!value.is_empty()).then(|| value.to_string())
            })
            .unwrap_or_else(|| relative.clone());

        let has_lib = crate_dir.join("src/lib.rs").is_file();
        let has_bin = crate_dir.join("src/main.rs").is_file();

        let description = match (has_lib, has_bin) {
            (true, true) => "Rust crate with library and binary entrypoint",
            (true, false) => "Rust library crate",
            (false, true) => "Rust binary crate",
            (false, false) => "Rust crate manifest without src/lib.rs or src/main.rs",
        };

        items.push(ListItem {
            kind: "crate".to_string(),
            name,
            path: Some(relative),
            status: "present".to_string(),
            description: description.to_string(),
        });
    }

    items
}

fn list_command_items() -> Vec<ListItem> {
    monad_core::command_catalog::approved_commands()
        .into_iter()
        .map(|command| ListItem {
            kind: "command".to_string(),
            name: command.path.to_string(),
            path: None,
            status: if command.plan_backed {
                "plan-backed"
            } else {
                "read-only-or-execution"
            }
            .to_string(),
            description: format!(
                "kind={:?}; supports_dry_run={}",
                command.kind, command.supports_dry_run
            ),
        })
        .collect()
}

fn list_pack_items() -> Vec<ListItem> {
    monad_packs::builtin_packs()
        .into_iter()
        .map(|pack| ListItem {
            kind: "pack".to_string(),
            name: pack.id.to_string(),
            path: None,
            status: pack.kind,
            description: format!("{} {} — {}", pack.name, pack.version, pack.description),
        })
        .collect()
}

fn list_surface_items(root: &std::path::Path) -> Vec<ListItem> {
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
    .map(|(relative, description)| {
        let exists = root.join(relative).exists();

        ListItem {
            kind: "surface".to_string(),
            name: (*relative).to_string(),
            path: Some((*relative).to_string()),
            status: if exists { "present" } else { "missing" }.to_string(),
            description: (*description).to_string(),
        }
    })
    .collect()
}

fn render_list_output(output: &ListCommandOutput, format: &str) -> Result<String, String> {
    match format {
        "json" => serde_json::to_string_pretty(output).map_err(|error| error.to_string()),
        "markdown" => Ok(render_list_markdown(output)),
        "text" => Ok(render_list_text(output)),
        other => Err(format!("unsupported list output format `{other}`")),
    }
}

fn render_list_text(output: &ListCommandOutput) -> String {
    let mut rendered = String::new();

    rendered.push_str("Monad List\n");
    rendered.push_str("==========\n\n");
    rendered.push_str(&format!("status: {}\n", output.status));
    rendered.push_str(&format!("kind: {}\n", output.requested_kind));
    rendered.push_str(&format!(
        "scope: {}\n",
        output.scope.as_deref().unwrap_or("none")
    ));
    rendered.push_str(&format!("did mutate: {}\n", output.did_mutate));
    rendered.push_str(&format!("total: {}\n", output.total_count));
    rendered.push_str("\nitems:\n");

    for item in &output.items {
        rendered.push_str(&format!(
            "  - [{}] {} status={} path={} — {}\n",
            item.kind,
            item.name,
            item.status,
            item.path.as_deref().unwrap_or("n/a"),
            item.description
        ));
    }

    rendered.push_str("\nnotes:\n");
    for note in &output.notes {
        rendered.push_str(&format!("  - {note}\n"));
    }

    rendered
}

fn render_list_markdown(output: &ListCommandOutput) -> String {
    let mut rendered = String::new();

    rendered.push_str("# Monad List\n\n");
    rendered.push_str(&format!("- **Status:** `{}`\n", output.status));
    rendered.push_str(&format!("- **Kind:** `{}`\n", output.requested_kind));
    rendered.push_str(&format!(
        "- **Scope:** `{}`\n",
        output.scope.as_deref().unwrap_or("none")
    ));
    rendered.push_str(&format!("- **Did mutate:** `{}`\n", output.did_mutate));
    rendered.push_str(&format!("- **Total:** `{}`\n\n", output.total_count));

    rendered.push_str("## Items\n\n");
    rendered.push_str("| Kind | Name | Status | Path | Description |\n");
    rendered.push_str("|---|---|---|---|---|\n");

    for item in &output.items {
        rendered.push_str(&format!(
            "| `{}` | `{}` | `{}` | `{}` | {} |\n",
            item.kind,
            item.name,
            item.status,
            item.path.as_deref().unwrap_or("n/a"),
            item.description.replace('|', "\\|")
        ));
    }

    rendered.push_str("\n## Notes\n\n");
    for note in &output.notes {
        rendered.push_str(&format!("- {note}\n"));
    }

    rendered
}

'''

text = text.replace(insert_before, "\n" + list_code + insert_before, 1)
path.write_text(text)
PY

mkdir -p crates/monad-cli/tests

cat > crates/monad-cli/tests/list_command.rs <<'RS'
use std::process::Command;

#[test]
fn list_all_outputs_text_inventory() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .arg("list")
        .output()
        .expect("monad list should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("Monad List"));
    assert!(stdout.contains("status: implemented"));
    assert!(stdout.contains("kind: all"));
    assert!(stdout.contains("did mutate: false"));
    assert!(stdout.contains("[manifest] monad.toml"));
    assert!(stdout.contains("[crate] monad-cli"));
    assert!(stdout.contains("[command] add"));
    assert!(stdout.contains("[pack] official.typescript"));
}

#[test]
fn list_crates_outputs_only_crate_inventory() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["list", "crates"])
        .output()
        .expect("monad list crates should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("kind: crates"));
    assert!(stdout.contains("[crate] monad-cli"));
    assert!(stdout.contains("[crate] monad-core"));
    assert!(!stdout.contains("[pack] official.typescript"));
}

#[test]
fn list_commands_outputs_command_catalog() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["list", "commands"])
        .output()
        .expect("monad list commands should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("kind: commands"));
    assert!(stdout.contains("[command] init"));
    assert!(stdout.contains("[command] add"));
    assert!(stdout.contains("[command] policy check"));
    assert!(stdout.contains("[command] workpacket plan"));
}

#[test]
fn list_packs_outputs_pack_catalog_as_json() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["list", "packs", "--format", "json"])
        .output()
        .expect("monad list packs --format json should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains(r#""command": "list""#));
    assert!(stdout.contains(r#""requested_kind": "packs""#));
    assert!(stdout.contains(r#""name": "official.typescript""#));
    assert!(stdout.contains(r#""name": "official.docs""#));
    assert!(stdout.contains(r#""did_mutate": false"#));
}

#[test]
fn list_markdown_outputs_table() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["list", "manifests", "--format", "markdown"])
        .output()
        .expect("monad list manifests --format markdown should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("# Monad List"));
    assert!(stdout.contains("| Kind | Name | Status | Path | Description |"));
    assert!(stdout.contains("`monad.toml`"));
}
RS

cargo fmt --all

echo
echo "Applied layer-0002-hotfix-0020-implement-monad-list"
echo
echo "Implemented:"
echo "  - monad list text/json/markdown output"
echo "  - inventory for crates, manifests, commands, packs, and managed surfaces"
echo "  - optional --scope substring filtering"
echo "  - read-only did_mutate=false behavior"
echo "  - list command integration tests"
