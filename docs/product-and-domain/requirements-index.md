# Monad Requirements Index

## Purpose

This document is the operational requirements registry for Monad OS / Monad CLI.

It normalizes the core functional and non-functional requirements into stable IDs so Monad’s planning, architecture, work packets, BDD scenarios, policies, findings, risks, tests, and release evidence can be cross-linked.

This file is intentionally more concise than the full Product Requirements Document.

The full requirements narrative lives in:

```text id="jbitui"
docs/product/prd.md
docs/planning/0003-product-requirements-document.md
```

This index exists so future Monad commands can validate and trace requirements.

---

## Requirement Model

Each requirement should have:

```text id="cyq210"
stable ID
title
type
status
description
related user needs
related ADRs
related work packets
related BDD scenarios
related policies
related findings
related risks
source docs
```

The active requirement ID formats are:

```text id="ez7vaj"
FR-NNN   Functional Requirement
NFR-NNN  Non-Functional Requirement
```

IDs are stable. Titles may change, but IDs should not.

---

## Requirement Status Values

Allowed requirement statuses:

```text id="gmo4f9"
draft
accepted
planned
implemented
validated
deprecated
```

### Status Meaning

| Status      | Meaning                                                                                  |
| ----------- | ---------------------------------------------------------------------------------------- |
| Draft       | The requirement is being shaped and is not authoritative yet.                            |
| Accepted    | The requirement is part of the product baseline.                                         |
| Planned     | The requirement is accepted and scheduled for implementation.                            |
| Implemented | Implementation exists, but validation may not be complete.                               |
| Validated   | Implementation, tests, docs, and evidence satisfy the requirement.                       |
| Deprecated  | The requirement is no longer recommended for new work but remains historically reserved. |

---

## Requirement Priority Values

Recommended priority values:

```text id="zsbtb0"
P0
P1
P2
P3
```

| Priority | Meaning                                                      |
| -------- | ------------------------------------------------------------ |
| P0       | Required for product trust or foundational correctness.      |
| P1       | Required for credible v1 usefulness.                         |
| P2       | Important but can follow the earliest implementation layers. |
| P3       | Future or optional enhancement.                              |

---

## Functional Requirements Summary

| ID     | Title                                 | Status   | Priority | Primary Command / Surface   |
| ------ | ------------------------------------- | -------- | -------- | --------------------------- |
| FR-001 | Version Reporting                     | Accepted | P0       | `cmd:monad version`         |
| FR-002 | Command Catalog                       | Accepted | P0       | Command catalog             |
| FR-003 | List Commands                         | Accepted | P0       | `cmd:monad list`            |
| FR-004 | Configuration and Manifest Resolution | Accepted | P0       | `cmd:monad config`          |
| FR-005 | Repository Inspection                 | Accepted | P0       | `cmd:monad inspect`         |
| FR-006 | Baseline Check                        | Accepted | P0       | `cmd:monad check`           |
| FR-007 | Doctor Diagnostics                    | Accepted | P1       | `cmd:monad doctor`          |
| FR-008 | Lifecycle Graph                       | Accepted | P1       | `cmd:monad graph`           |
| FR-009 | Context Handoff                       | Accepted | P1       | `cmd:monad context handoff` |
| FR-010 | Documentation Check                   | Accepted | P0       | `cmd:monad docs check`      |
| FR-011 | Plan Creation                         | Accepted | P0       | `cmd:monad plan`            |
| FR-012 | Apply With Approval                   | Accepted | P0       | `cmd:monad apply`           |

---

## Non-Functional Requirements Summary

| ID      | Title                   | Status   | Priority | Category              |
| ------- | ----------------------- | -------- | -------- | --------------------- |
| NFR-001 | Local-First Operation   | Accepted | P0       | Runtime               |
| NFR-002 | Deterministic Behavior  | Accepted | P0       | Correctness           |
| NFR-003 | No Network by Default   | Accepted | P0       | Security / Privacy    |
| NFR-004 | No Telemetry by Default | Accepted | P0       | Security / Privacy    |
| NFR-005 | AI Optionality          | Accepted | P0       | AI / Product Boundary |
| NFR-006 | No Required Database    | Accepted | P0       | Infrastructure        |
| NFR-007 | Structured Output       | Accepted | P1       | Automation            |
| NFR-008 | Stable Exit Codes       | Accepted | P1       | Automation / CI       |
| NFR-009 | Read-Only Safety        | Accepted | P0       | Safety                |
| NFR-010 | Plan-Backed Mutation    | Accepted | P0       | Safety / Governance   |

---

# Functional Requirements

## FR-001: Version Reporting

Status: Accepted
Priority: P0
Primary Surface: `cmd:monad version`
Owner Role: CLI maintainer
Source Docs: `docs/product/prd.md`, `docs/roadmap/roadmap.md`

### Description

Monad must provide a version command that reports the current CLI version.

This command should work outside a Monad repository and should not require repository discovery.

### User Need

* UN-003: Understand command surface

### Related ADRs

* ADR-0001: Rust Single-Binary Runtime
* ADR-0012: Honest Placeholder Commands

