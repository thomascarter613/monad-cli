# 18. ADR Set

## 18.1 Purpose of This Section

This section defines the initial Architecture Decision Record set for Monad OS and Monad CLI.

The ADR set exists to preserve the architectural decisions that should guide Monad’s implementation, roadmap, governance model, and future work packets.

Monad is intentionally ambitious. Without durable decisions, the project can drift into competing directions:

* CLI versus hosted platform,
* local-first versus SaaS-first,
* deterministic runtime versus AI-first agent,
* native-tool coordination versus tool replacement,
* safe plan-backed mutation versus direct generation,
* structured governance versus ad hoc documentation,
* practical Rust workspace versus premature crate explosion,
* lifecycle graph as core model versus ordinary scaffolder.

The ADR set prevents that drift.

Each ADR records:

* context,
* decision,
* consequences,
* alternatives considered,
* follow-up actions,
* and the architectural principle being protected.

The initial ADR set should be treated as a source-of-truth foundation. Later ADRs may supersede or refine these decisions, but they should not be silently ignored.

---

## 18.2 ADR Principles

Monad’s ADR practice should follow these principles.

### 18.2.1 Significant Decisions Must Be Recorded

A decision should become an ADR when it materially affects:

* architecture,
* source-of-truth rules,
* safety model,
* mutation model,
* AI model,
* hosted/local boundary,
* data model,
* crate structure,
* plugin/pack model,
* policy model,
* release model,
* or long-term product direction.

### 18.2.2 ADRs Should Preserve Context, Not Just Conclusions

A decision without context becomes hard to defend later.

Each ADR should explain:

* what problem existed,
* what constraints shaped the decision,
* what was chosen,
* what was rejected,
* what trade-offs remain.

### 18.2.3 ADRs Should Be Stable but Not Sacred

Accepted ADRs should not be rewritten casually.

If a decision changes materially, create a new ADR that supersedes the old one.

### 18.2.4 ADRs Should Connect to Work Packets

Significant implementation work should reference the ADRs it implements or depends on.

Example:

```text id="dllvr2"
WP-0025: Plan Schema and Domain Model
  Related ADRs:
    ADR-0006: Plan-Backed Mutation
```

### 18.2.5 ADRs Should Protect Product Doctrine

The ADR set should preserve Monad’s core doctrine:

* local-first,
* deterministic before AI,
* read-only before mutation,
* plan-backed before mutation,
* no network by default,
* no telemetry by default,
* native-tool coordination over replacement,
* `monad.toml` canonical,
* AI-optional architecture,
* hosted control plane optional and later,
* lifecycle graph as long-term moat.

---

## 18.3 ADR Status Model

Recommended ADR statuses:

```text id="kfk68h"
Proposed
Accepted
Superseded
Deprecated
Rejected
```

### 18.3.1 Proposed

The decision is recommended but not yet final.

Use when:

* implementation has not started,
* trade-offs are still being tested,
* the decision may change with new evidence.

### 18.3.2 Accepted

The decision is authoritative for current implementation.

Accepted ADRs should guide work packets, tests, docs, and code structure.

### 18.3.3 Superseded

The decision has been replaced by a later ADR.

The superseded ADR should link to the replacement.

### 18.3.4 Deprecated

The decision is still historically relevant but should not guide new work.

Use when a decision is being phased out.

### 18.3.5 Rejected

The option was considered and explicitly not chosen.

Rejected ADRs may be useful when a tempting architecture should not be revisited casually.

---

## 18.4 ADR Numbering and Naming

ADR files should use stable numeric identifiers.

Recommended filename convention:

```text id="vzpe8f"
adr-NNNN-kebab-case-title.md
```

Examples:

```text id="ewwy3c"
adr-0001-rust-single-binary-runtime.md
adr-0002-coordinate-native-tools.md
adr-0003-local-first-core.md
```

ADR numbers should not be reused.

If an ADR is superseded, the original file should remain in place.

---

## 18.5 Initial ADR Index

| ADR      | Title                                             | Status   | Theme               |
| -------- | ------------------------------------------------- | -------- | ------------------- |
| ADR-0001 | Rust Single-Binary Runtime                        | Accepted | Runtime             |
| ADR-0002 | Coordinate Native Tools Instead of Replacing Them | Accepted | Tooling             |
| ADR-0003 | Local-First Core                                  | Accepted | Infrastructure      |
| ADR-0004 | AI-Native but AI-Optional                         | Accepted | AI                  |
| ADR-0005 | `monad.toml` Is the Canonical Manifest            | Accepted | Source of Truth     |
| ADR-0006 | Plan-Backed Mutation                              | Accepted | Safety              |
| ADR-0007 | Modular Rust Workspace                            | Proposed | Code Architecture   |
| ADR-0008 | Lifecycle Graph as Core Model                     | Proposed | Domain Model        |
| ADR-0009 | Documentation-as-Code                             | Proposed | Documentation       |
| ADR-0010 | Policy-as-Code                                    | Proposed | Governance          |
| ADR-0011 | Deterministic Context Before AI Assistance        | Proposed | Context / AI Safety |
| ADR-0012 | Honest Placeholder Commands                       | Accepted | CLI Trust           |

---

## ADR-0001: Rust Single-Binary Runtime

Status: Accepted

### Context

