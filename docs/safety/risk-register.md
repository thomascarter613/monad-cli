# Monad Risk Register

## Purpose

This document is the operational risk register for Monad OS / Monad CLI.

It tracks product, architecture, implementation, governance, security, safety, and release risks that could weaken Monad’s trust model.

The full planning context lives in:

```text
docs/planning/
docs/planning/0018-traceability-matrix.md
```

This file is the concise governance registry for risk tracking.

---

## Risk Doctrine

Monad is a governance-grade repository runtime.

That means risks should be explicit, not hidden in implementation details.

A risk should identify:

```text
what can go wrong
why it matters
what controls reduce it
what evidence proves the control works
who owns the risk
current status
```

Risk tracking should remain practical and local-first.

No external GRC system is required for core risk governance.

---

## Risk ID Format

Risks use:

```text
RISK-NNN
```

Examples:

```text
RISK-001
RISK-002
RISK-013
```

Risk IDs are stable and must not be reused.

---

## Risk Status Values

Allowed risk statuses:

```text
open
mitigated
accepted
transferred
closed
```

| Status      | Meaning                                                    |
| ----------- | ---------------------------------------------------------- |
| open        | The risk exists and requires active attention.             |
| mitigated   | Controls exist and evidence supports the mitigation.       |
| accepted    | The risk is knowingly accepted.                            |
| transferred | The risk is delegated to another system, tool, or process. |
| closed      | The risk is no longer applicable.                          |

---

## Risk Severity Values

Recommended severity values:

```text
critical
high
medium
low
```

| Severity | Meaning                                                      |
| -------- | ------------------------------------------------------------ |
| critical | Could invalidate core trust, safety, or release readiness.   |
| high     | Could significantly harm correctness, safety, or user trust. |
| medium   | Could cause friction, rework, confusion, or drift.           |
| low      | Worth tracking but not release-blocking by itself.           |

---

## Risk Register Summary

| Risk     | Title                             | Severity | Status | Owner Role                     |
| -------- | --------------------------------- | -------- | ------ | ------------------------------ |
| RISK-001 | Command Catalog Drift             | high     | open   | CLI maintainer                 |
| RISK-002 | Source-of-Truth Confusion         | high     | open   | Workspace/config owner         |
| RISK-003 | Unsafe Mutation                   | critical | open   | Plan/change owner              |
| RISK-004 | Secret Leakage                    | critical | open   | Security owner                 |
| RISK-005 | AI Overreach                      | high     | open   | AI architecture owner          |
| RISK-006 | Hosted Prematurity                | high     | open   | Product/architecture owner     |
| RISK-007 | Native Tool Inconsistency         | medium   | open   | Native tool integration owner  |
| RISK-008 | Docs Drift                        | high     | open   | Documentation/governance owner |
| RISK-009 | Policy False Positives            | medium   | open   | Governance/security owner      |
| RISK-010 | Release Regression                | high     | open   | Release owner                  |
| RISK-011 | Schema Breakage                   | high     | open   | Schema/output owner            |
| RISK-012 | Hidden Network Calls              | high     | open   | Security owner                 |
| RISK-013 | Hidden Telemetry                  | high     | open   | Security owner                 |
| RISK-014 | Planning and Implementation Drift | high     | open   | Product/architecture owner     |

---

# RISK-001: Command Catalog Drift

Severity: High
Status: Open
Owner Role: CLI maintainer
Related Requirements: FR-002, FR-003, FR-006
Related ADRs: ADR-0012
Related Work Packets: WP-0001, WP-0008, WP-0020
Related Policies: POLICY-COMMAND-CATALOG, POLICY-PLACEHOLDER-HONESTY
Related Findings: COMMAND-CATALOG-DRIFT, COMMAND-PLACEHOLDER-MISLEADING
Related Evidence: EVID-004

## Description

The command catalog, Clap command tree, docs, and tests may drift from each other.

This would undermine command honesty and user trust.

