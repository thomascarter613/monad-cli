#!/usr/bin/env bash
set -euo pipefail

# layer-0002-hotfix-0003-main-rs-no-args-default-scope.sh
#
# Fixes the next WP-0001 smoke failure:
#
#   assertion failed: stdout.contains("@monad")
#
# The smoke test expects running the binary with no args to print both:
#   - "monad"
#   - "@monad"
#
# This patch updates the no-args help guard in crates/monad-cli/src/main.rs.

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

# If the previous hotfix inserted a help banner, replace it with one that includes @monad.
old_variants = [
    'println!("monad\\n\\nUsage: monad <COMMAND>\\n\\nRun `monad --help` for full command help.");',
    'println!("monad\n\nUsage: monad <COMMAND>\n\nRun `monad --help` for full command help.");',
]
new = 'println!("monad\\n\\nDefault scope: @monad\\n\\nUsage: monad <COMMAND>\\n\\nRun `monad --help` for full command help.");'

replaced = False
for old in old_variants:
    if old in text:
        text = text.replace(old, new)
        replaced = True

if not replaced:
    # If no guard exists yet, insert one at the top of main.
    marker = "__MONAD_NO_ARGS_HELP_GUARD__"
    if marker not in text:
        match = re.search(r"fn\s+main\s*\([^)]*\)\s*(?:->\s*[^{]+)?\{", text)
        if not match:
            raise SystemExit("could not find fn main(...) { in crates/monad-cli/src/main.rs")
        insert_at = match.end()
        guard = """
    // __MONAD_NO_ARGS_HELP_GUARD__
    if std::env::args_os().len() == 1 {
        println!("monad\\n\\nDefault scope: @monad\\n\\nUsage: monad <COMMAND>\\n\\nRun `monad --help` for full command help.");
        std::process::exit(0);
    }

"""
        text = text[:insert_at] + guard + text[insert_at:]
    elif "@monad" not in text:
        raise SystemExit("found no-args guard but could not safely patch it; inspect crates/monad-cli/src/main.rs")

path.write_text(text, encoding="utf-8")
print("[hotfix-0003] ensured no-args output includes @monad")
PY

if command -v cargo >/dev/null 2>&1; then
  cargo fmt --all
  cargo test -p monad-cli --test smoke
else
  echo "[hotfix-0003] cargo not found; skipped validation"
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
  git commit -m "fix(cli): include default scope in root help"

NEXT
