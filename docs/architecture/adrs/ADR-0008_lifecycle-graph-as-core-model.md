---
id: ADR-0008
title: Lifecycle Graph as Core Model
status: proposed
date: 2026-07-02
supersedes: []
superseded_by: null
tags: [graph, lifecycle, domain-model, traceability, governance, v1]
---

# ADR-0008: Lifecycle Graph as Core Model

## Status

Proposed.

## Context

Monad's differentiation depends on connecting repository lifecycle artifacts into a coherent model.

Most developer tools see only one slice of the repository. A package manager sees packages and dependencies. A task runner sees tasks. A CI system sees workflows. A documentation tool sees Markdown. A policy tool sees rules and findings. A test runner sees tests. An AI assistant often sees whichever files happen to be included in context.

Monad's opportunity is broader. It should model the repository as a governed lifecycle system made of related artifacts that can be inspected, validated, explained, handed off, and eventually changed safely.

Relevant artifacts include:

- workspace;
- projects;
- packages;
- services;
- apps;
- libraries;
- domains;
- manifests;
- source files;
- generated files;
- documentation;
- ADRs;
- work packets;
- policies;
- waivers;
- plans;
- tests;
- releases;
- context packs;
- native tool manifests;
- CI workflows;
- security findings;
- ownership metadata;
- future hosted or AI integration artifacts.

Flat inspection reports are useful, but they do not fully express lifecycle relationships. Monad needs to answer questions such as:

- Which work packet introduced or modified this artifact?
- Which ADR justifies this architectural rule?
- Which policy applies to this project?
- Which docs describe this service?
- Which tests cover this package?
- Which generated files are derived from this source file?
- Which plans affect this area of the repository?
- Which context pack should include this artifact?
- Which native tool manifests describe this workspace unit?
- Which artifacts are drifting from source-of-truth expectations?

The lifecycle graph is the structure that can connect these artifacts.

## Decision

Monad will model repository knowledge as a lifecycle graph.

The lifecycle graph is a deterministic domain model that represents repository artifacts as nodes and relationships as edges. It should begin as local, in-memory, reproducible output derived from repository files and Monad manifests. It may later support persisted caches, graph queries, hosted dashboards, AI context enrichment, and release evidence, but persistence and hosted visualization must not precede the local deterministic model.

Initial graph support may include:

- workspace nodes;
- project or unit nodes;
- package nodes;
- documentation nodes;
- ADR nodes;
- work packet nodes;
- native manifest nodes;
- simple dependency or ownership edges;
- text output;
- Mermaid output;
- JSON output once the schema stabilizes.

The graph should eventually support:

- traceability;
- drift detection;
- policy context;
- documentation consistency checks;
- AI context generation;
- release readiness;
- plan impact analysis;
- hosted dashboard visualizations;
- lifecycle queries;
- repository health evidence.

## Decision Drivers

This decision is driven by the following needs:

- **Traceability:** Monad needs to connect decisions, work packets, policies, code, docs, plans, tests, and releases.
- **Governance:** policy and documentation checks need context about which artifacts relate to each other.
- **AI-readiness:** AI assistance is safer when context is derived from a deterministic graph rather than ad hoc file selection.
- **Drift detection:** detecting drift requires relationships between source-of-truth files, generated artifacts, docs, and native manifests.
- **Repository understanding:** users should be able to inspect the repository as a system, not just as a file tree.
- **Plan safety:** planned changes should be able to report affected nodes and relationships.
- **Local-first operation:** the graph must be generated locally before any hosted graph, cache, or dashboard exists.
- **Future moat:** a lifecycle graph can become a durable differentiator for Monad compared with ordinary scaffolders and task wrappers.

## Rationale

Monad is not merely a scaffolder, task runner, or documentation generator. Its long-term value comes from understanding the software delivery lifecycle inside the repository.

A lifecycle graph gives Monad a common model that can connect otherwise separate features. The same graph can support inspection, docs validation, ADR lookup, work packet traceability, policy context, context generation, release readiness, and future AI workflows.

The graph also creates a disciplined path for feature growth. Instead of each command inventing its own view of the repository, commands can contribute to or consume a shared graph model. For example, `monad inspect` can discover nodes, `monad docs check` can validate documentation nodes, `monad policy check` can evaluate policy relationships, `monad context handoff` can render graph-derived context, and `monad plan` can report impact against graph nodes.

