---
id: ADR-0002
title: Coordinate Native Tools Instead of Replacing Them
status: accepted
date: 2026-07-02
supersedes: []
superseded_by: null
tags: [tooling, orchestration, monorepo, local-first, governance, v1]
---

# ADR-0002: Coordinate Native Tools Instead of Replacing Them

## Status

Accepted.

## Context

Monad is a local-first, governance-grade monorepo runtime. It must help developers initialize, inspect, validate, document, graph, govern, and evolve serious monorepos without silently damaging user work.

A monorepo is not one tool. It is a system of many overlapping toolchains and conventions. Real repositories commonly include language package managers, build systems, task runners, formatters, linters, test frameworks, code generators, documentation tools, container tooling, infrastructure tooling, policy engines, CI providers, secret scanners, dependency scanners, release tooling, and application frameworks.

Monad needs to operate across polyglot repositories. A single workspace may contain TypeScript apps, Rust crates, Go services, Python workers, Java services, infrastructure modules, policy files, generated contracts, documentation, and automation scripts. Each ecosystem already has native tools that developers know and that frameworks expect.

Monad could attempt to replace those tools with one universal build system and one universal task model. That approach would make Monad more powerful in theory, but it would also increase implementation scope dramatically, duplicate mature ecosystems, and create adoption friction. It would force users to translate existing repository behavior into Monad-specific abstractions before Monad can provide value.

The project goal is different. Monad should become the repo operating layer: a stable CLI and runtime that understands repository intent, coordinates native tools, adds governance boundaries, produces plans and evidence, and provides consistent human and machine interfaces.

## Decision

Monad will coordinate native ecosystem tools instead of replacing them by default.

Monad will act as an orchestration, governance, inspection, planning, validation, and context layer over the tools a repository already uses or intentionally adopts. It may generate configuration for native tools, invoke native tools, validate native tool outputs, explain tool state, synchronize Monad metadata with native manifests, and produce plans that modify native configuration. It will not attempt to become the default replacement for every package manager, task runner, formatter, linter, test framework, build system, release tool, infrastructure tool, or policy engine.

In practical terms:

- Bun, pnpm, npm, yarn, Cargo, Go tooling, Python tooling, Maven, Gradle, Docker, Terraform, Pulumi, Biome, ESLint, Prettier, Lefthook, Turborepo, Moon, OpenTelemetry tools, policy engines, and similar ecosystem tools remain valid native tools.
- Monad may provide a consistent command surface over those tools.
- Monad may choose recommended defaults for newly initialized governed repositories.
- Monad may generate, validate, and synchronize configuration files used by those tools.
- Monad may add governance rules and safety checks around tool usage.
- Monad may expose plans, diffs, diagnostics, evidence, and machine-readable reports for tool-driven operations.
- Monad should avoid reimplementing mature ecosystem functionality unless there is a specific governance, safety, portability, or user-experience reason to do so.

## Decision Drivers

This decision is driven by the following needs:

- **Adoption:** existing repositories should be able to gain Monad governance and inspection capabilities without replacing their entire toolchain first.
- **Polyglot support:** Monad must support many languages and frameworks without treating one ecosystem as the only first-class path.
- **Local-first usefulness:** Monad should run locally and coordinate tools already installed in the user's environment or devcontainer.
- **Governance over reinvention:** Monad's durable value is policy, intent, planning, evidence, graphing, and safe change orchestration, not rewriting every mature tool.
- **Ecosystem compatibility:** frameworks and package managers often expect their own native files, commands, and conventions.
- **Maintainability:** a solo-maintainable core must avoid becoming a replacement implementation for package management, builds, formatting, testing, deployment, observability, and release engineering all at once.
- **User trust:** users are more likely to trust Monad if it can explain and coordinate familiar tools rather than hide them behind opaque abstractions.
- **AI-readiness:** AI agents need high-quality repository context and safe execution boundaries; they do not require Monad to replace every underlying tool.

## Rationale

The strongest role for Monad is to become the repository control plane layer, not the universal implementation of all developer tooling.

Native tools encode ecosystem knowledge that would be expensive and risky to duplicate. Package managers understand lockfiles, registries, dependency resolution, workspace semantics, publishing rules, and ecosystem-specific lifecycle hooks. Framework generators understand their own file structures and conventions. Build systems understand caching and task execution. Linters and formatters understand language syntax. Policy tools and scanners understand specialized domains. Replacing all of that would slow Monad down and reduce compatibility.

