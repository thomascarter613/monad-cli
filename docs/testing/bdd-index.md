# Monad BDD Scenario Index

## Purpose

This document is the operational BDD scenario registry for Monad OS / Monad CLI.

It normalizes behavior-driven scenarios into stable IDs so product requirements, ADRs, work packets, tests, policies, findings, risks, and release evidence can be cross-linked.

The full BDD planning narrative lives in:

```text id="nnq6ww"
docs/planning/0013-BDD-specification-set.md
```

This file is the concise registry intended for ongoing maintenance and future validation.

---

## BDD Doctrine

BDD scenarios define product promises in user-observable terms.

A Monad BDD scenario should answer:

```text id="o3e5rf"
Given this repository state,
when the user runs this command or workflow,
then Monad should produce this behavior safely and deterministically.
```

BDD scenarios should preserve Monad’s core doctrine:

```text id="w0j8fh"
local-first before hosted
deterministic before AI
read-only before mutation
plan-backed before mutation
honest commands before deep commands
policy explanation before policy enforcement
```

---

## BDD ID Format

BDD scenarios use:

```text id="u96ycy"
BDD-DOMAIN-NNN
```

Examples:

```text id="k0a6sn"
BDD-VERSION-001
BDD-CATALOG-002
BDD-MANIFEST-003
BDD-APPLY-SAFE-001
```

BDD IDs are stable and must not be reused.

---

## Recommended Domains

| Domain     | Purpose                                      |
| ---------- | -------------------------------------------- |
| VERSION    | Version reporting behavior                   |
| CATALOG    | Command catalog and command honesty behavior |
| CONFIG     | Configuration behavior                       |
| MANIFEST   | Manifest/source-of-truth behavior            |
| INSPECT    | Repository inspection behavior               |
| CHECK      | Repository validation behavior               |
| DOCTOR     | Diagnostics/remediation behavior             |
| GRAPH      | Lifecycle graph behavior                     |
| CONTEXT    | Context handoff and context pack behavior    |
| DOCS       | Documentation validation behavior            |
| ADR        | ADR lifecycle behavior                       |
| WORKPACKET | Work-packet lifecycle behavior               |
| POLICY     | Policy and waiver behavior                   |
| PLAN       | Plan creation and plan validation behavior   |
| APPLY      | Apply and mutation behavior                  |
| NATIVE     | Native tool coordination behavior            |
| AI         | AI-optional behavior                         |
| NETWORK    | No-network behavior                          |
| TELEMETRY  | No-telemetry behavior                        |
| RELEASE    | Release readiness behavior                   |

---

## BDD Status Values

Allowed BDD scenario statuses:

```text id="ubm8r2"
draft
specified
implemented
passing
blocked
future
```

| Status      | Meaning                                                    |
| ----------- | ---------------------------------------------------------- |
| draft       | Scenario is being shaped and may change.                   |
| specified   | Scenario is accepted as expected behavior.                 |
| implemented | Implementation exists, but validation may not be complete. |
| passing     | Scenario is implemented and test evidence passes.          |
| blocked     | Scenario cannot proceed due to dependency or decision.     |
| future      | Scenario is intentionally deferred.                        |

---

## BDD Scenario Summary

