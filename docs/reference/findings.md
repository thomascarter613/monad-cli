# Monad Findings Reference

## Purpose

This document defines the operational findings registry for Monad OS / Monad CLI.

A finding is a stable, machine-readable diagnostic condition that Monad can report during checks, inspections, policy evaluation, context generation, plan validation, apply validation, docs validation, or release readiness.

Findings should be stable because they may appear in:

```text id="qrb8wy"
CLI output
JSON reports
CI logs
tests
documentation
policy reports
release evidence
future hosted dashboards
```

---

## Finding Doctrine

Findings are not random error messages.

A finding should have:

```text id="ci95vq"
stable ID
severity
category
message
related requirement
related policy
related work packet
remediation
```

A finding should answer:

```text id="fejdze"
What is wrong?
Why does it matter?
What should the user do next?
What requirement or policy does this protect?
```

---

## Finding ID Format

Findings use:

```text id="jap73z"
DOMAIN-STABLE-ID
```

Examples:

```text id="8cw4r9"
MANIFEST-MISSING
COMMAND-CATALOG-DRIFT
CONTEXT-SECRET-RISK
APPLY-UNPLANNED-FILE-OP
```

Finding IDs are stable and must not be reused.

---

## Severity Values

Allowed severity values:

```text id="k3oos3"
info
warning
error
critical
```

| Severity | Meaning                                                           |
| -------- | ----------------------------------------------------------------- |
| info     | Informational condition.                                          |
| warning  | Needs attention but may not block work.                           |
| error    | Should block strict validation or CI mode.                        |
| critical | Indicates unsafe, security-sensitive, or trust-breaking behavior. |

---

## Category Values

Recommended categories:

```text id="ek3wre"
manifest
workspace
command
docs
context
mutation
plan
apply
policy
network
telemetry
ai
release
```

---

## Findings Summary

| Finding ID                     | Severity | Category  | Related Policy                 | Related Requirement | Related Work Packet |
| ------------------------------ | -------- | --------- | ------------------------------ | ------------------- | ------------------- |
| MANIFEST-MISSING               | warning  | manifest  | POLICY-CANONICAL-MANIFEST      | FR-004              | WP-0002, WP-0008    |
| MANIFEST-INVALID-TOML          | error    | manifest  | POLICY-CANONICAL-MANIFEST      | FR-004              | WP-0002             |
| MANIFEST-CANONICAL-CONFLICT    | error    | manifest  | POLICY-CANONICAL-MANIFEST      | FR-004              | WP-0002, WP-0021    |
| WORKSPACE-NOT-FOUND            | warning  | workspace | None yet                       | FR-005              | WP-0008             |
| COMMAND-CATALOG-DRIFT          | error    | command   | POLICY-COMMAND-CATALOG         | FR-002, FR-003      | WP-0001, WP-0020    |
| COMMAND-PLACEHOLDER-MISLEADING | error    | command   | POLICY-PLACEHOLDER-HONESTY     | FR-002, FR-003      | WP-0020             |
| DOCS-REQUIRED-MISSING          | warning  | docs      | POLICY-DOCS-REQUIRED           | FR-010              | WP-0011             |
| CONTEXT-SECRET-RISK            | critical | context   | POLICY-SECRET-REDACTION        | FR-009              | WP-0012             |
| MUTATION-PLAN-REQUIRED         | critical | mutation  | POLICY-NO-UNSAFE-MUTATION      | FR-011, FR-012      | WP-0004             |
| PLAN-SCHEMA-INVALID            | error    | plan      | POLICY-NO-UNSAFE-MUTATION      | FR-011              | WP-0004             |
| APPLY-UNPLANNED-FILE-OP        | critical | apply     | POLICY-NO-UNSAFE-MUTATION      | FR-012              | WP-0004             |
| POLICY-WAIVER-EXPIRED          | warning  | policy    | POLICY-RELEASE-READINESS       | FR-006              | WP-0013             |
| NETWORK-CALL-UNEXPECTED        | critical | network   | POLICY-NO-NETWORK-BY-DEFAULT   | NFR-003             | WP-0017             |
| TELEMETRY-UNEXPECTED           | critical | telemetry | POLICY-NO-TELEMETRY-BY-DEFAULT | NFR-004             | WP-0017             |
| AI-REQUIRED-FOR-CORE-COMMAND   | error    | ai        | POLICY-AI-OPTIONAL             | NFR-005             | WP-0012             |
| WORKPACKET-INDEX-MISSING       | warning  | docs      | POLICY-DOCS-REQUIRED           | FR-010              | WP-0000, WP-0011    |
| WORKPACKET-FILE-MISSING        | warning  | docs      | POLICY-DOCS-REQUIRED           | FR-010              | WP-0000, WP-0011    |
| WORKPACKET-ID-INVALID          | warning  | docs      | POLICY-DOCS-REQUIRED           | FR-010              | WP-0000, WP-0011    |
| WORKPACKET-SECTION-MISSING     | warning  | docs      | POLICY-DOCS-REQUIRED           | FR-010              | WP-0000, WP-0011    |
| RELEASE-EVIDENCE-MISSING       | error    | release   | POLICY-RELEASE-READINESS       | NFR-008             | WP-0015             |
| RELEASE-GATE-FAILED            | error    | release   | POLICY-RELEASE-READINESS       | NFR-008             | WP-0015             |

