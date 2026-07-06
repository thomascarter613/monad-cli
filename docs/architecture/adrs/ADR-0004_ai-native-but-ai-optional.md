---
id: ADR-0004
title: AI-Native but AI-Optional
status: accepted
date: 2026-07-02
supersedes: []
superseded_by: null
tags: [ai, ai-optional, context, safety, provider-agnostic, v1]
---

# ADR-0004: AI-Native but AI-Optional

## Status

Accepted.

## Context

AI-assisted software development is central to Monad's future relevance. Monad is intended to help humans and AI assistants understand serious repositories, architecture decisions, work packets, policies, dependency graphs, generated plans, and safe change boundaries.

However, AI cannot be the foundation of Monad's correctness. Repository governance requires deterministic source-of-truth rules, explicit policy boundaries, reproducible checks, explainable diagnostics, plan-backed mutation, and human review. These requirements must hold even when no AI provider is configured.

AI systems can hallucinate, omit context, misunderstand project constraints, overreach during mutation, and produce plausible but unsafe recommendations. If Monad depends on AI for core repository understanding, validation, graphing, policy checks, or mutation safety, the runtime becomes less trustworthy.

Monad should therefore be designed so that AI can consume high-quality context and suggest reviewable work, but the core runtime remains deterministic, inspectable, and useful without any model, API key, hosted provider, local model, or AI-specific account.

## Decision

Monad will be AI-native but AI-optional.

Monad will produce structured context, repository evidence, diagnostics, plans, graph outputs, ADRs, work packet metadata, and handoff artifacts that are useful to humans and AI assistants. These artifacts should make AI assistance safer, more grounded, and easier to review.

AI providers must not be required for core commands. Monad's core functionality must work without AI for initialization, inspection, checking, graphing, documentation validation, context generation, ADR/work packet management, policy checks, plan generation, diffing, and safe local mutation.

AI may assist with higher-level workflows only through explicit, reviewable boundaries. AI-generated suggestions must become inspectable artifacts such as draft documentation, proposed ADRs, candidate work packets, explanations, or candidate plans. AI must not silently apply repository changes, override deterministic validation, bypass policy rules, or become the source of truth.

Monad should remain provider-agnostic. Future AI integrations may support hosted models, local models, enterprise model gateways, or no-op/mock adapters, but no single AI vendor or runtime should become mandatory for core product value.

## Decision Drivers

This decision is driven by the following needs:

- **Correctness:** core repository understanding and validation must be deterministic.
- **Safety:** AI output must not directly mutate repositories without review and explicit approval.
- **Trust:** users should be able to use Monad in private or sensitive repositories without sending code to AI providers.
- **Provider agnosticism:** Monad should not depend on a single model vendor, API, or hosted AI runtime.
- **Local-first compatibility:** core commands must work offline and without network access.
- **Human review:** AI suggestions should support humans, not replace the human approval boundary.
- **Auditability:** AI-assisted workflows should leave evidence of inputs, generated artifacts, decisions, and applied changes.
- **Graceful degradation:** disabling AI should not break core CLI behavior.
- **Future extensibility:** AI can become more capable later if deterministic context and plan boundaries exist first.

## Rationale

Monad's most important AI contribution is not immediate autonomous code modification. Its most important contribution is deterministic, high-quality repository context.

AI assistants are much safer when they receive structured information about the repository's source-of-truth files, command surface, ADRs, work packets, policies, dependency graph, task graph, generated artifacts, protected files, and mutation rules. Monad can produce that context without relying on AI. This makes AI assistance more grounded while preserving deterministic behavior.

The AI-optional boundary also protects users who cannot or do not want to use AI providers. Some repositories are private, regulated, proprietary, air-gapped, or otherwise unsuitable for external model calls. Monad must still be useful in those environments.

Provider agnosticism is also important. AI ecosystems change quickly. Model quality, pricing, privacy guarantees, deployment options, and enterprise policies will shift. Monad should model AI as an optional adapter boundary rather than a hardcoded dependency.

This decision aligns with the larger Monad doctrine: deterministic before intelligent, read-only before mutation, plan-backed before mutation, local-first before hosted, and human approval before applied change.

## Scope of the Decision

This ADR applies to:

- context generation;
- handoff generation;
- AI-readable repository summaries;
- AI provider boundaries;
- AI-assisted explanation workflows;
- AI-assisted ADR and work packet drafting;
- AI-assisted candidate plan generation;
- AI-assisted documentation drafting;
- AI usage metadata and future audit trails;
- AI safety checks and policy boundaries.

This ADR does not require AI support in v1 core commands. It requires the architecture to be AI-ready without making AI a prerequisite.

This ADR does not prohibit:

- local AI integrations;
- hosted AI integrations;
- enterprise AI gateway integrations;
- AI-generated drafts;
- AI-assisted explanations;
- AI-suggested candidate plans;
- AI summarization of deterministic reports;
- future opt-in autonomous-adjacent workflows with strong policy and approval gates.

It does prohibit treating AI output as authoritative without deterministic validation or human review.

## AI Boundary Rules

AI integrations must follow these rules:

- AI is never required for core correctness.
- AI is never the canonical source of repository truth.
- AI must not silently call external providers.
- AI must not silently transmit repository contents.
- AI must not directly apply repository changes without explicit approval.
- AI-suggested mutations must be represented as reviewable plans or draft artifacts.
- Deterministic policy checks must override AI suggestions.
- AI output should be traceable to input context where practical.
- Users must be able to disable AI without breaking core workflows.
- No-op or mock AI adapters should exist before real provider integrations become required in tests.

## Context-First AI Model

Monad should prioritize deterministic context before AI execution.

The recommended progression is:

