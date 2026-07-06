---
id: ADR-0003
title: Local-First Core
status: accepted
date: 2026-07-02
supersedes: []
superseded_by: null
tags: [local-first, offline, privacy, runtime, cli, v1]
---

# ADR-0003: Local-First Core

## Status

Accepted.

## Context

Monad is intended to be a local-first monorepo operating runtime and SDLC control plane. Its first and most important runtime surface is the `monad` CLI running against a repository on the developer's machine, in a devcontainer, or in CI.

Monad's value should not require SaaS infrastructure, a hosted database, a browser dashboard, a cloud account, an organization account, an AI provider, telemetry, or a remote daemon. A developer should be able to clone a repository, install or build the `monad` binary, and use core Monad capabilities directly against the local filesystem.

The baseline topology is:

```text
Developer machine
  └─ monad binary
      └─ local repository
```

This local-first posture is especially important because Monad may operate on sensitive material, including private source code, architecture decisions, work packets, governance artifacts, policies, context packs, dependency graphs, security findings, generated plans, and future mutation evidence.

A hosted-first model would increase trust barriers before Monad has earned local credibility. It would also add authentication, tenancy, persistence, billing, deployment, operations, synchronization, and privacy concerns before the core runtime is stable.

Monad may eventually support hosted dashboards, organization views, repository fleet visibility, remote policy management, hosted context indexing, or collaborative governance workflows. Those capabilities should be optional extensions, not prerequisites for core value.

## Decision

Monad's core functionality will work locally against the repository filesystem.

Core commands should not require network access, hosted services, external databases, telemetry endpoints, organization accounts, browser dashboards, or AI providers. The local CLI is the primary runtime and must remain useful without a hosted control plane.

The local runtime may read and write local repository files according to explicit command contracts. It may use local state under `.monad/` for generated state, cache data, reports, context artifacts, plans, and other inspectable runtime outputs. Any such state must remain local, transparent, and safe to remove or regenerate unless explicitly documented otherwise.

Hosted sync, hosted dashboards, shared organization policy, fleet-level views, cloud execution, and team collaboration features are future optional capabilities. They must not become required for core repository initialization, inspection, validation, graphing, documentation checks, context generation, plan generation, or safe local mutation.

## Decision Drivers

This decision is driven by the following needs:

- **Trust:** users are more likely to adopt Monad if it works on their private repositories without sending source code or governance artifacts to a service.
- **Privacy:** repository context, policies, plans, and AI handoff artifacts may contain sensitive intellectual property or security-relevant information.
- **Bootstrap simplicity:** a solo developer should not need to deploy infrastructure before receiving value from Monad.
- **Offline capability:** core commands should be usable in offline, air-gapped, CI, devcontainer, or constrained environments.
- **Open-source viability:** a local-first CLI is easier to evaluate, fork, audit, test, and contribute to than a SaaS-first system.
- **Cost control:** early usage should not require cloud hosting, database operations, remote indexing, or paid API calls.
- **Determinism:** local commands should produce predictable results from local repository state.
- **Safety:** mutating commands should be plan-backed and auditable locally before any remote collaboration layer exists.
- **Future optionality:** a hosted control plane can be added later without undermining the local runtime boundary.

## Rationale

Monad's durable product value begins with repository understanding and safe local control. If the CLI cannot inspect, validate, graph, document, plan, and explain a repository locally, a hosted control plane would only mask weakness in the core runtime.

A local-first design makes Monad useful in the places where developers already work: terminal sessions, local repositories, devcontainers, CI jobs, and code review workflows. It also aligns with the project's governance goals. Governance artifacts should be available as files, not only as records in a remote service.

Local-first does not mean local-only forever. It means the local runtime remains the foundation of correctness. A hosted layer may eventually aggregate reports, coordinate teams, manage policy distribution, or display repository fleets, but it should consume and enhance local evidence rather than become the source of truth for basic repository operations.

This model also improves AI safety. AI workflows should be built on deterministic local context generation and explicit user-approved plans. Core functionality should remain useful even when AI is unavailable, disabled, untrusted, or intentionally excluded.

## Scope of the Decision

This ADR applies to core Monad capabilities such as:

- repository root detection;
- manifest loading and validation;
- workspace inspection;
- command catalog integrity;
- graph generation;
- policy and governance checks;
- documentation checks;
- ADR and work packet management;
- context and handoff generation;
- plan, diff, and apply workflows;
- local diagnostics and reports;
- local state under `.monad/`;
- CI execution of core commands.

This ADR does not prohibit optional network-aware capabilities such as:

- checking for new Monad releases;
- installing packs or templates from an explicit registry;
- publishing releases;
- integrating with GitHub or another forge when explicitly requested;
- synchronizing with a future hosted control plane;
- using an AI provider when explicitly configured;
- downloading remote templates, schemas, or policies when explicitly requested.

The distinction is that network behavior must be explicit, optional, and non-essential for core local operation.

## Local State Model

Monad may use `.monad/` as a local runtime state directory for generated or derived artifacts. Examples may include:

- local cache entries;
- generated reports;
- generated context packs;
- generated handoff documents;
- generated plans;
- snapshots or fingerprints used for validation;
- local diagnostic evidence;
- tool detection cache where safe and useful.

Local state should follow these principles:

- it must be inspectable by users;
- it must not silently upload data;
- it should be safe to delete unless a specific artifact is documented as user-owned evidence;
- it should avoid becoming a hidden conflicting source of truth;
- it should not override `monad.toml` or repository-native manifests;
- it should be governed by clear ignore/commit recommendations depending on artifact type.

## Network and Telemetry Rules

Core commands should follow a no-network-by-default rule.

A command that needs network access should make that behavior clear through its name, documentation, configuration, or flags. Network access should not be hidden inside ordinary inspection, check, graph, context, plan, or apply commands unless the user has explicitly configured a network-backed feature.

Telemetry should be disabled by default. If telemetry is ever introduced, it must be opt-in, documented, and separable from core correctness. Monad should never require telemetry to validate or mutate a repository.

## Implementation Guidance

The implementation should separate local core behavior from optional remote adapters.

Recommended boundaries:

- local repository model;
- local manifest loader;
- local filesystem safety layer;
- local graph builder;
- local diagnostics model;
- local context generator;
- local plan/diff/apply engine;
- optional remote registry adapter;
- optional forge adapter;
- optional hosted-control-plane adapter;
- optional AI provider adapter.

Core command handlers should not import hosted-specific code directly. Remote integrations should be explicit dependencies behind adapter interfaces so that the local runtime can remain testable without credentials, network access, or service mocks.

Tests should include offline execution assumptions for core commands. Documentation should clearly distinguish local-first core behavior from optional hosted or network-aware features.

## Consequences

### Positive Consequences

- Users can evaluate and use Monad without deploying infrastructure.
- Monad is useful for private repositories and sensitive codebases.
- Core commands are easier to test, debug, and reason about.
- The project avoids premature SaaS complexity.
- Local-first behavior supports open-source adoption and forkability.
- Core workflows can run in CI without a Monad-hosted service.
- Privacy and trust posture are stronger from the beginning.
- A future hosted control plane can be layered on top of local evidence.

### Negative Consequences

- Collaboration features are deferred or limited in early versions.
- There is no central dashboard as a core dependency.
- Multi-repository and organization-wide visibility come later.
- Local performance, cache invalidation, and filesystem behavior matter more.
- Users must manage local files, local state, and local tool availability.
- Some SaaS-style features require explicit later architecture rather than being assumed from day one.

### Required Mitigations

- Keep core commands offline-capable.
- Make missing local tools produce actionable diagnostics.
- Keep `.monad/` state inspectable and documented.
- Separate local source-of-truth files from generated or cached state.
- Do not silently call network services from core commands.
- Keep hosted sync and AI provider integrations behind explicit configuration.
- Add tests or architecture checks that protect no-network-by-default behavior.
- Document which generated artifacts are safe to delete and which should be retained.

## Alternatives Considered

### Hosted-First SaaS Control Plane

Monad could begin as a hosted product where repositories connect to a cloud service for indexing, policy management, graphing, dashboards, team collaboration, and AI workflows.

This was rejected for the core architecture because it creates privacy, cost, trust, operations, tenancy, authentication, and deployment complexity before the local runtime is proven. It also makes Monad less useful for offline, private, air-gapped, or solo-developer workflows.

### Local Daemon with Remote Sync from Day One

Monad could run a local background daemon that watches repositories and synchronizes with a hosted service.

This was rejected as an initial requirement because it adds process lifecycle complexity, background state, networking concerns, debugging burden, and trust questions. A daemon may be considered later for specific advanced use cases, but it should not be required for core CLI behavior.

### CI-Only Control Plane

Monad could operate primarily in CI, producing repository reports and governance findings after code is pushed.

This was rejected because developers need repository understanding before CI. Local feedback is essential for safe mutation, planning, graphing, context generation, and documentation workflows. CI should be another execution environment for Monad, not the only one.

### AI-Hosted Control Plane

Monad could rely on hosted AI services to read repositories, explain architecture, suggest changes, and generate plans.

This was rejected because deterministic local context and policy boundaries must exist before AI assistance is safe. AI may enhance Monad later, but it must not become the foundation of core correctness or repository access.

## Validation

This decision is validated when:

- `monad` can initialize, inspect, check, graph, and generate context locally;
- core commands work without network access;
- core commands work without a hosted Monad account;
- core commands work without an AI provider;
- local state is stored under documented repository-local paths;
- generated local reports and plans are human-readable or machine-readable without a remote service;
- CI can run core Monad checks without contacting a Monad-hosted backend;
- documentation describes optional network-aware features separately from local core behavior.

## Review Criteria

This ADR should be reconsidered only if:

- Monad intentionally becomes a SaaS-first product and accepts the privacy/adoption tradeoff;
- local-only operation becomes impossible for core repository governance workflows;
- a hosted backend becomes necessary for correctness rather than convenience;
- the project explicitly chooses a team/fleet management model that supersedes local-first operation.

A future hosted control plane may extend Monad, but it should not silently supersede this decision. Local-first remains the foundation unless a later ADR explicitly replaces it.

## Related Decisions

This ADR relates to:

- ADR-0001, which establishes the Rust single-binary runtime;
- ADR-0002, which establishes native tool coordination over replacement;
- future decisions about AI-native but AI-optional architecture;
- future decisions about `monad.toml`, `monad.lock`, and `.monad/` state;
- future decisions about plan-backed mutation and filesystem safety;
- future decisions about hosted control plane boundaries;
- future decisions about telemetry, registry access, and remote sync.