### Related Work Packets

* WP-0001: Rust Workspace and CLI Skeleton
* WP-0008: Inspect, List, Check, Doctor, Config, Version

### Related BDD Scenarios

* BDD-VERSION-001: Version command reports version
* BDD-VERSION-002: Version command works outside a repository

### Related Tests

* CLI smoke test
* Snapshot test, if output becomes structured

### Related Policies

* POLICY-COMMAND-CATALOG
* POLICY-PLACEHOLDER-HONESTY

### Related Findings

None yet.

### Related Risks

* RISK-001: Command Catalog Drift

### Acceptance Criteria

1. `monad version` exits successfully.
2. The command reports the package/runtime version.
3. The command works outside a repository.
4. The command performs no file mutation.
5. The command performs no network calls.
6. The command does not require AI configuration.

---

## FR-002: Command Catalog

Status: Accepted
Priority: P0
Primary Surface: Command catalog
Owner Role: CLI maintainer
Source Docs: `docs/product/prd.md`, `docs/engineering/command-catalog.md`

### Description

Monad must maintain a command catalog with metadata for every known command.

The command catalog is the source of command metadata, including status, category, mutation behavior, dry-run support, AI usage, network usage, and stability.

### User Need

* UN-003: Understand command surface

### Related ADRs

* ADR-0012: Honest Placeholder Commands

### Related Work Packets

* WP-0001: Rust Workspace and CLI Skeleton
* WP-0020: Command Contract Iteration

### Related BDD Scenarios

* BDD-CATALOG-001: Command catalog lists known commands
* BDD-CATALOG-002: Command catalog marks planned commands
* BDD-CATALOG-003: Mutating commands declare mutation metadata
* BDD-CATALOG-004: Placeholder commands are honest

### Related Tests

* Command catalog unit tests
* Command catalog contract tests
* Snapshot tests

### Related Policies

* POLICY-COMMAND-CATALOG
* POLICY-PLACEHOLDER-HONESTY

### Related Findings

* COMMAND-CATALOG-DRIFT
* COMMAND-PLACEHOLDER-MISLEADING

### Related Risks

* RISK-001: Command Catalog Drift

### Acceptance Criteria

1. Every known command has catalog metadata.
2. Implemented commands are marked implemented.
3. Planned commands are marked planned or placeholder.
4. Mutating commands declare mutation behavior.
5. Commands that support dry-run declare it.
6. Commands that use network or AI declare it.
7. The catalog can be tested against the CLI command tree.

---

## FR-003: List Commands

Status: Accepted
Priority: P0
Primary Surface: `cmd:monad list`
Owner Role: CLI maintainer
Source Docs: `docs/product/prd.md`, `docs/user-guide/commands.md`

### Description

Monad must provide a command that lists implemented and planned commands in a way that is honest and useful.

### User Need

* UN-003: Understand command surface

### Related ADRs

* ADR-0012: Honest Placeholder Commands

### Related Work Packets

* WP-0001: Rust Workspace and CLI Skeleton
* WP-0008: Inspect, List, Check, Doctor, Config, Version
* WP-0020: Command Contract Iteration

### Related BDD Scenarios

* BDD-CATALOG-005: List command shows implemented commands
* BDD-CATALOG-006: List command marks planned commands
* BDD-CATALOG-007: List command does not imply placeholders are implemented

### Related Tests

* CLI smoke test
* Snapshot test
* Command catalog contract test

### Related Policies

* POLICY-COMMAND-CATALOG
* POLICY-PLACEHOLDER-HONESTY

### Related Findings

* COMMAND-CATALOG-DRIFT
* COMMAND-PLACEHOLDER-MISLEADING

### Related Risks

* RISK-001: Command Catalog Drift

### Acceptance Criteria

1. `monad list` exits successfully.
2. It lists known command surfaces.
3. It distinguishes implemented, partial, planned, and placeholder commands.
4. It does not misrepresent unimplemented behavior.
5. It performs no file mutation.
6. It performs no network calls.

---

## FR-004: Configuration and Manifest Resolution

Status: Accepted
Priority: P0
Primary Surface: `cmd:monad config`
Owner Role: Workspace/config maintainer
Source Docs: `docs/product/prd.md`, `docs/reference/manifest.md`

### Description

Monad must resolve repository configuration using `monad.toml` as the canonical manifest.

`workspace.toml` may exist as a compatibility mirror only.

If `monad.toml` and `workspace.toml` conflict, `monad.toml` wins and the conflict should be reported.

### User Need

* UN-002: Validate source-of-truth consistency

### Related ADRs

* ADR-0003: Local-First Core
* ADR-0005: `monad.toml` Is the Canonical Manifest

### Related Work Packets

* WP-0002: Core Workspace Model and Manifest Schema
* WP-0008: Inspect, List, Check, Doctor, Config, Version
* WP-0021: Workspace Model Integrity Iteration

### Related BDD Scenarios