However, the graph must start simple. A premature graph database or over-modeled ontology would slow implementation and create infrastructure dependency. The first graph should be deterministic, local, in-memory, testable, and easy to render. Persistence, caching, indexing, and hosted visualization should come only after the graph model proves useful.

## Scope of the Decision

This ADR applies to:

- repository inspection domain modeling;
- graph node and edge schemas;
- graph export formats;
- traceability modeling;
- documentation, ADR, and work packet relationships;
- policy context relationships;
- plan impact analysis;
- context generation;
- graph consistency checks;
- future graph cache and hosted graph boundaries.

This ADR does not require an external graph database, hosted graph service, or persistent local index in the near term. It also does not require Monad to perfectly model every repository artifact immediately.

## Graph Principles

The lifecycle graph should follow these principles.

### Deterministic Before Persistent

The graph should first be generated deterministically from local repository state. If persistence is added later, the persisted graph should be treated as derived cache unless a future ADR explicitly defines a canonical graph storage model.

### Local Before Hosted

The graph should be useful from the local CLI before any hosted dashboard exists. Hosted graph views may be valuable later, but they should consume local evidence rather than become required for core graph generation.

### Useful Before Complete

The initial graph does not need to model every possible artifact. It should model high-value nodes and edges first, then expand as commands need more relationships.

### Source-Referenced

Graph nodes should reference their source artifacts where possible. A graph node should be explainable: users should be able to understand which file, manifest, heading, command, or generated artifact produced it.

### Machine-Readable and Human-Readable

The graph should support machine-readable output for CI and automation, but it should also provide human-readable summaries and diagrams.

### No Hidden Authority

The graph should not silently become the source of truth. Source files such as `monad.toml`, ADRs, work packets, policies, native manifests, and docs remain source artifacts. The graph is a derived model unless explicitly superseded by a later ADR.

## Candidate Node Types

Initial and future graph nodes may include:

- `Workspace`;
- `WorkspaceUnit`;
- `Project`;
- `Application`;
- `Service`;
- `Library`;
- `Package`;
- `Domain`;
- `Manifest`;
- `NativeTool`;
- `Task`;
- `DocumentationPage`;
- `Adr`;
- `WorkPacket`;
- `Policy`;
- `Waiver`;
- `Plan`;
- `TestSuite`;
- `Release`;
- `ContextPack`;
- `GeneratedArtifact`;
- `Finding`;
- `Owner`.

Not every node type is required in the first implementation. The list defines a direction for the domain model.

## Candidate Edge Types

Initial and future graph edges may include:

- `contains`;
- `depends_on`;
- `documents`;
- `decides`;
- `implements`;
- `governs`;
- `waives`;
- `generates`;
- `derived_from`;
- `tests`;
- `releases`;
- `mentions`;
- `references`;
- `owned_by`;
- `affected_by`;
- `planned_by`;
- `configured_by`;
- `validated_by`;
- `included_in_context`.

Edge naming should remain stable enough for machine-readable output. Human-readable labels can evolve separately from machine-readable identifiers.

## Output Formats

Monad should support graph output in multiple formats over time.

Near-term outputs:

- text summaries for humans;
- Mermaid diagrams for documentation and quick visualization.

Medium-term outputs:

- JSON for CI, tests, integrations, and AI context generation;
- DOT for Graphviz-compatible rendering;
- Markdown summaries for handoffs and reports.

Future outputs may include:

- persisted local cache under `.monad/graphs/`;
- queryable graph indexes;
- hosted dashboard payloads;
- release evidence bundles;
- AI context slices derived from graph traversal.

Output formats should be rendered from the same graph model rather than independently re-discovering repository relationships.

## Implementation Guidance

Start with an in-memory graph model.

Recommended implementation steps:

1. Define stable node identifiers and node kinds.
2. Define stable edge identifiers and edge kinds.
3. Build graph from local repository inspection and `monad.toml`.
4. Add source references for graph nodes.
5. Add text output.
6. Add Mermaid output.
7. Add fixture tests for simple repositories.
8. Add JSON output once the schema is stable enough.
9. Add graph invariant checks.
10. Add DOT output later.
11. Add local cache only after deterministic generation is stable.
12. Add hosted or indexed graph behavior only after the local model proves useful.

The graph builder should avoid hidden network calls. It should consume local files, manifests, docs, and generated metadata. Native tool adapters may contribute facts to the graph, but those contributions should be explicit and deterministic where possible.