Monad is intended to be a local-first SDLC control plane and monorepo operating system.

The first executable runtime surface is the `monad` CLI. This CLI must be fast, portable, deterministic, safe, and suitable for serious developer workflows.

Monad must be useful without requiring:

* a hosted backend,
* a language-specific runtime,
* a package manager runtime,
* a local daemon,
* a cloud account,
* a database,
* or an AI provider.

The runtime also needs to support safety-critical behavior over time:

* repository inspection,
* manifest parsing,
* command catalog integrity,
* graph construction,
* context generation,
* policy evaluation,
* plan validation,
* dry-run apply,
* approved mutation,
* and release artifact generation.

These requirements favor a systems-grade implementation language.

### Decision

Monad will use Rust for the core runtime and will distribute the main executable as a single binary named `monad`.

Rust is the default implementation language for:

* CLI runtime,
* domain models,
* manifest parsing,
* command catalog,
* repository inspection,
* graph generation,
* context generation,
* policy evaluation,
* plan/apply safety,
* and native tool coordination.

### Consequences

Positive:

* strong type safety,
* fast startup,
* good portability,
* serious systems-tooling posture,
* strong fit for deterministic filesystem work,
* strong fit for graph/domain modeling,
* strong fit for single-binary distribution,
* strong fit for safety-sensitive command behavior,
* fewer runtime installation assumptions for users.

Negative:

* slower iteration than scripting languages,
* higher implementation complexity,
* steeper learning curve,
* plugin/runtime extensibility requires more careful design,
* some ecosystem integrations may require more adapter work.

### Alternatives Considered

#### TypeScript/Node CLI

Pros:

* fast iteration,
* strong ecosystem,
* natural fit for JavaScript/TypeScript monorepos.

Cons:

* requires runtime or bundling strategy,
* greater supply-chain surface,
* slower startup,
* less ideal for deterministic single-binary systems tooling.

#### Go CLI

Pros:

* excellent single-binary distribution,
* simple deployment,
* fast builds,
* good systems-tooling fit.

Cons:

* less expressive type modeling than Rust for certain domain invariants,
* weaker ownership/safety guarantees,
* less appealing for safety-critical mutation internals.

#### Python CLI

Pros:

* fast prototyping,
* excellent scripting ergonomics,
* broad ecosystem.

Cons:

* runtime dependency,
* packaging complexity,
* slower startup,
* weaker fit for single-binary distribution.

#### Shell-Based Tooling

Pros:

* simple,
* easy to start,
* transparent.

Cons:

* brittle across environments,
* difficult to test deeply,
* poor fit for complex domain model,
* unsafe for future mutation workflows,
* weak portability.

### Follow-Up Actions

* Maintain a Rust workspace.
* Separate CLI dispatch from domain logic.
* Preserve single-binary distribution as a core product constraint.
* Keep deterministic core logic in Rust.
* Add command contract tests.
* Add release packaging later.
* Avoid implementing core correctness in shell scripts.

### Related Work Packets

* WP-0001: Rust Workspace and CLI Foundation
* WP-0004: Command Catalog Model
* WP-0005: Clap Surface Contract

### Protected Principles

* Local-first
* Deterministic before intelligent
* Safety before mutation
* Single-binary developer experience

---

## ADR-0002: Coordinate Native Tools Instead of Replacing Them

Status: Accepted

### Context

Modern repositories already use many native tools.

Examples include:

* Git,
* Cargo,
* Bun,
* npm,
* pnpm,
* Moon,
* Turborepo,
* Biome,
* Docker,
* GitHub Actions,
* GitLab CI,
* security scanners,
* documentation tools,
* release tools.

Monad should not become a lower-quality replacement for every tool in the software delivery ecosystem.

Replacing native tools would dramatically increase scope and reduce adoption. Developers already trust their build tools, test tools, linters, formatters, package managers, and CI systems.

Monad’s unique value is not to replace these tools. Monad’s value is to understand how they fit together in the repository lifecycle.

### Decision

Monad will coordinate native tools rather than replace them by default.

Monad should:

* detect native tools,
* inspect native tool manifests,
* explain native tool presence,
* delegate when explicitly configured,
* normalize findings where appropriate,
* connect native tool metadata to the lifecycle graph,
* and validate repository-level governance around native tools.

Native tools remain authoritative for their domains.

Examples:

* Cargo remains authoritative for Rust builds.
* Bun/npm/pnpm remain authoritative for JavaScript package workflows.
* Git remains authoritative for version control.
* Docker remains authoritative for container builds.
* CI systems remain authoritative for CI execution.

### Consequences

Positive:

* respects existing ecosystems,
* reduces Monad scope,
* increases adoption,
* preserves developer choice,
* supports polyglot repositories,
* supports cloud/framework/database agnosticism,
* avoids competing with mature specialized tools.

Negative:

* requires adapter design,
* native tool behavior can vary,
* consistency may be harder across ecosystems,
* tool availability differs by machine,
* output parsing may be brittle.

### Alternatives Considered

#### Replace Native Tools With a Monad-Native Build/Task System

Rejected because:

* scope would explode,
* existing tools are already mature,
* users would resist replacement,
* Monad would become a build system instead of a lifecycle control plane.

#### Support Only One Blessed Stack

Rejected because:

* Monad must be polyglot and agnostic,
* repositories vary widely,
* one blessed stack would undermine adoption.

#### Integrate Only Through Shell Commands

Rejected as the only model because:

* shell-only integration is hard to validate,
* behavior is platform-specific,
* output parsing is fragile,
* safety boundaries are weaker.

Shell delegation may still be used carefully behind explicit adapters.

### Follow-Up Actions

* Define native tool adapter ports.
* Start with detection before delegation.
* Preserve native tool authority.
* Add graceful missing-tool behavior.
* Add native tool findings.
* Add native tool metadata to inspection reports.
* Add tests for missing optional tools.

### Related Work Packets

* WP-0009: Repository Inspection Engine
* WP-0011: Doctor Diagnostics
* WP-0044: Native Tool Detection
* WP-0045: Cargo Adapter
* WP-0046: Bun/Node Adapter
* WP-0048: Git Adapter

### Protected Principles

* Native-tool coordination over replacement
* Polyglot support
* Scope control
* Developer trust

---

## ADR-0003: Local-First Core

Status: Accepted

### Context

Monad’s value should not require SaaS, cloud infrastructure, hosted database, AI API key, organization account, browser dashboard, or remote service.

The early user should be able to run Monad locally inside a repository.

The baseline topology is:

```text id="k5o60r"
Developer machine
  └─ monad binary
      └─ local repository
```

This local-first posture is critical because Monad may operate on sensitive repositories, private source code, governance artifacts, policies, context packs, and future mutation plans.

A hosted-first model would increase trust barriers, operational complexity, cost, privacy concerns, and development scope.

### Decision

Monad’s core functionality will work locally against the repository filesystem.

Core local commands should not require network access, hosted services, telemetry, external databases, or AI providers.

The local CLI is the primary runtime.

Hosted sync, hosted dashboards, organization views, and team/fleet features are future optional capabilities.

### Consequences

Positive:

* high trust,
* low operational burden,
* useful for solo developers,
* useful for private repositories,
* strong open-source adoption path,
* no required cloud account,
* no required hosted backend,
* easier local debugging,
* better privacy posture.

Negative:

* collaboration features are deferred,
* no central dashboard initially,
* local performance and cache design matter more,
* repository-level reports must be generated locally first,
* multi-repository visibility comes later.

### Alternatives Considered

#### Hosted-First SaaS Control Plane

Rejected for the early product because:

* increases complexity,
* requires auth, tenancy, persistence, hosting, and operations,
* creates privacy concerns before local trust is earned,
* distracts from the core CLI.

#### Local Daemon Plus Remote Sync From Day One

Rejected because:

* adds background process complexity,
* introduces network trust concerns,
* increases debugging burden,
* is unnecessary for early CLI value.

#### CI-Only Control Plane

Rejected because:

* local developer experience matters,
* repository understanding should be available before CI,
* CI should be another execution environment, not the only one.

### Follow-Up Actions

* Avoid required network calls.
* Keep `.monad/` local state optional and inspectable.
* Treat hosted sync as future optional capability.
* Ensure core commands work offline.
* Add no-network-by-default tests or architecture checks.
* Avoid telemetry by default.

### Related Work Packets

* WP-0001: Rust Workspace and CLI Foundation
* WP-0008: Workspace Root Detection
* WP-0009: Repository Inspection Engine
* WP-0010: Baseline Check Engine
* WP-0021: Handoff Generator
* WP-0068: Hosted Control Plane Architecture, later

### Protected Principles

* Local-first before hosted
* Privacy by default
* No network by default
* No hosted dependency for core value

---

## ADR-0004: AI-Native but AI-Optional

Status: Accepted

### Context

AI-assisted software development is central to Monad’s future relevance.

Monad should eventually help AI assistants understand repositories, decisions, policies, plans, and safe change boundaries.

However, AI is unreliable without:

* deterministic context,
* source-of-truth rules,
* policy constraints,
* human review,
* plan validation,
* and auditability.

Monad must not require any AI provider for correctness. Core repository understanding, validation, graphing, documentation checks, context handoff, policy checks, and plan validation must remain deterministic.

AI should enhance Monad. AI should not become the foundation of Monad’s correctness.

### Decision

Monad will be AI-native but AI-optional.

AI may eventually:

* consume context packs,
* explain findings,
* draft ADRs,
* draft work packets,
* explain plans,
* suggest plan candidates,
* summarize graph/context,
* assist with documentation.

AI must not:

* be required for core commands,
* silently call external providers,
* apply repository changes automatically,
* override deterministic policy checks,
* become the source of truth.

### Consequences

Positive:

* avoids AI lock-in,
* protects core correctness,
* supports local and hosted AI providers later,
* supports users with no AI provider,
* improves AI safety through structured context,
* makes AI assistance auditable.

Negative:

* AI workflows require additional safety controls,
* users may expect autonomous behavior too early,
* prompt/version/eval management becomes a future concern,
* context redaction and verification become important.

### Alternatives Considered

#### AI-First Autonomous Agent

Rejected because:

* safety risk is too high,
* deterministic repository understanding must come first,
* autonomous mutation conflicts with plan-backed mutation.

#### No AI Support

Rejected because:

* AI-assisted development is a major use case,
* Monad’s context and graph capabilities can make AI safer,
* users will want AI-ready handoff artifacts.

