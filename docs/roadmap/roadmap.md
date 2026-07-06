# Monad Roadmap

## Purpose

This roadmap defines the implementation path for Monad OS / Monad CLI.

Monad is a local-first, governance-grade SDLC control plane and monorepo operating system. The first runtime surface is `monad`, a Rust single-binary CLI for understanding, validating, documenting, graphing, planning, and safely evolving serious software repositories.

The roadmap exists to keep implementation disciplined.

Monad’s vision is intentionally large, but the implementation must advance in small, testable, reversible layers.

---

## Roadmap Principle

Monad should be built in strict, testable layers.

Core sequencing rules:

```text
Local trust before hosted capability.
Read-only understanding before mutation.
Plan-backed mutation before generators.
Deterministic behavior before AI assistance.
Source-of-truth rules before automation.
Command contracts before command depth.
Graph foundations before graph persistence.
Policy checks before policy enforcement.
Templates before plugins.
Solo-developer usability before enterprise extensibility.
```

Monad should advance only through increments that preserve trust:

```text
compile
expose honestly
inspect safely
validate deterministically
document clearly
graph coherently
plan visibly
apply cautiously
extend safely
assist optionally
host only when local value is proven
```

---

## Current Product Status

Monad is in early foundation development.

The current focus is:

1. Rust workspace and CLI skeleton stabilization.
2. Command catalog integrity.
3. Clap command surface contract tests.
4. Honest placeholder command metadata.
5. Source-of-truth manifest rules.
6. Read-only repository understanding.
7. Documentation, ADR, work-packet, policy, and context lifecycle.
8. Plan-backed mutation later.

Commands may currently be:

```text
implemented
partially implemented
planned
placeholder
future
```

Planned and placeholder commands must be honest about their status.

---

## Source-of-Truth Rules

Monad uses:

```text
monad.toml      canonical Monad manifest
workspace.toml  compatibility mirror only
monad.lock      resolved state
.monad/         local generated/cache/context/report/plan state
```

If `monad.toml` and `workspace.toml` conflict, `monad.toml` wins.

`.monad/` must not become canonical truth.

---

## Product Maturity Sequence

Recommended maturity sequence:

```text
Stage 0: Repository foundation
Stage 1: CLI skeleton and command contracts
Stage 2: Read-only repository understanding
Stage 3: Documentation, ADR, and work-packet lifecycle
Stage 4: Plan-backed mutation engine
Stage 5: Generators, templates, and packs
Stage 6: Policy engine and waivers
Stage 7: Release/change lifecycle
Stage 8: Lifecycle graph persistence and querying
Stage 9: AI-assisted planning with human approval
Stage 10: Optional hosted/team control plane
```

Each stage should have clear entry criteria, exit criteria, tests, documentation updates, and rollback boundaries.

---

## Version Roadmap

```text
v0.1: CLI foundation and command catalog integrity
v0.2: Read-only repository inspection and validation
v0.3: Documentation, ADR, work-packet, and context lifecycle
v0.4: Plan model and dry-run apply
v0.5: Safe mutation for selected generators
v0.6: Policy engine and waivers
v0.7: Pack/template system
v0.8: Release/change lifecycle
v0.9: Lifecycle graph maturity and local indexing
v1.0: Stable local-first Monad OS core
v1.1: Advanced packs, policy bundles, and adapters
v1.2: AI-assisted planning and context governance
v2.0: Optional hosted/team/fleet control plane
```

---

# v0 Roadmap

## v0.1: CLI Foundation and Command Catalog Integrity

Purpose:

Prove that Monad is a real local CLI project with a trustworthy command surface.

Expected capabilities:

* Rust workspace compiles.
* `monad` binary exists.
* `monad version` works.
* `monad list` works.
* Command catalog exists.
* Clap command surface matches command catalog.
* Planned commands are clearly marked.
* Placeholder commands are honest.
* Mutating commands declare metadata.
* CLI smoke tests pass.
* Command contract tests pass.

Validation gate:

```bash
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
cargo test -p monad-cli --test command_catalog_contract
```

