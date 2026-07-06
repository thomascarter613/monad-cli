# Monad Traceability Matrix

## Purpose

This document is the operational traceability matrix for Monad OS / Monad CLI.

It connects:

```text
business goals
user needs
requirements
ADRs
work packets
BDD scenarios
tests
policies
findings
risks
release evidence
documentation
```

The full planning narrative lives in:

```text
docs/planning/0018-traceability-matrix.md
```

This file is the concise governance registry intended for ongoing maintenance and future machine validation.

---

## Traceability Doctrine

Monad should be able to explain:

```text
why an artifact exists
what requirement it serves
what decision shaped it
what work packet delivers it
what test proves it
what policy governs it
what risk it mitigates
what release evidence proves readiness
```

Traceability should remain local-first and repository-native.

No hosted GRC system, external requirements database, or SaaS tracker is required for core traceability.

---

## Traceability Chain

Monad’s primary traceability chain is:

```text
Requirement
  -> ADR
    -> Work Packet
      -> BDD Scenario
        -> Test Evidence
          -> Policy / Finding / Risk
            -> Release Evidence
```

A mature release should be able to trace critical behavior across that chain.

---

## Registry Sources

| Registry             | Source File                                   |
| -------------------- | --------------------------------------------- |
| ID conventions       | `docs/reference/ids.md`                       |
| Requirements         | `docs/product/requirements-index.md`          |
| ADRs                 | `docs/architecture/decision-records/index.md` |
| Work Packets         | `docs/roadmap/work-packets/index.md`          |
| BDD Scenarios        | `docs/testing/bdd-index.md`                   |
| Findings             | `docs/reference/findings.md`                  |
| Risks                | `governance/risk-register.md`                 |
| Release Evidence     | `docs/reference/release-evidence.md`          |
| Full Planning Matrix | `docs/planning/0018-traceability-matrix.md`   |

---

# Requirement to ADR to Work Packet Matrix

| Requirement                                   | ADRs                         | Work Packets                                |
| --------------------------------------------- | ---------------------------- | ------------------------------------------- |
| FR-001: Version Reporting                     | ADR-0001, ADR-0012           | WP-0001, WP-0008, WP-0020                   |
| FR-002: Command Catalog                       | ADR-0012                     | WP-0001, WP-0020                            |
| FR-003: List Commands                         | ADR-0012                     | WP-0001, WP-0008, WP-0020                   |
| FR-004: Configuration and Manifest Resolution | ADR-0003, ADR-0005           | WP-0002, WP-0005, WP-0008, WP-0021          |
| FR-005: Repository Inspection                 | ADR-0002, ADR-0003, ADR-0008 | WP-0008, WP-0024                            |
| FR-006: Baseline Check                        | ADR-0005, ADR-0010, ADR-0012 | WP-0008, WP-0013, WP-0025                   |
| FR-007: Doctor Diagnostics                    | ADR-0002, ADR-0003, ADR-0005 | WP-0008, WP-0027                            |
| FR-008: Lifecycle Graph                       | ADR-0008, ADR-0009, ADR-0010 | WP-0010, WP-0026                            |
| FR-009: Context Handoff                       | ADR-0004, ADR-0011           | WP-0012, WP-0026                            |
| FR-010: Documentation Check                   | ADR-0009                     | WP-0011, WP-0025                            |
| FR-011: Plan Creation                         | ADR-0004, ADR-0006           | WP-0004, WP-0022                            |
| FR-012: Apply With Approval                   | ADR-0006                     | WP-0004, WP-0022                            |
| NFR-001: Local-First Operation                | ADR-0003                     | WP-0001, WP-0002, WP-0008                   |
| NFR-002: Deterministic Behavior               | ADR-0001, ADR-0003, ADR-0011 | WP-0001, WP-0002, WP-0008, WP-0010, WP-0012 |
| NFR-003: No Network by Default                | ADR-0003, ADR-0004           | WP-0003, WP-0017, WP-0024                   |
| NFR-004: No Telemetry by Default              | ADR-0003                     | WP-0017                                     |
| NFR-005: AI Optionality                       | ADR-0004, ADR-0011           | WP-0012, WP-0026                            |
| NFR-006: No Required Database                 | ADR-0003, ADR-0008           | WP-0002, WP-0010                            |
| NFR-007: Structured Output                    | ADR-0001, ADR-0008           | WP-0008, WP-0010, WP-0015                   |
| NFR-008: Stable Exit Codes                    | ADR-0012                     | WP-0008, WP-0017, WP-0020                   |
| NFR-009: Read-Only Safety                     | ADR-0003, ADR-0006           | WP-0003, WP-0008, WP-0011                   |
| NFR-010: Plan-Backed Mutation                 | ADR-0006                     | WP-0003, WP-0004, WP-0014, WP-0022          |

