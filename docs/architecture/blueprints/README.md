# Architecture Blueprints

This directory contains architecture blueprints for Monad.

Blueprints are structured design artifacts that explain how major parts of Monad should be shaped before, during, and after implementation. They sit between high-level architecture strategy and executable code.

They are intended to be more concrete than ADRs, but less transient than implementation notes.

## Purpose

Architecture blueprints help Monad preserve design intent across:

- Rust crate and module boundaries;
- CLI command design;
- repository inspection flows;
- manifest and configuration resolution;
- lifecycle graph modeling;
- documentation and ADR/work-packet lifecycle;
- policy and findings systems;
- plan, diff, dry-run, and apply engines;
- pack and template trust boundaries;
- plugin execution boundaries;
- deterministic context generation;
- optional AI provider adapters;
- optional hosted projection layers.

Blueprints should answer:

- What subsystem is being designed?
- Which ADRs constrain it?
- Which work packets implement it?
- What are the core domain concepts?
- What inputs and outputs does it own?
- What is source-of-truth versus generated state?
- What commands depend on it?
- What safety or trust boundaries apply?
- What is intentionally out of scope?

## Relationship to ADRs

ADRs record decisions.

Blueprints explain designs shaped by those decisions.

For example:

- ADR-0005 decides that `monad.toml` is canonical.
- A manifest-resolution blueprint should explain how manifest loading, mirror detection, lockfile resolution, diagnostics, and migration behavior work.

- ADR-0006 decides that mutation is plan-backed.
- A plan/apply blueprint should explain plan schemas, diff rendering, dry-run behavior, filesystem safety, apply reports, and stale-plan detection.

- ADR-0008 proposes the lifecycle graph as a core model.
- A graph blueprint should explain node kinds, edge kinds, graph builders, output formats, invariants, cache behavior, and downstream consumers.

Blueprints should cite related ADRs and must not contradict accepted ADRs.

## Relationship to Work Packets

Work packets define implementation scope.

Blueprints define subsystem shape.

A work packet may reference one or more blueprints when implementing a subsystem. A blueprint may cover multiple work packets.

Recommended linkage:

```markdown
## Related Work Packets

- WP-0002: Core Workspace Model and Manifest Schema
- WP-0012: Lifecycle Graph v0
- WP-0025: Plan Schema and Domain Model
```

## Relationship to Future Monad Commands

Future Monad commands should eventually be able to inspect, validate, and include these blueprints in generated handoffs.

Potential future commands:

```bash
monad docs check
monad context handoff
monad graph docs
monad adr list
monad workpacket list
```

Blueprint files should therefore use predictable headings, stable filenames, local links, and explicit relationship sections.

## Recommended Blueprint Template

Use this structure for new architecture blueprints unless a subsystem needs something more specific.

```markdown
# <Subsystem> Blueprint

## Status

Draft | Proposed | Active | Superseded

## Purpose

What subsystem does this blueprint describe?

## Scope

What is included?

## Non-Goals

What is intentionally excluded?

## Related ADRs

- ADR-0000: Example Decision

## Related Work Packets

- WP-0000: Example Work Packet

## Domain Concepts

What are the important domain objects, states, and relationships?

## Source-of-Truth Model

Which files or artifacts are canonical?
Which files are resolved, generated, cached, or external?

## Inputs

What files, commands, schemas, or runtime data does this subsystem consume?

## Outputs

What files, reports, diagnostics, plans, graph nodes, or machine-readable artifacts does this subsystem produce?

## Command Surface

Which commands use this subsystem?

## Data Model

What schemas, Rust types, or structured artifacts are expected?

## Safety and Trust Boundaries

What can go wrong?
What must be protected?
What must be explicit, opt-in, or plan-backed?

## Error and Diagnostic Model

What findings, warnings, errors, and exit-code categories apply?

## Testing Strategy

What fixture tests, contract tests, integration tests, and regression tests are required?

## Open Questions

What still needs design validation?

## Evolution Plan

How should the subsystem mature across v0, v1, and later versions?
```

## Suggested Initial Blueprints

The following blueprints are recommended as the architecture documentation matures.

