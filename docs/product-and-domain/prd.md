# Monad Product Requirements Document

Status: Draft / Normalized
Document ID: PRD-MONAD-0001
Product: Monad OS / Monad CLI
Primary Runtime Surface: `monad` CLI
Last Updated: 2026-07-06

---

## 1. Purpose

This Product Requirements Document defines the narrative product requirements for **Monad OS / Monad CLI**.

Monad is a Rust single-binary, local-first, governance-grade, AI-ready but AI-optional SDLC control plane and monorepo operating system.

The first product surface is the `monad` CLI.

This PRD explains what Monad must do, why it must do it, what constraints shape the product, and how the requirements trace into ADRs, work packets, BDD scenarios, policies, findings, risks, and release evidence.

The concise machine-oriented requirement registry lives in:

```text
docs/product/requirements-index.md
```

This PRD remains the narrative source for product intent and requirement meaning.

---

## 2. Product Thesis

Monad turns a repository into a governed lifecycle graph and exposes a safe local control plane for understanding, validating, documenting, graphing, planning, and safely evolving it.

Monad is not primarily a scaffolder.

Monad is not primarily a task runner.

Monad is not primarily an AI agent.

Monad is a local-first SDLC control plane that begins by making repository state understandable, traceable, and governable before it allows broad mutation or automation.

---

## 3. Product Summary

Monad provides a single local CLI that helps developers and teams:

1. Understand the current repository.
2. Resolve and validate canonical project metadata.
3. Inspect lifecycle structure and command surfaces.
4. Detect documentation, policy, manifest, and command drift.
5. Build a lifecycle graph of the repository.
6. Generate safe context and handoff artifacts.
7. Create explicit plans before mutating the filesystem.
8. Apply approved plans with evidence and policy gates.
9. Preserve traceability across requirements, ADRs, work packets, BDD scenarios, tests, findings, risks, policies, and releases.

Monad should feel useful to a solo developer on a laptop while remaining structurally capable of growing into a governance-grade platform for larger engineering organizations.

---

## 4. Product Doctrine

All product decisions must preserve the following doctrine:

```text
Local-first before hosted.
Deterministic before AI.
Read-only understanding before mutation.
Plan-backed mutation before generators.
Source-of-truth rules before automation.
Command contracts before command depth.
Graph foundations before graph persistence.
Policy checks before policy enforcement.
Templates before plugins.
Solo-developer usability before enterprise extensibility.
```

This doctrine constrains requirement interpretation.

When a requirement could be implemented in a simple local deterministic way or a more complex hosted/AI-driven way, the local deterministic implementation wins unless an accepted ADR explicitly says otherwise.

---

## 5. Users and Stakeholders

### 5.1 Primary User: Solo Developer / Repository Owner

The first target user is an individual developer managing a repository that is growing in complexity.

This user needs:

* Clear CLI commands.
* Local operation.
* No required hosted service.
* No required database.
* No required AI provider.
* Safe defaults.
* Explainable findings.
* Simple evidence that the repository is healthy.

Monad must not require enterprise infrastructure before it is useful.

### 5.2 Secondary User: Technical Lead / Maintainer

A maintainer needs a reliable way to keep repository structure, docs, commands, work packets, ADRs, policies, and release evidence aligned.

This user needs:

* Stable IDs.
* Traceability.
* CI-friendly checks.
* Structured output.
* Clear failure modes.
* Release readiness evidence.

### 5.3 Future User: Platform / Governance Team

A future platform or governance team may use Monad to coordinate larger monorepos, policy programs, AI context workflows, and release governance.

This user will eventually need:

* Policy-as-code.
* Plugin architecture.
* Graph persistence.
* Hosted or shared reporting.
* Team-level workflows.
* Enterprise integrations.

These needs must be anticipated structurally, but they must not force complexity into the local-first core.

---

## 6. Problem Statement

Modern repositories accumulate architecture decisions, scripts, docs, tasks, packages, services, policies, tests, AI context files, and release artifacts over time.

As repositories grow, teams lose confidence in:

* Which file is canonical.
* Which commands are supported.
* Which docs are current.
* Which requirements are implemented.
* Which ADRs justify behavior.
* Which work packets own future changes.
* Which checks are required before release.
* Whether generated or AI-assisted changes are safe.
* Whether mutation is planned, reviewable, and reversible.
* Whether evidence exists for claimed readiness.

Without a governed local control plane, repositories become hard to inspect, hard to validate, hard to evolve, and unsafe to automate.

Monad addresses this by creating a deterministic local layer over repository structure and lifecycle behavior.

---

## 7. Goals

### 7.1 Product Goals

Monad must:

1. Provide a trustworthy local CLI for repository understanding.
2. Resolve canonical Monad workspace state from `monad.toml`.
3. Expose a command catalog that matches the actual CLI surface.
4. Detect drift between docs, catalogs, policies, and implementation.
5. Support read-only inspection before mutation.
6. Generate lifecycle and context artifacts without requiring AI.
7. Require explicit plans before filesystem mutation.
8. Apply mutations only after approval and policy checks.
9. Produce evidence for tests, policy gates, findings, and releases.
10. Preserve stable traceability from requirements through release evidence.

### 7.2 Planning Hardening Goals

The current planning hardening pass must make the documentation package:

```text
queryable
testable
cross-referenceable
eventually machine-validatable
```

This requires stable references across:

```text
Requirement
  -> ADR
    -> Work Packet
      -> BDD Scenario
        -> Test Evidence
          -> Policy / Finding / Risk
            -> Release Evidence
```

---

## 8. Non-Goals

Monad must not attempt to do the following in the current core phase:

1. Replace native language build tools.
2. Replace package managers.
3. Require a hosted service.
4. Require a database.
5. Require telemetry.
6. Require network access for core commands.
7. Require AI for core behavior.
8. Perform broad unplanned filesystem mutation.
9. Hide placeholder command behavior.
10. Treat generated `.monad/` state as canonical source of truth.
11. Implement broad mutators before the plan-backed mutation engine exists.
12. Generate all roadmap work packets before the normalized governance substrate is stable.