---

# Requirement to BDD to Test Matrix

| Requirement | BDD Scenarios                                                        | Primary Test Evidence                              |
| ----------- | -------------------------------------------------------------------- | -------------------------------------------------- |
| FR-001      | BDD-VERSION-001, BDD-VERSION-002                                     | CLI smoke tests                                    |
| FR-002      | BDD-CATALOG-001, BDD-CATALOG-002, BDD-CATALOG-003, BDD-CATALOG-004   | command catalog unit tests, command contract tests |
| FR-003      | BDD-CATALOG-005, BDD-CATALOG-006, BDD-CATALOG-007                    | CLI smoke tests, snapshot tests                    |
| FR-004      | BDD-MANIFEST-001, BDD-MANIFEST-002, BDD-MANIFEST-003, BDD-CONFIG-001 | manifest unit tests, fixture integration tests     |
| FR-005      | BDD-INSPECT-001, BDD-INSPECT-002, BDD-INSPECT-003                    | inspection fixture tests, read-only safety tests   |
| FR-006      | BDD-CHECK-001, BDD-CHECK-002, BDD-CHECK-003                          | check fixture tests, exit code tests               |
| FR-007      | BDD-DOCTOR-001, BDD-DOCTOR-002, BDD-DOCTOR-003                       | doctor fixture tests, snapshot tests               |
| FR-008      | BDD-GRAPH-001, BDD-GRAPH-002, BDD-GRAPH-003, BDD-GRAPH-004           | graph invariant tests, schema tests                |
| FR-009      | BDD-CONTEXT-001, BDD-CONTEXT-SECRET-001, BDD-AI-OPTIONAL-001         | context fixture tests, redaction tests             |
| FR-010      | BDD-DOCS-001, BDD-DOCS-002, BDD-DOCS-003                             | docs fixture tests                                 |
| FR-011      | BDD-PLAN-001, BDD-PLAN-002, BDD-PLAN-DRYRUN-001                      | plan schema tests, mutation safety tests           |
| FR-012      | BDD-APPLY-001, BDD-APPLY-002, BDD-APPLY-SAFE-001, BDD-APPLY-SAFE-002 | apply contract tests, filesystem mutation tests    |
| NFR-001     | BDD-NETWORK-001, BDD-AI-OPTIONAL-001                                 | offline tests, no-AI tests                         |
| NFR-002     | BDD-GRAPH-003, BDD-CONTEXT-001                                       | snapshot tests, deterministic fixture tests        |
| NFR-003     | BDD-NETWORK-001                                                      | no-network tests or review gate                    |
| NFR-004     | BDD-TELEMETRY-001                                                    | telemetry review gate                              |
| NFR-005     | BDD-AI-OPTIONAL-001                                                  | no-AI tests                                        |
| NFR-009     | BDD-INSPECT-003, BDD-APPLY-002                                       | mutation safety tests                              |
| NFR-010     | BDD-PLAN-001, BDD-APPLY-SAFE-001                                     | plan/apply contract tests                          |