---

# Finding Details

## MANIFEST-MISSING

Severity: Warning
Category: manifest
Related Policy: POLICY-CANONICAL-MANIFEST
Related Requirements: FR-004
Related Work Packets: WP-0002, WP-0008
Related Risks: RISK-002

### Message

No canonical `monad.toml` manifest was found.

### Why It Matters

Monad needs a canonical manifest to resolve workspace intent.

### Remediation

Create `monad.toml` or run a future plan-backed initialization workflow.

---

## MANIFEST-INVALID-TOML

Severity: Error
Category: manifest
Related Policy: POLICY-CANONICAL-MANIFEST
Related Requirements: FR-004
Related Work Packets: WP-0002
Related Risks: RISK-002

### Message

`monad.toml` exists but could not be parsed as valid TOML.

### Why It Matters

Invalid configuration prevents deterministic workspace resolution.

### Remediation

Fix the TOML syntax and rerun the command.

---

## MANIFEST-CANONICAL-CONFLICT

Severity: Error
Category: manifest
Related Policy: POLICY-CANONICAL-MANIFEST
Related Requirements: FR-004
Related ADRs: ADR-0005
Related Work Packets: WP-0002, WP-0021
Related Risks: RISK-002

### Message

`monad.toml` and `workspace.toml` contain conflicting workspace values.

### Why It Matters

`monad.toml` is canonical. Conflicts create source-of-truth ambiguity.

### Remediation

Update `workspace.toml` to match `monad.toml`, remove the mirror, or document the compatibility behavior.

---

## WORKSPACE-NOT-FOUND

Severity: Warning
Category: workspace
Related Policy: None yet
Related Requirements: FR-005
Related Work Packets: WP-0008
Related Risks: RISK-007

### Message

No recognized Monad workspace root was found.

### Why It Matters

Some repository-aware commands require workspace discovery.

### Remediation

Run the command from a repository root or initialize a Monad workspace later through a plan-backed workflow.

---

## COMMAND-CATALOG-DRIFT

Severity: Error
Category: command
Related Policy: POLICY-COMMAND-CATALOG
Related Requirements: FR-002, FR-003
Related ADRs: ADR-0012
Related Work Packets: WP-0001, WP-0020
Related Risks: RISK-001

### Message

The command catalog and CLI command surface do not match.

### Why It Matters

Monad’s command surface must be honest and test-backed.

### Remediation

Update the command catalog, CLI surface, or contract tests so they agree.

---