## Impact

Users may see commands that do not exist, planned commands may appear implemented, or implemented commands may lack metadata.

## Controls

```text
command catalog contract tests
placeholder honesty policy
command metadata requirements
snapshot tests
docs check later
```

## Evidence

```text
EVID-004: Command Catalog Contract Passed
CLI smoke tests
command catalog unit tests
```

## Mitigation Plan

1. Keep command catalog as an explicit source of command metadata.
2. Test catalog against Clap.
3. Mark placeholder/planned commands honestly.
4. Update docs and catalog together.

---

# RISK-002: Source-of-Truth Confusion

Severity: High
Status: Open
Owner Role: Workspace/config owner
Related Requirements: FR-004, FR-006
Related ADRs: ADR-0005
Related Work Packets: WP-0002, WP-0005, WP-0008, WP-0021
Related Policies: POLICY-CANONICAL-MANIFEST
Related Findings: MANIFEST-MISSING, MANIFEST-INVALID-TOML, MANIFEST-CANONICAL-CONFLICT
Related Evidence: EVID-003, EVID-009

## Description

`monad.toml`, `workspace.toml`, `monad.lock`, and `.monad/` may be misunderstood or treated as competing sources of truth.

## Impact

Configuration may become ambiguous, generated state may become canonical, or compatibility mirrors may override canonical intent.

## Controls

```text
ADR-0005
canonical manifest policy
manifest fixture tests
doctor diagnostics
config command explanation
```

## Evidence

```text
manifest unit tests
fixture integration tests
policy checks
```

## Mitigation Plan

1. Treat `monad.toml` as canonical.
2. Treat `workspace.toml` as compatibility mirror only.
3. Treat `monad.lock` as resolved state.
4. Treat `.monad/` as generated/local state.
5. Report conflicts clearly.

---

# RISK-003: Unsafe Mutation

Severity: Critical
Status: Open
Owner Role: Plan/change owner
Related Requirements: FR-011, FR-012, NFR-009, NFR-010
Related ADRs: ADR-0006
Related Work Packets: WP-0003, WP-0004, WP-0014, WP-0022
Related Policies: POLICY-NO-UNSAFE-MUTATION
Related Findings: MUTATION-PLAN-REQUIRED, PLAN-SCHEMA-INVALID, APPLY-UNPLANNED-FILE-OP
Related Evidence: EVID-003, EVID-012

## Description

Commands may modify files before plan-backed mutation safety exists.

## Impact

User repositories could be changed unexpectedly, generated files could overwrite important content, or destructive operations could occur without review.

## Controls

```text
read-only-before-mutation doctrine
plan-backed mutation ADR
filesystem safety layer
dry-run tests
apply contract tests
explicit approval
apply reports
```

## Evidence

```text
dry-run writes nothing
apply writes only planned operations
apply report exists
mutation safety tests pass
```

## Mitigation Plan

1. Build filesystem safety before mutators.
2. Route risky changes through plan/apply.
3. Require dry-run for preview.
4. Require explicit approval for apply.
5. Block unplanned file operations.

---

# RISK-004: Secret Leakage

Severity: Critical
Status: Open
Owner Role: Security owner
Related Requirements: FR-009
Related ADRs: ADR-0004, ADR-0011
Related Work Packets: WP-0012, WP-0026
Related Policies: POLICY-SECRET-REDACTION
Related Findings: CONTEXT-SECRET-RISK
Related Evidence: EVID-003, EVID-008

## Description

Context packs or handoff outputs may include secrets, credentials, tokens, private keys, or sensitive local files.

## Impact

Sensitive data could be exposed to humans, AI tools, logs, hosted systems, or external providers.

## Controls

```text
secret redaction policy
default exclude patterns
context manifest
redaction tests
security review
no network by default
AI optionality
```

## Evidence

```text
redaction fixture tests
security checks
context output review
```

## Mitigation Plan