Coordinating native tools allows Monad to focus on the higher-order problems that cut across all tools:

- what the repository is supposed to contain;
- which files are canonical source-of-truth files;
- which generated files must stay synchronized;
- which commands are inspect-only and which can mutate;
- which mutations require a plan, diff, dry-run, or confirmation;
- how to represent workspace units, dependencies, tasks, policies, ADRs, and work packets;
- how to detect drift between intent and implementation;
- how to produce evidence for humans, CI systems, and AI agents;
- how to protect user work from unsafe or surprising changes.

This approach gives Monad a clear boundary: it owns repo intent and orchestration semantics, while native tools own ecosystem-specific execution. Monad can still provide a unified interface, but that interface should be transparent about what is being invoked and what files are being changed.

## Scope of the Decision

This ADR applies to:

- task execution strategy;
- package manager coordination;
- framework generator coordination;
- formatter, linter, and test orchestration;
- build and graph integration;
- policy and scanner integration;
- documentation and context generation;
- release and changelog orchestration;
- infrastructure and deployment tool coordination;
- template, pack, and plugin execution boundaries.

This ADR does not prevent Monad from implementing internal logic where native tools are insufficient. Monad may still implement:

- workspace manifest parsing;
- lockfile and state management for Monad's own data;
- graph modeling across ecosystems;
- plan, diff, and apply semantics;
- protected-file and filesystem safety rules;
- policy evaluation orchestration and result normalization;
- context pack generation;
- ADR and work packet management;
- diagnostics and reporting;
- adapters for invoking tools consistently.

## Implementation Guidance

Monad should model native tools through explicit adapters rather than scattering shell command strings throughout command handlers.

A native tool adapter should define:

- the tool identity and supported versions where relevant;
- how Monad detects whether the tool is present;
- how Monad determines whether the repository uses the tool;
- which commands Monad may invoke;
- which files the tool owns or mutates;
- how dry-run, check, write, and fix modes map onto the tool;
- how stdout, stderr, exit codes, and generated artifacts become structured diagnostics;
- how failures are surfaced to users and CI;
- what fallback behavior exists when the tool is missing.

Monad should prefer a plan-first model for operations that modify native tool configuration. For example, adding a workspace unit may require updates to `monad.toml`, package manager workspace configuration, task runner configuration, documentation, and policy metadata. Monad should be able to present that as a coherent plan before applying changes.

When invoking native tools, Monad should be explicit. Users should be able to understand what command was run, why it was run, what inputs it used, what files changed, and what evidence was produced.

Monad should avoid storing hidden state that contradicts native tool state. Where Monad has a canonical manifest, it should define synchronization rules with native manifests rather than pretend native files do not exist.

Monad should not wrap every possible flag of every native tool. It should expose stable, governance-relevant workflows and leave advanced tool-specific workflows available through the native tool itself.

## Expected Native Tool Categories

Monad may coordinate tools in categories such as:

- package managers: Bun, pnpm, npm, yarn, Cargo, pip/uv/Poetry, Go modules, Maven, Gradle;
- task runners and build systems: Moon, Turborepo, Make, Just, Cargo, Gradle, framework CLIs;
- formatters and linters: Biome, rustfmt, clippy, gofmt, Ruff, ESLint, Prettier;
- test runners: cargo test, Vitest, Jest, Playwright, pytest, Go test, JUnit ecosystems;
- framework generators: Next.js, TanStack Start, SolidJS, Elysia, FastAPI, Axum, Spring, NestJS;
- policy and security tools: gitleaks, cargo-deny, Trivy, OpenSSF Scorecard, OPA-compatible tooling;
- documentation tools: Markdown generators, OpenAPI/Scalar tooling, AsyncAPI tooling, graph renderers;
- infrastructure tools: Docker, Compose, Terraform, Pulumi, Nomad, Kubernetes tooling;
- observability tools: OpenTelemetry collectors and local observability stacks;
- release tools: Changesets, changelog generators, GitHub release automation.

This list is not exhaustive. The key rule is that Monad coordinates native tools through stable boundaries instead of replacing them wholesale.

## Consequences

### Positive Consequences

