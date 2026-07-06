---
id: ADR-0019
title: No Telemetry by Default
status: accepted
date: 2026-07-06
supersedes: []
superseded_by: null
tags: [telemetry, privacy, local-first, trust, opt-in, v1]
---

# ADR-0019: No Telemetry by Default

## Status

Accepted.

## Context

Monad is a local-first repository runtime. It may inspect source code, manifests, ADRs, work packets, policies, generated plans, graph data, context packs, security findings, and other sensitive repository artifacts.

Telemetry can be useful for product improvement, reliability, usage analytics, and hosted feature development. However, default telemetry would create privacy and trust concerns, especially for private repositories, regulated environments, air-gapped workflows, and users evaluating Monad as an open-source governance tool.

The local CLI must not silently transmit repository metadata, command usage, file paths, diagnostics, context summaries, graph outputs, policy findings, or plan data.

## Decision

Monad will have no telemetry by default.

Core CLI behavior must not send telemetry, analytics, crash reports, usage events, repository metadata, source code, file names, graph data, context artifacts, policy findings, or plan data unless the user explicitly opts in through documented configuration or a future hosted workflow.

If telemetry is ever introduced, it must be:

- opt-in;
- documented;
- inspectable where practical;
- disableable;
- separate from core correctness;
- explicit about what data is collected;
- explicit about destination and retention;
- compatible with local-first operation;
- policy-controllable in governed environments.

No telemetry should be required to use core commands.

## Decision Drivers

This decision is driven by:

- **Privacy:** repositories may contain sensitive code and governance data.
- **Trust:** users must know Monad is not silently phoning home.
- **Local-first operation:** core value must not require remote services.
- **Open-source adoption:** default no-telemetry behavior is easier to audit and trust.
- **AI safety:** context and plan artifacts must not be uploaded implicitly.
- **Enterprise readiness:** organizations often restrict telemetry from developer tools.
- **Policy alignment:** network behavior should be explicit and controllable.

## Rationale

Monad's value depends on repository trust. A tool that reads governance artifacts and context packs must be conservative about data leaving the machine.

No telemetry by default does not prohibit future opt-in telemetry or hosted features. It establishes that telemetry is not part of the core runtime contract. Users can choose to enable hosted sync, registry access, update checks, crash reporting, or product analytics later if those features are implemented and documented.

This decision also simplifies early architecture. Monad can focus on deterministic local behavior without building a telemetry pipeline, consent model, data retention model, and privacy controls before the core runtime matures.

## Telemetry Rules

Monad should follow these rules:

- no analytics by default;
- no crash report upload by default;
- no background upload by default;
- no repository fingerprint upload by default;
- no context upload by default;
- no graph upload by default;
- no policy finding upload by default;
- no plan or apply report upload by default;
- no AI provider calls by default;
- no hosted sync by default.

Explicit network commands may exist, but they must be clearly named, documented, or configured. Network access should not be hidden inside ordinary local checks.

## Implementation Guidance

Recommended implementation steps:

1. Keep core commands no-network-by-default.
2. Add tests or architecture checks for accidental telemetry dependencies where practical.
3. Document network-aware commands separately.
4. Ensure future hosted sync is explicit.
5. Ensure future update checks are explicit or configurable.
6. Ensure future crash reporting is opt-in.
7. Add policy controls for telemetry and network behavior if such features are added.

Configuration should allow users and organizations to disable telemetry even if future opt-in telemetry exists.

## Consequences

### Positive Consequences

- Strong privacy posture.
- Higher trust for private and sensitive repositories.
- Better alignment with local-first doctrine.
- Easier open-source auditability.
- No analytics infrastructure required early.
- Reduced risk of accidental context leakage.

### Negative Consequences

- Less product usage data by default.
- Harder to understand real-world command usage.
- Crash and reliability telemetry require opt-in workflows.
- Hosted product feedback loops may develop more slowly.

### Required Mitigations

- Use explicit user feedback channels.
- Keep issue templates and diagnostics useful.
- Provide local diagnostic bundles that users can choose to share.
- Make future telemetry opt-in and transparent.
- Document network-aware behavior clearly.

## Alternatives Considered

### Telemetry Enabled by Default

Rejected because it conflicts with local-first trust and privacy expectations.

### Anonymous Minimal Telemetry by Default

Rejected because even metadata can reveal sensitive repository information or user behavior.

### Telemetry Required for Hosted Features

Rejected for core behavior. Future hosted features may require explicit sync, but that must be part of the hosted feature contract, not the local CLI baseline.

## Validation

This decision is validated when:

- core commands make no telemetry calls;
- network-aware commands are explicit;
- context, graph, policy, and plan artifacts are not uploaded by default;
- future telemetry has opt-in configuration;
- documentation states the no-telemetry default;
- tests or review checks guard against accidental telemetry in core paths.

## Review Criteria

This ADR should be reconsidered only if the project explicitly changes its privacy posture and accepts the trust tradeoff in a superseding ADR.

## Related Decisions

This ADR relates to ADR-0003 Local-First Core, ADR-0004 AI-Native but AI-Optional, ADR-0011 Deterministic Context Before AI Assistance, ADR-0018 Hosted Control Plane Is Optional Projection Layer, ADR-0016 Pack and Template Trust Model, and ADR-0017 Plugin Execution and Trust Boundary.
