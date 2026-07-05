# 17. Initial Documentation Files

## 17.1 Purpose of This Section

This section drafts the first repo-ready Markdown files for Monad OS and Monad CLI.

The goal is not to create final marketing copy. The goal is to create a strong source-of-truth documentation foundation that future Monad commands can validate.

These files should help the repository explain:

* what Monad is,
* what Monad is not,
* what is implemented now,
* what is planned,
* what principles govern development,
* what safety constraints must be preserved,
* how contributors should work,
* how architectural decisions are recorded,
* how testing is expected to work,
* how security issues are handled,
* how operations and support should work,
* and how future roadmap/work-packet/governance commands can inspect the repository.

This section provides initial file content that can be saved directly into the repository.

---

## 17.2 Documentation File Principles

The initial documentation files should follow these principles.

### 17.2.1 Be Honest About Current Status

Monad is early-stage. Documentation should not imply that all planned commands, schemas, generators, policies, AI workflows, or hosted features are already implemented.

Use clear status language:

```text id="4xdvwf"
implemented
partially implemented
planned
future
non-goal
```

### 17.2.2 Preserve Local-First Doctrine

All initial documentation should reinforce:

* local-first before hosted,
* deterministic before AI,
* read-only before mutation,
* plan-backed before mutation,
* no network by default,
* no telemetry by default,
* no required database,
* no required AI provider,
* no required cloud account,
* native-tool coordination over replacement.

### 17.2.3 Treat Docs as Future Validation Targets

These files should be structured so future Monad commands can validate them.

Future commands may include:

```bash id="3qs79y"
monad docs check
monad adr list
monad workpacket list
monad policy check
monad context handoff
monad release readiness
```

Therefore, documentation should use stable headings, predictable paths, and clear file ownership.

### 17.2.4 Avoid Fake Completeness

Initial docs may mention future features, but they must not imply those features are finished.

For example, it is acceptable to say:

```text id="f2nyyl"
Future mutating commands must be plan-backed.
```

It is not acceptable to say:

```text id="2kz1fa"
Monad safely applies all repository mutations through a completed plan engine.
```

before the plan engine exists.

### 17.2.5 Prefer Repo-Ready Markdown

Each draft below is intended to be copied into the file path indicated by its heading.

Do not include the surrounding section prose inside the target files.

---

## 17.3 Initial Documentation File Manifest

Recommended initial files:

| File                                                                        | Purpose                          | Initial Maturity |
| --------------------------------------------------------------------------- | -------------------------------- | ---------------- |
| `README.md`                                                                 | Top-level project orientation    | Required now     |
| `docs/index.md`                                                             | Documentation map                | Required now     |
| `docs/product/charter.md`                                                   | Product charter                  | Required now     |
| `docs/product/prd.md`                                                       | Product requirements             | Required now     |
| `docs/architecture/overview.md`                                             | Architecture overview            | Required now     |
| `docs/architecture/decision-records/index.md`                               | ADR index                        | Required now     |
| `docs/architecture/decision-records/adr-0001-rust-single-binary-runtime.md` | First ADR                        | Required now     |
| `docs/engineering/testing-strategy.md`                                      | Engineering testing expectations | Required now     |
| `docs/security/security-model.md`                                           | Security model                   | Required now     |
| `docs/operations/operational-model.md`                                      | Operational model                | Required now     |
| `docs/roadmap/roadmap.md`                                                   | Roadmap summary                  | Required now     |
| `docs/governance/governance-model.md`                                       | Governance model                 | Required now     |
| `CONTRIBUTING.md`                                                           | Contributor guidance             | Required now     |
| `SECURITY.md`                                                               | Security reporting policy        | Required now     |
| `SUPPORT.md`                                                                | Support guidance                 | Required now     |
| `CODE_OF_CONDUCT.md`                                                        | Conduct expectations             | Required now     |

Optional near-term files:

| File                                     | Purpose                        |
| ---------------------------------------- | ------------------------------ |
| `docs/product/positioning.md`            | Product category and messaging |
| `docs/product/personas.md`               | Target users                   |
| `docs/product/use-cases.md`              | Use cases                      |
| `docs/engineering/command-catalog.md`    | Command catalog docs           |
| `docs/engineering/output-formats.md`     | Output format docs             |
| `docs/engineering/release-process.md`    | Release process                |
| `docs/security/threat-model.md`          | Threat model                   |
| `docs/security/secret-handling.md`       | Secret handling                |
| `docs/security/supply-chain-security.md` | Supply-chain security          |
| `docs/governance/adr-process.md`         | ADR process                    |
| `docs/governance/work-packet-process.md` | Work-packet process            |
| `docs/governance/policy-process.md`      | Policy process                 |
| `docs/governance/release-governance.md`  | Release governance             |
| `docs/reference/manifest.md`             | Manifest reference             |
| `docs/reference/command-catalog.md`      | Command catalog reference      |
| `docs/reference/findings.md`             | Finding model reference        |
| `docs/reference/exit-codes.md`           | Exit code reference            |

---

## 17.4 `README.md`

Save as:

```text id="n13nvw"
README.md
```

````markdown id="ey15yy"
# Monad OS / Monad CLI

Monad is a local-first, governance-grade SDLC control plane and monorepo operating system.

The first runtime surface is `monad`, a Rust single-binary CLI for understanding, validating, documenting, graphing, planning, and safely evolving serious software repositories.

## What Monad Is

Monad helps turn a repository from a loose folder of files into a governed, queryable, auditable lifecycle system.

It is designed to help developers and teams answer:

- What is this repository?
- What projects, packages, services, docs, policies, and lifecycle artifacts exist?
- What depends on what?
- What decisions shaped this system?
- What work packet is active?
- What policies apply?
- What docs are stale?
- What can safely change?
- What should an AI assistant know before helping?
- What plan would be applied before any mutation occurs?

## Product Thesis

Modern software delivery is fragmented across code, manifests, CI workflows, docs, ADRs, tickets, policies, release processes, and AI assistant context.

Monad provides a deterministic local control plane that connects these lifecycle artifacts and helps the repository explain itself.

## Core Principles

- Local-first
- AI-native but AI-optional
- Cloud-agnostic
- Database-agnostic
- Governance-grade
- Secure by design
- Observable by design
- Documentation-as-code
- Policy-as-code
- Plan-backed before mutation
- Native-tool coordination over replacement
- Deterministic before intelligent

## Current Status

Monad is currently in early foundation development.

The current focus is:

1. Rust workspace and CLI skeleton.
2. Command catalog and CLI contract tests.
3. Honest placeholder command metadata.
4. Read-only repository inspection and validation.
5. Documentation, ADR, work-packet, and context lifecycle.
6. Plan-backed mutation engine.

Commands may initially be implemented, read-only, preview-only, or placeholders.

Placeholder commands must be honest about their status.

## Canonical Source of Truth

Monad uses:

```text
monad.toml      canonical Monad manifest
workspace.toml  compatibility mirror only
monad.lock      resolved state
.monad/         local Monad state/cache/context/reports/plans
```

If `monad.toml` and `workspace.toml` conflict, `monad.toml` wins.

## Early Command Surface

The intended early command surface includes:

