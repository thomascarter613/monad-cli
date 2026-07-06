---
id: ADR-0018
title: Hosted Control Plane Is Optional Projection Layer
status: accepted
date: 2026-07-06
supersedes: []
superseded_by: null
tags: [hosted, control-plane, local-first, projection, optional, v1]
---

# ADR-0018: Hosted Control Plane Is Optional Projection Layer

## Status

Accepted.

## Context

Monad is local-first. Core repository understanding, validation, graphing, context generation, policy checks, and plan-backed mutation must work locally without a hosted service.

A hosted control plane may become valuable later for team collaboration, dashboards, organization-wide policy, fleet visibility, repository inventory, hosted graph views, release evidence aggregation, and shared governance workflows.

However, a hosted-first model would undermine early trust, increase operational complexity, and create privacy concerns before the local runtime proves itself. Monad must not require users to upload source code, governance artifacts, context packs, plans, graph data, or policy findings to a service in order to receive core value.

## Decision

Any hosted Monad control plane will be an optional projection layer over local repository evidence.

The local CLI remains the primary runtime and source of core behavior. Hosted services may aggregate, visualize, synchronize, or coordinate evidence produced by local Monad workflows, but they must not be required for core correctness.

Hosted features may include:

- organization dashboards;
- repository fleet views;
- policy distribution;
- graph visualization;
- release evidence aggregation;
- team collaboration;
- context inventory;
- workflow history;
- optional remote pack or plugin registries.

Hosted features must consume explicit local outputs where possible, such as versioned machine-readable schemas, graph exports, policy reports, context manifests, plan reports, and release evidence. They should not become hidden sources of truth for local repository behavior.

## Decision Drivers

This decision is driven by:

- **Local-first trust:** users need value without a hosted account.
- **Privacy:** repositories and context artifacts may be sensitive.
- **Open-source viability:** local CLI adoption should not require SaaS infrastructure.
- **Cost control:** core use should not require hosting costs.
- **Evidence model:** hosted views should project local evidence rather than replace it.
- **Future optionality:** team/fleet workflows remain possible later.
- **Governance:** source-of-truth artifacts should remain reviewable in the repository.

## Rationale

A hosted control plane can be valuable, but only after the local evidence model is strong. If the local CLI cannot produce trustworthy manifests, graphs, policies, context, plans, and reports, a hosted layer would only centralize incomplete information.

Treating hosted features as a projection layer preserves the architecture. The repository remains the source of durable intent. The CLI produces deterministic evidence. The hosted service can aggregate and display that evidence for teams.

This also gives Monad a practical growth path: solo/local value first, optional team/organization features later.

## Projection Rules

A hosted projection layer should follow these rules:

- it is optional;
- it must not be required for core CLI commands;
- it should consume versioned local outputs;
- it should not silently change local source-of-truth files;
- sync should be explicit;
- telemetry and upload behavior must be opt-in;
- local policy and plan checks remain authoritative for local apply;
- hosted state should be explainable as projection, aggregation, or organization configuration.

## Implementation Guidance

Recommended implementation steps:

1. Build local CLI evidence first.
2. Stabilize machine-readable output schemas.
3. Stabilize graph, policy, context, plan, and release report formats.
4. Add explicit export/sync commands before background sync.
5. Add hosted adapters behind optional crates or features.
6. Add authentication and tenancy only when hosted features are real.
7. Keep upload/telemetry opt-in and documented.

Hosted integration code should not become a dependency of deterministic local core crates.

## Consequences

### Positive Consequences

- Local Monad remains useful without SaaS.
- Hosted features can be added later without rewriting the core.
- Privacy and trust posture remain strong.
- The repository remains the durable source of truth.
- Future dashboards can consume local evidence through stable schemas.
- Teams can eventually get fleet visibility and collaboration features.

### Negative Consequences

- Team dashboards and shared views are deferred.
- Hosted product capabilities depend on local schema maturity.
- Sync semantics require careful design.
- Users may expect SaaS collaboration earlier.

### Required Mitigations

- Keep local outputs structured and versioned.
- Document hosted features as optional.
- Avoid background upload by default.
- Keep hosted code out of local deterministic core.
- Provide explicit export/sync workflows before automation.

## Alternatives Considered

### Hosted-First Monad

Rejected because it conflicts with local-first trust, privacy, open-source adoption, and core CLI usefulness.

### No Hosted Layer Ever

Rejected because organization dashboards, fleet visibility, and shared governance may be valuable later.

### Hosted Source of Truth

Rejected because repository intent and local evidence should remain inspectable and version-controlled.

## Validation

This decision is validated when:

- core commands run without a hosted account;
- hosted integration is optional;
- local reports and schemas can feed hosted views;
- no background upload occurs by default;
- hosted code is isolated from local deterministic core;
- documentation clearly distinguishes local truth from hosted projection.

## Review Criteria

This ADR should be reconsidered only if Monad intentionally becomes SaaS-first and explicitly accepts the privacy, adoption, and architecture tradeoffs.

## Related Decisions

This ADR relates to ADR-0003 Local-First Core, ADR-0015 Local Graph Cache Is Rebuildable Generated State, ADR-0013 Versioned Machine-Readable Output Schemas, ADR-0019 No Telemetry by Default, and ADR-0008 Lifecycle Graph as Core Model.
