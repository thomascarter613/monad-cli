use std::fs;
use std::process::Command;

fn temp_plan_path(name: &str, extension: &str) -> std::path::PathBuf {
    let mut path = std::env::temp_dir();
    path.push(format!(
        "monad-apply-test-{}-{name}.{extension}",
        std::process::id()
    ));
    path
}

#[test]
fn apply_reads_existing_plan_without_mutating() {
    let plan = temp_plan_path("plan", "md");

    fs::write(
        &plan,
        "# Monad Change Plan\n\n- **Operation:** `add`\n\n## Steps\n\n1. validate\n",
    )
    .expect("should write temp plan");

    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args([
            "apply",
            plan.to_str().expect("temp path should be utf-8"),
            "--dry-run",
        ])
        .output()
        .expect("monad apply should run");

    let _ = fs::remove_file(&plan);

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("Monad Apply Preview"));
    assert!(stdout.contains("status: not_implemented"));
    assert!(stdout.contains("implemented: false"));
    assert!(stdout.contains("dry-run: true"));
    assert!(stdout.contains("did mutate: false"));
    assert!(stdout.contains("execution is intentionally disabled"));
}

#[test]
fn apply_can_render_json() {
    let plan = temp_plan_path("plan", "json");

    fs::write(
        &plan,
        r#"{
  "command": "plan",
  "operation": "add",
  "status": "implemented"
}
"#,
    )
    .expect("should write temp plan");

    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args([
            "apply",
            plan.to_str().expect("temp path should be utf-8"),
            "--dry-run",
            "--format",
            "json",
        ])
        .output()
        .expect("monad apply --format json should run");

    let _ = fs::remove_file(&plan);

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains(r#""command": "apply""#));
    assert!(stdout.contains(r#""status": "not_implemented""#));
    assert!(stdout.contains(r#""implemented": false"#));
    assert!(stdout.contains(r#""did_mutate": false"#));
    assert!(stdout.contains(r#""inferred_plan_format": "json""#));
}

#[test]
fn apply_fails_for_missing_plan_file() {
    let plan = temp_plan_path("missing", "json");

    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["apply", plan.to_str().expect("temp path should be utf-8")])
        .output()
        .expect("monad apply missing file should run and fail cleanly");

    assert!(!output.status.success());

    let stderr = String::from_utf8_lossy(&output.stderr);
    assert!(stderr.contains("failed to read plan file"));
}