#### Single-Provider AI Integration

Rejected because:

* provider lock-in conflicts with agnosticism,
* users may use hosted or local providers,
* core should work with no provider.

### Follow-Up Actions

* Add deterministic context generation first.
* Add `NoopAiAdapter` before real providers.
* Require AI suggestions to become reviewable plans.
* Add context redaction and verification.
* Add AI usage audit metadata later.
* Add mocked AI evaluation tests before live provider tests.

### Related Work Packets

* WP-0020: Context Model
* WP-0021: Handoff Generator
* WP-0023: Context Redaction and Safety
* WP-0061: AI Provider Port
* WP-0062: Noop AI Adapter
* WP-0066: AI-Suggested Plan Creation
* WP-0067: AI Safety and Audit Controls

### Protected Principles

* AI-native but AI-optional
* Deterministic before intelligent
* Human approval before mutation
* Provider agnosticism

---

## ADR-0005: `monad.toml` Is the Canonical Manifest

Status: Accepted

### Context

Monad needs a clear source of truth.

Previous planning allowed compatibility mirrors, but competing manifests create drift and ambiguity.

The repository may contain multiple configuration files:

* `Cargo.toml`,
* `package.json`,
* `turbo.json`,
* `moon.yml`,
* `.github/workflows/*.yml`,
* `workspace.toml`,
* `monad.toml`,
* `monad.lock`.

Monad must distinguish repository-native manifests from Monad’s own canonical manifest.

Without a clear canonical manifest, commands such as `monad config`, `monad check`, `monad doctor`, `monad graph`, `monad context`, and `monad plan` may resolve conflicting intent.

### Decision

`monad.toml` is the canonical Monad manifest.

`workspace.toml` may exist as a compatibility mirror only.

`monad.lock` records resolved state.

`.monad/` stores local/generated/cache/context/report/plan state.

If `monad.toml` and `workspace.toml` conflict, `monad.toml` wins.

### Consequences

Positive:

* reduces ambiguity,
* improves validation,
* supports source-of-truth checks,
* prevents configuration drift,
* makes docs and tests clearer,
* gives `monad check` and `monad doctor` a stable rule.

Negative:

* migration from older mirror-based workflows may be required,
* users must understand canonical versus compatibility files,
* compatibility mirror behavior needs documentation and tests.

### Alternatives Considered

#### Use `workspace.toml` as Canonical

Rejected because `monad.toml` is clearer and product-specific.

#### Allow Both Equally

Rejected because equal canonical status creates drift.

#### Store Canonical Config Only Under `.monad/`

Rejected because `.monad/` is local/generated/cache state and should not become canonical truth.

### Follow-Up Actions

* Add canonical manifest policy.
* Add conflict detection.
* Document mirror behavior clearly.
* Add fixture tests for valid, missing, mirror-only, and conflicting manifests.
* Add `monad config inspect`.
* Add `monad doctor` remediation for conflicts.

### Related Work Packets

* WP-0002: Canonical Manifest and Workspace Model
* WP-0008: Workspace Root Detection
* WP-0010: Baseline Check Engine
* WP-0011: Doctor Diagnostics

### Protected Principles

* Clear source of truth
* Local-first repository state
* Generated state is not canonical
* Deterministic manifest resolution

---

## ADR-0006: Plan-Backed Mutation

Status: Accepted

### Context

Monad will eventually add, remove, rename, move, generate, sync, migrate, and upgrade repository artifacts.

These operations can be risky.

Risky operations include:

* creating files,
* modifying files,
* deleting files,
* moving files,
* running native tools,
* generating docs,
* generating ADRs,
* generating work packets,
* installing packs,
* applying templates,
* accepting AI-suggested changes,
* migrating repository structure.

Direct mutation would make Monad less trustworthy.

Users should be able to inspect intended changes before they happen.

### Decision

Repository mutation should be plan-backed by default.

The mature flow is:

```bash id="e2tn70"
monad plan ...
monad apply plan.json --dry-run
monad apply plan.json --yes
```

A plan should list intended effects before mutation.

A dry-run should simulate the apply without writing files.

An approved apply should write only the operations listed in the plan.

### Consequences

Positive:

* safer mutations,
* reviewable change intent,
* auditability,
* policy gates,
* rollback hints,
* better AI safety,
* clearer CI behavior,
* stronger user trust.

Negative:

* more implementation work,
* slower simple workflows,
* plan schema must be maintained,
* some users may want direct commands,
* generated workflows require more ceremony.

### Alternatives Considered

#### Direct Mutation Commands

Rejected as the default because direct mutation weakens trust.

#### Git-Only Rollback

Rejected as sufficient because users still need to know what Monad intends before mutation.

#### Interactive Prompts Without Plans

Rejected because prompts are not enough for auditability, CI, AI safety, or repeatability.

### Follow-Up Actions

* Define plan schema.
* Implement plan validation.
* Implement dry-run before apply.
* Implement apply reports.
* Block unsafe mutation paths.
* Add mutation safety tests.
* Require AI suggestions to become reviewable plans.

### Related Work Packets

* WP-0025: Plan Schema and Domain Model
* WP-0026: Plan Creation for Documentation Artifacts
* WP-0027: Dry-Run Apply Engine
* WP-0028: Apply Engine with Approval
* WP-0029: Rollback Hints and Apply Reports
* WP-0030: Plan Policy Evaluation

