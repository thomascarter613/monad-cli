# 1. Product Understanding and Assumptions

## 1.1 Purpose of This Section

This section establishes the shared understanding that governs the rest of the Monad OS / Monad CLI planning package.

Its purpose is to clarify:

* what Monad OS is,
* what Monad CLI is,
* what the current `monad-cli` repository represents,
* why the product exists,
* what the product is not,
* what assumptions are being made,
* what assumptions are explicitly not being made,
* and what boundaries should guide future planning and implementation.

This section is intentionally foundational. It does not attempt to provide the full architecture, roadmap, implementation plan, security model, testing strategy, or product requirements. Those are covered in later sections.

The goal here is to prevent conceptual drift before deeper planning begins.

A future reader should leave this section understanding that Monad is not merely a CLI, not merely a scaffolder, not merely a task runner, and not merely an AI helper. Monad is intended to become a local-first SDLC control plane and monorepo operating system, beginning with a trustworthy Rust CLI.

---

## 1.2 Product Understanding

Monad OS is a local-first SDLC control plane and monorepo operating system.

The first executable product surface is `monad-cli`, a Rust single-binary command-line runtime named `monad`.

Monad is intended to make serious software repositories:

* self-describing,
* governable,
* inspectable,
* auditable,
* graphable,
* AI-ready,
* AI-optional,
* safely evolvable,
* documentation-aware,
* policy-aware,
* and lifecycle-aware.

The larger product thesis is that a software repository should not merely be a directory containing source files, scripts, manifests, and documentation. It should become a governed lifecycle system whose structure, decisions, policies, work, tests, documentation, release history, and AI context can be understood through a coherent local control plane.

Monad OS is therefore not merely:

* a scaffolder,
* a task runner,
* a documentation generator,
* an AI wrapper,
* a monorepo starter,
* a build system,
* a project management tool,
* a GitHub Actions generator,
* or a template collection.

It may include or coordinate capabilities in those categories, but the product thesis is broader:

> Monad OS turns a repository into a governed lifecycle graph and exposes a safe local control plane for understanding, validating, documenting, planning, and evolving it.

The current implementation begins with the local CLI because a trustworthy local runtime is the simplest and most durable foundation for the larger product.

---

## 1.3 Why Monad Exists

Modern software repositories are increasingly difficult to understand and govern.

A serious repository may contain:

* application code,
* services,
* libraries,
* packages,
* infrastructure code,
* CI workflows,
* package manager manifests,
* task runner configuration,
* architecture documents,
* Architecture Decision Records,
* work packets,
* release notes,
* test suites,
* security policies,
* dependency policies,
* ownership files,
* runbooks,
* generated files,
* AI prompts,
* handoff notes,
* and partial tribal knowledge that exists only in conversations.

These artifacts are usually disconnected.

A developer joining the repository, an AI assistant helping with a task, a platform engineer enforcing standards, or a maintainer trying to release safely must reconstruct the system from scattered evidence.

Monad exists to make that reconstruction explicit, deterministic, and repeatable.

The product’s core belief is:

> A repository should be able to explain itself.

It should be able to answer questions such as:

* What is this repository?
* What does it contain?
* What is canonical?
* What is generated?
* What depends on what?
* What policies apply?
* What architecture decisions shaped it?
* What work packet is currently active?
* What docs are stale or missing?
* What tests prove the expected behavior?
* What commands are safe to run?
* What commands would mutate files?
* What would happen before a change is applied?
* What context should a human or AI assistant have before making changes?

Monad exists to make those answers available locally, safely, and in a form that can be used by both humans and machines.

---

## 1.4 Product Identity and Naming

The product should be understood at several levels.

### Monad OS

Monad OS is the larger product and conceptual system.

It is the local-first SDLC control plane / monorepo operating system. It includes the product doctrine, architecture, lifecycle model, governance model, graph model, documentation model, policy model, context model, and future extension ecosystem.

Monad OS is the long-term product category.

### Monad CLI

Monad CLI is the primary local executable interface to Monad OS.

The binary is named:

```bash
monad
```

The CLI is the first runtime surface because it can provide immediate value without requiring a hosted backend, database, cloud account, web application, or AI provider.

### `monad-cli` Repository

The `monad-cli` repository is the current implementation vehicle.

