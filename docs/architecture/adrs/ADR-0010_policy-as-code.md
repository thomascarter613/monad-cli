---
id: ADR-0010
title: Policy-as-Code
status: accepted
date: 2026-07-02
supersedes: []
superseded_by: null
tags: [policy, governance, validation, waivers, ci, v1]
---

# ADR-0010: Policy-as-Code

## Status

Proposed.

## Context

Monad aims to provide governance-grade repository validation. Governance cannot depend only on prose, convention, or manual review. Policies should be explicit, versioned, testable, explainable, and runnable locally and in CI.

Monad already has several architectural decisions that imply policy enforcement. `monad.toml` is the canonical manifest. Core behavior is local-first. AI is optional and non-authoritative. Mutation should be plan-backed. Documentation should live in the repository. Native tools should be coordinated rather than replaced.

Those principles need checks that can be repeated over time. Without policy-as-code, Monad risks becoming a documentation-heavy tool that describes governance but cannot verify it.

Policy domains may include:

- canonical manifest rules;
- command catalog rules;
- documentation requirements;
- ADR requirements;
- work packet requirements;
- no unsafe mutation;
- protected path behavior;
- secret redaction;
- context generation safety;
- AI provider boundaries;
- release readiness gates;
- plan safety;
- waiver rules;
- native tool expectations;
- generated-file ownership;
- local-first and no-network-by-default checks.

Early Monad may start with built-in Rust policy checks. The long-term model should support explicit policy artifacts, policy reports, policy explanations, waivers, and plan gates without introducing an overcomplicated policy language before the actual rule set is understood.

## Decision

Policies will be defined as code or structured files and evaluated by Monad.

The initial approach should be conservative:

- start with built-in Rust policy checks;
- expose policy findings through structured diagnostics;
- provide human-readable policy explanations;
- make policy output CI-friendly;
- add waivers only after policy checks are stable;
- add policy gates for plans before risky mutation workflows mature;
- avoid a custom policy DSL too early;
- consider OPA/Rego or another policy engine only after built-in policy needs are clear.

Policy-as-code does not mean every rule must immediately live in an external policy language. It means policy rules must be explicit, repeatable, testable, inspectable, and capable of producing structured findings.

## Decision Drivers

This decision is driven by the following needs:

- **Repeatability:** governance checks should produce consistent results from the same repository state.
- **CI readiness:** policies should run in automation, not only during manual review.
- **Explainability:** users should understand which rule fired, why it fired, and how to fix it.
- **Auditability:** policy results, waivers, and gates should be reviewable as repository evidence.
- **Safety:** mutating plans should be checked before apply.
- **Local-first operation:** policy evaluation should work locally without a hosted policy service.
- **Configurability:** future teams may need stricter or different rules.
- **Incremental adoption:** policies must not become so strict early that they block useful adoption.
- **AI safety:** AI-generated suggestions must be constrained by deterministic policy checks.

## Rationale

Policy-as-code is the executable counterpart to Monad's governance documentation. ADRs and docs record what should be true. Policy checks determine whether the repository currently satisfies those expectations.

Starting with built-in Rust policies is the safest early path. It keeps policy behavior close to the domain model while rules are still being discovered. It also avoids forcing users to learn a policy language before the product has stable governance concepts.

Over time, structured policy files or external policy engines may become valuable. For example, organizations may want configurable severity, waivers, custom policy bundles, or integration with OPA-compatible systems. Those capabilities should extend a clear policy model, not replace it prematurely.

Policy-as-code also protects plan-backed mutation. If a plan intends to touch protected files, bypass source-of-truth rules, introduce risky generated artifacts, or use network/AI behavior unexpectedly, the policy layer should be able to block or warn before apply.

## Scope of the Decision

This ADR applies to:

- built-in policy checks;
- policy findings and severity;
- policy explanation;
- policy reports;
- policy configuration;
- policy waivers;
- waiver expiration and audit metadata;
- plan policy gates;
- documentation and ADR/work packet policies;
- source-of-truth and manifest policies;
- context and AI safety policies;
- future external policy engine integration.

This ADR does not require a custom policy DSL in the near term. It also does not require OPA/Rego or any specific external policy engine in v1.

## Policy Model

A policy rule should eventually have a stable identity and structured metadata.

A mature policy rule may include:

- rule ID;
- title;
- description;
- rationale;
- severity;
- category;
- affected paths or graph nodes;
- input facts;
- evaluation result;
- remediation guidance;
- whether the rule is waivable;
- waiver requirements;
- related ADRs or work packets;
- related command or plan operation;
- machine-readable output.

A policy finding should be specific enough for a user or CI system to act on it. It should avoid vague failure messages such as "policy failed" without context.

## Waiver Model

Waivers should be introduced only after policy checks are stable enough to justify exceptions.