### Protected Principles

* Plan-backed before mutation
* Review before apply
* Auditability
* AI safety
* Human approval

---

## ADR-0007: Modular Rust Workspace

Status: Proposed

### Context

Monad’s scope includes:

* CLI command surface,
* config and manifest resolution,
* repository inspection,
* lifecycle graph,
* context and handoff generation,
* docs lifecycle,
* policy evaluation,
* plan/apply safety,
* templates and packs,
* native tool coordination,
* future AI,
* future hosted integration.

A single large crate would become difficult to maintain over time.

However, creating too many crates too early can also create overhead and fake architecture maturity.

The repository should balance clean boundaries with practical implementation.

### Decision

Use a modular Rust workspace with separate crates for major bounded contexts, but extract crates only when behavior justifies the boundary.

Recommended long-term crates:

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

Near-term structure may begin with:

```text id="fb0qv0"
monad-cli
monad-core
```

Additional crates should be extracted when they have real logic, tests, and stable boundaries.

### Consequences

Positive:

* clear boundaries,
* testable modules,
* easier long-term growth,
* aligns with DDD bounded contexts,
* reduces CLI crate bloat,
* allows optional AI/hosted features to remain out of core.

Negative:

* more workspace overhead,
* crate boundaries can be premature,
* dependency management requires discipline,
* refactoring between crates may be needed.

### Alternatives Considered

#### Single Crate

Acceptable early, but risky long-term if all domain logic accumulates in one place.

#### One Crate Per Command

Rejected because it creates too much fragmentation and poor domain cohesion.

#### Plugin-First Crate Layout

Rejected because plugin architecture should not precede core trust and safety.

### Follow-Up Actions

* Keep boundaries practical.
* Avoid creating empty crates too far ahead of implementation.
* Add crates when behavior justifies them.
* Keep `monad-core` independent from `monad-cli`.
* Prevent AI/hosted crates from becoming core dependencies.

### Related Work Packets

* WP-0001: Rust Workspace and CLI Foundation
* WP-0002: Canonical Manifest and Workspace Model
* WP-0009: Repository Inspection Engine
* WP-0012: Lifecycle Graph v0
* WP-0025: Plan Schema and Domain Model

### Protected Principles

* DDD-aligned boundaries
* Practical modularity
* Avoid premature crate explosion
* Keep core deterministic

---

## ADR-0008: Lifecycle Graph as Core Model

Status: Proposed

### Context

Monad’s differentiation depends on connecting repository lifecycle artifacts.

Relevant artifacts include:

* workspace,
* projects,
* packages,
* services,
* apps,
* docs,
* ADRs,
* work packets,
* policies,
* waivers,
* plans,
* tests,
* releases,
* context packs,
* native tool manifests,
* CI workflows.

Most tools see only one slice of the repository.

Monad’s opportunity is to model the repository as a governed lifecycle system.

The lifecycle graph is the structure that can connect these artifacts.

### Decision

Monad will model repository knowledge as a lifecycle graph.

The graph should begin as deterministic local output and mature over time.

Initial graph support may include:

* workspace nodes,
* project nodes,
* documentation nodes,
* native manifest nodes,
* simple relationships,
* text output,
* Mermaid output,
* JSON output later.

The graph should eventually support:

* traceability,
* drift detection,
* policy context,
* AI context,
* release readiness,
* hosted dashboard visualizations.

### Consequences

Positive:

* core product moat,
* enables traceability,
* supports AI context,
* supports governance,
* supports drift detection,
* supports documentation-as-code,
* supports release evidence,
* supports future hosted dashboards.

Negative:

* graph model can become complex,
* source artifact references must be maintained,
* graph consistency requires tests,
* graph persistence can be tempting too early,
* over-modeling could slow implementation.

### Alternatives Considered

#### Flat Inspection Reports Only

Rejected as the long-term model because flat reports do not express lifecycle relationships well.

#### Project Dependency Graph Only

Rejected because Monad’s graph must include docs, ADRs, work packets, policies, plans, context, and releases, not just code dependencies.

#### External Graph Database From Day One

Rejected because persistence should not precede the local model. The graph should be generated deterministically before being cached, indexed, or hosted.

### Follow-Up Actions

* Start with in-memory graph.
* Export text/Mermaid first.
* Add JSON schema when stable.
* Add DOT export later.
* Add graph invariant tests.
* Add persistence only after model stabilizes.
* Keep `.monad/graph/` as generated/cache output, not canonical truth.

### Related Work Packets

* WP-0012: Lifecycle Graph v0
* WP-0055: Graph Node/Edge Schema
* WP-0056: Graph Export JSON
* WP-0057: Graph Export Mermaid and DOT
* WP-0058: Graph Query v0
* WP-0059: Local Graph Cache
* WP-0060: Graph Consistency Checks

### Protected Principles

* Lifecycle graph as moat
* Deterministic graph before persistence
* Repository as lifecycle system
* Traceability

---

## ADR-0009: Documentation-as-Code

Status: Proposed

### Context

Monad treats documentation as a first-class lifecycle artifact, not an afterthought.

Important documentation includes:

* product docs,
* architecture docs,
* ADRs,
* work packets,
* security docs,
* operations docs,
* governance docs,
* roadmap docs,
* user guides,
* reference docs,
* runbooks.

If these documents live outside the repository, they are harder to version, inspect, validate, test, and include in handoffs.

Monad should be able to validate documentation presence and consistency over time.

### Decision

Product, architecture, governance, security, operations, ADR, work-packet, and roadmap documentation will live in the repository and be validated by Monad.

Documentation should be treated as source-of-truth, not decoration.

Future commands should include:

```bash id="rz3l53"
monad docs check
monad adr list
monad workpacket list
monad context handoff
```

### Consequences

Positive:

* version-controlled knowledge,
* inspectable docs,
* supports handoff,
* supports governance,
* supports AI context,
* supports release readiness,
* supports traceability,
* helps prevent knowledge loss.

Negative:

* docs can drift,
* validation rules must avoid false positives,
* generated docs need lineage metadata,
* users may resist documentation ceremony if it is too heavy.

### Alternatives Considered

#### External Wiki

Rejected as the primary model because external docs drift from code and are harder for local CLI inspection.

#### Hosted Documentation Only

Rejected because hosted docs conflict with local-first operation.

#### No Formal Docs Validation

Rejected because Monad’s governance-grade value requires documentation checks.

### Follow-Up Actions

* Add `monad docs check`.
* Define required docs.
* Add docs freshness checks later.
* Add ADR/work-packet validation.
* Add generated docs lineage metadata later.
* Keep planning docs distinct from user-guide docs.

### Related Work Packets

* WP-0003: Documentation and Governance Foundation
* WP-0014: Docs Check
* WP-0015: Docs Generate Preview
* WP-0016: ADR List and Validation
* WP-0018: Work Packet List and Validation
* WP-0021: Handoff Generator

### Protected Principles

* Documentation-as-code
* Repository self-description
* Handoff readiness
* Governance without external dependency

---

## ADR-0010: Policy-as-Code

Status: Proposed

### Context

Monad aims to provide governance-grade repository validation.

Policies should be explicit, versioned, and testable.

Policy domains may include:

* canonical manifest rules,
* command catalog rules,
* documentation requirements,
* no unsafe mutation,
* secret redaction,
* ADR requirements,
* work-packet requirements,
* release gates,
* plan safety,
* AI context safety,
* native tool expectations.

Early Monad may start with built-in Rust policy checks, but the long-term model should support explicit policy artifacts.

### Decision

Policies will be defined as code or structured files and evaluated by Monad.

The initial approach should be conservative:

* start with built-in policy checks,
* expose policy findings,
* add policy explain,
* add waivers after policy check is stable,
* avoid overcomplicated policy DSL too early.

### Consequences

Positive:

* repeatable governance,
* CI integration,
* auditable controls,
* plan gates,
* traceability,
* consistent enforcement,
* policy explainability.

Negative:

* false positives can frustrate users,
* policy language must be carefully scoped,
* waivers require governance,
* strict enforcement too early can block adoption.

### Alternatives Considered

#### Hardcoded Checks Only

Acceptable early, but insufficient long-term for configurable governance.

#### External OPA-Only Model From Day One

Rejected for early Monad because it adds complexity before built-in policy needs are clear.

OPA or similar systems may be integrated later.

#### Manual Governance Docs Only

Rejected because manual-only governance is not repeatable or CI-friendly.

### Follow-Up Actions

* Start with built-in Rust policies.
* Add policy check.
* Add policy explain.
* Add policy report schema.
* Add waivers after policy check is stable.
* Add policy gates for plans.
* Consider structured policy files later.

### Related Work Packets

* WP-0038: Policy Rule Model
* WP-0039: Built-In Policy Bundle
* WP-0040: Policy Check
* WP-0041: Policy Explain
* WP-0042: Policy Waiver Model
* WP-0043: Waiver Expiration and Audit
* WP-0030: Plan Policy Evaluation

### Protected Principles

* Policy-as-code
* Explainable governance
* CI-ready validation
* Plan safety gates

---

## ADR-0011: Deterministic Context Before AI Assistance

Status: Proposed

### Context

AI assistants need repository context.

Unmanaged context can:

* leak secrets,
* omit constraints,
* misrepresent current state,
* include stale docs,
* ignore ADRs,
* miss active work packets,
* overlook policies,
* or encourage unsafe changes.

Monad should make AI safer by generating deterministic context before AI is involved.

Context generation is useful even without AI. It helps humans hand off work between sessions, collaborators, and future tools.

### Decision

Monad will first generate deterministic context packs and handoffs without AI.

AI assistance can later consume these artifacts.

Context generation should:

* work offline,
* require no AI provider,
* respect ignore rules,
* exclude known secret files,
* report included/excluded files where possible,
* include repository identity,
* include command surface,
* include known risks and missing data,
* include relevant docs/governance artifacts.

### Consequences

Positive:

* useful without AI,
* safer AI workflows,
* repeatable handoffs,
* better session continuity,
* auditable context export,
* privacy-preserving defaults.

Negative:

* summaries may be less polished without AI,
* context relevance rules need iteration,
* context size management may be difficult,
* redaction rules must be maintained.

### Alternatives Considered

#### AI-Generated Context Only

