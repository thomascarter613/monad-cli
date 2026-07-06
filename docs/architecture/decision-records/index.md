# Architecture Decision Records Index

## Purpose

This directory contains Architecture Decision Records for Monad OS / Monad CLI.

ADRs record significant architectural decisions that shape Monad’s runtime, source-of-truth model, safety model, command surface, documentation model, policy model, AI boundary, hosted boundary, and implementation sequence.

This index is the operational ADR registry.

It exists so humans and future Monad commands can answer:

```text
What decisions have been made?
Which decisions are accepted?
Which decisions are still proposed?
Which requirements does each ADR support?
Which work packets implement each decision?
Which policies enforce each decision?
Which risks does each decision mitigate?
Which ADRs supersede or depend on others?
```

Monad should eventually be able to validate this index through commands such as:

```bash
monad adr list
monad adr validate
monad docs check
monad trace check
monad release readiness
```

---

## ADR Doctrine

Monad should not make major architectural moves by accident.

Any decision that materially affects trust, safety, source of truth, mutation, AI, hosting, policy, extensibility, schemas, or repository governance should be captured in an ADR.

Accepted ADRs are authoritative unless superseded.

Proposed ADRs guide implementation but may still be refined.

Rejected ADRs may be useful when a tempting path should not be revisited casually.

---

## ADR ID Format

ADR IDs use:

```text
ADR-NNNN
```

Examples:

```text
ADR-0001
ADR-0005
ADR-0012
```

ADR filenames should use:

```text
adr-NNNN-kebab-case-title.md
```

Example:

```text
adr-0005-canonical-manifest.md
```

ADR IDs are stable and must not be reused.

If a title changes, the ID remains the same.

---

## ADR Status Values

Allowed ADR statuses:

```text
proposed
accepted
superseded
deprecated
rejected
```

| Status     | Meaning                                                                       |
| ---------- | ----------------------------------------------------------------------------- |
| proposed   | The decision is recommended but not yet final.                                |
| accepted   | The decision is authoritative for current implementation.                     |
| superseded | The decision has been replaced by a later ADR.                                |
| deprecated | The decision is historically relevant but no longer recommended for new work. |
| rejected   | The decision was considered and intentionally not chosen.                     |

---

## ADR Metadata Standard

Each ADR should include the following relationship sections when applicable:

```markdown
## Related Requirements

- FR-NNN
- NFR-NNN

## Related Work Packets

- WP-NNNN

## Related Policies

- POLICY-ID

## Related Findings

- FINDING-ID

## Related Risks

- RISK-NNN

## Supersedes

- None

## Superseded By

- None
```

If a section has no entries, use:

```text
None.
```

Do not silently omit relationship fields once an ADR is normalized.

---

## ADR Summary

| ADR      | Title                                             | Status   | Theme                      | Source File                                                     |
| -------- | ------------------------------------------------- | -------- | -------------------------- | --------------------------------------------------------------- |
| ADR-0001 | Rust Single-Binary Runtime                        | accepted | Runtime                    | `adr-0001-rust-single-binary-runtime.md`                        |
| ADR-0002 | Coordinate Native Tools Instead of Replacing Them | accepted | Native Tooling             | `adr-0002-coordinate-native-tools-instead-of-replacing-them.md` |
| ADR-0003 | Local-First Core                                  | accepted | Runtime / Infrastructure   | `adr-0003-local-first-core.md`                                  |
| ADR-0004 | AI-Native but AI-Optional                         | accepted | AI Boundary                | `adr-0004-ai-native-but-ai-optional.md`                         |
| ADR-0005 | `monad.toml` Is the Canonical Manifest            | accepted | Source of Truth            | `adr-0005-canonical-manifest.md`                                |
| ADR-0006 | Plan-Backed Mutation                              | accepted | Mutation Safety            | `adr-0006-plan-backed-mutation.md`                              |
| ADR-0007 | Modular Rust Workspace                            | proposed | Code Architecture          | `adr-0007-modular-rust-workspace.md`                            |
| ADR-0008 | Lifecycle Graph as Core Model                     | proposed | Graph / Domain Model       | `adr-0008-lifecycle-graph-as-core-model.md`                     |
| ADR-0009 | Documentation-as-Code                             | proposed | Documentation / Governance | `adr-0009-documentation-as-code.md`                             |
| ADR-0010 | Policy-as-Code                                    | proposed | Policy / Governance        | `adr-0010-policy-as-code.md`                                    |
| ADR-0011 | Deterministic Context Before AI Assistance        | proposed | Context / AI Safety        | `adr-0011-deterministic-context-before-ai-assistance.md`        |
| ADR-0012 | Honest Placeholder Commands                       | accepted | CLI Trust                  | `adr-0012-honest-placeholder-commands.md`                       |