* BDD-MANIFEST-001: `monad.toml` is canonical
* BDD-MANIFEST-002: `workspace.toml` conflict is reported
* BDD-MANIFEST-003: Missing manifest is diagnosed
* BDD-CONFIG-001: Config command explains source of truth

### Related Tests

* Manifest unit tests
* Fixture integration tests
* Doctor diagnostic tests
* Snapshot tests

### Related Policies

* POLICY-CANONICAL-MANIFEST

### Related Findings

* MANIFEST-MISSING
* MANIFEST-INVALID-TOML
* MANIFEST-CANONICAL-CONFLICT

### Related Risks

* RISK-002: Source-of-Truth Confusion

### Acceptance Criteria

1. `monad.toml` is treated as canonical.
2. `workspace.toml` is treated as compatibility mirror only.
3. Manifest conflicts are reported.
4. Invalid manifests produce actionable findings.
5. Missing manifests are explained clearly.
6. Config commands are read-only unless explicitly generating a plan.

---

## FR-005: Repository Inspection

Status: Accepted
Priority: P0
Primary Surface: `cmd:monad inspect`
Owner Role: Repository inspection owner
Source Docs: `docs/product/prd.md`, `docs/user-guide/commands.md`

### Description

Monad must inspect a repository and report detected structure, manifests, docs, governance artifacts, project areas, and native tool presence without mutating files.

### User Need

* UN-001: Inspect repository structure

### Related ADRs

* ADR-0002: Coordinate Native Tools Instead of Replacing Them
* ADR-0003: Local-First Core
* ADR-0008: Lifecycle Graph as Core Model

### Related Work Packets

* WP-0008: Inspect, List, Check, Doctor, Config, Version
* WP-0024: Native Tool Interop Iteration

### Related BDD Scenarios

* BDD-INSPECT-001: Inspect reports repository structure
* BDD-INSPECT-002: Inspect detects native manifests
* BDD-INSPECT-003: Inspect is read-only
* BDD-NATIVE-001: Native tools are detected but not replaced

### Related Tests

* Fixture integration tests
* Read-only mutation safety tests
* Snapshot tests
* Native manifest detection tests

### Related Policies

* POLICY-NO-UNSAFE-MUTATION

### Related Findings

* WORKSPACE-NOT-FOUND

### Related Risks

* RISK-007: Native Tool Inconsistency
* RISK-003: Unsafe Mutation

### Acceptance Criteria

1. `monad inspect` reports repository structure.
2. It detects known native manifests where supported.
3. It reports docs/governance artifacts where supported.
4. It performs no canonical file mutation.
5. It works without network.
6. It works without AI.
7. It produces deterministic output for stable fixtures.

---

## FR-006: Baseline Check

Status: Accepted
Priority: P0
Primary Surface: `cmd:monad check`
Owner Role: Validation/check owner
Source Docs: `docs/product/prd.md`, `docs/engineering/testing-strategy.md`

### Description

Monad must validate baseline repository invariants and report findings.

Checks should begin with source-of-truth, command catalog, documentation presence, and safety-related invariants, then grow into policy-backed validation.

### User Need

* UN-002: Validate source-of-truth consistency

### Related ADRs

* ADR-0005: `monad.toml` Is the Canonical Manifest
* ADR-0010: Policy-as-Code
* ADR-0012: Honest Placeholder Commands

### Related Work Packets

* WP-0008: Inspect, List, Check, Doctor, Config, Version
* WP-0013: Policy and Waiver System
* WP-0025: Governance and Policy Iteration

### Related BDD Scenarios

* BDD-CHECK-001: Check passes valid repository
* BDD-CHECK-002: Check reports invalid repository
* BDD-CHECK-003: Check CI mode exits nonzero on blocking findings

### Related Tests

* Check fixture tests
* CLI integration tests
* Findings schema tests
* Exit code tests

### Related Policies

* POLICY-CANONICAL-MANIFEST
* POLICY-COMMAND-CATALOG
* POLICY-DOCS-REQUIRED
* POLICY-PLACEHOLDER-HONESTY

### Related Findings

* MANIFEST-CANONICAL-CONFLICT
* COMMAND-CATALOG-DRIFT
* DOCS-REQUIRED-MISSING
* COMMAND-PLACEHOLDER-MISLEADING

### Related Risks

* RISK-001: Command Catalog Drift
* RISK-002: Source-of-Truth Confusion
* RISK-008: Docs Drift

### Acceptance Criteria

1. `monad check` reports baseline findings.
2. Valid fixture repositories pass.
3. Invalid fixture repositories produce expected findings.
4. CI mode can return nonzero for blocking findings.
5. Findings include remediation where practical.
6. Check behavior is deterministic.

---

## FR-007: Doctor Diagnostics

Status: Accepted
Priority: P1
Primary Surface: `cmd:monad doctor`
Owner Role: Diagnostics owner
Source Docs: `docs/product/prd.md`, `docs/operations/operational-model.md`

### Description

Monad must provide diagnostics and remediation hints for repository setup, source-of-truth conflicts, missing docs, command catalog drift, native tool availability, and other operational issues.

### User Need

* UN-006: Explain and remediate repository problems

### Related ADRs