## COMMAND-PLACEHOLDER-MISLEADING

Severity: Error
Category: command
Related Policy: POLICY-PLACEHOLDER-HONESTY
Related Requirements: FR-002, FR-003
Related ADRs: ADR-0012
Related Work Packets: WP-0020
Related Risks: RISK-001

### Message

A placeholder or planned command may be presented as implemented behavior.

### Why It Matters

Users must be able to trust command status and safety metadata.

### Remediation

Mark the command as planned, placeholder, partial, or implemented accurately.

---

## DOCS-REQUIRED-MISSING

Severity: Warning
Category: docs
Related Policy: POLICY-DOCS-REQUIRED
Related Requirements: FR-010
Related ADRs: ADR-0009
Related Work Packets: WP-0011
Related Risks: RISK-008

### Message

A required documentation artifact is missing.

### Why It Matters

Monad treats documentation as source-of-truth governance material.

### Remediation

Add the missing documentation file or update the docs policy if the requirement changed.

---

## CONTEXT-SECRET-RISK

Severity: Critical
Category: context
Related Policy: POLICY-SECRET-REDACTION
Related Requirements: FR-009
Related ADRs: ADR-0004, ADR-0011
Related Work Packets: WP-0012
Related Risks: RISK-004

### Message

Context output may include likely secret or sensitive material.

### Why It Matters

Context handoff may be consumed by humans or AI tools. Secret leakage is a critical trust failure.

### Remediation

Exclude the sensitive path, redact the content, update default ignore rules, or require explicit user approval.

---

## MUTATION-PLAN-REQUIRED

Severity: Critical
Category: mutation
Related Policy: POLICY-NO-UNSAFE-MUTATION
Related Requirements: FR-011, FR-012, NFR-010
Related ADRs: ADR-0006
Related Work Packets: WP-0004
Related Risks: RISK-003

### Message

A repository mutation was requested without a valid plan.

### Why It Matters

Monad requires plan-backed mutation for risky repository changes.

### Remediation

Create a plan first, inspect it, then use dry-run before approved apply.

---

## PLAN-SCHEMA-INVALID

Severity: Error
Category: plan
Related Policy: POLICY-NO-UNSAFE-MUTATION
Related Requirements: FR-011
Related ADRs: ADR-0006
Related Work Packets: WP-0004
Related Risks: RISK-011

### Message

The plan does not conform to the expected plan schema.

### Why It Matters

Invalid plans cannot be safely reviewed or applied.

### Remediation

Fix the plan structure, regenerate the plan, or update schema handling if the schema changed intentionally.

---

## APPLY-UNPLANNED-FILE-OP

Severity: Critical
Category: apply
Related Policy: POLICY-NO-UNSAFE-MUTATION
Related Requirements: FR-012
Related ADRs: ADR-0006
Related Work Packets: WP-0004
Related Risks: RISK-003

### Message

Apply attempted a file operation not declared in the plan.

### Why It Matters

Apply must only execute planned operations.

### Remediation

Block the operation, inspect the apply report, and fix the plan/apply engine before retrying.

---

## POLICY-WAIVER-EXPIRED

Severity: Warning
Category: policy
Related Policy: POLICY-RELEASE-READINESS
Related Requirements: FR-006
Related Work Packets: WP-0013
Related Risks: RISK-009

### Message

A policy waiver has expired.

### Why It Matters

Expired waivers weaken governance and release readiness.

### Remediation

Remove the waiver, renew it with justification, or fix the underlying policy violation.

---

## NETWORK-CALL-UNEXPECTED

Severity: Critical
Category: network
Related Policy: POLICY-NO-NETWORK-BY-DEFAULT
Related Requirements: NFR-003
Related ADRs: ADR-0003, ADR-0004
Related Work Packets: WP-0017
Related Risks: RISK-012

### Message

A core command attempted network access without explicit user intent.

### Why It Matters

Monad is local-first and should not call network by default.

