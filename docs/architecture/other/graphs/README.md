# Graph Architecture

This directory documents Monad's graph architecture.

Monad models a repository as a governed lifecycle system rather than a flat file tree. Graph outputs connect workspace units, packages, docs, ADRs, work packets, policies, plans, releases, context packs, generated artifacts, and native tool manifests.

## Purpose

Graph architecture supports:

- repository understanding;
- dependency and ownership visibility;
- documentation traceability;
- ADR and work-packet relationships;
- policy context;
- plan impact analysis;
- release readiness evidence;
- deterministic AI context generation;
- future hosted projection.

## Related ADRs

- ADR-0003: Local-First Core
- ADR-0005: `monad.toml` Is the Canonical Manifest
- ADR-0008: Lifecycle Graph as Core Model
- ADR-0013: Versioned Machine-Readable Output Schemas
- ADR-0015: Local Graph Cache Is Rebuildable Generated State
- ADR-0018: Hosted Control Plane Is Optional Projection Layer

## Graph Model

The graph is a derived model built from source repository state.

Candidate node kinds include:

- workspace;
- workspace unit;
- project;
- package;
- app;
- service;
- library;
- manifest;
- documentation page;
- ADR;
- work packet;
- policy;
- waiver;
- plan;
- release;
- context pack;
- generated artifact;
- finding;
- owner.

Candidate edge kinds include:

- contains;
- depends_on;
- documents;
- decides;
- implements;
- governs;
- generates;
- derived_from;
- tests;
- releases;
- references;
- owned_by;
- affected_by;
- planned_by;
- configured_by;
- included_in_context.

## Output Formats

Expected graph output formats:

| Format | Use |
| ------ | --- |
| Text | Human inspection and command-line summaries. |
| Mermaid | Markdown-native diagrams. |
| JSON | CI, tests, context generation, and hosted projection. |
| DOT | Graphviz-compatible rendering. |
| Markdown | Handoffs, reports, and release evidence. |

Stable machine-readable graph output should follow versioned schema rules.

## Cache Rules

A local graph cache may exist under `.monad/graphs/`, but it is generated state.

Rules:

- graph generation must work without the cache;
- cache files must not override source artifacts;
- stale cache must be detected or ignored;
- cache deletion must not remove repository intent;
- release evidence must be clearly distinguished from ordinary cache.

## Expected Commands

```bash
monad graph
monad graph --format mermaid
monad graph --format json
monad graph check
```

Early graph support may be partial, but output should remain honest about maturity and coverage.

## Testing Expectations

Graph tests should cover:

- duplicate node detection;
- dangling edges;
- invalid edge kinds;
- missing source references;
- deterministic fixture output;
- cache rebuild behavior;
- JSON schema compatibility once stable.

## Maintenance Notes

Graph architecture should stay aligned with lifecycle graph ADRs and future graph blueprints. Avoid introducing a graph database or hosted graph dependency before the deterministic local model is proven.