* ADR-0002: Coordinate Native Tools Instead of Replacing Them
* ADR-0003: Local-First Core
* ADR-0005: `monad.toml` Is the Canonical Manifest

### Related Work Packets

* WP-0008: Inspect, List, Check, Doctor, Config, Version
* WP-0027: UX and Diagnostics Iteration

### Related BDD Scenarios

* BDD-DOCTOR-001: Doctor reports actionable diagnostics
* BDD-DOCTOR-002: Doctor reports manifest conflict remediation
* BDD-DOCTOR-003: Doctor handles missing optional native tools

### Related Tests

* Doctor fixture tests
* Snapshot tests
* Native tool missing tests

### Related Policies

* POLICY-CANONICAL-MANIFEST
* POLICY-COMMAND-CATALOG
* POLICY-DOCS-REQUIRED

### Related Findings

* WORKSPACE-NOT-FOUND
* MANIFEST-CANONICAL-CONFLICT
* COMMAND-CATALOG-DRIFT
* DOCS-REQUIRED-MISSING

### Related Risks

* RISK-002: Source-of-Truth Confusion
* RISK-007: Native Tool Inconsistency
* RISK-008: Docs Drift

### Acceptance Criteria

1. `monad doctor` reports actionable issues.
2. Diagnostics include remediation hints.
3. Missing optional native tools are handled gracefully.
4. Doctor does not mutate files.
5. Doctor works without network.
6. Doctor output is suitable for support workflows.

---

## FR-008: Lifecycle Graph

Status: Accepted
Priority: P1
Primary Surface: `cmd:monad graph`
Owner Role: Graph owner
Source Docs: `docs/product/prd.md`, `docs/reference/graph-schema.md`

### Description

Monad must represent repository lifecycle artifacts as a graph.

The graph should connect repository structure, docs, ADRs, work packets, policies, commands, plans, context artifacts, tests, and releases over time.

### User Need

* UN-007: Understand repository relationships and traceability

### Related ADRs

* ADR-0008: Lifecycle Graph as Core Model
* ADR-0009: Documentation-as-Code
* ADR-0010: Policy-as-Code

### Related Work Packets

* WP-0010: Graph Engine
* WP-0026: Graph and Context Iteration

### Related BDD Scenarios

* BDD-GRAPH-001: Graph emits repository lifecycle nodes
* BDD-GRAPH-002: Graph edges reference existing nodes
* BDD-GRAPH-003: Mermaid graph output is deterministic
* BDD-GRAPH-004: Graph JSON validates schema

### Related Tests

* Graph invariant tests
* Snapshot tests
* Schema tests
* Fixture tests

### Related Policies

None yet.

### Related Findings

None yet.

### Related Risks

* RISK-011: Schema Breakage
* RISK-014: Planning and Implementation Drift

### Acceptance Criteria

1. `monad graph` emits a lifecycle graph representation.
2. Early graph output is deterministic.
3. Graph nodes and edges are internally consistent.
4. Mermaid/text output is supported early.
5. JSON output is added when schema is stable.
6. Graph generation does not require a graph database.

---

## FR-009: Context Handoff

Status: Accepted
Priority: P1
Primary Surface: `cmd:monad context handoff`
Owner Role: Context/AI workflow owner
Source Docs: `docs/product/prd.md`, `docs/user-guide/context-handoff.md`

### Description

Monad must generate deterministic context handoff artifacts for humans and AI assistants.

Context handoff must work without AI and must exclude likely secrets by default.

### User Need

* UN-004: Generate AI-safe handoff context

### Related ADRs

* ADR-0004: AI-Native but AI-Optional
* ADR-0011: Deterministic Context Before AI Assistance

### Related Work Packets

* WP-0012: Context Pack and Handoff
* WP-0026: Graph and Context Iteration

### Related BDD Scenarios

* BDD-CONTEXT-001: Context handoff works without AI
* BDD-CONTEXT-SECRET-001: Context excludes likely secrets
* BDD-AI-OPTIONAL-001: Core context workflow does not require AI provider

### Related Tests

* Context fixture tests
* Redaction tests
* Snapshot tests
* No-AI tests
* No-network tests

### Related Policies

* POLICY-SECRET-REDACTION
* POLICY-AI-OPTIONAL

### Related Findings

* CONTEXT-SECRET-RISK
* AI-REQUIRED-FOR-CORE-COMMAND

### Related Risks

* RISK-004: Secret Leakage
* RISK-005: AI Overreach

### Acceptance Criteria

1. Context handoff works without AI.
2. Context handoff works without network.
3. Likely secret files are excluded by default.
4. Included/excluded context is reported where practical.
5. Output is deterministic for stable fixtures.
6. AI-generated summaries are not required for core value.

---

## FR-010: Documentation Check

Status: Accepted
Priority: P0
Primary Surface: `cmd:monad docs check`
Owner Role: Documentation/governance owner
Source Docs: `docs/product/prd.md`, `docs/governance/governance-model.md`

### Description

Monad must validate repository documentation presence, structure, and consistency.

