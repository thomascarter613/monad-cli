use std::process::Command;

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