---

## 9. Source-of-Truth Model

Monad uses the following source-of-truth model:

```text
monad.toml      canonical Monad manifest
workspace.toml  compatibility mirror only
monad.lock      resolved state
.monad/         local generated/cache/context/report/plan state
```

### 9.1 Canonical Manifest Rule

`monad.toml` is the canonical Monad manifest.

If `monad.toml` and `workspace.toml` conflict, `monad.toml` wins.

Related policy:

```text
POLICY-CANONICAL-MANIFEST
```

Related finding examples:

```text
MANIFEST-MISSING
MANIFEST-INVALID-TOML
MANIFEST-CANONICAL-CONFLICT
```

Related risks:

```text
RISK-002
RISK-014
```

### 9.2 Generated State Rule

`.monad/` may contain generated state, cache data, context packs, reports, plans, and apply evidence.

`.monad/` must not become canonical truth.

Generated state may support workflows, but authoritative decisions must trace back to source files, manifests, registries, ADRs, policies, tests, or explicit plans.

---

## 10. Accepted Architectural Constraints

The PRD must remain consistent with accepted ADRs.

Accepted ADRs:

```text
ADR-0001: Rust Single-Binary Runtime
ADR-0002: Coordinate Native Tools Instead of Replacing Them
ADR-0003: Local-First Core
ADR-0004: AI-Native but AI-Optional
ADR-0005: monad.toml Is the Canonical Manifest
ADR-0006: Plan-Backed Mutation
ADR-0012: Honest Placeholder Commands
```

Proposed ADRs that inform future direction:

```text
ADR-0007: Modular Rust Workspace
ADR-0008: Lifecycle Graph as Core Model
ADR-0009: Documentation-as-Code
ADR-0010: Policy-as-Code
ADR-0011: Deterministic Context Before AI Assistance
```

Accepted ADRs must not be contradicted without a superseding ADR.

---

## 11. Product Scope by Phase

### 11.1 Current Boundary: Planning Hardening

The current workstream is documentation and governance normalization.

Primary outputs:

```text
docs/reference/ids.md
docs/product/requirements-index.md
docs/architecture/decision-records/index.md
docs/roadmap/work-packets/index.md
docs/roadmap/work-packets/WP-0000-work-packet-specification-and-schema.md
governance/traceability-matrix.md
governance/risk-register.md
docs/testing/bdd-index.md
docs/reference/findings.md
docs/reference/release-evidence.md
docs/product/prd.md
```

### 11.2 Layer 0002: Rust Workspace and CLI Skeleton Stabilization

Layer 0002 focuses on stabilizing the Rust workspace and CLI skeleton.

Primary concerns:

* CLI shape.
* Command catalog.
* Version command.
* Honest placeholder behavior.
* Workspace testability.
* Contract tests between command registry and Clap surface.

Related requirements:

```text
FR-001
FR-002
FR-003
NFR-002
NFR-007
NFR-008
```

Related work packets:

```text
WP-0001
WP-0008
```

### 11.3 Layer 0003: Read-Only Lifecycle Commands

Layer 0003 must focus on read-only or dry-run commands.

Candidate command surfaces:

```text
docs check
docs generate --dry-run
adr list
adr new --dry-run
adr supersede --dry-run
workpacket list
workpacket new --dry-run
workpacket plan
policy check
policy explain
template list
template inspect
plugin list
release plan --dry-run
context handoff
```

Related requirements:

```text
FR-004
FR-005
FR-006
FR-007
FR-008
FR-009
FR-010
NFR-001
NFR-002
NFR-003
NFR-004
NFR-005
NFR-006
NFR-007
NFR-008
NFR-009
```

Related work packets:

```text
WP-0002
WP-0003
WP-0008
```

### 11.4 Layer 0004: Plan-Backed Repository Mutation Engine

Layer 0004 introduces plan-backed mutation.

Primary capabilities:

```text
plan schema
plan creation
dry-run apply
approved apply
file operation model
rollback hints
policy gate integration
```

Only after this layer should broad mutators become real:

```text
add
remove
rename
move
generate
sync
clean
migrate
upgrade
```

Related requirements:

```text
FR-011
FR-012
NFR-009
NFR-010
```

Related work packets:

```text
WP-0004
WP-0005
WP-0006
WP-0007
```

---

## 12. Functional Requirements

The concise registry for these requirements is:

```text
docs/product/requirements-index.md
```

This PRD defines the narrative meaning of each requirement.

---

### FR-001: Version Reporting

Monad must provide deterministic version reporting for the CLI and runtime.

The user must be able to determine:

* The installed Monad version.
* The command binary identity.
* The build or package version when available.
* Whether the CLI can be invoked successfully in the current environment.

Expected command surface:

```text
monad version
monad --version
```

Acceptance expectations:

* `monad version` returns a stable human-readable result.
* Structured output must be available when global output format support exists.
* The command must not require network access.
* The command must not require a valid workspace.
* The command must be safe to run anywhere.

Related ADRs:

```text
ADR-0001
ADR-0003
```

Related work packets:

```text
WP-0001
WP-0008
```

Related BDD scenarios:

```text
BDD-CLI-001
BDD-CLI-002
```

Related policies:

```text
POLICY-COMMAND-CATALOG
POLICY-NO-NETWORK-BY-DEFAULT
POLICY-NO-TELEMETRY-BY-DEFAULT
```

Related findings:

```text
COMMAND-CATALOG-DRIFT
NETWORK-CALL-UNEXPECTED
TELEMETRY-UNEXPECTED
```

Related risks:

```text
RISK-001
RISK-010
RISK-012
RISK-013
```

Related evidence:

```text
EVID-002
EVID-003
EVID-004
```

---

### FR-002: Command Catalog

Monad must maintain a command catalog that describes the CLI command surface.

The command catalog must make it possible to verify that documented commands, cataloged commands, and actual Clap commands do not drift apart.

The command catalog should include:

* Command path.
* Description.
* Status.
* Mutability classification.
* Placeholder status when applicable.
* Related requirements.
* Related work packet.
* Related policy expectations.

Command IDs use this format:

```text
cmd:<command path>
```

Examples:

```text
cmd:version
cmd:commands list
cmd:docs check
cmd:policy check
cmd:context handoff
cmd:plan create
cmd:apply
```

Acceptance expectations:

* Every cataloged command must exist in the CLI surface or be explicitly marked as planned.
* Every exposed command must be represented in the catalog.
* Placeholder commands must honestly identify themselves as placeholders.
* Contract tests must detect catalog/CLI drift.

Related ADRs:

```text
ADR-0001
ADR-0012
```

Related work packets:

```text
WP-0001
WP-0008
```

Related BDD scenarios:

```text
BDD-CLI-003
BDD-CLI-004
BDD-CLI-005
```

Related policies:

```text
POLICY-COMMAND-CATALOG
POLICY-PLACEHOLDER-HONESTY
```

Related findings:

```text
COMMAND-CATALOG-DRIFT
COMMAND-PLACEHOLDER-MISLEADING
```

Related risks:

```text
RISK-001
RISK-010
RISK-014
```

Related evidence:

```text
EVID-003
EVID-004
```

---

### FR-003: List Commands

Monad must provide a user-facing way to list available commands.

The list command must be accurate, deterministic, and aligned with the command catalog.

Expected command surface:

```text
monad commands list
```

Alternative aliases may exist only if they are cataloged.

Acceptance expectations:

* The command list must include stable command paths.
* Mutating commands must be distinguishable from read-only or dry-run commands when metadata exists.
* Placeholder commands must not appear as complete features.
* Structured output must be available when global output formatting is implemented.

Related ADRs:

```text
ADR-0001
ADR-0012
```

Related work packets:

```text
WP-0001
WP-0008
```

Related BDD scenarios:

```text
BDD-CLI-006
BDD-CLI-007
```

Related policies:

```text
POLICY-COMMAND-CATALOG
POLICY-PLACEHOLDER-HONESTY
```

Related findings:

```text
COMMAND-CATALOG-DRIFT
COMMAND-PLACEHOLDER-MISLEADING
```

Related risks:

```text
RISK-001
RISK-010
```

Related evidence:

```text
EVID-003
EVID-004
```

---

### FR-004: Configuration and Manifest Resolution

Monad must resolve workspace configuration from canonical source files.

The canonical manifest is:

```text
monad.toml
```

The compatibility mirror is:

```text
workspace.toml
```

The resolved state file is:

```text
monad.lock
```

Generated local state is stored under:

```text
.monad/
```

Acceptance expectations:

* Monad must search for workspace configuration deterministically.
* `monad.toml` must be treated as canonical.
* `workspace.toml` may be read as a compatibility mirror.
* A conflict between `monad.toml` and `workspace.toml` must prefer `monad.toml`.
* Missing or invalid manifests must produce clear findings.
* Manifest resolution must not require network access.
* Manifest resolution must not require AI.

Related ADRs:

```text
ADR-0003
ADR-0005
```

Related work packets:

```text
WP-0002
WP-0008
```

Related BDD scenarios:

```text
BDD-CONFIG-001
BDD-CONFIG-002
BDD-CONFIG-003
BDD-CONFIG-004
```

Related policies:

```text
POLICY-CANONICAL-MANIFEST
POLICY-NO-NETWORK-BY-DEFAULT
POLICY-AI-OPTIONAL
```

Related findings:

```text
MANIFEST-MISSING
MANIFEST-INVALID-TOML
MANIFEST-CANONICAL-CONFLICT
WORKSPACE-NOT-FOUND
AI-REQUIRED-FOR-CORE-COMMAND
NETWORK-CALL-UNEXPECTED
```

Related risks:

```text
RISK-002
RISK-005
RISK-011
RISK-012
RISK-014
```

Related evidence:

```text
EVID-002
EVID-003
EVID-009
```

---

### FR-005: Repository Inspection

Monad must inspect repository structure and summarize relevant lifecycle information.

Repository inspection should identify:

* Workspace root.
* Manifest presence.
* Known source-of-truth files.
* Docs structure.
* ADR structure.
* Work packet structure.
* Policy structure.
* Package or crate structure when detectable.
* Potential drift or missing required surfaces.

Expected command surface may include:

```text
monad inspect
```

Acceptance expectations:

* Inspection must be read-only.
* Inspection must be deterministic.
* Inspection must not require network access.
* Inspection must not mutate files.
* Inspection must emit actionable findings.
* Inspection must support human-readable output first and structured output where implemented.

Related ADRs:

```text
ADR-0002
ADR-0003
ADR-0005
```

Related work packets:

```text
WP-0002
WP-0003
WP-0008
```

Related BDD scenarios:

```text
BDD-INSPECT-001
BDD-INSPECT-002
BDD-INSPECT-003
```

Related policies:

```text
POLICY-CANONICAL-MANIFEST
POLICY-DOCS-REQUIRED
POLICY-NO-UNSAFE-MUTATION
```

Related findings:

```text
WORKSPACE-NOT-FOUND
MANIFEST-MISSING
DOCS-REQUIRED-MISSING
WORKPACKET-INDEX-MISSING
WORKPACKET-FILE-MISSING
```

Related risks:

```text
RISK-002
RISK-003
RISK-008
RISK-014
```

Related evidence:

```text
EVID-002
EVID-003
EVID-005
EVID-007
```

---

### FR-006: Baseline Check

Monad must provide a baseline check that determines whether the repository satisfies minimum expected structure and governance rules.

Expected command surface may include:

```text
monad check
```

The baseline check should evaluate:

* Workspace manifest validity.
* Command catalog consistency.
* Required documentation presence.
* Required registry presence.
* Required work-packet index presence.
* Basic policy expectations.
* Release evidence prerequisites when applicable.

Acceptance expectations:

* The check must be deterministic.
* The check must be CI-friendly.
* The check must produce stable exit codes.
* The check must produce actionable findings.
* The check must not mutate repository state.
* The check must not require network access.
* The check must not require telemetry or AI.

Related ADRs:

```text
ADR-0003
ADR-0005
ADR-0012
```

Related work packets:

```text
WP-0002
WP-0003
WP-0008
```

Related BDD scenarios:

```text
BDD-CHECK-001
BDD-CHECK-002
BDD-CHECK-003
BDD-CHECK-004
```

Related policies:

```text
POLICY-CANONICAL-MANIFEST
POLICY-COMMAND-CATALOG
POLICY-DOCS-REQUIRED
POLICY-PLACEHOLDER-HONESTY
POLICY-RELEASE-READINESS
```

Related findings:

```text
MANIFEST-MISSING
MANIFEST-INVALID-TOML
COMMAND-CATALOG-DRIFT
COMMAND-PLACEHOLDER-MISLEADING
DOCS-REQUIRED-MISSING
WORKPACKET-INDEX-MISSING
RELEASE-EVIDENCE-MISSING
```

Related risks:

```text
RISK-001
RISK-002
RISK-008
RISK-010
RISK-014
```

Related evidence:

```text
EVID-001
EVID-002
EVID-003
EVID-004
EVID-005
EVID-006
EVID-007
EVID-009
```

---

### FR-007: Doctor Diagnostics

Monad must provide diagnostics that explain repository health problems and recommended remediations.

Expected command surface may include:

```text
monad doctor
```

Doctor diagnostics differ from baseline checks by emphasizing explanation and remediation guidance.

Acceptance expectations:

* Doctor must be read-only.
* Doctor must explain findings in human-readable language.
* Doctor should map findings to policies where possible.
* Doctor should identify related risks where useful.
* Doctor should avoid false claims of repair unless an approved mutation plan exists.
* Doctor must not perform unplanned mutation.

Related ADRs:

```text
ADR-0003
ADR-0005
ADR-0006
ADR-0012
```

Related work packets:

```text
WP-0002
WP-0003
WP-0008
```

Related BDD scenarios:

```text
BDD-DOCTOR-001
BDD-DOCTOR-002
BDD-DOCTOR-003
```

Related policies:

```text
POLICY-NO-UNSAFE-MUTATION
POLICY-CANONICAL-MANIFEST
POLICY-DOCS-REQUIRED
POLICY-PLACEHOLDER-HONESTY
```

Related findings:

```text
MANIFEST-MISSING
MANIFEST-INVALID-TOML
MANIFEST-CANONICAL-CONFLICT
DOCS-REQUIRED-MISSING
COMMAND-CATALOG-DRIFT
POLICY-WAIVER-EXPIRED
```

Related risks:

```text
RISK-002
RISK-003
RISK-008
RISK-009
RISK-014
```

Related evidence:

```text
EVID-002
EVID-003
EVID-005
EVID-009
```

---

### FR-008: Lifecycle Graph

Monad must model repository lifecycle structure as a graph.

The lifecycle graph is a core conceptual model that supports understanding how repository artifacts relate.

Graph nodes may include:

* Requirements.
* ADRs.
* Work packets.
* Layers.
* Tasks.
* Commands.
* Policies.
* Findings.
* Risks.
* Tests.
* Release evidence.
* Docs.
* Manifests.
* Packages or crates.
* Generated plans.

Graph edges may include:

* Requires.
* Implements.
* Supersedes.
* Validates.
* Produces.
* Blocks.
* Mitigates.
* Violates.
* Waives.
* Evidence-for.

Expected command surface may include:

```text
monad graph
```

Acceptance expectations:

* Graph generation must be deterministic.
* Initial graph generation may be read-only and file-based.
* Graph persistence is not required in the local-first core.
* Graph output should support text and structured formats over time.
* Graph output must not require a database.
* Graph output must not require AI.

Related ADRs:

```text
ADR-0002
ADR-0003
ADR-0008
```

Related work packets:

```text
WP-0002
WP-0003
WP-0008
```

Related BDD scenarios:

```text
BDD-GRAPH-001
BDD-GRAPH-002
BDD-GRAPH-003
```

Related policies:

```text
POLICY-DOCS-REQUIRED
POLICY-COMMAND-CATALOG
POLICY-AI-OPTIONAL
```

Related findings:

```text
WORKPACKET-INDEX-MISSING
WORKPACKET-FILE-MISSING
WORKPACKET-ID-INVALID
WORKPACKET-SECTION-MISSING
COMMAND-CATALOG-DRIFT
AI-REQUIRED-FOR-CORE-COMMAND
```

Related risks:

```text
RISK-001
RISK-008
RISK-011
RISK-014
```

Related evidence:

```text
EVID-003
EVID-005
EVID-006
EVID-007
```

---

### FR-009: Context Handoff

Monad must support deterministic context and handoff generation.

Context handoff artifacts should help a future developer, maintainer, or AI assistant understand the repository state without relying on hidden memory.

Expected command surface may include:

```text
monad context handoff
```

The context handoff should include:

* Project identity.
* Current layer or work-packet boundary.
* Relevant commands.
* Current source-of-truth files.
* Recent findings.
* Risks.
* Release evidence status.
* Active next steps.
* Implementation boundaries.
* Important accepted ADRs.
* Requirement and work-packet references.

Acceptance expectations:

* Context handoff must be deterministic.
* Context handoff must not require AI.
* Context handoff must avoid leaking secrets.
* Context handoff must preserve source-of-truth rules.
* Context handoff should be usable across chat sessions, tools, and maintainers.

Related ADRs:

```text
ADR-0003
ADR-0004
ADR-0011
```

Related work packets:

```text
WP-0002
WP-0003
WP-0008
```

Related BDD scenarios:

```text
BDD-CONTEXT-001
BDD-CONTEXT-002
BDD-CONTEXT-003
BDD-CONTEXT-004
```

Related policies:

```text
POLICY-SECRET-REDACTION
POLICY-AI-OPTIONAL
POLICY-NO-NETWORK-BY-DEFAULT
POLICY-NO-TELEMETRY-BY-DEFAULT
```

Related findings:

```text
CONTEXT-SECRET-RISK
AI-REQUIRED-FOR-CORE-COMMAND
NETWORK-CALL-UNEXPECTED
TELEMETRY-UNEXPECTED
```

Related risks:

```text
RISK-004
RISK-005
RISK-012
RISK-013
RISK-014
```

Related evidence:

```text
EVID-003
EVID-008
EVID-009
```

---

### FR-010: Documentation Check

Monad must support checking required documentation and documentation registries.

Expected command surface may include:

```text
monad docs check
```

The docs check should validate the presence and basic integrity of required documentation surfaces, including:

```text
docs/reference/ids.md
docs/product/requirements-index.md
docs/product/prd.md
docs/architecture/decision-records/index.md
docs/roadmap/work-packets/index.md
docs/testing/bdd-index.md
docs/reference/findings.md
docs/reference/release-evidence.md
governance/traceability-matrix.md
governance/risk-register.md
```

Acceptance expectations:

* Docs check must be read-only.
* Docs check must produce actionable findings.
* Docs check must use stable IDs.
* Docs check must detect missing required docs.
* Docs check should detect obvious cross-reference drift over time.
* Docs check must not rewrite docs unless a plan-backed mutation flow is used.

Related ADRs:

```text
ADR-0003
ADR-0006
ADR-0009
```

Related work packets:

```text
WP-0000
WP-0002
WP-0003
WP-0008
```

Related BDD scenarios:

```text
BDD-DOCS-001
BDD-DOCS-002
BDD-DOCS-003
BDD-DOCS-004
```

Related policies:

```text
POLICY-DOCS-REQUIRED
POLICY-NO-UNSAFE-MUTATION
```

Related findings:

```text
DOCS-REQUIRED-MISSING
WORKPACKET-INDEX-MISSING
WORKPACKET-FILE-MISSING
WORKPACKET-ID-INVALID
WORKPACKET-SECTION-MISSING
```

Related risks:

```text
RISK-008
RISK-011
RISK-014
```

Related evidence:

```text
EVID-005
EVID-006
EVID-007
```

---

### FR-011: Plan Creation

Monad must support creation of explicit plans before repository mutation.

A plan must describe intended file operations and expected outcomes before changes are applied.

Expected command surface may include:

```text
monad plan create
monad workpacket plan
monad release plan --dry-run
```

A plan should include:

* Plan ID.
* Related requirement IDs.
* Related ADR IDs.
* Related work packet IDs.
* Proposed file operations.
* Expected created files.
* Expected modified files.
* Expected deleted files.
* Policy gates.
* Risk notes.
* Rollback hints.
* Evidence expectations.
* Approval status.

Acceptance expectations:

* Plans must be deterministic.
* Plans must be reviewable before mutation.
* Plans must identify mutating operations.
* Plans must be valid against an explicit plan schema.
* Plans must preserve source-of-truth rules.
* Plans must not silently mutate files.
* Plans must provide enough information for dry-run apply.

Related ADRs:

```text
ADR-0006
ADR-0010
```

Related work packets:

```text
WP-0004
```

Related BDD scenarios:

```text
BDD-PLAN-001
BDD-PLAN-002
BDD-PLAN-003
BDD-PLAN-004
```

Related policies:

```text
POLICY-NO-UNSAFE-MUTATION
POLICY-CANONICAL-MANIFEST
POLICY-RELEASE-READINESS
```

Related findings:

```text
MUTATION-PLAN-REQUIRED
PLAN-SCHEMA-INVALID
APPLY-UNPLANNED-FILE-OP
RELEASE-EVIDENCE-MISSING
```

Related risks:

```text
RISK-003
RISK-009
RISK-010
RISK-011
RISK-014
```

Related evidence:

```text
EVID-003
EVID-009
EVID-012
```

---

### FR-012: Apply With Approval

Monad must support applying approved mutation plans.

Mutation must be plan-backed, approval-aware, policy-gated, and evidence-producing.

Expected command surface may include:

```text
monad apply
```

The apply process should support:

* Dry-run apply.
* Approved apply.
* File operation validation.
* Policy gate validation.
* Finding emission.
* Apply report generation.
* Rollback hints.
* Release evidence linkage when applicable.

Acceptance expectations:

* Apply must reject unplanned file operations.
* Apply must reject invalid plans.
* Apply must require approval before real mutation.
* Apply must produce evidence or reports for mutation.
* Apply must integrate policy gates.
* Apply must preserve canonical source-of-truth rules.
* Apply must not hide destructive operations.
* Apply must remain local-first.

Related ADRs:

```text
ADR-0003
ADR-0006
ADR-0010
```

Related work packets:

```text
WP-0004
WP-0005
WP-0006
WP-0007
```

Related BDD scenarios:

```text
BDD-APPLY-001
BDD-APPLY-002
BDD-APPLY-003
BDD-APPLY-004
BDD-APPLY-005
```

Related policies:

```text
POLICY-NO-UNSAFE-MUTATION
POLICY-CANONICAL-MANIFEST
POLICY-RELEASE-READINESS
```

Related findings:

```text
MUTATION-PLAN-REQUIRED
PLAN-SCHEMA-INVALID
APPLY-UNPLANNED-FILE-OP
RELEASE-EVIDENCE-MISSING
RELEASE-GATE-FAILED
```

Related risks:

```text
RISK-003
RISK-009
RISK-010
RISK-011
RISK-014
```

Related evidence:

```text
EVID-003
EVID-009
EVID-012
```

---

## 13. Non-Functional Requirements

---

### NFR-001: Local-First Operation

Monad must work locally by default.

Core commands must not require:

* Hosted services.
* Cloud accounts.
* Remote APIs.
* External databases.
* AI providers.
* Telemetry services.

Related ADRs:

```text
ADR-0003
```

Related policies:

```text
POLICY-NO-NETWORK-BY-DEFAULT
POLICY-NO-TELEMETRY-BY-DEFAULT
```

Related risks:

```text
RISK-006
RISK-012
RISK-013
```

---

### NFR-002: Deterministic Behavior

Monad must prefer deterministic behavior over probabilistic or AI-mediated behavior.

For the same repository state and command inputs, core commands should produce stable outputs.

Related ADRs:

```text
ADR-0003
ADR-0004
ADR-0011
```

Related policies:

```text
POLICY-AI-OPTIONAL
```

Related risks:

```text
RISK-005
RISK-014
```

---

### NFR-003: No Network by Default

Monad core commands must not perform network calls by default.

Any future network behavior must be:

* Explicit.
* Documented.
* Configurable.
* Policy-checkable.
* Disabled by default for core local commands.

Related policies:

```text
POLICY-NO-NETWORK-BY-DEFAULT
```

Related findings:

```text
NETWORK-CALL-UNEXPECTED
```

Related risks:

```text
RISK-012
```

---

### NFR-004: No Telemetry by Default

Monad must not emit telemetry by default.

If telemetry is ever introduced, it must be:

* Explicitly opt-in.
* Documented.
* Disableable.
* Policy-checkable.
* Clearly separated from local core operation.

Related policies:

```text
POLICY-NO-TELEMETRY-BY-DEFAULT
```

Related findings:

```text
TELEMETRY-UNEXPECTED
```

Related risks:

```text
RISK-013
```

---

### NFR-005: AI Optionality

Monad may be AI-ready, but core functionality must be AI-optional.

No core command may require an AI model, AI API key, hosted LLM service, or agent runtime.

Related ADRs:

```text
ADR-0004
ADR-0011
```

Related policies:

```text
POLICY-AI-OPTIONAL
```

Related findings:

```text
AI-REQUIRED-FOR-CORE-COMMAND
```

Related risks:

```text
RISK-005
```

---

### NFR-006: No Required Database

Monad must not require a database for local core operation.

Future graph persistence, hosted reporting, team coordination, or analytics may use a database later, but the local core must work without one.

Related ADRs:

```text
ADR-0003
ADR-0008
```

Related risks:

```text
RISK-006
```

---

### NFR-007: Structured Output

Monad should support structured output for commands where machine consumption is useful.

Candidate formats include:

```text
text
json
markdown
mermaid
dot
```

Structured output must be deterministic and documented.

Related requirements:

```text
FR-001
FR-003
FR-005
FR-006
FR-008
FR-009
FR-011
FR-012
```

Related risks:

```text
RISK-010
RISK-011
```

---

### NFR-008: Stable Exit Codes

Monad must use stable exit codes for CI-friendly operation.

Checks, policy gates, catalog contracts, docs validation, and apply operations must have clear success and failure semantics.

Related requirements:

```text
FR-006
FR-010
FR-011
FR-012
```

Related risks:

```text
RISK-010
RISK-014
```

---

### NFR-009: Read-Only Safety

Read-only commands must not mutate repository files.

Read-only command examples include:

```text
version
commands list
inspect
check
doctor
graph
docs check
policy check
context handoff
```

Any command that writes files must be clearly classified and must participate in plan-backed mutation once mutation support exists.

Related ADRs:

```text
ADR-0003
ADR-0006
```

Related policies:

```text
POLICY-NO-UNSAFE-MUTATION
```

Related findings:

```text
MUTATION-PLAN-REQUIRED
APPLY-UNPLANNED-FILE-OP
```

Related risks:

```text
RISK-003
```

---

### NFR-010: Plan-Backed Mutation

All non-trivial repository mutation must be backed by an explicit plan.

Monad must not silently create, modify, delete, move, or rewrite important repository files outside an approved plan-backed workflow.

Related ADRs:

```text
ADR-0006
```

Related requirements:

```text
FR-011
FR-012
```

Related policies:

```text
POLICY-NO-UNSAFE-MUTATION
```

Related findings:

```text
MUTATION-PLAN-REQUIRED
PLAN-SCHEMA-INVALID
APPLY-UNPLANNED-FILE-OP
```

Related risks:

```text
RISK-003
RISK-011
RISK-014
```

---

## 14. Command Surface Requirements

### 14.1 Command Classification

Every command should be classified as one of:

```text
read-only
dry-run
plan-producing
plan-applying
mutating
placeholder
```

A command may have multiple traits, but mutation behavior must be explicit.

### 14.2 Placeholder Honesty

Placeholder commands are allowed only if they are honest.

A placeholder command must not pretend to be complete.

A placeholder command must:

* Say it is a placeholder.
* Avoid claiming mutation success.
* Avoid writing files unless explicitly intended and plan-backed.
* Be represented correctly in the command catalog.

Related ADR:

```text
ADR-0012
```

Related policy:

```text
POLICY-PLACEHOLDER-HONESTY
```

Related findings:

```text
COMMAND-PLACEHOLDER-MISLEADING
```

### 14.3 Command Catalog Contract

The command catalog and Clap command surface must remain aligned.

The minimum contract test is:

```bash
cargo test -p monad-cli --test command_catalog_contract
```

Related evidence:

```text
EVID-004
```

---

## 15. Policy Requirements

Initial policy IDs:

```text
POLICY-CANONICAL-MANIFEST
POLICY-COMMAND-CATALOG
POLICY-DOCS-REQUIRED
POLICY-NO-UNSAFE-MUTATION
POLICY-SECRET-REDACTION
POLICY-PLACEHOLDER-HONESTY
POLICY-AI-OPTIONAL
POLICY-NO-NETWORK-BY-DEFAULT
POLICY-NO-TELEMETRY-BY-DEFAULT
POLICY-RELEASE-READINESS
```

Policy files themselves may be generated later as individual files.

Until then, these IDs are stable references used by the PRD, requirements index, traceability matrix, findings registry, risk register, BDD index, and release evidence registry.

Policies must become machine-validatable over time, but early policy checks may be implemented as deterministic Rust checks.