- Monad can support existing repositories sooner because it does not require a full toolchain migration.
- Monad can remain polyglot and ecosystem-agnostic while still offering strong defaults.
- The core runtime remains smaller and more maintainable.
- Users can continue using familiar framework and language tools directly when needed.
- Monad can focus on repo intent, governance, safety, context, and evidence.
- Native tools continue to evolve independently without requiring Monad to mirror every feature.
- The architecture supports plugins, packs, and adapters as extension points.

### Negative Consequences

- Behavior may vary across ecosystems because native tools have different semantics and quality levels.
- Monad must handle missing tools, version mismatches, platform differences, and inconsistent output formats.
- Some workflows may require adapters before they can be fully governed by Monad.
- Users may occasionally need to debug both Monad and the underlying native tool.
- Full determinism is harder when external tools are involved.
- There is a risk of thin wrapper commands that do not add enough Monad-specific value.

### Required Mitigations

- Define clear adapter interfaces for native tool detection, invocation, diagnostics, and owned files.
- Normalize native tool results into structured Monad diagnostics.
- Keep command output transparent about underlying tool invocations.
- Distinguish between Monad-owned files, native-tool-owned files, generated files, and user-owned files.
- Support dry-run and plan-first behavior for Monad-managed configuration changes.
- Make missing-tool diagnostics actionable.
- Avoid wrapping native tools unless Monad adds governance, safety, context, planning, validation, or evidence value.
- Prefer stable contracts over one-off command glue.

## Alternatives Considered

### Replace Native Tools with a Monad Build System

Monad could become a full build system and task runner that replaces Turborepo, Moon, Make, Cargo workflows, language task runners, and framework-specific commands.

This was rejected for v1 because it dramatically expands scope and risks forcing users to migrate before receiving value. It would also duplicate mature tools and pull Monad away from its core governance and orchestration mission.

### Use One Existing Tool as the Mandatory Backend

Monad could require one primary underlying system such as Bazel, Pants, Buck2, Nx, Turborepo, or Moon, and build all functionality around that backend.

This was rejected because Monad is intended to coordinate native tools across many repository styles. A mandatory backend would reduce flexibility, increase adoption friction, and tie Monad's long-term architecture to another tool's assumptions.

### Use Shell Scripts as the Integration Layer

Monad could mostly generate and run shell scripts that call native tools.

This was rejected as the primary architecture because shell scripts are difficult to make portable, strongly typed, testable, auditable, and safe for complex repository mutation. Shell may still be generated or invoked in narrow cases, but it should not be the central integration model.

### Implement Only Templates and Avoid Runtime Coordination

Monad could be a pure repository template generator that writes starter files and then exits permanently from the lifecycle.

This was rejected because Monad's intended value extends beyond initialization. It must inspect, validate, govern, plan, diff, apply, document, and generate context over the lifetime of the repository.

## Validation

This decision is validated when:

- Monad can initialize a governed repository while writing native configuration files rather than proprietary-only equivalents;
- Monad can inspect and explain native tool configuration in a structured way;
- Monad can run validation workflows through native tools while normalizing diagnostics;
- Monad can produce dry-run plans for changes that affect native tool configuration;
- users can still run native tools directly outside Monad where appropriate;
- Monad's command surface adds governance and safety value rather than merely hiding native commands;
- generated repositories remain understandable to developers who know the underlying ecosystems.

## Review Criteria

This ADR should be reconsidered only if:

- native tool coordination proves too inconsistent to support Monad's governance goals;
- the project deliberately narrows scope to a single ecosystem where a replacement runtime is justified;
- a future Monad-specific execution engine becomes necessary for safety, determinism, or governance reasons that native tools cannot satisfy;
- a mandatory external backend becomes strategically preferable and the adoption tradeoff is accepted explicitly in a superseding ADR.

A future specialized execution engine may complement this ADR, but it should not silently reverse the default principle that Monad coordinates ecosystem-native tools rather than replacing them wholesale.

## Related Decisions

This ADR relates to:

- ADR-0001, which establishes Rust as the core single-binary runtime language;
- future decisions about workspace manifests and native manifest synchronization;
- future decisions about task graph generation and execution;
- future decisions about plugin and pack boundaries;
- future decisions about filesystem safety, protected files, and plan/diff/apply semantics;
- future decisions about default package manager and governed repository presets.