Primary work packets:

```text
WP-0001: Rust Workspace and CLI Foundation
WP-0004: Command Catalog Model
WP-0005: Clap Surface Contract
WP-0006: Placeholder Honesty and Command Metadata
WP-0007: CLI Output and Exit Code Standardization
```

Non-goals:

* Deep repository inspection.
* Policy engine.
* Plan/apply engine.
* AI integration.
* Hosted control plane.

---

## v0.2: Read-Only Repository Inspection and Validation

Purpose:

Prove that Monad can understand and validate a repository without changing it.

Expected capabilities:

* Workspace root detection.
* Canonical manifest detection.
* Compatibility mirror conflict reporting.
* Repository inspection.
* Native manifest detection.
* Baseline check engine.
* Doctor diagnostics.
* Lifecycle graph v0.
* Diff/drift detection v0.
* Text output.
* JSON output for key reports.
* Read-only safety tests.

Primary commands:

```bash
monad config
monad inspect
monad check
monad doctor
monad graph
monad diff
```

Primary work packets:

```text
WP-0002: Canonical Manifest and Workspace Model
WP-0008: Workspace Root Detection
WP-0009: Repository Inspection Engine
WP-0010: Baseline Check Engine
WP-0011: Doctor Diagnostics
WP-0012: Lifecycle Graph v0
WP-0013: Diff and Drift Detection v0
```

Non-goals:

* Real mutation.
* Generators.
* Plugin execution.
* AI planning.
* Hosted services.

---

## v0.3: Documentation, ADR, Work-Packet, and Context Lifecycle

Purpose:

Make repository lifecycle artifacts first-class and inspectable.

Expected capabilities:

* `monad docs check`
* `monad adr list`
* `monad adr validate`
* `monad adr new --dry-run`
* `monad adr supersede --dry-run`
* `monad workpacket list`
* `monad workpacket validate`
* `monad workpacket plan`
* `monad context handoff`
* deterministic context packs
* context redaction and safety
* context verification

Primary work packets:

```text
WP-0014: Docs Check
WP-0015: Docs Generate Preview
WP-0016: ADR List and Validation
WP-0017: ADR New and Supersede Dry-Run
WP-0018: Work Packet List and Validation
WP-0019: Work Packet Plan
WP-0020: Context Model
WP-0021: Handoff Generator
WP-0022: Context Pack Generator
WP-0023: Context Redaction and Safety
WP-0024: Context Verification
```

Non-goals:

* Direct docs mutation.
* AI-generated context as default.
* Hosted context sync.
* Autonomous work-packet implementation.

---

## v0.4: Plan Model and Dry-Run Apply

Purpose:

Introduce the safe mutation model before enabling broad mutation.

Expected capabilities:

* Plan schema.
* Plan domain model.
* Plan validation.
* File operation model.
* Plan creation for documentation/governance artifacts.
* Dry-run apply.
* No-write dry-run tests.
* Plan reports.
* Basic rollback hints.

Primary commands:

```bash
monad plan
monad apply --dry-run
```

Primary work packets:

```text
WP-0025: Plan Schema and Domain Model
WP-0026: Plan Creation for Documentation Artifacts
WP-0027: Dry-Run Apply Engine
WP-0029: Rollback Hints and Apply Reports
```

Non-goals:

* Broad approved mutation.
* Full generators.
* Pack install.
* AI-generated plans.
* Hosted approvals.

---

## v0.5: Safe Mutation for Selected Generators

Purpose:

Prove that selected repository changes can be applied safely through plan/apply.

Expected capabilities:

* Approved apply.
* Apply reports.
* Selected documentation generator applies.
* Selected ADR/work-packet artifact generation.
* File writes limited to planned operations.
* Unsafe mutation blocking.
* Deletion approval rules.
* Mutation safety tests.

Primary commands:

```bash
monad apply plan.json --yes
monad docs generate
monad adr new
monad workpacket new
```

Primary work packets:

```text
WP-0028: Apply Engine with Approval
WP-0029: Rollback Hints and Apply Reports
WP-0030: Plan Policy Evaluation
WP-0031: Template Metadata Model
WP-0032: Core Documentation Templates
WP-0033: Project Generator Foundation
```

