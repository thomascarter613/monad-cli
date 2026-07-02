---
schema_version: 1
type: workpacket

id: WP-0000
title: Work Packet Specification and Schema
slug: work-packet-specification-and-schema

status: planned
priority: high
risk: medium

epic: EPIC-0000
sprint: SPRINT-0000
milestone: v0.0.1
release_target: v1.0.0

sequence: 0
depends_on:[]
blocks:
  - WP-0001

related_adrs: []
related_docs:
  - docs/product/v1-scope.md
  - docs/product/v1-command-reference.md
  - docs/architecture/cli-doctrine.md
  - docs/workpackets/schema.md

related_commands:
  - monad workpacket new
  - monad workpacket list
  - monad workpacket plan

affected_crates:
  - crates/monad-core
  - crates/monad-context
  - crates/monad-graph
affected_paths:
  - docs/workpackets/**
  - schemas/**
  - .monad/index/**

owners:
  - role: implementer
    name: solo-developer
  - role: reviewer
    name: future-self

labels:
  - v1
  - monad
  - work-packet-specification-and-schema

machine:
  llm_ingest: true
  implementation_order: strict
  requires_plan: true
  mutates_files: true
  can_parallelize: false
  estimated_complexity: medium
---

# WP-0000: Work Packet Specification and Schema

## 1. Purpose

Define the canonical work packet format, required metadata, Markdown structure, JSON schema, lifecycle statuses, relationship model, and AI/human implementation contract. Then all future packets follow this standard.

## 2. Outcome Summary

After this work packet is complete:

- Canonical work packet standard exists.
- JSON schemas exist.
- All future packets can follow the standard.

## 3. Context

Monad is a Rust CLI for initializing, modifying, evolving, validating, documenting, graphing, governing, and managing serious monorepos.

This work packet follows the WP-0000 standard. It must be understandable by humans and coding-assistant LLMs, and it must provide enough implementation detail to proceed from repo-native planning artifacts.

## 4. Scope

This work packet includes:

- Work packet format
- JSON schema
- Epic and sprint templates
- AI/human implementation contract

## 5. Non-Goals

This work packet does not include:

- Implementing full workpacket commands
- Remote issue tracker integrations
- Automatic AI coding

## 6. Dependencies

### Required Prior Work

- None.

### Blocks

- WP-0001

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

- `docs/workpackets/**`
- `schemas/**`
- `.monad/index/**`

## 9. Implementation Order

1. Create work packet documentation structure
2. Define lifecycle statuses
3. Define YAML front matter
4. Define Markdown body structure
5. Define task and subtask conventions
6. Define relationship model
7. Define epic and sprint formats
8. Define JSON schemas
9. Define generated indexes
10. Define AI/human implementation contract

## 10. Tasks


### TASK-0000.1: Create work packet documentation structure

**Purpose:** Complete the `Create work packet documentation structure` portion of this work packet.

**Actions:**

1. Review the relevant product, architecture, ADR, and prior work packet context.
2. Implement the smallest clear set of changes required for this task.
3. Keep behavior aligned with the approved Monad v1 command contract.
4. Add or update tests where behavior is introduced.
5. Update documentation if the task changes user-visible behavior.

**Expected Outcome:**

- `Create work packet documentation structure` is implemented or fully specified according to this packet.
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

### TASK-0000.2: Define lifecycle statuses

**Purpose:** Complete the `Define lifecycle statuses` portion of this work packet.

**Actions:**

1. Review the relevant product, architecture, ADR, and prior work packet context.
2. Implement the smallest clear set of changes required for this task.
3. Keep behavior aligned with the approved Monad v1 command contract.
4. Add or update tests where behavior is introduced.
5. Update documentation if the task changes user-visible behavior.

**Expected Outcome:**

- `Define lifecycle statuses` is implemented or fully specified according to this packet.
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

### TASK-0000.3: Define YAML front matter

**Purpose:** Complete the `Define YAML front matter` portion of this work packet.

**Actions:**

1. Review the relevant product, architecture, ADR, and prior work packet context.
2. Implement the smallest clear set of changes required for this task.
3. Keep behavior aligned with the approved Monad v1 command contract.
4. Add or update tests where behavior is introduced.
5. Update documentation if the task changes user-visible behavior.

**Expected Outcome:**

- `Define YAML front matter` is implemented or fully specified according to this packet.
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

### TASK-0000.4: Define Markdown body structure

**Purpose:** Complete the `Define Markdown body structure` portion of this work packet.

**Actions:**

1. Review the relevant product, architecture, ADR, and prior work packet context.
2. Implement the smallest clear set of changes required for this task.
3. Keep behavior aligned with the approved Monad v1 command contract.
4. Add or update tests where behavior is introduced.
5. Update documentation if the task changes user-visible behavior.

**Expected Outcome:**

- `Define Markdown body structure` is implemented or fully specified according to this packet.
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

### TASK-0000.5: Define task and subtask conventions

**Purpose:** Complete the `Define task and subtask conventions` portion of this work packet.

**Actions:**

1. Review the relevant product, architecture, ADR, and prior work packet context.
2. Implement the smallest clear set of changes required for this task.
3. Keep behavior aligned with the approved Monad v1 command contract.
4. Add or update tests where behavior is introduced.
5. Update documentation if the task changes user-visible behavior.

**Expected Outcome:**

- `Define task and subtask conventions` is implemented or fully specified according to this packet.
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

### TASK-0000.6: Define relationship model

**Purpose:** Complete the `Define relationship model` portion of this work packet.

**Actions:**

1. Review the relevant product, architecture, ADR, and prior work packet context.
2. Implement the smallest clear set of changes required for this task.
3. Keep behavior aligned with the approved Monad v1 command contract.
4. Add or update tests where behavior is introduced.
5. Update documentation if the task changes user-visible behavior.

**Expected Outcome:**

- `Define relationship model` is implemented or fully specified according to this packet.
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

### TASK-0000.7: Define epic and sprint formats

**Purpose:** Complete the `Define epic and sprint formats` portion of this work packet.

**Actions:**

1. Review the relevant product, architecture, ADR, and prior work packet context.
2. Implement the smallest clear set of changes required for this task.
3. Keep behavior aligned with the approved Monad v1 command contract.
4. Add or update tests where behavior is introduced.
5. Update documentation if the task changes user-visible behavior.

**Expected Outcome:**

- `Define epic and sprint formats` is implemented or fully specified according to this packet.
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

### TASK-0000.8: Define JSON schemas

**Purpose:** Complete the `Define JSON schemas` portion of this work packet.

**Actions:**

1. Review the relevant product, architecture, ADR, and prior work packet context.
2. Implement the smallest clear set of changes required for this task.
3. Keep behavior aligned with the approved Monad v1 command contract.
4. Add or update tests where behavior is introduced.
5. Update documentation if the task changes user-visible behavior.

**Expected Outcome:**

- `Define JSON schemas` is implemented or fully specified according to this packet.
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

### TASK-0000.9: Define generated indexes

**Purpose:** Complete the `Define generated indexes` portion of this work packet.

**Actions:**

1. Review the relevant product, architecture, ADR, and prior work packet context.
2. Implement the smallest clear set of changes required for this task.
3. Keep behavior aligned with the approved Monad v1 command contract.
4. Add or update tests where behavior is introduced.
5. Update documentation if the task changes user-visible behavior.

**Expected Outcome:**

- `Define generated indexes` is implemented or fully specified according to this packet.
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

### TASK-0000.10: Define AI/human implementation contract

**Purpose:** Complete the `Define AI/human implementation contract` portion of this work packet.

**Actions:**

1. Review the relevant product, architecture, ADR, and prior work packet context.
2. Implement the smallest clear set of changes required for this task.
3. Keep behavior aligned with the approved Monad v1 command contract.
4. Add or update tests where behavior is introduced.
5. Update documentation if the task changes user-visible behavior.

**Expected Outcome:**

- `Define AI/human implementation contract` is implemented or fully specified according to this packet.
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
| SUBTASK-0000.1.1 | TASK-0000.1 | Execute Create work packet documentation structure | Task outcome is implemented, documented, and validated. |
| SUBTASK-0000.2.1 | TASK-0000.2 | Execute Define lifecycle statuses | Task outcome is implemented, documented, and validated. |
| SUBTASK-0000.3.1 | TASK-0000.3 | Execute Define YAML front matter | Task outcome is implemented, documented, and validated. |
| SUBTASK-0000.4.1 | TASK-0000.4 | Execute Define Markdown body structure | Task outcome is implemented, documented, and validated. |
| SUBTASK-0000.5.1 | TASK-0000.5 | Execute Define task and subtask conventions | Task outcome is implemented, documented, and validated. |
| SUBTASK-0000.6.1 | TASK-0000.6 | Execute Define relationship model | Task outcome is implemented, documented, and validated. |
| SUBTASK-0000.7.1 | TASK-0000.7 | Execute Define epic and sprint formats | Task outcome is implemented, documented, and validated. |
| SUBTASK-0000.8.1 | TASK-0000.8 | Execute Define JSON schemas | Task outcome is implemented, documented, and validated. |
| SUBTASK-0000.9.1 | TASK-0000.9 | Execute Define generated indexes | Task outcome is implemented, documented, and validated. |
| SUBTASK-0000.10.1 | TASK-0000.10 | Execute Define AI/human implementation contract | Task outcome is implemented, documented, and validated. |

## 12. Expected File Changes

### Create

- `docs/workpackets/**`
- `schemas/**`
- `.monad/index/**`

### Modify

- `monad.toml`
- `README.md`
- `docs/00-index.md`
- Related docs and tests as needed.

### Delete

None unless explicitly required by the implementation task.

## 13. Command Behavior

Commands affected:

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

- [ ] Canonical work packet standard exists.
- [ ] JSON schemas exist.
- [ ] All future packets can follow the standard.
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

This packet intentionally comes before implementation-heavy work.

The goal is to prevent future packets from becoming inconsistent, under-specified, or too vague for coding assistants to use. Treat the work packet standard as part of Monad's product architecture, not merely documentation.

Do not make the standard so complicated that humans avoid using it. The format should be detailed, predictable, and repeatable.

## 21. Notes for AI Implementers

- This packet defines the standard for itself and all later work packets.
- Follow tasks in numeric order.
- Do not implement non-goals.
- Do not silently alter public command signatures.
- Stop and report conflicts with ADRs, earlier packets, or the approved command reference.
- Run validation commands before claiming completion.
- Do not fabricate completion evidence.

## 22. Follow-Up Work

Follow-up work should be captured in later work packets, not added opportunistically to this packet.