It contains, or is expected to contain, the Rust workspace, CLI crate, core domain crates, documentation, governance files, work packets, ADRs, tests, policies, and implementation layers for the local Monad runtime.

### Optional Hosted Control Plane

A hosted control plane may exist later.

It could provide dashboards, team workflows, repository fleet management, compliance evidence, graph visualization, release governance, and organization-wide reporting.

However, the hosted control plane is optional and future-facing. It must not be required for core Monad value.

---

## 1.5 Relationship Between Monad OS, Monad CLI, and `monad-cli`

The relationship should be understood as follows:

```text
Monad OS
  ├─ Product category and conceptual system
  ├─ SDLC control-plane doctrine
  ├─ Lifecycle graph model
  ├─ Governance model
  ├─ Documentation model
  ├─ Policy model
  ├─ Context and handoff model
  ├─ Plan/apply mutation model
  │
  └─ Monad CLI
      ├─ Local Rust runtime
      ├─ Single binary named `monad`
      ├─ First executable interface
      ├─ Reads and validates local repositories
      ├─ Produces reports, graphs, context, and plans
      │
      └─ `monad-cli` repository
          ├─ Current implementation repository
          ├─ Rust workspace
          ├─ CLI and core crates
          ├─ Product docs
          ├─ ADRs
          ├─ Work packets
          ├─ Policies
          ├─ Tests
          └─ Governance artifacts
```

This distinction matters because future documents, issues, ADRs, and implementation work should avoid confusing:

* the product vision,
* the executable CLI,
* the repository currently being built,
* and possible future hosted features.

When in doubt:

* **Monad OS** refers to the larger system.
* **Monad CLI** refers to the local runtime.
* **`monad`** refers to the command/binary.
* **`monad-cli`** refers to the current repository.
* **Hosted Monad** refers only to a future optional extension.

---

## 1.6 Product Identity

Recommended product hierarchy:

```text
Monad OS
  ├─ monad-cli: local Rust CLI runtime
  ├─ monad-core: core domain models and contracts
  ├─ monad-plans: plan/apply mutation engine
  ├─ monad-policy: policy and governance engine
  ├─ monad-context: context and handoff engine
  ├─ monad-graph: lifecycle graph engine
  ├─ monad-packs: curated packs/templates/plugins
  └─ optional hosted control plane later
```

This hierarchy should be treated as conceptual rather than immediately mandatory.

Not every crate, subsystem, pack, plugin, or hosted feature must exist at the beginning. The hierarchy describes the intended product shape and the direction of decomposition as the implementation matures.

The near-term implementation should remain disciplined:

1. stabilize the local CLI,
2. stabilize the command catalog,
3. implement read-only repository understanding,
4. implement documentation and governance lifecycle support,
5. implement deterministic context handoff,
6. implement plan-backed mutation,
7. then add deeper generators, packs, plugins, policies, and optional hosted capabilities.

---

## 1.7 Core Product Statement

> Monad OS is a local-first, governance-grade SDLC control plane that turns software repositories into governed lifecycle graphs and provides a safe Rust CLI for understanding, validating, documenting, planning, and evolving them.

This statement should guide product decisions.

If a proposed feature does not help a repository become more understandable, governable, traceable, safe, or evolvable, it should be questioned.

If a proposed feature makes Monad dependent on one cloud, one database, one AI provider, one framework, or one hosted service, it should be treated carefully and likely deferred or isolated behind an adapter.

---

## 1.8 Developer-Facing Statement

> Monad helps developers understand, validate, document, graph, and safely evolve serious monorepos without locking into one cloud, database, framework, package manager, task runner, or AI provider.

For developers, the product should feel like a trustworthy local companion for serious repositories.

A developer should be able to run commands such as:

```bash
monad inspect
monad check
monad doctor
monad graph
monad context handoff
monad docs check
monad plan
```

and receive useful, honest, deterministic output.

Developer trust is central.

Monad should not pretend to implement features that are only planned. It should not silently mutate repositories. It should not hide risky behavior behind friendly command names. It should not require cloud or AI services to perform core work.

---

## 1.9 Enterprise-Facing Statement

> Monad provides a deterministic repository control plane for enforcing architecture, governance, documentation integrity, policy checks, change planning, and AI-safe software delivery across complex software systems.

