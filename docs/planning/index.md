# Monad Planning Package Index

## Purpose

This directory contains the expanded planning package for Monad OS / Monad CLI.

The planning package is the source-of-truth foundation for Monad’s product definition, architecture strategy, governance model, roadmap, testing strategy, documentation structure, ADR set, and traceability model.

Monad is a local-first, governance-grade SDLC control plane and monorepo operating system. The first runtime surface is `monad`, a Rust single-binary CLI for understanding, validating, documenting, graphing, planning, and safely evolving serious software repositories.

This planning package exists to keep the project aligned before and during implementation.

---

## Status

This planning package is a living source-of-truth artifact.

It should be treated as:

```text
authoritative for product and architecture intent
authoritative for implementation sequencing
authoritative for current governance doctrine
not a claim that every described feature is already implemented
```

Individual sections may describe:

```text
current behavior
planned behavior
future behavior
non-goals
open questions
```

When implementation differs from planning intent, update the relevant planning document, ADR, roadmap, or work packet instead of allowing silent drift.

---

## Core Doctrine

All implementation work should preserve the following doctrine:

```text
Local-first before hosted.
Deterministic before AI.
Read-only understanding before mutation.
Plan-backed mutation before generators.
Source-of-truth rules before automation.
Command contracts before command depth.
Graph foundations before graph persistence.
Policy checks before policy enforcement.
Templates before plugins.
Solo-developer usability before enterprise extensibility.
```

Monad should remain:

```text
local-first
governance-grade
AI-ready but AI-optional
cloud-agnostic
database-agnostic
native-tool-coordinating
lifecycle-graph-centered
safe by default
honest about implemented versus planned behavior
```

---

## Source-of-Truth Rules

Monad’s repository source-of-truth model is:

```text
monad.toml      canonical Monad manifest
workspace.toml  compatibility mirror only
monad.lock      resolved state
.monad/         local generated/cache/context/report/plan state
```

If `monad.toml` and `workspace.toml` conflict, `monad.toml` wins.

`.monad/` must not become canonical truth.

---

## Planning Package Map

| Order | File                                                 | Section                                           | Purpose                                                                                                                                |
| ----: | ---------------------------------------------------- | ------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
|  0000 | `0000-product-understanding-and-assumptions.md`      | Product Understanding and Assumptions             | Captures the initial product framing, assumptions, constraints, and interpretation of Monad’s purpose.                                 |
|  0001 | `0001-executive-summary.md`                          | Executive Summary                                 | Summarizes Monad’s product thesis, strategy, architecture posture, and implementation direction.                                       |
|  0002 | `0002-product-charter.md`                            | Product Charter                                   | Defines product identity, mission, vision, users, jobs to be done, principles, and non-goals.                                          |
|  0003 | `0003-product-requirements-document.md`              | Product Requirements Document                     | Defines goals, functional requirements, non-functional requirements, safety requirements, and release criteria.                        |
|  0004 | `0004-domain-model-and-ddd-design.md`                | Domain Model and DDD Design                       | Defines bounded contexts, domain entities, aggregates, lifecycle concepts, and domain relationships.                                   |
|  0005 | `0005-architecture-strategy.md`                      | Architecture Strategy                             | Defines the architectural style, runtime architecture, local-first boundaries, and long-term modular direction.                        |
|  0006 | `0006-ai-architecture.md`                            | AI Architecture                                   | Defines Monad’s AI-native but AI-optional model, deterministic context-first posture, and AI safety boundaries.                        |
|  0007 | `0007-data-architecture.md`                          | Data Architecture                                 | Defines source-of-truth data, local state, future persistence boundaries, schemas, graph data, and generated artifacts.                |
|  0008 | `0008-api-and-integration-design.md`                 | API and Integration Design                        | Defines CLI interfaces, future APIs, native tool integrations, ports/adapters, and integration boundaries.                             |
|  0009 | `0009-security-privacy-compliance-governance.md`     | Security, Privacy, Compliance, and Governance     | Defines trust boundaries, security posture, privacy rules, compliance posture, and governance controls.                                |
|  0010 | `0010-infra-and-cloud-agnostic-deployment-plan.md`   | Infrastructure and Cloud-Agnostic Deployment Plan | Defines the infrastructure strategy, local-first deployment posture, and future optional hosted deployment path.                       |
|  0011 | `0011-observability-and-operations.md`               | Observability and Operations                      | Defines local observability, diagnostics, findings, reports, operations, runbooks, and future hosted observability.                    |
|  0012 | `0012-testing-strategy.md`                           | Testing Strategy                                  | Defines unit, integration, fixture, contract, snapshot, schema, mutation safety, security, BDD, and future AI tests.                   |
|  0013 | `0013-BDD-specification-set.md`                      | BDD Specification Set                             | Defines behavior-driven scenarios that turn product doctrine into executable product promises.                                         |
|  0014 | `0014-implementation-roadmap.md`                     | Implementation Roadmap                            | Defines maturity stages, version strategy, epics, work packets, layers, and near-term sequencing.                                      |
|  0015 | `0015-initial-repository-documentation-structure.md` | Initial Repository and Documentation Structure    | Defines the repo layout, docs layout, governance structure, policy structure, fixtures, examples, scripts, and `.monad/` boundary.     |
|  0016 | `0016-initial-documentation-files.md`                | Initial Documentation Files                       | Provides repo-ready Markdown drafts for initial README, docs, governance, security, operations, and contributor files.                 |
|  0017 | `0017-ADR-set.md`                                    | ADR Set                                           | Defines the initial architecture decision record set and decision governance model.                                                    |
|  0018 | `0018-traceability-matrix.md`                        | Traceability Matrix                               | Connects business goals, user needs, requirements, ADRs, components, work packets, tests, docs, policies, risks, and release evidence. |

