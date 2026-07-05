# 15. Implementation Roadmap

## 15.1 Purpose of This Section

This section defines the implementation roadmap for Monad OS and Monad CLI.

Its purpose is to establish:

* the order in which Monad should be built,
* the maturity stages Monad should pass through,
* the relationship between versions, epics, work packets, layers, and tasks,
* what belongs in MVP, v1, v1.x, and v2,
* what should be deferred,
* how local-first trust should be built before hosted capability,
* how read-only understanding should precede mutation,
* how plan-backed mutation should precede generators,
* how deterministic behavior should precede AI assistance,
* and how current implementation work should be bounded so that the project remains small, testable, reversible, and coherent.

Monad’s product vision is intentionally large. The implementation strategy must not be.

The implementation roadmap exists to prevent Monad from becoming a pile of ambitious but disconnected features. Every phase should increase trust, reduce ambiguity, and preserve the product doctrine.

The most important roadmap rule is:

> Build the local, deterministic, read-only, test-backed control plane before building mutation, generation, AI assistance, or hosted infrastructure.

---

## 15.2 Roadmap Thesis

Monad’s roadmap thesis is:

> A repository lifecycle control plane must earn trust in layers: first by describing itself, then by validating itself, then by explaining itself, then by planning safe change, then by applying reviewed change, and only later by assisting with generation, policy, AI, and hosted team workflows.

This means Monad should not begin by trying to generate every app type, orchestrate every tool, or become a hosted SaaS platform.

The correct early sequence is:

```text id="xpm3fn"
1. Compile reliably.
2. Expose an honest command surface.
3. Detect and explain the repository.
4. Validate source-of-truth rules.
5. Emit structured findings.
6. Graph the lifecycle.
7. Generate deterministic handoffs.
8. Validate docs, ADRs, work packets, and policies.
9. Create reviewable plans.
10. Dry-run plans.
11. Apply approved plans safely.
12. Add templates and generators on top of the plan engine.
13. Add packs and policy bundles.
14. Add optional AI assistance.
15. Add optional hosted/team control plane.
```

This order matters.

If Monad builds generators before plans, mutation will be unsafe.

If Monad builds AI before deterministic context and policy, AI will be untrustworthy.

If Monad builds hosted infrastructure before local trust, the product will become operationally expensive before it proves its core value.

If Monad builds command depth before command contracts, the CLI will drift.

---

## 15.3 Roadmap Principles

Monad should be built according to the following roadmap principles.

### 15.3.1 Local Trust Before Hosted Capability

The local CLI must become valuable before any hosted control plane.

Hosted capabilities may eventually aggregate reports, visualize graphs, manage policy evidence, and coordinate teams, but they must not be required for the local CLI to function.

### 15.3.2 Read-Only Understanding Before Mutation

Monad must first understand repositories without changing them.

Read-only capabilities include:

```bash id="qv269y"
monad version
monad list
monad config inspect
monad inspect
monad check
monad doctor
monad graph
monad docs check
monad context handoff
```

Only after these are trustworthy should mutation become a central focus.

### 15.3.3 Plan-Backed Mutation Before Generators

Monad should not generate or modify repository files directly as its primary mutation model.

The correct model is:

```text id="as35kw"
command intent
  -> reviewable plan
  -> dry-run
  -> policy checks
  -> human approval
  -> apply
  -> apply report
```

Generators should eventually create plans, not silently write files.

### 15.3.4 Deterministic Behavior Before AI Assistance

AI must not be introduced as a substitute for deterministic repository understanding.

AI assistance should depend on:

* deterministic context,
* stable findings,
* structured repository models,
* safe plan generation,
* policy checks,
* human approval,
* and audit evidence.

### 15.3.5 Source-of-Truth Rules Before Automation

Before Monad automates lifecycle work, it must know what is canonical.

Core source-of-truth rules:

```text id="x31856"
monad.toml is canonical.
workspace.toml is a compatibility mirror only.
monad.lock records resolved state.
.monad/ stores local state, cache, context, reports, and plans.
Repository documentation and governance files are lifecycle artifacts.
```

### 15.3.6 Command Contracts Before Command Depth

Monad should first guarantee that its command catalog and CLI surface agree.

A sparse but honest command surface is better than a broad but misleading one.

### 15.3.7 Graph Foundations Before Graph Persistence

The lifecycle graph should first be generated deterministically from repository state.

Only later should Monad introduce local graph caching, indexing, querying, or hosted graph dashboards.

### 15.3.8 Policy Checks Before Policy Enforcement

Early policy should report findings.

Hard enforcement should come only after:

* policy rules are understandable,
* waivers exist,
* findings are stable,
* false positives are manageable,
* and CI behavior is configurable.

### 15.3.9 Templates Before Plugins

Templates are simpler and safer than plugins.

Monad should establish safe template metadata, preview, plan generation, and apply behavior before introducing arbitrary plugin execution.

### 15.3.10 Solo-Developer Usability Before Enterprise Extensibility

Monad should work well for one developer in one repository before it attempts enterprise fleet governance.

This does not weaken the enterprise vision. It makes the enterprise path credible.

---

## 15.4 Product Maturity Sequence

The recommended maturity sequence is:

```text id="mg97p1"
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

Each stage should have clear entry and exit criteria.

---

## 15.5 Stage 0: Repository Foundation

### Purpose

Create the repository foundation needed to build Monad seriously.

### Focus

* repository structure,
* README,
* product docs,
* architecture docs,
* governance docs,
* ADRs,
* work-packet model,
* roadmap,
* contribution expectations,
* initial CI,
* source-of-truth documentation.

### Entry Criteria

None. This is the bootstrap stage.

### Exit Criteria

Stage 0 is complete when:

* the repository has an intentional structure,
* product charter exists,
* planning package exists,
* ADR structure exists,
* work-packet structure exists,
* governance/security/operations docs exist,
* initial Rust workspace direction is documented,
* and future work can be expressed as work packets.

### Non-Goals

Stage 0 does not need:

* working CLI depth,
* repository inspection,
* mutation engine,
* hosted services,
* AI features.

---

## 15.6 Stage 1: CLI Skeleton and Command Contracts

### Purpose

Create a trustworthy CLI foundation.

### Focus

* Rust workspace,
* `monad` binary,
* CLI/library split,
* command catalog,
* Clap command surface,
* command contract tests,
* placeholder honesty,
* version/help/list commands,
* smoke tests.

### Entry Criteria

Stage 1 can begin when the repository foundation exists.

### Exit Criteria

Stage 1 is complete when:

* `cargo fmt --all --check` passes,
* `cargo check --workspace` passes,
* `cargo test --workspace` passes,
* `monad version` works,
* `monad list` works,
* command catalog exists,
* Clap surface matches catalog,
* placeholder commands are honest,
* planned commands do not pretend to be implemented,
* mutating commands declare mutation metadata,
* and no command performs unsafe mutation.

### Non-Goals

Stage 1 does not need:

* deep repository inspection,
* policy engine,
* graph maturity,
* plan/apply engine,
* generators,
* AI,
* hosted control plane.

---

## 15.7 Stage 2: Read-Only Repository Understanding

### Purpose

Make Monad able to inspect, validate, explain, and graph a repository without mutating it.

### Focus

* workspace root detection,
* manifest resolution,
* canonical source-of-truth rules,
* repository inspection,
* native manifest detection,
* baseline checks,
* doctor diagnostics,
* lifecycle graph v0,
* diff/drift detection v0,
* structured findings,
* text and JSON output,
* read-only safety tests.

### Entry Criteria

Stage 2 can begin when:

* command catalog contract is green,
* command placeholders are honest,
* core CLI skeleton is stable,
* and source-of-truth rules are implemented or ready to implement.

### Exit Criteria

Stage 2 is complete when:

* Monad can detect a workspace root,
* `monad.toml` is recognized as canonical,
* `workspace.toml` conflicts are reported,
* `monad inspect` produces useful repository state,
* `monad check` validates baseline invariants,
* `monad doctor` provides remediation hints,
* `monad graph` emits a basic graph,
* read-only commands do not mutate files,
* fixture tests cover valid, invalid, and conflicting repositories,
* and CI can run core read-only checks.

### Non-Goals

Stage 2 does not need:

* real mutation,
* generators,
* plugin execution,
* hosted services,
* AI planning.

---

## 15.8 Stage 3: Documentation, ADR, and Work-Packet Lifecycle

### Purpose

Make repository lifecycle artifacts first-class.

### Focus

* docs check,
* docs generate preview,
* ADR listing,
* ADR validation,
* ADR creation dry-run,
* ADR supersede dry-run,
* work-packet listing,
* work-packet validation,
* work-packet planning,
* context handoff,
* context safety,
* documentation findings.

### Entry Criteria

Stage 3 can begin when Stage 2 read-only inspection and findings are stable.

### Exit Criteria

Stage 3 is complete when:

* `monad docs check` reports missing or invalid docs,
* ADRs can be listed and validated,
* ADR creation can be previewed without mutation,
* work packets can be listed and validated,
* work-packet plans can be emitted,
* context handoffs can be generated deterministically,
* sensitive files are excluded from context output by default,
* and docs/governance checks are test-backed.

### Non-Goals

Stage 3 does not need:

* actual file-writing docs generation,
* direct ADR mutation,
* autonomous work-packet implementation,
* AI-generated planning,
* hosted docs dashboard.

---

## 15.9 Stage 4: Plan-Backed Mutation Engine

### Purpose

Create the safe mutation model for Monad.

### Focus

* plan schema,
* plan domain model,
* file operation model,
* plan validation,
* dry-run apply,
* approval model,
* apply engine,
* apply reports,
* rollback hints,
* policy gate integration,
* mutation safety tests.

### Entry Criteria

Stage 4 can begin when:

* read-only inspection is stable,
* docs/governance lifecycle commands exist or are well specified,
* findings and output models are stable,
* and mutation safety tests are defined before implementation.

### Exit Criteria

Stage 4 is complete when:

* plans are schema-versioned,
* plans list intended file operations,
* dry-run performs no writes,
* apply writes only planned files,
* unsafe operations are blocked,
* deletion requires explicit approval,
* applies produce reports,
* failed applies report partial state,
* and plan/apply workflows are test-backed.

### Non-Goals

Stage 4 does not need:

* broad project generators,
* plugin marketplace,
* AI plan generation,
* hosted approvals.

---

## 15.10 Stage 5: Generators, Templates, and Packs

### Purpose

Support safe generation of repository artifacts on top of the plan engine.

### Focus

* template metadata,
* documentation templates,
* project generator foundation,
* pack metadata,
* core pack,
* pack install preview,
* pack apply through plan engine,
* generator safety rules.

### Entry Criteria

Stage 5 can begin when the plan engine supports safe preview, dry-run, and apply.

### Exit Criteria

Stage 5 is complete when:

* templates have metadata,
* templates can produce plans,
* core documentation templates exist,
* project generator foundation exists,
* packs can be described,
* pack install can be previewed,
* pack apply uses plan-backed mutation,
* and generated artifacts are reviewable before apply.

### Non-Goals

Stage 5 does not need:

* plugin marketplace,
* arbitrary remote code execution,
* every framework generator,
* AI-generated templates,
* hosted pack registry.

---

## 15.11 Stage 6: Policy Engine and Waivers

### Purpose

Support repository policy-as-code for structure, docs, governance, security, and architecture rules.

### Focus

* policy rule model,
* built-in policy bundle,
* policy check,
* policy explain,
* waiver model,
* waiver expiration,
* waiver audit,
* policy findings,
* policy reports.

### Entry Criteria

Stage 6 can begin when:

* findings are stable,
* docs/work-packet/ADR checks exist,
* plan/apply model exists or is underway,
* and policy behavior can be expressed against repository lifecycle artifacts.

### Exit Criteria

Stage 6 is complete when:

* policies can be evaluated,
* policy findings have stable IDs,
* policy explanations are useful,
* waivers can suppress findings according to rules,
* expired waivers are detected,
* policy reports are structured,
* and policy checks can run in CI.

### Non-Goals

Stage 6 does not need:

* enterprise policy marketplace,
* centralized policy server,
* hosted compliance dashboard,
* full OPA integration unless justified.

---

## 15.12 Stage 7: Release and Change Lifecycle

### Purpose

Connect plans, work packets, tests, policy, and release readiness.

### Focus

* release plan,
* release readiness check,
* changelog generation,
* versioning strategy,
* release evidence report,
* work-packet completion,
* policy status,
* test status,
* documentation status.

### Entry Criteria

Stage 7 can begin when:

* baseline checks are stable,
* docs and governance checks exist,
* policy checks exist,
* and plan/apply evidence exists.

### Exit Criteria

Stage 7 is complete when:

* `monad release readiness` can explain release state,
* release blockers are reported,
* release evidence can be generated,
* changelog/version metadata can be checked or generated,
* work-packet completion can be considered,
* and CI can use release readiness as a gate.

### Non-Goals

Stage 7 does not need:

* hosted release dashboard,
* multi-repository release orchestration,
* automated publishing to every package manager,
* enterprise approval workflows.

---

## 15.13 Stage 8: Lifecycle Graph Persistence and Querying

### Purpose

Make the lifecycle graph more complete, queryable, and eventually cacheable.

### Focus

* graph node/edge schema,
* JSON graph export,
* Mermaid and DOT graph export,
* graph query v0,
* local graph cache,
* graph consistency checks,
* graph drift,
* graph evidence.

### Entry Criteria

Stage 8 can begin when:

* graph v0 exists,
* inspection and docs/governance models are stable,
* and graph outputs have clear use cases.

### Exit Criteria

Stage 8 is complete when:

* graph schema is explicit,
* graph JSON validates,
* graph exports are deterministic,
* graph queries answer useful questions,
* local graph cache is safe and rebuildable if implemented,
* graph consistency checks exist,
* and graph output can support future AI and hosted dashboards.

### Non-Goals

Stage 8 does not need:

* graph database,
* hosted graph explorer,
* real-time graph updates,
* local daemon.

---

## 15.14 Stage 9: AI-Assisted Planning With Human Approval

### Purpose

Add optional AI assistance without weakening deterministic behavior.

### Focus

* AI provider port,
* noop AI adapter,
* prompt template model,
* AI-assisted ADR drafting,
* AI-assisted plan explanation,
* AI-suggested plan creation,
* AI safety and audit controls.

### Entry Criteria

Stage 9 can begin when:

* deterministic context generation exists,
* plan model exists,
* policy checks exist,
* human approval model exists,
* and AI-free workflows are fully functional.

### Exit Criteria

Stage 9 is complete when:

* Monad can run without AI,
* AI providers are optional,
* noop adapter exists,
* AI output is classified,
* AI suggestions become reviewable plans,
* AI cannot directly apply changes,
* context sent to AI is inspectable,
* AI usage is auditable,
* and deterministic policy checks gate AI-suggested plans.

### Non-Goals

Stage 9 does not need:

* autonomous coding agents,
* AI-required correctness,
* hidden provider calls,
* automatic mutation,
* hosted AI orchestration.

---

## 15.15 Stage 10: Optional Hosted and Team Control Plane

### Purpose

Add optional team/fleet capabilities without weakening local-first operation.

### Focus

* hosted control-plane architecture,
* repository metadata sync,
* organization/team model,
* graph dashboard,
* policy compliance dashboard,
* release governance dashboard,
* hosted audit evidence.

### Entry Criteria

Stage 10 can begin when:

* local CLI is valuable,
* reports and evidence are structured,
* graph and policy models are stable,
* release readiness exists,
* and there is a clear reason for team/fleet aggregation.

### Exit Criteria

Stage 10 is complete when:

* hosted features are optional,
* local CLI remains useful offline,
* data upload is explicit,
* tenant/team model is defined,
* hosted dashboards visualize existing local evidence,
* audit evidence can be stored or synchronized,
* and hosted behavior does not become required for core CLI correctness.

### Non-Goals

Stage 10 does not need to be part of v1.

It should not be allowed to pull earlier stages into premature SaaS architecture.

---

## 15.16 Version Strategy

Recommended version strategy:

```text id="ukp8v4"
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

### 15.16.1 v0.1: CLI Foundation and Command Catalog Integrity

v0.1 should prove that Monad is a real CLI project with a trustworthy command surface.

Expected capabilities:

* Rust workspace compiles,
* `monad` binary exists,
* `monad version` works,
* `monad list` works,
* command catalog exists,
* Clap command surface matches catalog,
* planned commands are honest,
* smoke tests pass,
* command contract tests pass.

Exit criteria:

```bash id="lf85qo"
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
```

Plus command catalog contract tests.

### 15.16.2 v0.2: Read-Only Repository Inspection and Validation

v0.2 should prove that Monad can understand a repository without changing it.

Expected capabilities:

* workspace root detection,
* canonical manifest detection,
* compatibility mirror conflict reporting,
* repository inspection,
* baseline check engine,
* doctor diagnostics,
* text output,
* JSON output for key reports,
* read-only safety tests.

### 15.16.3 v0.3: Documentation, ADR, Work-Packet, and Context Lifecycle

v0.3 should prove that Monad can treat docs and governance as lifecycle artifacts.

Expected capabilities:

* docs check,
* ADR list/validate,
* ADR new dry-run,
* work-packet list/validate,
* work-packet plan,
* context handoff,
* context redaction/safety,
* context verification.

### 15.16.4 v0.4: Plan Model and Dry-Run Apply

v0.4 should prove that mutation can be planned safely before being performed.

Expected capabilities:

* plan schema,
* plan validation,
* plan creation for docs/governance artifacts,
* dry-run apply,
* no-write dry-run tests,
* plan reports.

### 15.16.5 v0.5: Safe Mutation for Selected Generators

v0.5 should prove that approved mutation can be applied safely for narrow cases.

Expected capabilities:

* approved apply,
* file operation model,
* apply reports,
* rollback hints,
* selected documentation generator applies,
* selected governance artifact applies,
* mutation safety tests.