Non-goals:

* Arbitrary project generation.
* Plugin marketplace.
* AI mutation.
* Unreviewed generation.

---

## v0.6: Policy Engine and Waivers

Purpose:

Make governance rules explicit, repeatable, explainable, and CI-ready.

Expected capabilities:

* Policy rule model.
* Built-in policy bundle.
* `monad policy check`
* `monad policy explain`
* Policy findings.
* Waiver model.
* Waiver expiration.
* Waiver audit.
* Plan policy gate integration.

Primary work packets:

```text
WP-0038: Policy Rule Model
WP-0039: Built-In Policy Bundle
WP-0040: Policy Check
WP-0041: Policy Explain
WP-0042: Policy Waiver Model
WP-0043: Waiver Expiration and Audit
WP-0030: Plan Policy Evaluation
```

Non-goals:

* Enterprise policy marketplace.
* Centralized policy server.
* Hosted compliance dashboard.
* OPA-only model from day one.

---

## v0.7: Packs and Templates

Purpose:

Introduce safe reusable repository templates and packs.

Expected capabilities:

* Template metadata.
* Core documentation templates.
* Pack metadata.
* Core pack.
* Pack install preview.
* Pack apply through plan engine.
* Template/pack fixture tests.
* Plan-backed generation.

Primary work packets:

```text
WP-0031: Template Metadata Model
WP-0032: Core Documentation Templates
WP-0033: Project Generator Foundation
WP-0034: Pack Metadata Model
WP-0035: Core Pack
WP-0036: Pack Install Preview
WP-0037: Pack Apply via Plan Engine
```

Non-goals:

* Arbitrary remote plugin execution.
* Hosted pack registry.
* Untrusted pack installation.
* Every framework generator.

---

## v0.8: Release and Change Lifecycle

Purpose:

Connect work packets, tests, policy, plans, docs, and release readiness.

Expected capabilities:

* Release plan.
* Release readiness check.
* Changelog generation.
* Versioning strategy.
* Release evidence report.
* Work-packet completion evidence.
* Policy status.
* Test status.
* Documentation status.

Primary work packets:

```text
WP-0050: Release Plan
WP-0051: Release Readiness Check
WP-0052: Changelog Generation
WP-0053: Versioning Strategy
WP-0054: Release Evidence Report
```

Non-goals:

* Hosted release dashboard.
* Multi-repository release orchestration.
* Fully automated publishing.
* Enterprise approval workflows.

---

## v0.9: Lifecycle Graph Maturity and Local Indexing

Purpose:

Mature the lifecycle graph into a stable local product asset.

Expected capabilities:

* Graph node/edge schema.
* Graph JSON export.
* Graph Mermaid export.
* Graph DOT export.
* Graph query v0.
* Local graph cache if needed.
* Graph consistency checks.
* Graph drift checks.
* Graph evidence for release readiness.

Primary work packets:

```text
WP-0055: Graph Node/Edge Schema
WP-0056: Graph Export JSON
WP-0057: Graph Export Mermaid and DOT
WP-0058: Graph Query v0
WP-0059: Local Graph Cache
WP-0060: Graph Consistency Checks
```

Non-goals:

* Graph database.
* Hosted graph explorer.
* Local daemon.
* Real-time graph updates.

---

# v1 Roadmap

## v1.0: Stable Local-First Monad OS Core

Purpose:

Deliver a stable local-first governance-grade CLI that proves Monad’s core thesis.

A credible v1 should include:

* stable CLI command surface,
* canonical manifest model,
* command catalog contract tests,
* read-only repository inspection,
* baseline policy checks,
* docs check,
* ADR lifecycle support,
* work-packet lifecycle support,
* deterministic context handoff,
* graph generation,
* plan model,
* dry-run apply,
* safe apply for selected operations,
* template/generator foundation,
* pack metadata foundation,
* machine-readable JSON outputs,
* repo-ready documentation,
* governance documentation,
* security model,
* testing strategy,
* release process.

