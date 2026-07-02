use std::process::Command;

fn monad(args: &[&str]) -> std::process::Output {
    Command::new(env!("CARGO_BIN_EXE_monad"))
        .args(args)
        .output()
        .expect("failed to run monad binary")
}

fn assert_success(args: &[&str]) {
    let output = monad(args);
    assert!(
        output.status.success(),
        "expected `monad {}` to succeed\nstdout:\n{}\nstderr:\n{}",
        args.join(" "),
        String::from_utf8_lossy(&output.stdout),
        String::from_utf8_lossy(&output.stderr)
    );
}

#[test]
fn root_help_works() {
    assert_success(&["--help"]);
}

#[test]
fn version_works() {
    assert_success(&["version", "--verbose"]);
    assert_success(&["version", "--verbose", "--json"]);
}

#[test]
fn top_level_command_help_works() {
    let commands = [
        "init",
        "add",
        "remove",
        "rename",
        "move",
        "list",
        "inspect",
        "check",
        "doctor",
        "plan",
        "apply",
        "diff",
        "generate",
        "sync",
        "run",
        "build",
        "test",
        "lint",
        "format",
        "graph",
        "clean",
        "migrate",
        "upgrade",
        "context",
        "config",
        "version",
        "policy",
        "template",
        "pack",
        "plugin",
        "release",
        "docs",
        "adr",
        "workpacket",
    ];

    for command in commands {
        assert_success(&[command, "--help"]);
    }
}

#[test]
fn namespaced_command_help_works() {
    let commands: &[&[&str]] = &[
        &["policy", "check", "--help"],
        &["policy", "waive", "--help"],
        &["policy", "explain", "--help"],
        &["template", "list", "--help"],
        &["template", "add", "--help"],
        &["template", "inspect", "--help"],
        &["pack", "list", "--help"],
        &["pack", "install", "--help"],
        &["pack", "update", "--help"],
        &["plugin", "list", "--help"],
        &["plugin", "install", "--help"],
        &["plugin", "remove", "--help"],
        &["release", "plan", "--help"],
        &["release", "apply", "--help"],
        &["release", "publish", "--help"],
        &["context", "pack", "--help"],
        &["context", "verify", "--help"],
        &["context", "handoff", "--help"],
        &["graph", "projects", "--help"],
        &["graph", "tasks", "--help"],
        &["graph", "deps", "--help"],
        &["docs", "generate", "--help"],
        &["docs", "check", "--help"],
        &["adr", "new", "--help"],
        &["adr", "list", "--help"],
        &["adr", "supersede", "--help"],
        &["workpacket", "new", "--help"],
        &["workpacket", "list", "--help"],
        &["workpacket", "plan", "--help"],
        &["config", "get", "--help"],
        &["config", "set", "--help"],
        &["config", "unset", "--help"],
        &["config", "list", "--help"],
        &["config", "validate", "--help"],
    ];

    for args in commands {
        assert_success(args);
    }
}