### Remediation

Remove the network call, guard it behind explicit configuration, or document and test the exception.

---

## TELEMETRY-UNEXPECTED

Severity: Critical
Category: telemetry
Related Policy: POLICY-NO-TELEMETRY-BY-DEFAULT
Related Requirements: NFR-004
Related ADRs: ADR-0003
Related Work Packets: WP-0017
Related Risks: RISK-013

### Message

Telemetry behavior was detected or introduced without explicit opt-in.

### Why It Matters

No telemetry by default is a trust requirement.

### Remediation

Remove telemetry, make it explicit opt-in, and document it through ADR/security review.

---

## AI-REQUIRED-FOR-CORE-COMMAND

Severity: Error
Category: ai
Related Policy: POLICY-AI-OPTIONAL
Related Requirements: NFR-005
Related ADRs: ADR-0004, ADR-0011
Related Work Packets: WP-0012
Related Risks: RISK-005

### Message

A core Monad command requires an AI provider.

### Why It Matters

Monad is AI-ready but AI-optional.

### Remediation

Provide deterministic non-AI behavior or move AI-dependent behavior behind an explicit optional path.

---

## WORKPACKET-INDEX-MISSING

Severity: Warning
Category: docs
Related Policy: POLICY-DOCS-REQUIRED
Related Requirements: FR-010
Related Work Packets: WP-0000, WP-0011
Related Risks: RISK-014

### Message

The work-packet index is missing.

### Remediation

Create `docs/roadmap/work-packets/index.md`.

---

## WORKPACKET-FILE-MISSING

Severity: Warning
Category: docs
Related Policy: POLICY-DOCS-REQUIRED
Related Requirements: FR-010
Related Work Packets: WP-0000, WP-0011
Related Risks: RISK-014

### Message

A work packet listed in the index does not have a corresponding file.

### Remediation

Create the missing work-packet file or update the index.

---

## WORKPACKET-ID-INVALID

Severity: Warning
Category: docs
Related Policy: POLICY-DOCS-REQUIRED
Related Requirements: FR-010
Related Work Packets: WP-0000, WP-0011
Related Risks: RISK-014

### Message

A work-packet ID does not match the expected `WP-NNNN` format.

### Remediation

Update the ID to match the canonical format without reusing existing IDs.

---

## WORKPACKET-SECTION-MISSING

Severity: Warning
Category: docs
Related Policy: POLICY-DOCS-REQUIRED
Related Requirements: FR-010
Related Work Packets: WP-0000, WP-0011
Related Risks: RISK-014

### Message

A work packet is missing a required or expected section.

### Remediation

Add the missing section or mark it intentionally not applicable.

---

## RELEASE-EVIDENCE-MISSING

Severity: Error
Category: release
Related Policy: POLICY-RELEASE-READINESS
Related Requirements: NFR-008
Related Work Packets: WP-0015, WP-0030
Related Risks: RISK-010, RISK-014

### Message

Required release evidence is missing.

### Remediation

Produce the missing evidence or update release readiness requirements if the evidence is no longer applicable.

---

## RELEASE-GATE-FAILED

Severity: Error
Category: release
Related Policy: POLICY-RELEASE-READINESS
Related Requirements: NFR-008
Related Work Packets: WP-0015, WP-0030
Related Risks: RISK-010

### Message

A release gate failed.

### Remediation

Fix the failing gate before release or document an explicit release exception.

---

## Validation Targets

Future `monad findings validate` or `monad trace check` should validate:

1. Every finding ID is unique.
2. Every finding has severity.
3. Every finding has category.
4. Every finding has a message.
5. Every finding has remediation.
6. Every referenced requirement exists.
7. Every referenced policy exists.
8. Every referenced work packet exists.
9. Every referenced risk exists.
10. Critical findings map to at least one risk.

Initial validation should warn before it fails.

---

## Final Rule

A Monad finding should be stable enough for automation and clear enough for a human to fix.