### 15.16.6 v0.6: Policy Engine and Waivers

v0.6 should prove that policy-as-code can guide repository governance.

Expected capabilities:

* policy rule model,
* built-in policies,
* policy check,
* policy explain,
* waiver model,
* waiver expiration,
* policy reports,
* CI integration.

### 15.16.7 v0.7: Pack and Template System

v0.7 should prove that reusable templates and packs can extend Monad safely.

Expected capabilities:

* template metadata,
* core templates,
* pack metadata,
* pack preview,
* pack plan generation,
* pack apply through plan engine.

### 15.16.8 v0.8: Release and Change Lifecycle

v0.8 should prove that Monad can connect repository lifecycle health to release readiness.

Expected capabilities:

* release plan,
* release readiness,
* changelog generation,
* version strategy checks,
* release evidence report.

### 15.16.9 v0.9: Lifecycle Graph Maturity and Local Indexing

v0.9 should mature the lifecycle graph.

Expected capabilities:

* graph schema,
* JSON/Mermaid/DOT exports,
* graph query v0,
* local graph cache if needed,
* graph consistency checks.

### 15.16.10 v1.0: Stable Local-First Monad OS Core

v1.0 should be the first stable local-first governance-grade release.

Expected capabilities:

* stable CLI command surface,
* source-of-truth rules,
* read-only repository understanding,
* docs/governance lifecycle,
* context handoff,
* graph generation,
* policy checks,
* plan/dry-run/apply for selected operations,
* template foundation,
* JSON schemas,
* robust tests,
* release process,
* security posture,
* documentation.

### 15.16.11 v1.1: Advanced Packs, Policy Bundles, and Adapters

v1.1 should expand safe extensibility.

Expected capabilities:

* more packs,
* policy bundles,
* native tool adapters,
* CI adapters,
* richer templates,
* stronger docs/work-packet automation.

### 15.16.12 v1.2: AI-Assisted Planning and Context Governance

v1.2 should add optional AI workflows.

Expected capabilities:

* AI provider port,
* noop adapter,
* prompt templates,
* context governance,
* AI-assisted explanations,
* AI-suggested plan candidates,
* human approval,
* safety controls.

### 15.16.13 v2.0: Optional Hosted/Team/Fleet Control Plane

v2.0 should introduce optional hosted/team/fleet capabilities.

Expected capabilities:

* hosted architecture,
* team model,
* repo metadata sync,
* graph dashboard,
* policy dashboard,
* release governance dashboard,
* audit evidence.

v2.0 must not invalidate the local-first CLI.

---

## 15.17 MVP Definition

The MVP should not be “generate every project type.”

The MVP should prove the core thesis:

> A local repository can describe itself, validate itself, explain itself, graph itself, document itself, and produce safe change plans.

### 15.17.1 MVP Command Loop

The MVP command loop is:

```bash id="56thmy"
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

### 15.17.2 MVP Product Capabilities

The MVP should include:

* local CLI execution,
* command catalog,
* honest planned/implemented command status,
* canonical manifest model,
* source-of-truth checks,
* read-only repository inspection,
* baseline repository validation,
* doctor diagnostics,
* lifecycle graph v0,
* deterministic context handoff,
* docs check,
* plan model,
* dry-run apply,
* structured findings,
* JSON output for key commands,
* fixture tests,
* command contract tests,
* read-only safety tests.

### 15.17.3 MVP Success Criteria

The MVP succeeds if a serious user can run Monad in a repository and understand:

* what the repository is,
* what Monad recognizes,
* what is missing,
* what is inconsistent,
* what docs/governance artifacts exist,
* what the lifecycle graph looks like,
* what context can be handed off,
* what changes could be planned,
* and that no unsafe mutation happens.

### 15.17.4 MVP Non-Goals

The MVP does not need:

* broad generators,
* plugin marketplace,
* AI provider integration,
* hosted dashboard,
* Kubernetes,
* database dependency,
* multi-repo fleet governance,
* enterprise SSO,
* autonomous mutation.

---

## 15.18 v1 Definition

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

### 15.18.1 v1 Quality Bar

v1 should be judged by trust, not feature count.

v1 should be:

* useful locally,
* deterministic,
* safe by default,
* test-backed,
* documented,
* explainable,
* extensible,
* and honest about what it does not yet do.

### 15.18.2 v1 Product Promise

A v1 user should be able to say:

```text id="bu6imh"
Monad helps me understand, validate, document, graph, govern, and safely evolve my repository from the command line without requiring a hosted service or AI provider.
```

### 15.18.3 v1 Stability Expectations

v1 should stabilize:

* command names,
* global flags,
* output formats,
* exit code strategy,
* core schemas,
* manifest model,
* plan model,
* policy finding model,
* context handoff behavior,
* graph output behavior.

---

## 15.19 v1 Non-Goals

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

These exclusions are strategic. They preserve the local-first product boundary.

---

## 15.20 Roadmap Hierarchy

Preferred implementation hierarchy:

```text id="a5e1rt"
Epic
  Work Packet
    Layer
      Task
```

### 15.20.1 Epic

An epic is a large product capability area.

Examples:

```text id="k6ddc2"
Command Surface and CLI Contracts
Read-Only Repository Understanding
Plan-Backed Mutation Engine
Policy Engine and Waivers
```

An epic should define:

* purpose,
* scope,
* expected outcomes,
* major work packets,
* dependencies,
* maturity stage,
* risks,
* and completion criteria.

### 15.20.2 Work Packet

A work packet is a coherent implementation unit that can be planned, built, tested, reviewed, and completed.

Each work packet should include:

* purpose,
* scope,
* out of scope,
* inputs,
* outputs,
* dependencies,
* affected bounded contexts,
* implementation layers,
* tests,
* documentation updates,
* acceptance criteria,
* risks,
* rollback strategy,
* definition of done.

### 15.20.3 Layer

A layer is a small, ordered implementation slice inside a work packet.

A layer should be:

* small enough to implement safely,
* testable,
* reversible,
* easy to review,
* and clearly related to the work-packet acceptance criteria.

### 15.20.4 Task

A task is the smallest execution step.

Tasks may include:

* add type,
* add parser,
* add fixture,
* add test,
* update command,
* update docs,
* run CI.

Tasks should usually be tracked in implementation notes, issues, or PRs rather than the top-level roadmap.

---

## 15.21 Work Packet Template

Every significant work packet should follow this template.

```markdown id="cn62eu"
## WP-XXXX: Title

Purpose:

Scope:

Out of scope:

Affected bounded contexts:

Inputs:

Outputs:

Dependencies:

Layers:

Tests:

Documentation updates:

Acceptance criteria:

Risks:

Rollback strategy:

Definition of done:
```

### 15.21.1 Work Packet Readiness

A work packet is ready when it has:

* clear purpose,
* bounded scope,
* explicit non-goals,
* dependencies,
* affected commands,
* affected data/schema,
* affected bounded contexts,
* tests to add,
* docs to update,
* safety concerns,
* acceptance criteria.

### 15.21.2 Work Packet Completion

A work packet is complete when:

* implementation is done,
* tests pass,
* command catalog is updated,
* docs are updated,
* examples are updated if needed,
* schemas are updated if needed,
* ADRs are added if needed,
* safety constraints are preserved,
* acceptance criteria are satisfied,
* and CI is green.

---

# 15.22 Epic Map

## EPIC-0001: Repository Foundation and Source of Truth

Purpose:

Create the foundational repository structure, documentation, governance surfaces, manifests, and source-of-truth rules.

Work packets:

```text id="8i4c3q"
WP-0000: Product and Repository Foundation
WP-0001: Rust Workspace and CLI Foundation
WP-0002: Canonical Manifest and Workspace Model
WP-0003: Documentation and Governance Foundation
```

Completion criteria:

* repository foundation exists,
* source-of-truth doctrine is documented,
* Rust workspace exists,
* canonical manifest model is defined,
* docs/governance structure exists.

---

## EPIC-0002: Command Surface and CLI Contracts

Purpose:

Create a trustworthy CLI surface backed by a command catalog and contract tests.

Work packets:

```text id="3j1hie"
WP-0004: Command Catalog Model
WP-0005: Clap Surface Contract
WP-0006: Placeholder Honesty and Command Metadata
WP-0007: CLI Output and Exit Code Standardization
```

Completion criteria:

* command catalog exists,
* Clap surface matches catalog,
* planned commands are honest,
* mutating commands declare metadata,
* output and exit code patterns are standardized.

---

## EPIC-0003: Read-Only Repository Understanding

Purpose:

Make Monad able to inspect, validate, explain, and graph a repository without mutating it.

Work packets:

```text id="2smqcr"
WP-0008: Workspace Root Detection
WP-0009: Repository Inspection Engine
WP-0010: Baseline Check Engine
WP-0011: Doctor Diagnostics
WP-0012: Lifecycle Graph v0
WP-0013: Diff and Drift Detection v0
```

Completion criteria:

* repository root can be detected,
* repository state can be inspected,
* baseline checks run,
* doctor diagnostics explain remediation,
* graph v0 exists,
* drift can be reported,
* read-only safety is proven.

---

## EPIC-0004: Documentation, ADR, and Work-Packet Lifecycle

Purpose:

Make docs, ADRs, and work packets first-class lifecycle artifacts.

Work packets:

```text id="r7ywam"
WP-0014: Docs Check
WP-0015: Docs Generate Preview
WP-0016: ADR List and Validation
WP-0017: ADR New and Supersede Dry-Run
WP-0018: Work Packet List and Validation
WP-0019: Work Packet Plan
```

Completion criteria:

* docs can be checked,
* docs generation can be previewed,
* ADRs can be listed and validated,
* ADR changes can be planned or dry-run,
* work packets can be listed and validated,
* work-packet plans can be generated.

---

## EPIC-0005: Context and AI-Safe Handoff

Purpose:

Produce deterministic context packs and handoff summaries for humans and AI tools.

Work packets:

```text id="7jbmm1"
WP-0020: Context Model
WP-0021: Handoff Generator
WP-0022: Context Pack Generator
WP-0023: Context Redaction and Safety
WP-0024: Context Verification
```

Completion criteria:

* context model exists,
* handoff generator is deterministic,
* context packs can be generated,
* sensitive files are excluded/redacted,
* context output can be verified,
* AI is not required.

---

## EPIC-0006: Plan-Backed Mutation Engine

Purpose:

Create the plan/apply model that makes repository mutation safe, inspectable, and auditable.

Work packets:

```text id="h5qmbp"
WP-0025: Plan Schema and Domain Model
WP-0026: Plan Creation for Documentation Artifacts
WP-0027: Dry-Run Apply Engine
WP-0028: Apply Engine with Approval
WP-0029: Rollback Hints and Apply Reports
WP-0030: Plan Policy Evaluation
```

Completion criteria:

* plans are schema-versioned,
* plans can be created,
* dry-run writes nothing,
* approved apply writes only planned files,
* apply reports are generated,
* policy checks can gate plans.

---

## EPIC-0007: Generators, Templates, and Packs

Purpose:

Support safe generation of repo artifacts, apps, services, packages, docs, and governance files.

Work packets:

```text id="370fxv"
WP-0031: Template Metadata Model
WP-0032: Core Documentation Templates
WP-0033: Project Generator Foundation
WP-0034: Pack Metadata Model
WP-0035: Core Pack
WP-0036: Pack Install Preview
WP-0037: Pack Apply via Plan Engine
```

Completion criteria:

* templates have metadata,
* documentation templates exist,
* project generator foundation exists,
* packs have metadata,
* core pack exists,
* pack install can be previewed,
* pack apply uses plan engine.

---

## EPIC-0008: Policy Engine and Waivers

Purpose:

Support policy-as-code for repo structure, docs, governance, security, and architecture rules.

Work packets:

```text id="04v3ox"
WP-0038: Policy Rule Model
WP-0039: Built-In Policy Bundle
WP-0040: Policy Check
WP-0041: Policy Explain
WP-0042: Policy Waiver Model
WP-0043: Waiver Expiration and Audit
```

Completion criteria:

* policy rule model exists,
* built-in policies exist,
* policy checks produce findings,
* policy explain works,
* waivers exist,
* expired waivers are audited.

---

## EPIC-0009: Native Tool Coordination

Purpose:

Coordinate native tools without replacing them.

Work packets:

```text id="xq8cp7"
WP-0044: Native Tool Detection
WP-0045: Cargo Adapter
WP-0046: Bun/Node Adapter
WP-0047: Moon/Turborepo Adapter
WP-0048: Git Adapter
WP-0049: CI Adapter Foundation
```

Completion criteria:

* native tools can be detected,
* tool availability is reported,
* selected adapters exist,
* missing optional tools degrade gracefully,
* Monad coordinates rather than replaces native tools.

---

## EPIC-0010: Release and Change Lifecycle

Purpose:

Connect plans, work packets, tests, policy, and release readiness.

Work packets:

```text id="jc40wc"
WP-0050: Release Plan
WP-0051: Release Readiness Check
WP-0052: Changelog Generation
WP-0053: Versioning Strategy
WP-0054: Release Evidence Report
```

Completion criteria:

* release plans exist,
* release readiness can be checked,
* changelogs can be generated or validated,
* versioning strategy is enforced,
* release evidence reports are produced.

---

## EPIC-0011: Advanced Graph and Query Layer

Purpose:

Make the lifecycle graph more complete, queryable, and eventually cacheable.

Work packets:

```text id="vobvly"
WP-0055: Graph Node/Edge Schema
WP-0056: Graph Export JSON
WP-0057: Graph Export Mermaid and DOT
WP-0058: Graph Query v0
WP-0059: Local Graph Cache
WP-0060: Graph Consistency Checks
```

Completion criteria:

* graph schema exists,
* JSON graph export works,
* Mermaid and DOT export work,
* graph query v0 exists,
* local cache is safe if implemented,
* graph consistency checks pass.

---

## EPIC-0012: AI-Assisted but AI-Optional Workflows

Purpose:

Add optional AI assistance while preserving deterministic behavior and human approval.

Work packets:

```text id="7w902z"
WP-0061: AI Provider Port
WP-0062: Noop AI Adapter
WP-0063: Prompt Template Model
WP-0064: AI-Assisted ADR Drafting
WP-0065: AI-Assisted Plan Explanation
WP-0066: AI-Suggested Plan Creation
WP-0067: AI Safety and Audit Controls
```

Completion criteria:

* AI provider port exists,
* noop adapter preserves AI-free behavior,
* prompt templates are versioned,
* AI can draft or explain but not apply automatically,
* AI suggestions become reviewable plans,
* AI usage is auditable.

---

## EPIC-0013: Optional Hosted Control Plane

Purpose:

Add optional team/fleet features without weakening local-first operation.

Work packets:

```text id="ko7n6t"
WP-0068: Hosted Control Plane Architecture
WP-0069: Repo Metadata Sync
WP-0070: Organization and Team Model
WP-0071: Graph Dashboard
WP-0072: Policy Compliance Dashboard
WP-0073: Release Governance Dashboard
WP-0074: Hosted Audit Evidence
```

Completion criteria:

* hosted architecture is defined,
* repository metadata sync is explicit and optional,
* team model exists,
* graph dashboard exists,
* policy dashboard exists,
* release dashboard exists,
* audit evidence can be hosted,
* local CLI remains fully useful without hosted services.

---

# 15.23 Detailed Work Packet Plan

The following work packets define the near-term implementation sequence in greater detail.

Later work packets should be expanded when their prerequisite stages become active.

---

## WP-0000: Product and Repository Foundation

Purpose:

Create the initial product/repository foundation and source-of-truth documentation.

Scope:

* README,
* product charter,
* roadmap,
* initial ADRs,
* governance docs,
* initial directory structure.

Out of scope:

* executable CLI behavior,
* mutation engine,
* hosted services.

Affected bounded contexts:

* Governance,
* Documentation,
* Product Planning,
* Architecture.

Inputs:

* product vision,
* architecture principles,
* roadmap.

Outputs:

* repository skeleton,
* docs,
* ADRs,
* governance files.

Dependencies:

* none.

Layers:

```text id="s6ceqg"
Layer 0000.1: top-level repository skeleton
Layer 0000.2: product docs
Layer 0000.3: architecture docs
Layer 0000.4: governance docs
Layer 0000.5: roadmap and work-packet docs
```

Tests:

* documentation presence checks, later,
* markdown link checks, later,
* structure checks, later.

Documentation updates:

* README,
* product charter,
* architecture overview,
* ADR index,
* roadmap,
* governance docs.

Acceptance criteria:

* repo has clear README,
* product charter exists,
* ADR index exists,
* roadmap exists,
* governance model exists,
* directory structure is intentional.

Risks:

* over-documenting before implementation,
* unclear source-of-truth hierarchy,
* roadmap becoming stale.

Rollback strategy:

* docs-only changes can be reverted normally through Git.

Definition of done:

* foundation docs are committed,
* repository structure is understandable,
* future work can reference the roadmap.

---

## WP-0001: Rust Workspace and CLI Foundation

Purpose:

Create the Rust workspace foundation for `monad`.

Scope:

* Cargo workspace,
* `monad-cli`,
* `monad-core`,
* initial binary,
* initial library split,
* version command,
* smoke tests.

Out of scope:

* full repo inspection,
* mutation,
* policy engine.

Affected bounded contexts:

* Command,
* Workspace,
* Runtime.

Inputs:

* repository foundation,
* CLI command vision.

Outputs:

* compiling Rust workspace,
* runnable `monad` binary,
* passing tests.

Dependencies:

* WP-0000.

Layers:

```text id="a6v34z"
Layer 0001.1: Cargo workspace
Layer 0001.2: monad-core crate
Layer 0001.3: monad-cli crate
Layer 0001.4: binary/library split
Layer 0001.5: version/help smoke tests
```

Tests:

* workspace compile test,
* version command smoke test,
* help command smoke test,
* cargo workspace tests.

Documentation updates:

* README usage,
* development setup,
* command list notes.

Acceptance criteria:

```bash id="d9re12"
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
```

All pass.

Risks:

* CLI and library boundaries may be unclear,
* tests may overfit early output,
* binary-only structure may limit future contract testing.

Rollback strategy:

* revert crate split if needed,
* preserve working binary behavior.

Definition of done:

* workspace compiles,
* binary runs,
* smoke tests pass,
* docs explain how to run the CLI.

---

## WP-0002: Canonical Manifest and Workspace Model

Purpose:

Establish `monad.toml` as canonical and define workspace resolution rules.

Scope:

* manifest model,
* workspace root detection,
* compatibility mirror handling,
* source-of-truth validation.

Out of scope:

* complex migration,
* hosted sync,
* remote repository metadata.

Affected bounded contexts:

* Workspace,
* Configuration,
* Source of Truth,
* Inspection.

Inputs:

* source-of-truth doctrine,
* repository layout expectations.

Outputs:

* manifest domain types,
* manifest parser,
* workspace model,
* source-of-truth findings.

Dependencies:

* WP-0001.

Layers:

```text id="uf5l7u"
Layer 0002.1: manifest domain types
Layer 0002.2: manifest parser
Layer 0002.3: workspace root detection
Layer 0002.4: compatibility mirror detection
Layer 0002.5: source-of-truth check
```

Tests:

* valid `monad.toml`,
* missing `monad.toml`,
* `workspace.toml` only,
* conflicting `workspace.toml`,
* invalid TOML,
* nested directory root detection,
* read-only safety.

Documentation updates:

* manifest reference,
* source-of-truth documentation,
* compatibility mirror explanation.

Acceptance criteria:

* `monad.toml` is recognized as canonical,
* `workspace.toml` is not treated as canonical,
* conflicts are reported,
* tests cover missing, valid, and conflicting manifest states.

Risks:

* `workspace.toml` could be accidentally treated as canonical,
* root detection could be inconsistent,
* invalid manifests could produce poor errors.

Rollback strategy:

* keep manifest parsing isolated,
* avoid migration writes in this packet.

Definition of done:

* manifest behavior is test-backed,
* source-of-truth rules are visible to users,
* no mutation occurs.

---

## WP-0003: Documentation and Governance Foundation

Purpose:

Create docs and governance surfaces that Monad itself can later validate.

Scope:

* docs layout,
* ADR layout,
* work-packet layout,
* governance model,
* security docs,
* operations docs.

Out of scope:

* docs generation,
* docs mutation,
* hosted documentation.

Affected bounded contexts:

* Documentation,
* Governance,
* ADR,
* Work Packet,
* Security,
* Operations.

Inputs:

* planning package,
* architecture doctrine,
* governance requirements.

Outputs:

* docs structure,
* ADR structure,
* work-packet structure,
* governance docs.

Dependencies:

* WP-0000.

Layers:

```text id="v9h0rt"
Layer 0003.1: docs/index.md
Layer 0003.2: architecture overview
Layer 0003.3: ADR structure
Layer 0003.4: work-packet structure
Layer 0003.5: security/governance/operations docs
```

Tests:

* future docs-check fixtures,
* future ADR structure tests,
* future work-packet structure tests.

Documentation updates:

* all docs in scope.

Acceptance criteria:

* docs are discoverable,
* ADRs have standard format,
* work packets have standard format,
* docs are suitable for future `monad docs check`.

Risks:

* documentation may drift from implementation,
* too much future scope may obscure immediate implementation.

Rollback strategy:

* docs can be revised without code migration.

Definition of done:

* docs layout is stable enough for validation commands to target.

---

## WP-0004: Command Catalog Model

Purpose:

Create a structured command catalog as the source of truth for planned and implemented CLI commands.

Scope:

* command metadata,
* command namespace,
* implemented/planned state,
* mutation metadata,
* dry-run and plan-backed metadata.

Out of scope:

* fully implementing every catalog command,
* hosted command registry,
* plugin-provided commands.

Affected bounded contexts:

* Command,
* Observability,
* Testing.

Inputs:

* planned command surface,
* CLI architecture,
* BDD command scenarios.

Outputs:

* command catalog model,
* command entries,
* command listing output.

Dependencies:

* WP-0001.

Layers:

```text id="kdoyui"
Layer 0004.1: command metadata type
Layer 0004.2: command catalog entries
Layer 0004.3: command listing output
Layer 0004.4: planned vs implemented display
Layer 0004.5: command examples
```

Tests:

* catalog contains expected commands,
* catalog entries include category/status,
* mutating commands declare mutation metadata,
* examples reference known commands.

Documentation updates:

* command surface docs,
* command catalog notes.

Acceptance criteria:

* every known command has metadata,
* mutating commands are marked,
* unimplemented commands are honest,
* command list output is useful.

Risks:

* command catalog may drift from Clap,
* catalog may overpromise planned behavior.

Rollback strategy:

* catalog entries can be adjusted without changing domain behavior.

Definition of done:

* `monad list` is backed by structured catalog data,
* planned commands are clearly labeled.

---

## WP-0005: Clap Surface Contract

Purpose:

Ensure the actual CLI surface and command catalog do not drift.

Scope:

* contract tests,
* nested command validation,
* command example validation.

Out of scope:

* implementing all planned commands,
* plugin command discovery.

Affected bounded contexts:

* Command,
* Testing.

Inputs:

* command catalog,
* Clap command tree.

Outputs:

* command contract tests.

Dependencies:

* WP-0004.

Layers:

```text id="qniuy9"
Layer 0005.1: catalog-to-Clap traversal
Layer 0005.2: top-level command test
Layer 0005.3: nested command test
Layer 0005.4: examples command test
Layer 0005.5: implemented command coverage test
```

Tests:

* `clap_surface_exposes_every_catalog_command`,
* `catalog_does_not_claim_unknown_example_commands`,
* nested command coverage,
* planned/implemented command checks.

Documentation updates:

* test strategy,
* command catalog documentation.

Acceptance criteria:

* catalog commands expected in CLI are exposed,
* Clap commands are known to catalog,
* tests fail when catalog and CLI drift.

Risks:

* tests may become too strict for planned commands,
* command examples may require parsing rules.

Rollback strategy:

* contract test strictness can be staged by metadata.

Definition of done:

* command catalog drift causes a failing test.

---

## WP-0006: Placeholder Honesty and Command Metadata

Purpose:

Prevent the CLI from pretending unimplemented behavior exists.

Scope:

* placeholder renderer,
* metadata output,
* planned command messaging,
* exit code for unimplemented commands.

Out of scope:

* full implementation of planned commands,
* command-specific deep behavior.

Affected bounded contexts:

* Command,
* Observability,
* Safety.

Inputs:

* command catalog,
* CLI surface.

Outputs:

* placeholder behavior,
* honest planned-command output,
* mutation metadata display.

Dependencies:

* WP-0004,
* WP-0005.

Layers:

```text id="i0jzhe"
Layer 0006.1: placeholder output model
Layer 0006.2: implemented=false behavior
Layer 0006.3: mutating metadata display
Layer 0006.4: plan-backed metadata display
Layer 0006.5: tests for placeholder honesty
```

Tests:

* planned command output says not implemented,
* planned command does not silently succeed as real behavior,
* mutating planned commands display future safety model,
* placeholder exit code is documented.

Documentation updates:

* command status semantics,
* CLI behavior docs.

Acceptance criteria:

* unimplemented commands are explicitly marked,
* placeholder commands do not silently succeed as if implemented,
* mutating planned commands warn about future mutation behavior.

Risks:

* users may be confused by broad planned command surface,
* planned commands may obscure implemented capabilities.

Rollback strategy:

* hide planned commands by default if needed,
* keep `--all` option for planned surface if UX demands it.

Definition of done:

* placeholder behavior is honest and tested.

---

## WP-0007: CLI Output and Exit Code Standardization

Purpose:

Create consistent human and machine output behavior.

Scope:

* standard output format,
* error format,
* findings format,
* exit codes.

Out of scope:

* final schemas for every future report,
* hosted telemetry,
* remote diagnostics.

Affected bounded contexts:

* Observability,
* Command,
* Testing.

Inputs:

* findings model,
* testing strategy,
* observability strategy.

Outputs:

* finding model,
* output formatter,
* JSON output foundation,
* exit code mapping.

Dependencies:

* WP-0004,
* WP-0005.

Layers:

```text id="wpi26y"
Layer 0007.1: finding model
Layer 0007.2: output formatter
Layer 0007.3: JSON output foundation
Layer 0007.4: exit code mapping
Layer 0007.5: snapshot tests
```

Tests:

* output snapshot tests,
* JSON structure tests,
* exit code tests,
* error formatting tests.

Documentation updates:

* CLI output contract,
* exit code reference,
* findings model.

Acceptance criteria:

* command errors are consistent,
* validation failures have specific exit codes,
* JSON output is possible for key commands.

Risks:

* output contracts may stabilize too early,
* exit code taxonomy may need adjustment.

Rollback strategy:

* mark JSON schema as pre-v1 until stable.

Definition of done:

* core output behavior is predictable and test-backed.

---

## WP-0008: Workspace Root Detection

Purpose:

Allow Monad to reliably identify the workspace root.

Scope:

* root detection from current directory,
* root detection by manifest,
* Git root awareness,
* error handling.

Out of scope:

* multi-repo workspace federation,
* hosted repository identity.

Affected bounded contexts:

* Workspace,
* Inspection,
* Command.

Inputs:

* manifest model,
* source-of-truth rules.

Outputs:

* workspace root detector,
* workspace-not-found finding/error.

Dependencies:

* WP-0002,
* WP-0007.

Layers:

```text id="p7s5bf"
Layer 0008.1: current directory root detection
Layer 0008.2: walk-up manifest discovery
Layer 0008.3: Git root fallback
Layer 0008.4: workspace-not-found finding
Layer 0008.5: fixture tests
```

Tests:

* root found in current directory,
* root found from nested directory,
* missing root reports useful error,
* Git root fallback behavior,
* no file mutation.

Documentation updates:

* workspace detection rules,
* troubleshooting docs.

Acceptance criteria:

* running in nested directories still finds workspace,
* missing workspace produces useful error,
* no files are modified.

Risks:

* ambiguous roots in nested repositories,
* Git root and manifest root may conflict.

Rollback strategy:

* prefer manifest root when present,
* report ambiguity rather than guessing silently.

Definition of done:

* workspace root detection is deterministic and tested.

---

## WP-0009: Repository Inspection Engine

Purpose:

Make `monad inspect` useful.

Scope:

* file tree scan,
* project detection,
* native manifest detection,
* docs detection,
* policy detection,
* governance artifact detection.

Out of scope:

* deep static analysis,
* dependency graph resolution,
* mutation,
* AI summarization.

Affected bounded contexts:

* Inspection,
* Workspace,
* Native Tool Coordination,
* Docs,
* Governance.

Inputs:

* workspace model,
* repository files,
* native manifests.

Outputs:

* inspection report model,
* text output,
* JSON output.

Dependencies:

* WP-0008,
* WP-0007.

Layers:

```text id="2t08e6"
Layer 0009.1: inspection report model
Layer 0009.2: project area detection
Layer 0009.3: native manifest detection
Layer 0009.4: docs/governance detection
Layer 0009.5: text and JSON output
```

Tests:

* fixture inspection tests,
* native manifest detection tests,
* output snapshot tests,
* JSON schema tests,
* read-only safety test.

Documentation updates:

* inspect command docs,
* inspection report docs.

Acceptance criteria:

* `monad inspect` reports meaningful repo state,
* fixture repos are inspected correctly,
* command is read-only.

Risks:

* inspection may overclaim understanding,
* project detection may be too heuristic.

Rollback strategy:

* label uncertain detections clearly,
* keep findings separate from facts.

Definition of done:

* inspection works on representative fixtures and does not mutate files.

---

## WP-0010: Baseline Check Engine

Purpose:

Make `monad check` validate core invariants.

Scope:

* canonical manifest check,
* docs existence check,
* command catalog check,
* source-of-truth check,
* workspace shape check.

Out of scope:

* full policy engine,
* release readiness,
* mutation.

Affected bounded contexts:

* Inspection,
* Workspace,
* Governance,
* Observability.

Inputs:

* workspace model,
* inspection report,
* command catalog,
* docs/governance structure.

Outputs:

* check runner,
* baseline findings,
* CI mode.

Dependencies:

* WP-0007,
* WP-0008,
* WP-0009.

Layers:

```text id="k1pnxw"
Layer 0010.1: check runner
Layer 0010.2: invariant registry
Layer 0010.3: baseline findings
Layer 0010.4: CI mode
Layer 0010.5: tests and snapshots
```

Tests:

* valid repo passes,
* missing manifest reports finding,
* manifest conflict reports finding,
* missing docs reports finding,
* CI mode exit code tests,
* JSON output tests.

Documentation updates:

* check command docs,
* baseline invariant docs.

Acceptance criteria:

* valid repo passes,
* invalid repo reports clear findings,
* CI mode returns useful exit codes.

Risks:

* checks may become too opinionated too early,
* warnings/errors may need configurability.

Rollback strategy:

* start with warning-based findings,
* reserve hard failures for clear invariant violations.

Definition of done:

* `monad check` is useful, deterministic, and test-backed.

---

## WP-0011: Doctor Diagnostics

Purpose:

Provide higher-level guidance and remediation hints.

Scope:

* diagnostic checks,
* grouped findings,
* remediation hints,
* severity levels.

Out of scope:

* automatic repair,
* hosted diagnostics,
* AI-generated remediation.

Affected bounded contexts:

* Observability,
* Workspace,
* Docs,
* Native Tool Coordination.

Inputs:

* check engine,
* inspection engine,
* findings model.

Outputs:

* diagnostic model,
* `monad doctor` output,
* remediation guidance.

Dependencies:

* WP-0007,
* WP-0009,
* WP-0010.

Layers:

```text id="82c4os"
Layer 0011.1: diagnostic model
Layer 0011.2: manifest diagnostics
Layer 0011.3: docs diagnostics
Layer 0011.4: native tool diagnostics
Layer 0011.5: remediation output
```

Tests:

* doctor reports actionable problems,
* remediation hints exist,
* missing optional native tools do not crash,
* severity grouping works,
* snapshot tests.

Documentation updates:

* doctor command docs,
* troubleshooting docs,
* runbook links.

Acceptance criteria:

* `monad doctor` helps users fix problems,
* output is actionable,
* diagnostics are test-backed.

Risks:

* doctor may duplicate check too much,
* remediation hints may be too generic.

Rollback strategy:

* keep doctor as a presentation layer over findings where possible.

Definition of done:

* users can understand how to fix common repository problems.

---

## WP-0012: Lifecycle Graph v0

Purpose:

Create first graph model and outputs.

Scope:

* graph node model,
* graph edge model,
* workspace/project/docs nodes,
* text output,
* Mermaid output.

Out of scope:

* graph persistence,
* graph database,
* hosted graph dashboard,
* advanced graph query.

Affected bounded contexts:

* Graph,
* Workspace,
* Inspection,
* Docs.

Inputs:

* inspection report,
* workspace model,
* docs/governance metadata.

Outputs:

* graph domain model,
* graph builder,
* text graph,
* Mermaid graph.

Dependencies:

* WP-0009,
* WP-0010.

Layers:

```text id="ncc0g4"
Layer 0012.1: graph domain model
Layer 0012.2: graph builder from inspection report
Layer 0012.3: text graph output
Layer 0012.4: Mermaid output
Layer 0012.5: graph invariant tests
```

Tests:

* graph nodes exist,
* graph edges reference existing nodes,
* text output snapshot,
* Mermaid output snapshot,
* deterministic ordering,
* fixture tests.

Documentation updates:

* graph command docs,
* graph model docs.

Acceptance criteria:

* graph contains workspace and project nodes,
* graph edges are valid,
* Mermaid output is usable.

Risks:

* graph model may become too detailed too early,
* graph output may become unstable.

Rollback strategy:

* keep graph v0 intentionally small,
* expand graph schema later in EPIC-0011.

Definition of done:

* graph v0 demonstrates lifecycle graph direction without requiring persistence.

---

## WP-0013: Diff and Drift Detection v0

Purpose:

Detect drift between expected and actual repo state.

Scope:

* manifest-vs-files drift,
* docs-vs-code drift,
* command catalog drift,
* compatibility mirror drift.

Out of scope:

* automatic repair,
* hosted drift monitoring,
* continuous file watching.

Affected bounded contexts:

* Inspection,
* Workspace,
* Docs,
* Command,
* Governance.

Inputs:

* inspection report,
* manifest model,
* command catalog,
* docs/governance expectations.

Outputs:

* drift model,
* diff/drift findings,
* text and JSON output.

Dependencies:

* WP-0007,
* WP-0009,
* WP-0010,
* WP-0012.

Layers:

```text id="ip6a5r"
Layer 0013.1: drift model
Layer 0013.2: manifest drift
Layer 0013.3: docs drift
Layer 0013.4: catalog drift
Layer 0013.5: diff output
```

Tests:

* manifest drift fixture,
* docs drift fixture,
* catalog drift test,
* compatibility mirror drift test,
* JSON output test,
* read-only safety test.

Documentation updates:

* diff/drift command docs,
* drift model docs.

Acceptance criteria:

* `monad diff` reports meaningful drift,
* no mutations occur,
* output supports text and JSON.

Risks:

* drift checks may overlap with baseline checks,
* drift semantics may be unclear.

Rollback strategy:

* keep drift v0 narrow and report-only.

Definition of done:

* drift detection reports discrepancies without attempting repair.

---

# 15.24 Mid-Term Work Packet Summary

The following work packets should be expanded into detailed plans when their epic becomes active.

## EPIC-0004: Documentation, ADR, and Work-Packet Lifecycle

| Work Packet | Summary                                      | Earliest Stage |
| ----------- | -------------------------------------------- | -------------- |
| WP-0014     | Implement `monad docs check`                 | Stage 3        |
| WP-0015     | Preview docs generation through dry-run/plan | Stage 3        |
| WP-0016     | List and validate ADRs                       | Stage 3        |
| WP-0017     | Preview ADR new/supersede operations         | Stage 3        |
| WP-0018     | List and validate work packets               | Stage 3        |
| WP-0019     | Generate work-packet implementation plan     | Stage 3        |

## EPIC-0005: Context and AI-Safe Handoff

| Work Packet | Summary                          | Earliest Stage |
| ----------- | -------------------------------- | -------------- |
| WP-0020     | Define context model             | Stage 3        |
| WP-0021     | Generate deterministic handoff   | Stage 3        |
| WP-0022     | Generate context packs           | Stage 3        |
| WP-0023     | Add redaction and context safety | Stage 3        |
| WP-0024     | Verify context output            | Stage 3        |

## EPIC-0006: Plan-Backed Mutation Engine

| Work Packet | Summary                                    | Earliest Stage |
| ----------- | ------------------------------------------ | -------------- |
| WP-0025     | Define plan schema and domain model        | Stage 4        |
| WP-0026     | Create plans for docs/governance artifacts | Stage 4        |
| WP-0027     | Implement dry-run apply                    | Stage 4        |
| WP-0028     | Implement approved apply                   | Stage 4        |
| WP-0029     | Add rollback hints and apply reports       | Stage 4        |
| WP-0030     | Gate plans with policy evaluation          | Stage 4/6      |

## EPIC-0007: Generators, Templates, and Packs

| Work Packet | Summary                          | Earliest Stage |
| ----------- | -------------------------------- | -------------- |
| WP-0031     | Define template metadata         | Stage 5        |
| WP-0032     | Add core documentation templates | Stage 5        |
| WP-0033     | Add project generator foundation | Stage 5        |
| WP-0034     | Define pack metadata             | Stage 5        |
| WP-0035     | Add core pack                    | Stage 5        |
| WP-0036     | Preview pack install             | Stage 5        |
| WP-0037     | Apply packs through plan engine  | Stage 5        |

## EPIC-0008: Policy Engine and Waivers

| Work Packet | Summary                         | Earliest Stage |
| ----------- | ------------------------------- | -------------- |
| WP-0038     | Define policy rule model        | Stage 6        |
| WP-0039     | Add built-in policy bundle      | Stage 6        |
| WP-0040     | Implement policy check          | Stage 6        |
| WP-0041     | Implement policy explain        | Stage 6        |
| WP-0042     | Define waiver model             | Stage 6        |
| WP-0043     | Add waiver expiration and audit | Stage 6        |

## EPIC-0009: Native Tool Coordination

| Work Packet | Summary                    | Earliest Stage |
| ----------- | -------------------------- | -------------- |
| WP-0044     | Detect native tools        | Stage 2/3      |
| WP-0045     | Add Cargo adapter          | Stage 3        |
| WP-0046     | Add Bun/Node adapter       | Stage 3/5      |
| WP-0047     | Add Moon/Turborepo adapter | Stage 5        |
| WP-0048     | Add Git adapter            | Stage 2/3      |
| WP-0049     | Add CI adapter foundation  | Stage 6/7      |

## EPIC-0010: Release and Change Lifecycle

| Work Packet | Summary                           | Earliest Stage |
| ----------- | --------------------------------- | -------------- |
| WP-0050     | Define release plan               | Stage 7        |
| WP-0051     | Implement release readiness check | Stage 7        |
| WP-0052     | Generate changelog                | Stage 7        |
| WP-0053     | Enforce versioning strategy       | Stage 7        |
| WP-0054     | Generate release evidence report  | Stage 7        |

## EPIC-0011: Advanced Graph and Query Layer

| Work Packet | Summary                       | Earliest Stage |
| ----------- | ----------------------------- | -------------- |
| WP-0055     | Define graph node/edge schema | Stage 8        |
| WP-0056     | Export graph JSON             | Stage 8        |
| WP-0057     | Export Mermaid and DOT        | Stage 8        |
| WP-0058     | Add graph query v0            | Stage 8        |
| WP-0059     | Add local graph cache         | Stage 8        |
| WP-0060     | Add graph consistency checks  | Stage 8        |

## EPIC-0012: AI-Assisted but AI-Optional Workflows

| Work Packet | Summary                          | Earliest Stage |
| ----------- | -------------------------------- | -------------- |
| WP-0061     | Define AI provider port          | Stage 9        |
| WP-0062     | Implement noop AI adapter        | Stage 9        |
| WP-0063     | Define prompt template model     | Stage 9        |
| WP-0064     | Add AI-assisted ADR drafting     | Stage 9        |
| WP-0065     | Add AI-assisted plan explanation | Stage 9        |
| WP-0066     | Add AI-suggested plan creation   | Stage 9        |
| WP-0067     | Add AI safety and audit controls | Stage 9        |

## EPIC-0013: Optional Hosted Control Plane

| Work Packet | Summary                          | Earliest Stage |
| ----------- | -------------------------------- | -------------- |
| WP-0068     | Define hosted architecture       | Stage 10       |
| WP-0069     | Add repo metadata sync           | Stage 10       |
| WP-0070     | Define organization/team model   | Stage 10       |
| WP-0071     | Add graph dashboard              | Stage 10       |
| WP-0072     | Add policy compliance dashboard  | Stage 10       |
| WP-0073     | Add release governance dashboard | Stage 10       |
| WP-0074     | Add hosted audit evidence        | Stage 10       |

---

# 15.25 Recommended Near-Term Layer Boundary

The current phase should stop treating new feature work as Layer 0002 hotfixes.

Recommended boundary:

```text id="lhj3kb"
Layer 0002: Rust workspace and CLI skeleton stabilization
Layer 0003: read-only lifecycle commands
Layer 0004: plan-backed repository mutation engine
```

This boundary is important because the project has moved beyond repairing the Rust skeleton. New work should now be treated as staged product implementation, not as continuing hotfixes against the bootstrap layer.

---

## 15.26 Layer 0002 Completion Criteria

Layer 0002 is complete when:

* Rust workspace compiles,
* CLI library/binary split is stable,
* command catalog exists,
* Clap command surface matches catalog,
* placeholders are honest,
* current smoke tests pass,
* no mutating command performs unsafe writes.

Validation commands:

```bash id="xwmefz"
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
cargo test -p monad-cli --test command_catalog_contract
```

If these are green, the project should move forward rather than continuing to add feature work as hotfixes.

---

## 15.27 Layer 0003 Entry Criteria

Layer 0003 can begin when:

* command catalog contract is green,
* `config list` and other known catalog commands are exposed,
* command placeholder behavior is stable,
* tests confirm catalog/CLI alignment,
* command metadata can distinguish read-only, dry-run, planned, and mutating behavior.

---

## 15.28 Layer 0003 Scope

Layer 0003 should implement read-only or dry-run lifecycle commands:

```text id="u19xfw"
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

