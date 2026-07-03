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

if [ ! -f "crates/monad-plans/src/lib.rs" ]; then
  echo "ERROR: crates/monad-plans/src/lib.rs not found." >&2
  exit 1
fi

cp crates/monad-cli/src/lib.rs crates/monad-cli/src/lib.rs.bak.layer-0002-hotfix-0014
cp crates/monad-plans/src/lib.rs crates/monad-plans/src/lib.rs.bak.layer-0002-hotfix-0014
cp crates/monad-plans/Cargo.toml crates/monad-plans/Cargo.toml.bak.layer-0002-hotfix-0014

cat > crates/monad-plans/Cargo.toml <<'TOML'
[package]
name = "monad-plans"
version = "0.1.0"
edition = "2021"
license = "MIT"
publish = false

[lib]
path = "src/lib.rs"

[dependencies]
serde = { version = "1", features = ["derive"] }
TOML

cat > crates/monad-plans/src/lib.rs <<'RS'
//! Plan primitives for mutating Monad operations.
//!
//! Monad mutating commands are expected to become plan-backed. At WP-0001 this
//! crate provides the minimal stable data model for representing a plan.

use serde::Serialize;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
#[serde(rename_all = "snake_case")]
pub enum PlanMode {
    DryRun,
    Apply,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
#[serde(rename_all = "snake_case")]
pub enum PlanStepKind {
    CreateFile,
    UpdateFile,
    DeleteFile,
    CreateDirectory,
    RunCommand,
    Validate,
    Other(String),
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
pub struct PlanStep {
    pub kind: PlanStepKind,
    pub summary: String,
}

impl PlanStep {
    pub fn new(kind: PlanStepKind, summary: impl Into<String>) -> Self {
        Self {
            kind,
            summary: summary.into(),
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
pub struct ChangePlan {
    pub operation: String,
    pub mode: PlanMode,
    pub steps: Vec<PlanStep>,
}

impl ChangePlan {
    pub fn dry_run(operation: impl Into<String>) -> Self {
        Self {
            operation: operation.into(),
            mode: PlanMode::DryRun,
            steps: Vec::new(),
        }
    }

    pub fn apply(operation: impl Into<String>) -> Self {
        Self {
            operation: operation.into(),
            mode: PlanMode::Apply,
            steps: Vec::new(),
        }
    }

    pub fn push_step(&mut self, step: PlanStep) {
        self.steps.push(step);
    }

    pub fn with_step(mut self, step: PlanStep) -> Self {
        self.push_step(step);
        self
    }

    pub fn is_empty(&self) -> bool {
        self.steps.is_empty()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn dry_run_plan_starts_empty_and_accepts_steps() {
        let mut plan = ChangePlan::dry_run("add app web");
        assert_eq!(plan.mode, PlanMode::DryRun);
        assert!(plan.is_empty());

        plan.push_step(PlanStep::new(
            PlanStepKind::CreateDirectory,
            "create apps/web",
        ));

        assert!(!plan.is_empty());
        assert_eq!(plan.steps.len(), 1);
    }

    #[test]
    fn apply_plan_uses_apply_mode() {
        let plan = ChangePlan::apply("release apply");
        assert_eq!(plan.mode, PlanMode::Apply);
    }
}
RS

python3 - <<'PY'
from pathlib import Path
import re

path = Path("crates/monad-cli/src/lib.rs")
text = path.read_text()

old = '''Some(("version", sub)) => emit_version(sub, json),
        Some(("pack", sub)) if matches_subcommand(sub, "list") => emit_pack_list(json),
        Some((command, sub)) => {'''

new = '''Some(("version", sub)) => emit_version(sub, json),
        Some(("plan", sub)) => emit_plan(sub, json),
        Some(("pack", sub)) if matches_subcommand(sub, "list") => emit_pack_list(json),
        Some((command, sub)) => {'''

if old in text:
    text = text.replace(old, new, 1)
elif 'Some(("plan", sub)) => emit_plan(sub, json),' not in text:
    marker = 'Some(("version", sub)) => emit_version(sub, json),'
    if marker not in text:
        raise SystemExit("ERROR: could not find version match arm insertion point")
    text = text.replace(marker, marker + '\n        Some(("plan", sub)) => emit_plan(sub, json),', 1)

insert_before = '\n#[derive(Debug, Serialize)]\nstruct PlaceholderOutput'
if insert_before not in text:
    raise SystemExit("ERROR: could not find PlaceholderOutput insertion point")

plan_code = r'''
#[derive(Debug, Serialize)]
struct PlanCommandOutput {
    schema_version: u32,
    command: &'static str,
    status: &'static str,
    operation: String,
    arguments: Vec<String>,
    mutating: bool,
    plan_backed: bool,
    supports_dry_run: bool,
    plan: monad_plans::ChangePlan,
    warnings: Vec<String>,
    notes: Vec<String>,
}

fn emit_plan(matches: &ArgMatches, json: bool) -> Result<(), String> {
    let operation = matches
        .get_one::<String>("operation")
        .ok_or_else(|| "missing required plan operation".to_string())?
        .to_string();

    let arguments = matches
        .get_many::<String>("args")
        .map(|values| values.cloned().collect::<Vec<_>>())
        .unwrap_or_default();

    let format = matches
        .get_one::<String>("format")
        .map(String::as_str)
        .unwrap_or("text");

    let output = build_plan_output(operation, arguments);
    let rendered = render_plan_output(&output, if json { "json" } else { format })?;

    if let Some(out) = matches.get_one::<String>("out") {
        std::fs::write(out, rendered).map_err(|error| format!("failed to write plan to {out}: {error}"))?;
        println!("wrote plan: {out}");
    } else {
        println!("{rendered}");
    }

    Ok(())
}

fn build_plan_output(operation: String, arguments: Vec<String>) -> PlanCommandOutput {
    let plan_backed = monad_core::command_catalog::is_plan_backed(&operation);
    let supports_dry_run = monad_core::command_catalog::supports_dry_run(&operation);
    let mutating = monad_core::command_catalog::is_mutating_command(&operation);

    let mut plan = monad_plans::ChangePlan::dry_run(operation.clone());

    match operation.as_str() {
        "init" => {
            plan.push_step(monad_plans::PlanStep::new(
                monad_plans::PlanStepKind::Validate,
                "validate target directory, workspace name, preset, package manager, and safety flags",
            ));
            plan.push_step(monad_plans::PlanStep::new(
                monad_plans::PlanStepKind::CreateDirectory,
                "create governed Monad repository foundation directories",
            ));
            plan.push_step(monad_plans::PlanStep::new(
                monad_plans::PlanStepKind::CreateFile,
                "write monad.toml, workspace.toml compatibility mirror, monad.lock, and .monad state",
            ));
            plan.push_step(monad_plans::PlanStep::new(
                monad_plans::PlanStepKind::RunCommand,
                "run formatting, validation, and smoke checks",
            ));
        }
        "add" => {
            plan.push_step(monad_plans::PlanStep::new(
                monad_plans::PlanStepKind::Validate,
                "validate requested unit kind, name, destination, language, framework, and template",
            ));
            plan.push_step(monad_plans::PlanStep::new(
                monad_plans::PlanStepKind::Other("resolve_template".to_string()),
                "resolve pack/template defaults and calculate generated file set",
            ));
            plan.push_step(monad_plans::PlanStep::new(
                monad_plans::PlanStepKind::CreateDirectory,
                "create the target workspace unit directory",
            ));
            plan.push_step(monad_plans::PlanStep::new(
                monad_plans::PlanStepKind::CreateFile,
                "write source files, package manifests, tests, README, and ownership metadata",
            ));
            plan.push_step(monad_plans::PlanStep::new(
                monad_plans::PlanStepKind::UpdateFile,
                "update monad.toml and regenerate workspace.toml compatibility mirror",
            ));
        }
        "remove" => {
            plan.push_step(monad_plans::PlanStep::new(
                monad_plans::PlanStepKind::Validate,
                "validate target exists and compute reverse dependencies",
            ));
            plan.push_step(monad_plans::PlanStep::new(
                monad_plans::PlanStepKind::UpdateFile,
                "remove workspace metadata and references from manifests",
            ));
            plan.push_step(monad_plans::PlanStep::new(
                monad_plans::PlanStepKind::DeleteFile,
                "delete target files unless --keep-files is requested",
            ));
        }
        "rename" | "move" => {
            plan.push_step(monad_plans::PlanStep::new(
                monad_plans::PlanStepKind::Validate,
                "validate target, destination/name, ownership, and import/reference update strategy",
            ));
            plan.push_step(monad_plans::PlanStep::new(
                monad_plans::PlanStepKind::UpdateFile,
                "rewrite manifests, references, ownership metadata, and graph metadata",
            ));
            plan.push_step(monad_plans::PlanStep::new(
                monad_plans::PlanStepKind::RunCommand,
                "run validation checks after the structural change",
            ));
        }
        "generate" | "sync" | "clean" | "migrate" | "upgrade" => {
            plan.push_step(monad_plans::PlanStep::new(
                monad_plans::PlanStepKind::Validate,
                "validate operation inputs and current workspace state",
            ));
            plan.push_step(monad_plans::PlanStep::new(
                monad_plans::PlanStepKind::Other("compute_change_set".to_string()),
                "compute the deterministic change set before writing",
            ));
            plan.push_step(monad_plans::PlanStep::new(
                monad_plans::PlanStepKind::UpdateFile,
                "apply safe manifest, generated artifact, or metadata updates",
            ));
        }
        _ => {
            plan.push_step(monad_plans::PlanStep::new(
                monad_plans::PlanStepKind::Validate,
                "validate operation inputs and current workspace state",
            ));
            plan.push_step(monad_plans::PlanStep::new(
                monad_plans::PlanStepKind::Other("compute_change_set".to_string()),
                "compute a deterministic change set",
            ));
            plan.push_step(monad_plans::PlanStep::new(
                monad_plans::PlanStepKind::Other("present_plan".to_string()),
                "present the plan for human review before any apply step",
            ));
        }
    }

    let mut warnings = Vec::new();
    if !monad_core::command_catalog::is_approved_command(&operation) {
        warnings.push(format!(
            "`{operation}` is not in the approved WP-0001 command catalog; emitting a generic exploratory plan."
        ));
    }

    let notes = vec![
        "This command does not mutate the repository unless --out writes the rendered plan document.".to_string(),
        "Future work packets will connect this plan model to monad apply, lockfile updates, and real repository edits.".to_string(),
    ];

    PlanCommandOutput {
        schema_version: monad_core::PLAN_SCHEMA_VERSION,
        command: "plan",
        status: "implemented",
        operation,
        arguments,
        mutating,
        plan_backed,
        supports_dry_run,
        plan,
        warnings,
        notes,
    }
}

fn render_plan_output(output: &PlanCommandOutput, format: &str) -> Result<String, String> {
    match format {
        "json" => serde_json::to_string_pretty(output).map_err(|error| error.to_string()),
        "markdown" => Ok(render_plan_markdown(output)),
        "text" => Ok(render_plan_text(output)),
        other => Err(format!("unsupported plan output format `{other}`")),
    }
}

fn render_plan_text(output: &PlanCommandOutput) -> String {
    let mut rendered = String::new();

    rendered.push_str("Monad Change Plan\n");
    rendered.push_str("=================\n\n");
    rendered.push_str(&format!("status: {}\n", output.status));
    rendered.push_str(&format!("operation: {}\n", output.operation));
    rendered.push_str(&format!("arguments: {}\n", output.arguments.join(" ")));
    rendered.push_str(&format!("mutating: {}\n", output.mutating));
    rendered.push_str(&format!("plan-backed: {}\n", output.plan_backed));
    rendered.push_str(&format!("supports --dry-run: {}\n", output.supports_dry_run));
    rendered.push_str("\nsteps:\n");

    for (index, step) in output.plan.steps.iter().enumerate() {
        rendered.push_str(&format!("  {}. {:?}: {}\n", index + 1, step.kind, step.summary));
    }

    if !output.warnings.is_empty() {
        rendered.push_str("\nwarnings:\n");
        for warning in &output.warnings {
            rendered.push_str(&format!("  - {warning}\n"));
        }
    }

    if !output.notes.is_empty() {
        rendered.push_str("\nnotes:\n");
        for note in &output.notes {
            rendered.push_str(&format!("  - {note}\n"));
        }
    }

    rendered
}

fn render_plan_markdown(output: &PlanCommandOutput) -> String {
    let mut rendered = String::new();

    rendered.push_str("# Monad Change Plan\n\n");
    rendered.push_str(&format!("- **Status:** `{}`\n", output.status));
    rendered.push_str(&format!("- **Operation:** `{}`\n", output.operation));
    rendered.push_str(&format!("- **Arguments:** `{}`\n", output.arguments.join(" ")));
    rendered.push_str(&format!("- **Mutating:** `{}`\n", output.mutating));
    rendered.push_str(&format!("- **Plan-backed:** `{}`\n", output.plan_backed));
    rendered.push_str(&format!(
        "- **Supports `--dry-run`:** `{}`\n\n",
        output.supports_dry_run
    ));

    rendered.push_str("## Steps\n\n");
    for (index, step) in output.plan.steps.iter().enumerate() {
        rendered.push_str(&format!(
            "{}. **{:?}** — {}\n",
            index + 1,
            step.kind,
            step.summary
        ));
    }

    if !output.warnings.is_empty() {
        rendered.push_str("\n## Warnings\n\n");
        for warning in &output.warnings {
            rendered.push_str(&format!("- {warning}\n"));
        }
    }

    if !output.notes.is_empty() {
        rendered.push_str("\n## Notes\n\n");
        for note in &output.notes {
            rendered.push_str(&format!("- {note}\n"));
        }
    }

    rendered
}

'''

text = text.replace(insert_before, "\n" + plan_code + insert_before, 1)
path.write_text(text)
PY

mkdir -p crates/monad-cli/tests

cat > crates/monad-cli/tests/plan_command.rs <<'RS'
use std::fs;
use std::process::Command;

#[test]
fn plan_add_outputs_text_plan() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["plan", "add", "app", "web"])
        .output()
        .expect("monad plan add should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("Monad Change Plan"));
    assert!(stdout.contains("status: implemented"));
    assert!(stdout.contains("operation: add"));
    assert!(stdout.contains("plan-backed: true"));
    assert!(stdout.contains("create the target workspace unit directory"));
}

#[test]
fn plan_add_outputs_json_plan() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["plan", "add", "app", "web", "--format", "json"])
        .output()
        .expect("monad plan add --format json should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains(r#""command": "plan""#));
    assert!(stdout.contains(r#""status": "implemented""#));
    assert!(stdout.contains(r#""operation": "add""#));
    assert!(stdout.contains(r#""plan_backed": true"#));
    assert!(stdout.contains(r#""supports_dry_run": true"#));
}

#[test]
fn plan_add_outputs_markdown_plan() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["plan", "add", "app", "web", "--format", "markdown"])
        .output()
        .expect("monad plan add --format markdown should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("# Monad Change Plan"));
    assert!(stdout.contains("- **Operation:** `add`"));
    assert!(stdout.contains("## Steps"));
}

#[test]
fn plan_can_write_to_explicit_out_file() {
    let mut out = std::env::temp_dir();
    out.push(format!(
        "monad-plan-test-{}-{}.md",
        std::process::id(),
        "add-web"
    ));

    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args([
            "plan",
            "add",
            "app",
            "web",
            "--format",
            "markdown",
            "--out",
            out.to_str().expect("temp path should be valid utf-8"),
        ])
        .output()
        .expect("monad plan --out should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);
    assert!(stdout.contains("wrote plan:"));

    let contents = fs::read_to_string(&out).expect("plan output file should exist");
    assert!(contents.contains("# Monad Change Plan"));
    assert!(contents.contains("- **Operation:** `add`"));

    let _ = fs::remove_file(out);
}
RS

cargo fmt --all

echo
echo "Applied layer-0002-hotfix-0014-implement-monad-plan-output"
echo
echo "Implemented:"
echo "  - serializable monad-plans primitives"
echo "  - monad plan text/json/markdown output"
echo "  - monad plan --out"
echo "  - plan command integration tests"
