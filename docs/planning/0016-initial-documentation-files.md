# 17. Initial Documentation Files

This section drafts the first repo-ready Markdown files.

The goal is not to create final marketing copy. The goal is to create a strong source-of-truth documentation foundation that future Monad commands can validate.

---

## 17.1 `README.md`

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
.monad/         local Monad state/cache/context
````

If `monad.toml` and `workspace.toml` conflict, `monad.toml` wins.

## Early Command Surface

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

Future mutating commands must be plan-backed.

## Safety Model

Monad should not silently mutate repositories.

Risky operations should go through:

```bash
monad plan ...
monad apply plan.json --dry-run
monad apply plan.json --yes
```

## AI Model

Monad is AI-ready but AI-optional.

AI tools may consume Monad-generated context packs and handoffs, but Monad must remain useful without any AI provider.

No command should require OpenAI, Anthropic, local LLMs, Cursor, Copilot, or any hosted model to provide core value.

## Documentation

Start here:

* `docs/index.md`
* `docs/product/charter.md`
* `docs/product/prd.md`
* `docs/architecture/overview.md`
* `docs/roadmap/roadmap.md`
* `docs/engineering/testing-strategy.md`
* `docs/security/security-model.md`
* `docs/governance/governance-model.md`

## Development

Run:

```bash
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
```

## License

TBD.

````

---

## 17.2 `docs/index.md`

```markdown id="5cp4d4"
# Monad Documentation

This directory is the source-of-truth documentation space for Monad OS and Monad CLI.

Monad is a local-first SDLC control plane and monorepo operating system that makes software repositories self-describing, governable, inspectable, AI-ready, and safely evolvable.

## Documentation Map

## Product

- `product/charter.md` — product charter
- `product/prd.md` — product requirements document
- `product/positioning.md` — product category and messaging
- `product/personas.md` — target users and customers
- `product/use-cases.md` — core use cases

## Architecture

- `architecture/overview.md` — system architecture overview
- `architecture/principles.md` — architecture principles
- `architecture/system-context.md` — system context model
- `architecture/data-architecture.md` — data architecture
- `architecture/ai-architecture.md` — AI-native but AI-optional model
- `architecture/security-architecture.md` — security architecture
- `architecture/decision-records/` — ADRs

## Roadmap

- `roadmap/roadmap.md` — product roadmap
- `roadmap/milestones.md` — milestone plan
- `roadmap/work-packets/` — implementation work packets

## Engineering

- `engineering/development-workflow.md` — local development workflow
- `engineering/testing-strategy.md` — test strategy
- `engineering/command-catalog.md` — command catalog documentation
- `engineering/output-formats.md` — CLI output format rules
- `engineering/release-process.md` — release process

## Security

- `security/security-model.md` — security model
- `security/threat-model.md` — threat model
- `security/secret-handling.md` — secret handling
- `security/supply-chain-security.md` — supply-chain security

## Operations

- `operations/operational-model.md` — operational model
- `operations/runbooks/` — operational runbooks

## Governance

- `governance/governance-model.md` — governance model
- `governance/adr-process.md` — ADR process
- `governance/work-packet-process.md` — work-packet process
- `governance/policy-process.md` — policy process
- `governance/release-governance.md` — release governance

## User Guide

- `user-guide/installation.md`
- `user-guide/getting-started.md`
- `user-guide/commands.md`
- `user-guide/configuration.md`
- `user-guide/context-handoff.md`

## Reference

- `reference/manifest.md`
- `reference/command-catalog.md`
- `reference/plan-schema.md`
- `reference/graph-schema.md`
- `reference/policy-schema.md`

## Documentation Principles

- Documentation is source-of-truth, not decoration.
- Significant architecture choices belong in ADRs.
- Significant work belongs in work packets.
- Generated docs must identify their source.
- Stale documentation should be detected by `monad docs check`.
````

---

## 17.3 `docs/product/charter.md`

```markdown id="gjcbfq"
# Product Charter: Monad OS / Monad CLI

## Product Name

Monad OS

## Runtime Name

`monad`

## Product Definition

Monad OS is a local-first SDLC control plane and monorepo operating system that turns software repositories into governed lifecycle graphs.

## Mission

Help developers and organizations understand, validate, document, govern, and safely evolve complex software repositories.

## Vision

A software repository should be self-describing, auditable, policy-aware, graphable, AI-ready, and safely evolvable.

Monad exists to make that possible through a deterministic local runtime.

## Problem Statement

Modern repositories contain code, docs, manifests, CI workflows, policies, ADRs, work packets, release notes, tests, architecture diagrams, and AI context scattered across disconnected tools and files.

