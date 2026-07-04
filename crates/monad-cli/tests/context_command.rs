use std::path::PathBuf;
use std::process::Command;

fn workspace_root() -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .join("../..")
        .canonicalize()
        .expect("workspace root should resolve")
}

#[test]
fn context_pack_outputs_text_inventory() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .current_dir(workspace_root())
        .args(["context", "pack"])
        .output()
        .expect("monad context pack should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("Monad Context Pack"));
    assert!(stdout.contains("status: implemented"));
    assert!(stdout.contains("did mutate: false"));
    assert!(stdout.contains("monad.toml"));
    assert!(stdout.contains("crates/monad-cli/src/lib.rs"));
}

#[test]
fn context_pack_outputs_json_inventory() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .current_dir(workspace_root())
        .args([
            "context",
            "pack",
            "--include",
            "manifests",
            "--format",
            "json",
        ])
        .output()
        .expect("monad context pack --format json should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains(r#""command": "context""#));
    assert!(stdout.contains(r#""subcommand": "pack""#));
    assert!(stdout.contains(r#""include": "manifests""#));
    assert!(stdout.contains(r#""did_mutate": false"#));
    assert!(stdout.contains(r#""path": "monad.toml""#));
}

#[test]
fn context_verify_passes_for_workspace() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .current_dir(workspace_root())
        .args(["context", "verify"])
        .output()
        .expect("monad context verify should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("Monad Context Verify"));
    assert!(stdout.contains("status: passed"));
    assert!(stdout.contains("did mutate: false"));
    assert!(stdout.contains("MONAD_CONTEXT_CANONICAL_MANIFEST"));
}

#[test]
fn context_handoff_outputs_handoff_summary() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .current_dir(workspace_root())
        .args(["context", "handoff", "--workpacket", "WP-0001"])
        .output()
        .expect("monad context handoff should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("Monad Context Handoff"));
    assert!(stdout.contains("current workpacket: WP-0001"));
    assert!(stdout.contains("command surface total:"));
    assert!(stdout.contains("next actions:"));
}

#[test]
fn context_handoff_outputs_markdown() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .current_dir(workspace_root())
        .args(["context", "handoff", "--format", "markdown"])
        .output()
        .expect("monad context handoff --format markdown should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("# Monad Context Handoff"));
    assert!(stdout.contains("## Important Files"));
    assert!(stdout.contains("## Next Actions"));
}
