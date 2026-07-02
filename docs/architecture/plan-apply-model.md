# Plan/Diff/Apply Model

Plan files are JSON and contain ordered operations.

## Step kinds

```txt
create_dir
remove_dir
create_file
update_file
delete_file
move_file
copy_file
update_json
update_toml
append_managed_block
replace_managed_block
run_command_hint
```

## Safety rules

- Never write outside the workspace root.
- Never delete outside the workspace root.
- Never destructively follow symlinks by default.
- Never overwrite user-modified files without conflict reporting.
- Mutating commands must support `--dry-run`.