| BDD ID                 | Scenario                                                  | Status    | Related Requirement | Related Work Packet | Test Type        |
| ---------------------- | --------------------------------------------------------- | --------- | ------------------- | ------------------- | ---------------- |
| BDD-VERSION-001        | Version command reports version                           | specified | FR-001              | WP-0001, WP-0008    | CLI smoke        |
| BDD-VERSION-002        | Version command works outside a repository                | specified | FR-001              | WP-0001, WP-0008    | CLI smoke        |
| BDD-CATALOG-001        | Command catalog lists known commands                      | specified | FR-002              | WP-0001, WP-0020    | Catalog unit     |
| BDD-CATALOG-002        | Command catalog marks planned commands                    | specified | FR-002              | WP-0001, WP-0020    | Catalog unit     |
| BDD-CATALOG-003        | Mutating commands declare mutation metadata               | specified | FR-002              | WP-0020             | Contract         |
| BDD-CATALOG-004        | Placeholder commands are honest                           | specified | FR-002              | WP-0020             | Contract         |
| BDD-CATALOG-005        | List command shows implemented commands                   | specified | FR-003              | WP-0008             | CLI smoke        |
| BDD-CATALOG-006        | List command marks planned commands                       | specified | FR-003              | WP-0008             | Snapshot         |
| BDD-CATALOG-007        | List command does not imply placeholders are implemented  | specified | FR-003              | WP-0008, WP-0020    | Contract         |
| BDD-MANIFEST-001       | `monad.toml` is canonical                                 | specified | FR-004              | WP-0002             | Fixture          |
| BDD-MANIFEST-002       | `workspace.toml` conflict is reported                     | specified | FR-004              | WP-0002, WP-0021    | Fixture          |
| BDD-MANIFEST-003       | Missing manifest is diagnosed                             | specified | FR-004              | WP-0002, WP-0008    | Fixture          |
| BDD-CONFIG-001         | Config command explains source of truth                   | specified | FR-004              | WP-0008             | CLI integration  |
| BDD-INSPECT-001        | Inspect reports repository structure                      | specified | FR-005              | WP-0008             | Fixture          |
| BDD-INSPECT-002        | Inspect detects native manifests                          | specified | FR-005              | WP-0008, WP-0024    | Fixture          |
| BDD-INSPECT-003        | Inspect is read-only                                      | specified | FR-005, NFR-009     | WP-0003, WP-0008    | Mutation safety  |
| BDD-NATIVE-001         | Native tools are detected but not replaced                | specified | FR-005              | WP-0009, WP-0024    | Adapter          |
| BDD-CHECK-001          | Check passes valid repository                             | specified | FR-006              | WP-0008             | Fixture          |
| BDD-CHECK-002          | Check reports invalid repository                          | specified | FR-006              | WP-0008             | Fixture          |
| BDD-CHECK-003          | Check CI mode exits nonzero on blocking findings          | specified | FR-006, NFR-008     | WP-0008             | CLI integration  |
| BDD-DOCTOR-001         | Doctor reports actionable diagnostics                     | specified | FR-007              | WP-0008, WP-0027    | Fixture          |
| BDD-DOCTOR-002         | Doctor reports manifest conflict remediation              | specified | FR-007              | WP-0008, WP-0027    | Fixture          |
| BDD-DOCTOR-003         | Doctor handles missing optional native tools              | specified | FR-007              | WP-0008, WP-0024    | Fixture          |
| BDD-GRAPH-001          | Graph emits repository lifecycle nodes                    | specified | FR-008              | WP-0010             | Graph invariant  |
| BDD-GRAPH-002          | Graph edges reference existing nodes                      | specified | FR-008              | WP-0010             | Graph invariant  |
| BDD-GRAPH-003          | Mermaid graph output is deterministic                     | specified | FR-008, NFR-002     | WP-0010             | Snapshot         |
| BDD-GRAPH-004          | Graph JSON validates schema                               | future    | FR-008, NFR-007     | WP-0010, WP-0026    | Schema           |
| BDD-CONTEXT-001        | Context handoff works without AI                          | specified | FR-009, NFR-005     | WP-0012             | Fixture          |
| BDD-CONTEXT-SECRET-001 | Context excludes likely secrets                           | specified | FR-009              | WP-0012             | Security fixture |
| BDD-AI-OPTIONAL-001    | Core workflow does not require AI provider                | specified | NFR-005             | WP-0012, WP-0026    | No-AI            |
| BDD-DOCS-001           | Docs check reports missing required docs                  | specified | FR-010              | WP-0011             | Docs fixture     |
| BDD-DOCS-002           | Docs check validates planning index                       | specified | FR-010              | WP-0011             | Docs fixture     |
| BDD-DOCS-003           | Docs check warns about broken cross-links                 | specified | FR-010              | WP-0011, WP-0025    | Cross-link       |
| BDD-ADR-001            | ADR list reports known ADRs                               | specified | FR-010              | WP-0011             | Docs fixture     |
| BDD-ADR-002            | ADR validate reports invalid status                       | specified | FR-010              | WP-0011             | Docs fixture     |
| BDD-WORKPACKET-001     | Work-packet index lists known work packets                | specified | FR-010              | WP-0000, WP-0011    | Docs fixture     |
| BDD-WORKPACKET-002     | Work-packet files use stable IDs                          | specified | FR-010              | WP-0000, WP-0011    | Docs fixture     |
| BDD-WORKPACKET-003     | Work-packet files include required sections               | specified | FR-010              | WP-0000, WP-0011    | Docs fixture     |
| BDD-POLICY-001         | Policy check reports canonical manifest violation         | specified | FR-006              | WP-0013             | Policy fixture   |
| BDD-POLICY-002         | Policy explain gives remediation                          | specified | FR-006              | WP-0013             | Policy fixture   |
| BDD-POLICY-WAIVER-001  | Expired waiver is reported                                | future    | FR-006              | WP-0013             | Policy fixture   |
| BDD-PLAN-001           | Plan creation produces reviewable plan                    | specified | FR-011              | WP-0004             | Plan schema      |
| BDD-PLAN-002           | Plan creation does not modify files                       | specified | FR-011              | WP-0004             | Mutation safety  |
| BDD-PLAN-DRYRUN-001    | Dry-run can evaluate a plan without writing               | specified | FR-011, FR-012      | WP-0004             | Mutation safety  |
| BDD-APPLY-001          | Apply requires valid plan                                 | specified | FR-012              | WP-0004             | Apply contract   |
| BDD-APPLY-002          | Dry-run writes nothing                                    | specified | FR-012, NFR-009     | WP-0004             | Mutation safety  |
| BDD-APPLY-SAFE-001     | Apply writes only planned operations                      | specified | FR-012, NFR-010     | WP-0004             | Mutation safety  |
| BDD-APPLY-SAFE-002     | Unsafe mutation is blocked                                | specified | FR-012, NFR-010     | WP-0003, WP-0004    | Mutation safety  |
| BDD-NETWORK-001        | Core commands do not call network by default              | specified | NFR-003             | WP-0003, WP-0017    | Security gate    |
| BDD-TELEMETRY-001      | Monad sends no telemetry by default                       | specified | NFR-004             | WP-0017             | Security gate    |
| BDD-RELEASE-001        | Release readiness reports required evidence               | future    | NFR-008             | WP-0015, WP-0030    | Release fixture  |
| BDD-RELEASE-002        | Release readiness fails when required evidence is missing | future    | NFR-008             | WP-0015, WP-0030    | Release fixture  |