A waiver should be explicit, reviewable, and time-bound where practical. It may include:

- waiver ID;
- rule ID;
- reason;
- owner;
- affected path or node;
- expiration date or review date;
- created date;
- related issue, work packet, or ADR;
- approval metadata;
- scope limitation.

Waivers should not become a silent way to disable governance permanently. Expiring or reviewable waivers preserve trust while allowing pragmatic exceptions.

## Implementation Guidance

Policy evaluation should begin with built-in policy checks represented as Rust rule implementations over structured repository facts.

Recommended implementation steps:

1. Define policy finding model.
2. Define severity levels.
3. Add built-in policy bundle for core repository rules.
4. Add `monad policy check`.
5. Add `monad policy explain`.
6. Add machine-readable policy report output.
7. Add plan policy evaluation.
8. Add waiver model after findings are stable.
9. Add waiver expiration and audit checks.
10. Consider structured policy files or external policy engines after rule boundaries are proven.

Policy checks should consume repository facts from manifest loading, inspection, documentation validation, lifecycle graph data, and plan validation rather than independently rediscovering everything.

Policy behavior should be local-first and no-network-by-default. External policy bundles or hosted policy distribution may be considered later, but core built-in policies must not require a hosted service.

## Consequences

### Positive Consequences

- Governance becomes repeatable and testable.
- CI can enforce repository rules consistently.
- Policy findings create auditable evidence.
- Plan-backed mutation can be gated before apply.
- Documentation, ADR, work packet, and manifest rules can be validated.
- Users can understand why a check failed through policy explanations.
- Future AI-assisted workflows can be constrained by deterministic rules.
- The policy model can evolve toward configurable organization governance.

### Negative Consequences

- False positives can frustrate users.
- Strict policies too early can slow adoption.
- Policy severity and waiver behavior require careful design.
- A policy language introduced too early could increase complexity.
- Policy output must remain understandable, not just machine-readable.
- Waivers can become governance debt if not time-bound or reviewed.

### Required Mitigations

- Start with a small built-in policy set.
- Make findings actionable and severity-based.
- Provide `policy explain` behavior.
- Avoid blocking adoption with overly strict defaults.
- Add waivers only after rule semantics stabilize.
- Make waivers explicit, reviewable, and preferably expiring.
- Keep policy evaluation local-first.
- Avoid custom DSL design until real policy needs justify it.
- Test policies against fixtures to reduce noisy findings.

## Alternatives Considered

### Hardcoded Checks Only

Monad could keep all governance checks as hardcoded Rust logic forever.

This is acceptable early, but insufficient long-term for configurable governance. Organizations may eventually need structured policies, waivers, bundles, or external policy engine integration.

### External OPA-Only Model from Day One

Monad could require OPA/Rego or a similar policy engine immediately.

This was rejected for early Monad because it adds complexity before built-in policy needs are clear. OPA or similar systems may be integrated later behind a stable policy model.

### Manual Governance Docs Only

Monad could rely on ADRs, docs, and human review without executable policy checks.

This was rejected because manual-only governance is not repeatable, CI-friendly, or sufficient for plan safety and AI-assisted workflows.

### Hosted Policy Service First

Monad could centralize policy in a hosted control plane.

This was rejected because it conflicts with local-first operation. Hosted policy distribution may be useful later, but local built-in checks must work first.

## Validation

This decision is validated when:

- Monad can run built-in policy checks locally;
- policy findings include stable rule IDs, severity, messages, paths or affected nodes, and remediation guidance;
- policy output can be rendered for humans and machines;
- `monad policy explain` can explain built-in rules;
- policy checks can run in CI without a hosted service;
- plan validation can include policy gate results;
- waivers, once introduced, are explicit and reviewable;
- tests cover passing, failing, warning, waived, and expired-waiver scenarios.

## Review Criteria

This ADR should be reconsidered if:

- policy-as-code introduces more friction than governance value;
- a built-in Rust policy model proves too inflexible;
- a future external policy engine becomes clearly superior and should become the primary policy runtime;
- hosted policy distribution becomes mandatory and the local-first tradeoff is explicitly accepted;
- another governance model supersedes executable policy checks.

Because this ADR is Proposed, implementation details may evolve. The protected principle is executable, explainable, local-first governance rather than any specific policy engine.

## Related Decisions

This ADR relates to:

- ADR-0003, which establishes local-first core behavior;
- ADR-0004, which establishes AI-native but AI-optional behavior;
- ADR-0005, which establishes `monad.toml` as the canonical manifest;
- ADR-0006, which establishes plan-backed mutation;
- ADR-0008, which establishes lifecycle graph as a core model;
- ADR-0009, which establishes documentation-as-code;
- ADR-0011, which establishes deterministic context before AI assistance;
- future decisions about waivers, release evidence, and policy engine adapters.