---

## 16. Finding Requirements

Findings are stable diagnostic identifiers emitted by checks, diagnostics, policy gates, and release readiness workflows.

Initial finding IDs include:

```text
MANIFEST-MISSING
MANIFEST-INVALID-TOML
MANIFEST-CANONICAL-CONFLICT
WORKSPACE-NOT-FOUND
COMMAND-CATALOG-DRIFT
COMMAND-PLACEHOLDER-MISLEADING
DOCS-REQUIRED-MISSING
CONTEXT-SECRET-RISK
MUTATION-PLAN-REQUIRED
PLAN-SCHEMA-INVALID
APPLY-UNPLANNED-FILE-OP
POLICY-WAIVER-EXPIRED
NETWORK-CALL-UNEXPECTED
TELEMETRY-UNEXPECTED
AI-REQUIRED-FOR-CORE-COMMAND
WORKPACKET-INDEX-MISSING
WORKPACKET-FILE-MISSING
WORKPACKET-ID-INVALID
WORKPACKET-SECTION-MISSING
RELEASE-EVIDENCE-MISSING
RELEASE-GATE-FAILED
```

Findings must be:

* Stable.
* Human-readable.
* Machine-referenceable.
* Associated with remediation guidance where possible.
* Related to policies, risks, and requirements where possible.

The findings registry lives in:

```text
docs/reference/findings.md
```

---

## 17. Risk Requirements

The risk register tracks known product, implementation, safety, governance, and release risks.

Initial risk IDs include:

```text
RISK-001: Command Catalog Drift
RISK-002: Source-of-Truth Confusion
RISK-003: Unsafe Mutation
RISK-004: Secret Leakage
RISK-005: AI Overreach
RISK-006: Hosted Prematurity
RISK-007: Native Tool Inconsistency
RISK-008: Docs Drift
RISK-009: Policy False Positives
RISK-010: Release Regression
RISK-011: Schema Breakage
RISK-012: Hidden Network Calls
RISK-013: Hidden Telemetry
RISK-014: Planning and Implementation Drift
```

The risk register lives in:

```text
governance/risk-register.md
```

Each requirement should be traceable to risks where relevant.

Mitigations should be implemented through ADRs, policies, tests, command contracts, docs checks, release evidence, or plan-backed workflows.

---

## 18. Release Evidence Requirements

Release evidence must show that Monad is safe and ready for a release boundary.

Initial release evidence IDs include:

```text
EVID-001: Formatting Passed
EVID-002: Workspace Check Passed
EVID-003: Test Suite Passed
EVID-004: Command Catalog Contract Passed
EVID-005: Docs Check Passed
EVID-006: ADR Index Valid
EVID-007: Work Packet Index Valid
EVID-008: Security Checks Passed
EVID-009: Policy Checks Passed
EVID-010: Release Notes Prepared
EVID-011: Changelog Updated
EVID-012: Apply Reports Present When Required
```

The release evidence registry lives in:

```text
docs/reference/release-evidence.md
```

Minimum current local gate:

```bash
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
```

For CLI command-surface changes:

```bash
cargo test -p monad-cli --test command_catalog_contract
```

---

## 19. BDD Scenario Requirements

BDD scenarios provide testable behavior descriptions linked to requirements.

The BDD index lives in:

```text
docs/testing/bdd-index.md
```

Scenario IDs must follow the stable ID convention:

```text
BDD-DOMAIN-NNN
```

Candidate domains include:

```text
BDD-CLI-NNN
BDD-CONFIG-NNN
BDD-INSPECT-NNN
BDD-CHECK-NNN
BDD-DOCTOR-NNN
BDD-GRAPH-NNN
BDD-CONTEXT-NNN
BDD-DOCS-NNN
BDD-POLICY-NNN
BDD-PLAN-NNN
BDD-APPLY-NNN
BDD-RELEASE-NNN
```

BDD scenarios must eventually trace to:

* Requirements.
* Work packets.
* Tests.
* Policies.
* Findings.
* Risks.
* Release evidence.

---

## 20. Work Packet Requirements

Work packets organize implementation into governed units.

The work-packet index lives in:

```text
docs/roadmap/work-packets/index.md
```

The work-packet specification lives in:

```text
docs/roadmap/work-packets/WP-0000-work-packet-specification-and-schema.md
```

Current active work-packet slice to generate later:

```text
WP-0001-rust-workspace-and-cli-skeleton.md
WP-0002-core-workspace-model-and-manifest-schema.md
WP-0003-filesystem-safety-layer.md
WP-0004-plan-diff-apply-engine.md
WP-0005-monad-init.md
WP-0006-built-in-packs-and-templates.md
WP-0007-monad-add-and-monad-generate.md
```

Do not generate all roadmap work packets before existing docs are normalized.

---

## 21. Traceability Summary