v1 product promise:

```text
Monad helps me understand, validate, document, graph, govern, and safely evolve my repository from the command line without requiring a hosted service or AI provider.
```

v1 should be judged by trust, not feature count.

---

## v1.1: Advanced Packs, Policy Bundles, and Adapters

Purpose:

Expand safe extensibility after the local core stabilizes.

Expected capabilities:

* more built-in packs,
* richer policy bundles,
* native tool adapters,
* CI adapters,
* documentation templates,
* governance templates,
* improved project generation through plan/apply,
* stronger fixture coverage.

Non-goals:

* unsafe plugin execution,
* hosted pack marketplace as a requirement,
* autonomous AI mutation.

---

## v1.2: AI-Assisted Planning and Context Governance

Purpose:

Add optional AI assistance while preserving deterministic behavior and human approval.

Expected capabilities:

* AI provider port,
* noop AI adapter,
* prompt template model,
* AI-assisted ADR drafting,
* AI-assisted plan explanation,
* AI-suggested plan candidates,
* AI safety and audit controls,
* context governance,
* deterministic policy gates for AI-suggested plans.

Primary work packets:

```text
WP-0061: AI Provider Port
WP-0062: Noop AI Adapter
WP-0063: Prompt Template Model
WP-0064: AI-Assisted ADR Drafting
WP-0065: AI-Assisted Plan Explanation
WP-0066: AI-Suggested Plan Creation
WP-0067: AI Safety and Audit Controls
```

Rules:

* AI must be optional.
* AI must not be required for core commands.
* AI suggestions must not apply automatically.
* AI suggestions should become reviewable plans.
* AI usage should be inspectable and auditable.

---

# v2 Roadmap

## v2.0: Optional Hosted/Team/Fleet Control Plane

Purpose:

Introduce optional team and fleet capabilities without weakening local-first operation.

Expected capabilities:

* hosted control-plane architecture,
* repository metadata sync,
* organization/team model,
* graph dashboard,
* policy compliance dashboard,
* release governance dashboard,
* hosted audit evidence.

Primary work packets:

```text
WP-0068: Hosted Control Plane Architecture
WP-0069: Repo Metadata Sync
WP-0070: Organization and Team Model
WP-0071: Graph Dashboard
WP-0072: Policy Compliance Dashboard
WP-0073: Release Governance Dashboard
WP-0074: Hosted Audit Evidence
```

Rules:

* hosted control plane must be optional,
* local CLI must remain useful offline,
* sync must be explicit,
* data upload must be controlled,
* hosted views should project local evidence rather than replace local truth.

---

# Epic Map

## EPIC-0001: Repository Foundation and Source of Truth

Purpose:

Create the foundational repository structure, documentation, governance surfaces, manifests, and source-of-truth rules.

Work packets:

```text
WP-0000: Product and Repository Foundation
WP-0001: Rust Workspace and CLI Foundation
WP-0002: Canonical Manifest and Workspace Model
WP-0003: Documentation and Governance Foundation
```

---

## EPIC-0002: Command Surface and CLI Contracts

Purpose:

Create a trustworthy CLI surface backed by a command catalog and contract tests.

Work packets:

```text
WP-0004: Command Catalog Model
WP-0005: Clap Surface Contract
WP-0006: Placeholder Honesty and Command Metadata
WP-0007: CLI Output and Exit Code Standardization
```

---

## EPIC-0003: Read-Only Repository Understanding

Purpose:

Make Monad able to inspect, validate, explain, and graph a repository without mutating it.

Work packets:

```text
WP-0008: Workspace Root Detection
WP-0009: Repository Inspection Engine
WP-0010: Baseline Check Engine
WP-0011: Doctor Diagnostics
WP-0012: Lifecycle Graph v0
WP-0013: Diff and Drift Detection v0
```

---

## EPIC-0004: Documentation, ADR, and Work-Packet Lifecycle

Purpose:

Make docs, ADRs, and work packets first-class lifecycle artifacts.

Work packets:

```text
WP-0014: Docs Check
WP-0015: Docs Generate Preview
WP-0016: ADR List and Validation
WP-0017: ADR New and Supersede Dry-Run
WP-0018: Work Packet List and Validation
WP-0019: Work Packet Plan
```

---

## EPIC-0005: Context and AI-Safe Handoff

Purpose:

Produce deterministic context packs and handoff summaries for humans and AI tools.

Work packets:

```text
WP-0020: Context Model
WP-0021: Handoff Generator
WP-0022: Context Pack Generator
WP-0023: Context Redaction and Safety
WP-0024: Context Verification
```

---

## EPIC-0006: Plan-Backed Mutation Engine

Purpose:

Create the plan/apply model that makes repository mutation safe, inspectable, and auditable.

Work packets:

```text
WP-0025: Plan Schema and Domain Model
WP-0026: Plan Creation for Documentation Artifacts
WP-0027: Dry-Run Apply Engine
WP-0028: Apply Engine with Approval
WP-0029: Rollback Hints and Apply Reports
WP-0030: Plan Policy Evaluation
```

---

## EPIC-0007: Generators, Templates, and Packs

Purpose:

Support safe generation of repo artifacts, apps, services, packages, docs, and governance files.

Work packets:

```text
WP-0031: Template Metadata Model
WP-0032: Core Documentation Templates
WP-0033: Project Generator Foundation
WP-0034: Pack Metadata Model
WP-0035: Core Pack
WP-0036: Pack Install Preview
WP-0037: Pack Apply via Plan Engine
```

---

## EPIC-0008: Policy Engine and Waivers

Purpose:

Support policy-as-code for repo structure, docs, governance, security, and architecture rules.

Work packets:

```text
WP-0038: Policy Rule Model
WP-0039: Built-In Policy Bundle
WP-0040: Policy Check
WP-0041: Policy Explain
WP-0042: Policy Waiver Model
WP-0043: Waiver Expiration and Audit
```

---

## EPIC-0009: Native Tool Coordination

Purpose:

Coordinate native tools without replacing them.

Work packets:

```text
WP-0044: Native Tool Detection
WP-0045: Cargo Adapter
WP-0046: Bun/Node Adapter
WP-0047: Moon/Turborepo Adapter
WP-0048: Git Adapter
WP-0049: CI Adapter Foundation
```

---

## EPIC-0010: Release and Change Lifecycle

Purpose:

Connect plans, work packets, tests, policy, and release readiness.

Work packets:

```text
WP-0050: Release Plan
WP-0051: Release Readiness Check
WP-0052: Changelog Generation
WP-0053: Versioning Strategy
WP-0054: Release Evidence Report
```

---

## EPIC-0011: Advanced Graph and Query Layer

Purpose:

Make the lifecycle graph more complete, queryable, and eventually cacheable.

Work packets:

```text
WP-0055: Graph Node/Edge Schema
WP-0056: Graph Export JSON
WP-0057: Graph Export Mermaid and DOT
WP-0058: Graph Query v0
WP-0059: Local Graph Cache
WP-0060: Graph Consistency Checks
```

---

## EPIC-0012: AI-Assisted but AI-Optional Workflows

Purpose:

Add optional AI assistance while preserving deterministic behavior and human approval.

Work packets:

```text
WP-0061: AI Provider Port
WP-0062: Noop AI Adapter
WP-0063: Prompt Template Model
WP-0064: AI-Assisted ADR Drafting
WP-0065: AI-Assisted Plan Explanation
WP-0066: AI-Suggested Plan Creation
WP-0067: AI Safety and Audit Controls
```

---

## EPIC-0013: Optional Hosted Control Plane

Purpose:

Add optional team/fleet features without weakening local-first operation.

Work packets:

```text
WP-0068: Hosted Control Plane Architecture
WP-0069: Repo Metadata Sync
WP-0070: Organization and Team Model
WP-0071: Graph Dashboard
WP-0072: Policy Compliance Dashboard
WP-0073: Release Governance Dashboard
WP-0074: Hosted Audit Evidence
```

---

# Current Implementation Boundary

