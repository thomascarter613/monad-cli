# Plan/Diff/Apply Model

This document defines Monad's plan, diff, dry-run, and apply architecture.

The model implements ADR-0006: Plan-Backed Mutation.

## Purpose

Monad should be able to propose repository changes before applying them.

The mature flow is:

```bash
monad plan ...
monad diff plan.json
monad apply plan.json --dry-run
monad apply plan.json --yes
```

Plans make mutation reviewable, testable, auditable, policy-checkable, and safer for AI-assisted workflows.

## Related ADRs

- ADR-0005: `monad.toml` Is the Canonical Manifest
- ADR-0006: Plan-Backed Mutation
- ADR-0010: Policy-as-Code
- ADR-0013: Versioned Machine-Readable Output Schemas
- ADR-0014: Stable CLI Exit Code Taxonomy
- ADR-0016: Pack and Template Trust Model
- ADR-0017: Plugin Execution and Trust Boundary

## Plan Lifecycle

1. **Create** — build a candidate plan from command intent and repository state.
2. **Validate** — check schema, preconditions, protected paths, and policy gates.
3. **Review** — render human-readable summary and machine-readable output.
4. **Diff** — show file and manifest-level changes.
5. **Dry-run** — simulate apply without writing.
6. **Approve** — require explicit approval for apply.
7. **Apply** — execute only planned operations.
8. **Report** — record results, skipped operations, conflicts, and diagnostics.
9. **Verify** — re-run checks or graph/context generation as needed.

## Plan File Shape

Plan files should eventually be JSON with a versioned schema.

Candidate top-level fields:

```text
schema
schema_version
plan_id
created_at
monad_version
workspace_root
workspace_id
command
inputs
preconditions
operations
policy_findings
warnings
risk_level
related_adrs
related_work_packets
```

## Operation Kinds

Candidate operation kinds:

```text
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

Native tool execution should be represented carefully. A plan may recommend or model a native tool invocation, but automatic execution must be explicit and policy-aware.

## Safety Rules

Plan/apply must enforce these rules:

- never write outside the workspace root;
- never delete outside the workspace root;
- normalize paths before safety checks;
- reject unsafe path traversal;
- avoid destructive symlink following by default;
- report conflicts before writes;
- never silently overwrite user-modified files;
- protect canonical manifests and governance files according to scope;
- require dry-run support where practical;
- ensure apply performs only planned operations;
- detect stale plans before apply.

## Diff Model

Diff output should show:

- files to create;
- files to update;
- files to delete;
- files to move;
- manifest field changes;
- generated-file changes;
- protected paths touched;
- policy findings;
- operations that require user approval.

Diff output should support human-readable and machine-readable forms.

## Apply Reports

Apply reports should capture:

- plan ID;
- executed operations;
- skipped operations;
- failed operations;
- conflicts;
- resulting diagnostics;
- timestamps;
- affected paths;
- follow-up checks;
- rollback hints where practical.

Reports may become release or audit evidence when intentionally preserved.

## AI and Extension Boundaries

AI, packs, templates, and plugins may generate candidate plans, but they must not bypass plan validation, filesystem safety, policy gates, or human approval.

## Testing Expectations

Tests should cover:

- plan schema validation;
- create/update/delete/move operations;
- dry-run no-write behavior;
- path traversal rejection;
- protected path behavior;
- stale plan detection;
- policy gate failures;
- apply report generation;
- AI/pack/plugin candidate plan boundaries.

## Maintenance Notes

Keep this document synchronized with future plan schema docs, apply report docs, command exit-code behavior, and filesystem safety implementation.