1. Exclude likely secrets by default.
2. Document included and excluded paths.
3. Add redaction tests.
4. Keep context generation deterministic and local.
5. Require explicit approval for provider-bound context later.

---

# RISK-005: AI Overreach

Severity: High
Status: Open
Owner Role: AI architecture owner
Related Requirements: FR-009, NFR-005
Related ADRs: ADR-0004, ADR-0011
Related Work Packets: WP-0012, WP-0026
Related Policies: POLICY-AI-OPTIONAL
Related Findings: AI-REQUIRED-FOR-CORE-COMMAND
Related Evidence: EVID-009

## Description

AI features may be introduced before deterministic context, plan safety, policy checks, and audit controls are mature.

## Impact

AI may be perceived as authoritative, apply changes unsafely, leak context, or become required for core value.

## Controls

```text
AI optionality ADR
deterministic context first
noop AI adapter later
AI suggestions become plans
no automatic apply
policy gates
```

## Evidence

```text
no-AI tests
policy checks
plan-backed AI suggestions
```

## Mitigation Plan

1. Keep AI optional.
2. Build deterministic context first.
3. Convert AI suggestions into reviewable plans.
4. Never allow AI to apply automatically.
5. Preserve no-provider core operation.

---

# RISK-006: Hosted Prematurity

Severity: High
Status: Open
Owner Role: Product/architecture owner
Related Requirements: NFR-001, NFR-006
Related ADRs: ADR-0003
Related Work Packets: WP-0001, WP-0002
Related Policies: POLICY-AI-OPTIONAL, POLICY-NO-NETWORK-BY-DEFAULT
Related Findings: NETWORK-CALL-UNEXPECTED
Related Evidence: EVID-006

## Description

The project may move toward hosted dashboards, sync, organizations, or fleet control before local CLI value is proven.

## Impact

Monad could become overbuilt, cloud-dependent, harder to bootstrap, and less aligned with its local-first doctrine.

## Controls

```text
local-first ADR
hosted deferred to v2
no network by default
no required database
local reports first
```

## Evidence

```text
ADR index
roadmap
offline command behavior
```

## Mitigation Plan

1. Defer hosted control plane.
2. Prove local CLI first.
3. Keep all core commands useful offline.
4. Treat hosted features as projections of local evidence.

---

# RISK-007: Native Tool Inconsistency

Severity: Medium
Status: Open
Owner Role: Native tool integration owner
Related Requirements: FR-005, FR-007
Related ADRs: ADR-0002
Related Work Packets: WP-0008, WP-0009, WP-0024
Related Policies: None yet
Related Findings: WORKSPACE-NOT-FOUND
Related Evidence: EVID-003

## Description

Native tools may be detected inconsistently across environments, versions, operating systems, and repository layouts.

## Impact

Monad may misreport repository capabilities or produce confusing diagnostics.

## Controls

```text
native tool detection fixtures
adapter boundaries
doctor diagnostics
optional tool handling
clear unsupported-state messages
```

## Evidence

```text
adapter tests
fixture tests
doctor tests
```

## Mitigation Plan

1. Detect tools without replacing them.
2. Treat missing optional tools gracefully.
3. Keep adapters small and testable.
4. Use fixtures for common layouts.

---

# RISK-008: Docs Drift

Severity: High
Status: Open
Owner Role: Documentation/governance owner
Related Requirements: FR-010
Related ADRs: ADR-0009
Related Work Packets: WP-0011, WP-0025
Related Policies: POLICY-DOCS-REQUIRED
Related Findings: DOCS-REQUIRED-MISSING
Related Evidence: EVID-005

## Description

Planning docs, user docs, ADRs, work packets, command docs, and implementation may drift.

## Impact

Users and future development sessions may make decisions based on stale or contradictory information.

## Controls

```text
docs check
planning index
ADR index
work-packet index
traceability matrix
release readiness checks
```

## Evidence

```text
docs check passed
ADR index valid
work-packet index valid
```

