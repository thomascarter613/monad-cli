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
        "monad-check-test-{}-{nanos}-{name}",
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

fn create_baseline_repo(name: &str) -> std::path::PathBuf {
    let root = temp_repo_path(name);

    fs::create_dir_all(root.join(".monad")).expect("should create state dir");

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
    "crates/monad-plans",
    "crates/monad-packs",
    "crates/monad-policy",
    "crates/monad-context",
    "crates/monad-graph",
]
"#,
    );

    for crate_name in [
        "monad-cli",
        "monad-core",
        "monad-plans",
        "monad-packs",
        "monad-policy",
        "monad-context",
        "monad-graph",
    ] {
        write_file(
            &root.join(format!("crates/{crate_name}/Cargo.toml")),
            &format!(
                r#"[package]
name = "{crate_name}"
version = "0.1.0"
edition = "2021"
"#
            ),
        );
    }

    root
}

#[test]
fn check_passes_for_baseline_repo() {
    let root = create_baseline_repo("pass");

    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["check", root.to_str().expect("temp path should be utf-8")])
        .output()
        .expect("monad check should run");

    let _ = fs::remove_dir_all(&root);

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("Monad Repository Check"));
    assert!(stdout.contains("status: passed"));
    assert!(stdout.contains("errors: 0"));
    assert!(stdout.contains("MONAD_CHECK_CANONICAL_MANIFEST"));
    assert!(stdout.contains("MONAD_CHECK_WP_0001_CRATE_MANIFEST"));
}

#[test]
fn check_json_reports_passed_baseline_repo() {
    let root = create_baseline_repo("json");

    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args([
            "check",
            root.to_str().expect("temp path should be utf-8"),
            "--format",
            "json",
        ])
        .output()
        .expect("monad check --format json should run");

    let _ = fs::remove_dir_all(&root);

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains(r#""command": "check""#));
    assert!(stdout.contains(r#""status": "passed""#));
    assert!(stdout.contains(r#""error_count": 0"#));
    assert!(stdout.contains(r#""did_mutate": false"#));
}

#[test]
fn check_fails_for_missing_required_manifest() {
    let root = create_baseline_repo("missing-manifest");
    fs::remove_file(root.join("monad.toml")).expect("should remove monad.toml");

    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["check", root.to_str().expect("temp path should be utf-8")])
        .output()
        .expect("monad check should run");

    let _ = fs::remove_dir_all(&root);

    assert!(!output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);
    let stderr = String::from_utf8_lossy(&output.stderr);

    assert!(stdout.contains("status: failed"));
    assert!(stdout.contains("required file `monad.toml` is missing"));
    assert!(stderr.contains("check failed"));
}

#[test]
fn check_fix_is_accepted_but_non_mutating() {
    let root = create_baseline_repo("fix");

    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args([
            "check",
            root.to_str().expect("temp path should be utf-8"),
            "--fix",
        ])
        .output()
        .expect("monad check --fix should run");

    let _ = fs::remove_dir_all(&root);

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("fix requested: true"));
    assert!(stdout.contains("did mutate: false"));
    assert!(stdout.contains("MONAD_CHECK_FIX_NOT_IMPLEMENTED"));
}