---

# Detailed Scenario Registry

## BDD-VERSION-001: Version command reports version

Status: Specified
Related Requirements: FR-001
Related ADRs: ADR-0001, ADR-0012
Related Work Packets: WP-0001, WP-0008
Related Policies: POLICY-COMMAND-CATALOG
Related Findings: None yet.
Test Type: CLI smoke test

### Scenario

Given the user has installed the `monad` binary, when they run:

```bash id="vv2glp"
monad version
```

then Monad reports its current version and exits successfully.

---

## BDD-VERSION-002: Version command works outside a repository

Status: Specified
Related Requirements: FR-001, NFR-001
Related ADRs: ADR-0001, ADR-0003
Related Work Packets: WP-0001, WP-0008
Related Policies: POLICY-AI-OPTIONAL, POLICY-NO-NETWORK-BY-DEFAULT
Related Findings: None yet.
Test Type: CLI smoke test

### Scenario

Given the current directory is not a Monad repository, when the user runs:

```bash id="ew6suj"
monad version
```

then Monad reports its version without requiring repository discovery, network access, or AI configuration.

---

## BDD-CATALOG-001: Command catalog lists known commands

Status: Specified
Related Requirements: FR-002
Related ADRs: ADR-0012
Related Work Packets: WP-0001, WP-0020
Related Policies: POLICY-COMMAND-CATALOG
Related Findings: COMMAND-CATALOG-DRIFT
Test Type: Catalog unit test

