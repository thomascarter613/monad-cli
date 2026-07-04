# Monad OS / Monad CLI

# Enterprise-Grade Product Planning Package

# Part 4: ADRs, Traceability, Risks, Governance, Execution, Technology Strategy, and Final Review

## Running Table of Contents

Part 1.
1. Product Understanding and Assumptions
2. Executive Summary
3. Product Charter
4. Product Requirements Document
5. Domain Model and DDD Design
6. Architecture Strategy
7. AI Architecture

Part 2.
8. Data Architecture
9. API and Integration Design
10. Security, Privacy, Compliance, and Governance
11. Infrastructure and Cloud-Agnostic Deployment Plan
12. Observability and Operations
13. Testing Strategy
14. BDD Specification Set

Part 3.
15. Implementation Roadmap
16. Initial Repository and Documentation Structure
17. Initial Documentation Files

Part 4.
18. ADR Set
19. Traceability Matrix
20. Risk Register
21. Governance and Decision System
22. Execution Plan
23. Recommended Technology Strategy
24. Final Review

This document covers sections 18 through 24.

---

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

# 19. Traceability Matrix

## 19.1 Traceability Strategy

Monad should connect business goals, user needs, requirements, architecture, tests, work packets, and docs.

The matrix below is an initial traceability baseline.

## 19.2 Core Traceability Matrix

| Business Goal              | User Need                      | Requirement             | Architecture Component              | Test Evidence             | Work Packet             | Docs                                     |
| -------------------------- | ------------------------------ | ----------------------- | ----------------------------------- | ------------------------- | ----------------------- | ---------------------------------------- |
| Make repos understandable  | Inspect repo structure         | `monad inspect`         | `monad-inspect`                     | fixture integration tests | WP-0009                 | `docs/user-guide/commands.md`            |
| Make repos governable      | Validate invariants            | `monad check`           | `monad-policy`, `monad-config`      | check tests               | WP-0010                 | `docs/engineering/testing-strategy.md`   |
| Preserve trust             | Command honesty                | command metadata        | command catalog                     | catalog contract tests    | WP-0004/WP-0006         | `docs/engineering/command-catalog.md`    |
| Avoid unsafe changes       | Plan before mutation           | plan/apply              | `monad-plans`                       | dry-run/apply tests       | WP-0025-WP-0029         | `docs/reference/plan-schema.md`          |
| Support AI safely          | Generate context               | context handoff         | `monad-context`                     | redaction tests           | WP-0020-WP-0024         | `docs/user-guide/context-handoff.md`     |
| Preserve local-first value | No required backend            | local file-backed state | `monad-config`, filesystem adapters | offline tests             | WP-0002                 | `docs/architecture/overview.md`          |
| Avoid vendor lock-in       | Cloud/database agnostic design | adapter boundaries      | ports/adapters                      | adapter conformance tests | WP-0044-WP-0049         | `docs/architecture/data-architecture.md` |
| Improve governance         | ADR/work-packet lifecycle      | ADR/workpacket commands | governance context                  | docs fixture tests        | WP-0016-WP-0019         | `docs/governance/governance-model.md`    |
| Enable graph moat          | Lifecycle graph                | graph outputs           | `monad-graph`                       | graph invariant tests     | WP-0012/WP-0055-WP-0060 | `docs/reference/graph-schema.md`         |
| Enable CI use              | Machine-readable checks        | JSON output/exit codes  | output layer                        | schema tests              | WP-0007                 | `docs/engineering/output-formats.md`     |

## 19.3 Requirement-to-Test Mapping

| Requirement                                    | Tests                        |
| ---------------------------------------------- | ---------------------------- |
| `monad version` reports version                | CLI smoke test               |
| `monad list` lists commands                    | CLI smoke + snapshot         |
| Catalog matches Clap                           | command catalog contract     |
| `monad.toml` is canonical                      | manifest unit tests          |
| `workspace.toml` mirror conflicts reported     | fixture integration test     |
| `monad inspect` is read-only                   | mutation safety test         |
| `monad check` returns nonzero in CI on failure | CLI integration test         |
| `monad graph` emits valid graph                | graph invariant + snapshot   |
| Context excludes secrets                       | security fixture test        |
| Dry-run does not modify files                  | dry-run mutation test        |
| Apply only executes planned ops                | apply contract test          |
| Policy explain returns remediation             | policy unit/integration test |

