---
schema_version: 1
type: workpacket

id: WP-0011
title: Docs ADR and Workpacket Commands
slug: docs-adr-and-workpacket-commands

status: planned
priority: high
risk: medium

epic: EPIC-0007
sprint: SPRINT-0006
milestone: v0.7.0
release_target: v1.0.0

sequence: 11
depends_on:
  - WP-0010
blocks:
  - WP-0012

related_adrs: []
related_docs:
  - docs/product/v1-scope.md
  - docs/product/v1-command-reference.md
  - docs/architecture/cli-doctrine.md
  - docs/workpackets/schema.md

related_commands:
  - monad docs generate
  - monad docs check
  - monad adr new
  - monad adr list
  - monad adr supersede
  - monad workpacket new
  - monad workpacket list
  - monad workpacket plan

affected_crates:
  - crates/monad-cli
  - crates/monad-core
  - crates/monad-context
affected_paths:
  - crates/monad-cli/**
  - docs/**

owners:
  - role: implementer
    name: solo-developer
  - role: reviewer
    name: future-self

labels:
  - v1
  - monad
  - docs-adr-and-workpacket-commands

machine:
  llm_ingest: true
  implementation_order: strict
  requires_plan: true
  mutates_files: true
  can_parallelize: false
  estimated_complexity: medium
---

# WP-0011: Docs ADR and Workpacket Commands

## 1. Purpose

Implement documentation, ADR, and work packet authoring workflows based on the WP-0000 standard.

## 2. Outcome Summary

After this work packet is complete:

- Workpacket commands honor WP-0000.
- ADR commands work.
- Docs can be refreshed.

## 3. Context

Monad is a Rust CLI for initializing, modifying, evolving, validating, documenting, graphing, governing, and managing serious monorepos.

This work packet follows the WP-0000 standard. It must be understandable by humans and coding-assistant LLMs, and it must provide enough implementation detail to proceed from repo-native planning artifacts.

## 4. Scope

This work packet includes:

- Docs commands
- ADR commands
- Workpacket commands

## 5. Non-Goals

This work packet does not include:

- Issue tracker sync

## 6. Dependencies

### Required Prior Work

- WP-0010

### Blocks

- WP-0012

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
- `docs/**`

## 9. Implementation Order

1. Implement docs generate/check
2. Implement ADR commands
3. Implement workpacket new/list/plan
4. Parse workpacket front matter
5. Generate indexes

## 10. Tasks


### TASK-0011.1: Implement docs generate/check

**Purpose:** Complete the `Implement docs generate/check` portion of this work packet.

**Actions:**

1. Review the relevant product, architecture, ADR, and prior work packet context.
2. Implement the smallest clear set of changes required for this task.
3. Keep behavior aligned with the approved Monad v1 command contract.
4. Add or update tests where behavior is introduced.
5. Update documentation if the task changes user-visible behavior.

**Expected Outcome:**

- `Implement docs generate/check` is implemented or fully specified according to this packet.
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

### TASK-0011.2: Implement ADR commands

**Purpose:** Complete the `Implement ADR commands` portion of this work packet.

**Actions:**

1. Review the relevant product, architecture, ADR, and prior work packet context.
2. Implement the smallest clear set of changes required for this task.
3. Keep behavior aligned with the approved Monad v1 command contract.
4. Add or update tests where behavior is introduced.
5. Update documentation if the task changes user-visible behavior.

**Expected Outcome:**

- `Implement ADR commands` is implemented or fully specified according to this packet.
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

### TASK-0011.3: Implement workpacket new/list/plan

**Purpose:** Complete the `Implement workpacket new/list/plan` portion of this work packet.

**Actions:**

1. Review the relevant product, architecture, ADR, and prior work packet context.
2. Implement the smallest clear set of changes required for this task.
3. Keep behavior aligned with the approved Monad v1 command contract.
4. Add or update tests where behavior is introduced.
5. Update documentation if the task changes user-visible behavior.

**Expected Outcome:**

- `Implement workpacket new/list/plan` is implemented or fully specified according to this packet.
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

### TASK-0011.4: Parse workpacket front matter

**Purpose:** Complete the `Parse workpacket front matter` portion of this work packet.

**Actions:**

1. Review the relevant product, architecture, ADR, and prior work packet context.
2. Implement the smallest clear set of changes required for this task.
3. Keep behavior aligned with the approved Monad v1 command contract.
4. Add or update tests where behavior is introduced.
5. Update documentation if the task changes user-visible behavior.

**Expected Outcome:**

- `Parse workpacket front matter` is implemented or fully specified according to this packet.
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

### TASK-0011.5: Generate indexes

**Purpose:** Complete the `Generate indexes` portion of this work packet.

**Actions:**

1. Review the relevant product, architecture, ADR, and prior work packet context.
2. Implement the smallest clear set of changes required for this task.
3. Keep behavior aligned with the approved Monad v1 command contract.
4. Add or update tests where behavior is introduced.
5. Update documentation if the task changes user-visible behavior.

**Expected Outcome:**

- `Generate indexes` is implemented or fully specified according to this packet.
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
| SUBTASK-0011.1.1 | TASK-0011.1 | Execute Implement docs generate/check | Task outcome is implemented, documented, and validated. |
| SUBTASK-0011.2.1 | TASK-0011.2 | Execute Implement ADR commands | Task outcome is implemented, documented, and validated. |
| SUBTASK-0011.3.1 | TASK-0011.3 | Execute Implement workpacket new/list/plan | Task outcome is implemented, documented, and validated. |
| SUBTASK-0011.4.1 | TASK-0011.4 | Execute Parse workpacket front matter | Task outcome is implemented, documented, and validated. |
| SUBTASK-0011.5.1 | TASK-0011.5 | Execute Generate indexes | Task outcome is implemented, documented, and validated. |

## 12. Expected File Changes

### Create

- `crates/monad-cli/**`
- `docs/**`

### Modify

- `monad.toml`
- `README.md`
- `docs/00-index.md`
- Related docs and tests as needed.

### Delete

None unless explicitly required by the implementation task.

## 13. Command Behavior

Commands affected:

- `monad docs generate`
- `monad docs check`
- `monad adr new`
- `monad adr list`
- `monad adr supersede`
- `monad workpacket new`
- `monad workpacket list`
- `monad workpacket plan`

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

- [ ] Workpacket commands honor WP-0000.
- [ ] ADR commands work.
- [ ] Docs can be refreshed.
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
