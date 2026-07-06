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

This work packet defines the canonical work-packet specification and schema for Monad OS / Monad CLI.

Monad uses work packets as repository-native delivery contracts. A work packet is not merely a task list, issue, or planning note. It is the structured unit that connects roadmap intent to implementation, tests, documentation, governance, policy, risk, and release evidence.

The delivery hierarchy is:

```text
Epic
  Work Packet
    Layer
      Task
```

This work packet establishes the standard that all later work packets should follow.

---

## Problem Statement

Monad’s roadmap is intentionally large and governance-oriented.

Without a normalized work-packet model, the roadmap can drift into disconnected implementation work:

```text
features without requirements
requirements without tests
ADRs without implementation paths
commands without documentation
docs without owners
policies without findings
risks without controls
release claims without evidence
```

That would undermine Monad’s core thesis: a repository should be understandable, governable, traceable, and safe to evolve.

WP-0000 prevents that drift by defining the work-packet structure before the rest of the roadmap is materialized.


## 2. Outcome Summary

After this work packet is complete:

- Canonical work packet standard exists.
- JSON schemas exist.
- All future packets can follow the standard.

## 3. Context

Monad is a Rust CLI for initializing, modifying, evolving, validating, documenting, graphing, governing, and managing serious monorepos.

This work packet follows the WP-0000 standard. It must be understandable by humans and coding-assistant LLMs, and it must provide enough implementation detail to proceed from repo-native planning artifacts.

## Scope

In scope:

```text
work-packet ID convention
work-packet file naming convention
metadata standard
status model
required section model
layer convention
task convention
traceability convention
test plan convention
documentation convention
risk convention
definition of done convention
future validation expectations
```

Out of scope:

```text
Rust parser implementation
CLI command implementation
schema validation implementation
automatic file generation
hosted synchronization
workflow automation
```

---

## Goals

This work packet should:

1. Define the canonical work-packet ID format.
2. Define the canonical work-packet filename format.
3. Define required metadata fields.
4. Define allowed status values.
5. Define required sections.
6. Define layer and task conventions.
7. Define cross-link expectations.
8. Define acceptance criteria expectations.
9. Define test plan expectations.
10. Define documentation update expectations.
11. Define rollback and safety expectations.
12. Define future validation targets for `monad workpacket validate`.

---

## Non-Goals

This work packet does not implement:

```text
monad workpacket list
monad workpacket validate
monad workpacket new
monad workpacket plan
machine-readable schemas
YAML frontmatter parsing
automatic roadmap synchronization
hosted project management integration
GitHub issue synchronization
Jira or Linear synchronization
Implementing full workpacket commands
Remote issue tracker integrations
Automatic AI coding
```

Those may come later.

This work packet only defines the repo-native work-packet standard.

---

## Canonical Location

Work packets live in:

```text
docs/roadmap/work-packets/
```

The index file is:

```text
docs/roadmap/work-packets/index.md
```

This work packet lives at:

```text
docs/roadmap/work-packets/WP-0000-work-packet-specification-and-schema.md
```

---

## ID Convention

Work-packet IDs use:

```text
WP-NNNN
```

Examples:

```text
WP-0000
WP-0001
WP-0010
WP-0031
```

Rules:

1. Work-packet IDs are stable.
2. Work-packet IDs are never reused.
3. IDs do not encode status.
4. IDs do not encode owner.
5. IDs do not encode implementation date.
6. IDs should remain stable even if titles change.
7. Superseded IDs remain reserved.
8. Deprecated IDs remain reserved.
9. Rejected IDs remain reserved if they were ever referenced.

---

## Filename Convention

Work-packet files should use:

```text
WP-NNNN-kebab-case-title.md
```

Examples:

```text
WP-0000-work-packet-specification-and-schema.md
WP-0001-rust-workspace-and-cli-skeleton.md
WP-0002-core-workspace-model-and-manifest-schema.md
```

Rules:

1. Filename begins with the work-packet ID.
2. Filename title is kebab-case.
3. Filename title should match the current work-packet title where practical.
4. File renames must update `docs/roadmap/work-packets/index.md`.
5. File renames must not change the work-packet ID.

---

## Status Values

Allowed work-packet statuses:

```text
planned
ready
active
blocked
implemented
validated
closed
deferred
superseded
```

| Status      | Meaning                                                          |
| ----------- | ---------------------------------------------------------------- |
| planned     | The work packet is known but not yet ready for implementation.   |
| ready       | The work packet is detailed enough to begin.                     |
| active      | Work is currently underway.                                      |
| blocked     | Work cannot continue until a dependency or decision is resolved. |
| implemented | Code or docs exist, but validation may not be complete.          |
| validated   | Tests, docs, acceptance criteria, and evidence pass.             |
| closed      | Work is complete and no active follow-up remains.                |
| deferred    | Work is intentionally postponed.                                 |
| superseded  | Work has been replaced by another work packet.                   |

---

## Required Metadata

Every work packet should include this metadata block near the top:

```markdown
# WP-NNNN: Title

schema_version: 1
id: WP-0000
Status: Planned  
priority: high
risk: medium
type: workpacket

title: Work Packet Specification and Schema
slug: work-packet-specification-and-schema

Epic: EPIC-NNNN  
sprint: SPRINT-0000
Stage: Stage N  
release_target: v1.0.0
milestone: v0.0.1

sequence: 0
depends_on:[]
blocks:
  - WP-0001

Related Requirements: FR-NNN, NFR-NNN  
Related ADRs: ADR-NNNN  
Related BDD: BDD-DOMAIN-NNN  
Related Tests: test name or test category  
Related Policies: POLICY-ID  
Related Findings: FINDING-ID  
Related Risks: RISK-NNN  

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
```

Use:

```text
None yet.
```

when a relationship does not exist yet.

Do not silently omit relationship fields after a work packet is normalized.

---

## Required Sections

A detailed work packet should include:

```text
Purpose
Problem Statement
Goals
Non-Goals
Scope
Out of Scope
Inputs
Outputs
Dependencies
Affected Areas
Command Impact
Data and Schema Impact
Filesystem Impact
Security and Safety Impact
Layers
Tasks
Test Plan
Documentation Updates
Acceptance Criteria
Rollback Strategy
Risks and Mitigations
Definition of Done
Follow-Up Work
```

Small work packets may be shorter, but omitted sections should be intentional.

---

## Cross-Link Convention

Use IDs as primary references.

Use file paths as secondary references when useful.

Good:

```markdown
Related Requirements: FR-004, NFR-002  
Related ADRs: ADR-0005  
Related Work Packets: WP-0002  
Related Policies: POLICY-CANONICAL-MANIFEST  
Related Findings: MANIFEST-CANONICAL-CONFLICT  
Related Risks: RISK-002  
```

Better when a file path is helpful:

```markdown
Related ADRs:
- ADR-0005: `docs/architecture/decision-records/adr-0005-canonical-manifest.md`

Related Work Packets:
- WP-0002: `docs/roadmap/work-packets/WP-0002-core-workspace-model-and-manifest-schema.md`
```

Avoid making filenames the canonical identity.

Files can move. IDs should remain stable.

---

## Layer Convention

Layers are ordered implementation slices within a work packet.

Layer IDs should use:

```text
LAYER-NNNN.N
```

Examples:

```text
LAYER-0000.1
LAYER-0000.2
LAYER-0000.3
```

Layer titles should be concise and implementation-oriented.

Example:

```markdown
### LAYER-0000.1: Define Work-Packet Metadata Standard
```

Layer rules:

1. Layers should be ordered.
2. Layers should be small enough to review.
3. Layers should preserve rollback boundaries.
4. Layers should avoid mixing unrelated concerns.
5. Layers should identify test expectations where applicable.

---

## Task Convention

Tasks are implementation steps inside a layer.

Tasks should be specific and ordered.

Example:

```markdown
#### Tasks

1. Add the work-packet metadata standard.
2. Define allowed statuses.
3. Define required cross-link fields.
4. Add examples.
5. Update the work-packet index.
```

Tasks should not be so tiny that the work packet becomes unreadable.

---

## Inputs

Inputs for this work packet:

```text
docs/reference/ids.md
docs/roadmap/roadmap.md
docs/roadmap/work-packets/index.md
docs/planning/index.md
docs/planning/0014-implementation-roadmap.md
docs/planning/0018-traceability-matrix.md
docs/product/requirements-index.md
docs/architecture/decision-records/index.md
```

