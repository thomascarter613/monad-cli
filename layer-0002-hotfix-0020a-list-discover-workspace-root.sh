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

cp "$CLI_RS" "$CLI_RS.bak.layer-0002-hotfix-0020a"

python3 - <<'PY'
from pathlib import Path

path = Path("crates/monad-cli/src/lib.rs")
text = path.read_text()

old = '''fn build_list_output(requested_kind: &str, scope: Option<String>) -> ListCommandOutput {
    let mut items = Vec::new();

    if list_includes(requested_kind, "manifests") {
        items.extend(list_manifest_items(std::path::Path::new(".")));
    }

    if list_includes(requested_kind, "crates") {
        items.extend(list_crate_items(std::path::Path::new(".")));
    }

    if list_includes(requested_kind, "commands") {
        items.extend(list_command_items());
    }

    if list_includes(requested_kind, "packs") {
        items.extend(list_pack_items());
    }

    if list_includes(requested_kind, "surfaces") {
        items.extend(list_surface_items(std::path::Path::new(".")));
    }'''

new = '''fn build_list_output(requested_kind: &str, scope: Option<String>) -> ListCommandOutput {
    let mut items = Vec::new();
    let workspace_root = discover_monad_workspace_root();

    if list_includes(requested_kind, "manifests") {
        items.extend(list_manifest_items(&workspace_root));
    }

    if list_includes(requested_kind, "crates") {
        items.extend(list_crate_items(&workspace_root));
    }

    if list_includes(requested_kind, "commands") {
        items.extend(list_command_items());
    }

    if list_includes(requested_kind, "packs") {
        items.extend(list_pack_items());
    }

    if list_includes(requested_kind, "surfaces") {
        items.extend(list_surface_items(&workspace_root));
    }'''

if old not in text:
    raise SystemExit("ERROR: expected build_list_output root-scanning block not found")

text = text.replace(old, new, 1)

insert_before = '''fn list_includes(requested_kind: &str, section: &str) -> bool {'''
if insert_before not in text:
    raise SystemExit("ERROR: could not find list_includes insertion point")

helper = r'''fn discover_monad_workspace_root() -> std::path::PathBuf {
    let mut current = std::env::current_dir().unwrap_or_else(|_| std::path::PathBuf::from("."));

    loop {
        if current.join("monad.toml").is_file() {
            return current;
        }

        if !current.pop() {
            return std::path::PathBuf::from(".");
        }
    }
}

'''

if "fn discover_monad_workspace_root()" not in text:
    text = text.replace(insert_before, helper + insert_before, 1)

path.write_text(text)
PY

cargo fmt --all

echo
echo "Applied layer-0002-hotfix-0020a-list-discover-workspace-root"
echo
echo "Fixed:"
echo "  - monad list now walks upward to find monad.toml"
echo "  - list tests work from crate-root and workspace-root current directories"
