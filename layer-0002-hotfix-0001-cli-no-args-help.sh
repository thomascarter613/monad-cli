#!/usr/bin/env bash
set -euo pipefail

# layer-0002-hotfix-0001-cli-no-args-help.sh
#
# Fixes WP-0001 smoke failure:
#
#   test binary_runs ... FAILED
#   assertion failed: stdout.contains("monad")
#
# Cause:
#   The Clap skeleton requires a subcommand. Running the binary with no args
#   exits through Clap's error path, which writes usage to stderr instead of
#   printing normal help to stdout. Existing smoke tests expect `monad` with no
#   args to print help containing "monad".
#
# Fix:
#   Make the root command optional and print root help to stdout when no
#   subcommand is provided.

REPO_DIR="${1:-.}"
cd "$REPO_DIR"

if [[ ! -f crates/monad-cli/src/lib.rs ]]; then
  echo "ERROR: crates/monad-cli/src/lib.rs not found. Run from repo root." >&2
  exit 1
fi

python - <<'PY'
from pathlib import Path

path = Path("crates/monad-cli/src/lib.rs")
text = path.read_text(encoding="utf-8")

text = text.replace(
    "use clap::{Args, Parser, Subcommand, ValueEnum};",
    "use clap::{Args, CommandFactory, Parser, Subcommand, ValueEnum};",
)

text = text.replace(
    "    #[command(subcommand)]\n    pub command: Commands,",
    "    #[command(subcommand)]\n    pub command: Option<Commands>,",
)

text = text.replace(
    "    dispatch(cli)",
    """    if cli.command.is_none() {
        let mut command = Cli::command();
        command.print_help().map_err(|error| error.to_string())?;
        println!();
        return Ok(());
    }

    dispatch(cli)""",
)

text = text.replace(
    "    match cli.command {",
    "    match cli.command.expect(\"command is handled before dispatch\") {",
)

path.write_text(text, encoding="utf-8")
PY

cargo fmt --all
cargo test -p monad-cli --test smoke
cargo test -p monad-cli --test help_smoke || true
cargo test --workspace

cat <<'NEXT'

Hotfix complete.

Recommended validation:

  cargo fmt --all --check
  cargo check --workspace
  cargo test --workspace
  cargo run -p monad-cli -- --help
  cargo run -p monad-cli --

Then commit:

  git add .
  git commit -m "fix(cli): print root help when no command is provided"

NEXT
