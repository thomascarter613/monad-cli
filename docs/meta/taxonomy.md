# Taxonomy

This document defines Monad's high-level classification system.

## Artifact Classes

| Class | Examples |
| ----- | -------- |
| Source | code, docs, ADRs, work packets, manifests |
| Resolved | lockfiles, resolved manifests, dependency state |
| Generated | graphs, reports, context packs, caches |
| Evidence | release reports, apply reports, audit findings |
| External | native tool output, provider responses, hosted projections |
| Archival | frozen snapshots, archive manifests |
| Forensic | incident records, failed apply evidence, review records |

## Governance Record Classes

| Class | Purpose |
| ----- | ------- |
| ADR | Durable architecture decision. |
| RFC | Proposal before durable decision. |
| Work packet | Implementation scope unit. |
| Policy | Repeatable governance rule. |
| Finding | Result emitted by a policy or validation check. |
| Waiver | Explicit exception to a finding or policy. |
| Risk | Known uncertainty or failure mode. |
| Evidence | Proof of check, release, or review state. |

## Command Classes

| Class | Examples |
| ----- | -------- |
| Inspect | `inspect`, `list`, `graph` |
| Validate | `check`, `doctor`, `policy check`, `docs check` |
| Mutate | `add`, `remove`, `rename`, `move`, `generate`, `apply` |
| Orchestrate | `run`, `build`, `test`, `lint`, `format` |
| Govern | `adr`, `workpacket`, `policy`, `release` |
| Context | `context handoff`, `context pack` |
| Extend | `pack`, `template`, `plugin` |

## State Classes

| Class | Meaning |
| ----- | ------- |
| Canonical | Authoritative source of intent. |
| Resolved | Derived state used for reproducibility. |
| Cached | Rebuildable local generated state. |
| Reported | Output created to explain command results. |
| Archived | Frozen for later reference. |
| Projected | Optional hosted or external view. |

## Maintenance Notes

Use this taxonomy when designing schemas, command metadata, policy findings, context manifests, graph nodes, and release evidence.
