---
id: ADR-0007
title: Modular Rust Workspace
status: proposed
date: 2026-07-02
supersedes: []
superseded_by: null
tags: [rust, workspace, crates, modularity, ddd, code-architecture, v1]
---

# ADR-0007: Modular Rust Workspace

## Status

Proposed.

## Context

Monad is implemented as a Rust runtime exposed primarily through the `monad` CLI. Earlier decisions established Rust as the implementation language, native-tool coordination as the tooling strategy, local-first operation as the core runtime posture, AI as optional, `monad.toml` as the canonical manifest, and plan-backed mutation as the default safety model.

Those decisions imply a growing set of responsibilities for the Rust codebase. Monad's scope includes:

- CLI command surface and command dispatch;
- command catalog and command contract validation;
- configuration and manifest resolution;
- repository root detection;
- workspace model and manifest schema;
- repository inspection;
- native tool detection and coordination;
- lifecycle graph modeling;
- documentation and ADR lifecycle support;
- work packet lifecycle support;
- context and handoff generation;
- policy and waiver modeling;
- plan, diff, dry-run, and apply safety;
- filesystem safety and protected-file rules;
- packs, templates, and future plugins;
- future AI adapter boundaries;
- future hosted integration boundaries.

A single large Rust crate can move quickly at the beginning, but it risks accumulating unrelated responsibilities in one place. Over time, command parsing, domain models, filesystem operations, graph logic, manifest resolution, context generation, policy evaluation, and plan/apply code would become harder to test and refactor.

At the same time, creating too many crates too early can create artificial complexity. Empty or thin crates can make the repository look more mature than the implementation actually is. Premature crate boundaries can slow development, increase dependency-management overhead, and force refactors before domain seams are understood.

Monad therefore needs a modular Rust architecture that supports long-term bounded contexts without creating a crate explosion before behavior justifies separation.

## Decision

Monad will use a modular Rust workspace with separate crates for major bounded contexts, but crates should be extracted only when behavior justifies the boundary.

The near-term structure may remain small, such as:

```text
crates/
  monad-cli/
  monad-core/
```

As real behavior accumulates, Monad may extract additional crates around stable domain boundaries. Candidate long-term crates include:

```text
crates/
  monad-cli/
  monad-core/
  monad-config/
  monad-inspect/
  monad-graph/
  monad-context/
  monad-docs/
  monad-policy/
  monad-plans/
  monad-packs/
  monad-fs/
  monad-native-tools/
  monad-ai/
  monad-hosted/
```

This list is directional, not mandatory. The project should not create crates merely because they appear in this ADR. A crate should be extracted when it has meaningful behavior, tests, a coherent domain boundary, and a dependency direction that improves maintainability.

The `monad-cli` crate should remain focused on CLI concerns: argument parsing, command dispatch, output formatting, exit codes, and presentation-level wiring. Durable domain behavior should live outside the CLI crate when it becomes non-trivial.

The `monad-core` crate should contain stable foundational types and contracts that are genuinely shared across bounded contexts. It should not become a dumping ground for all domain logic.

## Decision Drivers

This decision is driven by the following needs:

- **Maintainability:** Monad's scope will grow beyond what should live in one large file or one large crate.
- **Testability:** domain logic should be testable without invoking the CLI parser.
- **Bounded contexts:** manifest resolution, inspection, graphing, context generation, policy, and plan/apply behavior have different models and responsibilities.
- **Dependency discipline:** optional AI and hosted features must not become required dependencies of deterministic local core behavior.
- **Local-first reliability:** core local behavior should remain small, deterministic, and easy to build.
- **Refactor safety:** clear crate boundaries can make future changes safer once seams are known.
- **Practicality:** crate extraction should follow real implementation needs rather than speculative architecture diagrams.
- **Contributor clarity:** a modular workspace helps contributors know where new behavior belongs.

## Rationale

A modular Rust workspace gives Monad room to grow while preserving the single-binary runtime model. Multiple crates do not prevent building one `monad` executable. They allow the implementation to separate CLI presentation from durable domain logic.

The key is timing. Extracting crates too late can produce an oversized `monad-cli` or `monad-core` crate that is difficult to untangle. Extracting crates too early can create empty architecture and unnecessary ceremony. Monad should use incremental modularity: start simple, identify stable seams, then extract.

This approach aligns with domain-driven design without forcing every domain term into a crate immediately. A bounded context should become a crate when it has its own model, tests, dependencies, and change cadence.

It also protects earlier ADRs. Local-first deterministic functionality should not depend on future hosted or AI crates. Plan/apply safety should have a clear model separate from command parsing. Native tool coordination should be isolated behind adapters. Context generation should be usable by humans and AI without requiring AI provider dependencies.

## Scope of the Decision

This ADR applies to:

- Rust workspace crate layout;
- dependency direction between crates;
- when to extract new crates;
- where CLI command parsing should live;
- where domain models should live;
- separation of deterministic local core from optional AI and hosted integrations;
- testing strategy for domain logic;
- future pack, plugin, context, graph, policy, and plan/apply boundaries.