---

# Policy to Requirement to Finding Matrix

| Policy                         | Protected Requirements           | Findings                                                             |
| ------------------------------ | -------------------------------- | -------------------------------------------------------------------- |
| POLICY-CANONICAL-MANIFEST      | FR-004, FR-006, NFR-002          | MANIFEST-MISSING, MANIFEST-INVALID-TOML, MANIFEST-CANONICAL-CONFLICT |
| POLICY-COMMAND-CATALOG         | FR-002, FR-003, FR-006           | COMMAND-CATALOG-DRIFT                                                |
| POLICY-DOCS-REQUIRED           | FR-010, FR-006                   | DOCS-REQUIRED-MISSING                                                |
| POLICY-NO-UNSAFE-MUTATION      | FR-011, FR-012, NFR-009, NFR-010 | MUTATION-PLAN-REQUIRED, APPLY-UNPLANNED-FILE-OP                      |
| POLICY-SECRET-REDACTION        | FR-009                           | CONTEXT-SECRET-RISK                                                  |
| POLICY-PLACEHOLDER-HONESTY     | FR-002, FR-003, NFR-008          | COMMAND-PLACEHOLDER-MISLEADING                                       |
| POLICY-AI-OPTIONAL             | FR-009, NFR-001, NFR-005         | AI-REQUIRED-FOR-CORE-COMMAND                                         |
| POLICY-NO-NETWORK-BY-DEFAULT   | NFR-001, NFR-003                 | NETWORK-CALL-UNEXPECTED                                              |
| POLICY-NO-TELEMETRY-BY-DEFAULT | NFR-004                          | TELEMETRY-UNEXPECTED                                                 |
| POLICY-RELEASE-READINESS       | FR-011, FR-012, NFR-010          | RELEASE-EVIDENCE-MISSING, RELEASE-GATE-FAILED                        |

---

# Risk to Control to Evidence Matrix

| Risk                                        | Controls                                                   | Evidence                     |
| ------------------------------------------- | ---------------------------------------------------------- | ---------------------------- |
| RISK-001: Command Catalog Drift             | command catalog contract tests, placeholder honesty policy | EVID-004                     |
| RISK-002: Source-of-Truth Confusion         | canonical manifest policy, manifest fixture tests          | EVID-003, EVID-009           |
| RISK-003: Unsafe Mutation                   | plan-backed mutation, dry-run tests, apply contract tests  | EVID-003, EVID-012           |
| RISK-004: Secret Leakage                    | secret redaction policy, context redaction tests           | EVID-003, EVID-008           |
| RISK-005: AI Overreach                      | AI optionality policy, plan-backed AI suggestions          | EVID-009                     |
| RISK-006: Hosted Prematurity                | local-first ADR, hosted deferral in roadmap                | EVID-006                     |
| RISK-007: Native Tool Inconsistency         | native tool adapters, doctor diagnostics                   | EVID-003                     |
| RISK-008: Docs Drift                        | docs check, docs-required policy                           | EVID-005                     |
| RISK-009: Policy False Positives            | policy explain, waiver model                               | EVID-009                     |
| RISK-010: Release Regression                | release readiness checks, CI gate                          | EVID-001, EVID-002, EVID-003 |
| RISK-011: Schema Breakage                   | schema tests, versioned schemas                            | EVID-003                     |
| RISK-012: Hidden Network Calls              | no-network policy, review gate                             | EVID-008                     |
| RISK-013: Hidden Telemetry                  | no-telemetry policy, security review                       | EVID-008                     |
| RISK-014: Planning and Implementation Drift | traceability matrix, work-packet validation, dogfooding    | EVID-005, EVID-007           |

---

# Work Packet to Docs to Tests Matrix

