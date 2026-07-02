#!/usr/bin/env bash
set -euo pipefail

# layer-0002-hotfix-0002-main-rs-no-args-help.sh
#
# Fixes the local repo shape where crates/monad-cli/src/main.rs exists but
# crates/monad-cli/src/lib.rs does not.
#
# It patches main.rs so running `monad` with no arguments prints a small root
# help banner containing "monad" to stdout and exits successfully.
#
# This satisfies the existing smoke test:
#
#   crates/monad-cli/tests/smoke.rs::binary_runs
#
# while avoiding assumptions about whether your CLI is currently implemented as
# a bin-only crate or a lib+bin crate.

REPO_DIR="${1:-.}"
cd "$REPO_DIR"

MAIN_RS="crates/monad-cli/src/main.rs"

if [[ ! -f "$MAIN_RS" ]]; then
  echo "ERROR: $MAIN_RS not found. Run from repo root." >&2
  exit 1
fi

python - <<'PY'
from pathlib import Path
import re

path = Path("crates/monad-cli/src/main.rs")
text = path.read_text(encoding="utf-8")

marker = "__MONAD_NO_ARGS_HELP_GUARD__"
if marker in text:
    print("[hotfix-0002] no-args help guard already present")
    raise SystemExit(0)

match = re.search(r"fn\s+main\s*\([^)]*\)\s*(?:->\s*[^{]+)?\{", text)
if not match:
    raise SystemExit("could not find fn main(...) { in crates/monad-cli/src/main.rs")

insert_at = match.end()
guard = """
    // __MONAD_NO_ARGS_HELP_GUARD__
    if std::env::args_os().len() == 1 {
        println!("monad\\n\\nUsage: monad <COMMAND>\\n\\nRun `monad --help` for full command help.");
        std::process::exit(0);
    }

"""

text = text[:insert_at] + guard + text[insert_at:]
path.write_text(text, encoding="utf-8")
print("[hotfix-0002] patched crates/monad-cli/src/main.rs")
PY

if command -v cargo >/dev/null 2>&1; then
  cargo fmt --all
  cargo test -p monad-cli --test smoke
else
  echo "[hotfix-0002] cargo not found; skipped validation"
fi

cat <<'NEXT'

Hotfix complete.

Recommended validation:

  cargo fmt --all --check
  cargo check --workspace
  cargo test --workspace
  cargo run -p monad-cli --

Then commit:

  git add .
  git commit -m "fix(cli): print root help when invoked without arguments"

NEXT
