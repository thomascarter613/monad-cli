---
id: ADR-0015
title: Local Graph Cache Is Rebuildable Generated State
status: proposed
date: 2026-07-06
supersedes: []
superseded_by: null
tags: [graph, cache, generated-state, local-first, lifecycle, v1]
---

# ADR-0015: Local Graph Cache Is Rebuildable Generated State

## Status

Proposed.

## Context

ADR-0008 establishes the lifecycle graph as a core model. The graph connects repository artifacts such as workspace units, manifests, docs, ADRs, work packets, policies, plans, tests, releases, and context packs.

As graph generation matures, Monad may cache graph output under `.monad/graphs/` or a similar local state path to improve performance, preserve reports, or support future inspection workflows.

Caching is useful, but a local cache must not become a hidden source of truth. Monad already distinguishes canonical source files, resolved lock state, and generated/local state. The graph cache must respect that model.

## Decision

The local graph cache is rebuildable generated state.

The authoritative sources for graph generation remain repository files and explicit Monad source-of-truth artifacts, including `monad.toml`, docs, ADRs, work packets, policies, native manifests, and source files. Cached graph files are derived outputs.

A local graph cache may live under a generated state path such as:

```text
.monad/graphs/
```

or another documented `.monad/` subdirectory. It must be safe to delete and rebuild unless a specific exported report is intentionally promoted to release evidence or another durable artifact by a later workflow.

The graph cache must not override canonical source files, and stale cache data must not be treated as repository truth.

## Decision Drivers

This decision is driven by:

- **Local-first operation:** graph data should be generated locally before hosted projection exists.
- **Source-of-truth clarity:** derived graph files must not compete with `monad.toml`, docs, ADRs, work packets, or native manifests.
- **Performance:** caching may be useful for larger repositories.
- **Determinism:** cache output should be reproducible from source state.
- **Safety:** stale generated data must not mislead users or AI context generation.
- **Hosted optionality:** hosted graph views should consume local evidence, not replace local truth.

## Rationale

A graph cache is an optimization and evidence artifact, not the repository model itself. If cached graph data becomes authoritative, Monad would reintroduce hidden state and drift. That would conflict with local-first, documentation-as-code, manifest source-of-truth, and lifecycle graph principles.

Treating the cache as rebuildable generated state keeps the graph model deterministic. Users can delete `.monad/graphs/`, regenerate it, and expect Monad to derive the same graph from the same source state.

## Cache Rules

The local graph cache should follow these rules:

- cache data is derived from local repository sources;
- cache data must not override source files;
- stale cache must be detected or ignored;
- cache files should include schema/version metadata;
- cache files should include source fingerprints where practical;
- users should be able to rebuild the cache;
- cache deletion should not damage repository intent;
- cache paths should be documented;
- generated graph reports promoted to release evidence should be clearly distinguished from ordinary cache.

## Implementation Guidance

Recommended implementation steps:

1. Generate graph in memory first.
2. Add text and Mermaid outputs before persistent cache.
3. Add JSON graph schema only once graph shape stabilizes.
4. Add optional local graph cache after deterministic generation is reliable.
5. Include schema version and generation metadata in cached graph files.
6. Include source fingerprints or invalidation metadata where practical.
7. Add `monad graph clean` or equivalent only through safe generated-state deletion rules.
8. Document which graph outputs are cache, reports, or release evidence.

The graph builder should be able to run without reading cache. Cache should accelerate or preserve output, not supply missing truth.

## Consequences

### Positive Consequences

- Graph generation remains deterministic and source-derived.
- Users can safely delete and rebuild cache.
- Stale generated state is less likely to become hidden truth.
- Hosted graph features can consume local evidence later.
- AI context generation can avoid relying on stale cache as authority.

### Negative Consequences

- Rebuilding graph may cost time in large repositories.
- Cache invalidation must be designed carefully.
- Users may need documentation to understand cache versus evidence.
- Some reports may need explicit promotion if they must be retained.

### Required Mitigations

- Keep cache metadata explicit.
- Add invalidation checks.
- Document cache paths and deletion behavior.
- Distinguish ordinary cache from release evidence.
- Keep graph generation possible without cache.

## Alternatives Considered

### Make the Graph Cache Canonical

This was rejected because it would create hidden state and drift from source files.

### Avoid Graph Caching Entirely

This may be acceptable early, but large repositories may eventually benefit from caching. The decision permits caching while keeping it non-authoritative.

### Use an External Graph Store from Day One

This was rejected because it conflicts with local-first operation and adds infrastructure before the local deterministic graph model is proven.

## Validation

This decision is validated when:

- graph generation works without a cache;
- cache files include generation metadata;
- cache deletion does not remove repository intent;
- stale cache is detected or safely ignored;
- `.monad/graphs/` is documented as generated state;
- release evidence artifacts are clearly distinguished from ordinary cache.

## Review Criteria

This ADR should be reconsidered if graph persistence becomes necessary as a canonical model and the source-of-truth tradeoff is explicitly accepted in a later ADR.

## Related Decisions

This ADR relates to ADR-0008 Lifecycle Graph as Core Model, ADR-0003 Local-First Core, ADR-0005 `monad.toml` Is the Canonical Manifest, ADR-0011 Deterministic Context Before AI Assistance, and ADR-0018 Hosted Control Plane Is Optional Projection Layer.
