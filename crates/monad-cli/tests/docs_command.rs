use std::path::PathBuf;
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