This makes repositories difficult to understand, govern, maintain, and safely evolve.

AI-assisted development increases both the opportunity and the risk: assistants can move quickly, but they often lack a governed understanding of repository architecture, policies, current work, and source-of-truth constraints.

## Opportunity

Monad can define a new local-first SDLC control-plane category by connecting repository lifecycle artifacts into one governed model and exposing safe CLI workflows for inspection, validation, documentation, planning, and change.

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

## Non-Goals

Monad is not initially:

- a hosted SaaS-only platform,
- a mandatory AI agent,
- a replacement for native build tools,
- a generic project management app,
- a Kubernetes-first platform,
- or a required database-backed service.

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
```

---

## 17.4 `docs/product/prd.md`

```markdown id="8pmk9m"
# Product Requirements Document: Monad OS / Monad CLI

## Overview

Monad OS is a local-first SDLC control plane and monorepo operating system.

The first implementation is `monad`, a Rust CLI that helps users inspect, validate, document, graph, plan, and safely evolve repositories.

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
- multi-repo fleet governance.

## Functional Requirements

### FR-001: Version

`monad version` reports the CLI version.

### FR-002: Command Catalog

Monad maintains a command catalog with metadata for every known command.

### FR-003: List Commands

`monad list` lists implemented and planned commands.

### FR-004: Config

`monad config` and subcommands explain canonical configuration.

### FR-005: Inspect

`monad inspect` reports repository structure and detected artifacts.

### FR-006: Check

`monad check` validates baseline repository invariants.

### FR-007: Doctor

`monad doctor` reports diagnostics and remediation hints.

### FR-008: Graph

`monad graph` emits repository graph views.

### FR-009: Context Handoff

`monad context handoff` emits deterministic handoff context.

### FR-010: Docs Check

`monad docs check` validates documentation presence and consistency.

### FR-011: Plan

`monad plan` creates reviewable change plans.

### FR-012: Apply

`monad apply` applies plans only through controlled approval.

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
```

---

## 17.5 `docs/architecture/overview.md`

````markdown id="i9m4fx"
# Architecture Overview

## Summary

Monad uses a local-first modular Rust CLI architecture.

The executable is `monad`.

The architecture favors deterministic local operation, clean crate boundaries, plan-backed mutation, and future extensibility through packs, templates, policies, and optional plugins.

## Recommended Style

Monad combines:

- Clean Architecture,
- Hexagonal Architecture,
- Domain-Driven Design,
- command/query separation,
- documentation-as-code,
- policy-as-code,
- plan/apply mutation safety.

## Core Runtime

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
````

## Source of Truth

`monad.toml` is canonical.

`workspace.toml` is a compatibility mirror.

`monad.lock` records resolved state.

`.monad/` contains local runtime state, cache, and generated context.

## Mutation Model

Monad should not silently mutate repositories.

The mature flow is:

```bash
monad plan ...
monad apply plan.json --dry-run
monad apply plan.json --yes
```

## AI Model

Monad is AI-native but AI-optional.

AI may consume context packs and help explain plans, but deterministic Monad behavior must work without AI.

## Hosted Model

A hosted control plane may be added later, but it must be optional.

The local CLI must remain valuable without a cloud account, hosted backend, external database, or AI provider.

````

---

## 17.6 `docs/architecture/decision-records/index.md`

```markdown id="b1lkx5"
# Architecture Decision Records

This directory contains Architecture Decision Records for Monad OS and Monad CLI.

## ADR Format

Each ADR should include:

- Status
- Context
- Decision
- Consequences
- Alternatives Considered
- Follow-Up Actions

## ADR Index

| ADR | Title | Status |
|---|---|---|
| ADR-0001 | Rust Single-Binary Runtime | Accepted |
| ADR-0002 | Coordinate Native Tools Instead of Replacing Them | Accepted |
| ADR-0003 | Local-First Core | Accepted |
| ADR-0004 | AI-Native but AI-Optional | Accepted |
| ADR-0005 | Canonical Manifest is monad.toml | Accepted |
| ADR-0006 | Plan-Backed Mutation | Proposed |
| ADR-0007 | Modular Rust Workspace | Proposed |
| ADR-0008 | Lifecycle Graph as Core Model | Proposed |
| ADR-0009 | Documentation-as-Code | Proposed |
| ADR-0010 | Policy-as-Code | Proposed |
````

---

## 17.7 `docs/architecture/decision-records/adr-0001-rust-single-binary-runtime.md`

