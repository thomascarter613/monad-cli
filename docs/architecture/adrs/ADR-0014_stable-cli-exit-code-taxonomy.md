---
id: ADR-0014
title: Stable CLI Exit Code Taxonomy
status: proposed
date: 2026-07-06
supersedes: []
superseded_by: null
tags: [cli, exit-codes, automation, ci, diagnostics, v1]
---

# ADR-0014: Stable CLI Exit Code Taxonomy

## Status

Proposed.

## Context

Monad is a CLI for local developer workflows and CI automation. Exit codes are part of its public contract. Humans can read terminal output, but scripts and CI systems usually interpret process status.

If exit codes are inconsistent, automation becomes unreliable. If planned commands return ordinary success, users and CI may believe work was completed when it was only described. If every failure uses one generic code, automation cannot distinguish invalid input, repository validation failures, policy gates, missing native tools, manifest problems, and unexpected runtime faults.

Monad therefore needs a stable exit code taxonomy that is small enough to understand and specific enough to support reliable automation.

## Decision

Monad will define and document a stable CLI exit code taxonomy.

Proposed taxonomy:

| Code | Meaning |
| ---: | ------- |
| 0 | Success: requested operation completed as documented. |
| 1 | General failure: uncategorized operational failure. |
| 2 | Usage error: invalid arguments, invalid command combination, or malformed user input. |
| 3 | Validation failure: repository did not satisfy requested checks. |
| 4 | Policy failure: policy checks failed or policy gates blocked operation. |
| 5 | Plan/apply blocked: plan preconditions failed, protected path rule fired, stale plan detected, or apply could not proceed safely. |
| 6 | Missing dependency: required local native tool or dependency was unavailable. |
| 7 | Manifest/config error: invalid, missing, conflicting, or unsupported configuration state. |
| 8 | Placeholder/unimplemented: command is visible but not operational. |
| 9 | Explicit external operation failed: configured network, provider, registry, or remote integration failed. |
| 10 | Runtime invariant failure: unexpected Monad bug or invariant violation. |

The exact numeric values may be refined before stabilization, but once documented as stable they must not change casually.

Commands should map structured diagnostics to exit codes consistently. Machine-readable output should include compatible outcome metadata where practical.

## Decision Drivers

This decision is driven by:

- **CI reliability:** automation needs predictable process status.
- **Command honesty:** placeholders must not look like completed operational checks.
- **Diagnostics:** users need to understand failure category quickly.
- **Policy and validation:** governance failures should be distinct from runtime faults.
- **Plan safety:** blocked mutation should be distinguishable from ordinary validation failure.
- **Native tool coordination:** missing tools need actionable status.
- **Schema alignment:** machine-readable diagnostics should align with exit behavior.

## Rationale

Exit codes are a small but important trust boundary. Monad can print detailed findings, but CI often sees only pass or fail. A governance-grade CLI needs stronger semantics than generic success or generic failure.

A stable taxonomy makes workflows more reliable. CI can fail on policy failures, detect unimplemented command status, distinguish local dependency problems from repository validation problems, and separate expected governance findings from unexpected runtime faults.

This ADR also reinforces honest placeholder commands. Planned command visibility is acceptable only if incomplete commands cannot masquerade as completed checks.

## Implementation Guidance

Exit code handling should be centralized.

Recommended implementation steps:

1. Define an internal exit code enum.
2. Map diagnostic categories to exit codes.
3. Document the taxonomy in `docs/reference/exit-codes.md`.
4. Add tests for representative command outcomes.
5. Ensure placeholder commands use the placeholder/unimplemented code for operational invocation.
6. Include outcome metadata in machine-readable output where practical.
7. Mark the taxonomy as preview until v1 stabilization.

When multiple failure categories occur, Monad should document precedence. For example, usage errors should usually be reported before repository validation, and runtime invariant failures should remain clearly visible.

## Consequences

### Positive Consequences

- CI workflows become more reliable.
- Users can distinguish broad failure classes.
- Placeholder commands remain honest.
- Policy and validation failures become easier to automate around.
- Machine-readable outputs can align with process status.

### Negative Consequences

- More categories require documentation.
- Commands must map errors carefully.
- Some failures may fit multiple categories.
- Stable codes become costly to change after users depend on them.

### Required Mitigations

- Keep the taxonomy small.
- Centralize exit code mapping.
- Document precedence rules.
- Add command outcome tests.
- Treat the taxonomy as preview until it is stable enough for v1.

## Alternatives Considered

### Only 0 and 1

This was rejected because governance, policy, plan/apply, placeholders, and CI workflows need more detail.

### Highly Specific Exit Codes

This was rejected because detailed rule-level data belongs in structured findings, not process status.

### Text-Only Failure Semantics

This was rejected because parsing human text is brittle and unsuitable for stable automation.

## Validation

This decision is validated when:

- exit codes are documented;
- command handlers use centralized exit mapping;
- tests cover success, usage error, validation failure, policy failure, placeholder, manifest error, missing dependency, and runtime invariant failure;
- machine-readable output includes compatible outcome metadata;
- CI examples can rely on the taxonomy.

## Review Criteria

This ADR should be reconsidered if the taxonomy proves too coarse, too complex, or incompatible with common CLI conventions.

## Related Decisions

This ADR relates to ADR-0012 Honest Placeholder Commands, ADR-0013 Versioned Machine-Readable Output Schemas, ADR-0010 Policy-as-Code, ADR-0006 Plan-Backed Mutation, and ADR-0002 Coordinate Native Tools Instead of Replacing Them.
