# 18. ADR Set

## ADR-0001: Rust Single-Binary Runtime

Status: Accepted

### Context

Monad is intended to be a local-first SDLC control plane and monorepo operating system. The primary runtime must be fast, portable, deterministic, and usable without a hosted backend or language-specific runtime dependency.

### Decision

Use Rust for the core runtime and distribute the main executable as a single binary named `monad`.

### Consequences

Positive:

* strong type safety,
* fast startup,
* good portability,
* serious systems-tooling posture,
* strong fit for deterministic filesystem and graph work.

Negative:

* slower iteration than scripting languages,
* higher implementation complexity,
* plugin/runtime extensibility requires more care.

### Alternatives Considered

* TypeScript/Node CLI
* Go CLI
* Python CLI
* Shell-based tooling

### Follow-Up Actions

* Maintain a Rust workspace.
* Separate CLI dispatch from domain logic.
* Preserve single-binary distribution as a core product constraint.

---

## ADR-0002: Coordinate Native Tools Instead of Replacing Them

Status: Accepted

### Context

Modern repositories already use many native tools: Cargo, Bun, npm, pnpm, Moon, Turborepo, Biome, GitHub Actions, Docker, security scanners, and documentation tooling.

Monad should not become a lower-quality replacement for each tool.

### Decision

Monad will coordinate native tools rather than replace them by default.

### Consequences

Positive:

* respects existing ecosystems,
* reduces scope,
* increases adoption,
* preserves developer choice,
* supports cloud/framework/database agnosticism.

Negative:

* requires adapter design,
* native tool behavior can vary,
* consistency may be harder across ecosystems.

### Alternatives Considered

* Replace native tools with a Monad-native build/task system.
* Support only one blessed stack.
* Integrate only through shell commands.

### Follow-Up Actions

* Define native tool adapter ports.
* Start with detection before delegation.
* Preserve native tool authority.

---

## ADR-0003: Local-First Core

Status: Accepted

### Context

Monad’s value should not require SaaS, cloud infrastructure, hosted database, AI API key, or organization account.

### Decision

Monad’s core functionality will work locally against the repository filesystem.

### Consequences

Positive:

* high trust,
* low operational burden,
* useful for solo developers,
* suitable for private repositories,
* strong open-source adoption path.

Negative:

* collaboration features are deferred,
* no central dashboard initially,
* local performance and cache design matter more.

### Alternatives Considered

* Hosted-first SaaS control plane.
* Local daemon plus remote sync from day one.
* CI-only control plane.

### Follow-Up Actions

* Avoid required network calls.
* Keep `.monad/` local state optional and inspectable.
* Treat hosted sync as future optional capability.

---

## ADR-0004: AI-Native but AI-Optional

Status: Accepted

### Context

AI-assisted software development is central to Monad’s future relevance, but AI is unreliable without context, guardrails, and human approval. Monad must not require any AI provider for correctness.

### Decision

Monad will be AI-native but AI-optional.

AI may consume context packs, explain findings, draft artifacts, or suggest plans, but deterministic behavior remains the foundation.

### Consequences

Positive:

* avoids AI lock-in,
* protects core correctness,
* supports local and hosted AI providers later,
* improves AI safety through structured context.

Negative:

* AI workflows require additional safety controls,
* users may expect autonomous behavior too early,
* prompt/version/eval management becomes a future concern.

### Alternatives Considered

* AI-first autonomous agent.
* No AI support.
* Single-provider AI integration.

### Follow-Up Actions

* Add deterministic context generation first.
* Add `NoopAiAdapter` before real providers.
* Require AI suggestions to become reviewable plans.

---

## ADR-0005: `monad.toml` Is the Canonical Manifest

Status: Accepted

### Context

Monad needs a clear source of truth. Previous planning allowed compatibility mirrors, but competing manifests create drift.

### Decision

`monad.toml` is the canonical Monad manifest.

`workspace.toml` may exist as a compatibility mirror only.

### Consequences

Positive:

* reduces ambiguity,
* improves validation,
* supports source-of-truth checks,
* prevents configuration drift.

Negative:

* migration from older mirror-based workflows may be required,
* users must understand canonical versus compatibility files.

### Alternatives Considered

* Use `workspace.toml` as canonical.
* Allow both equally.
* Store canonical config only under `.monad/`.

### Follow-Up Actions

* Add canonical manifest policy.
* Add conflict detection.
* Document mirror behavior clearly.

---

## ADR-0006: Plan-Backed Mutation

Status: Accepted

### Context

Monad will eventually add, remove, rename, move, generate, sync, migrate, and upgrade repository artifacts. These operations can be risky.

### Decision

Repository mutation should be plan-backed by default.

The mature flow is:

```bash id="e2tn70"
monad plan ...
monad apply plan.json --dry-run
monad apply plan.json --yes
```

### Consequences

Positive:

* safer mutations,
* reviewable change intent,
* auditability,
* policy gates,
* rollback hints,
* better AI safety.

