# Monad Release Evidence Reference

## Purpose

This document defines the operational release evidence registry for Monad OS / Monad CLI.

Release evidence connects tests, checks, documentation, policy, risk controls, work packets, and release readiness.

A release should not merely claim readiness. It should be able to point to evidence.

Future release workflows may use this registry through:

```bash id="z3m34d"
monad release readiness
monad trace check
monad docs check
monad policy check
```

---

## Release Evidence Doctrine

Monad is a governance-grade repository runtime.

A release should be supported by evidence that proves:

```text id="j3sccp"
the code formats
the workspace checks
the tests pass
the command surface is honest
the docs are updated
the ADR index is valid
the work-packet index is valid
security checks pass
policy checks pass
release notes exist
changelog is updated
required apply reports exist
```

Evidence should be local-first and reproducible where practical.

---

## Evidence ID Format

Release evidence IDs use:

```text id="wb0dea"
EVID-NNN
```

Examples:

```text id="6ums3z"
EVID-001
EVID-004
EVID-012
```

Evidence IDs are stable and must not be reused.

---

## Evidence Status Values

Allowed evidence statuses:

```text id="fgk2go"
required
produced
verified
missing
not-applicable
```

| Status         | Meaning                                                    |
| -------------- | ---------------------------------------------------------- |
| required       | Evidence is required for the release or gate.              |
| produced       | Evidence was generated but not yet independently verified. |
| verified       | Evidence exists and has been accepted.                     |
| missing        | Evidence is required but absent.                           |
| not-applicable | Evidence is not required for this release scope.           |

---

## Release Evidence Summary

| Evidence | Title                               | Source                                                    | Required For                     | Related Risks                |
| -------- | ----------------------------------- | --------------------------------------------------------- | -------------------------------- | ---------------------------- |
| EVID-001 | Formatting Passed                   | `cargo fmt --all --check`                                 | All releases                     | RISK-010                     |
| EVID-002 | Workspace Check Passed              | `cargo check --workspace`                                 | All releases                     | RISK-010                     |
| EVID-003 | Test Suite Passed                   | `cargo test --workspace`                                  | All releases                     | RISK-003, RISK-010, RISK-011 |
| EVID-004 | Command Catalog Contract Passed     | `cargo test -p monad-cli --test command_catalog_contract` | CLI-surface releases             | RISK-001                     |
| EVID-005 | Docs Check Passed                   | future `monad docs check`                                 | Docs/governance releases         | RISK-008, RISK-014           |
| EVID-006 | ADR Index Valid                     | future `monad adr validate`                               | Architecture/governance releases | RISK-006                     |
| EVID-007 | Work Packet Index Valid             | future `monad workpacket validate`                        | Roadmap/governance releases      | RISK-014                     |
| EVID-008 | Security Checks Passed              | security CI / review gate                                 | Security-sensitive releases      | RISK-004, RISK-012, RISK-013 |
| EVID-009 | Policy Checks Passed                | future `monad policy check`                               | Policy-governed releases         | RISK-002, RISK-005, RISK-009 |
| EVID-010 | Release Notes Prepared              | release notes artifact                                    | All public releases              | RISK-010                     |
| EVID-011 | Changelog Updated                   | changelog file                                            | All public releases              | RISK-010                     |
| EVID-012 | Apply Reports Present When Required | apply report artifacts                                    | Mutation releases                | RISK-003                     |

---

# Evidence Details

## EVID-001: Formatting Passed

Status: Required
Source Command:

```bash id="tq63lp"
cargo fmt --all --check
```

Owner Role: Release owner
Related Requirements: NFR-002
Related Work Packets: WP-0017, WP-0030, WP-0031
Related Risks: RISK-010

### Purpose

Proves Rust formatting is consistent.

### Required When

Required for all releases.

### Acceptance Criteria

1. Command exits successfully.
2. No formatting changes are required.
3. Evidence is captured in CI logs or release notes.

---

## EVID-002: Workspace Check Passed

Status: Required
Source Command:

```bash id="apsq8o"
cargo check --workspace
```

Owner Role: Release owner
Related Requirements: NFR-002
Related Work Packets: WP-0017, WP-0030, WP-0031
Related Risks: RISK-010

### Purpose

Proves the Rust workspace type-checks.

### Required When

Required for all releases.

### Acceptance Criteria

1. Command exits successfully.
2. All workspace crates check.
3. Warnings are reviewed according to project policy.

---

## EVID-003: Test Suite Passed

Status: Required
Source Command:

```bash id="fiy840"
cargo test --workspace
```

Owner Role: Release owner
Related Requirements: FR-001 through FR-012, NFR-001 through NFR-010
Related Work Packets: WP-0016, WP-0017, WP-0030, WP-0031
Related Risks: RISK-003, RISK-010, RISK-011

