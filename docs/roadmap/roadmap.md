# Monad Roadmap

This roadmap defines the implementation path for Monad OS / Monad CLI.

Monad is a local-first, governance-grade SDLC control plane and monorepo operating system. The first runtime surface is `monad`, a Rust single-binary CLI for understanding, validating, documenting, graphing, planning, and safely evolving serious software repositories.

The roadmap exists to keep implementation disciplined. Monad's vision is intentionally large, but implementation must advance in small, testable, reversible layers.

## Companion Files

| File / Directory | Purpose |
| ---------------- | ------- |
| `docs/roadmap/index.md` | Roadmap navigation, doctrine, and version/stage overview. |
| `docs/roadmap/roadmap.md` | Canonical roadmap narrative and delivery sequence. |
| `docs/workpackets/` | Current materialized work-packet files. |
| `docs/governance/traceability-matrix.md` | Traceability across requirements, ADRs, work packets, tests, risks, policies, and evidence. |
| `docs/testing/bdd-index.md` | Behavior scenario registry. |
| `docs/reference/release-evidence.md` | Release evidence registry. |

## Roadmap Doctrine

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

Sequencing rules:

- local trust before hosted capability;
- read-only understanding before mutation;
- plan-backed mutation before generators;
- deterministic behavior before AI assistance;
- source-of-truth rules before automation;
- command contracts before command depth;
- graph foundations before graph persistence;
- policy checks before policy enforcement;
- templates before plugins.

## Source-of-Truth Rules

```text
monad.toml      canonical Monad manifest
workspace.toml  compatibility mirror only
monad.lock      resolved state
.monad/         local generated/cache/context/report/plan state
```

If `monad.toml` and `workspace.toml` conflict, `monad.toml` wins. `.monad/` must not become canonical truth.

Roadmap files do not override accepted ADRs. If roadmap direction conflicts with an accepted ADR, the ADR wins until superseded.

## Product Maturity Sequence

| Stage | Focus |
| ----: | ----- |
| 0 | Repository foundation. |
| 1 | CLI skeleton and command contracts. |
| 2 | Read-only repository understanding. |
| 3 | Documentation, ADR, work-packet, and context lifecycle. |
| 4 | Plan-backed mutation engine. |
| 5 | Generators, templates, and packs. |
| 6 | Policy engine and waivers. |
| 7 | Release/change lifecycle. |
| 8 | Lifecycle graph maturity and local indexing. |
| 9 | AI-assisted planning with human approval. |
| 10 | Optional hosted/team control plane. |

## Version Roadmap

| Version | Focus |
| ------- | ----- |
| v0.1 | CLI foundation and command catalog integrity. |
| v0.2 | Read-only repository inspection and validation. |
| v0.3 | Documentation, ADR, work-packet, and context lifecycle. |
| v0.4 | Plan model and dry-run apply. |
| v0.5 | Safe mutation for selected generators. |
| v0.6 | Policy engine and waivers. |
| v0.7 | Pack/template system. |
| v0.8 | Release/change lifecycle. |
| v0.9 | Lifecycle graph maturity and local indexing. |
| v1.0 | Stable local-first Monad OS core. |
| v1.1 | Advanced packs, policy bundles, and adapters. |
| v1.2 | AI-assisted planning and context governance. |
| v2.0 | Optional hosted/team/fleet control plane. |

# v0 Roadmap

## v0.1: CLI Foundation and Command Catalog Integrity

Purpose: prove that Monad is a real local CLI project with a trustworthy command surface.

Expected capabilities:

- Rust workspace compiles.
- `monad` binary exists.
- `monad version` works.
- `monad list` works.
- Command catalog exists.
- Clap command surface matches command catalog.
- Planned commands are clearly marked.
- Placeholder commands are honest.
- Mutating commands declare metadata.
- CLI smoke and command contract tests pass.

Validation gate:

```bash
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
cargo test -p monad-cli --test command_catalog_contract
```

Primary work packets: WP-0001, WP-0004, WP-0005, WP-0006, WP-0007.

## v0.2: Read-Only Repository Inspection and Validation

