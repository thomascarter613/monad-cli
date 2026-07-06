# Invariant Checkers

This document defines the checker model for Monad invariants.

Invariant checkers are validation routines that prove or report whether declared rules remain true as the repository evolves.

## Purpose

Invariant checkers help detect drift before it becomes unsafe or misleading.

They may cover:

- command behavior;
- documentation structure;
- graph integrity;
- policy rules;
- data retention classification;
- infrastructure contracts;
- interoperability boundaries;
- safety rules;
- release evidence.

## Checker Classes

| Checker | Purpose |
| ------- | ------- |
| Command checker | Validate command metadata, placeholders, output formats, and exit behavior. |
| Docs checker | Validate required docs, links, indexes, and generated docs lineage. |
| Graph checker | Validate lifecycle graph nodes, edges, and references. |
| Policy checker | Validate policy findings, waivers, and gates. |
| Data checker | Validate schemas, retention classes, archival/forensic records. |
| Safety checker | Validate no-network, no-telemetry, AI-optional, and mutation safety invariants. |
| Release checker | Validate evidence completeness and readiness gates. |

## Finding Model

Checker findings should include:

- checker ID;
- invariant ID;
- severity;
- affected path or node;
- message;
- remediation guidance;
- related ADR/policy;
- machine-readable category.

## Execution Model

Checkers should be deterministic and local-first. They should not mutate repository state unless explicitly paired with a plan-backed repair flow.

## Maintenance Notes

Update this document when new invariants, checker commands, policy gates, or verification evidence models are introduced.