---

# ADR Registry

## ADR-0001: Rust Single-Binary Runtime

Status: accepted
Theme: Runtime
Owner Role: Architecture owner
Source File: `docs/architecture/decision-records/adr-0001-rust-single-binary-runtime.md`

### Decision

Monad uses Rust for the core runtime and distributes the primary executable as a single binary named `monad`.

### Related Requirements

* FR-001: Version Reporting
* NFR-002: Deterministic Behavior
* NFR-007: Structured Output

### Related Work Packets

* WP-0001: Rust Workspace and CLI Skeleton
* WP-0020: Command Contract Iteration

### Related Policies

* POLICY-COMMAND-CATALOG

### Related Findings

None.

### Related Risks

* RISK-010: Release Regression
* RISK-011: Schema Breakage

### Supersedes

None.

### Superseded By

None.

---

## ADR-0002: Coordinate Native Tools Instead of Replacing Them

Status: accepted
Theme: Native Tooling
Owner Role: Architecture owner
Source File: `docs/architecture/decision-records/adr-0002-coordinate-native-tools-instead-of-replacing-them.md`

### Decision

Monad coordinates native tools rather than replacing them by default.

Native tools remain authoritative for their domains.

Examples:

* Git remains responsible for version control.
* Cargo remains responsible for Rust builds.
* Bun, npm, and pnpm remain responsible for JavaScript package workflows.
* Moon and Turborepo remain responsible for their task graph behavior.
* CI systems remain responsible for CI execution.

### Related Requirements

* FR-005: Repository Inspection
* FR-007: Doctor Diagnostics

### Related Work Packets

* WP-0008: Inspect, List, Check, Doctor, Config, Version
* WP-0009: Sync, Run, Build, Test, Lint, Format, Clean
* WP-0024: Native Tool Interop Iteration

### Related Policies

None yet.

### Related Findings

* WORKSPACE-NOT-FOUND

### Related Risks

* RISK-007: Native Tool Inconsistency

### Supersedes

None.

### Superseded By

None.

---

## ADR-0003: Local-First Core

Status: accepted
Theme: Runtime / Infrastructure
Owner Role: Architecture owner
Source File: `docs/architecture/decision-records/adr-0003-local-first-core.md`

### Decision

Monad’s core functionality works locally against the repository filesystem.

Core commands should not require:

* hosted backend,
* cloud account,
* external database,
* Kubernetes,
* AI provider,
* telemetry service,
* browser dashboard,
* local daemon.

### Related Requirements

* FR-004: Configuration and Manifest Resolution
* FR-005: Repository Inspection
* FR-007: Doctor Diagnostics
* NFR-001: Local-First Operation
* NFR-002: Deterministic Behavior
* NFR-003: No Network by Default
* NFR-004: No Telemetry by Default
* NFR-006: No Required Database
* NFR-009: Read-Only Safety

### Related Work Packets

* WP-0001: Rust Workspace and CLI Skeleton
* WP-0002: Core Workspace Model and Manifest Schema
* WP-0008: Inspect, List, Check, Doctor, Config, Version
* WP-0012: Context Pack and Handoff

### Related Policies

* POLICY-NO-NETWORK-BY-DEFAULT
* POLICY-NO-TELEMETRY-BY-DEFAULT
* POLICY-AI-OPTIONAL

### Related Findings

* NETWORK-CALL-UNEXPECTED
* TELEMETRY-UNEXPECTED
* AI-REQUIRED-FOR-CORE-COMMAND

### Related Risks

* RISK-006: Hosted Prematurity
* RISK-012: Hidden Network Calls
* RISK-013: Hidden Telemetry

### Supersedes

None.

### Superseded By

None.

---

## ADR-0004: AI-Native but AI-Optional