## 19.4 Artifact-to-Owner Mapping

| Artifact         | Owner Role                  |
| ---------------- | --------------------------- |
| `monad.toml`     | workspace maintainer        |
| command catalog  | CLI maintainer              |
| ADRs             | architecture owner          |
| work packets     | delivery owner              |
| policies         | governance/security owner   |
| plans            | change author               |
| apply reports    | change author/reviewer      |
| context packs    | developer/AI workflow owner |
| risk register    | product/architecture owner  |
| release evidence | release owner               |

---

# 20. Risk Register

| Risk ID | Description                                   | Category      | Likelihood | Impact   | Severity | Mitigation                                                      | Detection              | Owner Role        | Related WP      | Residual Risk |
| ------- | --------------------------------------------- | ------------- | ---------- | -------- | -------- | --------------------------------------------------------------- | ---------------------- | ----------------- | --------------- | ------------- |
| R-001   | Scope explosion from huge command surface     | Product       | High       | High     | Critical | strict layering, placeholder honesty, roadmap gates             | roadmap review         | product owner     | all             | Medium        |
| R-002   | Too many placeholders reduce trust            | Product       | Medium     | High     | High     | convert placeholders into real read-only behavior incrementally | command catalog report | CLI maintainer    | WP-0006         | Medium        |
| R-003   | Unsafe mutation damages repos                 | Safety        | Medium     | Critical | Critical | plan/apply, dry-run, approval flags, tests                      | mutation safety tests  | plan engine owner | WP-0025-WP-0029 | Low           |
| R-004   | Secret leakage into context packs             | Security      | Medium     | Critical | Critical | redaction, ignore rules, security tests                         | context security tests | security owner    | WP-0023         | Low           |
| R-005   | `monad.toml` and `workspace.toml` drift       | Governance    | High       | Medium   | High     | canonical manifest policy                                       | `monad check`          | config owner      | WP-0002         | Low           |
| R-006   | Monad tries to replace too many native tools  | Architecture  | Medium     | High     | High     | adapter strategy, ADR-0002                                      | architecture review    | architect         | WP-0044-WP-0049 | Medium        |
| R-007   | Lifecycle graph becomes too complex too early | Architecture  | Medium     | Medium   | Medium   | start with v0 graph, avoid persistence early                    | graph tests            | graph owner       | WP-0012         | Medium        |
| R-008   | AI features undermine deterministic trust     | AI            | Medium     | High     | High     | AI optionality, noop adapter, human approval                    | AI workflow tests      | AI owner          | WP-0061-WP-0067 | Medium        |
| R-009   | Plugin/packs introduce supply-chain risk      | Security      | Medium     | High     | High     | defer plugins, checksum/signature model                         | security review        | security owner    | WP-0034-WP-0037 | Medium        |
| R-010   | CLI output changes break users/CI             | Compatibility | Medium     | Medium   | Medium   | schema versions, snapshot tests                                 | CI                     | CLI maintainer    | WP-0007         | Low           |
| R-011   | Documentation becomes stale                   | Governance    | High       | Medium   | High     | `docs check`, docs-as-code                                      | docs check             | docs owner        | WP-0014         | Medium        |
| R-012   | Work packet process becomes bureaucratic      | Product       | Medium     | Medium   | Medium   | lightweight templates, profiles                                 | user feedback          | product owner     | WP-0018         | Medium        |
| R-013   | Rust crate boundaries become premature        | Architecture  | Medium     | Medium   | Medium   | create crates when needed, avoid empty abstractions             | architecture review    | architect         | WP-0001         | Medium        |
| R-014   | Native tool adapter behavior inconsistent     | Integration   | Medium     | Medium   | Medium   | fixtures, adapter conformance tests                             | adapter tests          | integration owner | WP-0044-WP-0049 | Medium        |
| R-015   | Hosted layer distracts from local core        | Strategy      | Medium     | High     | High     | defer hosted until local v1                                     | roadmap gate           | product owner     | WP-0068+        | Low           |
| R-016   | Hard-to-explain product category              | GTM           | High       | Medium   | High     | use “local-first SDLC control plane” framing                    | positioning review     | product owner     | docs/product    | Medium        |
| R-017   | Graph/cache data treated as source of truth   | Data          | Medium     | Medium   | Medium   | clear docs, source references                                   | check command          | data owner        | WP-0059         | Low           |
| R-018   | Apply failures leave partial state            | Reliability   | Medium     | High     | High     | preflight, rollback hints, atomic write patterns                | apply tests            | plan owner        | WP-0028/WP-0029 | Medium        |
| R-019   | Policy false positives frustrate users        | Governance    | Medium     | Medium   | Medium   | explain, severity, waivers                                      | policy feedback        | policy owner      | WP-0040-WP-0043 | Medium        |
| R-020   | Solo developer process becomes too heavy      | Delivery      | High       | Medium   | High     | small layers, copy-pasteable patches, no fragile scripts        | cadence review         | project owner     | all             | Medium        |