### Scenario

Given the command catalog is loaded, when Monad lists catalog entries, then every known command has metadata including name, status, category, and implementation state.

---

## BDD-CATALOG-002: Command catalog marks planned commands

Status: Specified
Related Requirements: FR-002
Related ADRs: ADR-0012
Related Work Packets: WP-0001, WP-0020
Related Policies: POLICY-COMMAND-CATALOG, POLICY-PLACEHOLDER-HONESTY
Related Findings: COMMAND-PLACEHOLDER-MISLEADING
Test Type: Catalog unit test

### Scenario

Given a command is planned but not implemented, when the command appears in the catalog, then it is clearly marked as planned, placeholder, or future.

---

## BDD-CATALOG-003: Mutating commands declare mutation metadata

Status: Specified
Related Requirements: FR-002, NFR-010
Related ADRs: ADR-0006, ADR-0012
Related Work Packets: WP-0020
Related Policies: POLICY-NO-UNSAFE-MUTATION
Related Findings: MUTATION-PLAN-REQUIRED
Test Type: Command contract test

### Scenario

Given a command may modify repository files, when it is listed in the command catalog, then its metadata declares mutation behavior and whether it is plan-backed.

---

## BDD-CATALOG-004: Placeholder commands are honest

Status: Specified
Related Requirements: FR-002, FR-003
Related ADRs: ADR-0012
Related Work Packets: WP-0020
Related Policies: POLICY-PLACEHOLDER-HONESTY
Related Findings: COMMAND-PLACEHOLDER-MISLEADING
Test Type: Command contract test

### Scenario

Given a placeholder command exists, when the user invokes or lists it, then Monad clearly indicates the command is not fully implemented.

---

## BDD-MANIFEST-001: `monad.toml` is canonical

Status: Specified
Related Requirements: FR-004
Related ADRs: ADR-0005
Related Work Packets: WP-0002
Related Policies: POLICY-CANONICAL-MANIFEST
Related Findings: MANIFEST-CANONICAL-CONFLICT
Test Type: Manifest fixture test

### Scenario

Given a repository contains `monad.toml`, when Monad resolves workspace configuration, then `monad.toml` is treated as the canonical manifest.

---

## BDD-MANIFEST-002: `workspace.toml` conflict is reported

Status: Specified
Related Requirements: FR-004
Related ADRs: ADR-0005
Related Work Packets: WP-0002, WP-0021
Related Policies: POLICY-CANONICAL-MANIFEST
Related Findings: MANIFEST-CANONICAL-CONFLICT
Test Type: Fixture integration test

### Scenario

Given a repository contains both `monad.toml` and `workspace.toml` with conflicting values, when Monad checks the workspace, then it reports the conflict and treats `monad.toml` as canonical.

---

## BDD-INSPECT-003: Inspect is read-only

Status: Specified
Related Requirements: FR-005, NFR-009
Related ADRs: ADR-0003, ADR-0006
Related Work Packets: WP-0003, WP-0008
Related Policies: POLICY-NO-UNSAFE-MUTATION
Related Findings: APPLY-UNPLANNED-FILE-OP
Test Type: Mutation safety test

### Scenario

Given a repository fixture, when the user runs:

```bash id="3eoc5s"
monad inspect
```

then Monad reports repository structure without creating, modifying, or deleting canonical files.

---

## BDD-CONTEXT-SECRET-001: Context excludes likely secrets

