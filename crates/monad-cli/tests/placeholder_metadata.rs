use std::process::Command;

#[test]
fn placeholder_text_output_reports_plan_metadata_for_add() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["add", "app", "web", "--dry-run"])
        .output()
        .expect("monad add placeholder should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("command: add"));
    assert!(stdout.contains("status: placeholder"));
    assert!(stdout.contains("implemented: false"));
    assert!(stdout.contains("mutating: true"));
    assert!(stdout.contains("plan-backed: true"));
    assert!(stdout.contains("supports --dry-run: true"));
}

#[test]
fn placeholder_text_output_reports_read_only_metadata_for_inspect() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .arg("inspect")
        .output()
        .expect("monad inspect placeholder should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("command: inspect"));
    assert!(stdout.contains("status: placeholder"));
    assert!(stdout.contains("implemented: false"));
    assert!(stdout.contains("mutating: false"));
    assert!(stdout.contains("plan-backed: false"));
    assert!(stdout.contains("supports --dry-run: false"));
}

#[test]
fn placeholder_json_output_reports_command_metadata() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["--json", "add", "app", "web", "--dry-run"])
        .output()
        .expect("monad add --json placeholder should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains(r#""command": "add""#));
    assert!(stdout.contains(r#""status": "placeholder""#));
    assert!(stdout.contains(r#""implemented": false"#));
    assert!(stdout.contains(r#""mutating": true"#));
    assert!(stdout.contains(r#""plan_backed": true"#));
    assert!(stdout.contains(r#""supports_dry_run": true"#));
}