For enterprise or institutional users, Monad’s value is not merely convenience. It is control, traceability, auditability, and repeatability.

Enterprise-facing value includes:

* architecture governance,
* policy enforcement,
* documentation integrity,
* command surface control,
* work packet traceability,
* ADR traceability,
* change planning,
* release readiness,
* security evidence,
* AI context governance,
* and safer repository evolution.

Monad should eventually be able to support regulated, security-sensitive, and governance-heavy environments without forcing every user to adopt heavyweight enterprise workflows from day one.

This means the product should support profiles or maturity levels over time, such as:

* solo developer,
* team,
* platform team,
* enterprise,
* regulated enterprise.

The early product should keep enterprise-grade architecture without making the solo-developer workflow unusable.

---

## 1.10 AI-Era Statement

> Monad gives humans and AI assistants a shared, governed source of truth for how a software system is structured, why it exists, what can change, and how changes should be applied safely.

Monad is designed for the AI era, but it is not an AI-first dependency.

AI assistants are powerful but risky when they lack repository context, architecture boundaries, policy constraints, current work-packet state, and source-of-truth rules.

Monad should make AI-assisted development safer by producing deterministic artifacts such as:

* repository summaries,
* context packs,
* handoff documents,
* command catalogs,
* graph outputs,
* policy reports,
* work-packet summaries,
* ADR indexes,
* plan previews,
* and safety warnings.

The important principle is:

> AI may consume Monad’s outputs, but Monad’s correctness must not depend on AI.

AI-generated recommendations, summaries, plans, or code should be treated as untrusted suggestions until they are validated by Monad’s deterministic checks and approved by a human.

---

## 1.11 Product Boundaries

Monad should coordinate the software delivery lifecycle around a repository, but it should not attempt to replace every tool in that lifecycle.

Monad should coordinate native tools such as:

* Cargo,
* Bun,
* npm,
* pnpm,
* Moon,
* Turborepo,
* Biome,
* Docker,
* Git,
* GitHub Actions,
* security scanners,
* documentation tools,
* infrastructure tools,
* and AI assistants.

Monad should not become a worse replacement for those tools.

Its role is to understand, validate, document, graph, govern, plan, and safely coordinate repository evolution.

A useful boundary is:

```text
Native tools perform their native jobs.
Monad understands and governs how those jobs fit into the repository lifecycle.
```

For example:

* Cargo remains responsible for Rust builds.
* Bun or npm remains responsible for JavaScript package workflows.
* Moon or Turborepo may remain responsible for task orchestration.
* GitHub Actions may remain responsible for CI execution.
* Docker remains responsible for image/container workflows.
* AI assistants remain optional helpers.
* Monad coordinates, validates, contextualizes, and governs.

This boundary is important because Monad’s scope is already large. Replacing mature native tools would increase implementation burden and weaken the product’s core thesis.

---

## 1.12 Current Implementation Phase

The current implementation phase is foundation and stabilization.

The immediate goal is not to implement the full Monad OS vision. The immediate goal is to make the local Rust CLI trustworthy.

The current phase should focus on:

* Rust workspace stability,
* `monad` binary stability,
* CLI library/binary split,
* command catalog integrity,
* Clap command surface alignment,
* honest placeholder commands,
* basic config command behavior,
* basic version/list/help behavior,
* and green tests.

The current phase should not prioritize:

* hosted control plane,
* AI provider integrations,
* real mutating generators,
* plugin marketplace,
* graph database,
* complex policy language,
* or enterprise dashboards.

A practical near-term milestone is:

> A green, contract-tested Monad CLI whose command catalog and executable command surface agree.

After that, the next major milestone is:

> A read-only Monad CLI that can inspect, validate, explain, graph, and summarize a repository without mutating it.

Only after that should the product move into serious plan-backed mutation.

---

## 1.13 Primary Assumptions

The following assumptions are used throughout this planning package:

1. Monad OS starts as a local-first open-source Rust CLI.
2. The first executable runtime is the `monad` binary.
3. The current implementation repository is `monad-cli`.
4. Hosted/cloud features are future optional extensions, not required for core value.
5. `monad.toml` is the canonical manifest.
6. `workspace.toml` is only a compatibility mirror.
7. `monad.lock` captures resolved state.
8. `.monad/` stores local Monad state, cache, context, and generated runtime artifacts.
9. The product coordinates native tools rather than replacing them.
10. Mutating commands must eventually be plan-backed.
11. Early mutating commands should be placeholder, dry-run, or preview-only until the plan engine is mature.
12. AI functionality must be optional.
13. Deterministic alternatives must exist for all core AI-adjacent workflows.
14. The first serious milestone should be read-only repository understanding.
15. The second serious milestone should be safe plan-backed mutation.
16. The central long-term moat is the lifecycle graph.
17. Documentation, ADRs, policies, work packets, tests, and plans are first-class lifecycle artifacts.
18. The implementation process should favor small, testable layers.
19. The product must remain useful to a solo developer.
20. The product should be architected so it can eventually support teams, enterprises, and regulated environments.

---

## 1.14 Non-Assumptions

The plan does not assume:

* a hosted SaaS backend,
* a mandatory database,
* a required cloud provider,
* a required AI provider,
* Kubernetes as the first runtime,
* GitHub as the only forge,
* microservices as the first architecture,
* a web UI as the first interface,
* a graph database as an initial dependency,
* a plugin marketplace as an early feature,
* a package registry as an early requirement,
* a visual dashboard as an early requirement,
* a full policy language as an early requirement,
* autonomous AI code mutation,
* or direct mutation before plan/apply safety exists.

These non-assumptions are important because they prevent the early product from becoming too heavy before the local CLI core proves its value.

Monad should be designed so these capabilities can exist later, but not so that they are required early.

---

## 1.15 Consequences of These Assumptions

The assumptions above create several practical consequences for the rest of the product plan.

### 1. Local Files Come First

The initial source of truth should be repository files, not a database or hosted service.

Important local files include:

```text
monad.toml
workspace.toml
monad.lock
.monad/
docs/
governance/
policies/
ADRs
work packets
native manifests
CI workflows
```

### 2. The CLI Surface Must Be Treated as a Contract

Because the CLI is the first product interface, command names, command metadata, flags, help output, exit codes, and structured output should be designed carefully.

The command catalog and actual Clap command tree must not drift.

### 3. Read-Only Commands Must Become Excellent Before Mutation

The first durable value should come from commands such as:

```bash
monad inspect
monad check
monad doctor
monad graph
monad docs check
monad context handoff
```

These commands build trust without risking destructive behavior.

### 4. Mutation Requires Plans

Commands that create, modify, delete, move, rename, or generate files must eventually flow through a plan/apply model.

The intended mature pattern is:

```bash
monad plan ...
monad apply plan.json --dry-run
monad apply plan.json --yes
```

### 5. AI Must Be Optional and Governed

AI-related workflows should be built on top of deterministic context, graph, policy, and planning outputs.

AI may help draft, explain, summarize, or suggest. It must not be required for correctness.

### 6. Native Tools Remain Native

Monad should detect and coordinate existing tools rather than absorb all their responsibilities.

This keeps Monad focused on its true role: the governed SDLC control plane.

### 7. The Lifecycle Graph Becomes the Long-Term Moat

The long-term differentiator is not simply a CLI command list. It is the ability to connect lifecycle artifacts:

```text
code -> docs -> ADRs -> work packets -> tests -> policies -> plans -> releases -> context
```

This graph is what makes Monad more than a scaffolder or task runner.

---

## 1.16 Section Acceptance Criteria

This section is successful if a reader understands the following:

1. Monad OS is the larger product and category.
2. Monad CLI is the local executable runtime.
3. `monad-cli` is the current implementation repository.
4. The product starts local-first and does not require a hosted backend.
5. The product is AI-native but AI-optional.
6. The product is cloud-agnostic and database-agnostic.
7. Monad coordinates native tools rather than replacing them.
8. `monad.toml` is canonical.
9. `workspace.toml` is a compatibility mirror only.
10. Mutation must eventually be plan-backed.
11. The first milestone is trustworthy read-only repository understanding.
12. The second milestone is safe plan-backed mutation.
13. The lifecycle graph is the central long-term product moat.
14. Hosted, AI, plugin, dashboard, database, and enterprise features are future extensions, not early dependencies.
15. The rest of the planning package should be interpreted through these assumptions.

If any later section contradicts these points, that later section should be revisited.
