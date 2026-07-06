---
id: ADR-0020
title: AI Provider Port and Noop Adapter
status: proposed
date: 2026-07-06
supersedes: []
superseded_by: null
tags: [ai, ports-adapters, noop, provider-agnostic, testing, v1]
---

# ADR-0020: AI Provider Port and Noop Adapter

## Status

Proposed.

## Context

ADR-0004 establishes that Monad is AI-native but AI-optional. ADR-0011 establishes deterministic context before AI assistance. Future Monad features may use AI to explain repository state, summarize context, draft ADRs, draft work packets, explain plans, suggest candidate plans, or assist with documentation.

However, AI must not become a required dependency for core correctness. Monad must work without an AI provider, without a model key, without network access, and without a hosted service.

To preserve that boundary, AI integration should be modeled as an optional port with provider adapters. A no-op adapter should exist before real providers become necessary.

## Decision

Monad will define an AI provider port and a no-op AI adapter before integrating real AI providers.

The AI provider port will represent the boundary between deterministic Monad core behavior and optional AI assistance. The port should define request and response types, allowed operation categories, error handling, provenance metadata, and safety constraints.

A `NoopAiAdapter` or equivalent must be available so that:

- core workflows can run without AI;
- tests can exercise AI extension points without live model calls;
- AI-related commands can degrade honestly when no provider is configured;
- provider-specific code stays outside deterministic local core;
- future providers can be added behind stable interfaces.

Real AI provider adapters may be added later for hosted models, local models, or enterprise AI gateways, but none should become mandatory for core Monad behavior.

## Decision Drivers

This decision is driven by:

- **AI optionality:** core commands must not require AI.
- **Provider agnosticism:** Monad must avoid vendor lock-in.
- **Testability:** AI extension points need mock/no-op behavior.
- **Safety:** AI output must remain non-authoritative and reviewable.
- **Local-first operation:** no provider calls should occur by default.
- **Privacy:** repository context should not be sent to providers implicitly.
- **Architecture:** ports/adapters keep provider code out of deterministic core.

## Rationale

Without an explicit AI provider port, AI behavior could leak into command handlers, context generation, plan creation, or documentation workflows in an ad hoc way. That would make it harder to disable AI, test behavior, audit provider calls, or preserve local-first operation.

A no-op adapter makes the optional boundary real. It forces the codebase to handle the absence of AI as a normal condition rather than an error. It also prevents tests from depending on live providers or network access.

This model supports future providers without committing Monad to a vendor. Hosted AI, local models, enterprise gateways, and mock adapters can all implement the same boundary if the request/response model is designed carefully.

## Provider Port Model

The AI provider port should eventually define:

- provider identity;
- supported operation types;
- request schema;
- response schema;
- model configuration;
- credential requirements;
- network requirements;
- context input format;
- redaction expectations;
- cost/token metadata where applicable;
- provenance metadata;
- error categories;
- timeout and retry behavior;
- safety constraints;
- whether the provider is allowed in CI.

AI outputs should be represented as suggestions, drafts, explanations, or candidate plans. They should not be treated as source of truth.

## Noop Adapter Behavior

The no-op adapter should:

- make no network calls;
- require no credentials;
- produce honest unavailable/disabled responses;
- support tests for command flow;
- avoid fake AI output;
- preserve deterministic behavior;
- make provider absence explicit in diagnostics.

A no-op adapter should not pretend to summarize, decide, or generate intelligent output. It should state that AI is disabled or unavailable and preserve the command's non-AI behavior where possible.

## Implementation Guidance

Recommended implementation steps:

1. Finish deterministic context generation first.
2. Define AI operation categories.
3. Define AI request and response structs.
4. Implement `NoopAiAdapter`.
5. Add tests using the no-op adapter.
6. Add provider configuration model.
7. Add redaction and context verification before real provider calls.
8. Add one provider adapter only after the boundary is stable.
9. Require AI-generated mutations to become candidate plans.
10. Add provenance metadata for AI-assisted outputs.

AI provider code should live outside deterministic local core crates. Core crates may define interfaces and data types, but concrete hosted provider adapters should remain optional.

## Consequences

### Positive Consequences

- Monad remains useful without AI.
- Tests do not require live providers.
- Provider lock-in is avoided.
- AI behavior is explicit and auditable.
- Future providers can be added behind a stable boundary.
- AI absence becomes a supported state.
- Local-first and no-telemetry defaults are easier to preserve.

### Negative Consequences

- AI features require more architecture before provider integration.
- A provider port may need iteration as real use cases emerge.
- No-op behavior may feel underwhelming before real providers exist.
- Provider-specific capabilities may not fit perfectly behind one port.

### Required Mitigations

- Keep the initial provider port small.
- Add real provider adapters only after deterministic context and redaction exist.
- Make no-op responses honest.
- Keep provider code optional.
- Add tests for disabled, missing-config, provider-error, and successful-provider scenarios.
- Route AI-suggested mutations through plan-backed workflows.

## Alternatives Considered

### Direct Provider Integration

Rejected because direct integration would couple Monad to one provider and make AI harder to disable or test.

### AI Required for Context and Planning

Rejected because core context and planning must remain deterministic and AI-optional.

### Mock Only in Tests, No Runtime Noop

Rejected because runtime AI-disabled behavior is a real user mode, not only a test condition.

### No AI Interface Until Much Later

Rejected because early architecture should reserve the boundary even if real providers come later.

## Validation

This decision is validated when:

- AI extension points can run with a no-op adapter;
- tests do not require live AI calls;
- no provider is required for core commands;
- provider configuration is explicit;
- no provider calls happen by default;
- AI-generated mutation suggestions become draft artifacts or candidate plans;
- provider-specific code is isolated from deterministic core behavior.

## Review Criteria

This ADR should be reconsidered if real AI provider requirements prove incompatible with a shared port, or if Monad intentionally becomes AI-provider-specific in a superseding decision.

## Related Decisions

This ADR relates to ADR-0004 AI-Native but AI-Optional, ADR-0011 Deterministic Context Before AI Assistance, ADR-0019 No Telemetry by Default, ADR-0017 Plugin Execution and Trust Boundary, ADR-0006 Plan-Backed Mutation, and ADR-0007 Modular Rust Workspace.
