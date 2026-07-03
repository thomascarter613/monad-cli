#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"
cd "$ROOT"

if [ ! -f "monad.toml" ]; then
  echo "ERROR: monad.toml not found. Run from repo root." >&2
  exit 1
fi

CLI_RS="crates/monad-cli/src/lib.rs"

if [ ! -f "$CLI_RS" ]; then
  echo "ERROR: $CLI_RS not found." >&2
  exit 1
fi

cp "$CLI_RS" "$CLI_RS.bak.layer-0002-hotfix-0016"

python3 - <<'PY'
from pathlib import Path

path = Path("crates/monad-cli/src/lib.rs")
text = path.read_text()

old = '''        .arg(
            arg("args", "Operation arguments")
                .num_args(0..)
                .trailing_var_arg(true),
        )
        .arg(opt("out", "Output file"))
        .arg(fmt_arg())'''

new = '''        .arg(arg("args", "Operation arguments").num_args(0..))
        .arg(opt("out", "Output file"))
        .arg(fmt_arg())'''

if old not in text:
    raise SystemExit("ERROR: expected trailing_var_arg block was not found in plan_cmd()")

text = text.replace(old, new, 1)
path.write_text(text)
PY

cargo fmt --all

echo
echo "Applied layer-0002-hotfix-0016-fix-plan-option-parsing"
echo
echo "Fixed:"
echo "  - monad plan --format is parsed as an option"
echo "  - monad plan --out is parsed as an option"
echo "  - operation args no longer swallow trailing flags"