This ADR does not require the immediate creation of every candidate crate. It also does not prohibit temporary modules inside an existing crate while a boundary is still forming.

## Candidate Crate Responsibilities

The following crate boundaries are candidates, not immediate requirements.

### `monad-cli`

Owns the executable surface.

Responsibilities may include:

- command-line parsing;
- top-level command dispatch;
- human-readable output rendering;
- machine-readable output selection;
- exit code mapping;
- CLI help text;
- command catalog exposure;
- shell-facing error presentation.

It should not own most durable domain rules once those rules become reusable or safety-critical.

### `monad-core`

Owns shared foundational contracts.

Responsibilities may include:

- shared result and diagnostic types;
- common identifiers;
- workspace root abstractions;
- command metadata primitives;
- core domain traits;
- shared serialization conventions;
- cross-crate error categories.

It should stay intentionally small. If `monad-core` becomes a dumping ground, the modular architecture has failed.

### `monad-config`

Owns canonical manifest and configuration behavior.

Responsibilities may include:

- `monad.toml` parsing;
- schema version handling;
- `workspace.toml` mirror compatibility;
- `monad.lock` resolution behavior;
- manifest diagnostics;
- config read/write operations;
- migration helpers.

### `monad-inspect`

Owns repository inspection.

Responsibilities may include:

- filesystem scanning;
- repository shape detection;
- native manifest discovery;
- managed unit discovery;
- read-only inspection reports;
- source/generated/native artifact classification.

### `monad-graph`

Owns lifecycle graph modeling and rendering.

Responsibilities may include:

- graph nodes and edges;
- dependency graph extraction;
- lifecycle graph modeling;
- text, JSON, Mermaid, and DOT outputs;
- graph validation;
- graph filtering.

### `monad-context`

Owns deterministic context and handoff generation.

Responsibilities may include:

- context pack model;
- context rendering;
- handoff generation;
- context verification;
- redaction hooks;
- AI-readable but AI-independent artifacts.

### `monad-docs`

Owns documentation lifecycle behavior.

Responsibilities may include:

- documentation checks;
- documentation generation;
- ADR file discovery;
- work packet file discovery;
- docs index validation;
- documentation-as-code rules.

### `monad-policy`

Owns governance and policy concepts.

Responsibilities may include:

- policy findings;
- waivers;
- policy severity;
- policy check orchestration;
- policy result normalization;
- future policy-as-code adapters.

### `monad-plans`

Owns plan-backed mutation.

Responsibilities may include:

- plan schema;
- plan validation;
- diff generation;
- dry-run execution;
- apply execution;
- apply reports;
- protected-file integration;
- stale-plan detection.

### `monad-fs`

Owns filesystem safety.

Responsibilities may include:

- safe path normalization;
- repository-root containment checks;
- protected path rules;
- read/write operation primitives;
- create/update/delete/move safety;
- symlink handling rules;
- dry-run-safe operation modeling.

### `monad-native-tools`

Owns native tool detection and adapters.

Responsibilities may include:

- tool detection;
- version discovery;
- command invocation models;
- native manifest facts;
- normalized tool diagnostics;
- adapter traits for package managers, task runners, linters, formatters, and scanners.

### `monad-packs`

Owns packs, templates, and future extension bundles.

Responsibilities may include:

- pack metadata;
- template metadata;
- installation planning;
- version resolution;
- registry adapter boundaries;
- local pack discovery.

### `monad-ai`

Owns optional AI adapter boundaries.

Responsibilities may include:

- no-op AI adapter;
- provider adapter traits;
- AI request and response models;
- redaction integration;
- AI provenance metadata;
- candidate artifact or plan generation.

This crate must remain optional from the perspective of core deterministic workflows.

### `monad-hosted`

Owns optional hosted control plane integration.

Responsibilities may include:

- remote sync adapters;
- hosted dashboard integration;
- organization/fleet API clients;
- future authentication integration;
- remote policy distribution.

This crate must not be required for local-first core behavior.

## Crate Extraction Rules

A new crate should usually be created only when most of the following are true:

- the domain has meaningful behavior, not just placeholder types;
- the domain has tests or fixtures;
- the domain has a clear public API;
- the domain has dependencies that should not leak into other crates;
- the domain has a different change cadence from surrounding code;
- extracting it reduces CLI or core crate bloat;
- the boundary supports earlier ADRs, such as local-first, AI-optional, or plan-backed mutation;
- the crate can be explained in one or two sentences.

A new crate should usually be avoided when:

- it would contain only empty modules;
- it exists only to mirror a roadmap title;
- it would create circular dependencies;
- its API is not yet understood;
- it makes simple implementation harder without increasing safety or clarity;
- the behavior can remain a private module until the seam stabilizes.

## Dependency Direction Rules

Dependencies should flow inward toward deterministic, local, foundational behavior.

Preferred rules:

- `monad-cli` may depend on domain crates.
- Domain crates should not depend on `monad-cli`.
- Deterministic local crates should not depend on AI or hosted crates.
- AI and hosted crates may depend on context or core abstractions, not the other way around.
- Native tool adapters should not leak shell-specific implementation into core domain models.
- Plan/apply code may depend on filesystem safety, but filesystem safety should not depend on plan/apply code.
- Shared types in `monad-core` should remain minimal and stable.
- Circular dependencies are not allowed.

## Implementation Guidance

Start with practical modularity.

Near-term work may keep many modules in `monad-core` until enough behavior exists to justify extraction. When a module becomes large, independently testable, or dependency-heavy, extract it into a crate with a clear public API.

Each crate should include a short README or module-level documentation once it becomes non-trivial. Crates should expose domain concepts rather than low-level implementation details.

The CLI crate should remain thin. Command handlers may orchestrate domain services, but they should not become the long-term home for manifest resolution, graph construction, context generation, policy evaluation, or filesystem mutation logic.

Crate boundaries should be enforced by tests, dependency checks, and review discipline rather than by documentation alone.

## Consequences

### Positive Consequences

- The Rust codebase can grow without forcing all behavior into the CLI crate.
- Domain logic becomes easier to test independently.
- Optional AI and hosted capabilities can remain outside deterministic local core behavior.
- Bounded contexts become easier to reason about.
- Dependency management becomes more intentional.
- Refactoring becomes safer once crate boundaries stabilize.
- The architecture can evolve toward governance-grade behavior without a single monolithic crate.

### Negative Consequences

- More crates create more workspace overhead.
- Premature boundaries can slow implementation.
- Public APIs between crates require maintenance.
- Dependency direction requires discipline.
- Refactoring may be needed as domain seams become clearer.
- Contributors may need guidance to know where new behavior belongs.

### Required Mitigations

- Avoid creating empty roadmap crates.
- Extract crates only when real behavior and tests justify them.
- Keep `monad-cli` thin and presentation-focused.
- Keep `monad-core` small and foundational.
- Document crate responsibilities as they become non-trivial.
- Enforce no dependency from deterministic core crates to optional AI or hosted crates.
- Watch for circular dependencies and crate bloat.
- Prefer private modules until boundaries stabilize.

## Alternatives Considered

### Single Crate

Monad could keep all implementation in one crate.

This is acceptable for very early bootstrapping, but it is risky long-term. Monad's scope includes too many distinct responsibilities for one crate to remain clear, testable, and maintainable indefinitely.

### One Crate Per Command

Monad could create a crate for every CLI command or command group.

This was rejected because command boundaries are not always domain boundaries. One crate per command would create fragmentation, duplicate shared models, and make cross-command workflows harder to implement.

### One Crate Per Roadmap Item

Monad could mirror every roadmap item or work packet as a crate.

This was rejected because roadmap structure is planning structure, not necessarily runtime architecture. Crates should follow stable implementation boundaries, not documentation hierarchy.

### Plugin-First Crate Layout

Monad could design everything as plugins from the beginning.

This was rejected for the near term because plugin architecture should not precede core trust, local-first behavior, manifest semantics, graphing, and plan-backed mutation. Plugin boundaries can be introduced later once core contracts are stable.

### Monolithic Core with Feature Flags Only

Monad could keep a large `monad-core` crate and rely on feature flags for optional behavior.

This was rejected as the long-term default because feature flags alone do not create strong domain boundaries. They can help with optional dependencies, but they do not replace clear crate ownership where independent bounded contexts emerge.

## Validation

This decision is validated when:

- the CLI crate remains focused on parsing, dispatch, and presentation;
- reusable domain behavior lives outside the CLI crate once it becomes non-trivial;
- `monad-core` remains foundational rather than becoming a dumping ground;
- new crates are introduced only when they contain meaningful logic and tests;
- deterministic local behavior does not depend on AI or hosted integration crates;
- crate APIs are documented enough for contributors to understand ownership;
- dependency direction remains acyclic and intentional;
- workspace validation catches unintended dependency drift over time.

## Review Criteria

This ADR should be reconsidered if:

- modularity overhead slows development more than it improves safety and maintainability;
- the project intentionally narrows scope enough that a single crate becomes sufficient;
- the implementation discovers better domain boundaries than the candidate crate list;
- Rust workspace ergonomics or distribution requirements make the proposed crate model impractical;
- a later plugin or extension architecture supersedes the crate layout assumptions.

Because this ADR is Proposed, it may be refined as implementation evidence accumulates. The protected principle is practical modularity, not the exact candidate crate list.

## Related Decisions

This ADR relates to:

- ADR-0001, which establishes Rust as the core single-binary runtime language;
- ADR-0002, which establishes native tool coordination over replacement;
- ADR-0003, which establishes local-first operation;
- ADR-0004, which establishes AI-native but AI-optional behavior;
- ADR-0005, which establishes `monad.toml` as canonical manifest;
- ADR-0006, which establishes plan-backed mutation;
- future decisions about lifecycle graph modeling;
- future decisions about context generation and AI adapter boundaries;
- future decisions about plugins, packs, and hosted control plane integration.