| Blueprint | Purpose | Related ADRs |
| --------- | ------- | ------------ |
| `runtime-and-crate-boundaries.md` | Rust workspace, crate responsibilities, dependency direction, and CLI/domain separation. | ADR-0001, ADR-0007 |
| `manifest-resolution.md` | `monad.toml`, `workspace.toml` mirror handling, `monad.lock`, config diagnostics, and root detection. | ADR-0005 |
| `repository-inspection.md` | Read-only repository discovery, artifact classification, native manifest detection, and inspection findings. | ADR-0002, ADR-0003 |
| `lifecycle-graph.md` | Node/edge model, graph builders, output formats, graph invariants, and graph consumers. | ADR-0008, ADR-0015 |
| `documentation-lifecycle.md` | Docs-as-code checks, ADR/work-packet validation, generated docs, and docs freshness. | ADR-0009 |
| `policy-and-waivers.md` | Built-in policy rules, findings, severity, explanations, waivers, and plan gates. | ADR-0010 |
| `context-and-handoff.md` | Deterministic context packs, handoff output, redaction, inclusion/exclusion manifests, and AI input boundaries. | ADR-0004, ADR-0011, ADR-0020 |
| `plan-diff-apply.md` | Plan model, diff output, dry-run, apply reports, stale-plan detection, and mutation safety. | ADR-0006, ADR-0014 |
| `output-schemas-and-exit-codes.md` | Versioned JSON schemas, output maturity, and CLI exit-code taxonomy. | ADR-0013, ADR-0014 |
| `packs-templates-and-plugins.md` | Pack/template trust model, plugin execution boundaries, permissions, and supply-chain posture. | ADR-0016, ADR-0017 |
| `hosted-projection.md` | Optional hosted control plane, local evidence export, sync boundaries, and privacy posture. | ADR-0018, ADR-0019 |
| `ai-provider-boundary.md` | AI provider port, no-op adapter, provider configuration, provenance, and disabled-AI behavior. | ADR-0004, ADR-0011, ADR-0020 |

## Diagram Guidance

Blueprints may include diagrams when they clarify structure.

Preferred diagram formats:

- Mermaid for Markdown-native diagrams;
- PlantUML when a diagram needs stronger C4-style structure;
- DOT/Graphviz output when generated from Monad graph data;
- plain text diagrams when stability and copyability matter most.

Recommended C4-style diagram levels:

- **Context:** Monad CLI, repository, native tools, optional hosted control plane, optional AI providers.
- **Container:** CLI crate, core domain crates, generated state, native tools, optional adapters.
- **Component:** manifest loader, graph builder, policy evaluator, context generator, plan engine, filesystem safety layer.

Diagrams should remain source-controlled and text-based. Avoid image-only diagrams unless a generated image is accompanied by source.

## Source-of-Truth Rules

Blueprints must preserve these source-of-truth rules:

- ADRs record durable decisions.
- `monad.toml` is the canonical Monad manifest.
- `monad.lock` is resolved state, not author intent.
- `.monad/` contains generated/local/cache/report/context/plan state unless otherwise specified.
- Blueprints explain architecture but do not override accepted ADRs.
- Work packets define implementation scope but do not silently change architectural decisions.
- Generated artifacts should be clearly distinguishable from authored source documents.

## Status Values

Recommended blueprint statuses:

| Status | Meaning |
| ------ | ------- |
| Draft | Early outline; not yet ready to guide implementation. |
| Proposed | Design is coherent but still open to refinement. |
| Active | Current implementation guidance. |
| Superseded | Replaced by a newer blueprint or ADR. |

## Maintenance Rules

- Keep blueprint filenames lowercase and kebab-cased.
- Link related ADRs and work packets explicitly.
- Update blueprints when implementation materially changes architecture.
- Supersede rather than silently rewrite major design intent.
- Keep diagrams text-based and reviewable.
- Keep local links valid.
- Prefer concrete implementation guidance over vague architecture prose.

## Current State

This directory currently establishes the blueprint documentation convention.

Concrete subsystem blueprints should be added incrementally as implementation work reaches each subsystem.