Graph consistency checks should detect malformed nodes, dangling edges, duplicate identifiers, unsupported edge kinds, missing source references where required, and cycles where cycles are not allowed.

## Consequences

### Positive Consequences

- Monad gets a coherent domain model for repository lifecycle knowledge.
- Traceability across code, docs, ADRs, work packets, policies, plans, and releases becomes possible.
- AI context can be generated from deterministic graph slices.
- Drift detection can use relationships rather than flat file lists.
- Policy checks can operate with richer context.
- Plan impact analysis can identify affected repository areas.
- Documentation-as-code becomes easier to validate.
- Future hosted dashboards have a local evidence model to consume.
- The lifecycle graph can become a durable product moat.

### Negative Consequences

- The graph model can become complex if over-designed.
- Node and edge schemas require maintenance.
- Source artifact references must be kept accurate.
- Graph consistency requires dedicated tests.
- Persistence may be tempting before the model stabilizes.
- Over-modeling could slow implementation and make early commands harder to ship.
- Users may need clear explanations of graph concepts.

### Required Mitigations

- Start with a small in-memory graph.
- Prefer useful relationships over exhaustive modeling.
- Keep graph generation deterministic and local.
- Add source references for explainability.
- Add graph invariant tests early.
- Treat `.monad/graphs/` as generated/cache output, not canonical truth.
- Defer graph persistence until the model stabilizes.
- Defer hosted graph dashboards until local output is valuable.
- Document graph node and edge semantics as they stabilize.

## Alternatives Considered

### Flat Inspection Reports Only

Monad could produce flat reports listing files, packages, docs, policies, and findings without modeling relationships between them.

This was rejected as the long-term model because flat reports do not express lifecycle relationships well. They are useful output views, but they are not enough to support traceability, context slicing, plan impact analysis, and governance relationships.

### Project Dependency Graph Only

Monad could model only code/project/package dependencies.

This was rejected because Monad's graph must include docs, ADRs, work packets, policies, plans, context, releases, native manifests, and governance artifacts. Code dependencies are only one part of the lifecycle system.

### External Graph Database from Day One

Monad could require a graph database or hosted graph service for repository modeling.

This was rejected because persistence should not precede the local model. Requiring external storage would conflict with local-first operation and add unnecessary infrastructure before the graph schema is proven.

### File Tree as the Only Model

Monad could treat the repository file tree as the primary model and avoid semantic graph modeling.

This was rejected because filesystem layout alone cannot represent decisions, ownership, policy relationships, generated lineage, work packet traceability, or plan impact.

### AI-Generated Graph

Monad could ask an AI model to infer repository relationships and produce a graph.

This was rejected as a correctness foundation because graph generation must be deterministic, inspectable, and reproducible. AI may help explain or enrich graph output later, but it must not be the authoritative graph builder.

## Validation

This decision is validated when:

- Monad can generate a local graph from repository state;
- graph generation does not require a hosted service;
- graph generation does not require an AI provider;
- graph output includes stable node and edge kinds;
- graph nodes reference source artifacts where practical;
- text and Mermaid output are available for early human review;
- JSON output is added once the schema stabilizes;
- graph invariant tests catch duplicate nodes, dangling edges, and invalid relationships;
- graph data can support at least one real workflow such as docs checking, context generation, policy context, or plan impact analysis.

## Review Criteria

This ADR should be reconsidered if:

- the lifecycle graph proves too abstract to support real workflows;
- a simpler model can provide traceability, drift detection, policy context, and AI context more effectively;
- the project intentionally narrows scope to a simple scaffolder or task wrapper;
- a future storage or query architecture supersedes the in-memory deterministic graph model;
- implementation evidence shows better node/edge boundaries than those described here.

Because this ADR is Proposed, the exact graph schema may evolve. The protected principle is that Monad models the repository as a lifecycle system, not merely a file tree or command wrapper.

## Related Decisions

This ADR relates to:

- ADR-0001, which establishes Rust as the core runtime language;
- ADR-0002, which establishes native tool coordination over replacement;
- ADR-0003, which establishes local-first operation;
- ADR-0004, which establishes AI-native but AI-optional behavior;
- ADR-0005, which establishes `monad.toml` as canonical manifest;
- ADR-0006, which establishes plan-backed mutation;
- ADR-0007, which proposes modular Rust workspace boundaries;
- future decisions about documentation-as-code;
- future decisions about policy-as-code;
- future decisions about deterministic context before AI assistance;
- future decisions about graph persistence, query, cache, and hosted visualization.