```bash
monad version
monad list
monad config
monad inspect
monad check
monad doctor
monad graph
monad diff
monad context handoff
monad docs check
monad plan
monad apply --dry-run
```

Not every command listed above is necessarily fully implemented yet.

Use:

```bash
monad list
```

to see implemented and planned command status.

## Safety Model

Monad should not silently mutate repositories.

Read-only commands should not create, modify, or delete canonical repository files.

Risky operations should eventually go through:

```bash
monad plan ...
monad apply plan.json --dry-run
monad apply plan.json --yes
```

Future mutating commands must be plan-backed unless a specific exception is documented and tested.

## AI Model

Monad is AI-ready but AI-optional.

AI tools may consume Monad-generated context packs and handoffs, but Monad must remain useful without any AI provider.

No command should require OpenAI, Anthropic, local LLMs, Cursor, Copilot, or any hosted model to provide core value.

AI-generated suggestions must not be applied automatically. They should become reviewable plans.

## Hosted Model

A hosted control plane may be added later for team and fleet workflows.

The local CLI must remain useful without:

- a cloud account,
- a hosted backend,
- an external database,
- Kubernetes,
- telemetry,
- or an AI provider.

## Documentation

Start here:

- `docs/index.md`
- `docs/product/charter.md`
- `docs/product/prd.md`
- `docs/architecture/overview.md`
- `docs/roadmap/roadmap.md`
- `docs/engineering/testing-strategy.md`
- `docs/security/security-model.md`
- `docs/governance/governance-model.md`

## Development

Run:

```bash
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
```

Optional stronger checks may include:

```bash
cargo clippy --workspace --all-targets -- -D warnings
```

## Repository Structure

Important paths:

```text
crates/       Rust source crates
docs/         documentation
governance/   governance artifacts
policies/     policy artifacts
fixtures/     test fixture repositories
examples/     user-facing examples
.monad/       local Monad state, cache, context, reports, and plans
```

## License

TBD.
````

---

## 17.5 `docs/index.md`

Save as:

```text id="5vp9ro"
docs/index.md
```

````markdown id="5cp4d4"
# Monad Documentation

This directory is the source-of-truth documentation space for Monad OS and Monad CLI.

Monad is a local-first SDLC control plane and monorepo operating system that makes software repositories self-describing, governable, inspectable, AI-ready, and safely evolvable.

## Documentation Status

Monad is currently in early foundation development.

Some documents describe implemented behavior. Others describe planned or future behavior. Documents should clearly distinguish current behavior from planned behavior when there is a risk of confusion.

## Documentation Map

### Product

- `product/charter.md` — product charter
- `product/prd.md` — product requirements document
- `product/positioning.md` — product category and messaging
- `product/personas.md` — target users and customers
- `product/use-cases.md` — core use cases

### Architecture

- `architecture/overview.md` — system architecture overview
- `architecture/principles.md` — architecture principles
- `architecture/system-context.md` — system context model
- `architecture/data-architecture.md` — data architecture
- `architecture/ai-architecture.md` — AI-native but AI-optional model
- `architecture/security-architecture.md` — security architecture
- `architecture/decision-records/` — architecture decision records

### Planning

- `planning/` — expanded planning package and product/architecture source-of-truth documentation

### Roadmap

- `roadmap/roadmap.md` — product roadmap
- `roadmap/milestones.md` — milestone plan
- `roadmap/work-packets/` — implementation work packets

### Engineering

- `engineering/development-workflow.md` — local development workflow
- `engineering/testing-strategy.md` — test strategy
- `engineering/command-catalog.md` — command catalog documentation
- `engineering/output-formats.md` — CLI output format rules
- `engineering/release-process.md` — release process

### Security

- `security/security-model.md` — security model
- `security/threat-model.md` — threat model
- `security/secret-handling.md` — secret handling
- `security/supply-chain-security.md` — supply-chain security

### Operations

- `operations/operational-model.md` — operational model
- `operations/runbooks/` — operational runbooks

### Governance

- `governance/governance-model.md` — governance model
- `governance/adr-process.md` — ADR process
- `governance/work-packet-process.md` — work-packet process
- `governance/policy-process.md` — policy process
- `governance/release-governance.md` — release governance

### User Guide

- `user-guide/installation.md`
- `user-guide/getting-started.md`
- `user-guide/commands.md`
- `user-guide/configuration.md`
- `user-guide/context-handoff.md`

### Reference

- `reference/manifest.md`
- `reference/command-catalog.md`
- `reference/findings.md`
- `reference/exit-codes.md`
- `reference/plan-schema.md`
- `reference/graph-schema.md`
- `reference/policy-schema.md`

## Documentation Principles

- Documentation is source-of-truth, not decoration.
- Significant architecture choices belong in ADRs.
- Significant work belongs in work packets.
- Generated docs must identify their source.
- Stale documentation should be detected by `monad docs check`.
- Planning documents may be more detailed than user-guide documents.
- User-guide documents should stay practical and concise.
- Reference documents should be precise and version-aware.

## Future Validation

Future Monad commands should be able to validate this documentation structure.

Planned validation commands include:

```bash
monad docs check
monad adr list
monad workpacket list
monad policy check
monad release readiness
```
````

---

## 17.6 `docs/product/charter.md`

Save as:

```text id="9g8b0g"
docs/product/charter.md
```

```markdown id="gjcbfq"
# Product Charter: Monad OS / Monad CLI

## Product Name

Monad OS

## Runtime Name

`monad`

## Repository Name

`monad-cli`

## Product Definition

Monad OS is a local-first SDLC control plane and monorepo operating system that turns software repositories into governed lifecycle graphs.

The first executable product surface is `monad`, a Rust single-binary CLI.

## Mission

Help developers and organizations understand, validate, document, govern, and safely evolve complex software repositories.

## Vision

A software repository should be self-describing, auditable, policy-aware, graphable, AI-ready, and safely evolvable.

Monad exists to make that possible through a deterministic local runtime.

## Problem Statement

Modern repositories contain code, docs, manifests, CI workflows, policies, ADRs, work packets, release notes, tests, architecture diagrams, and AI context scattered across disconnected tools and files.

This makes repositories difficult to understand, govern, maintain, and safely evolve.

AI-assisted development increases both the opportunity and the risk. Assistants can move quickly, but they often lack a governed understanding of repository architecture, policies, current work, and source-of-truth constraints.

## Opportunity

Monad can define a new local-first SDLC control-plane category by connecting repository lifecycle artifacts into one governed model and exposing safe CLI workflows for inspection, validation, documentation, graphing, planning, and change.

## Target Users

- Solo developers building serious systems
- Platform engineers
- Staff and principal engineers
- Technical founders
- AI-assisted developers
- DevEx teams
- Architecture governance teams
- Security and compliance teams

## Core Jobs to Be Done

1. Understand a complex repository quickly.
2. Validate repository health and source-of-truth consistency.
3. Generate deterministic human/AI handoff context.
4. Plan repository changes before mutation.
5. Govern ADRs, work packets, policies, docs, and releases.
6. Coordinate native tools without replacing them.
7. Preserve repository safety while enabling evolution.

## Product Principles

- Local-first
- AI-native but AI-optional
- Cloud-agnostic
- Database-agnostic
- Deterministic before intelligent
- Plan-backed before mutation
- Explain before acting
- Coordinate native tools
- Govern without unnecessary bureaucracy
- Make lifecycle artifacts first-class

## Product Boundaries

Monad should coordinate and explain repository lifecycle behavior.

Monad should not unnecessarily replace tools that already do their jobs well.

Examples:

- Git remains responsible for version control.
- Cargo remains responsible for Rust builds.
- Bun, npm, pnpm, Moon, Turborepo, and other tools remain responsible for their native ecosystems.
- CI systems remain responsible for job execution.
- Monad should inspect, coordinate, validate, graph, and govern the relationships between these tools.

## Non-Goals

Monad is not initially:

- a hosted SaaS-only platform,
- a mandatory AI agent,
- a replacement for native build tools,
- a generic project management app,
- a Kubernetes-first platform,
- a required database-backed service,
- a telemetry-first developer tool,
- or an autonomous mutation engine.

## Success Criteria

Monad succeeds when a user can run the local CLI and reliably answer:

- What is in this repository?
- What is canonical?
- What commands exist?
- What policies apply?
- What docs or governance records are missing?
- What changed?
- What should be handed off to another developer or AI assistant?
- What would happen before a mutation is applied?
- What evidence remains after a plan or apply operation?

## Charter Rule

Monad should make repositories easier to understand, safer to evolve, and more governable without making local development dependent on a hosted service, AI provider, database, or cloud platform.
```

