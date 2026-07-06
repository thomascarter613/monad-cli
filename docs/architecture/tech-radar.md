# Tech Radar

This document records Monad's project-specific technology radar.

The radar is not a generic industry ranking. It captures technology choices, posture, and architectural constraints for Monad as a local-first, Rust-based monorepo runtime and SDLC control plane.

## Radar Rings

| Ring | Meaning |
| ---- | ------- |
| Adopt | Approved default for current implementation. |
| Trial | Promising and allowed in bounded experiments. |
| Assess | Worth tracking, but not yet selected. |
| Hold | Avoid by default unless a later ADR changes the decision. |

## Adopt

| Technology | Use | Rationale |
| ---------- | --- | --------- |
| Rust | Core runtime implementation | Single-binary distribution, safety, performance, strong local CLI fit. |
| Clap | CLI parsing | Mature Rust CLI ecosystem. |
| TOML | Canonical manifest format | Aligns with Rust tooling and `monad.toml`. |
| Markdown | Documentation, ADRs, work packets | Reviewable documentation-as-code. |
| JSON | Machine-readable outputs | CI, automation, schemas, reports, graph/context/plan artifacts. |
| Mermaid | Lightweight diagrams | Markdown-native graph and architecture visualization. |
| Git | Source-of-truth recovery and review | Repository-native versioning and audit trail. |

## Trial

| Technology | Use | Rationale |
| ---------- | --- | --------- |
| DOT/Graphviz | Graph export | Useful for graph visualization after schema stabilizes. |
| JSON Schema | Output contract validation | Useful once machine-readable outputs stabilize. |
| WASM plugins | Future plugin isolation | Candidate for safer plugin execution, not yet selected. |
| External process plugins | Future plugin model | Simple and language-agnostic, but requires trust controls. |
| OPA/Rego | Future policy adapter | Useful for organization policy, but not day-one policy runtime. |

## Assess

| Technology | Use | Rationale |
| ---------- | --- | --------- |
| Local graph cache | Performance optimization | Rebuildable generated state after graph model stabilizes. |
| Hosted control plane | Optional projection | Potential team/fleet value after local evidence matures. |
| AI provider adapters | Optional assistance | Must use provider port/no-op adapter and deterministic context first. |
| Remote pack registry | Extension distribution | Requires trust, provenance, and policy model first. |

## Hold

| Technology/Approach | Reason |
| ------------------- | ------ |
| Hosted-first runtime | Conflicts with local-first doctrine. |
| Telemetry by default | Conflicts with privacy and trust posture. |
| AI-required workflows | Conflicts with AI-optional architecture. |
| External graph database from day one | Premature before local deterministic graph model proves useful. |
| Plugin-first architecture | Premature before core safety and domain boundaries stabilize. |
| Direct mutation by default | Conflicts with plan-backed mutation. |
| Unversioned machine-readable output | Breaks CI and automation contracts. |

## Decision Rules

- Promote from Trial to Adopt only with implementation evidence or ADR support.
- Promote high-impact architecture choices through ADRs.
- Keep optional technologies outside deterministic local core until accepted.
- Avoid adding infrastructure before local file-based behavior works.
- Prefer native tool coordination over replacement.

## Related ADRs

- ADR-0001: Rust Single-Binary Runtime
- ADR-0002: Coordinate Native Tools Instead of Replacing Them
- ADR-0003: Local-First Core
- ADR-0004: AI-Native but AI-Optional
- ADR-0013: Versioned Machine-Readable Output Schemas
- ADR-0017: Plugin Execution and Trust Boundary
- ADR-0018: Hosted Control Plane Is Optional Projection Layer
- ADR-0019: No Telemetry by Default
- ADR-0020: AI Provider Port and Noop Adapter

## Maintenance Notes

Update this radar when a technology moves rings, is introduced into implementation, or is superseded by an ADR. The radar should reflect current architectural posture, not aspirational tooling sprawl.