1. Build reliable repository inspection.
2. Build source-of-truth manifest and lockfile modeling.
3. Build graph generation.
4. Build policy and documentation checks.
5. Build context pack generation.
6. Build handoff generation.
7. Build context verification and redaction.
8. Add no-op AI adapter boundaries.
9. Add optional provider adapters.
10. Allow AI suggestions to become draft artifacts or candidate plans.
11. Validate and review plans before apply.

This sequencing prevents AI from becoming a shortcut around missing deterministic architecture.

## Provider-Agnostic Adapter Model

Future AI integrations should use explicit provider adapters.

A provider adapter should define:

- provider identity;
- supported model configuration;
- local versus hosted behavior;
- network requirements;
- credential requirements;
- input and output schemas;
- redaction behavior;
- audit metadata;
- error handling;
- token/cost reporting where applicable;
- safety constraints;
- whether the adapter is allowed in CI;
- whether the adapter is allowed for sensitive repositories.

The core runtime should be able to run with a `NoopAiAdapter` or equivalent mock adapter so that AI-dependent extension points can be tested without making live model calls.

## Implementation Guidance

The implementation should separate deterministic context generation from AI invocation.

Recommended boundaries:

- repository inspection model;
- context graph model;
- context pack renderer;
- redaction and filtering layer;
- AI request model;
- AI response model;
- provider adapter interface;
- no-op/mock provider adapter;
- candidate artifact generation;
- candidate plan generation;
- deterministic plan validation;
- human approval gate.

AI-facing context should be structured and versioned where practical. Markdown is useful for humans and models, but machine-readable JSON should exist for automation and verification workflows.

AI output should be stored or displayed as a draft or candidate artifact unless the user explicitly routes it into a plan/apply workflow. Even then, deterministic validation and policy checks must remain in control.

## Consequences

### Positive Consequences

- Monad can support AI-assisted workflows without requiring AI for core use.
- Users can run Monad in private, offline, or sensitive environments.
- AI assistance becomes safer because it consumes deterministic context.
- Provider lock-in is avoided.
- Core validation, graphing, and planning remain testable without model calls.
- Human review and plan-backed mutation remain central.
- Future AI integrations can evolve without destabilizing the core runtime.
- AI usage can be made auditable through explicit adapter boundaries.

### Negative Consequences

- AI capabilities will arrive more slowly than a direct AI-first agent approach.
- More engineering is required to build deterministic context before provider integrations.
- Users may expect autonomous AI behavior sooner than Monad should provide it.
- Context redaction, prompt/version management, evaluation, and audit metadata become future design concerns.
- Provider adapters add integration complexity.
- Some AI-generated outputs may require careful validation before they become useful plans.

### Required Mitigations

- Make deterministic context generation a core capability before live AI integrations.
- Provide clear documentation that AI is optional and non-authoritative.
- Add no-op/mock AI adapter support before real provider adapters are required by tests.
- Require AI-generated mutation suggestions to become reviewable plans.
- Run deterministic validation and policy checks on any AI-suggested plan before apply.
- Add redaction and context filtering before sensitive data is sent to any provider.
- Preserve local-first/no-network-by-default behavior for core commands.
- Make AI network behavior explicit, opt-in, and auditable.

## Alternatives Considered

### AI-First Autonomous Agent

Monad could begin as an autonomous AI agent that reads repositories, decides changes, edits files, and explains its work afterward.

This was rejected because it reverses the safety model. Without deterministic context, policy checks, protected-file rules, and plan-backed mutation, autonomous behavior creates too much risk for serious repositories.

### AI-Required Control Plane

Monad could require an AI provider for repository understanding, architecture explanation, planning, and mutation suggestions.

This was rejected because it would break local-first and offline usage, create provider lock-in, raise privacy concerns, and make core correctness depend on probabilistic model behavior.

### No AI Support

Monad could avoid AI entirely and remain a deterministic CLI only.

This was rejected because AI-assisted software development is a major use case. Monad's context, graph, policy, ADR, and work packet capabilities can make AI assistance safer and more useful than ordinary prompt-based workflows.

### Single-Provider AI Integration

Monad could choose one provider and design around that provider's API, model behavior, and tooling.

This was rejected because it would conflict with provider agnosticism and would make Monad vulnerable to vendor changes, pricing shifts, policy restrictions, and user environment constraints.

## Validation

This decision is validated when:

- core Monad commands run without an AI provider;
- context and handoff artifacts are useful to humans without AI;
- context and handoff artifacts are structured enough to support AI consumption;
- AI provider configuration is optional and explicit;
- tests can exercise AI extension points with no-op or mock adapters;
- AI-generated mutation suggestions become draft artifacts or candidate plans rather than direct file writes;
- deterministic policy and plan validation run before any AI-suggested changes are applied;
- users can disable AI features without breaking core repository governance workflows.

## Review Criteria

This ADR should be reconsidered only if:

- Monad intentionally becomes an AI-first autonomous agent and accepts the safety tradeoff;
- deterministic local context proves insufficient as the foundation for AI-assisted workflows;
- a future enterprise deployment model requires a mandatory AI gateway and the project explicitly accepts that constraint;
- another ADR defines a stricter AI safety model that supersedes this one.

A future AI subsystem may extend this decision with more detailed provider, redaction, evaluation, and audit rules. It should not silently convert AI from optional assistant to required authority.

## Related Decisions

This ADR relates to:

- ADR-0001, which establishes the Rust single-binary runtime;
- ADR-0002, which establishes native tool coordination over replacement;
- ADR-0003, which establishes the local-first core;
- future decisions about context packs and handoff artifacts;
- future decisions about deterministic context before AI assistance;
- future decisions about provider adapters and no-op AI adapters;
- future decisions about plan-backed mutation and human approval gates;
- future decisions about context redaction, privacy, and AI audit metadata.