---

## 17.7 `docs/product/prd.md`

Save as:

```text id="4g2sls"
docs/product/prd.md
```

```markdown id="8pmk9m"
# Product Requirements Document: Monad OS / Monad CLI

## Overview

Monad OS is a local-first SDLC control plane and monorepo operating system.

The first implementation is `monad`, a Rust CLI that helps users inspect, validate, document, graph, plan, and safely evolve repositories.

## Product Goal

The goal of Monad is to make a repository self-describing, governable, inspectable, auditable, graphable, AI-ready, AI-optional, and safely evolvable.

## Goals

1. Provide a trustworthy local CLI.
2. Maintain a cataloged command surface.
3. Detect and explain repository structure.
4. Validate source-of-truth and governance rules.
5. Generate deterministic context handoffs.
6. Represent repository lifecycle artifacts as a graph.
7. Support plan-backed mutation.
8. Keep AI optional.
9. Keep cloud and database dependencies optional.
10. Coordinate native tools.

## Non-Goals

The early product will not provide:

- hosted control plane,
- mandatory AI provider,
- mandatory database,
- enterprise SSO,
- autonomous mutation,
- full plugin marketplace,
- visual dashboard,
- multi-repo fleet governance,
- Kubernetes-first deployment,
- hidden telemetry,
- hidden network calls.

## Functional Requirements

### FR-001: Version

`monad version` reports the CLI version.

Acceptance criteria:

- works outside a repository,
- exits successfully,
- does not require network,
- does not require AI configuration.

### FR-002: Command Catalog

Monad maintains a command catalog with metadata for every known command.

Acceptance criteria:

- commands have names,
- commands have categories,
- commands have implementation status,
- mutating commands declare mutation behavior,
- planned commands are clearly identified.

### FR-003: List Commands

`monad list` lists implemented and planned commands.

Acceptance criteria:

- implemented commands are visible,
- planned commands are marked,
- placeholder behavior is honest.

### FR-004: Config

`monad config` and subcommands explain canonical configuration.

Acceptance criteria:

- `monad.toml` is treated as canonical,
- `workspace.toml` is treated as compatibility mirror only,
- conflicts are reported.

### FR-005: Inspect

`monad inspect` reports repository structure and detected artifacts.

Acceptance criteria:

- reports workspace identity when known,
- reports detected project areas,
- reports native manifests,
- does not mutate files.

### FR-006: Check

`monad check` validates baseline repository invariants.

Acceptance criteria:

- valid repositories pass,
- invalid repositories emit findings,
- CI mode can fail on blocking issues.

### FR-007: Doctor

`monad doctor` reports diagnostics and remediation hints.

Acceptance criteria:

- reports actionable issues,
- includes remediation hints,
- reports optional missing tools without crashing.

### FR-008: Graph

`monad graph` emits repository graph views.

Acceptance criteria:

- supports text output early,
- supports Mermaid and JSON later,
- graph edges do not reference missing nodes.

### FR-009: Context Handoff

`monad context handoff` emits deterministic handoff context.

Acceptance criteria:

- works without AI,
- excludes known sensitive files by default,
- reports included and excluded context when possible.

### FR-010: Docs Check

`monad docs check` validates documentation presence and consistency.

Acceptance criteria:

- reports missing required docs,
- includes remediation hints,
- supports CI usage later.

### FR-011: Plan

`monad plan` creates reviewable change plans.

Acceptance criteria:

- no files are modified during plan creation,
- plan lists intended file operations,
- plan includes risks and schema version.

### FR-012: Apply

`monad apply` applies plans only through controlled approval.

Acceptance criteria:

- dry-run modifies no files,
- approved apply writes only planned files,
- apply produces an apply report,
- unsafe mutation is blocked.

## Non-Functional Requirements

- Local-first
- Deterministic
- Fast enough for everyday CLI use
- Safe by default
- No network by default
- No telemetry by default
- No AI dependency
- No required database
- Structured output support
- Test-backed command behavior
- Clear exit codes
- Machine-readable schemas over time
- Cross-platform design where practical
- Graceful degradation when optional tools are missing

## Safety Requirements

Monad must protect against:

- silent mutation,
- secret leakage,
- hidden network calls,
- hidden telemetry,
- unsafe plugin execution,
- AI suggestions applied without review,
- canonical source-of-truth confusion,
- generated state becoming hidden truth.

## Release Criteria

A release is acceptable only if:

- formatting passes,
- workspace check passes,
- tests pass,
- command catalog contract passes,
- implemented commands are documented,
- placeholder commands are honest,
- read-only commands do not mutate files,
- safety constraints are preserved.

## PRD Rule

Monad should not claim a capability as complete unless the command behavior, tests, documentation, and safety constraints support that claim.
```

---

## 17.8 `docs/architecture/overview.md`

Save as:

```text id="hhfjkk"
docs/architecture/overview.md
```

````markdown id="i9m4fx"
# Architecture Overview

## Summary

Monad uses a local-first modular Rust CLI architecture.

The executable is `monad`.

The architecture favors deterministic local operation, clean crate boundaries, plan-backed mutation, and future extensibility through packs, templates, policies, and optional plugins.

## Architectural Style

Monad combines:

- Clean Architecture,
- Hexagonal Architecture,
- Domain-Driven Design,
- command/query separation,
- documentation-as-code,
- policy-as-code,
- plan/apply mutation safety.

## Core Runtime

The intended long-term architecture is modular.

```text
monad-cli
  -> monad-core
  -> monad-config
  -> monad-inspect
  -> monad-graph
  -> monad-context
  -> monad-docs
  -> monad-policy
  -> monad-plans
  -> monad-packs
```

Not every module or crate needs to exist immediately.

Early Monad may start with:

```text
monad-cli
  -> monad-core
```

Additional crates should be extracted only when domain boundaries justify them.

## Source of Truth

`monad.toml` is canonical.

`workspace.toml` is a compatibility mirror.