Layer 0003 should not introduce general-purpose mutation.

Allowed behavior:

* read files,
* inspect repository state,
* emit findings,
* emit reports,
* emit plans or previews,
* write output only when explicitly requested,
* write generated reports only to configured/generated locations.

Disallowed behavior:

* silently creating source files,
* modifying canonical docs without plan,
* deleting files,
* installing packs,
* executing untrusted plugins,
* calling AI providers by default,
* requiring network.

---

## 15.29 Layer 0004 Entry Criteria

Layer 0004 can begin when:

* read-only lifecycle commands are useful,
* dry-run patterns are established,
* output/report models exist,
* findings are stable enough,
* docs/context/governance workflows expose realistic mutation needs,
* and mutation safety tests are written or clearly specified.

---

## 15.30 Layer 0004 Scope

Layer 0004 should implement the plan-backed mutation engine:

```text id="s0z99x"
plan schema
plan creation
dry-run apply
approved apply
file operation model
rollback hints
policy gate integration
```

Only after Layer 0004 should commands like these become real mutators:

```text id="ybc2t9"
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

## 15.31 Sequencing Rules

The roadmap should enforce these sequencing rules.

### 15.31.1 No Generator Before Plan

A generator may preview output before the plan engine exists, but it should not perform real writes as its primary behavior.

### 15.31.2 No AI Mutation Before Plan and Policy

AI-suggested changes must not become applyable until deterministic plan validation and policy gates exist.

### 15.31.3 No Hosted Control Plane Before Local Evidence

Hosted dashboards should not exist before local reports, graph outputs, policy outputs, and release evidence exist.

### 15.31.4 No Plugin Execution Before Template and Pack Safety

Plugins should not be introduced before template metadata, pack metadata, signature/verification posture, and plan-backed apply patterns are mature.

### 15.31.5 No Enforcement Before Explanation

Policy enforcement should not become strict before policy explanations, remediation hints, and waiver paths exist.

### 15.31.6 No Cache as Source of Truth

Graph caches, context caches, or local indexes must not become canonical state.

### 15.31.7 No Silent Network

Any network-enabled roadmap item must remain explicit and opt-in.

---

## 15.32 Roadmap Dependency Map

High-level dependencies:

```text id="7gk0kd"
Command catalog
  -> Clap contract
  -> placeholder honesty
  -> stable CLI surface