---

## Outputs

Outputs from this work packet:

```text
docs/roadmap/work-packets/WP-0000-work-packet-specification-and-schema.md
```

Conceptual outputs:

```text
work-packet metadata standard
work-packet section standard
work-packet status model
work-packet ID convention
work-packet layer convention
work-packet traceability convention
future validation target
```

---

## Dependencies

This work packet depends on:

```text
docs/reference/ids.md
docs/product/requirements-index.md
docs/architecture/decision-records/index.md
docs/roadmap/work-packets/index.md
```

This work packet should precede the detailed expansion of later work packets.

---

## Affected Areas

Affected repository areas:

```text
docs/roadmap/work-packets/
docs/roadmap/roadmap.md
docs/reference/ids.md
governance/traceability-matrix.md
```

Future affected commands:

```text
cmd:monad workpacket list
cmd:monad workpacket validate
cmd:monad docs check
cmd:monad trace check
cmd:monad release readiness
```

---

## Command Impact

No immediate CLI implementation is required.

Future command impact:

1. `monad workpacket list` should read the work-packet index.
2. `monad workpacket validate` should validate work-packet structure.
3. `monad docs check` should detect missing work-packet files.
4. `monad trace check` should detect broken work-packet references.
5. `monad release readiness` should use work-packet status and evidence.

---

## Data and Schema Impact

No machine-readable schema is required immediately.

Future schema candidates:

```text
SCHEMA-WORKPACKET-V0
SCHEMA-WORKPACKET-INDEX-V0
```

Possible future files:

```text
schemas/workpacket.schema.json
schemas/workpacket-index.schema.json
```

For now, the Markdown structure should be predictable enough for later parsing.

---

## Filesystem Impact

This work packet creates or updates files under:

```text
docs/roadmap/work-packets/
```

It should not modify source code.

It should not write generated state under `.monad/`.

It should not require network access.

---

## Security and Safety Impact

Direct security impact is low because this is documentation/governance work.

Indirect safety impact is important because the work-packet model requires future work packets to document:

```text
filesystem impact
mutation behavior
security and safety impact
test plan
rollback strategy
risks and mitigations
acceptance criteria
```

This supports Monad’s plan-backed and safety-first doctrine.

---

## Layers

### LAYER-0000.1: Define Work-Packet Metadata Standard

#### Purpose

Define the metadata every normalized work packet should include.

#### Tasks

1. Define required metadata fields.
2. Define allowed status values.
3. Define cross-link fields.
4. Define owner role field.
5. Define source file expectations.

#### Acceptance Criteria

1. Metadata fields are documented.
2. Status values are documented.
3. Cross-link fields are documented.
4. Future work packets can copy the metadata pattern.

---

### LAYER-0000.2: Define Work-Packet Section Standard

#### Purpose

Define the required sections for detailed work packets.

#### Tasks

1. List required sections.
2. Explain omitted sections should be intentional.
3. Define test plan expectations.
4. Define documentation update expectations.
5. Define definition-of-done expectations.

#### Acceptance Criteria

1. Required sections are documented.
2. Future work packets can follow the same structure.
3. Validation targets are clear enough to implement later.

---

### LAYER-0000.3: Define ID and File Naming Rules

#### Purpose

Ensure work-packet files can be found, referenced, and validated.

#### Tasks

1. Define `WP-NNNN` ID format.
2. Define filename format.
3. Define renaming rules.
4. Define supersession rules.

#### Acceptance Criteria

1. ID format is documented.
2. Filename convention is documented.
3. Superseded IDs remain reserved.
4. IDs remain stable even if titles change.

---

### LAYER-0000.4: Define Layer and Task Rules

#### Purpose

Make implementation sequence explicit inside each work packet.

#### Tasks

1. Define layer ID format.
2. Define task format.
3. Define layer ordering rules.
4. Define rollback boundary expectations.

#### Acceptance Criteria

1. Layer convention is documented.
2. Task convention is documented.
3. Future work packets can decompose implementation cleanly.

---

### LAYER-0000.5: Define Future Validation Targets

