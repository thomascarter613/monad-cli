---
schema_version: 1
type: workpacket

id: WP-0014
title: Remove Rename Move Migrate Upgrade
slug: remove-rename-move-migrate-upgrade

status: planned
priority: high
risk: medium

epic: EPIC-0010
sprint: SPRINT-0008
milestone: v0.8.0
release_target: v1.0.0

sequence: 14
depends_on:
  - WP-0013
blocks:
  - WP-0015

related_adrs: []
related_docs:
  - docs/product/v1-scope.md
  - docs/product/v1-command-reference.md
  - docs/architecture/cli-doctrine.md
  - docs/workpackets/schema.md

related_commands:
  - monad remove
  - monad rename
  - monad move
  - monad migrate
  - monad upgrade

affected_crates:
  - crates/monad-cli
  - crates/monad-core
  - crates/monad-plans
affected_paths:
  - crates/monad-cli/**
  - crates/monad-core/**
  - crates/monad-plans/**

owners:
  - role: implementer
    name: solo-developer
  - role: reviewer
    name: future-self

labels:
  - v1
  - monad
  - remove-rename-move-migrate-upgrade

machine:
  llm_ingest: true
  implementation_order: strict
  requires_plan: true
  mutates_files: true
  can_parallelize: false
  estimated_complexity: medium
---

# WP-0014: Remove Rename Move Migrate Upgrade

## 1. Purpose

Implement safe repository evolution commands for removing, renaming, moving, migrating, and upgrading workspace state.

## 2. Outcome Summary

After this work packet is complete:

- Evolution commands are safe.
- Destructive operations are guarded.
- Schema upgrades are documented.

## 3. Context

Monad is a Rust CLI for initializing, modifying, evolving, validating, documenting, graphing, governing, and managing serious monorepos.

This work packet follows the WP-0000 standard. It must be understandable by humans and coding-assistant LLMs, and it must provide enough implementation detail to proceed from repo-native planning artifacts.

## 4. Scope

This work packet includes:

- Evolution commands

## 5. Non-Goals

This work packet does not include:

- Perfect import rewriting

## 6. Dependencies

### Required Prior Work

- WP-0013

### Blocks

- WP-0015

### Related ADRs

- ADR-0001: Use Rust for Monad CLI, if applicable.

## 7. Inputs

Required inputs:

- Approved Monad v1 command reference.
- Approved Monad v1 defaults.
- WP-0000 work packet specification and schema.
- Existing repo docs under `docs/`.
- Existing workspace state under `monad.toml`, if present.

## 8. Outputs

Expected outputs:

- `crates/monad-cli/**`
- `crates/monad-core/**`
- `crates/monad-plans/**`

## 9. Implementation Order

1. Implement remove
2. Implement rename
3. Implement move
4. Implement migrate
5. Implement upgrade

## 10. Tasks


### TASK-0014.1: Implement remove

**Purpose:** Complete the `Implement remove` portion of this work packet.

**Actions:**

1. Review the relevant product, architecture, ADR, and prior work packet context.
2. Implement the smallest clear set of changes required for this task.
3. Keep behavior aligned with the approved Monad v1 command contract.
4. Add or update tests where behavior is introduced.
5. Update documentation if the task changes user-visible behavior.

**Expected Outcome:**

- `Implement remove` is implemented or fully specified according to this packet.
- Changes are understandable to human and AI implementers.
- The repository remains valid and testable.

**Validation:**

```bash
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
```

**Done When:**

- The task outcome is present in the repo.
- Required validation commands pass.
- No non-goals were implemented.

### TASK-0014.2: Implement rename

**Purpose:** Complete the `Implement rename` portion of this work packet.

**Actions:**

1. Review the relevant product, architecture, ADR, and prior work packet context.
2. Implement the smallest clear set of changes required for this task.
3. Keep behavior aligned with the approved Monad v1 command contract.
4. Add or update tests where behavior is introduced.
5. Update documentation if the task changes user-visible behavior.

**Expected Outcome:**

- `Implement rename` is implemented or fully specified according to this packet.
- Changes are understandable to human and AI implementers.
- The repository remains valid and testable.

**Validation:**

```bash
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
```

**Done When:**

- The task outcome is present in the repo.
- Required validation commands pass.
- No non-goals were implemented.

### TASK-0014.3: Implement move

**Purpose:** Complete the `Implement move` portion of this work packet.

**Actions:**

1. Review the relevant product, architecture, ADR, and prior work packet context.
2. Implement the smallest clear set of changes required for this task.
3. Keep behavior aligned with the approved Monad v1 command contract.
4. Add or update tests where behavior is introduced.
5. Update documentation if the task changes user-visible behavior.

**Expected Outcome:**

- `Implement move` is implemented or fully specified according to this packet.
- Changes are understandable to human and AI implementers.
- The repository remains valid and testable.

**Validation:**

```bash
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
```

**Done When:**

- The task outcome is present in the repo.
- Required validation commands pass.
- No non-goals were implemented.

### TASK-0014.4: Implement migrate

**Purpose:** Complete the `Implement migrate` portion of this work packet.

**Actions:**

1. Review the relevant product, architecture, ADR, and prior work packet context.
2. Implement the smallest clear set of changes required for this task.
3. Keep behavior aligned with the approved Monad v1 command contract.
4. Add or update tests where behavior is introduced.
5. Update documentation if the task changes user-visible behavior.

**Expected Outcome:**

- `Implement migrate` is implemented or fully specified according to this packet.
- Changes are understandable to human and AI implementers.
- The repository remains valid and testable.

**Validation:**

```bash
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
```

**Done When:**

- The task outcome is present in the repo.
- Required validation commands pass.
- No non-goals were implemented.

### TASK-0014.5: Implement upgrade

**Purpose:** Complete the `Implement upgrade` portion of this work packet.

**Actions:**

1. Review the relevant product, architecture, ADR, and prior work packet context.
2. Implement the smallest clear set of changes required for this task.
3. Keep behavior aligned with the approved Monad v1 command contract.
4. Add or update tests where behavior is introduced.
5. Update documentation if the task changes user-visible behavior.

**Expected Outcome:**

- `Implement upgrade` is implemented or fully specified according to this packet.
- Changes are understandable to human and AI implementers.
- The repository remains valid and testable.

**Validation:**

```bash
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
```

**Done When:**

- The task outcome is present in the repo.
- Required validation commands pass.
- No non-goals were implemented.


## 11. Subtasks

| ID | Parent Task | Title | Expected Outcome |
|---|---|---|---|
| SUBTASK-0014.1.1 | TASK-0014.1 | Execute Implement remove | Task outcome is implemented, documented, and validated. |
| SUBTASK-0014.2.1 | TASK-0014.2 | Execute Implement rename | Task outcome is implemented, documented, and validated. |
| SUBTASK-0014.3.1 | TASK-0014.3 | Execute Implement move | Task outcome is implemented, documented, and validated. |
| SUBTASK-0014.4.1 | TASK-0014.4 | Execute Implement migrate | Task outcome is implemented, documented, and validated. |
| SUBTASK-0014.5.1 | TASK-0014.5 | Execute Implement upgrade | Task outcome is implemented, documented, and validated. |

## 12. Expected File Changes

### Create

- `crates/monad-cli/**`
- `crates/monad-core/**`
- `crates/monad-plans/**`

### Modify

- `monad.toml`
- `README.md`
- `docs/00-index.md`
- Related docs and tests as needed.

### Delete

None unless explicitly required by the implementation task.

## 13. Command Behavior

Commands affected:

- `monad remove`
- `monad rename`
- `monad move`
- `monad migrate`
- `monad upgrade`

Expected behavior:

- Commands follow the approved v1 command contract.
- Mutating commands support `--dry-run`.
- Commands used in CI support machine-readable output where applicable.
- Help output is accurate and tested.

## 14. Data Model / Schema Changes

Data model changes must be documented before implementation.

If this packet adds or changes a schema, update:

- `docs/architecture/`
- `schemas/`
- relevant tests
- generated examples

## 15. Safety Requirements

- Do not write outside the workspace root.
- Do not silently overwrite user-modified files.
- Do not implement post-v1 non-goals.
- Keep changes plan-backed for mutating command behavior once the plan engine exists.
- Preserve `default_scope = "@monad"`.
- Preserve Markdown work packets as canonical.

## 16. Test Requirements

Required tests:

- Unit tests for new core logic.
- Smoke tests for user-visible commands.
- Golden tests for generated output where applicable.
- Error-path tests for invalid inputs.
- Documentation checks for new command behavior.

## 17. Validation Commands

```bash
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
bash scripts/check-docs.sh
```

## 18. Acceptance Criteria

- [ ] Evolution commands are safe.
- [ ] Destructive operations are guarded.
- [ ] Schema upgrades are documented.
- [ ] All listed tasks are complete.
- [ ] All required validation commands pass.
- [ ] Documentation is updated.
- [ ] No non-goals were implemented.
- [ ] Completion evidence is recorded.

## 19. Completion Evidence

**Completed At:** TBD  
**Completed By:** TBD  
**Commit(s):** TBD  

**Validation Run:**

```bash
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
bash scripts/check-docs.sh
```

**Validation Result:** TBD

## 20. Notes for Human Implementers

Implement this packet in order. Keep changes boring, clear, and reviewable. Prefer explicit code and tests over clever abstractions.

## 21. Notes for AI Implementers

- Read WP-0000 before implementing this packet.
- Follow tasks in numeric order.
- Do not implement non-goals.
- Do not silently alter public command signatures.
- Stop and report conflicts with ADRs, earlier packets, or the approved command reference.
- Run validation commands before claiming completion.
- Do not fabricate completion evidence.

## 22. Follow-Up Work

Follow-up work should be captured in later work packets, not added opportunistically to this packet.