---

## Recommended Reading Order

Read the package in this order:

1. `0001-executive-summary.md`
2. `0002-product-charter.md`
3. `0003-product-requirements-document.md`
4. `0004-domain-model-and-ddd-design.md`
5. `0005-architecture-strategy.md`
6. `0006-ai-architecture.md`
7. `0007-data-architecture.md`
8. `0008-api-and-integration-design.md`
9. `0009-security-privacy-compliance-governance.md`
10. `0010-infra-and-cloud-agnostic-deployment-plan.md`
11. `0011-observability-and-operations.md`
12. `0012-testing-strategy.md`
13. `0013-BDD-specification-set.md`
14. `0014-implementation-roadmap.md`
15. `0015-initial-repository-documentation-structure.md`
16. `0016-initial-documentation-files.md`
17. `0017-ADR-set.md`
18. `0018-traceability-matrix.md`

Use `0000-product-understanding-and-assumptions.md` as background context when reviewing earlier product assumptions.

---

## Implementation Guidance

The planning package should guide implementation in this order:

```text
1. Preserve source-of-truth rules.
2. Stabilize the Rust CLI foundation.
3. Protect the command catalog and CLI surface with contract tests.
4. Implement read-only repository understanding.
5. Add docs, ADR, work-packet, policy, and context lifecycle commands.
6. Add plan-backed mutation.
7. Add generators and packs only through the plan engine.
8. Add AI assistance only after deterministic context and plan safety exist.
9. Add hosted control-plane features only after local value is proven.
```

---

## Current Recommended Implementation Boundary

The current project should stop treating new feature work as bootstrap hotfixes.

Recommended boundary:

```text
Layer 0002: Rust workspace and CLI skeleton stabilization
Layer 0003: read-only lifecycle commands
Layer 0004: plan-backed repository mutation engine
```

Layer 0002 is complete when:

```text
Rust workspace compiles.
CLI library/binary split is stable.
Command catalog exists.
Clap command surface matches catalog.
Placeholders are honest.
Current smoke tests pass.
No mutating command performs unsafe writes.
```

Layer 0003 should focus on read-only or dry-run lifecycle commands:

```text
docs check
docs generate --dry-run
adr list
adr new --dry-run
adr supersede --dry-run
workpacket list
workpacket new --dry-run
workpacket plan
policy check
policy explain
template list
template inspect
plugin list
release plan --dry-run
context handoff
```

Layer 0004 should introduce the plan-backed mutation engine:

```text
plan schema
plan creation
dry-run apply
approved apply
file operation model
rollback hints
policy gate integration
```

Only after Layer 0004 should broad mutating commands become real mutators.

---

## Key Accepted ADRs

The ADR set currently establishes these accepted decisions:

```text
ADR-0001: Rust Single-Binary Runtime
ADR-0002: Coordinate Native Tools Instead of Replacing Them
ADR-0003: Local-First Core
ADR-0004: AI-Native but AI-Optional
ADR-0005: monad.toml Is the Canonical Manifest
ADR-0006: Plan-Backed Mutation
ADR-0012: Honest Placeholder Commands
```

Future work should not contradict accepted ADRs without creating a superseding ADR.

---

## Proposed ADRs to Refine During Implementation

The ADR set also proposes:

```text
ADR-0007: Modular Rust Workspace
ADR-0008: Lifecycle Graph as Core Model
ADR-0009: Documentation-as-Code
ADR-0010: Policy-as-Code
ADR-0011: Deterministic Context Before AI Assistance
```

These should guide implementation while remaining open to refinement as implementation pressure reveals better boundaries.