Purpose: prove that Monad can understand and validate a repository without changing it.

Expected capabilities:

- workspace root detection;
- canonical manifest detection;
- compatibility mirror conflict reporting;
- repository inspection;
- native manifest detection;
- baseline check engine;
- doctor diagnostics;
- lifecycle graph v0;
- drift detection v0;
- text and JSON output;
- read-only safety tests.

Primary commands:

```bash
monad config
monad inspect
monad check
monad doctor
monad graph
monad diff
```

Primary work packets: WP-0002, WP-0008, WP-0009, WP-0010, WP-0011, WP-0012, WP-0013.

## v0.3: Documentation, ADR, Work-Packet, and Context Lifecycle

Purpose: make repository lifecycle artifacts first-class and inspectable.

Expected capabilities:

- `monad docs check`
- `monad adr list`
- `monad adr validate`
- `monad adr new --dry-run`
- `monad adr supersede --dry-run`
- `monad workpacket list`
- `monad workpacket validate`
- `monad workpacket plan`
- `monad context handoff`
- deterministic context packs
- context redaction and safety
- context verification

Primary work packets: WP-0014 through WP-0024.

## v0.4: Plan Model and Dry-Run Apply

Purpose: introduce the safe mutation model before enabling broad mutation.

Expected capabilities:

- plan schema;
- plan domain model;
- plan validation;
- file operation model;
- plan creation for documentation/governance artifacts;
- dry-run apply;
- no-write dry-run tests;
- plan reports;
- rollback hints.

Primary commands:

```bash
monad plan
monad apply --dry-run
```

Primary work packets: WP-0025, WP-0026, WP-0027, WP-0029.

## v0.5: Safe Mutation for Selected Generators

Purpose: prove that selected repository changes can be applied safely through plan/apply.

Expected capabilities:

- approved apply;
- apply reports;
- selected documentation generator applies;
- selected ADR/work-packet artifact generation;
- file writes limited to planned operations;
- mutation safety tests.

Primary work packets: WP-0028 through WP-0033.

## v0.6: Policy Engine and Waivers

Purpose: make governance rules explicit, repeatable, explainable, and CI-ready.

Expected capabilities:

- policy rule model;
- built-in policy bundle;
- `monad policy check`;
- `monad policy explain`;
- policy findings;
- waiver model;
- waiver expiration and audit;
- plan policy gate integration.

Primary work packets: WP-0038 through WP-0043, plus WP-0030.

## v0.7: Packs and Templates

Purpose: introduce safe reusable repository templates and packs.

Expected capabilities:

- template metadata;
- core documentation templates;
- pack metadata;
- core pack;
- pack install preview;
- pack apply through plan engine;
- fixture tests;
- plan-backed generation.

Primary work packets: WP-0031 through WP-0037.

## v0.8: Release and Change Lifecycle

Purpose: connect plans, work packets, tests, policy, and release readiness.

Expected capabilities:

- release plan;
- release readiness check;
- changelog generation;
- versioning strategy;
- release evidence report;
- work-packet completion evidence;
- policy, test, and documentation status.

Primary work packets: WP-0050 through WP-0054.

## v0.9: Lifecycle Graph Maturity and Local Indexing

Purpose: mature the lifecycle graph into a stable local product asset.

Expected capabilities:

- graph node/edge schema;
- graph JSON export;
- graph Mermaid export;
- graph DOT export;
- graph query v0;
- local graph cache if needed;
- graph consistency checks;
- graph evidence for release readiness.

Primary work packets: WP-0055 through WP-0060.

# v1 Roadmap

## v1.0: Stable Local-First Monad OS Core

Purpose: deliver a stable local-first governance-grade CLI that proves Monad's core thesis.

A credible v1 should include stable CLI surface, canonical manifest model, command catalog contract tests, read-only inspection, baseline policy checks, docs check, ADR/work-packet lifecycle support, deterministic context handoff, graph generation, plan model, dry-run apply, selected safe apply, template/generator foundation, pack metadata, machine-readable outputs, repo-ready docs, governance docs, security model, testing strategy, and release process.

v1 product promise:

```text
Monad helps me understand, validate, document, graph, govern, and safely evolve my repository from the command line without requiring a hosted service or AI provider.
```

v1 should be judged by trust, not feature count.

## v1.1: Advanced Packs, Policy Bundles, and Adapters

Purpose: expand safe extensibility after the local core stabilizes.

Expected capabilities include more built-in packs, richer policy bundles, native tool adapters, CI adapters, documentation/governance templates, improved project generation through plan/apply, and stronger fixture coverage.

## v1.2: AI-Assisted Planning and Context Governance

Purpose: add optional AI assistance while preserving deterministic behavior and human approval.

Expected capabilities:

- AI provider port;
- noop AI adapter;
- prompt template model;
- AI-assisted ADR drafting;
- AI-assisted plan explanation;
- AI-suggested plan candidates;
- AI safety and audit controls;
- context governance;
- deterministic policy gates for AI-suggested plans.

Primary work packets: WP-0061 through WP-0067.

Rules:

- AI must be optional.
- AI must not be required for core commands.
- AI suggestions must not apply automatically.
- AI suggestions should become reviewable plans.
- AI usage should be inspectable and auditable.

# v2 Roadmap

## v2.0: Optional Hosted/Team/Fleet Control Plane

Purpose: introduce optional team and fleet capabilities without weakening local-first operation.

Expected capabilities:

- hosted control-plane architecture;
- repository metadata sync;
- organization/team model;
- graph dashboard;
- policy compliance dashboard;
- release governance dashboard;
- hosted audit evidence.

Primary work packets: WP-0068 through WP-0074.

Rules:

- hosted control plane must be optional;
- local CLI must remain useful offline;
- sync must be explicit;
- data upload must be controlled;
- hosted views should project local evidence rather than replace local truth.

# Epic Map

| Epic | Purpose | Work Packets |
| ---- | ------- | ------------ |
| EPIC-0001 | Repository foundation and source of truth. | WP-0000 through WP-0003 |
| EPIC-0002 | Command surface and CLI contracts. | WP-0004 through WP-0007 |
| EPIC-0003 | Read-only repository understanding. | WP-0008 through WP-0013 |
| EPIC-0004 | Documentation, ADR, and work-packet lifecycle. | WP-0014 through WP-0019 |
| EPIC-0005 | Context and AI-safe handoff. | WP-0020 through WP-0024 |
| EPIC-0006 | Plan-backed mutation engine. | WP-0025 through WP-0030 |
| EPIC-0007 | Generators, templates, and packs. | WP-0031 through WP-0037 |
| EPIC-0008 | Policy engine and waivers. | WP-0038 through WP-0043 |
| EPIC-0009 | Native tool coordination. | WP-0044 through WP-0049 |
| EPIC-0010 | Release and change lifecycle. | WP-0050 through WP-0054 |
| EPIC-0011 | Advanced graph and query layer. | WP-0055 through WP-0060 |
| EPIC-0012 | AI-assisted but AI-optional workflows. | WP-0061 through WP-0067 |
| EPIC-0013 | Optional hosted control plane. | WP-0068 through WP-0074 |

# Current Implementation Boundary

Recommended boundary:

```text
Layer 0002: Rust workspace and CLI skeleton stabilization
Layer 0003: read-only lifecycle commands
Layer 0004: plan-backed repository mutation engine
```

Layer 0002 is complete when the Rust workspace compiles, the CLI library/binary split is stable, the command catalog exists, Clap command surface matches catalog, placeholders are honest, smoke tests pass, and no mutating command performs unplanned writes.

Layer 0003 can begin when command catalog contract is green, known catalog commands are exposed, placeholder behavior is stable, tests confirm catalog/CLI alignment, and command metadata distinguishes read-only, dry-run, planned, and mutating behavior.

Layer 0003 should implement read-only or dry-run lifecycle commands such as `docs check`, `adr list`, `workpacket list`, `context handoff`, lightweight `policy check`, metadata-only `template list`, and `release plan --dry-run`.

Layer 0004 should implement plan schema, plan creation, dry-run apply, approved apply, file operation model, rollback hints, and policy gate integration. Only after Layer 0004 should broad mutating commands become real mutators, and even then they should mutate through plan/apply.