Status: accepted
Theme: AI Boundary
Owner Role: AI architecture owner
Source File: `docs/architecture/decision-records/adr-0004-ai-native-but-ai-optional.md`

### Decision

Monad is AI-native but AI-optional.

AI may eventually assist with context, explanation, ADR drafting, work-packet drafting, and plan suggestions, but deterministic Monad behavior remains the foundation.

AI must not be required for core value.

### Related Requirements

* FR-009: Context Handoff
* FR-011: Plan Creation
* NFR-003: No Network by Default
* NFR-005: AI Optionality

### Related Work Packets

* WP-0012: Context Pack and Handoff
* WP-0026: Graph and Context Iteration

### Related Policies

* POLICY-AI-OPTIONAL
* POLICY-NO-NETWORK-BY-DEFAULT

### Related Findings

* AI-REQUIRED-FOR-CORE-COMMAND
* NETWORK-CALL-UNEXPECTED

### Related Risks

* RISK-005: AI Overreach
* RISK-012: Hidden Network Calls

### Supersedes

None.

### Superseded By

None.

---

## ADR-0005: `monad.toml` Is the Canonical Manifest

Status: accepted
Theme: Source of Truth
Owner Role: Workspace/config owner
Source File: `docs/architecture/decision-records/adr-0005-canonical-manifest.md`

### Decision

`monad.toml` is the canonical Monad manifest.

`workspace.toml` may exist as a compatibility mirror only.

`monad.lock` records resolved state.

`.monad/` stores local/generated/cache/context/report/plan state and must not become canonical truth.

If `monad.toml` and `workspace.toml` conflict, `monad.toml` wins.

### Related Requirements

* FR-004: Configuration and Manifest Resolution
* FR-006: Baseline Check
* NFR-002: Deterministic Behavior

### Related Work Packets

* WP-0002: Core Workspace Model and Manifest Schema
* WP-0008: Inspect, List, Check, Doctor, Config, Version
* WP-0021: Workspace Model Integrity Iteration

### Related Policies

* POLICY-CANONICAL-MANIFEST

### Related Findings

* MANIFEST-MISSING
* MANIFEST-INVALID-TOML
* MANIFEST-CANONICAL-CONFLICT

### Related Risks

* RISK-002: Source-of-Truth Confusion

### Supersedes

None.

### Superseded By

None.

---

## ADR-0006: Plan-Backed Mutation

Status: accepted
Theme: Mutation Safety
Owner Role: Plan/change owner
Source File: `docs/architecture/decision-records/adr-0006-plan-backed-mutation.md`

### Decision

Repository mutation should be plan-backed by default.

The mature flow is:

```bash
monad plan ...
monad apply plan.json --dry-run
monad apply plan.json --yes
```

Dry-run must not write files.

Approved apply must write only planned operations.

### Related Requirements

* FR-011: Plan Creation
* FR-012: Apply With Approval
* NFR-009: Read-Only Safety
* NFR-010: Plan-Backed Mutation

### Related Work Packets

* WP-0003: Filesystem Safety Layer
* WP-0004: Plan Diff Apply Engine
* WP-0014: Remove, Rename, Move, Migrate, Upgrade
* WP-0022: Plan Diff Apply Safety Iteration

### Related Policies

* POLICY-NO-UNSAFE-MUTATION

### Related Findings

* MUTATION-PLAN-REQUIRED
* PLAN-SCHEMA-INVALID
* APPLY-UNPLANNED-FILE-OP

### Related Risks

* RISK-003: Unsafe Mutation
* RISK-010: Release Regression
* RISK-011: Schema Breakage

### Supersedes

None.

### Superseded By

None.

---

## ADR-0007: Modular Rust Workspace

Status: proposed
Theme: Code Architecture
Owner Role: Architecture owner
Source File: `docs/architecture/decision-records/adr-0007-modular-rust-workspace.md`

### Decision

Monad should use a modular Rust workspace with separate crates for major bounded contexts, but it should avoid premature crate explosion.

Near-term structure may begin with:

```text
monad-cli
monad-core
```

Future crates may include:

```text
monad-config
monad-inspect
monad-graph
monad-context
monad-docs
monad-policy
monad-plans
monad-packs
```

### Related Requirements

* NFR-002: Deterministic Behavior
* NFR-007: Structured Output

### Related Work Packets

