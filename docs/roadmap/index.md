# Roadmap Index

This directory contains Monad's roadmap documentation.

The roadmap layer translates Monad's product, architecture, governance, safety, and implementation doctrine into sequenced delivery work. It exists to keep the project moving in small, testable, reversible increments.

## Purpose

Roadmap documentation should answer:

- What is the intended implementation sequence?
- Which maturity stage is active?
- Which epics and work packets belong to each stage?
- Which roadmap items are in scope for v0, v1, v1.x, and v2?
- Which items are explicitly deferred?
- Which ADRs constrain roadmap sequencing?
- What tests, docs, policy gates, and release evidence prove progress?

## Files

| File | Purpose |
| ---- | ------- |
| `roadmap.md` | Primary roadmap narrative covering maturity stages, versions, epics, work packets, current implementation boundary, risks, and fitness functions. |

## Related Directories

| Directory | Relationship |
| --------- | ------------ |
| `docs/workpackets/` | Materialized work-packet files that implement roadmap scope. |
| `docs/architecture/adrs/` | Architecture decisions that constrain roadmap sequencing. |
| `docs/governance/traceability-matrix.md` | Traceability from requirements and ADRs to work packets, tests, policies, risks, and evidence. |
| `docs/testing/bdd-index.md` | Behavior scenario registry used to validate roadmap delivery. |
| `docs/reference/release-evidence.md` | Release evidence registry for proving completion. |

## Roadmap Doctrine

Monad should advance only through increments that preserve trust:

```text
compile
expose honestly
inspect safely
validate deterministically
document clearly
graph coherently
plan visibly
apply cautiously
extend safely
assist optionally
host only when local value is proven
```

## Stage Sequence

The roadmap follows this maturity sequence:

| Stage | Focus |
| ----: | ----- |
| 0 | Repository foundation. |
| 1 | CLI skeleton and command contracts. |
| 2 | Read-only repository understanding. |
| 3 | Documentation, ADR, work-packet, and context lifecycle. |
| 4 | Plan-backed mutation engine. |
| 5 | Generators, templates, and packs. |
| 6 | Policy engine and waivers. |
| 7 | Release/change lifecycle. |
| 8 | Lifecycle graph maturity and local indexing. |
| 9 | AI-assisted planning with human approval. |
| 10 | Optional hosted/team control plane. |

## Version Sequence

| Version | Focus |
| ------- | ----- |
| v0.1 | CLI foundation and command catalog integrity. |
| v0.2 | Read-only repository inspection and validation. |
| v0.3 | Documentation, ADR, work-packet, and context lifecycle. |
| v0.4 | Plan model and dry-run apply. |
| v0.5 | Safe mutation for selected generators. |
| v0.6 | Policy engine and waivers. |
| v0.7 | Pack/template system. |
| v0.8 | Release/change lifecycle. |
| v0.9 | Lifecycle graph maturity and local indexing. |
| v1.0 | Stable local-first Monad OS core. |
| v1.1 | Advanced packs, policy bundles, and adapters. |
| v1.2 | AI-assisted planning and context governance. |
| v2.0 | Optional hosted/team/fleet control plane. |

## Current Implementation Boundary

The roadmap currently treats the project as early foundation work moving toward read-only lifecycle commands.

Recommended boundary:

```text
Layer 0002: Rust workspace and CLI skeleton stabilization
Layer 0003: read-only lifecycle commands
Layer 0004: plan-backed repository mutation engine
```

The project should avoid broad mutation, plugin execution, AI provider calls, hosted dependency, and unreviewed generation until the relevant earlier stages are complete.

## Roadmap Governance Rules

- Keep roadmap changes aligned with accepted ADRs.
- Add or revise work packets when implementation scope changes.
- Update the traceability matrix when roadmap scope changes requirements, risks, tests, or evidence.
- Do not mark roadmap items complete without appropriate tests and documentation.
- Preserve v1 non-goals unless a superseding ADR changes them.
- Keep hosted, AI, and plugin work deferred until deterministic local foundations are stable.

## Maintenance Notes

Update this index whenever roadmap files, work-packet locations, roadmap stages, or related governance registries change.