`monad.lock` records resolved state.

`.monad/` contains local runtime state, cache, reports, plans, and generated context.

## Local-First Runtime Model

The default runtime model is:

```text
developer machine
  -> monad binary
  -> local repository
```

No hosted backend, database, Kubernetes cluster, cloud account, or AI provider is required for core CLI behavior.

## Command Model

Monad commands should declare whether they are:

- read-only,
- generated-artifact writers,
- plan creators,
- dry-run commands,
- mutating apply commands,
- network-enabled,
- AI-assisted.

Read-only commands must not mutate canonical repository files.

## Mutation Model

Monad should not silently mutate repositories.

The mature flow is:

```bash
monad plan ...
monad apply plan.json --dry-run
monad apply plan.json --yes
```

Generators, migrations, pack installs, and AI-suggested changes should eventually flow through the plan/apply model.

## Graph Model

Monad’s long-term moat is the lifecycle graph.

The graph should connect:

- workspace,
- projects,
- packages,
- docs,
- ADRs,
- work packets,
- policies,
- plans,
- tests,
- releases,
- context artifacts,
- native tool manifests.

The graph should begin as deterministic local output before it becomes cached, queryable, or hosted.

## AI Model

Monad is AI-native but AI-optional.

AI may consume context packs, help explain plans, or suggest changes, but deterministic Monad behavior must work without AI.

AI-generated suggestions must become reviewable plans before any mutation occurs.

## Hosted Model

A hosted control plane may be added later, but it must be optional.

The local CLI must remain valuable without:

- a cloud account,
- hosted backend,
- external database,
- AI provider,
- telemetry service,
- or browser dashboard.

## Architecture Rule

Monad’s architecture should make repository understanding deterministic, mutation reviewable, governance inspectable, and AI assistance optional.
````

---

## 17.9 `docs/architecture/decision-records/index.md`

Save as:

```text id="04tm8d"
docs/architecture/decision-records/index.md
```

```markdown id="b1lkx5"
# Architecture Decision Records

This directory contains Architecture Decision Records for Monad OS and Monad CLI.

ADRs capture significant architectural decisions, their context, alternatives, and consequences.

## ADR Format

Each ADR should include:

- Status
- Date
- Context
- Decision
- Consequences
- Alternatives Considered
- Follow-Up Actions

## ADR Statuses

Recommended statuses:

- Proposed
- Accepted
- Superseded
- Deprecated
- Rejected

## ADR Index

| ADR | Title | Status |
|---|---|---|
| ADR-0001 | Rust Single-Binary Runtime | Accepted |
| ADR-0002 | Coordinate Native Tools Instead of Replacing Them | Accepted |
| ADR-0003 | Local-First Core | Accepted |
| ADR-0004 | AI-Native but AI-Optional | Accepted |
| ADR-0005 | Canonical Manifest is `monad.toml` | Accepted |
| ADR-0006 | Plan-Backed Mutation | Proposed |
| ADR-0007 | Modular Rust Workspace | Proposed |
| ADR-0008 | Lifecycle Graph as Core Model | Proposed |
| ADR-0009 | Documentation-as-Code | Proposed |
| ADR-0010 | Policy-as-Code | Proposed |

## ADR Rules

- Significant architecture changes require ADRs.
- ADRs should not be rewritten silently after acceptance.
- Superseded ADRs should link to their successors.
- ADRs should reference related work packets when applicable.
- Future `monad adr list` should be able to read and validate this structure.
```

---

## 17.10 `docs/architecture/decision-records/adr-0001-rust-single-binary-runtime.md`

Save as:

```text id="0h6n2x"
docs/architecture/decision-records/adr-0001-rust-single-binary-runtime.md
```

```markdown id="v25gpp"
# ADR-0001: Rust Single-Binary Runtime

## Status

Accepted

## Date

TBD

## Context

Monad is intended to be a local-first SDLC control plane and monorepo operating system.

The CLI must be fast, portable, deterministic, and suitable for serious developer workflows.

It should work without requiring a hosted backend, runtime server, package manager ecosystem, cloud account, external database, or language-specific project runtime.

Monad also needs strong safety boundaries because it will eventually inspect, validate, document, plan, and mutate repositories.

## Decision

Monad will use Rust for the core CLI runtime and will distribute the primary executable as a single binary named `monad`.

## Consequences

Positive:

- Fast startup.
- Strong type safety.
- Good portability.
- Suitable for systems-grade tooling.
- Easier distribution as a single binary.
- Strong fit for deterministic local repository analysis.
- Strong fit for modeling safety invariants.
- Strong fit for command-line tools that need predictable behavior.

Negative:

- Higher implementation complexity than simple scripting.
- Slower iteration than dynamic languages for some tasks.
- Requires Rust expertise.
- Plugin/extensibility model requires careful design.
- Some ecosystem integrations may require more adapter work than in dynamic languages.

## Alternatives Considered

### TypeScript/Node

Pros:

- Fast iteration.
- Large ecosystem.
- Good CLI libraries.
- Natural fit for JavaScript/TypeScript monorepos.

Cons:

- Runtime dependency.
- Slower startup.
- More supply-chain exposure.
- Less ideal for single-binary systems tooling.
- More difficult to guarantee deterministic local behavior across environments.

### Go

Pros:

- Excellent single-binary distribution.
- Simple concurrency.
- Strong CLI suitability.
- Fast builds.

Cons:

- Less expressive domain modeling than Rust.
- Weaker compile-time safety for some invariants.
- Less precise ownership/control for certain safety-sensitive internals.

### Python

Pros:

- Fast prototyping.
- Rich ecosystem.
- Strong scripting ergonomics.

Cons:

- Runtime dependency.
- Packaging complexity.
- Slower startup.
- Less ideal for serious single-binary tooling.
- Harder to distribute as a self-contained binary across platforms.

## Follow-Up Actions

- Maintain a Rust workspace.
- Keep CLI and core domain models separated.
- Add contract tests for command behavior.
- Add release packaging later.
- Preserve AI and hosted integrations as optional boundaries.
- Avoid putting all domain logic directly in the CLI command layer.

## Related Principles

- Local-first
- Deterministic before intelligent
- Plan-backed before mutation
- Native-tool coordination over replacement
- Governance-grade repository lifecycle control
```

---

## 17.11 `docs/engineering/testing-strategy.md`

Save as:

```text id="k01ioj"
docs/engineering/testing-strategy.md
```

````markdown id="7l9suk"
# Testing Strategy

## Testing Philosophy

Monad must be test-backed because it intends to inspect, validate, document, graph, plan, and eventually mutate repositories.

If Monad claims a repository is valid, invalid, safe, unsafe, documented, undocumented, graphable, policy-compliant, or ready to mutate, that behavior must be tested.

## Test Categories

- Unit tests
- Integration tests
- CLI smoke tests
- Command catalog contract tests
- Fixture repository tests
- Snapshot tests
- Schema tests
- Security tests
- Mutation safety tests
- BDD tests
- Future AI evaluation tests

## Current Minimum Gate

```bash
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
```

## Stronger Near-Term Gate

```bash
cargo clippy --workspace --all-targets -- -D warnings
cargo test -p monad-cli --test command_catalog_contract
```

## Command Catalog Contract