Early checks should validate required docs and known source-of-truth documentation. Later checks may validate ADRs, work packets, traceability, policy references, and stale documentation.

### User Need

* UN-008: Validate documentation and governance artifacts

### Related ADRs

* ADR-0009: Documentation-as-Code

### Related Work Packets

* WP-0011: Docs, ADR, and Workpacket Commands
* WP-0025: Governance and Policy Iteration

### Related BDD Scenarios

* BDD-DOCS-001: Docs check reports missing required docs
* BDD-DOCS-002: Docs check validates planning index
* BDD-DOCS-003: Docs check warns about broken cross-links

### Related Tests

* Docs fixture tests
* Snapshot tests
* Future cross-link validation tests

### Related Policies

* POLICY-DOCS-REQUIRED

### Related Findings

* DOCS-REQUIRED-MISSING

### Related Risks

* RISK-008: Docs Drift
* RISK-014: Planning and Implementation Drift

### Acceptance Criteria

1. Required docs can be checked.
2. Missing docs produce findings.
3. Findings include remediation hints.
4. The command is read-only.
5. Initial checks may warn before strict enforcement.
6. Future checks can validate IDs and cross-links.

---

## FR-011: Plan Creation

Status: Accepted
Priority: P0
Primary Surface: `cmd:monad plan`
Owner Role: Plan/change owner
Source Docs: `docs/product/prd.md`, `docs/reference/plan-schema.md`

### Description

Monad must create reviewable plans before repository mutation.

A plan should describe intended file operations, risks, policy gates, and expected effects before any mutation occurs.

### User Need

* UN-005: Plan before mutation

### Related ADRs

* ADR-0006: Plan-Backed Mutation
* ADR-0004: AI-Native but AI-Optional

### Related Work Packets

* WP-0004: Plan Diff Apply Engine
* WP-0022: Plan Diff Apply Safety Iteration

### Related BDD Scenarios

* BDD-PLAN-001: Plan creation produces reviewable plan
* BDD-PLAN-002: Plan creation does not modify files
* BDD-PLAN-DRYRUN-001: Dry-run can evaluate a plan without writing

### Related Tests

* Plan schema tests
* Fixture tests
* Mutation safety tests
* Snapshot tests

### Related Policies

* POLICY-NO-UNSAFE-MUTATION
* POLICY-RELEASE-READINESS

### Related Findings

* MUTATION-PLAN-REQUIRED
* PLAN-SCHEMA-INVALID

### Related Risks

* RISK-003: Unsafe Mutation
* RISK-011: Schema Breakage

### Acceptance Criteria

1. Plan creation does not modify files.
2. Plans list intended operations.
3. Plans include schema/version metadata when stabilized.
4. Plans can be validated before apply.
5. Plans can be inspected by humans.
6. AI-suggested changes become plans before mutation.

---

## FR-012: Apply With Approval

Status: Accepted
Priority: P0
Primary Surface: `cmd:monad apply`
Owner Role: Plan/change owner
Source Docs: `docs/product/prd.md`, `docs/reference/plan-schema.md`

### Description

Monad must apply repository changes only through controlled approval.

Dry-run must write nothing.

Approved apply must write only operations listed in a valid plan.

### User Need

* UN-005: Plan before mutation

### Related ADRs

* ADR-0006: Plan-Backed Mutation

### Related Work Packets

* WP-0004: Plan Diff Apply Engine
* WP-0022: Plan Diff Apply Safety Iteration

### Related BDD Scenarios

* BDD-APPLY-001: Apply requires valid plan
* BDD-APPLY-002: Dry-run writes nothing
* BDD-APPLY-SAFE-001: Apply writes only planned operations
* BDD-APPLY-SAFE-002: Unsafe mutation is blocked

### Related Tests

* Dry-run mutation tests
* Apply contract tests
* Filesystem mutation tests
* Apply report tests

### Related Policies

* POLICY-NO-UNSAFE-MUTATION

### Related Findings

* MUTATION-PLAN-REQUIRED
* PLAN-SCHEMA-INVALID
* APPLY-UNPLANNED-FILE-OP

### Related Risks

* RISK-003: Unsafe Mutation
* RISK-010: Release Regression

### Acceptance Criteria

1. Invalid plans are rejected.
2. Dry-run writes nothing.
3. Approved apply writes only planned operations.
4. Unplanned file operations are blocked.
5. Apply produces an inspectable report.
6. Destructive operations require explicit approval.
7. Failed apply reports partial state where applicable.

---

# Non-Functional Requirements

## NFR-001: Local-First Operation

Status: Accepted
Priority: P0
Category: Runtime
Owner Role: Architecture owner
Source Docs: `docs/architecture/overview.md`, `docs/planning/0010-infra-and-cloud-agnostic-deployment-plan.md`

### Description

Monad core functionality must work locally against the repository filesystem.

Core value must not require a hosted backend, cloud account, external database, Kubernetes, AI provider, telemetry service, browser dashboard, or local daemon.

### Related ADRs

* ADR-0003: Local-First Core

### Related Work Packets