## Mitigation Plan

1. Keep docs in repo.
2. Normalize IDs and cross-links.
3. Add docs checks.
4. Treat docs as deliverables, not afterthoughts.

---

# RISK-009: Policy False Positives

Severity: Medium
Status: Open
Owner Role: Governance/security owner
Related Requirements: FR-006, FR-010
Related ADRs: ADR-0010
Related Work Packets: WP-0013, WP-0025
Related Policies: POLICY-RELEASE-READINESS
Related Findings: POLICY-WAIVER-EXPIRED
Related Evidence: EVID-009

## Description

Policy checks may produce noisy, incorrect, or overly strict findings.

## Impact

Users may ignore policy output, disable checks, or lose trust in Monad diagnostics.

## Controls

```text
policy explain
waiver model
severity levels
fixture tests
clear remediation
warn-before-enforce maturity
```

## Evidence

```text
policy tests
waiver tests
policy report
```

## Mitigation Plan

1. Start with explainable policies.
2. Use warnings before strict enforcement.
3. Add waiver support.
4. Test policy fixtures carefully.

---

# RISK-010: Release Regression

Severity: High
Status: Open
Owner Role: Release owner
Related Requirements: FR-012, NFR-008, NFR-010
Related ADRs: ADR-0001, ADR-0006
Related Work Packets: WP-0015, WP-0017, WP-0030, WP-0031
Related Policies: POLICY-RELEASE-READINESS
Related Findings: RELEASE-GATE-FAILED
Related Evidence: EVID-001, EVID-002, EVID-003, EVID-010, EVID-011

## Description

A release may regress command behavior, tests, docs, schemas, or safety guarantees.

## Impact

Users may receive an unstable CLI, broken command surface, unsafe mutation behavior, or inaccurate docs.

## Controls

```text
release readiness checks
CI gates
test matrix
changelog
release evidence report
```

## Evidence

```text
formatting passed
workspace check passed
test suite passed
release notes prepared
changelog updated
```

## Mitigation Plan

1. Define release evidence.
2. Require CI gates.
3. Dogfood before release.
4. Keep release notes and changelog current.

---

# RISK-011: Schema Breakage

Severity: High
Status: Open
Owner Role: Schema/output owner
Related Requirements: NFR-007, FR-008, FR-011
Related ADRs: ADR-0001, ADR-0006, ADR-0008
Related Work Packets: WP-0004, WP-0010, WP-0022, WP-0026
Related Policies: POLICY-RELEASE-READINESS
Related Findings: PLAN-SCHEMA-INVALID
Related Evidence: EVID-003

## Description

Machine-readable outputs may change without versioning or tests.

## Impact

Scripts, CI, future dashboards, and release evidence may break unexpectedly.

## Controls

```text
schema IDs
schema tests
snapshot tests
versioned output
pre-v1 stability labels
```

## Evidence

```text
schema tests
snapshot tests
structured output fixtures
```

## Mitigation Plan

1. Mark schemas pre-v1 until stable.
2. Version important schemas.
3. Test JSON outputs.
4. Avoid breaking changes without documentation.

---

# RISK-012: Hidden Network Calls

Severity: High
Status: Open
Owner Role: Security owner
Related Requirements: NFR-001, NFR-003
Related ADRs: ADR-0003, ADR-0004, ADR-0011
Related Work Packets: WP-0003, WP-0017, WP-0024
Related Policies: POLICY-NO-NETWORK-BY-DEFAULT
Related Findings: NETWORK-CALL-UNEXPECTED
Related Evidence: EVID-008

## Description

Core commands may accidentally or indirectly call the network through integrations, adapters, AI providers, telemetry, or native tools.

## Impact

Local-first privacy and trust guarantees would be weakened.

## Controls

```text
no-network policy
explicit network flags
security review
offline tests where practical
native tool boundary documentation
```

## Evidence

```text
security checks
offline test behavior
review gates
```

## Mitigation Plan

