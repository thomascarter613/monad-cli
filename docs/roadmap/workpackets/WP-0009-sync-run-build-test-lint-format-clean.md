---
schema_version: 1
type: workpacket

id: WP-0009
title: Sync Run Build Test Lint Format Clean
slug: sync-run-build-test-lint-format-clean

status: planned
priority: high
risk: medium

epic: EPIC-0005
sprint: SPRINT-0005
milestone: v0.6.0
release_target: v1.0.0

sequence: 9
depends_on:
  - WP-0008
blocks:
  - WP-0010

related_adrs: []
related_docs:
  - docs/product/v1-scope.md
  - docs/product/v1-command-reference.md
  - docs/architecture/cli-doctrine.md
  - docs/workpackets/schema.md

related_commands:
  - monad sync
  - monad run
  - monad build
  - monad test
  - monad lint
  - monad format
  - monad clean

affected_crates:
  - crates/monad-cli
  - crates/monad-core
affected_paths:
  - crates/monad-cli/**
  - crates/monad-core/**

owners:
  - role: implementer
    name: solo-developer
  - role: reviewer
    name: future-self

labels:
  - v1
  - monad
  - sync-run-build-test-lint-format-clean

machine:
  llm_ingest: true
  implementation_order: strict
  requires_plan: true
  mutates_files: true
  can_parallelize: false
  estimated_complexity: medium
---

# WP-0009: Sync Run Build Test Lint Format Clean

## 1. Purpose

Implement native tool coordination for sync, task execution, build, test, lint, format, and clean.

## 2. Outcome Summary

After this work packet is complete:

- Native tool delegation works.
- Clean is safe.
- Sync is plan-backed.

## 3. Context

Monad is a Rust CLI for initializing, modifying, evolving, validating, documenting, graphing, governing, and managing serious monorepos.

This work packet follows the WP-0000 standard. It must be understandable by humans and coding-assistant LLMs, and it must provide enough implementation detail to proceed from repo-native planning artifacts.

## 4. Scope

This work packet includes:

- Task coordination
- Native tool interop

## 5. Non-Goals

This work packet does not include:

- Replacing native tools

## 6. Dependencies

### Required Prior Work

- WP-0008

### Blocks

- WP-0010

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

## 9. Implementation Order

1. Implement sync check/write
2. Implement task delegation
3. Implement build/test/lint/format wrappers
4. Implement clean with dry-run
5. Add fake-command tests

## 10. Tasks


### TASK-0009.1: Implement sync check/write

**Purpose:** Complete the `Implement sync check/write` portion of this work packet.

**Actions:**

1. Review the relevant product, architecture, ADR, and prior work packet context.
2. Implement the smallest clear set of changes required for this task.
3. Keep behavior aligned with the approved Monad v1 command contract.
4. Add or update tests where behavior is introduced.
5. Update documentation if the task changes user-visible behavior.

**Expected Outcome:**

- `Implement sync check/write` is implemented or fully specified according to this packet.
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

### TASK-0009.2: Implement task delegation

**Purpose:** Complete the `Implement task delegation` portion of this work packet.

**Actions:**

1. Review the relevant product, architecture, ADR, and prior work packet context.
2. Implement the smallest clear set of changes required for this task.
3. Keep behavior aligned with the approved Monad v1 command contract.
4. Add or update tests where behavior is introduced.
5. Update documentation if the task changes user-visible behavior.

**Expected Outcome:**

- `Implement task delegation` is implemented or fully specified according to this packet.
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

### TASK-0009.3: Implement build/test/lint/format wrappers

**Purpose:** Complete the `Implement build/test/lint/format wrappers` portion of this work packet.

**Actions:**

1. Review the relevant product, architecture, ADR, and prior work packet context.
2. Implement the smallest clear set of changes required for this task.
3. Keep behavior aligned with the approved Monad v1 command contract.
4. Add or update tests where behavior is introduced.
5. Update documentation if the task changes user-visible behavior.

**Expected Outcome:**

- `Implement build/test/lint/format wrappers` is implemented or fully specified according to this packet.
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

### TASK-0009.4: Implement clean with dry-run

**Purpose:** Complete the `Implement clean with dry-run` portion of this work packet.

**Actions:**

1. Review the relevant product, architecture, ADR, and prior work packet context.
2. Implement the smallest clear set of changes required for this task.
3. Keep behavior aligned with the approved Monad v1 command contract.
4. Add or update tests where behavior is introduced.
5. Update documentation if the task changes user-visible behavior.

**Expected Outcome:**

- `Implement clean with dry-run` is implemented or fully specified according to this packet.
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

### TASK-0009.5: Add fake-command tests

**Purpose:** Complete the `Add fake-command tests` portion of this work packet.

**Actions:**

1. Review the relevant product, architecture, ADR, and prior work packet context.
2. Implement the smallest clear set of changes required for this task.
3. Keep behavior aligned with the approved Monad v1 command contract.
4. Add or update tests where behavior is introduced.
5. Update documentation if the task changes user-visible behavior.

**Expected Outcome:**

- `Add fake-command tests` is implemented or fully specified according to this packet.
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
| SUBTASK-0009.1.1 | TASK-0009.1 | Execute Implement sync check/write | Task outcome is implemented, documented, and validated. |
| SUBTASK-0009.2.1 | TASK-0009.2 | Execute Implement task delegation | Task outcome is implemented, documented, and validated. |
| SUBTASK-0009.3.1 | TASK-0009.3 | Execute Implement build/test/lint/format wrappers | Task outcome is implemented, documented, and validated. |
| SUBTASK-0009.4.1 | TASK-0009.4 | Execute Implement clean with dry-run | Task outcome is implemented, documented, and validated. |
| SUBTASK-0009.5.1 | TASK-0009.5 | Execute Add fake-command tests | Task outcome is implemented, documented, and validated. |

## 12. Expected File Changes

### Create

- `crates/monad-cli/**`
- `crates/monad-core/**`

### Modify

- `monad.toml`
- `README.md`
- `docs/00-index.md`
- Related docs and tests as needed.

### Delete

None unless explicitly required by the implementation task.

## 13. Command Behavior

Commands affected:

- `monad sync`
- `monad run`
- `monad build`
- `monad test`
- `monad lint`
- `monad format`
- `monad clean`

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

- [ ] Native tool delegation works.
- [ ] Clean is safe.
- [ ] Sync is plan-backed.
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
