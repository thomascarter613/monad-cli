#!/usr/bin/env python3
from pathlib import Path
import sys


REPO_ROOT = Path("/data/Workspace/monad-factory-workspace/monad-cli")
TARGET = REPO_ROOT / "crates/monad-cli/tests/context_command.rs"

BAD = 'assert!(stdout.contains("Monad Context Verify");'
GOOD = 'assert!(stdout.contains("Monad Context Verify"));'


def main() -> int:
    if not REPO_ROOT.exists():
        print(f"ERROR: repo root does not exist: {REPO_ROOT}", file=sys.stderr)
        return 1

    if not TARGET.exists():
        print(f"ERROR: target file does not exist: {TARGET}", file=sys.stderr)
        return 1

    text = TARGET.read_text(encoding="utf-8")

    if GOOD in text and BAD not in text:
        print("No change needed: context verify assertion is already repaired.")
        return 0

    if BAD not in text:
        print(
            "ERROR: expected broken assertion was not found. "
            "Refusing to make an uncertain edit.",
            file=sys.stderr,
        )
        return 1

    updated = text.replace(BAD, GOOD, 1)
    TARGET.write_text(updated, encoding="utf-8")

    print(f"Repaired context verify assertion in: {TARGET}")
    print("Next: run cargo fmt --all, then the standard verification commands.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