The project should stop treating new feature work as bootstrap hotfixes.

Recommended boundary:

```text
Layer 0002: Rust workspace and CLI skeleton stabilization
Layer 0003: read-only lifecycle commands
Layer 0004: plan-backed repository mutation engine
```

## Layer 0002 Completion Criteria

Layer 0002 is complete when:

* Rust workspace compiles.
* CLI library/binary split is stable.
* Command catalog exists.
* Clap command surface matches catalog.
* Placeholders are honest.
* Current smoke tests pass.
* No mutating command performs unsafe writes.

Validation commands:

```bash
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
cargo test -p monad-cli --test command_catalog_contract
```

## Layer 0003 Entry Criteria

Layer 0003 can begin when:

* command catalog contract is green,
* known catalog commands are exposed,
* command placeholder behavior is stable,
* tests confirm catalog/CLI alignment,
* command metadata distinguishes read-only, dry-run, planned, and mutating behavior.

## Layer 0003 Scope

Layer 0003 should implement read-only or dry-run lifecycle commands:

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

Allowed behavior:

* read files,
* inspect repository state,
* emit findings,
* emit reports,
* emit previews,
* emit plans,
* write only explicitly requested generated output.

Disallowed behavior:

* silently creating source files,
* modifying canonical docs without a plan,
* deleting files,
* installing packs,
* executing untrusted plugins,
* calling AI providers by default,
* requiring network.

## Layer 0004 Scope

Layer 0004 should implement the plan-backed mutation engine:

```text
plan schema
plan creation
dry-run apply
approved apply
file operation model
rollback hints
policy gate integration
```

Only after Layer 0004 should broad mutating commands become real mutators:

```text
add
remove
rename
move
generate
sync
clean
migrate
upgrade
```

Even then, they should mutate through the plan/apply system.

---

# MVP Definition

The MVP should not be “generate every project type.”

The MVP should prove the core thesis:

> A local repository can describe itself, validate itself, explain itself, graph itself, document itself, and produce safe change plans.

MVP command loop:

```bash
monad version
monad list
monad config
monad inspect
monad check
monad doctor
monad graph
monad context handoff
monad docs check
monad plan
monad apply --dry-run
```

MVP success criteria:

* the repository can be inspected,
* source-of-truth rules can be validated,
* command surface is honest,
* docs/governance artifacts are discoverable,
* graph output exists,
* deterministic context handoff exists,
* plans can be previewed,
* dry-run writes nothing,
* core behavior works without AI,
* core behavior works without hosted services.

---

# v1 Non-Goals

v1 should not require:

* hosted backend,
* mandatory AI provider,
* required database,
* Kubernetes,
* enterprise SSO,
* real-time collaboration,
* autonomous agents,
* full plugin marketplace,
* full visual dashboard,
* multi-repo fleet governance.

v1 should also avoid:

* hidden telemetry,
* hidden network calls,
* unreviewed mutation,
* AI-authoritative behavior,
* arbitrary plugin execution,
* graph database dependency,
* local daemon requirement.

---

# Roadmap Governance

This roadmap is a living artifact.

Update it when:

* implementation discovers a false assumption,
* a work packet is too large,
* dependencies change,
* a risk becomes material,
* sequencing changes,
* a planned feature becomes unnecessary,
* or an ADR supersedes a roadmap assumption.

Major roadmap changes should be reflected in:

* ADRs when architectural,
* work packets when implementation-level,
* traceability matrix when requirements/evidence change,
* planning docs when product direction changes.

---

# Testing Expectations by Stage

| Stage    | Required Test Emphasis                                  |
| -------- | ------------------------------------------------------- |
| Stage 0  | Docs/structure checks later                             |
| Stage 1  | Unit, smoke, command contract                           |
| Stage 2  | Fixture integration, read-only safety, schema, snapshot |
| Stage 3  | Docs/ADR/work-packet fixtures, context safety           |
| Stage 4  | Plan schema, dry-run no-write, apply safety             |
| Stage 5  | Template/pack fixtures, plan-backed generation tests    |
| Stage 6  | Policy unit/fixture/schema tests, waiver tests          |
| Stage 7  | Release readiness fixtures, evidence report tests       |
| Stage 8  | Graph invariant, property, cache invalidation tests     |
| Stage 9  | Mocked AI evaluation tests, AI safety tests             |
| Stage 10 | Hosted integration/E2E tests, audit/security tests      |