# MVP Definition

The MVP should not be "generate every project type."

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

- repository inspection works;
- source-of-truth rules can be validated;
- command surface is honest;
- docs/governance artifacts are discoverable;
- graph output exists;
- deterministic context handoff exists;
- plans can be previewed;
- dry-run writes nothing;
- core behavior works without AI;
- core behavior works without hosted services.

# v1 Non-Goals

v1 should not require hosted backend, mandatory AI provider, required database, enterprise SSO, real-time collaboration, autonomous agents, full plugin marketplace, full visual dashboard, or multi-repo fleet governance.

v1 should also avoid hidden telemetry, hidden network calls, unreviewed mutation, AI-authoritative behavior, arbitrary plugin execution, graph database dependency, and local daemon requirement.

# Roadmap Governance

This roadmap is a living artifact.

Update it when implementation discovers a false assumption, a work packet is too large, dependencies change, a risk becomes material, sequencing changes, a planned feature becomes unnecessary, or an ADR supersedes a roadmap assumption.

Major roadmap changes should be reflected in ADRs when architectural, work packets when implementation-level, the traceability matrix when requirements/evidence change, and planning docs when product direction changes.

# Testing Expectations by Stage

| Stage | Required Test Emphasis |
| ----: | ---------------------- |
| 0 | Docs/structure checks later. |
| 1 | Unit, smoke, command contract. |
| 2 | Fixture integration, read-only safety, schema, snapshot. |
| 3 | Docs/ADR/work-packet fixtures, context safety. |
| 4 | Plan schema, dry-run no-write, apply safety. |
| 5 | Template/pack fixtures, plan-backed generation tests. |
| 6 | Policy unit/fixture/schema tests, waiver tests. |
| 7 | Release readiness fixtures, evidence report tests. |
| 8 | Graph invariant, property, cache invalidation tests. |
| 9 | Mocked AI evaluation tests, AI safety tests. |
| 10 | Hosted integration/E2E tests, audit/security tests. |

# Documentation Expectations by Stage

| Stage | Required Documentation |
| ----: | ---------------------- |
| 0 | Product, architecture, governance foundation. |
| 1 | CLI usage, command catalog, contributor setup. |
| 2 | Manifest model, inspect/check/doctor/graph docs. |
| 3 | Docs/ADR/work-packet/context lifecycle docs. |
| 4 | Plan/apply safety model and schemas. |
| 5 | Template, generator, and pack documentation. |
| 6 | Policy and waiver documentation. |
| 7 | Release lifecycle documentation. |
| 8 | Graph schema and query documentation. |
| 9 | AI safety, context, prompt, and audit documentation. |
| 10 | Hosted architecture and operations documentation. |

Documentation is part of the deliverable, not a postscript.

# Roadmap Risks

| Risk | Mitigation |
| ---- | ---------- |
| Scope expansion | Enforce maturity stages, preserve v1 non-goals, keep work packets small, defer hosted/AI/plugin work. |
| Mutation safety | Preserve plan-backed-before-mutation rule, dry-run first, mutation safety tests, and apply reports. |
| Command drift | Preserve command contract tests, placeholder honesty, and docs checks. |
| Roadmap staleness | Update work packets with implementation and add ADRs for major changes. |
| AI prematurity | Defer AI until deterministic context, plans, policy, and noop adapter exist. |
| Hosted prematurity | Defer hosted work to v2 and prove local reports/evidence first. |

# Roadmap Fitness Functions

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

# Immediate Next Steps

1. Keep `docs/roadmap/index.md` and this roadmap synchronized.
2. Normalize IDs across requirements, ADRs, work packets, BDD scenarios, policies, findings, risks, and evidence.
3. Continue maintaining work-packet files in `docs/workpackets/`.
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

# Final Roadmap Rule

Monad should advance only through increments that preserve trust:

> compile, expose honestly, inspect safely, validate deterministically, document clearly, graph coherently, plan visibly, apply cautiously, extend safely, assist optionally, and host only when local value is proven.