```markdown id="v25gpp"
# ADR-0001: Rust Single-Binary Runtime

## Status

Accepted

## Context

Monad is intended to be a local-first SDLC control plane and monorepo operating system.

The CLI must be fast, portable, deterministic, and suitable for serious developer workflows.

It should work without requiring a hosted backend, runtime server, package manager ecosystem, or language-specific project runtime.

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

Negative:

- Higher implementation complexity than simple scripting.
- Slower iteration than dynamic languages for some tasks.
- Requires Rust expertise.
- Plugin/extensibility model requires careful design.

## Alternatives Considered

### TypeScript/Node

Pros:

- Fast iteration.
- Large ecosystem.
- Good CLI libraries.

Cons:

- Runtime dependency.
- Slower startup.
- More supply-chain exposure.
- Less ideal for single-binary systems tooling.

### Go

Pros:

- Excellent single-binary distribution.
- Simple concurrency.
- Strong CLI suitability.

Cons:

- Less expressive domain modeling than Rust.
- Weaker compile-time safety for some invariants.

### Python

Pros:

- Fast prototyping.
- Rich ecosystem.

Cons:

- Runtime dependency.
- Packaging complexity.
- Slower.
- Less ideal for serious single-binary tooling.

## Follow-Up Actions

- Maintain a Rust workspace.
- Keep CLI and core domain models separated.
- Add contract tests for command behavior.
- Add release packaging later.
```

---

## 17.8 `docs/engineering/testing-strategy.md`

````markdown id="7l9suk"
# Testing Strategy

## Testing Philosophy

Monad must be test-backed because it intends to inspect, validate, document, plan, and eventually mutate repositories.

If Monad claims a repository is valid, invalid, safe, unsafe, documented, undocumented, or ready to mutate, that behavior must be tested.

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
````

## Command Catalog Contract

The command catalog and Clap command tree must not drift.

Required tests:

* Every catalog command intended for CLI exposure exists in Clap.
* Every Clap command is known to the catalog or intentionally excluded.
* Planned commands are marked as planned.
* Mutating commands declare mutation status.
* Placeholder commands are honest.

## Read-Only Safety

Read-only commands must not create, modify, or delete files.

Examples:

* `monad inspect`
* `monad check`
* `monad doctor`
* `monad list`
* `monad graph`
* `monad config`

## Mutation Safety

Mutating commands must eventually use:

```bash
monad plan ...
monad apply plan.json --dry-run
monad apply plan.json --yes
```

Tests must prove that dry-run does not write files and apply writes only planned files.

## Definition of Done

A change is done when:

* implementation is complete,
* tests pass,
* command catalog is updated,
* docs are updated,
* ADRs are added if needed,
* work packet acceptance criteria are satisfied,
* safety constraints are preserved.

````

---

## 17.9 `docs/security/security-model.md`

```markdown id="ffgipj"
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
````

Monad should also support explicit context ignore rules.

## Mutation Safety

Risky operations must be plan-backed.

The mature workflow is:

```bash
monad plan ...
monad apply plan.json --dry-run
monad apply plan.json --yes
```

## AI Safety

AI is optional.

AI-generated suggestions must be converted into reviewable plans before mutation.

AI must not directly apply repository changes without explicit human approval.

## Supply Chain

Recommended controls:

* dependency auditing,
* SBOM generation,
* release checksums,
* signed artifacts later,
* plugin checksums,
* pack version pinning,
* policy bundle versioning.

````

---

## 17.10 `docs/operations/operational-model.md`

```markdown id="cqizrd"
# Operational Model

## Summary

Monad begins as a local-first CLI. Its operational model is intentionally simple.

Initial operation:

```text
developer machine
  -> monad binary
  -> local repository
````

No cloud account, hosted backend, database, Kubernetes cluster, or AI provider is required.

## Local Operations

Users run commands such as:

```bash
monad inspect
monad check
monad doctor
monad graph
monad context handoff
monad docs check
```

## CI Operations

In CI, Monad can eventually run:

```bash
monad check --ci
monad docs check --ci
monad policy check --ci
```

## Diagnostics

`monad doctor` should provide actionable diagnostics for:

* workspace detection,
* manifest conflicts,
* missing docs,
* command catalog drift,
* native tool availability,
* policy configuration.

## Incident Categories

Important incidents include:

* destructive mutation bug,
* secret leakage into context,
* broken release artifact,
* schema incompatibility,
* policy bypass,
* command catalog drift,
* malicious dependency.

## Runbooks

Runbooks should live under:

```text
docs/operations/runbooks/
```

Initial runbooks:

* workspace not detected,
* manifest conflict,
* command catalog mismatch,
* docs check failed,
* context export safety,
* plan apply failed.

````

---

## 17.11 `docs/roadmap/roadmap.md`

```markdown id="612mfs"
# Monad Roadmap