The command catalog and Clap command tree must not drift.

Required tests:

- Every catalog command intended for CLI exposure exists in Clap.
- Every Clap command is known to the catalog or intentionally excluded.
- Planned commands are marked as planned.
- Mutating commands declare mutation status.
- Placeholder commands are honest.
- Command examples reference known commands.

## Read-Only Safety

Read-only commands must not create, modify, or delete canonical repository files.

Examples:

- `monad version`
- `monad list`
- `monad config`
- `monad inspect`
- `monad check`
- `monad doctor`
- `monad graph`

If a read-only command writes generated reports, that behavior must be explicit and limited to configured output paths.

## Fixture Testing

Repository-facing behavior should be tested against fixture repositories.

Example fixtures:

```text
fixtures/empty-repo/
fixtures/minimal-monad-repo/
fixtures/manifest-conflict-repo/
fixtures/rust-workspace/
fixtures/polyglot-workspace/
fixtures/docs-missing-repo/
fixtures/policy-violation-repo/
fixtures/context-secret-repo/
```

Fixtures must not contain real secrets.

## Mutation Safety

Mutating commands must eventually use:

```bash
monad plan ...
monad apply plan.json --dry-run
monad apply plan.json --yes
```

Tests must prove that:

- plan creation does not modify files,
- dry-run does not write files,
- apply writes only planned files,
- unsafe operations are blocked,
- deletion requires explicit approval,
- failed apply reports partial state.

## Security Testing

Security tests should cover:

- context secret exclusion,
- `.env` exclusion,
- private key redaction,
- no hidden network calls,
- no telemetry by default,
- plugin disabled by default,
- unsafe mutation blocking.

## BDD Testing

BDD scenarios should describe product behavior in user-visible terms.

Example:

```gherkin
Feature: Repository inspection safety

  Scenario: Inspect command is read-only
    Given a repository with tracked files
    When the user runs "monad inspect"
    Then no files are created
    And no files are modified
    And no files are deleted
```

## Future AI Evaluation Tests

AI is optional.

Early tests should prove deterministic AI-free behavior.

Future AI tests should use mocks, recorded responses, or deterministic fixtures rather than live providers by default.

## Definition of Done

A change is done when:

- implementation is complete,
- tests pass,
- command catalog is updated,
- docs are updated,
- ADRs are added if needed,
- work packet acceptance criteria are satisfied,
- safety constraints are preserved,
- CI is green.
````

---

## 17.12 `docs/security/security-model.md`

Save as:

```text id="ri8xu4"
docs/security/security-model.md
```

````markdown id="ffgipj"
# Security Model

## Summary

Monad is a local-first developer tool that reads repository files and may eventually mutate repository files through an explicit plan/apply process.

Security priorities:

- avoid destructive mutation,
- prevent secret leakage,
- avoid unexpected network calls,
- make generated context safe,
- ensure policy waivers are auditable,
- protect against unsafe plugins and packs,
- preserve supply-chain integrity.

## Security Principles

- Safe by default
- No network by default
- No telemetry by default
- No AI calls by default
- No mutation without plan or approval
- No secret inclusion in context by default
- No untrusted plugin execution by default
- No silent policy waivers
- No generated cache as source of truth

## Trust Boundaries

Important trust boundaries include:

- local repository files,
- `.monad/` generated state,
- native tool execution,
- context exports,
- plan/apply operations,
- future plugins,
- future packs,
- future AI providers,
- future hosted control plane.

## Secret Handling

Context generation must exclude likely secret files, including:

```text
.env
.env.*
*.pem
*.key
*.p12
*.pfx
id_rsa
id_ed25519
secrets.*
credentials.*
```

Monad should also support explicit context ignore rules.

## Context Safety

Context outputs may be used by humans, AI assistants, or future hosted services.

Context generation should:

- exclude secret files by default,
- report excluded sensitive files,
- avoid including binary files by default,
- avoid including large files without explicit configuration,
- produce a context manifest where feasible,
- work without AI.

## Mutation Safety

Risky operations must be plan-backed.

The mature workflow is:

```bash
monad plan ...
monad apply plan.json --dry-run
monad apply plan.json --yes
```

Direct mutation without plan visibility is a product risk.

## AI Safety

AI is optional.

AI-generated suggestions must be converted into reviewable plans before mutation.

AI must not directly apply repository changes without explicit human approval.

AI failure must not break deterministic commands such as `monad check`.

## Native Tool Safety

Monad coordinates native tools.

When invoking native tools, Monad should:

- make delegation visible,
- report tool availability,
- handle missing optional tools gracefully,
- avoid hiding tool failures,
- avoid passing secrets in command arguments.

## Supply Chain

Recommended controls:

- dependency auditing,
- SBOM generation,
- release checksums,
- signed artifacts later,
- plugin checksums,
- pack version pinning,
- policy bundle versioning.

## Security Incident Categories

Security-sensitive issues include:

- destructive mutation bug,
- secret leakage in context output,
- hidden network call,
- hidden telemetry,
- compromised dependency,
- compromised release artifact,
- incorrect policy pass,
- unsafe apply behavior.

## Security Rule

Monad should never trade local user trust for convenience. Hidden mutation, hidden network use, hidden telemetry, or hidden AI calls violate the product model.
````

---

## 17.13 `docs/operations/operational-model.md`

Save as:

```text id="a6ly3y"
docs/operations/operational-model.md
```

````markdown id="cqizrd"
# Operational Model

## Summary

Monad begins as a local-first CLI. Its operational model is intentionally simple.

Initial operation:

```text
developer machine
  -> monad binary
  -> local repository
```

No cloud account, hosted backend, database, Kubernetes cluster, or AI provider is required.

## Local Operations

Users run commands such as:

```bash
monad version
monad list
monad inspect
monad check
monad doctor
monad graph
monad context handoff
monad docs check
```

Local commands should explain what they did, what they found, and what the user can do next.

## CI Operations

In CI, Monad can eventually run:

```bash
monad check --ci
monad docs check --ci
monad policy check --ci
monad release readiness --ci
```

CI mode should be:

- non-interactive,
- deterministic,
- explicit about findings,
- strict about blocking issues,
- safe by default.

## Diagnostics

`monad doctor` should provide actionable diagnostics for:

- workspace detection,
- manifest conflicts,
- missing docs,
- command catalog drift,
- native tool availability,
- policy configuration,
- context export safety.

## Reports

Future Monad commands may write local reports under:

```text
.monad/reports/
```

Reports should be generated artifacts unless explicitly promoted to governance evidence.

## Incident Categories

Important incidents include:

- destructive mutation bug,
- secret leakage into context,
- broken release artifact,
- schema incompatibility,
- policy bypass,
- command catalog drift,
- malicious dependency,
- hidden network or telemetry behavior.

## Incident Response

For serious incidents:

1. Confirm the issue.
2. Identify affected versions.
3. Freeze or avoid affected release paths if needed.
4. Patch or revert.
5. Add regression tests.
6. Update documentation or runbooks.
7. Publish advisory if users may be affected.
8. Update the risk register if applicable.

## Runbooks

Runbooks should live under:

```text
docs/operations/runbooks/
```

Initial runbooks:

- workspace not detected,
- manifest conflict,
- command catalog mismatch,
- docs check failed,
- context export safety,
- plan apply failed.