* WP-0001: Rust Workspace and CLI Skeleton
* WP-0002: Core Workspace Model and Manifest Schema
* WP-0010: Graph Engine
* WP-0012: Context Pack and Handoff
* WP-0013: Policy and Waiver System

### Related Policies

None yet.

### Related Findings

None yet.

### Related Risks

* RISK-014: Planning and Implementation Drift

### Supersedes

None.

### Superseded By

None.

---

## ADR-0008: Lifecycle Graph as Core Model

Status: proposed
Theme: Graph / Domain Model
Owner Role: Graph owner
Source File: `docs/architecture/decision-records/adr-0008-lifecycle-graph-as-core-model.md`

### Decision

Monad models repository knowledge as a lifecycle graph.

The graph should connect code, docs, ADRs, work packets, policies, tests, releases, context packs, plans, and native tool manifests.

The graph should begin as deterministic local output before it becomes cached, queryable, hosted, or persisted.

### Related Requirements

* FR-005: Repository Inspection
* FR-008: Lifecycle Graph
* NFR-006: No Required Database
* NFR-007: Structured Output

### Related Work Packets

* WP-0010: Graph Engine
* WP-0026: Graph and Context Iteration

### Related Policies

None yet.

### Related Findings

None yet.

### Related Risks

* RISK-011: Schema Breakage
* RISK-014: Planning and Implementation Drift

### Supersedes

None.

### Superseded By

None.

---

## ADR-0009: Documentation-as-Code

Status: proposed
Theme: Documentation / Governance
Owner Role: Documentation/governance owner
Source File: `docs/architecture/decision-records/adr-0009-documentation-as-code.md`

### Decision

Product, architecture, governance, security, operations, ADR, work-packet, roadmap, and reference documentation live in the repository and are validated by Monad.

Documentation is source-of-truth, not decoration.

### Related Requirements

* FR-008: Lifecycle Graph
* FR-010: Documentation Check

### Related Work Packets

* WP-0011: Docs, ADR, and Workpacket Commands
* WP-0025: Governance and Policy Iteration

### Related Policies

* POLICY-DOCS-REQUIRED

### Related Findings

* DOCS-REQUIRED-MISSING

### Related Risks

* RISK-008: Docs Drift
* RISK-014: Planning and Implementation Drift

### Supersedes

None.

### Superseded By

None.

---

## ADR-0010: Policy-as-Code

Status: proposed
Theme: Policy / Governance
Owner Role: Governance/security owner
Source File: `docs/architecture/decision-records/adr-0010-policy-as-code.md`

### Decision

Policies are defined as code or structured repository files and evaluated by Monad.

Early policy behavior may start as built-in Rust checks and Markdown policy docs, then mature toward structured policies, reports, waivers, and enforcement.

### Related Requirements

* FR-006: Baseline Check
* FR-008: Lifecycle Graph
* NFR-010: Plan-Backed Mutation

### Related Work Packets

* WP-0013: Policy and Waiver System
* WP-0025: Governance and Policy Iteration

### Related Policies

* POLICY-CANONICAL-MANIFEST
* POLICY-COMMAND-CATALOG
* POLICY-DOCS-REQUIRED
* POLICY-NO-UNSAFE-MUTATION
* POLICY-SECRET-REDACTION
* POLICY-RELEASE-READINESS

### Related Findings

* MANIFEST-CANONICAL-CONFLICT
* COMMAND-CATALOG-DRIFT
* DOCS-REQUIRED-MISSING
* MUTATION-PLAN-REQUIRED
* CONTEXT-SECRET-RISK
* POLICY-WAIVER-EXPIRED

### Related Risks

* RISK-009: Policy False Positives
* RISK-003: Unsafe Mutation
* RISK-008: Docs Drift

### Supersedes

None.

### Superseded By

None.

---

## ADR-0011: Deterministic Context Before AI Assistance

Status: proposed
Theme: Context / AI Safety
Owner Role: Context/AI workflow owner
Source File: `docs/architecture/decision-records/adr-0011-deterministic-context-before-ai-assistance.md`

### Decision

Monad first generates deterministic context packs and handoffs without AI.

AI assistance may later consume these artifacts, but context generation must work offline and without a provider.

### Related Requirements

* FR-009: Context Handoff
* NFR-002: Deterministic Behavior
* NFR-005: AI Optionality

