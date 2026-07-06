# Monad ID and Cross-Link Reference

## Purpose

This document defines the canonical ID and cross-link conventions for Monad OS / Monad CLI planning, governance, documentation, implementation, testing, policy, risk, and release evidence artifacts.

Monad’s planning package should be:

```text
queryable
testable
cross-referenceable
eventually machine-validatable
```

The goal is not bureaucracy. The goal is to make Monad’s repository lifecycle artifacts traceable and trustworthy.

Monad should be able to connect:

```text
Requirement
  -> ADR
    -> Work Packet
      -> BDD Scenario
        -> Test Evidence
          -> Policy / Finding / Risk
            -> Release Evidence
```

Stable IDs are the foundation for that traceability.

---

## Core Rule

IDs are stable.

An ID should remain stable even if the title of the artifact changes.

Example:

```text
FR-005: Repository Inspection
```

may later be renamed to:

```text
FR-005: Inspect Repository Structure
```

but it should remain:

```text
FR-005
```

IDs must not be reused.

Deprecated, rejected, removed, or superseded IDs remain reserved.

---

## Why Monad Uses Typed IDs

Monad uses typed, human-readable IDs rather than UUIDs for planning artifacts.

Typed IDs make it easy for humans and future Monad commands to understand what kind of artifact is being referenced.

Good:

```text
FR-004
ADR-0005
WP-0002
BDD-MANIFEST-002
POLICY-CANONICAL-MANIFEST
MANIFEST-CANONICAL-CONFLICT
RISK-002
EVID-004
```

Avoid:

```text
8bc21d22-7d6e-438e-9d55-7e293c8d188a
```

UUIDs may be useful for runtime-generated objects later, but they are not appropriate for source-of-truth planning artifacts.

---

## Canonical ID Formats

| Artifact                   | Format                | Example                       |
| -------------------------- | --------------------- | ----------------------------- |
| Business Goal              | `BG-NNN`              | `BG-001`                      |
| User Need                  | `UN-NNN`              | `UN-001`                      |
| Functional Requirement     | `FR-NNN`              | `FR-005`                      |
| Non-Functional Requirement | `NFR-NNN`             | `NFR-003`                     |
| ADR                        | `ADR-NNNN`            | `ADR-0005`                    |
| Epic                       | `EPIC-NNNN`           | `EPIC-0003`                   |
| Work Packet                | `WP-NNNN`             | `WP-0010`                     |
| Layer                      | `LAYER-NNNN.N`        | `LAYER-0010.3`                |
| BDD Scenario               | `BDD-DOMAIN-NNN`      | `BDD-MANIFEST-002`            |
| Policy                     | `POLICY-DOMAIN-NAME`  | `POLICY-CANONICAL-MANIFEST`   |
| Finding                    | `DOMAIN-STABLE-ID`    | `MANIFEST-CANONICAL-CONFLICT` |
| Risk                       | `RISK-NNN`            | `RISK-004`                    |
| Release Evidence           | `EVID-NNN`            | `EVID-001`                    |
| Schema                     | `SCHEMA-NAME-VERSION` | `SCHEMA-PLAN-V0`              |
| Command                    | `cmd:<command path>`  | `cmd:monad inspect`           |

---

## ID Ownership

In the current solo-developer phase, the same person may assign every ID.

The owner role still matters because it clarifies future responsibility.

| Artifact                   | Owner Role                   |
| -------------------------- | ---------------------------- |
| Business Goal              | Product owner                |
| User Need                  | Product owner                |
| Functional Requirement     | Product owner                |
| Non-Functional Requirement | Product/architecture owner   |
| ADR                        | Architecture owner           |
| Epic                       | Delivery/product owner       |
| Work Packet                | Delivery owner               |
| Layer                      | Work-packet owner            |
| BDD Scenario               | Test/product owner           |
| Policy                     | Governance/security owner    |
| Finding                    | Engineering/governance owner |
| Risk                       | Product/architecture owner   |
| Release Evidence           | Release owner                |
| Schema                     | Schema/API owner             |
| Command                    | CLI owner                    |