## Hosted Operations

A hosted control plane may be added later.

Hosted operations may eventually require:

- logs,
- metrics,
- traces,
- dashboards,
- alerts,
- SLOs,
- incident response,
- audit logs.

Hosted operations are future optional capabilities and are not required for the local CLI.

## Operational Rule

Monad should be observable and diagnosable locally before it attempts hosted observability.
````

---

## 17.14 `docs/roadmap/roadmap.md`

Save as:

```text id="m4a50y"
docs/roadmap/roadmap.md
```

```markdown id="612mfs"
# Monad Roadmap

## Roadmap Principle

Monad should be built in strict, testable layers.

Read-only understanding comes before mutation.

Plan-backed mutation comes before large generators.

Deterministic behavior comes before AI assistance.

Local trust comes before hosted capability.

## Current Focus

The current focus is the Rust CLI foundation and command surface integrity.

Near-term work should stabilize:

- Rust workspace,
- `monad` binary,
- command catalog,
- Clap command surface,
- contract tests,
- placeholder honesty,
- read-only safety.

## Milestones

### v0.1: CLI Foundation

- Rust workspace
- `monad` binary
- command catalog
- CLI contract tests
- placeholder honesty
- version/list/config basics

### v0.2: Repository Understanding

- workspace root detection
- canonical manifest handling
- `monad inspect`
- `monad check`
- `monad doctor`
- source-of-truth validation
- read-only safety tests

### v0.3: Docs, Governance, and Context

- `monad docs check`
- `monad adr list`
- `monad workpacket list`
- `monad context handoff`
- deterministic context packs
- context redaction and safety

### v0.4: Plan Engine

- plan schema
- plan creation
- dry-run apply
- apply reports
- rollback hints

### v0.5: Safe Generators

- docs generation
- ADR generation
- work-packet generation
- selected project generation through plan/apply

### v0.6: Policy Engine

- built-in policy rules
- policy check
- policy explain
- policy waivers
- policy gates for plans

### v0.7: Packs and Templates

- pack metadata
- template metadata
- core pack
- pack install preview
- pack apply through plans

### v0.8: Release and Change Lifecycle

- release plan
- release readiness
- changelog generation
- versioning checks
- release evidence report

### v0.9: Lifecycle Graph Maturity

- graph schema
- graph JSON export
- graph Mermaid/DOT export
- graph query v0
- local graph cache if needed

### v1.0: Stable Local Core

- stable local-first CLI
- stable manifest schema
- stable command catalog
- stable plan/dry-run/apply for selected operations
- stable docs/governance/context workflows
- test-backed release process

### v1.2: AI-Assisted Planning

- AI provider port
- noop AI adapter
- prompt template model
- AI-assisted explanations
- AI-suggested plan candidates
- human approval and audit controls

### v2.0: Optional Hosted Control Plane

- hosted architecture
- repository metadata sync
- organization/team model
- graph dashboard
- policy dashboard
- release governance dashboard
- hosted audit evidence

## v1 Non-Goals

v1 should not require:

- hosted backend,
- mandatory AI provider,
- required database,
- Kubernetes,
- enterprise SSO,
- real-time collaboration,
- autonomous agents,
- full plugin marketplace,
- full visual dashboard,
- multi-repo fleet governance.

## Roadmap Rule

Monad should advance only through increments that preserve trust: compile, expose honestly, inspect safely, validate deterministically, document clearly, graph coherently, plan visibly, apply cautiously, extend safely, assist optionally, and host only when local value is proven.
```

---

## 17.15 `docs/governance/governance-model.md`

Save as:

```text id="iiiwg9"
docs/governance/governance-model.md
```

````markdown id="f52zmx"
# Governance Model

## Summary

Monad treats governance as part of normal software delivery.

Governance artifacts are not external bureaucracy. They are first-class lifecycle artifacts connected to code, docs, tests, policies, plans, and releases.

## Governance Artifacts

- ADRs
- Work packets
- Layers
- Policies
- Waivers
- Release plans
- Risk register
- Traceability matrix
- Apply reports
- Context handoffs

## ADR Governance

Significant architecture decisions require ADRs.

ADR lifecycle:

```text
draft -> proposed -> accepted -> superseded/deprecated
```

Each ADR should include:

- context,
- decision,
- consequences,
- alternatives considered,
- follow-up actions.

## Work Packet Governance

Significant implementation work should be tracked through work packets.

Preferred hierarchy:

```text
Epic
  Work Packet
    Layer
      Task
```

A work packet should include:

- purpose,
- scope,
- out of scope,
- affected bounded contexts,
- inputs,
- outputs,
- dependencies,
- layers,
- tests,
- documentation updates,
- acceptance criteria,
- risks,
- rollback strategy,
- definition of done.

## Policy Governance

Policies define repository rules.

Policy findings should include:

- policy ID,
- severity,
- message,
- affected path,
- remediation,
- waiver eligibility.

## Waiver Governance

Waivers must be explicit, justified, and preferably expiring.

A waiver should include:

- policy ID,
- reason,
- approver,
- expiration,
- related work packet,
- residual risk.

## Release Governance

A release should be gated by:

- tests,
- docs checks,
- policy checks,
- command catalog contract,
- changelog,
- release notes,
- risk review where appropriate.

## Traceability

Governance should connect:

```text
Requirement
  -> ADR
  -> Work Packet
  -> Test
  -> Policy
  -> Release Evidence
```

## Governance Rule

Monad governance should improve repository safety and clarity without creating unnecessary bureaucracy.
````

---

## 17.16 `CONTRIBUTING.md`

Save as:

```text id="sdj0xx"
CONTRIBUTING.md
```

````markdown id="bbsc4a"
# Contributing to Monad

Thank you for contributing to Monad.

Monad is a local-first SDLC control plane and monorepo operating system. Contributions should preserve its core principles:

- local-first operation,
- deterministic behavior,
- safety before mutation,
- command catalog honesty,
- documentation-as-code,
- policy-as-code,
- AI-optional design,
- native-tool coordination.

## Development Setup

Run:

```bash
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
```

Optional stronger check:

```bash
cargo clippy --workspace --all-targets -- -D warnings
```

## Command Contributions

When adding or changing a command:

1. Update the command catalog.
2. Update the Clap command tree.
3. Add or update command tests.
4. Add or update documentation.
5. Declare whether the command is mutating.
6. Declare whether it is plan-backed.
7. Declare whether it supports dry-run.
8. Ensure placeholder commands are honest.

## Mutating Commands

Do not add direct mutation behavior unless it is plan-backed or explicitly approved by the current roadmap.

Preferred future flow:

```bash
monad plan ...
monad apply plan.json --dry-run
monad apply plan.json --yes
```

Read-only commands must not create, modify, or delete canonical repository files.

## Documentation

Update documentation when behavior changes.

Significant decisions require ADRs.

Significant implementation work should map to a work packet.

## Tests

Contributions should include relevant tests.

Depending on the change, this may include:

- unit tests,
- CLI smoke tests,
- command catalog contract tests,
- fixture integration tests,
- snapshot tests,
- schema tests,
- mutation safety tests,
- security tests.

## Pull Request Expectations

A pull request should include:

- clear summary,
- tests,
- documentation updates,
- risk notes,
- linked work packet where applicable,
- ADR update where applicable,
- safety implications,
- whether behavior is read-only, dry-run, or mutating.

## Contribution Rule

A contribution should not expand Monad’s command surface, mutation power, AI behavior, or hosted assumptions without tests and documentation that preserve the project’s safety model.
````

---

## 17.17 `SECURITY.md`

Save as:

```text id="9hpn5j"
SECURITY.md
```

````markdown id="glwhri"
# Security Policy

## Security Philosophy

Monad is designed to be safe by default.

It should not silently mutate repositories, leak secrets, make unexpected network calls, emit hidden telemetry, or require AI/cloud services for core behavior.

## Reporting Security Issues

Please report security issues privately.

Do not open public issues for suspected vulnerabilities involving:

- secret leakage,
- destructive mutation,
- unsafe plugin execution,
- supply-chain compromise,
- release artifact compromise,
- policy bypass,
- AI-assisted unsafe behavior,
- hidden network calls,
- hidden telemetry.

## Security-Sensitive Areas

- context generation,
- plan/apply,
- plugin and pack installation,
- policy waivers,
- external tool execution,
- release artifacts,
- dependency management,
- AI provider integration,
- hosted sync, later.

## Secret Handling

Monad context generation must exclude likely secret files and should support explicit ignore rules.

Likely secret files include:

```text
.env
.env.*
*.pem
*.key
id_rsa
id_ed25519
credentials.*
secrets.*
```

## Mutation Safety

Repository mutation should go through a plan/apply model.

Unsafe direct mutation is considered a product risk.

## Network and Telemetry

Monad should not make network calls or send telemetry by default.

Any future network-enabled command should be explicit and documented.

## AI Safety

AI must be optional.

AI-generated output must not be applied automatically.

AI suggestions should become reviewable plans and should be checked by deterministic policy and safety controls.

## Supported Versions

Monad is in early development. Supported versions will be defined once release channels stabilize.

## Security Rule

If a behavior could expose secrets, mutate files, call external services, execute untrusted code, or affect release integrity, it must be explicit, documented, and test-backed.
````

---

## 17.18 `SUPPORT.md`

Save as:

```text id="w17ohd"
SUPPORT.md
```

````markdown id="lcxpgz"
# Support

Monad is currently in early development.

## Before Asking for Help

Please collect:

```bash
monad version
monad doctor
monad check
```

If available, include:

- operating system,
- Rust version,
- command run,
- expected behavior,
- actual behavior,
- relevant repository structure,
- whether the command was read-only, dry-run, or mutating.

## Do Not Share Secrets

Do not include:

- secrets,
- private keys,
- `.env` files,
- credentials,
- confidential source code,
- sensitive context packs,
- unredacted diagnostic bundles.

## Useful Diagnostic Commands

```bash
monad version
monad list
monad config
monad inspect
monad check
monad doctor
```

## Safety Reminder

Do not run mutating commands on important repositories unless you understand what they will change.

Prefer dry-run or plan-backed workflows.

Future preferred mutation flow:

```bash
monad plan ...
monad apply plan.json --dry-run
monad apply plan.json --yes
```

## Support Rule

Support requests should include enough context to reproduce the issue without exposing secrets or private repository contents.
````

---

## 17.19 `CODE_OF_CONDUCT.md`

Save as:

```text id="m407dz"
CODE_OF_CONDUCT.md
```

```markdown id="xy4i3v"
# Code of Conduct

## Our Standard

Monad aims to be a serious, respectful, technically rigorous project.

Participants are expected to:

- be respectful,
- assume good intent,
- critique ideas rather than people,
- document decisions,
- preserve safety and trust,
- avoid reckless changes,
- help maintain a high-quality engineering culture.

## Unacceptable Behavior

Unacceptable behavior includes:

- harassment,
- abusive language,
- intentional disruption,
- knowingly unsafe contributions,
- attempts to introduce malicious code,
- attempts to bypass security or governance controls,
- attempts to introduce hidden telemetry,
- attempts to introduce unsafe mutation behavior.

## Enforcement

Maintainers may remove, reject, or block contributions that violate project standards or compromise project safety.

## Project Culture

Monad values:

- technical rigor,
- clear documentation,
- safe defaults,
- honest status reporting,
- test-backed behavior,
- respectful collaboration,
- architecture discipline.

## Conduct Rule

Contributors should help make Monad safer, clearer, more trustworthy, and more useful.
```

---

## 17.20 Optional Near-Term File: `docs/engineering/development-workflow.md`

Save as:

```text id="qxncmd"
docs/engineering/development-workflow.md
```

````markdown id="xkyzs2"
# Development Workflow

## Summary

Monad development should be local-first, test-backed, and documentation-aware.

## Basic Workflow

Run:

```bash
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
```

Optional stronger checks:

```bash
cargo clippy --workspace --all-targets -- -D warnings
```

## Before Changing Commands

Check:

```bash
monad list
```

When changing commands:

1. Update the command catalog.
2. Update the Clap command tree.
3. Update tests.
4. Update docs.
5. Preserve placeholder honesty.
6. Declare mutation behavior.

## Before Adding Mutation

Do not add direct mutation casually.

Mutation should be:

- plan-backed,
- dry-runnable,
- approved,
- test-backed,
- report-producing.

## Before Adding Docs

Docs should have a clear owner and purpose.

Significant decisions should use ADRs.

Significant implementation work should use work packets.

## Development Rule

A change is not complete until implementation, tests, command metadata, and documentation agree.
````

---

## 17.21 Optional Near-Term File: `docs/reference/manifest.md`

Save as:

```text id="hvfkxn"
docs/reference/manifest.md
```

````markdown id="bvtdr0"
# Monad Manifest Reference

## Summary

`monad.toml` is the canonical Monad workspace manifest.

`workspace.toml` may exist as a compatibility mirror only.

`monad.lock` records resolved state.

## Canonical Manifest

The canonical manifest is:

```text
monad.toml
```

If `monad.toml` and `workspace.toml` conflict, `monad.toml` wins.

## Compatibility Mirror

`workspace.toml` is not canonical.

It exists only for compatibility with earlier tooling or transitional workflows.

## Example

```toml
[workspace]
name = "monad-cli"
type = "rust-cli"

[docs]
root = "docs"

[governance]
root = "governance"

[policies]
root = "policies"
```

## Future Schema

The manifest schema is pre-v1 and may change.

Future versions should include a schema version field when the format stabilizes.

## Manifest Rule

Repository intent belongs in `monad.toml`. Resolved state belongs in `monad.lock`. Generated local state belongs in `.monad/`.
````

---

## 17.22 Optional Near-Term File: `docs/reference/command-catalog.md`

Save as:

```text id="jh3u2o"
docs/reference/command-catalog.md
```

````markdown id="o1fhe5"
# Command Catalog Reference

## Summary

The command catalog describes known Monad commands and their metadata.

It should include both implemented and planned commands, while clearly distinguishing their status.

## Command Metadata

Each command should eventually declare:

- name,
- category,
- status,
- description,
- examples,
- whether it is read-only,
- whether it writes generated artifacts,
- whether it creates plans,
- whether it applies mutations,
- whether it uses network,
- whether it uses AI,
- whether it requires approval.