---

# 21. Governance and Decision System

## 21.1 Governance Philosophy

Monad governance should make serious development safer and clearer without creating unnecessary bureaucracy.

Governance exists to answer:

```text id="j1b2mz"
What changed?
Why did it change?
Who or what approved it?
What policy applied?
What test proves it?
What docs explain it?
What risk remains?
```

## 21.2 Decision-Making Process

Recommended decision levels:

| Level                        | Example                              | Required Artifact   |
| ---------------------------- | ------------------------------------ | ------------------- |
| Minor implementation         | refactor internals                   | commit message/test |
| User-visible behavior        | command output change                | work packet update  |
| Architecture decision        | new crate, schema, mutation model    | ADR                 |
| Governance/security decision | policy, waiver model, AI safety      | ADR + risk update   |
| Release decision             | version, compatibility, distribution | release plan        |

## 21.3 ADR Process

Lifecycle:

```text id="4c2d0c"
draft -> proposed -> accepted -> superseded -> deprecated
```

ADR required when:

* architecture style changes,
* source-of-truth model changes,
* mutation safety model changes,
* AI architecture changes,
* persistence model changes,
* plugin trust model changes,
* public CLI contract changes significantly.

## 21.4 RFC Process

Use RFCs for large future features before ADR acceptance.

RFC should include:

* problem,
* proposal,
* alternatives,
* compatibility,
* security impact,
* migration impact,
* testing plan,
* rollout plan.

## 21.5 Change Management

Every significant change should map to:

```text id="odgqg8"
Epic -> Work Packet -> Layer -> Commit/PR
```

Minimum change record:

* what changed,
* why,
* files affected,
* tests run,
* docs updated,
* risk notes.

## 21.6 Release Governance

Release gates:

```text id="g3dyqx"
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
command catalog contract
docs check
policy check
changelog update
version update
release notes
security review for sensitive changes
```

## 21.7 Security Review Process

Security review required for:

* context export changes,
* file mutation changes,
* plugin/pack install behavior,
* external command execution,
* network access,
* AI provider integrations,
* release artifact changes.

## 21.8 Architecture Review Process

Architecture review required for:

* new crate boundaries,
* schema changes,
* graph model changes,
* plan/apply changes,
* policy model changes,
* hosted control plane decisions,
* database or cache introduction.

## 21.9 Dependency Governance

Dependency additions should document:

* why needed,
* alternatives,
* maintenance status,
* license,
* security posture,
* transitive dependency risk.

## 21.10 AI Governance

AI workflows require:

* explicit opt-in,
* provider configuration,
* context redaction,
* prompt template versioning,
* human approval for mutation,
* audit metadata,
* deterministic fallback.

## 21.11 Data Governance

Rules:

* `monad.toml` is canonical.
* `workspace.toml` is mirror only.
* `.monad/` is local state/cache unless documented otherwise.
* generated artifacts need lineage metadata.
* context packs must exclude secrets.
* schemas must be versioned.

## 21.12 Documentation Governance

Docs must be updated when:

* command behavior changes,
* architecture changes,
* policies change,
* work packet status changes,
* release process changes,
* security model changes.

`monad docs check` should eventually enforce this.

---

