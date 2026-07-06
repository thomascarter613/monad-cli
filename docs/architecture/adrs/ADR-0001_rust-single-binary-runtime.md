---
id: ADR-0001
title: Use Rust for Monad CLI and Single-Binary Runtime
status: accepted
date: 2026-07-02
supersedes: []
superseded_by: null
tags: [rust, cli, single-binary, runtime, v1]
---

# ADR-0001: Use Rust for Monad CLI and Single-Binary Runtime

## Status

Accepted.

## Context

Monad is a local-first monorepo operating runtime exposed through a command-line interface named `monad`. It is expected to initialize, inspect, modify, validate, document, graph, govern, and hand off serious monorepos using a stable developer-facing and CI-facing command surface.

Monad is not only a scaffolder. It is intended to become a governance-grade repo runtime that can:

- create governed repository foundations;
- add, remove, move, rename, and generate workspace units;
- inspect repository state without mutation;
- plan, diff, and apply controlled changes;
- validate manifests, policies, documentation, and generated state;
- produce machine-readable output for CI and automation;
- generate context artifacts for humans and AI agents;
- preserve user work and avoid silent destructive behavior.

Those goals put pressure on the implementation language. The core runtime must be reliable enough for filesystem mutation, fast enough for repeated local use, portable enough to distribute easily, and explicit enough to support long-term governance semantics. It must also be usable by a solo maintainer without requiring a large service platform or heavy runtime dependency chain.

Monad must coordinate many external ecosystems, including JavaScript/TypeScript, Rust, Go, Python, Java, infrastructure tools, package managers, task runners, policy tools, and documentation generators. However, the core orchestration layer needs one canonical implementation language so that command contracts, plan/apply behavior, manifest parsing, graph construction, validation, and filesystem safety rules remain coherent.

## Decision

Monad's core CLI and local runtime will be implemented in Rust and distributed as a native single binary named `monad`.

Rust is the implementation language for the core runtime, including command dispatch, manifest loading, workspace inspection, graph construction, plan generation, safe filesystem mutation, validation, policy orchestration, context generation, and machine-readable output.

This decision does not require every generated project, pack, template, hook, or integration to be implemented in Rust. Monad may generate and coordinate code in TypeScript, JavaScript, Go, Python, Java, PHP, infrastructure languages, shell scripts, and other ecosystem-native formats. Rust owns the runtime boundary; generated repositories may remain polyglot.

## Decision Drivers

The core runtime needs the following properties:

- **Single-binary distribution:** users should be able to install and run `monad` without first installing Node.js, Python, a JVM, or a long chain of transitive runtime dependencies.
- **Local-first operation:** common commands should run against the local repository without requiring a hosted control plane.
- **Filesystem safety:** commands that write files must be explicit, testable, and able to support dry-run and plan-first workflows.
- **Deterministic behavior:** the same repository state and command input should produce predictable output, especially for CI and governance workflows.
- **Strong domain modeling:** manifests, work packets, ADRs, graphs, policies, plans, waivers, and generated artifacts should be represented by typed data structures instead of loosely coupled string manipulation.
- **Performance:** inspection, graphing, validation, and context generation should remain fast enough to run frequently.
- **Cross-platform support:** the CLI should be practical on Linux, macOS, Windows, devcontainers, CI runners, and future packaged distributions.
- **Long-term maintainability:** the implementation should make invalid states hard to represent and refactors relatively safe as the command surface grows.
- **AI-readiness without AI-dependence:** the runtime should produce structured context and evidence artifacts without requiring AI services to execute ordinary repository operations.

## Rationale

Rust is a strong fit for Monad because it combines systems-level control with modern safety guarantees and high-quality CLI ergonomics.

The ownership and borrowing model makes many classes of memory errors impossible without relying on a garbage-collected runtime. The type system encourages explicit modeling of command inputs, workspace state, manifests, graph nodes, generated plans, diagnostics, and error variants. This is important because Monad is expected to make controlled changes to user repositories; ambiguous or loosely modeled state would increase the risk of destructive behavior.

Rust also supports a practical single-binary distribution model. A single compiled executable aligns with Monad's local-first doctrine: users can run the tool in a fresh repository, a devcontainer, or CI without bootstrapping a language-specific application runtime first. This is especially important for a tool that will manage polyglot monorepos rather than belong exclusively to one language ecosystem.

Rust's performance profile is useful for repository inspection, graph generation, schema validation, filesystem traversal, and context packaging. Monad should be fast enough to encourage frequent use rather than become a heavyweight governance step that developers avoid.

Rust's ecosystem provides mature building blocks for command-line parsing, structured serialization, error reporting, filesystem traversal, async execution, testing, and cross-platform packaging. The project can use those building blocks while keeping Monad's own domain model explicit and testable.

## Scope of the Decision

This ADR applies to:

- the `monad` executable;
- core command routing and command contracts;
- workspace and repository inspection logic;
- manifest and lockfile parsing;
- plan, diff, and apply orchestration;
- graph construction and output rendering;
- policy, waiver, and governance orchestration;
- context and handoff artifact generation;
- validation and diagnostic output;
- filesystem safety and mutation boundaries.

This ADR does not require Rust for:

- generated application source code;
- generated service source code;
- generated frontend projects;
- ecosystem-native package manager files;
- third-party tools that Monad coordinates;
- templates, examples, and packs where another language is the correct ecosystem-native choice;
- future hosted services or UI surfaces that may be implemented with other technologies.

## Implementation Guidance

The Rust runtime should be organized around explicit domain boundaries rather than one large command file. The preferred direction is a multi-crate workspace where the CLI crate handles command-line concerns and core crates model durable concepts such as manifests, workspace units, graphs, plans, policies, diagnostics, and filesystem operations.