## Status Values

Recommended status values:

```text
implemented
partial
planned
placeholder
deprecated
```

## Mutation Metadata

Commands should be classified as:

```text
read-only
writes-generated-artifacts
plans-mutation
applies-mutation
external-network
external-tool-execution
ai-assisted
```

## Contract Rule

The command catalog and actual CLI surface must not drift.

Future contract tests should verify that catalog commands intended for CLI exposure are exposed by the Clap command tree.
````

---

## 17.23 Optional Near-Term File: `docs/reference/findings.md`

Save as:

```text id="9uqxho"
docs/reference/findings.md
```

````markdown id="sjmbuz"
# Findings Reference

## Summary

A finding is a structured observation produced by Monad.

Findings may describe missing files, invalid configuration, source-of-truth conflicts, policy violations, documentation gaps, context safety issues, or other repository lifecycle concerns.

## Severity

Recommended severities:

```text
info
warning
error
critical
```

## Finding Fields

A finding should eventually include:

- id,
- severity,
- title,
- message,
- path,
- category,
- remediation,
- policy ID if applicable,
- source command,
- source check.

## Example

```json
{
  "id": "MANIFEST-CANONICAL-CONFLICT",
  "severity": "warning",
  "title": "Compatibility mirror conflicts with canonical manifest",
  "message": "workspace.toml differs from monad.toml. monad.toml is canonical.",
  "path": "workspace.toml",
  "category": "configuration",
  "remediation": "Update workspace.toml to mirror monad.toml or remove the compatibility mirror."
}
```

## Findings Rule

Findings should be stable, actionable, and suitable for text output, JSON output, CI, docs, and future hosted reporting.
````

---

## 17.24 Optional Near-Term File: `docs/reference/exit-codes.md`

Save as:

```text id="3gdfr5"
docs/reference/exit-codes.md
```

````markdown id="mzadvw"
# Exit Codes Reference

## Summary

Monad should use stable exit codes so humans, scripts, and CI systems can understand command results.

The exit code model is pre-v1 and may evolve.

## Initial Exit Code Model

| Code | Meaning |
|---:|---|
| 0 | Success |
| 1 | Blocking findings or validation failure |
| 2 | Command usage error |
| 3 | Configuration or manifest error |
| 4 | Workspace detection error |
| 5 | Native tool failure |
| 6 | Plan validation or apply failure |
| 7 | Safety or security gate failure |
| 8 | Unsupported schema or version |
| 9 | Internal unexpected error |

## CI Behavior

CI mode should be non-interactive and should exit nonzero on blocking issues.

Example:

```bash
monad check --ci
```

## Exit Code Rule

Exit codes should be stable enough for automation and should be documented when command behavior changes.
````

---

## 17.25 Recommended Immediate Save Order

To apply these docs manually, save them in this order:

```text id="h6la7w"
README.md
docs/index.md
docs/product/charter.md
docs/product/prd.md
docs/architecture/overview.md
docs/architecture/decision-records/index.md
docs/architecture/decision-records/adr-0001-rust-single-binary-runtime.md
docs/engineering/testing-strategy.md
docs/security/security-model.md
docs/operations/operational-model.md
docs/roadmap/roadmap.md
docs/governance/governance-model.md
CONTRIBUTING.md
SECURITY.md
SUPPORT.md
CODE_OF_CONDUCT.md
```

Optional near-term files:

```text id="7j60yn"
docs/engineering/development-workflow.md
docs/reference/manifest.md
docs/reference/command-catalog.md
docs/reference/findings.md
docs/reference/exit-codes.md
```

---

## 17.26 Recommended Directory Creation Commands

If creating the docs manually, use explicit directory creation commands:

```bash id="z7upf4"
mkdir -p docs/product
mkdir -p docs/architecture/decision-records
mkdir -p docs/engineering
mkdir -p docs/security
mkdir -p docs/operations/runbooks
mkdir -p docs/roadmap/work-packets
mkdir -p docs/governance
mkdir -p docs/user-guide
mkdir -p docs/reference
```

Optional:

```bash id="b0gnf6"
mkdir -p governance
mkdir -p policies/core
mkdir -p policies/examples
mkdir -p fixtures
mkdir -p examples
mkdir -p scripts
mkdir -p .monad
```

Avoid fragile file-creation workflows if the terminal environment has trouble with heredocs.

Preferred manual workflow:

```text id="ovyvbr"
1. Create the target file.
2. Paste the file content.
3. Save it.
4. Run formatting/check commands.
5. Commit the result.
```

---

## 17.27 Documentation Validation Targets

Future `monad docs check` should eventually validate:

* `README.md` exists,
* `docs/index.md` exists,
* `docs/product/charter.md` exists,
* `docs/product/prd.md` exists,
* `docs/architecture/overview.md` exists,
* ADR index exists,
* at least one ADR exists,
* testing strategy exists,
* security model exists,
* operational model exists,
* roadmap exists,
* governance model exists,
* top-level `CONTRIBUTING.md` exists,
* top-level `SECURITY.md` exists,
* top-level `SUPPORT.md` exists,
* top-level `CODE_OF_CONDUCT.md` exists,
* docs do not claim planned commands are fully implemented,
* source-of-truth rules are documented,
* mutation safety model is documented.

Initial checks should probably be warnings rather than hard failures until policy configuration matures.

---

## 17.28 Documentation Risks

### 17.28.1 Overclaiming Risk

Risk:

Docs may describe planned behavior as if it already exists.

Mitigation:

* use current/planned/future language,
* keep `monad list` honest,
* update docs as commands mature.

### 17.28.2 Staleness Risk

Risk:

Docs may drift from implementation.

Mitigation:

* command catalog contract tests,
* future docs check,
* PR template requiring docs updates,
* work-packet acceptance criteria.

### 17.28.3 Planning Depth Versus User Clarity Risk

Risk:

Planning docs may be too long for ordinary users.

Mitigation:

* keep planning docs under `docs/planning/`,
* create concise user-guide docs separately,
* use `docs/index.md` to orient readers.

### 17.28.4 Security Disclosure Risk

Risk:

Support docs may encourage users to paste sensitive diagnostic information.

Mitigation:

* warn against sharing secrets,
* design diagnostic bundles to redact,
* document safe support practices.

---

## 17.29 Section Acceptance Criteria

This section is successful if a reader can:

1. Save the initial repo-ready Markdown files.
2. Understand where each file belongs.
3. Understand which files are required now and which are optional near-term.
4. See that documentation is treated as source-of-truth.
5. See that current, planned, and future behavior must be distinguished.
6. See that `monad.toml` is canonical.
7. See that `workspace.toml` is compatibility mirror only.
8. See that `monad.lock` is resolved state.
9. See that `.monad/` is local/generated/cache/context/report/plan state.
10. See that Monad is local-first, AI-optional, cloud-agnostic, and database-agnostic.
11. See that mutation must be plan-backed.
12. See that AI must not be required for core value.
13. See that docs are future validation targets for Monad itself.
14. See that testing, security, operations, roadmap, governance, and contributor docs are part of the foundation.
15. Avoid fragile terminal workflows when creating files manually.

The final documentation rule is:

> Monad’s first documentation files should be honest enough to trust now and structured enough for Monad to validate later.
