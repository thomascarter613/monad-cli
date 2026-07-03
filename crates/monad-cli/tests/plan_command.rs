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