1. Keep network disabled by default.
2. Document any future network behavior.
3. Require explicit user intent for network operations.
4. Add tests or review gates for core commands.

---

# RISK-013: Hidden Telemetry

Severity: High
Status: Open
Owner Role: Security owner
Related Requirements: NFR-004
Related ADRs: ADR-0003
Related Work Packets: WP-0017
Related Policies: POLICY-NO-TELEMETRY-BY-DEFAULT
Related Findings: TELEMETRY-UNEXPECTED
Related Evidence: EVID-008

## Description

Telemetry may be introduced without explicit opt-in, documentation, or governance.

## Impact

User trust and privacy posture would be damaged.

## Controls

```text
no telemetry by default
security review
documentation requirement
future opt-in only
```

## Evidence

```text
security checks
code review
release evidence
```

## Mitigation Plan

1. Do not include telemetry by default.
2. Treat telemetry as a major decision requiring ADR.
3. Require opt-in if ever introduced.
4. Document exactly what is sent and why.

---

# RISK-014: Planning and Implementation Drift

Severity: High
Status: Open
Owner Role: Product/architecture owner
Related Requirements: FR-008, FR-010, NFR-002
Related ADRs: ADR-0008, ADR-0009
Related Work Packets: WP-0000, WP-0011, WP-0018, WP-0029
Related Policies: POLICY-DOCS-REQUIRED, POLICY-RELEASE-READINESS
Related Findings: DOCS-REQUIRED-MISSING, RELEASE-EVIDENCE-MISSING
Related Evidence: EVID-005, EVID-007

## Description

The planning package may describe a different product than the implementation actually delivers.

## Impact

Future work may implement stale assumptions, users may be misled, and governance artifacts may become performative.

## Controls

```text
planning index
traceability matrix
work-packet index
docs check
dogfooding
release evidence
```

## Evidence

```text
docs check passed
work-packet index valid
dogfood report
release evidence report
```

## Mitigation Plan

1. Keep planning docs source-controlled.
2. Normalize IDs and cross-links.
3. Update docs with implementation changes.
4. Use work packets as delivery contracts.
5. Dogfood Monad on Monad.

---

## Risk-to-Evidence Matrix

| Risk     | Evidence                                         |
| -------- | ------------------------------------------------ |
| RISK-001 | EVID-004                                         |
| RISK-002 | EVID-003, EVID-009                               |
| RISK-003 | EVID-003, EVID-012                               |
| RISK-004 | EVID-003, EVID-008                               |
| RISK-005 | EVID-009                                         |
| RISK-006 | EVID-006                                         |
| RISK-007 | EVID-003                                         |
| RISK-008 | EVID-005                                         |
| RISK-009 | EVID-009                                         |
| RISK-010 | EVID-001, EVID-002, EVID-003, EVID-010, EVID-011 |
| RISK-011 | EVID-003                                         |
| RISK-012 | EVID-008                                         |
| RISK-013 | EVID-008                                         |
| RISK-014 | EVID-005, EVID-007                               |

---

## Validation Targets

Future `monad risk check` or `monad trace check` should validate:

1. Every risk has a stable ID.
2. Every risk has a status.
3. Every risk has a severity.
4. Every risk has an owner role.
5. Every high or critical risk has at least one control.
6. Every high or critical risk has related evidence.
7. Referenced requirements exist.
8. Referenced ADRs exist.
9. Referenced work packets exist.
10. Referenced policies exist.
11. Referenced findings exist.
12. Referenced evidence IDs exist.

Initial validation should warn before it fails.

---

## Maintenance Rules

Update this file when:

```text
new risks are discovered
risks become mitigated
controls change
release evidence changes
policies change
work-packet scope changes
architecture decisions change
```

Do not reuse risk IDs.

Closed risks remain reserved for traceability.

---

## Final Rule

A Monad risk should be connected to controls and evidence.

Risks without controls are warnings.

Controls without evidence are assumptions.