Rejected because AI should not be required for context, and AI-generated context may hallucinate or omit constraints.

#### Manual Handoff Docs Only

Rejected as insufficient because manual handoffs drift and are inconsistent.

#### No Context Feature

Rejected because context handoff is central to Monad’s value for both humans and AI-assisted workflows.

### Follow-Up Actions

* Build `monad context handoff`.
* Add redaction rules.
* Add context verification.
* Add context manifest.
* Add context pack generator.
* Add AI provider integration only after deterministic context exists.

### Related Work Packets

* WP-0020: Context Model
* WP-0021: Handoff Generator
* WP-0022: Context Pack Generator
* WP-0023: Context Redaction and Safety
* WP-0024: Context Verification
* WP-0063: Prompt Template Model
* WP-0065: AI-Assisted Plan Explanation

### Protected Principles

* Deterministic before AI
* Context safety
* AI optionality
* Handoff continuity

---

## ADR-0012: Honest Placeholder Commands

Status: Accepted

### Context

Monad’s command surface is intentionally broad, but early implementation will be incomplete.

Planned commands are useful because they communicate product direction and allow command catalog tests to protect future surface design.

However, broad planned command visibility creates risk.

Users must not be misled into thinking an unimplemented command actually performs real validation, planning, mutation, policy evaluation, or safety checks.

A CLI that silently succeeds without performing real behavior damages trust.

### Decision

Unimplemented, partial, or planned commands must be clearly marked as such.

Command metadata must include enough information to make command status and safety posture visible.

Recommended metadata includes:

```text id="gku44v"
implemented
status
mutating
plan_backed
supports_dry_run
uses_network
uses_ai
stability
```

Placeholder commands should:

* say they are not fully implemented,
* describe intended future behavior,
* avoid pretending success,
* avoid mutating files,
* avoid calling network,
* avoid calling AI,
* and use a documented exit behavior.

### Consequences

Positive:

* user trust,
* safer roadmap visibility,
* contract-testable command surface,
* clearer development sequencing,
* easier detection of command drift.

Negative:

* output may feel unfinished,
* requires metadata discipline,
* planned surface may feel larger than current implementation,
* placeholder exit code strategy must be decided.

### Alternatives Considered

#### Hide Future Commands

Rejected as the only approach because planned command visibility helps communicate direction and test the command catalog.

However, hiding planned commands by default may be considered if UX becomes confusing.

#### Show Commands Without Status

Rejected because it misleads users.

#### Allow Placeholder Success Messages

Rejected because success implies real behavior.

### Follow-Up Actions

* Add placeholder renderer.
* Add tests for planned command honesty.
* Document command stability.
* Add command metadata.
* Add command catalog contract tests for placeholder behavior.
* Decide placeholder exit code strategy.
* Ensure mutating placeholders never mutate.

### Related Work Packets

* WP-0004: Command Catalog Model
* WP-0005: Clap Surface Contract
* WP-0006: Placeholder Honesty and Command Metadata
* WP-0007: CLI Output and Exit Code Standardization

### Protected Principles

* Command honesty
* Trustworthy CLI surface
* No fake success
* Roadmap visibility without deception

---

## 18.6 ADR Dependency Map

The initial ADRs reinforce each other.

```text id="9x0pph"
ADR-0001 Rust Single-Binary Runtime
  supports ADR-0003 Local-First Core
  supports ADR-0006 Plan-Backed Mutation
  supports deterministic repository analysis

ADR-0002 Coordinate Native Tools
  supports cloud/framework/database agnosticism
  supports polyglot repository understanding
  constrains generator and adapter scope

ADR-0003 Local-First Core
  constrains hosted roadmap
  supports privacy and offline use
  requires local reports/context/graph first

ADR-0004 AI-Native but AI-Optional
  depends on ADR-0011 Deterministic Context Before AI
  constrains AI roadmap
  supports plan-backed mutation safety

ADR-0005 Canonical Manifest
  supports source-of-truth checks
  supports workspace detection
  supports config, check, doctor, graph, context

ADR-0006 Plan-Backed Mutation
  constrains generators, packs, AI suggestions, migrations
  requires plan schema, dry-run, apply reports

ADR-0007 Modular Rust Workspace
  organizes implementation boundaries
  should not create empty architecture

ADR-0008 Lifecycle Graph
  connects docs, ADRs, work packets, policies, tests, releases
  supports AI context and hosted dashboards later

ADR-0009 Documentation-as-Code
  supports docs check, context handoff, governance, release readiness

ADR-0010 Policy-as-Code
  supports check, plan gates, release readiness, waivers

ADR-0011 Deterministic Context Before AI
  supports AI safety and handoff continuity

ADR-0012 Honest Placeholder Commands
  protects CLI trust while roadmap is broad
```

---

## 18.7 ADRs by Roadmap Stage