Commands should follow Monad's command doctrine:

- inspection commands do not mutate;
- mutating commands support `--dry-run` where practical;
- significant changes are expressible as plans;
- applied plans are auditable;
- CI-relevant commands support machine-readable output.

The Rust implementation should prefer structured errors and diagnostics over ad hoc strings. Human-readable output and machine-readable output should be rendered from the same underlying diagnostic model wherever possible.

Filesystem writes should pass through a controlled boundary that can support previews, idempotency checks, overwrite protection, and future rollback or evidence capture. Direct, scattered writes from unrelated command code should be avoided.

External tools should be invoked through adapters rather than embedded directly into core domain logic. This keeps Monad capable of coordinating native ecosystems without turning the Rust runtime into an unstructured shell-script replacement.

## Consequences

### Positive Consequences

- Monad can be distributed as a native binary with minimal runtime prerequisites.
- The core runtime can remain local-first and usable in fresh repositories, CI jobs, and devcontainers.
- Strong typing improves safety for manifests, plans, graph data, policy findings, and diagnostics.
- Rust's performance helps keep inspection, graphing, validation, and context generation fast.
- The implementation can scale toward a governance-grade runtime without giving up systems-level control.
- Cross-platform support is practical without binding the tool to a single language ecosystem.
- The runtime can coordinate polyglot repositories while remaining implemented in one coherent core language.

### Negative Consequences

- Rust has more implementation ceremony than scripting languages for small features.
- Some contributors may face a steeper learning curve than they would with TypeScript or Python.
- Rapid prototyping can be slower when compared with dynamic languages.
- Compile times and dependency management must be watched as the workspace grows.
- Integrations with JavaScript, Python, or JVM ecosystems may require explicit adapter design rather than direct in-process reuse of ecosystem libraries.

### Required Mitigations

- Keep command handlers small and push reusable behavior into tested core modules.
- Use clear crate boundaries to prevent the CLI layer from accumulating all domain logic.
- Maintain fast local validation commands so contributors can iterate confidently.
- Document common contribution patterns for new commands, diagnostics, plans, and filesystem changes.
- Prefer adapter interfaces for external tools so that integration complexity is isolated.
- Avoid reimplementing ecosystem-native package managers, task runners, or build systems unless there is a specific Monad governance reason to do so.

## Alternatives Considered

### TypeScript / JavaScript

TypeScript would provide fast iteration, a very large package ecosystem, and excellent familiarity for web-oriented monorepo users. It would also align naturally with Bun, pnpm, npm, Turborepo, Biome, and many frontend/backend templates.

It was not selected for the core runtime because it would usually require a JavaScript runtime to be present before `monad` can run. That conflicts with the goal of a portable, single-binary, ecosystem-agnostic repo runtime. TypeScript remains a first-class target for generated projects, templates, packs, and integrations.

### Go

Go would provide simple cross-compilation, strong CLI ergonomics, fast builds, and a straightforward concurrency model. It is a credible alternative for a single-binary infrastructure CLI.

Rust was selected over Go because Monad's long-term domain model benefits from Rust's stronger type expressiveness, ownership model, enum-based error modeling, and safety guarantees around complex state transitions. Go remains an acceptable language for generated services or future integrations where it is the best ecosystem fit.

### Python

Python would provide excellent scripting speed, rich automation libraries, and strong AI/data ecosystem access.

It was not selected for the core runtime because Python distribution, dependency isolation, startup consistency, and runtime availability are weaker fits for a governance-grade single-binary CLI. Python remains appropriate for generated AI, data, automation, or analysis components where its ecosystem is the right choice.

### Shell Scripts

Shell scripts are useful for thin wrappers, bootstrap helpers, and local automation.

They were not selected for the core runtime because shell is difficult to make portable, type-safe, testable, and robust for complex repository mutation. Shell may still be generated or coordinated for ecosystem-native tasks, but it should not be the primary implementation language for Monad's core logic.

### JVM Languages

JVM languages offer strong ecosystems, mature tooling, and good enterprise integration options.

They were not selected for the core runtime because the JVM introduces a heavier runtime dependency and distribution model than the desired single-binary local-first experience. JVM languages may still be generated or coordinated for enterprise service templates and integrations.

## Validation

This decision is validated when:

- the repository builds a native `monad` binary from the Rust workspace;
- local validation can run without requiring a hosted Monad service;
- command contracts are represented by typed Rust structures and tests;
- filesystem-mutating commands can support dry-run or plan-first behavior;
- machine-readable outputs are generated through structured Rust data models;
- generated project templates remain free to use ecosystem-native languages and tools;
- documentation clearly distinguishes the Rust runtime from the polyglot repositories it manages.

## Review Criteria

This ADR should be reconsidered only if one of the following becomes true:

- Rust prevents Monad from meeting its core local-first or governance-grade goals;
- distribution requirements change so that a single binary is no longer important;
- another implementation language provides materially better safety, portability, and maintainability for the same scope;
- the project intentionally splits the local runtime from a separate hosted control plane with different implementation constraints.

Even if a future hosted service, UI, plugin registry, or enterprise control plane uses another technology, that does not automatically supersede this ADR. This ADR governs the local `monad` runtime.

## Related Decisions

Future or companion ADRs should further specify:

- how Monad coordinates native ecosystem tools;
- workspace crate/module boundaries;
- manifest and lockfile ownership;
- async/runtime strategy;
- plugin and pack execution boundaries;
- filesystem safety and protected-file policy;
- plan/diff/apply semantics;
- distribution, release, and installation strategy.