* WP-0001: Rust Workspace and CLI Skeleton
* WP-0002: Core Workspace Model and Manifest Schema
* WP-0008: Inspect, List, Check, Doctor, Config, Version

### Related Policies

* POLICY-NO-NETWORK-BY-DEFAULT
* POLICY-AI-OPTIONAL

### Related Risks

* RISK-006: Hosted Prematurity
* RISK-012: Hidden Network Calls

### Acceptance Criteria

1. Core commands work without a hosted service.
2. Core commands work without an AI provider.
3. Core commands work without a database.
4. Core commands work offline.
5. Hosted features remain optional and future.

---

## NFR-002: Deterministic Behavior

Status: Accepted
Priority: P0
Category: Correctness
Owner Role: Architecture owner
Source Docs: `docs/architecture/overview.md`, `docs/engineering/testing-strategy.md`

### Description

Monad core behavior should be deterministic for stable inputs.

Repeated runs against the same fixture should produce the same meaningful result.

### Related ADRs

* ADR-0001: Rust Single-Binary Runtime
* ADR-0003: Local-First Core
* ADR-0011: Deterministic Context Before AI Assistance

### Related Work Packets

* WP-0001: Rust Workspace and CLI Skeleton
* WP-0008: Inspect, List, Check, Doctor, Config, Version
* WP-0010: Graph Engine
* WP-0012: Context Pack and Handoff

### Related Risks

* RISK-011: Schema Breakage
* RISK-014: Planning and Implementation Drift

### Acceptance Criteria

1. Stable fixture inputs produce stable outputs.
2. Snapshot tests can protect expected output.
3. AI is not required for deterministic behavior.
4. Network state does not affect core command correctness.

---

## NFR-003: No Network by Default

Status: Accepted
Priority: P0
Category: Security / Privacy
Owner Role: Security owner
Source Docs: `docs/security/security-model.md`

### Description

Core Monad commands should not make network calls by default.

Any future network-enabled behavior must be explicit, documented, and test-backed.

### Related ADRs

* ADR-0003: Local-First Core
* ADR-0004: AI-Native but AI-Optional

### Related Work Packets

* WP-0017: CI, Security, and Quality Gates
* WP-0024: Native Tool Interop Iteration

### Related Policies

* POLICY-NO-NETWORK-BY-DEFAULT

### Related Findings

* NETWORK-CALL-UNEXPECTED

### Related Risks

* RISK-012: Hidden Network Calls

### Acceptance Criteria

1. Core commands do not call network by default.
2. Network behavior, if introduced, is explicit.
3. Network behavior is documented.
4. Tests or review gates protect the no-network default.

---

## NFR-004: No Telemetry by Default

Status: Accepted
Priority: P0
Category: Security / Privacy
Owner Role: Security owner
Source Docs: `docs/security/security-model.md`

### Description

Monad should not send telemetry by default.

Telemetry, if ever introduced, must be explicit, opt-in, documented, and governed.

### Related ADRs

* ADR-0003: Local-First Core

### Related Work Packets

* WP-0017: CI, Security, and Quality Gates

### Related Policies

* POLICY-NO-TELEMETRY-BY-DEFAULT

### Related Findings

* TELEMETRY-UNEXPECTED

### Related Risks

* RISK-013: Hidden Telemetry

### Acceptance Criteria

1. No telemetry is sent by default.
2. Telemetry is not required for core value.
3. Any future telemetry is opt-in and documented.
4. Security review covers telemetry changes.

---

## NFR-005: AI Optionality

Status: Accepted
Priority: P0
Category: AI / Product Boundary
Owner Role: AI architecture owner
Source Docs: `docs/architecture/ai-architecture.md`

### Description

Monad must remain useful without any AI provider.

AI may assist later, but AI must not be required for core validation, inspection, graphing, documentation checks, policy checks, context handoff, plan validation, or apply safety.

### Related ADRs

* ADR-0004: AI-Native but AI-Optional
* ADR-0011: Deterministic Context Before AI Assistance

### Related Work Packets

* WP-0012: Context Pack and Handoff
* WP-0026: Graph and Context Iteration

### Related Policies

* POLICY-AI-OPTIONAL

### Related Findings

* AI-REQUIRED-FOR-CORE-COMMAND

### Related Risks

* RISK-005: AI Overreach

### Acceptance Criteria

1. Core commands work without AI configuration.
2. AI suggestions do not apply automatically.
3. AI output is advisory unless converted into a reviewed plan.
4. No provider lock-in is introduced.

---

## NFR-006: No Required Database

Status: Accepted
Priority: P0
Category: Infrastructure
Owner Role: Architecture owner
Source Docs: `docs/architecture/data-architecture.md`

### Description

Monad core functionality should not require a database.

Local files, manifests, lockfiles, generated reports, and optional caches should be sufficient for core operation.

### Related ADRs

* ADR-0003: Local-First Core
* ADR-0008: Lifecycle Graph as Core Model

### Related Work Packets

* WP-0002: Core Workspace Model and Manifest Schema
* WP-0010: Graph Engine

### Related Risks

* RISK-006: Hosted Prematurity

