# Cross-Domain Validation

This document defines validation across Monad domains.

Cross-domain validation checks that separately valid artifacts still agree with each other across requirements, ADRs, work packets, docs, schemas, policies, risks, tests, and release evidence.

## Purpose

Cross-domain validation detects integration drift that domain validation alone cannot catch.

## Cross-Domain Checks

| Check | Description |
| ----- | ----------- |
| Requirement traceability | Requirements map to ADRs, work packets, tests, and evidence. |
| ADR consistency | ADRs do not contradict accepted decisions without supersession. |
| Work packet coverage | Work packets reference required docs, ADRs, tests, and release evidence. |
| Command/doc alignment | Command docs match command metadata and implementation status. |
| Policy/evidence alignment | Policy findings map to controls, risks, and release evidence. |
| Graph/docs alignment | Lifecycle graph references existing artifacts. |
| Context/source alignment | Context artifacts reference current source files and omit excluded data. |
| Data/retention alignment | Artifacts have appropriate retention and source-of-truth class. |

## Validation Flow

1. Run domain validation.
2. Build cross-domain reference graph.
3. Detect missing or stale references.
4. Classify findings by severity.
5. Produce human and machine-readable reports.
6. Feed release readiness and traceability checks.

## Failure Modes

- ADR index points to missing files.
- Traceability matrix references old paths.
- Release evidence claims checks that were not run.
- Docs describe planned commands as implemented.
- Work packets lack related ADRs or tests.
- Context packs include stale governance docs.

## Maintenance Notes

Update cross-domain validation when traceability, graph, docs governance, data governance, or release evidence models change.