# 22. Execution Plan

## 22.1 First 30 Days

Primary objective:

> Stabilize the CLI foundation and command catalog contract.

Build:

* command catalog completeness,
* Clap surface alignment,
* placeholder honesty,
* config subcommands,
* version/list/help stability,
* initial documentation updates.

Quality gates:

```bash id="bya9ub"
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
```

Recommended work packets:

```text id="7i7wfk"
WP-0004 Command Catalog Model
WP-0005 Clap Surface Contract
WP-0006 Placeholder Honesty
WP-0007 CLI Output and Exit Codes
```

## 22.2 First 60 Days

Primary objective:

> Make Monad useful as a read-only repository understanding tool.

Build:

* workspace root detection,
* manifest resolution,
* `monad inspect`,
* `monad check`,
* `monad doctor`,
* initial graph model.

Recommended work packets:

```text id="cllojl"
WP-0008 Workspace Root Detection
WP-0009 Repository Inspection Engine
WP-0010 Baseline Check Engine
WP-0011 Doctor Diagnostics
WP-0012 Lifecycle Graph v0
```

## 22.3 First 90 Days

Primary objective:

> Make docs, governance, and context first-class.

Build:

* `monad docs check`,
* `monad adr list`,
* `monad workpacket list`,
* `monad context handoff`,
* context redaction,
* docs/governance fixture tests.

Recommended work packets:

```text id="ihykzw"
WP-0014 Docs Check
WP-0016 ADR List and Validation
WP-0018 Work Packet List and Validation
WP-0020 Context Model
WP-0021 Handoff Generator
WP-0023 Context Redaction and Safety
```

## 22.4 First 6 Months

Primary objective:

> Add the plan-backed mutation foundation.

Build:

* plan schema,
* plan creation for docs/ADRs/work packets,
* dry-run apply,
* approved apply for low-risk operations,
* apply reports,
* rollback hints,
* policy evaluation for plans.

Recommended work packets:

```text id="8asqkt"
WP-0025 Plan Schema and Domain Model
WP-0026 Plan Creation for Documentation Artifacts
WP-0027 Dry-Run Apply Engine
WP-0028 Apply Engine with Approval
WP-0029 Rollback Hints and Apply Reports
WP-0030 Plan Policy Evaluation
```

## 22.5 First Year

Primary objective:

> Reach stable local-first Monad OS core.

Build:

* safe generators,
* core templates,
* pack model,
* policy engine,
* native tool adapters,
* release/change lifecycle,
* advanced graph exports,
* JSON schemas,
* stronger CI/release process.

Recommended focus:

```text id="jsu70v"
generators after plan/apply
policy after baseline checks
packs after templates
AI after deterministic context
hosted control plane after local v1
```

## 22.6 What to Build First

Build first:

1. command catalog stability,
2. config/source-of-truth behavior,
3. read-only inspect/check/doctor,
4. docs check,
5. context handoff,
6. graph v0,
7. plan schema,
8. dry-run apply.

## 22.7 What to Defer

Defer:

* hosted dashboard,
* plugin marketplace,
* AI provider integrations,
* complex generators,
* graph database,
* multi-cloud hosted deployments,
* enterprise RBAC,
* multi-repo fleet management.

## 22.8 What Not to Build Yet

Do not build yet:

* autonomous AI code mutation,
* direct unsafe file-writing commands,
* SaaS-first backend,
* required database,
* Kubernetes-first runtime,
* full replacement for native task/build tools,
* complex plugin runtime before trust model.

## 22.9 Critical Path

Critical path:

```text id="ird71x"
command catalog
  -> CLI contract
  -> workspace model
  -> inspect/check
  -> docs/context/graph
  -> plan schema
  -> dry-run apply
  -> safe apply
  -> generators
  -> policy gates
```

## 22.10 Parallelizable Work

Parallelizable after CLI foundation:

* docs drafting,
* ADR drafting,
* fixture repo creation,
* output schema design,
* policy rule definitions,
* graph schema design,
* context redaction rules,
* runbooks.

## 22.11 Solo Developer Strategy

For solo development:

* use small work packets,
* avoid fragile shell scripts,
* prefer manual file-save patches when needed,
* keep tests green after every layer,
* stop and stabilize when contracts fail,
* commit after each green layer,
* do not build hosted features early.

---

# 23. Recommended Technology Strategy

## 23.1 Technology Strategy Principles

Technology choices should follow architecture needs.

Monad should prefer:

* boring, reliable tools,
* local-first tools,
* testable libraries,
* portable formats,
* minimal required dependencies,
* explicit adapters,
* strong schema/versioning discipline.

## 23.2 Core Language

Recommended:

```text id="j7mupm"
Rust
```

Why:

* single binary,
* performance,
* type safety,
* strong CLI ecosystem,
* suitable for filesystem and graph work.

Alternatives:

* Go: strong alternative, less aligned with current repo.
* TypeScript: good ecosystem, weaker single-binary/local runtime posture.
* Python: good for scripts, not ideal for core runtime.

Decision:

Continue Rust.

## 23.3 CLI Framework

Recommended:

```text id="uv349t"
clap
```

Why:

* mature,
* widely used,
* derive and builder support,
* nested subcommands,
* help output,
* shell completions later.

Lock-in risk:

Low to medium. CLI surface can be modeled separately in command catalog.

## 23.4 Serialization

Recommended:

```text id="jztm4z"
serde
serde_json
toml
```

Why:

* Rust standard ecosystem,
* supports manifests and JSON outputs,
* stable enough for schema-versioned files.

## 23.5 Error Handling

Recommended:

```text id="yb4tzg"
thiserror for library/domain errors
anyhow for CLI boundary if useful
```

Why:

* clean domain errors,
* practical CLI ergonomics.

## 23.6 Terminal Output

Recommended:

```text id="x8luik"
anstream
anstyle
owo-colors or similar, optional
```

Keep color optional and disable in CI.

Avoid over-investing in fancy terminal UI early.

## 23.7 Testing

Recommended:

```text id="i7yhpz"
cargo test
assert_cmd
predicates
insta
tempfile
proptest
```

Purpose:

* CLI smoke tests,
* output assertions,
* snapshots,
* temp fixture repos,
* property-based invariants.

## 23.8 JSON Schema

Recommended later:

```text id="wsvgzb"
schemars
```

Purpose:

* generate JSON schemas from Rust types,
* validate structured outputs.

## 23.9 Graph Export

Recommended:

* build internal graph model in Rust,
* export to JSON,
* export to Mermaid,
* export to DOT.

Avoid requiring a graph database early.

## 23.10 Embedded Store

Recommended later:

```text id="r0l4ki"
SQLite
```

Use only when local graph/index performance requires it.

Avoid making SQLite canonical source of truth.

## 23.11 Hosted Store

Recommended later:

```text id="no7an3"
PostgreSQL
```

Use for optional hosted control plane.

Do not require it for local CLI.

## 23.12 Policy Engine

Recommended sequence:

1. built-in Rust policy rules,
2. structured policy files,
3. policy explain,
4. waivers,
5. optional OPA/Rego integration later if justified.

Do not start with full OPA dependency unless enterprise policy requirements demand it.

## 23.13 AI Provider Strategy

Recommended sequence:

1. `NoopAiAdapter`,
2. deterministic context packs,
3. prompt template model,
4. local model adapter,
5. hosted model adapters,
6. evals and safety reports.

Do not add real AI provider dependency before context safety is stable.

## 23.14 CI/CD

Recommended:

```text id="7msux4"
GitHub Actions initially
```

Because it is common and easy.

Keep CI logic portable by also supporting local scripts/commands.

## 23.15 Security Tooling

Recommended:

```text id="eql6w6"
cargo audit
cargo deny
gitleaks
SBOM generation later
OpenSSF Scorecard later
```

Make optional tools non-fatal locally unless explicitly configured.

## 23.16 Documentation

Recommended:

```text id="tca5ck"
Markdown
Mermaid
ADR markdown files
work-packet markdown files
```

Avoid hosted docs dependency early.

## 23.17 Release Tooling

Recommended later:

```text id="ejo4vr"
cargo-dist or custom release workflow
GitHub Releases
checksums
signing later
Homebrew later
```

---

# 24. Final Review

## 24.1 Recommended Direction

