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
    write_file(
        &root.join("crates/monad-core/src/lib.rs"),
        "pub fn test() {}\n",
    );

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