### Purpose

Proves the general test suite passes.

### Required When

Required for all releases.

### Acceptance Criteria

1. Command exits successfully.
2. No ignored critical tests without justification.
3. Test failures block release unless explicitly waived.

---

## EVID-004: Command Catalog Contract Passed

Status: Required for CLI-surface releases
Source Command:

```bash id="pmqtd4"
cargo test -p monad-cli --test command_catalog_contract
```

Owner Role: CLI maintainer
Related Requirements: FR-002, FR-003
Related ADRs: ADR-0012
Related Work Packets: WP-0001, WP-0008, WP-0020
Related Risks: RISK-001

### Purpose

Proves the command catalog and Clap surface remain aligned.

### Required When

Required when any CLI command, command catalog metadata, placeholder command, or command surface changes.

### Acceptance Criteria

1. Contract test exits successfully.
2. Every catalog command exposed through Clap is accounted for.
3. Placeholder/planned behavior remains honest.

---

## EVID-005: Docs Check Passed

Status: Required once implemented
Source Command:

```bash id="ojcz7b"
monad docs check
```

Owner Role: Documentation/governance owner
Related Requirements: FR-010
Related ADRs: ADR-0009
Related Work Packets: WP-0011, WP-0025
Related Risks: RISK-008, RISK-014

### Purpose

Proves required documentation exists and is structurally valid.

### Required When

Required after `monad docs check` exists, especially for docs/governance releases.

### Acceptance Criteria

1. Required docs exist.
2. Planning index exists.
3. ADR index exists.
4. Work-packet index exists.
5. Broken cross-links are reported.
6. Strict failures block release only after policy matures.

---

## EVID-006: ADR Index Valid

Status: Required once implemented
Source Command:

```bash id="4d0etr"
monad adr validate
```

Owner Role: Architecture owner
Related Requirements: FR-010
Related ADRs: ADR-0009
Related Work Packets: WP-0011
Related Risks: RISK-006, RISK-014

### Purpose

Proves ADRs are indexed, consistently structured, and traceable.

### Required When

Required for architecture-significant releases once ADR validation exists.

### Acceptance Criteria

1. ADR index exists.
2. ADR files referenced by the index exist.
3. Accepted ADRs have required relationship fields.
4. Superseded ADRs identify replacements.
5. ADR statuses use allowed values.

---

## EVID-007: Work Packet Index Valid

Status: Required once implemented
Source Command:

```bash id="ni2nm6"
monad workpacket validate
```

Owner Role: Delivery owner
Related Requirements: FR-010
Related Work Packets: WP-0000, WP-0011
Related Risks: RISK-014

### Purpose

Proves work-packet files are indexed and structurally valid.

### Required When

Required for roadmap/governance releases once work-packet validation exists.

### Acceptance Criteria

1. Work-packet index exists.
2. Referenced work-packet files exist.
3. Work-packet IDs match `WP-NNNN`.
4. Work-packet statuses use allowed values.
5. Required sections exist or are explicitly not applicable.

---

## EVID-008: Security Checks Passed

Status: Required for security-sensitive releases
Source Command:

```text id="nrrqbd"
security CI / review gate
```

Owner Role: Security owner
Related Requirements: NFR-003, NFR-004, FR-009
Related Work Packets: WP-0017
Related Risks: RISK-004, RISK-012, RISK-013

### Purpose

Proves security-sensitive release gates have passed.

### Required When

Required when changes affect context generation, filesystem access, network behavior, telemetry, dependencies, secrets, or mutation.

### Acceptance Criteria

1. Secret-handling changes are reviewed.
2. No-network-by-default posture is preserved.
3. No-telemetry-by-default posture is preserved.
4. Dependency/security scans pass where configured.
5. Exceptions are documented.

---

## EVID-009: Policy Checks Passed

Status: Required once implemented
Source Command:

```bash id="sjs8sn"
monad policy check
```

Owner Role: Governance/security owner
Related Requirements: FR-006, FR-010, NFR-010
Related ADRs: ADR-0010
Related Work Packets: WP-0013, WP-0025
Related Risks: RISK-002, RISK-005, RISK-009

### Purpose

Proves policy checks pass or produce accepted findings/waivers.

### Required When

Required after policy checks exist and for governance-sensitive releases.

### Acceptance Criteria

1. Policy check completes.
2. Blocking findings are resolved or explicitly waived.
3. Expired waivers are reported.
4. Policy output is explainable.

---

## EVID-010: Release Notes Prepared

Status: Required
Source Artifact:

```text id="letnd3"
release notes
```