No roadmap item should be considered complete without tests appropriate to its risk level.

---

# Documentation Expectations by Stage

| Stage    | Required Documentation                              |
| -------- | --------------------------------------------------- |
| Stage 0  | Product, architecture, governance foundation        |
| Stage 1  | CLI usage, command catalog, contributor setup       |
| Stage 2  | Manifest model, inspect/check/doctor/graph docs     |
| Stage 3  | Docs/ADR/work-packet/context lifecycle docs         |
| Stage 4  | Plan/apply safety model and schemas                 |
| Stage 5  | Template, generator, and pack documentation         |
| Stage 6  | Policy and waiver documentation                     |
| Stage 7  | Release lifecycle documentation                     |
| Stage 8  | Graph schema and query documentation                |
| Stage 9  | AI safety, context, prompt, and audit documentation |
| Stage 10 | Hosted architecture and operations documentation    |

Documentation is part of the deliverable, not a postscript.

---

# Roadmap Risks

## Scope Expansion Risk

Risk:

Monad’s large vision may cause too many features to be attempted before the core is stable.

Mitigation:

* enforce maturity stages,
* preserve v1 non-goals,
* keep work packets small,
* defer hosted, AI, and plugin work.

## Mutation Safety Risk

Risk:

Generators or commands may write files before plan/apply safety exists.

Mitigation:

* plan-backed-before-mutation rule,
* dry-run first,
* mutation safety tests,
* apply reports.

## Command Drift Risk

Risk:

Command catalog, CLI surface, docs, and tests may drift.

Mitigation:

* command contract tests,
* example command validation,
* placeholder honesty,
* docs checks.

## Roadmap Staleness Risk

Risk:

The roadmap may become outdated as implementation changes.

Mitigation:

* update work packets with implementation,
* treat roadmap as living artifact,
* add ADRs for major changes.

## AI Prematurity Risk

Risk:

AI features may be introduced before deterministic context, plans, and policy.

Mitigation:

* AI deferred until deterministic foundations exist,
* noop adapter first,
* no automatic apply,
* AI output classified as advisory or plan candidate.

## Hosted Prematurity Risk

Risk:

Hosted control plane may pull the product away from local CLI value.

Mitigation:

* hosted deferred to v2,
* local reports and evidence first,
* no hosted dependency for core commands.

---

# Roadmap Fitness Functions

The roadmap should be evaluated against these fitness functions.

1. Local-first remains true.
2. Read-only behavior precedes mutation.
3. Plan-backed mutation precedes generators.
4. AI remains optional.
5. Network remains explicit.
6. Command contracts stay green.
7. Source-of-truth rules remain stable.
8. Testing keeps pace with features.
9. Documentation keeps pace with features.
10. Hosted work is deferred.
11. Mutation is auditable.
12. Lifecycle graph matures incrementally.

---

# Immediate Next Steps

After the planning package is consolidated, the recommended next steps are:

1. Commit the completed planning package.
2. Normalize IDs across requirements, ADRs, work packets, BDD scenarios, policies, findings, risks, and evidence.
3. Materialize individual work-packet files for the active implementation group.
4. Confirm the Rust workspace and command contract baseline are green.
5. Move into Layer 0003 read-only lifecycle commands.
6. Start with self-validating repository behavior, especially `monad docs check`.

Recommended first Layer 0003 candidates:

```text
docs check
adr list
workpacket list
context handoff
policy check, initially lightweight
template list, metadata-only
release plan --dry-run
```

---

# Final Roadmap Rule

Monad should advance only through increments that preserve trust:

> compile, expose honestly, inspect safely, validate deterministically, document clearly, graph coherently, plan visibly, apply cautiously, extend safely, assist optionally, and host only when local value is proven.