### Acceptance Criteria

1. Core commands work without a database.
2. Graph output does not require a graph database.
3. Local caches are rebuildable generated state.
4. Hosted persistence remains optional and future.

---

## NFR-007: Structured Output

Status: Accepted
Priority: P1
Category: Automation
Owner Role: Output/schema owner
Source Docs: `docs/engineering/output-formats.md`

### Description

Monad should support structured output for automation, CI, future dashboards, and release evidence.

Text output may come first, but stable JSON should exist for important reports over time.

### Related ADRs

* ADR-0001: Rust Single-Binary Runtime
* ADR-0008: Lifecycle Graph as Core Model

### Related Work Packets

* WP-0008: Inspect, List, Check, Doctor, Config, Version
* WP-0010: Graph Engine
* WP-0015: Release Commands

### Related Risks

* RISK-011: Schema Breakage

### Acceptance Criteria

1. Important reports can eventually emit JSON.
2. JSON schemas are versioned when stable.
3. Structured output is tested.
4. Human-readable output remains useful.

---

## NFR-008: Stable Exit Codes

Status: Accepted
Priority: P1
Category: Automation / CI
Owner Role: CLI/output owner
Source Docs: `docs/reference/exit-codes.md`

### Description

Monad should use stable exit codes so scripts and CI systems can understand command outcomes.

### Related ADRs

* ADR-0012: Honest Placeholder Commands

### Related Work Packets

* WP-0008: Inspect, List, Check, Doctor, Config, Version
* WP-0017: CI, Security, and Quality Gates

### Related Risks

* RISK-010: Release Regression

### Acceptance Criteria

1. Successful commands exit `0`.
2. Usage errors have documented behavior.
3. Blocking validation failures can exit nonzero.
4. CI mode is deterministic and non-interactive.
5. Exit code behavior is documented and tested.

---

## NFR-009: Read-Only Safety

Status: Accepted
Priority: P0
Category: Safety
Owner Role: Safety/test owner
Source Docs: `docs/engineering/testing-strategy.md`, `docs/security/security-model.md`

### Description

Read-only commands must not create, modify, or delete canonical repository files.

If a read-only command writes optional reports, it must do so only through explicit output configuration and should not modify canonical source files.

### Related ADRs

* ADR-0003: Local-First Core
* ADR-0006: Plan-Backed Mutation

### Related Work Packets

* WP-0003: Filesystem Safety Layer
* WP-0008: Inspect, List, Check, Doctor, Config, Version

### Related Policies

* POLICY-NO-UNSAFE-MUTATION

### Related Risks

* RISK-003: Unsafe Mutation

### Acceptance Criteria

1. Read-only commands do not mutate canonical files.
2. Mutation safety tests exist for read-only commands.
3. Generated outputs are explicit.
4. Accidental writes are treated as defects.

---

## NFR-010: Plan-Backed Mutation

Status: Accepted
Priority: P0
Category: Safety / Governance
Owner Role: Plan/change owner
Source Docs: `docs/reference/plan-schema.md`, `docs/security/security-model.md`

### Description

Risky repository mutation must go through a plan/apply model.

The mature flow is:

```bash id="yav7sj"
monad plan ...
monad apply plan.json --dry-run
monad apply plan.json --yes
```

### Related ADRs

* ADR-0006: Plan-Backed Mutation

### Related Work Packets

* WP-0004: Plan Diff Apply Engine
* WP-0022: Plan Diff Apply Safety Iteration

### Related Policies

* POLICY-NO-UNSAFE-MUTATION

### Related Findings

* MUTATION-PLAN-REQUIRED
* APPLY-UNPLANNED-FILE-OP

### Related Risks

* RISK-003: Unsafe Mutation
* RISK-010: Release Regression

### Acceptance Criteria

1. Plan creation precedes risky mutation.
2. Dry-run writes nothing.
3. Apply writes only planned operations.
4. Unsafe operations are blocked.
5. Apply reports are produced where relevant.
6. AI-suggested changes must become reviewable plans before mutation.

---

# Requirement-to-ADR Matrix

| Requirement | Related ADRs                 |
| ----------- | ---------------------------- |
| FR-001      | ADR-0001, ADR-0012           |
| FR-002      | ADR-0012                     |
| FR-003      | ADR-0012                     |
| FR-004      | ADR-0003, ADR-0005           |
| FR-005      | ADR-0002, ADR-0003, ADR-0008 |
| FR-006      | ADR-0005, ADR-0010, ADR-0012 |
| FR-007      | ADR-0002, ADR-0003, ADR-0005 |
| FR-008      | ADR-0008, ADR-0009, ADR-0010 |
| FR-009      | ADR-0004, ADR-0011           |
| FR-010      | ADR-0009                     |
| FR-011      | ADR-0004, ADR-0006           |
| FR-012      | ADR-0006                     |
| NFR-001     | ADR-0003                     |
| NFR-002     | ADR-0001, ADR-0003, ADR-0011 |
| NFR-003     | ADR-0003, ADR-0004           |
| NFR-004     | ADR-0003                     |
| NFR-005     | ADR-0004, ADR-0011           |
| NFR-006     | ADR-0003, ADR-0008           |
| NFR-007     | ADR-0001, ADR-0008           |
| NFR-008     | ADR-0012                     |
| NFR-009     | ADR-0003, ADR-0006           |
| NFR-010     | ADR-0006                     |