Status: Specified
Related Requirements: FR-009
Related ADRs: ADR-0004, ADR-0011
Related Work Packets: WP-0012
Related Policies: POLICY-SECRET-REDACTION
Related Findings: CONTEXT-SECRET-RISK
Test Type: Security fixture test

### Scenario

Given a repository contains likely secret files, when Monad generates a context handoff, then likely secrets are excluded or redacted by default.

---

## BDD-PLAN-DRYRUN-001: Dry-run can evaluate a plan without writing

Status: Specified
Related Requirements: FR-011, FR-012, NFR-010
Related ADRs: ADR-0006
Related Work Packets: WP-0004
Related Policies: POLICY-NO-UNSAFE-MUTATION
Related Findings: MUTATION-PLAN-REQUIRED
Test Type: Mutation safety test

### Scenario

Given a valid plan file, when the user runs:

```bash id="u2jxlz"
monad apply plan.json --dry-run
```

then Monad evaluates the plan and reports intended effects without writing files.

---

## BDD-APPLY-SAFE-001: Apply writes only planned operations

Status: Specified
Related Requirements: FR-012, NFR-010
Related ADRs: ADR-0006
Related Work Packets: WP-0004, WP-0022
Related Policies: POLICY-NO-UNSAFE-MUTATION
Related Findings: APPLY-UNPLANNED-FILE-OP
Test Type: Apply contract test

### Scenario

Given a valid approved plan, when Monad applies it, then only file operations declared in the plan are executed.

---

## BDD-AI-OPTIONAL-001: Core workflow does not require AI provider

Status: Specified
Related Requirements: FR-009, NFR-005
Related ADRs: ADR-0004, ADR-0011
Related Work Packets: WP-0012, WP-0026
Related Policies: POLICY-AI-OPTIONAL
Related Findings: AI-REQUIRED-FOR-CORE-COMMAND
Test Type: No-AI test

### Scenario

Given no AI provider is configured, when the user runs core Monad workflows, then those workflows still provide deterministic local value.

---

## BDD-NETWORK-001: Core commands do not call network by default

Status: Specified
Related Requirements: NFR-001, NFR-003
Related ADRs: ADR-0003, ADR-0004
Related Work Packets: WP-0003, WP-0017
Related Policies: POLICY-NO-NETWORK-BY-DEFAULT
Related Findings: NETWORK-CALL-UNEXPECTED
Test Type: Security gate / review gate

### Scenario

Given the user runs core Monad commands, when no explicit network-enabled option is provided, then Monad does not intentionally call external network services.

---

## BDD-TELEMETRY-001: Monad sends no telemetry by default

Status: Specified
Related Requirements: NFR-004
Related ADRs: ADR-0003
Related Work Packets: WP-0017
Related Policies: POLICY-NO-TELEMETRY-BY-DEFAULT
Related Findings: TELEMETRY-UNEXPECTED
Test Type: Security gate / review gate

### Scenario

Given the user runs Monad, when no explicit telemetry option is configured, then Monad sends no telemetry by default.

---

## Validation Targets

Future `monad bdd validate` or `monad trace check` should validate:

1. Every BDD ID matches `BDD-DOMAIN-NNN`.
2. Every BDD status uses an allowed value.
3. Every BDD scenario maps to at least one requirement.
4. Every BDD scenario maps to at least one work packet.
5. Every BDD scenario has a test type.
6. Every referenced requirement exists.
7. Every referenced ADR exists.
8. Every referenced work packet exists.
9. Every referenced policy exists.
10. Every referenced finding exists.

Initial validation should warn before it fails.

---

## Maintenance Rules

Update this file when:

```text id="odymaw"
requirements change
work packets change
BDD scenarios are added
test strategy changes
policy or finding IDs change
release evidence expectations change
```

Do not reuse BDD IDs.

---

## Final Rule

A Monad BDD scenario should be stable enough to become a test and clear enough to prove a product promise.