Negative:

* more implementation work,
* slower simple workflows,
* plan schema must be maintained.

### Alternatives Considered

* Direct mutation commands.
* Git-only rollback.
* Interactive prompts without plans.

### Follow-Up Actions

* Define plan schema.
* Implement dry-run before apply.
* Block unsafe mutation paths.

---

## ADR-0007: Modular Rust Workspace

Status: Proposed

### Context

Monad’s scope includes CLI, config, inspection, graph, context, docs, policy, plans, packs, and future plugins.

A single large crate would become difficult to maintain.

### Decision

Use a modular Rust workspace with separate crates for major bounded contexts.

Recommended crates:

```text id="fcf4cy"
monad-cli
monad-core
monad-config
monad-inspect
monad-graph
monad-context
monad-docs
monad-policy
monad-plans
monad-packs
```

### Consequences

Positive:

* clear boundaries,
* testable modules,
* easier long-term growth,
* aligns with DDD bounded contexts.

Negative:

* more workspace overhead,
* crate boundaries can be premature,
* dependency management requires discipline.

### Alternatives Considered

* Single crate.
* One crate per command.
* Plugin-first crate layout.

### Follow-Up Actions

* Keep boundaries practical.
* Avoid creating empty crates too far ahead of implementation.
* Add crates when behavior justifies them.

---

## ADR-0008: Lifecycle Graph as Core Model

Status: Proposed

### Context

Monad’s differentiation depends on connecting code, docs, ADRs, work packets, policies, tests, releases, and context.

### Decision

Monad will model repository knowledge as a lifecycle graph.

### Consequences

Positive:

* core product moat,
* enables traceability,
* supports AI context,
* supports governance,
* supports drift detection.

Negative:

* graph model can become complex,
* source artifact references must be maintained,
* graph consistency requires tests.

### Alternatives Considered

* Flat inspection reports only.
* Project dependency graph only.
* External graph database from day one.

### Follow-Up Actions

* Start with in-memory graph.
* Export JSON/Mermaid/DOT.
* Add persistence only after model stabilizes.

---

## ADR-0009: Documentation-as-Code

Status: Proposed

### Context

Monad treats documentation as a first-class lifecycle artifact, not an afterthought.

### Decision

Product, architecture, governance, security, operations, ADR, work-packet, and roadmap documentation will live in the repository and be validated by Monad.

### Consequences

Positive:

* version-controlled knowledge,
* inspectable docs,
* supports handoff,
* supports governance,
* supports AI context.

Negative:

* docs can drift,
* validation rules must avoid false positives,
* generated docs need lineage metadata.

### Alternatives Considered

* External wiki.
* Hosted documentation only.
* No formal docs validation.

### Follow-Up Actions

* Add `monad docs check`.
* Define required docs.
* Add docs freshness checks later.

---

## ADR-0010: Policy-as-Code

Status: Proposed

### Context

Monad aims to provide governance-grade repository validation. Policies should be explicit, versioned, and testable.

### Decision

Policies will be defined as code or structured files and evaluated by Monad.

### Consequences

Positive:

* repeatable governance,
* CI integration,
* auditable controls,
* plan gates.

Negative:

* false positives can frustrate users,
* policy language must be carefully scoped,
* waivers require governance.

### Alternatives Considered

* Hardcoded checks only.
* External OPA-only model from day one.
* Manual governance docs only.

### Follow-Up Actions

* Start with built-in Rust policies.
* Add policy explain.
* Add waivers after policy check is stable.

---

## ADR-0011: Deterministic Context Before AI Assistance

Status: Proposed

### Context

AI assistants need repository context, but unmanaged context can leak secrets, omit constraints, or misrepresent current state.

### Decision

Monad will first generate deterministic context packs and handoffs without AI.

AI assistance can later consume these artifacts.

### Consequences

Positive:

* useful without AI,
* safer AI workflows,
* repeatable handoffs,
* better session continuity.

Negative:

* summaries may be less polished without AI,
* context relevance rules need iteration.

### Alternatives Considered

* AI-generated context only.
* Manual handoff docs only.
* No context feature.

### Follow-Up Actions

* Build `monad context handoff`.
* Add redaction rules.
* Add context verification.

---

## ADR-0012: Honest Placeholder Commands

Status: Accepted

### Context

Monad’s command surface is intentionally broad, but early implementation will be incomplete. Users must not be misled.

### Decision

Unimplemented or planned commands must be clearly marked as such.

Command metadata must include:

```text id="gku44v"
implemented
mutating
plan_backed
supports_dry_run
stability
```

### Consequences

Positive:

* user trust,
* safer roadmap visibility,
* contract-testable command surface.

Negative:

* output may feel unfinished,
* requires metadata discipline.

### Alternatives Considered

* Hide future commands.
* Show commands without status.
* Allow placeholder success messages.

### Follow-Up Actions

* Add placeholder renderer.
* Add tests for planned command honesty.
* Document command stability.

---