| Requirement                  | Primary ADRs                           |               Primary Work Packets | Primary Policies                                     | Primary Risks                |
| ---------------------------- | -------------------------------------- | ---------------------------------: | ---------------------------------------------------- | ---------------------------- |
| FR-001 Version Reporting     | ADR-0001, ADR-0003                     |                   WP-0001, WP-0008 | POLICY-COMMAND-CATALOG, POLICY-NO-NETWORK-BY-DEFAULT | RISK-001, RISK-010, RISK-012 |
| FR-002 Command Catalog       | ADR-0001, ADR-0012                     |                   WP-0001, WP-0008 | POLICY-COMMAND-CATALOG, POLICY-PLACEHOLDER-HONESTY   | RISK-001, RISK-010, RISK-014 |
| FR-003 List Commands         | ADR-0001, ADR-0012                     |                   WP-0001, WP-0008 | POLICY-COMMAND-CATALOG                               | RISK-001, RISK-010           |
| FR-004 Config Resolution     | ADR-0003, ADR-0005                     |                   WP-0002, WP-0008 | POLICY-CANONICAL-MANIFEST                            | RISK-002, RISK-011, RISK-014 |
| FR-005 Repository Inspection | ADR-0002, ADR-0003, ADR-0005           |          WP-0002, WP-0003, WP-0008 | POLICY-DOCS-REQUIRED, POLICY-NO-UNSAFE-MUTATION      | RISK-002, RISK-003, RISK-008 |
| FR-006 Baseline Check        | ADR-0003, ADR-0005, ADR-0012           |          WP-0002, WP-0003, WP-0008 | POLICY-RELEASE-READINESS                             | RISK-001, RISK-008, RISK-010 |
| FR-007 Doctor Diagnostics    | ADR-0003, ADR-0005, ADR-0006, ADR-0012 |          WP-0002, WP-0003, WP-0008 | POLICY-NO-UNSAFE-MUTATION                            | RISK-002, RISK-003, RISK-009 |
| FR-008 Lifecycle Graph       | ADR-0002, ADR-0003, ADR-0008           |          WP-0002, WP-0003, WP-0008 | POLICY-DOCS-REQUIRED, POLICY-AI-OPTIONAL             | RISK-008, RISK-011, RISK-014 |
| FR-009 Context Handoff       | ADR-0003, ADR-0004, ADR-0011           |          WP-0002, WP-0003, WP-0008 | POLICY-SECRET-REDACTION, POLICY-AI-OPTIONAL          | RISK-004, RISK-005, RISK-014 |
| FR-010 Documentation Check   | ADR-0003, ADR-0006, ADR-0009           | WP-0000, WP-0002, WP-0003, WP-0008 | POLICY-DOCS-REQUIRED                                 | RISK-008, RISK-011, RISK-014 |
| FR-011 Plan Creation         | ADR-0006, ADR-0010                     |                            WP-0004 | POLICY-NO-UNSAFE-MUTATION                            | RISK-003, RISK-011, RISK-014 |
| FR-012 Apply With Approval   | ADR-0003, ADR-0006, ADR-0010           | WP-0004, WP-0005, WP-0006, WP-0007 | POLICY-NO-UNSAFE-MUTATION, POLICY-RELEASE-READINESS  | RISK-003, RISK-010, RISK-011 |

---

## 22. Acceptance Gates

A change should not be considered complete unless the relevant acceptance gates pass.

### 22.1 Minimum Local Gate

```bash
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
```

Related evidence:

```text
EVID-001
EVID-002
EVID-003
```

### 22.2 Command Surface Gate

For CLI command surface changes:

```bash
cargo test -p monad-cli --test command_catalog_contract
```

Related evidence:

```text
EVID-004
```

### 22.3 Documentation Governance Gate

For documentation normalization changes, the expected files should remain present and internally consistent:

```text
docs/reference/ids.md
docs/product/requirements-index.md
docs/product/prd.md
docs/architecture/decision-records/index.md
docs/roadmap/work-packets/index.md
docs/testing/bdd-index.md
docs/reference/findings.md
docs/reference/release-evidence.md
governance/traceability-matrix.md
governance/risk-register.md
```

Related evidence:

```text
EVID-005
EVID-006
EVID-007
```

### 22.4 Policy and Safety Gate

Before mutation commands become real, Monad must validate:

* Mutation requires a plan.
* Plans must be schema-valid.
* Apply must reject unplanned file operations.
* Apply must produce evidence.
* Policy checks must run where required.

Related evidence:

```text
EVID-009
EVID-012
```

---

## 23. Out-of-Scope for Current PRD Slice

The following are intentionally out of scope for this PRD slice:

1. Hosted Monad service.
2. Multi-user collaboration backend.
3. Cloud synchronization.
4. Graph database persistence.
5. AI agent execution.
6. AI provider integration.
7. Plugin marketplace.
8. Full enterprise policy engine.
9. Full release automation.
10. Broad code generation.
11. Broad mutating commands before plan-backed apply exists.
12. Materializing all roadmap work packets.

These may be addressed later through additional ADRs, work packets, requirements, and roadmap phases.

---

## 24. Open Product Questions

The following questions should be resolved through future ADRs, work packets, or implementation spikes:

1. What is the first stable plan schema version?
2. What exact structured output formats are supported by each command?
3. Which commands are required for the first tagged release?
4. Which docs are mandatory versus advisory?
5. How should policy waivers be represented?
6. How should release evidence be stored under `.monad/` without becoming canonical truth?
7. What minimum graph model is required before graph persistence is considered?
8. What is the boundary between `docs generate --dry-run` and true mutation?
9. How should context handoff redact secrets deterministically?
10. When should plugin support begin, and what command-contract guarantees must exist first?

---

## 25. PRD Change Control

This PRD may be updated as planning hardening continues.

Any material change to product behavior must preserve stable IDs or introduce new IDs.

IDs are never reused.

If a title changes, the ID remains stable.

If a requirement is superseded, it must be marked as superseded and linked to the replacement requirement.

Accepted ADRs must not be contradicted without a superseding ADR.

---

## 26. Next Normalization Targets

After this PRD is saved, the next normalization pass should update accepted ADR files first:

```text
docs/architecture/decision-records/adr-0001-rust-single-binary-runtime.md
docs/architecture/decision-records/adr-0002-coordinate-native-tools-instead-of-replacing-them.md
docs/architecture/decision-records/adr-0003-local-first-core.md
docs/architecture/decision-records/adr-0004-ai-native-but-ai-optional.md
docs/architecture/decision-records/adr-0005-canonical-manifest.md
docs/architecture/decision-records/adr-0006-plan-backed-mutation.md
docs/architecture/decision-records/adr-0012-honest-placeholder-commands.md
```

Each ADR should include:

```markdown
## Related Requirements

## Related Work Packets

## Related Policies

## Related Findings

## Related Risks

## Supersedes

## Superseded By
```

Then normalize:

```text
docs/roadmap/roadmap.md
docs/planning/index.md
docs/planning/0018-traceability-matrix.md
```

Only after existing docs are normalized should the active work-packet slice be generated:

```text
WP-0001 through WP-0007
```
