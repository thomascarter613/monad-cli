use std::process::Command;

#[test]
fn doctor_outputs_text_diagnostics_without_mutating() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .arg("doctor")
        .output()
        .expect("monad doctor should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("Monad Doctor"));
    assert!(stdout.contains("status:"));
    assert!(stdout.contains("did mutate: false"));
    assert!(stdout.contains("rustc"));
    assert!(stdout.contains("cargo"));
    assert!(stdout.contains("bun"));
    assert!(stdout.contains("Missing optional tools"));
}

#[test]
fn doctor_outputs_json_diagnostics() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["doctor", "--format", "json"])
        .output()
        .expect("monad doctor --format json should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains(r#""command": "doctor""#));
    assert!(stdout.contains(r#""did_mutate": false"#));
    assert!(stdout.contains(r#""required_missing_count""#));
    assert!(stdout.contains(r#""optional_missing_count""#));
    assert!(stdout.contains(r#""diagnostics""#));
}

#[test]
fn doctor_include_filters_diagnostic_area() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["doctor", "--include", "repository"])
        .output()
        .expect("monad doctor --include repository should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("include: repository"));
    assert!(stdout.contains("monad.toml"));
    assert!(stdout.contains("Cargo.toml"));
}

#[test]
fn doctor_fix_is_accepted_but_non_mutating() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["doctor", "--fix"])
        .output()
        .expect("monad doctor --fix should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("fix requested: true"));
    assert!(stdout.contains("did mutate: false"));
    assert!(stdout.contains("does not mutate the environment or install tools"));
}