---

# Requirement-to-Work-Packet Matrix

| Requirement | Related Work Packets               |
| ----------- | ---------------------------------- |
| FR-001      | WP-0001, WP-0008                   |
| FR-002      | WP-0001, WP-0020                   |
| FR-003      | WP-0001, WP-0008, WP-0020          |
| FR-004      | WP-0002, WP-0008, WP-0021          |
| FR-005      | WP-0008, WP-0024                   |
| FR-006      | WP-0008, WP-0013, WP-0025          |
| FR-007      | WP-0008, WP-0027                   |
| FR-008      | WP-0010, WP-0026                   |
| FR-009      | WP-0012, WP-0026                   |
| FR-010      | WP-0011, WP-0025                   |
| FR-011      | WP-0004, WP-0022                   |
| FR-012      | WP-0004, WP-0022                   |
| NFR-001     | WP-0001, WP-0002, WP-0008          |
| NFR-002     | WP-0001, WP-0008, WP-0010, WP-0012 |
| NFR-003     | WP-0017, WP-0024                   |
| NFR-004     | WP-0017                            |
| NFR-005     | WP-0012, WP-0026                   |
| NFR-006     | WP-0002, WP-0010                   |
| NFR-007     | WP-0008, WP-0010, WP-0015          |
| NFR-008     | WP-0008, WP-0017                   |
| NFR-009     | WP-0003, WP-0008                   |
| NFR-010     | WP-0004, WP-0022                   |

---

# Requirement-to-Policy Matrix

| Requirement | Related Policies                                                        |
| ----------- | ----------------------------------------------------------------------- |
| FR-002      | POLICY-COMMAND-CATALOG                                                  |
| FR-003      | POLICY-COMMAND-CATALOG, POLICY-PLACEHOLDER-HONESTY                      |
| FR-004      | POLICY-CANONICAL-MANIFEST                                               |
| FR-006      | POLICY-CANONICAL-MANIFEST, POLICY-COMMAND-CATALOG, POLICY-DOCS-REQUIRED |
| FR-009      | POLICY-SECRET-REDACTION, POLICY-AI-OPTIONAL                             |
| FR-010      | POLICY-DOCS-REQUIRED                                                    |
| FR-011      | POLICY-NO-UNSAFE-MUTATION                                               |
| FR-012      | POLICY-NO-UNSAFE-MUTATION                                               |
| NFR-001     | POLICY-NO-NETWORK-BY-DEFAULT, POLICY-AI-OPTIONAL                        |
| NFR-003     | POLICY-NO-NETWORK-BY-DEFAULT                                            |
| NFR-004     | POLICY-NO-TELEMETRY-BY-DEFAULT                                          |
| NFR-005     | POLICY-AI-OPTIONAL                                                      |
| NFR-009     | POLICY-NO-UNSAFE-MUTATION                                               |
| NFR-010     | POLICY-NO-UNSAFE-MUTATION                                               |

---

# Requirement-to-Risk Matrix

| Requirement | Related Risks                |
| ----------- | ---------------------------- |
| FR-002      | RISK-001                     |
| FR-003      | RISK-001                     |
| FR-004      | RISK-002                     |
| FR-005      | RISK-003, RISK-007           |
| FR-006      | RISK-001, RISK-002, RISK-008 |
| FR-007      | RISK-002, RISK-007, RISK-008 |
| FR-008      | RISK-011, RISK-014           |
| FR-009      | RISK-004, RISK-005           |
| FR-010      | RISK-008, RISK-014           |
| FR-011      | RISK-003, RISK-011           |
| FR-012      | RISK-003, RISK-010           |
| NFR-001     | RISK-006, RISK-012           |
| NFR-002     | RISK-011, RISK-014           |
| NFR-003     | RISK-012                     |
| NFR-004     | RISK-013                     |
| NFR-005     | RISK-005                     |
| NFR-006     | RISK-006                     |
| NFR-009     | RISK-003                     |
| NFR-010     | RISK-003, RISK-010           |

---

# Initial Validation Targets

Future `monad docs check` or `monad trace check` should eventually validate that:

1. Every requirement has a stable ID.
2. Every requirement has a status.
3. Every requirement has a source document.
4. Every P0 requirement maps to at least one work packet.
5. Every P0 requirement maps to at least one test or planned BDD scenario.
6. Every safety/security requirement maps to at least one policy or risk.
7. Referenced ADR IDs exist.
8. Referenced work-packet IDs exist.
9. Referenced policy IDs exist.
10. Referenced risk IDs exist.

Initial validation should warn before it fails.

---

## Final Rule

Requirements are not just prose.

A Monad requirement should be stable enough to trace from product intent to architecture decision, work packet, BDD scenario, policy, test evidence, risk, and release evidence.