Monad should continue as a local-first Rust CLI that grows into a governance-grade SDLC control plane.

The correct immediate focus is not broad generation. It is trust.

Trust comes from:

* command catalog integrity,
* read-only inspection,
* clear source-of-truth rules,
* deterministic context,
* docs/governance lifecycle,
* safe plan-backed mutation.

## 24.2 Top 10 Most Important Decisions

1. Rust single-binary runtime.
2. Local-first core.
3. AI-native but AI-optional.
4. `monad.toml` is canonical.
5. `workspace.toml` is compatibility mirror only.
6. Coordinate native tools instead of replacing them.
7. Read-only understanding before mutation.
8. Plan-backed mutation before generators.
9. Lifecycle graph is the long-term moat.
10. Hosted control plane is optional and deferred.

## 24.3 Top 10 Risks

1. Scope explosion.
2. Too many placeholders.
3. Unsafe mutation.
4. Secret leakage into context.
5. Product category confusion.
6. Replacing native tools accidentally.
7. Premature hosted/SaaS layer.
8. Premature plugin system.
9. Over-complex graph model.
10. AI features undermining deterministic trust.

## 24.4 Top 10 Next Actions

1. Finish command catalog and Clap surface alignment.
2. Ensure `config list` and nested catalog commands exist in Clap.
3. Stabilize placeholder honesty.
4. Standardize output and exit codes.
5. Implement workspace root detection.
6. Implement canonical manifest resolution.
7. Implement `monad inspect`.
8. Implement `monad check`.
9. Implement `monad context handoff`.
10. Start plan schema only after read-only commands are useful.

## 24.5 What Should Be Validated Before Implementation

Validate:

* command surface hierarchy,
* canonical manifest schema,
* minimal workspace model,
* output format expectations,
* plan schema shape,
* graph node/edge model,
* docs required for v0,
* context redaction rules,
* mutation safety rules,
* native tool adapter boundaries.

## 24.6 What Should Never Be Compromised

Never compromise:

* local-first core,
* no AI dependency for correctness,
* source-of-truth clarity,
* mutation safety,
* secret redaction,
* test-backed command behavior,
* command catalog honesty,
* docs/governance traceability,
* native-tool coordination,
* portability.

## 24.7 What Can Safely Be Simplified

Can simplify:

* plugin system,
* hosted control plane,
* graph persistence,
* advanced policy language,
* AI provider support,
* release governance,
* complex generators,
* multi-cloud IaC,
* enterprise RBAC,
* visual dashboards.

## 24.8 What Can Be Postponed

Postpone:

* SaaS dashboard,
* org/team management,
* multi-repo fleet sync,
* graph database,
* pack registry,
* plugin marketplace,
* AI-assisted plan generation,
* cloud deployment automation,
* enterprise SSO,
* compliance certification claims.

## 24.9 First Implementation Work Packet

The best immediate work packet is:

```text id="f77arz"
WP-0005: Clap Surface Contract
```

Reason:

The current failure reported that the Clap command tree is missing a catalog command, specifically `config list`.

That means the command catalog and actual CLI surface are drifting.

Before building deeper features, the CLI must be trustworthy.

## 24.10 First Practical Fix Direction

Fix the current class of issue by ensuring:

1. every catalog command that should be exposed is represented in Clap,
2. nested commands like `config list` exist,
3. placeholders are acceptable if the behavior is not implemented,
4. contract tests prove the surface stays aligned.

The right fix is not to remove `config list` from the catalog unless the product decision changes.

The better fix is to expose `config list` in the CLI and route it to either real config-list behavior or an honest placeholder.

## 24.11 Final Product Summary

Monad OS is best understood as:

> a local-first, AI-optional, cloud-agnostic, database-agnostic SDLC operating system that turns software repositories into governed lifecycle graphs and provides a safe control plane for understanding, validating, documenting, planning, and evolving them.

The current `monad-cli` repository is the seed of that system.

The highest-leverage next milestone is:

> a green, contract-tested, read-only Monad CLI that can explain a repository honestly.

After that, Monad can safely grow into documentation lifecycle, context handoff, graphing, planning, policy, generators, packs, AI assistance, and optional hosted control-plane features.
