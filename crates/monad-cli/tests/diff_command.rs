use std::fs;
use std::process::Command;
use std::time::{SystemTime, UNIX_EPOCH};

fn temp_dir(name: &str) -> std::path::PathBuf {
    let nanos = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .expect("clock should be after unix epoch")
        .as_nanos();

    let mut path = std::env::temp_dir();
    path.push(format!("monad-diff-test-{}-{nanos}-{name}", std::process::id()));
    fs::create_dir_all(&path).expect("should create temp dir");
    path
}

#[test]
fn diff_defaults_to_monad_and_workspace_toml() {
    let root = temp_dir("default");

    fs::write(root.join("monad.toml"), "[workspace]\nname = \"demo\"\n")
        .expect("should write monad.toml");
    fs::write(
        root.join("workspace.toml"),
        "# compatibility mirror of monad.toml\n[workspace]\nname = \"demo\"\n",
    )
    .expect("should write workspace.toml");

    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .current_dir(&root)
        .arg("diff")
        .output()
        .expect("monad diff should run");

    let _ = fs::remove_dir_all(&root);

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("Monad Diff"));
    assert!(stdout.contains("left: monad.toml"));
    assert!(stdout.contains("right: workspace.toml"));
    assert!(stdout.contains("did mutate: false"));
    assert!(stdout.contains("compatibility mirror detected: true"));
}

#[test]
fn diff_reports_equal_files() {
    let root = temp_dir("equal");
    let left = root.join("left.toml");
    let right = root.join("right.toml");

    fs::write(&left, "[workspace]\nname = \"demo\"\n").expect("should write left");
    fs::write(&right, "[workspace]\nname = \"demo\"\n").expect("should write right");

    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args([
            "diff",
            left.to_str().expect("left path should be utf-8"),
            right.to_str().expect("right path should be utf-8"),
        ])
        .output()
        .expect("monad diff should run");

    let _ = fs::remove_dir_all(&root);

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("status: equal"));
    assert!(stdout.contains("equal: true"));
    assert!(stdout.contains("changed lines: 0"));
}

#[test]
fn diff_reports_different_files_as_json() {
    let root = temp_dir("json");
    let left = root.join("left.toml");
    let right = root.join("right.toml");

    fs::write(&left, "[workspace]\nname = \"left\"\n").expect("should write left");
    fs::write(&right, "[workspace]\nname = \"right\"\n").expect("should write right");

    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args([
            "diff",
            left.to_str().expect("left path should be utf-8"),
            right.to_str().expect("right path should be utf-8"),
            "--format",
            "json",
        ])
        .output()
        .expect("monad diff --format json should run");

    let _ = fs::remove_dir_all(&root);

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains(r#""command": "diff""#));
    assert!(stdout.contains(r#""status": "different""#));
    assert!(stdout.contains(r#""equal": false"#));
    assert!(stdout.contains(r#""did_mutate": false"#));
    assert!(stdout.contains(r#""changed_line_count": 1"#));
}

#[test]
fn diff_reports_markdown() {
    let root = temp_dir("markdown");
    let left = root.join("left.toml");
    let right = root.join("right.toml");

    fs::write(&left, "a\n").expect("should write left");
    fs::write(&right, "b\n").expect("should write right");

    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args([
            "diff",
            left.to_str().expect("left path should be utf-8"),
            right.to_str().expect("right path should be utf-8"),
            "--format",
            "markdown",
        ])
        .output()
        .expect("monad diff --format markdown should run");

    let _ = fs::remove_dir_all(&root);

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("# Monad Diff"));
    assert!(stdout.contains("## Changes"));
    assert!(stdout.contains("| Line | Kind | Left | Right |"));
}

#[test]
fn diff_strict_fails_when_files_differ() {
    let root = temp_dir("strict");
    let left = root.join("left.toml");
    let right = root.join("right.toml");

    fs::write(&left, "a\n").expect("should write left");
    fs::write(&right, "b\n").expect("should write right");

    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args([
            "diff",
            left.to_str().expect("left path should be utf-8"),
            right.to_str().expect("right path should be utf-8"),
            "--strict",
        ])
        .output()
        .expect("monad diff --strict should run and fail");

    let _ = fs::remove_dir_all(&root);

    assert!(!output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);
    let stderr = String::from_utf8_lossy(&output.stderr);

    assert!(stdout.contains("status: different"));
    assert!(stderr.contains("diff detected differences"));
}