#### Purpose

Prepare the structure for future Monad validation commands.

#### Tasks

1. Define future `monad workpacket validate` checks.
2. Define future `monad docs check` checks.
3. Define future `monad trace check` checks.
4. Define future findings.

#### Acceptance Criteria

1. Future validation targets are documented.
2. Finding IDs are named.
3. Validation can begin as warnings before enforcement.

---

## Test Plan

This work packet is documentation-first, so early validation is manual.

Future automated tests should cover the following.

### Documentation Presence Tests

Validate:

```text
docs/roadmap/work-packets/index.md exists
WP-0000 file exists
all indexed active-slice work packets exist
```

### Structure Tests

Validate each work packet includes:

```text
status
epic
stage
version target
owner role
related requirements
related ADRs
related risks
purpose
scope
acceptance criteria
definition of done
```

### ID Format Tests

Validate:

```text
WP IDs match WP-NNNN
Layer IDs match LAYER-NNNN.N
ADR IDs match ADR-NNNN
Requirement IDs match FR-NNN or NFR-NNN
Risk IDs match RISK-NNN
Policy IDs match POLICY-*
```

### Cross-Link Tests

Validate referenced IDs exist in their registries:

```text
requirements index
ADR index
work-packet index
policy registry
risk register
findings reference
release evidence reference
```

---

## Documentation Updates

This work packet requires or supports updates to:

```text
docs/roadmap/work-packets/index.md
docs/reference/ids.md
governance/traceability-matrix.md
docs/reference/findings.md
```

Future related docs:

```text
docs/reference/work-packet-schema.md
docs/user-guide/workpacket-commands.md
```

---

## Acceptance Criteria

This work packet is accepted when:

1. Work-packet ID convention is documented.
2. Work-packet filename convention is documented.
3. Work-packet status values are documented.
4. Required metadata fields are documented.
5. Required sections are documented.
6. Layer convention is documented.
7. Task convention is documented.
8. Cross-link convention is documented.
9. Test plan expectations are documented.
10. Documentation update expectations are documented.
11. Rollback expectations are documented.
12. Future validation targets are documented.
13. Related findings are identified.
14. The file can serve as the template for future work packets.

---

## Rollback Strategy

If the work-packet format proves too heavy:

1. Preserve IDs.
2. Preserve the index.
3. Preserve traceability metadata.
4. Reduce required sections.
5. Convert lower-risk sections to recommended sections.
6. Update this specification.
7. Update future validation rules.

Do not renumber existing work packets.

---

## Risks and Mitigations

### Risk: Work Packets Become Bureaucratic

Mitigation:

Keep work packets implementation-oriented and tied to tests, docs, and acceptance criteria.

### Risk: Work Packets Become Too Large

Mitigation:

Use layers and tasks. Split oversized work into follow-up work packets when necessary.

### Risk: IDs Drift

Mitigation:

Treat IDs as stable. Do not reuse IDs. Validate ID formats later.

### Risk: Docs Drift From Implementation

Mitigation:

Use future `monad docs check`, `monad workpacket validate`, and `monad trace check`.

### Risk: Future Validation Becomes Too Strict Too Early

Mitigation:

Start with warnings. Enforce only after the registries mature.

---

## Definition of Done

WP-0000 is done when:

```text
this file exists
the work-packet index exists
work-packet ID format is defined
metadata standard is defined
status model is defined
required sections are defined
layer/task conventions are defined
cross-link expectations are defined
future validation targets are defined
related findings are identified
```

---

## Follow-Up Work

Immediate follow-up work:

```text
WP-0001: Rust Workspace and CLI Skeleton
WP-0002: Core Workspace Model and Manifest Schema
WP-0003: Filesystem Safety Layer
WP-0004: Plan Diff Apply Engine
WP-0005: Monad Init
WP-0006: Built-In Packs and Templates
WP-0007: Monad Add and Monad Generate
```

Future command work:

```text
cmd:monad workpacket list
cmd:monad workpacket validate
cmd:monad workpacket new --dry-run
cmd:monad workpacket plan
```

---

## Final Rule

A Monad work packet should be specific enough to implement, test, validate, document, and close — but not so heavy that it prevents useful work from happening.


---


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
