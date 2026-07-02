---
schema_version: 1
type: workpacket

id: WP-0000
title: Title Goes Here
slug: title-goes-here

status: planned
priority: medium
risk: medium

epic: EPIC-0000
sprint: SPRINT-0000
milestone: v0.0.0
release_target: v1.0.0

sequence: 0
depends_on: []
blocks: []

related_adrs: []
related_docs: []
related_commands: []

affected_crates: []
affected_paths: []

owners:
  - role: implementer
    name: solo-developer

labels: []

machine:
  llm_ingest: true
  implementation_order: strict
  requires_plan: true
  mutates_files: true
  can_parallelize: false
  estimated_complexity: medium
---

# WP-0000: Title Goes Here

## 1. Purpose

Describe why this work packet exists.

## 2. Outcome Summary

After this work packet is complete:

- Outcome 1.

## 3. Context

Relevant background and decisions.

## 4. Scope

This work packet includes:

- Item 1.

## 5. Non-Goals

This work packet does not include:

- Non-goal 1.

## 6. Dependencies

### Required Prior Work

- None.

### Blocks

- None.

### Related ADRs

- None.

## 7. Inputs

Required inputs:

- Input 1.

## 8. Outputs

Expected outputs:

- Output 1.

## 9. Implementation Order

1. Task group 1.
2. Validation.

## 10. Tasks

### TASK-0000.1: Task title

**Purpose:** Explain the task purpose.

**Actions:**

1. Action 1.

**Expected Outcome:**

- Expected outcome.

**Validation:**

```bash
echo "validation command"
```

**Done When:**

- Done condition.

## 11. Subtasks

| ID | Parent Task | Title | Expected Outcome |
|---|---|---|---|
| SUBTASK-0000.1.1 | TASK-0000.1 | Subtask title | Outcome |

## 12. Expected File Changes

### Create

- `path/to/new-file`

### Modify

- `path/to/existing-file`

### Delete

- None.

## 13. Command Behavior

Commands affected:

- `monad example`

Expected behavior:

- Behavior 1.

## 14. Data Model / Schema Changes

None.

## 15. Safety Requirements

- Safety requirement 1.

## 16. Test Requirements

Required tests:

- Test 1.

## 17. Validation Commands

```bash
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
```

## 18. Acceptance Criteria

- [ ] Criterion 1.

## 19. Completion Evidence

**Completed At:** TBD  
**Completed By:** TBD  
**Commit(s):** TBD  

**Validation Result:** TBD

## 20. Notes for Human Implementers

Human-facing notes.

## 21. Notes for AI Implementers

- Follow this packet in order.
- Do not implement non-goals.
- Stop and report conflicts with ADRs or earlier packets.

## 22. Follow-Up Work

- Follow-up 1.