| Stage                                              | Relevant ADRs                          |
| -------------------------------------------------- | -------------------------------------- |
| Stage 0: Repository Foundation                     | ADR-0003, ADR-0005, ADR-0009           |
| Stage 1: CLI Skeleton and Command Contracts        | ADR-0001, ADR-0012                     |
| Stage 2: Read-Only Repository Understanding        | ADR-0002, ADR-0003, ADR-0005, ADR-0008 |
| Stage 3: Docs, ADR, Work-Packet, Context Lifecycle | ADR-0009, ADR-0011                     |
| Stage 4: Plan-Backed Mutation Engine               | ADR-0006                               |
| Stage 5: Generators, Templates, and Packs          | ADR-0002, ADR-0006                     |
| Stage 6: Policy Engine and Waivers                 | ADR-0010                               |
| Stage 7: Release and Change Lifecycle              | ADR-0006, ADR-0009, ADR-0010           |
| Stage 8: Graph Maturity                            | ADR-0008                               |
| Stage 9: AI-Assisted Planning                      | ADR-0004, ADR-0011, ADR-0006           |
| Stage 10: Optional Hosted Control Plane            | ADR-0003, ADR-0008, ADR-0010           |

---

## 18.8 Future ADR Candidates

The following decisions may require future ADRs.

### 18.8.1 Output Schema Versioning

Potential ADR:

```text id="b69trq"
ADR-0013: Versioned Machine-Readable Output Schemas
```

Reason:

JSON output, findings, graph reports, plan files, apply reports, and policy reports will become automation contracts.

### 18.8.2 Exit Code Taxonomy

Potential ADR:

```text id="owxds3"
ADR-0014: Stable CLI Exit Code Taxonomy
```

Reason:

CI integration requires stable exit behavior.

### 18.8.3 Local Graph Cache

Potential ADR:

```text id="ucr01a"
ADR-0015: Local Graph Cache Is Rebuildable Generated State
```

Reason:

Graph caching must not become hidden canonical truth.

### 18.8.4 Pack and Template Trust Model

Potential ADR:

```text id="zrgvos"
ADR-0016: Pack and Template Trust Model
```

Reason:

Packs/templates affect repository mutation and must be signed, versioned, previewable, or otherwise controlled.

### 18.8.5 Plugin Execution Model

Potential ADR:

```text id="8mse6p"
ADR-0017: Plugin Execution and Trust Boundary
```

Reason:

Plugin execution is higher risk than templates and should not be introduced casually.

### 18.8.6 Hosted Control Plane Boundary

Potential ADR:

```text id="lv6ny4"
ADR-0018: Hosted Control Plane Is Optional Projection Layer
```

Reason:

Hosted features must not undermine local-first operation.

### 18.8.7 Telemetry Policy

Potential ADR:

```text id="ii0u7n"
ADR-0019: No Telemetry by Default
```

Reason:

Telemetry has trust and privacy implications and should be explicitly governed.

### 18.8.8 AI Provider Port and Noop Adapter

Potential ADR:

```text id="ycif41"
ADR-0020: AI Provider Port and Noop Adapter
```

Reason:

AI support must remain optional and testable without live providers.

---

## 18.9 ADR Maintenance Rules

### 18.9.1 When to Add an ADR

Add an ADR when a decision:

* affects architecture boundaries,
* affects safety,
* affects source-of-truth rules,
* affects mutating behavior,
* affects AI or hosted boundaries,
* affects schemas,
* affects command contracts,
* affects plugin/pack trust,
* affects release governance,
* or creates long-term trade-offs.

### 18.9.2 When Not to Add an ADR

Do not add an ADR for:

* tiny refactors,
* typo fixes,
* local implementation details,
* temporary bug fixes,
* test-only changes,
* documentation wording changes,
* trivial dependency updates.

Use decision logs or work-packet notes instead.

### 18.9.3 How to Supersede an ADR

To supersede an ADR:

1. Create a new ADR.
2. Mark the old ADR as `Superseded`.
3. Link old ADR to new ADR.
4. Explain why the change was necessary.
5. Update affected docs and work packets.

### 18.9.4 ADR Review Expectations

ADR changes should be reviewed for:

* consistency with product doctrine,
* local-first preservation,
* safety impact,
* test impact,
* documentation impact,
* implementation feasibility,
* roadmap sequence impact.

---

## 18.10 Section Acceptance Criteria

This section is successful if a reader understands that:

1. ADRs are the durable record of Monad’s major architecture decisions.
2. Rust single-binary runtime is accepted.
3. Native-tool coordination over replacement is accepted.
4. Local-first core is accepted.
5. AI-native but AI-optional architecture is accepted.
6. `monad.toml` as canonical manifest is accepted.
7. Plan-backed mutation is accepted.
8. Modular Rust workspace is proposed but should avoid premature crate explosion.
9. Lifecycle graph as core model is proposed.
10. Documentation-as-code is proposed.
11. Policy-as-code is proposed.
12. Deterministic context before AI assistance is proposed.
13. Honest placeholder commands are accepted.
14. Future work packets should reference relevant ADRs.
15. Accepted ADRs should not be silently contradicted.
16. Proposed ADRs should guide implementation but may still be refined.
17. Future ADRs should be added for schema, exit code, graph cache, pack/plugin trust, hosted boundary, telemetry, and AI provider decisions.
18. The ADR set reinforces Monad’s core doctrine: local-first, deterministic, governance-grade, AI-optional, read-only-before-mutation, plan-backed-before-mutation, native-tool-coordinating, and lifecycle-graph-centered.

The final ADR rule is:

> Monad should not make major architectural moves by accident; decisions that shape trust, safety, source of truth, mutation, AI, hosting, policy, or extensibility belong in ADRs.