## Roadmap Principle

Monad should be built in strict, testable layers.

Read-only understanding comes before mutation.

Plan-backed mutation comes before large generators.

Deterministic behavior comes before AI assistance.

## Current Focus

The current focus is the Rust CLI foundation and command surface integrity.

## Milestones

## v0.1: CLI Foundation

- Rust workspace
- `monad` binary
- command catalog
- CLI contract tests
- placeholder honesty
- version/list/config basics

## v0.2: Repository Understanding

- workspace root detection
- `monad inspect`
- `monad check`
- `monad doctor`
- source-of-truth validation

## v0.3: Docs, Governance, and Context

- `monad docs check`
- `monad adr list`
- `monad workpacket list`
- `monad context handoff`
- deterministic context packs

## v0.4: Plan Engine

- plan schema
- plan creation
- dry-run apply
- apply reports
- rollback hints

## v0.5: Safe Generators

- docs generation
- ADR generation
- work-packet generation
- selected project generation through plan/apply

## v0.6: Policy Engine

- built-in policy rules
- policy explain
- policy waivers
- policy gates for plans

## v0.7: Packs and Templates

- pack metadata
- template metadata
- core pack
- pack install preview
- pack apply through plans

## v1.0: Stable Local Core

- stable local-first CLI
- stable manifest schema
- stable command catalog
- stable plan/dry-run/apply
- stable docs/governance/context workflows
- test-backed release process
````

---

## 17.12 `docs/governance/governance-model.md`

````markdown id="f52zmx"
# Governance Model

## Summary

Monad treats governance as part of normal software delivery.

Governance artifacts are not external bureaucracy. They are first-class lifecycle artifacts connected to code, docs, tests, policies, and plans.

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
````

## Work Packet Governance

Significant implementation work should be tracked through work packets.

Preferred hierarchy:

```text
Epic
  Work Packet
    Layer
      Task
```

## Policy Governance

Policies define repository rules.

Policy findings should include:

* policy ID,
* severity,
* message,
* affected path,
* remediation,
* waiver eligibility.

## Waiver Governance

Waivers must be explicit, justified, and preferably expiring.

A waiver should include:

* policy ID,
* reason,
* approver,
* expiration,
* related work packet,
* residual risk.

## Release Governance

A release should be gated by:

* tests,
* docs checks,
* policy checks,
* command catalog contract,
* changelog,
* release notes,
* risk review where appropriate.

````

---

## 17.13 `CONTRIBUTING.md`

```markdown id="bbsc4a"
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
````

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

## Documentation

Update documentation when behavior changes.

Significant decisions require ADRs.

Significant implementation work should map to a work packet.

## Pull Request Expectations

A pull request should include:

* clear summary,
* tests,
* documentation updates,
* risk notes,
* linked work packet where applicable,
* ADR update where applicable.

````

---

## 17.14 `SECURITY.md`

```markdown id="glwhri"
# Security Policy

## Security Philosophy

Monad is designed to be safe by default.

It should not silently mutate repositories, leak secrets, make unexpected network calls, or require AI/cloud services for core behavior.

## Reporting Security Issues

Please report security issues privately.

Do not open public issues for suspected vulnerabilities involving:

- secret leakage,
- destructive mutation,
- unsafe plugin execution,
- supply-chain compromise,
- release artifact compromise,
- policy bypass,
- AI-assisted unsafe behavior.

## Security-Sensitive Areas

- context generation,
- plan/apply,
- plugin and pack installation,
- policy waivers,
- external tool execution,
- release artifacts,
- dependency management.

## Secret Handling

Monad context generation must exclude likely secret files and should support explicit ignore rules.

## Mutation Safety

Repository mutation should go through a plan/apply model.

Unsafe direct mutation is considered a product risk.
````

---

## 17.15 `SUPPORT.md`

````markdown id="lcxpgz"
# Support

Monad is currently in early development.

## Before Asking for Help

Please collect:

```bash
monad version
monad doctor
monad check
````

If available, include:

* operating system,
* Rust version,
* command run,
* expected behavior,
* actual behavior,
* relevant repository structure,
* whether the command was read-only, dry-run, or mutating.

Do not include secrets, private keys, `.env` files, credentials, or confidential source code.

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

````

---

## 17.16 `CODE_OF_CONDUCT.md`

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
- attempts to bypass security or governance controls.

## Enforcement

Maintainers may remove, reject, or block contributions that violate project standards or compromise project safety.
````
