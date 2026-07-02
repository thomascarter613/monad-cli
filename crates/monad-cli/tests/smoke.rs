use std::process::Command;

#[test]
fn binary_runs() {
    let output = Command::new(env!("CARGO_BIN_EXE_monad"))
        .output()
        .expect("monad binary should run");

    assert!(
        output.status.success(),
        "expected monad binary to exit successfully"
    );

    let stdout = String::from_utf8_lossy(&output.stdout);
    assert!(stdout.contains("monad"));
    assert!(stdout.contains("@monad"));
}