---

## ID Assignment Rules

1. Assign IDs before an artifact becomes part of the canonical planning/governance system.
2. Do not reuse IDs.
3. Do not renumber IDs for cosmetic reasons.
4. Do not encode status in the ID.
5. Do not encode owner in the ID.
6. Do not encode implementation date in the ID.
7. Prefer short, stable IDs over long descriptive identifiers.
8. Titles may change; IDs should not.
9. Superseded artifacts keep their IDs.
10. Deleted or abandoned IDs remain reserved if they were ever referenced.

---

## Cross-Link Rule

Use IDs as the primary references.

Use file paths as secondary references when useful.

Good:

```markdown
Related ADRs: ADR-0005  
Related Requirements: FR-004, NFR-002  
Related Work Packets: WP-0002, WP-0010  
Related Policies: POLICY-CANONICAL-MANIFEST  
Related Findings: MANIFEST-CANONICAL-CONFLICT  
```

Better when file location is helpful:

```markdown
Related ADRs:
- ADR-0005: `docs/architecture/decision-records/adr-0005-canonical-manifest.md`

Related Work Packets:
- WP-0002: `docs/roadmap/work-packets/WP-0002-core-workspace-model-and-manifest-schema.md`
```

Avoid making filenames the canonical identity.

Files can move. IDs should remain stable.

---

## Status Values

Use controlled status values so future Monad commands can validate artifact state.

### General Artifact Status

```text
draft
proposed
accepted
planned
active
implemented
validated
superseded
deprecated
rejected
```

### Requirement Status

```text
draft
accepted
planned
implemented
validated
deprecated
```

### ADR Status

```text
proposed
accepted
superseded
deprecated
rejected
```

### Work-Packet Status

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

### BDD Scenario Status

```text
draft
specified
implemented
passing
blocked
future
```

### Policy Status

```text
draft
documented
implemented
enforced
waivable
deprecated
```

### Risk Status

```text
open
mitigated
accepted
transferred
closed
```

### Release Evidence Status

```text
required
produced
verified
missing
not-applicable
```

---

## Business Goal IDs

Business goals use:

```text
BG-NNN
```

Example:

```text
BG-001: Make repositories understandable
BG-002: Make repositories governable
BG-003: Avoid unsafe repository changes
BG-004: Support AI safely
BG-005: Preserve local-first value
```

Business goals should appear in:

```text
docs/product/charter.md
docs/product/prd.md
governance/traceability-matrix.md
```

---

## User Need IDs

User needs use:

```text
UN-NNN
```

Example:

```text
UN-001: Inspect repository structure
UN-002: Validate source-of-truth consistency
UN-003: Understand command surface
UN-004: Generate AI-safe handoff context
UN-005: Plan before mutation
```

User needs should map to requirements.

---

## Functional Requirement IDs

Functional requirements use:

```text
FR-NNN
```

Initial functional requirements:

```text
FR-001: Version Reporting
FR-002: Command Catalog
FR-003: List Commands
FR-004: Configuration and Manifest Resolution
FR-005: Repository Inspection
FR-006: Baseline Check
FR-007: Doctor Diagnostics
FR-008: Lifecycle Graph
FR-009: Context Handoff
FR-010: Documentation Check
FR-011: Plan Creation
FR-012: Apply With Approval
```

Functional requirements should appear in:

```text
docs/product/prd.md
docs/product/requirements-index.md
governance/traceability-matrix.md
```

Each functional requirement should map to:

```text
user need
ADR, where applicable
work packet
BDD scenario
test evidence
docs
policy/finding, where applicable
```

---

## Non-Functional Requirement IDs

Non-functional requirements use:

```text
NFR-NNN
```

Initial non-functional requirements:

```text
NFR-001: Local-First Operation
NFR-002: Deterministic Behavior
NFR-003: No Network by Default
NFR-004: No Telemetry by Default
NFR-005: AI Optionality
NFR-006: No Required Database
NFR-007: Structured Output
NFR-008: Stable Exit Codes
NFR-009: Read-Only Safety
NFR-010: Plan-Backed Mutation
```

Non-functional requirements should map to:

```text
ADRs
policies
tests
risks
release evidence
```

---

## ADR IDs

Architecture Decision Records use:

```text
ADR-NNNN
```

Example:

```text
ADR-0001: Rust Single-Binary Runtime
ADR-0002: Coordinate Native Tools Instead of Replacing Them
ADR-0003: Local-First Core
ADR-0004: AI-Native but AI-Optional
ADR-0005: monad.toml Is the Canonical Manifest
ADR-0006: Plan-Backed Mutation
ADR-0007: Modular Rust Workspace
ADR-0008: Lifecycle Graph as Core Model
ADR-0009: Documentation-as-Code
ADR-0010: Policy-as-Code
ADR-0011: Deterministic Context Before AI Assistance
ADR-0012: Honest Placeholder Commands
```

ADR filenames should use:

```text
adr-NNNN-kebab-case-title.md
```

Example:

```text
adr-0005-canonical-manifest.md
```

Each ADR should include cross-link sections:

```markdown
## Related Requirements

- FR-004
- NFR-002

## Related Work Packets

- WP-0002
- WP-0008
- WP-0010

## Related Policies

- POLICY-CANONICAL-MANIFEST

## Related Risks

- RISK-002
```

---

## Epic IDs

Epics use:

```text
EPIC-NNNN
```

Example:

```text
EPIC-0001: Repository Foundation and Source of Truth
EPIC-0002: Command Surface and CLI Contracts
EPIC-0003: Read-Only Repository Understanding
EPIC-0004: Documentation, ADR, and Work-Packet Lifecycle
EPIC-0005: Context and AI-Safe Handoff
EPIC-0006: Plan-Backed Mutation Engine
EPIC-0007: Generators, Templates, and Packs
EPIC-0008: Policy Engine and Waivers
EPIC-0009: Native Tool Coordination
EPIC-0010: Release and Change Lifecycle
EPIC-0011: Advanced Graph and Query Layer
EPIC-0012: AI-Assisted but AI-Optional Workflows
EPIC-0013: Optional Hosted Control Plane
```

Each work packet should reference its parent epic.

---

## Work Packet IDs

Work packets use:

```text
WP-NNNN
```

Example:

```text
WP-0000: Work Packet Specification and Schema
WP-0001: Rust Workspace and CLI Skeleton
WP-0002: Core Workspace Model and Manifest Schema
```

Work-packet filenames should use:

```text
WP-NNNN-kebab-case-title.md
```

Example:

```text
WP-0002-core-workspace-model-and-manifest-schema.md
```

Each work packet should include normalized metadata:

```markdown
# WP-0002: Core Workspace Model and Manifest Schema

Status: Planned  
Epic: EPIC-0001  
Stage: Stage 1  
Version Target: v0.2  
Related Requirements: FR-004, NFR-002  
Related ADRs: ADR-0005  
Related BDD: BDD-MANIFEST-001, BDD-MANIFEST-002  
Related Policies: POLICY-CANONICAL-MANIFEST  
Related Findings: MANIFEST-MISSING, MANIFEST-CANONICAL-CONFLICT  
Related Risks: RISK-002  
```

---

## Layer IDs

Layers use:

```text
LAYER-NNNN.N
```

The first number should match the work packet where practical.

Example:

```text
LAYER-0002.1: Define manifest model
LAYER-0002.2: Implement canonical manifest detection
LAYER-0002.3: Add mirror conflict reporting
```

Layer IDs are useful for internal work-packet sequencing.

They do not need to be globally referenced as often as work-packet IDs.

---

## BDD Scenario IDs

BDD scenarios use:

```text
BDD-DOMAIN-NNN
```

Recommended domains:

```text
VERSION
CATALOG
CONFIG
MANIFEST
INSPECT
CHECK
DOCTOR
GRAPH
CONTEXT
DOCS
ADR
WORKPACKET
POLICY
PLAN
APPLY
NATIVE
AI
NETWORK
TELEMETRY
RELEASE
```

Examples:

```text
BDD-VERSION-001
BDD-CATALOG-001
BDD-CATALOG-002
BDD-MANIFEST-001
BDD-MANIFEST-002
BDD-INSPECT-001
BDD-CONTEXT-SECRET-001
BDD-PLAN-DRYRUN-001
BDD-APPLY-SAFE-001
BDD-AI-OPTIONAL-001
```

Each BDD scenario should map to at least:

```text
requirement
ADR, where applicable
work packet
policy/finding, where applicable
test type
maturity
```

Example:

```markdown
### BDD-MANIFEST-002: workspace.toml conflict is reported

Related Requirements: FR-004  
Related ADRs: ADR-0005  
Related Work Packets: WP-0002  
Related Policy: POLICY-CANONICAL-MANIFEST  
Related Finding: MANIFEST-CANONICAL-CONFLICT  
Test Type: Fixture integration test  
Maturity: Planned  
```

---

## Policy IDs

Policies use:

```text
POLICY-DOMAIN-NAME
```

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

Each policy should map to:

```text
protected requirements
related ADRs
related work packets
finding IDs
waiver eligibility
```

Example:

```markdown
# POLICY-CANONICAL-MANIFEST: Canonical Manifest Policy

Protected Requirements: FR-004, NFR-002  
Related ADRs: ADR-0005  
Related Work Packets: WP-0002, WP-0010  

Findings:
- MANIFEST-MISSING
- MANIFEST-CANONICAL-CONFLICT
- MANIFEST-INVALID-TOML

Waiver Eligible: No for canonical ambiguity; maybe yes for mirror missing.
```

---

## Finding IDs

Findings use:

```text
DOMAIN-STABLE-ID
```

Initial finding IDs:

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
```

Findings should be stable because they may appear in:

```text
JSON output
test assertions
CI logs
documentation
policy reports
release evidence
future hosted dashboards
```

Each finding should map to:

```text
severity
category
message
related policy
related requirement
related work packet
remediation
```

---

## Risk IDs

Risks use:

```text
RISK-NNN
```

Initial risk IDs:

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

Each risk should map to:

```text
control
evidence
owner role
status
related requirements
related policies
related work packets
```

---

## Release Evidence IDs

Release evidence uses:

```text
EVID-NNN
```

Initial release evidence IDs:

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

Release evidence should later feed:

```bash
monad release readiness
```

Each evidence item should define:

```text
source command
required status
related requirements
related policies
related risks
release gate severity
```

---

## Schema IDs

Schemas use:

```text
SCHEMA-NAME-VERSION
```

Examples:

```text
SCHEMA-COMMAND-CATALOG-V0
SCHEMA-FINDING-V0
SCHEMA-PLAN-V0
SCHEMA-GRAPH-V0
SCHEMA-CONTEXT-MANIFEST-V0
SCHEMA-POLICY-REPORT-V0
SCHEMA-APPLY-REPORT-V0
SCHEMA-RELEASE-EVIDENCE-V0
```

Schemas should not be marked stable until their corresponding output is mature.

Pre-v1 schemas should be clearly labeled as pre-v1.

---

## Command References

Commands use:

```text
cmd:<command path>
```

Examples:

```text
cmd:monad version
cmd:monad list
cmd:monad config
cmd:monad inspect
cmd:monad check
cmd:monad doctor
cmd:monad graph
cmd:monad context handoff
cmd:monad docs check
cmd:monad plan
cmd:monad apply --dry-run
```

Command references are useful in:

```text
requirements
BDD scenarios
work packets
docs
test plans
release evidence
```

---

## Recommended Metadata Style

For the current phase, use plain Markdown metadata rather than YAML frontmatter.

Reason:

```text
easier to read
less fragile
sufficient for planning hardening
simple to copy/paste
simple for humans to review
```

Recommended format:

```markdown
# WP-0002: Core Workspace Model and Manifest Schema