| Work Packet             | Required Docs                                | Expected Tests                                      |
| ----------------------- | -------------------------------------------- | --------------------------------------------------- |
| WP-0000                 | work-packet specification, work-packet index | future work-packet validation fixtures              |
| WP-0001                 | CLI docs, command catalog docs               | CLI smoke tests, command contract tests             |
| WP-0002                 | manifest reference                           | manifest unit tests, fixture tests                  |
| WP-0003                 | filesystem safety docs                       | read-only safety tests, dry-run tests               |
| WP-0004                 | plan schema docs                             | plan schema tests, apply contract tests             |
| WP-0005                 | init command docs                            | init fixture tests, no-overwrite tests              |
| WP-0006                 | pack/template docs                           | template fixture tests                              |
| WP-0007                 | add/generate docs                            | generator fixture tests, plan-backed mutation tests |
| WP-0008                 | command docs                                 | CLI integration tests, fixture tests                |
| WP-0009                 | native tool coordination docs                | adapter tests, command invocation tests             |
| WP-0010                 | graph schema docs                            | graph invariant tests                               |
| WP-0011                 | docs/ADR/workpacket docs                     | docs fixture tests                                  |
| WP-0012                 | context handoff docs                         | context/redaction tests                             |
| WP-0013                 | policy/waiver docs                           | policy fixture tests                                |
| WP-0014                 | mutation command docs                        | mutation safety tests                               |
| WP-0015                 | release docs                                 | release readiness tests                             |
| WP-0016                 | testing strategy                             | full test matrix                                    |
| WP-0017                 | CI/security docs                             | CI, security, quality gates                         |
| WP-0018                 | dogfood docs                                 | dogfood test/report                                 |
| WP-0019 through WP-0031 | release hardening docs                       | release candidate evidence                          |

---

# Release Evidence to Source Matrix

| Evidence                                      | Source                                                    |
| --------------------------------------------- | --------------------------------------------------------- |
| EVID-001: Formatting Passed                   | `cargo fmt --all --check`                                 |
| EVID-002: Workspace Check Passed              | `cargo check --workspace`                                 |
| EVID-003: Test Suite Passed                   | `cargo test --workspace`                                  |
| EVID-004: Command Catalog Contract Passed     | `cargo test -p monad-cli --test command_catalog_contract` |
| EVID-005: Docs Check Passed                   | future `monad docs check`                                 |
| EVID-006: ADR Index Valid                     | future `monad adr validate`                               |
| EVID-007: Work Packet Index Valid             | future `monad workpacket validate`                        |
| EVID-008: Security Checks Passed              | security CI / review gate                                 |
| EVID-009: Policy Checks Passed                | future `monad policy check`                               |
| EVID-010: Release Notes Prepared              | release docs                                              |
| EVID-011: Changelog Updated                   | changelog file                                            |
| EVID-012: Apply Reports Present When Required | apply report artifacts                                    |

---

## Validation Targets

Future `monad trace check` should validate:

1. Every requirement referenced by this file exists.
2. Every ADR referenced by this file exists.
3. Every work packet referenced by this file exists.
4. Every BDD scenario referenced by this file exists.
5. Every policy referenced by this file exists.
6. Every finding referenced by this file exists.
7. Every risk referenced by this file exists.
8. Every release evidence ID referenced by this file exists.
9. Every P0 requirement has at least one related work packet.
10. Every P0 requirement has at least one planned or implemented test.
11. Every safety requirement has a related risk or policy.
12. Every release evidence ID has a source command or source artifact.

Initial validation should warn before it fails.

---

## Maintenance Rules

Update this file when:

```text
requirements are added, removed, renamed, or superseded
ADRs are accepted, proposed, superseded, or rejected
work packets are added, deferred, closed, or superseded
BDD scenarios are normalized
policies are added or changed
findings are added or changed
risks are added or closed
release evidence requirements change
```

Do not silently remove IDs.

Deprecated or superseded IDs should remain traceable.

---

## Final Rule

Monad’s traceability matrix should prove that the repository’s important artifacts are not isolated documents.

They are connected evidence in a local-first governance system.