### Related Work Packets

* WP-0012: Context Pack and Handoff
* WP-0026: Graph and Context Iteration

### Related Policies

* POLICY-SECRET-REDACTION
* POLICY-AI-OPTIONAL
* POLICY-NO-NETWORK-BY-DEFAULT

### Related Findings

* CONTEXT-SECRET-RISK
* AI-REQUIRED-FOR-CORE-COMMAND
* NETWORK-CALL-UNEXPECTED

### Related Risks

* RISK-004: Secret Leakage
* RISK-005: AI Overreach
* RISK-012: Hidden Network Calls

### Supersedes

None.

### Superseded By

None.

---

## ADR-0012: Honest Placeholder Commands

Status: accepted
Theme: CLI Trust
Owner Role: CLI maintainer
Source File: `docs/architecture/decision-records/adr-0012-honest-placeholder-commands.md`

### Decision

Unimplemented, partial, planned, or placeholder commands must be clearly marked as such.

Command metadata should expose:

```text
implemented
status
mutating
plan_backed
supports_dry_run
uses_network
uses_ai
stability
```

Placeholder commands must not pretend to perform real behavior.

### Related Requirements

* FR-001: Version Reporting
* FR-002: Command Catalog
* FR-003: List Commands
* FR-006: Baseline Check
* NFR-008: Stable Exit Codes

### Related Work Packets

* WP-0001: Rust Workspace and CLI Skeleton
* WP-0008: Inspect, List, Check, Doctor, Config, Version
* WP-0020: Command Contract Iteration

### Related Policies

* POLICY-COMMAND-CATALOG
* POLICY-PLACEHOLDER-HONESTY

### Related Findings

* COMMAND-CATALOG-DRIFT
* COMMAND-PLACEHOLDER-MISLEADING

### Related Risks

* RISK-001: Command Catalog Drift

### Supersedes

None.

### Superseded By

None.

---

# ADR-to-Requirement Matrix

| ADR      | Related Requirements                                                         |
| -------- | ---------------------------------------------------------------------------- |
| ADR-0001 | FR-001, NFR-002, NFR-007                                                     |
| ADR-0002 | FR-005, FR-007                                                               |
| ADR-0003 | FR-004, FR-005, FR-007, NFR-001, NFR-002, NFR-003, NFR-004, NFR-006, NFR-009 |
| ADR-0004 | FR-009, FR-011, NFR-003, NFR-005                                             |
| ADR-0005 | FR-004, FR-006, NFR-002                                                      |
| ADR-0006 | FR-011, FR-012, NFR-009, NFR-010                                             |
| ADR-0007 | NFR-002, NFR-007                                                             |
| ADR-0008 | FR-005, FR-008, NFR-006, NFR-007                                             |
| ADR-0009 | FR-008, FR-010                                                               |
| ADR-0010 | FR-006, FR-008, NFR-010                                                      |
| ADR-0011 | FR-009, NFR-002, NFR-005                                                     |
| ADR-0012 | FR-001, FR-002, FR-003, FR-006, NFR-008                                      |

---

# ADR-to-Work-Packet Matrix

| ADR      | Related Work Packets                        |
| -------- | ------------------------------------------- |
| ADR-0001 | WP-0001, WP-0020                            |
| ADR-0002 | WP-0008, WP-0009, WP-0024                   |
| ADR-0003 | WP-0001, WP-0002, WP-0008, WP-0012          |
| ADR-0004 | WP-0012, WP-0026                            |
| ADR-0005 | WP-0002, WP-0008, WP-0021                   |
| ADR-0006 | WP-0003, WP-0004, WP-0014, WP-0022          |
| ADR-0007 | WP-0001, WP-0002, WP-0010, WP-0012, WP-0013 |
| ADR-0008 | WP-0010, WP-0026                            |
| ADR-0009 | WP-0011, WP-0025                            |
| ADR-0010 | WP-0013, WP-0025                            |
| ADR-0011 | WP-0012, WP-0026                            |
| ADR-0012 | WP-0001, WP-0008, WP-0020                   |

---

# ADR-to-Policy Matrix