---

## Work Packet Hierarchy

Monad uses this implementation hierarchy:

```text
Epic
  Work Packet
    Layer
      Task
```

Every significant work packet should include:

```text
purpose
scope
out of scope
affected bounded contexts
inputs
outputs
dependencies
layers
tests
documentation updates
acceptance criteria
risks
rollback strategy
definition of done
```

---

## Epic Map

The roadmap defines these epics:

```text
EPIC-0001: Repository Foundation and Source of Truth
EPIC-0002: Command Surface and CLI Contracts
EPIC-0003: Read-Only Repository Understanding
EPIC-0004: Documentation, ADR, and Work-Packet Lifecycle
EPIC-0005: Context and AI-Safe Handoff
EPIC-0006: Plan-Backed Mutation Engine
EPIC-0007: Generators, Templates, and Packs
EPIC-0008: Policy Engine and Waivers
EPIC-0009: Native Tool Coordination
EPIC-0010: Release and Change Lifecycle
EPIC-0011: Advanced Graph and Query Layer
EPIC-0012: AI-Assisted but AI-Optional Workflows
EPIC-0013: Optional Hosted Control Plane
```

---

## Testing Expectations

All implementation work should preserve the testing doctrine:

> If Monad claims to understand, validate, document, graph, govern, plan, or mutate a repository, there must be tests proving that behavior.

Minimum local gate:

```bash
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
```

Recommended near-term stronger gate:

```bash
cargo clippy --workspace --all-targets -- -D warnings
cargo test -p monad-cli --test command_catalog_contract
```

Test categories include:

```text
unit tests
domain tests
fixture integration tests
CLI smoke tests
command contract tests
snapshot/golden tests
schema tests
property-based tests
mutation safety tests
security/privacy tests
BDD scenario tests
native tool integration tests
release tests
future AI evaluation tests
```

---

## Traceability Model

Monad’s traceability model connects:

```text
Business Goal
  -> User Need
    -> Product Requirement
      -> Architecture Decision
        -> Bounded Context / Component
          -> Work Packet
            -> Layer / Task
              -> Test Evidence
                -> Documentation
                  -> Release Evidence
```

Stable identifiers should be introduced and preserved for:

```text
business goals
user needs
functional requirements
non-functional requirements
ADRs
work packets
BDD scenarios
policies
findings
risks
release evidence
```

Future traceability commands may include:

```bash
monad trace check
monad trace graph
monad trace explain <requirement-id>
monad release readiness
```

---

## Documentation Validation Targets

Future `monad docs check` should eventually validate that:

```text
README.md exists.
docs/index.md exists.
docs/product/charter.md exists.
docs/product/prd.md exists.
docs/architecture/overview.md exists.
ADR index exists.
testing strategy exists.
security model exists.
operational model exists.
roadmap exists.
governance model exists.
planning index exists.
work-packet index exists.
source-of-truth rules are documented.
mutation safety model is documented.
planned behavior is not presented as implemented behavior.
```

Initial validation should likely report warnings before strict policy enforcement exists.

---

## How to Update This Planning Package

When updating planning docs:

1. Preserve section numbering.
2. Preserve filename ordering.
3. Update this index when files are added, renamed, deprecated, or superseded.
4. Update ADRs when architecture decisions change.
5. Update the roadmap when sequencing changes.
6. Update traceability when requirements, work packets, tests, or docs change.
7. Avoid presenting planned behavior as implemented behavior.
8. Prefer supersession over silent rewriting for major decisions.
9. Keep user-guide docs concise and planning docs detailed.
10. Keep hosted and AI features clearly marked as future unless implemented.

---

## Non-Goals of This Planning Package

This planning package is not:

```text
marketing copy
a complete user manual
a hosted SaaS specification
a claim that all features are implemented
a replacement for ADRs
a replacement for work packets
a replacement for tests
a replacement for release evidence
```

It is the source-of-truth planning foundation that guides those artifacts.

---

## Next Recommended Step After Planning

After the planning package is complete, the recommended next step is:

```text
Planning Package Consolidation and Execution Baseline
```

That work should:

1. Commit the completed planning package.
2. Normalize IDs across ADRs, requirements, work packets, BDD scenarios, policies, findings, risks, and evidence.
3. Materialize individual work-packet files for the active implementation group.
4. Confirm the Rust workspace and CLI command contract baseline are green.
5. Begin Layer 0003 read-only lifecycle commands.
6. Start with self-validating repository behavior, especially `monad docs check`.

---

## Final Rule

Monad’s planning package should be honest enough to trust, structured enough to validate, detailed enough to implement from, and disciplined enough to prevent the product from drifting away from its core doctrine.
