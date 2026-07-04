use std::process::Command;

#[test]
fn list_all_outputs_text_inventory() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .arg("list")
        .output()
        .expect("monad list should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("Monad List"));
    assert!(stdout.contains("status: implemented"));
    assert!(stdout.contains("kind: all"));
    assert!(stdout.contains("did mutate: false"));
    assert!(stdout.contains("[manifest] monad.toml"));
    assert!(stdout.contains("[crate] monad-cli"));
    assert!(stdout.contains("[command] add"));
    assert!(stdout.contains("[pack] official.typescript"));
}

#[test]
fn list_crates_outputs_only_crate_inventory() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["list", "crates"])
        .output()
        .expect("monad list crates should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("kind: crates"));
    assert!(stdout.contains("[crate] monad-cli"));
    assert!(stdout.contains("[crate] monad-core"));
    assert!(!stdout.contains("[pack] official.typescript"));
}

#[test]
fn list_commands_outputs_command_catalog() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["list", "commands"])
        .output()
        .expect("monad list commands should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("kind: commands"));
    assert!(stdout.contains("[command] init"));
    assert!(stdout.contains("[command] add"));
    assert!(stdout.contains("[command] policy check"));
    assert!(stdout.contains("[command] workpacket plan"));
}

#[test]
fn list_packs_outputs_pack_catalog_as_json() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["list", "packs", "--format", "json"])
        .output()
        .expect("monad list packs --format json should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains(r#""command": "list""#));
    assert!(stdout.contains(r#""requested_kind": "packs""#));
    assert!(stdout.contains(r#""name": "official.typescript""#));
    assert!(stdout.contains(r#""name": "official.docs""#));
    assert!(stdout.contains(r#""did_mutate": false"#));
}

#[test]
fn list_markdown_outputs_table() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(["list", "manifests", "--format", "markdown"])
        .output()
        .expect("monad list manifests --format markdown should run");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    assert!(stdout.contains("# Monad List"));
    assert!(stdout.contains("| Kind | Name | Status | Path | Description |"));
    assert!(stdout.contains("`monad.toml`"));
}