Owner Role: Release owner
Related Requirements: NFR-008
Related Work Packets: WP-0015, WP-0030, WP-0031
Related Risks: RISK-010

### Purpose

Proves user-facing release changes are described.

### Required When

Required for all public releases.

### Acceptance Criteria

1. Release notes summarize meaningful changes.
2. Breaking changes are called out.
3. Known limitations are called out.
4. Upgrade notes are included where relevant.

---

## EVID-011: Changelog Updated

Status: Required
Source Artifact:

```text id="q4gjrk"
CHANGELOG.md
```

Owner Role: Release owner
Related Requirements: NFR-008
Related Work Packets: WP-0015, WP-0030, WP-0031
Related Risks: RISK-010

### Purpose

Proves release history is updated.

### Required When

Required for all public releases once changelog policy exists.

### Acceptance Criteria

1. Changelog entry exists.
2. Version is correct.
3. Date is correct.
4. Added/changed/fixed/deprecated/removed/security notes are included where applicable.

---

## EVID-012: Apply Reports Present When Required

Status: Required for mutation releases
Source Artifact:

```text id="xzmwb7"
apply report artifacts
```

Owner Role: Plan/change owner
Related Requirements: FR-012, NFR-010
Related ADRs: ADR-0006
Related Work Packets: WP-0004, WP-0022
Related Risks: RISK-003

### Purpose

Proves repository mutation was performed through an inspectable apply process.

### Required When

Required when release work includes plan-backed mutation, generated file application, migration, or destructive operations.

### Acceptance Criteria

1. Apply report exists when mutation occurred.
2. Report lists planned operations.
3. Report lists executed operations.
4. Report identifies skipped or failed operations.
5. Report includes rollback hints where relevant.

---

# Evidence-to-Risk Matrix

| Evidence | Related Risks                |
| -------- | ---------------------------- |
| EVID-001 | RISK-010                     |
| EVID-002 | RISK-010                     |
| EVID-003 | RISK-003, RISK-010, RISK-011 |
| EVID-004 | RISK-001                     |
| EVID-005 | RISK-008, RISK-014           |
| EVID-006 | RISK-006, RISK-014           |
| EVID-007 | RISK-014                     |
| EVID-008 | RISK-004, RISK-012, RISK-013 |
| EVID-009 | RISK-002, RISK-005, RISK-009 |
| EVID-010 | RISK-010                     |
| EVID-011 | RISK-010                     |
| EVID-012 | RISK-003                     |

---

# Evidence-to-Work-Packet Matrix

| Evidence | Related Work Packets               |
| -------- | ---------------------------------- |
| EVID-001 | WP-0017, WP-0030, WP-0031          |
| EVID-002 | WP-0017, WP-0030, WP-0031          |
| EVID-003 | WP-0016, WP-0017, WP-0030, WP-0031 |
| EVID-004 | WP-0001, WP-0008, WP-0020          |
| EVID-005 | WP-0011, WP-0025                   |
| EVID-006 | WP-0011                            |
| EVID-007 | WP-0000, WP-0011                   |
| EVID-008 | WP-0017                            |
| EVID-009 | WP-0013, WP-0025                   |
| EVID-010 | WP-0015, WP-0030, WP-0031          |
| EVID-011 | WP-0015, WP-0030, WP-0031          |
| EVID-012 | WP-0004, WP-0022                   |

---

## Minimal Current Release Gate

Before full Monad release readiness exists, the minimum local gate is:

```bash id="klyp8z"
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
```

For CLI command-surface changes, also run:

```bash id="4j01y1"
cargo test -p monad-cli --test command_catalog_contract
```

---

## Future Release Readiness Behavior

Future `monad release readiness` should report:

```text id="ybp2xt"
required evidence
produced evidence
missing evidence
not-applicable evidence
blocking failures
waived findings
release risks
recommended next action
```

It should not silently pass a release with missing critical evidence.

---

## Validation Targets

Future `monad release evidence validate` or `monad trace check` should validate:

1. Every evidence ID matches `EVID-NNN`.
2. Every evidence item has a title.
3. Every evidence item has a source command or source artifact.
4. Every evidence item has required conditions.
5. Every evidence item maps to at least one risk.
6. Every evidence item maps to at least one work packet.
7. Required evidence for a release is present.
8. Missing evidence is reported.
9. Not-applicable evidence has justification.

Initial validation should warn before it fails.

---

## Maintenance Rules

Update this file when:

```text id="d5f1sm"
new release gates are added
release process changes
policy checks change
test gates change
security checks change
work-packet validation changes
ADR validation changes
apply reporting changes
```

Do not reuse evidence IDs.

---

## Final Rule

A Monad release should be supported by evidence.

If the evidence does not exist, readiness should be treated as an assumption, not a fact.