| ADR      | Related Policies                                                                                                                                      |
| -------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| ADR-0001 | POLICY-COMMAND-CATALOG                                                                                                                                |
| ADR-0002 | None yet                                                                                                                                              |
| ADR-0003 | POLICY-NO-NETWORK-BY-DEFAULT, POLICY-NO-TELEMETRY-BY-DEFAULT, POLICY-AI-OPTIONAL                                                                      |
| ADR-0004 | POLICY-AI-OPTIONAL, POLICY-NO-NETWORK-BY-DEFAULT                                                                                                      |
| ADR-0005 | POLICY-CANONICAL-MANIFEST                                                                                                                             |
| ADR-0006 | POLICY-NO-UNSAFE-MUTATION                                                                                                                             |
| ADR-0007 | None yet                                                                                                                                              |
| ADR-0008 | None yet                                                                                                                                              |
| ADR-0009 | POLICY-DOCS-REQUIRED                                                                                                                                  |
| ADR-0010 | POLICY-CANONICAL-MANIFEST, POLICY-COMMAND-CATALOG, POLICY-DOCS-REQUIRED, POLICY-NO-UNSAFE-MUTATION, POLICY-SECRET-REDACTION, POLICY-RELEASE-READINESS |
| ADR-0011 | POLICY-SECRET-REDACTION, POLICY-AI-OPTIONAL, POLICY-NO-NETWORK-BY-DEFAULT                                                                             |
| ADR-0012 | POLICY-COMMAND-CATALOG, POLICY-PLACEHOLDER-HONESTY                                                                                                    |

---

# ADR-to-Risk Matrix

| ADR      | Related Risks                |
| -------- | ---------------------------- |
| ADR-0001 | RISK-010, RISK-011           |
| ADR-0002 | RISK-007                     |
| ADR-0003 | RISK-006, RISK-012, RISK-013 |
| ADR-0004 | RISK-005, RISK-012           |
| ADR-0005 | RISK-002                     |
| ADR-0006 | RISK-003, RISK-010, RISK-011 |
| ADR-0007 | RISK-014                     |
| ADR-0008 | RISK-011, RISK-014           |
| ADR-0009 | RISK-008, RISK-014           |
| ADR-0010 | RISK-003, RISK-008, RISK-009 |
| ADR-0011 | RISK-004, RISK-005, RISK-012 |
| ADR-0012 | RISK-001                     |

---

# Future ADR Candidates

The following ADRs may be needed later.

| Candidate | Proposed Title                                    | Reason                                                                                                      |
| --------- | ------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| ADR-0013  | Versioned Machine-Readable Output Schemas         | JSON output, findings, graph reports, plans, apply reports, and policy reports become automation contracts. |
| ADR-0014  | Stable CLI Exit Code Taxonomy                     | CI integration requires stable exit behavior.                                                               |
| ADR-0015  | Local Graph Cache Is Rebuildable Generated State  | Graph cache must not become hidden canonical truth.                                                         |
| ADR-0016  | Pack and Template Trust Model                     | Packs/templates affect repository mutation and require trust controls.                                      |
| ADR-0017  | Plugin Execution and Trust Boundary               | Plugin execution is higher-risk than templates.                                                             |
| ADR-0018  | Hosted Control Plane Is Optional Projection Layer | Hosted features must not undermine local-first operation.                                                   |
| ADR-0019  | No Telemetry by Default                           | Telemetry has trust and privacy implications.                                                               |
| ADR-0020  | AI Provider Port and Noop Adapter                 | AI support must remain optional and testable without live providers.                                        |

---

# Validation Targets

Future `monad adr validate` should eventually check:

1. ADR filenames match ADR IDs.
2. ADR index lists all ADR files.
3. ADR status is one of the allowed values.
4. Accepted ADRs have related requirements.
5. Accepted ADRs have related work packets or an explanation.
6. Superseded ADRs identify their replacement.
7. Referenced requirement IDs exist.
8. Referenced work-packet IDs exist.
9. Referenced policy IDs exist.
10. Referenced risk IDs exist.
11. ADRs do not silently contradict accepted ADRs.
12. Proposed ADRs are clearly marked as proposed.

Initial validation should warn before it fails.

---

## Final Rule

An ADR should make Monad’s architecture more trustworthy by making important decisions explicit, traceable, and reviewable.

If a decision affects local-first operation, source of truth, mutation safety, AI optionality, hosted boundaries, policy, schemas, command trust, or extensibility, it belongs in an ADR.