Status: Planned  
Epic: EPIC-0001  
Stage: Stage 1  
Version Target: v0.2  
Related Requirements: FR-004, NFR-002  
Related ADRs: ADR-0005  
Related BDD: BDD-MANIFEST-001, BDD-MANIFEST-002  
Related Policies: POLICY-CANONICAL-MANIFEST  
Related Findings: MANIFEST-MISSING, MANIFEST-CANONICAL-CONFLICT  
Related Risks: RISK-002  
```

Future Monad may support YAML frontmatter:

```yaml
---
id: WP-0002
status: planned
epic: EPIC-0001
requirements:
  - FR-004
  - NFR-002
adrs:
  - ADR-0005
policies:
  - POLICY-CANONICAL-MANIFEST
---
```

Do not require YAML frontmatter yet.

---

## Supersession Rules

If an artifact is replaced:

1. Keep the original ID reserved.
2. Mark the original artifact as `superseded`.
3. Link the original artifact to the replacement.
4. Link the replacement back to the original.
5. Update indexes and traceability matrices.
6. Do not silently delete the historical record.

Example:

```markdown
Status: Superseded  
Superseded By: ADR-0021  
Supersedes: None
```

---

## Deprecation Rules

If an artifact is no longer recommended but still historically relevant:

1. Mark it `deprecated`.
2. Explain why.
3. Link to replacement guidance if any.
4. Keep the ID reserved.

Deprecation differs from supersession.

A superseded artifact has a direct replacement.

A deprecated artifact may not.

---

## Rejection Rules

Rejected artifacts should remain reserved when they represent meaningful decisions.

Use rejection for tempting but intentionally avoided paths.

Example:

```text
ADR-00XX: Hosted-First Control Plane
Status: Rejected
```

Rejected records can prevent repeated debate.

---

## Cross-Link Validation Rules

Future `monad docs check` or `monad trace check` should eventually validate:

1. Referenced ADR IDs exist.
2. Referenced work-packet IDs exist.
3. Referenced requirement IDs exist.
4. Referenced policy IDs exist.
5. Referenced finding IDs exist.
6. Referenced risk IDs exist.
7. Referenced evidence IDs exist.
8. Referenced files exist when paths are included.
9. Artifact status values are from controlled vocabularies.
10. IDs match canonical formats.
11. Deprecated or superseded IDs are not used as active dependencies without explanation.

Initial validation should warn rather than fail until the registry is mature.

---

## Recommended Registry Files

The normalized operational registries should live at:

```text
docs/reference/ids.md
docs/product/requirements-index.md
docs/architecture/decision-records/index.md
docs/roadmap/work-packets/index.md
docs/engineering/bdd-index.md
docs/reference/findings.md
docs/reference/release-evidence.md
governance/risk-register.md
governance/traceability-matrix.md
```

The planning package may remain deep and explanatory.

These registry files should be concise, operational, and easier for future Monad commands to validate.

---

## Initial Active Normalization Slice

Do not try to normalize every future artifact perfectly before implementation resumes.

Normalize the active slice first:

```text
FR-001 through FR-012
NFR-001 through NFR-010
ADR-0001 through ADR-0012
WP-0000 through WP-0007
BDD scenarios for version/catalog/config/manifest/read-only safety
core policies
core findings
top risks
initial release evidence
```

This creates a clean governance skeleton without freezing the project in planning mode.

---

## Final Rule

Monad IDs should make the planning package traceable without making it bureaucratic.

A good ID system lets a developer ask:

```text
Why does this exist?
What decision shaped it?
What work packet implements it?
What test proves it?
What policy governs it?
What risk does it mitigate?
What release evidence proves it is ready?
```

and find the answer locally in the repository.