Manifest model
  -> workspace root detection
  -> inspection
  -> check
  -> doctor
  -> graph

Inspection
  -> check
  -> doctor
  -> graph
  -> docs check
  -> context handoff
  -> policy check

Findings/output model
  -> check
  -> doctor
  -> docs check
  -> policy check
  -> reports
  -> release readiness

Context model
  -> context handoff
  -> context pack
  -> AI-assisted planning

Plan model
  -> dry-run apply
  -> approved apply
  -> generators
  -> packs
  -> AI-suggested plans

Policy model
  -> policy check
  -> plan policy gate
  -> release readiness
  -> hosted compliance dashboard

Graph model
  -> graph export
  -> graph query
  -> AI context enrichment
  -> hosted graph dashboard
```

This dependency map should be used to reject out-of-order work.

---

## 15.33 Roadmap Governance

The roadmap should be governed as a living artifact.

### 15.33.1 Change Control

Changes to the roadmap should happen when:

* implementation discovers a false assumption,
* a work packet is too large,
* a dependency is missing,
* a risk becomes material,
* a better sequencing option appears,
* user needs change,
* or a planned feature proves unnecessary.

Roadmap changes should be documented through:

* Git commit,
* PR description,
* ADR if architectural,
* work-packet update if implementation-level,
* changelog or planning note if user-visible.

### 15.33.2 Work Packet Splitting

A work packet should be split when:

* it cannot be tested as one unit,
* it mixes read-only and mutating behavior,
* it crosses too many bounded contexts,
* it requires multiple independent acceptance criteria,
* it introduces unrelated risks,
* or it cannot be safely rolled back.

### 15.33.3 Work Packet Deferral

A work packet should be deferred when:

* prerequisites are missing,
* it requires hosted infrastructure too early,
* it depends on AI before deterministic behavior exists,
* it introduces unsafe mutation,
* it does not support the MVP/v1 thesis,
* or it increases operational complexity without near-term user value.

---

## 15.34 Testing Expectations by Roadmap Stage

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

## 15.35 Documentation Expectations by Roadmap Stage

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

## 15.36 Roadmap Risks

### 15.36.1 Scope Expansion Risk

Risk:

Monad’s large vision may cause too many features to be attempted before the core is stable.

Mitigation:

* enforce maturity stages,
* preserve v1 non-goals,
* keep work packets small,
* defer hosted/AI/plugin work.

### 15.36.2 Mutation Safety Risk

Risk:

Generators or commands may write files before plan/apply safety exists.

Mitigation:

* plan-backed-before-mutation rule,
* dry-run first,
* mutation safety tests,
* apply reports.

### 15.36.3 Command Drift Risk

Risk:

Command catalog, CLI surface, docs, and tests may drift.

Mitigation:

* command contract tests,
* example command validation,
* placeholder honesty,
* docs checks.

### 15.36.4 Roadmap Staleness Risk

Risk:

The roadmap may become outdated as implementation changes.

Mitigation:

* update work packets with implementation,
* treat roadmap as living artifact,
* add ADRs for major changes.

### 15.36.5 AI Prematurity Risk

Risk:

AI features may be introduced before deterministic context, plans, and policy.

Mitigation:

* AI deferred to Stage 9,
* noop adapter first,
* no automatic apply,
* AI output classified as advisory/plan candidate.

### 15.36.6 Hosted Prematurity Risk

Risk:

Hosted control plane may pull the product away from local CLI value.

Mitigation:

* hosted deferred to Stage 10/v2,
* local reports/evidence first,
* no hosted dependency for core commands.

### 15.36.7 Plugin Prematurity Risk

Risk:

Plugins may introduce security and stability risks before the extension model is mature.

Mitigation:

* templates before plugins,
* packs before arbitrary code,
* plan-backed apply,
* signature/verification posture later.

---

## 15.37 Roadmap Fitness Functions

The roadmap should be evaluated against these fitness functions.

1. **Local-first remains true**

   No stage before v2 requires hosted infrastructure.

2. **Read-only precedes mutation**

   Repository understanding commands exist before mutation commands.

3. **Plan-backed mutation precedes generators**

   Generators do not write directly before plan/apply safety exists.

4. **AI remains optional**

   No core command requires AI credentials.

5. **Network remains explicit**

   No core roadmap stage introduces hidden network calls.

6. **Command contracts stay green**

   Command catalog and Clap surface remain aligned.

7. **Source-of-truth rules are stable**

   `monad.toml`, `workspace.toml`, `monad.lock`, and `.monad/` roles remain clear.

8. **Testing keeps pace with features**

   Each work packet includes relevant tests.

9. **Documentation keeps pace with features**

   Each user-visible behavior is documented.

10. **Hosted work is deferred**

Hosted control plane remains optional and later-stage.

11. **Mutation is auditable**

Plans, dry-runs, applies, and reports exist before broad mutation.

12. **Lifecycle graph matures incrementally**

Graph v0 comes before graph persistence, query, cache, or hosted dashboard.

---

## 15.38 Recommended Immediate Next Steps

Given the current project state, the recommended next steps are:

1. Treat Rust workspace and CLI skeleton stabilization as complete only when current tests are green.
2. Stop adding new feature behavior as Layer 0002 hotfixes.
3. Confirm command catalog and Clap surface alignment.
4. Confirm placeholder honesty.
5. Move into Layer 0003 read-only lifecycle commands.
6. Prioritize commands that deepen local repository understanding.
7. Add fixture repositories before adding deep command behavior.
8. Add read-only no-mutation tests.
9. Implement docs/context/governance commands as read-only or dry-run first.
10. Defer real mutation until Layer 0004 plan engine.

Recommended first Layer 0003 candidates:

```text id="if0ntb"
docs check
adr list
workpacket list
context handoff
policy check, initially lightweight
template list, metadata-only
release plan --dry-run
```

---

## 15.39 Early Non-Goals

The near-term roadmap does not include:

* hosted backend,
* mandatory AI provider,
* required database,
* Kubernetes deployment,
* enterprise SSO,
* real-time collaboration,
* autonomous agents,
* plugin marketplace,
* full visual dashboard,
* multi-repo fleet governance,
* graph database,
* local daemon,
* telemetry pipeline,
* cloud sync,
* remote execution,
* broad mutating generators before plan/apply.

These are not rejected forever. They are deferred until the local control plane is trustworthy.

---

## 15.40 Open Questions

The following questions should remain open until implementation pressure justifies decisions.

1. Should version numbers map strictly to stages, or can stages span multiple versions?

2. Should work packets become first-class files under `docs/work-packets/` with machine-readable metadata?

3. Should roadmap status be tracked in `monad.toml`, Markdown, or both?

4. Should Monad eventually validate its own roadmap through `monad workpacket check`?

5. What is the minimum command set required for v0.2?

6. What is the minimum command set required for MVP?

7. Should `monad graph` be MVP or v1 if early graph semantics are too unstable?

8. Should policy check begin as built-in rules before custom policy files exist?

9. Should context handoff precede docs/ADR/work-packet commands, or depend on them?

10. Should `docs generate --dry-run` emit a plan before the formal plan engine exists?

11. Which commands should support JSON output first?

12. How strict should CI mode be before policy waivers exist?

13. What mutation operations are safe enough for the first approved apply?

14. Should templates be allowed before the full pack model?

15. When should native adapters move from detection to delegation?

16. What evidence is required before declaring v1 stable?

17. What user pain would justify v2 hosted control plane work?

18. What user pain would justify AI features before v1.2?

---

## 15.41 Section Acceptance Criteria

This section is successful if a reader understands that:

1. Monad must be built in disciplined layers.
2. The implementation order is part of the product strategy.
3. Local trust comes before hosted capability.
4. Read-only repository understanding comes before mutation.
5. Plan-backed mutation comes before generators.
6. Deterministic behavior comes before AI assistance.
7. Source-of-truth rules come before automation.
8. Command contracts come before command depth.
9. Graph foundations come before graph persistence.
10. Policy checks come before strict policy enforcement.
11. Templates come before plugins.
12. Solo-developer usability comes before enterprise extensibility.
13. MVP is about repository understanding, validation, graphing, docs, context, and safe planning.
14. v1 is a stable local-first Monad OS core, not a hosted SaaS.
15. v2 is the appropriate horizon for optional hosted/team/fleet control plane work.
16. The roadmap hierarchy is `Epic → Work Packet → Layer → Task`.
17. Work packets must include scope, tests, docs, risks, and acceptance criteria.
18. The current project should move from Layer 0002 stabilization into Layer 0003 read-only lifecycle commands once command contracts are green.
19. Layer 0004 should introduce the plan-backed mutation engine.
20. Broad mutating commands should not become real mutators until after the plan/apply model exists.

The final roadmap rule is:

> Monad should advance only through increments that preserve trust: compile, expose honestly, inspect safely, validate deterministically, document clearly, graph coherently, plan visibly, apply cautiously, extend safely, assist optionally, and host only when local value is proven.
