# 22. Execution Plan

## 22.1 Purpose of This Section

This section defines the execution plan for Monad OS / Monad CLI.

Monad is intended to become a local-first, governance-grade, AI-ready but AI-optional SDLC control plane and monorepo operating system. The first runtime surface is the Rust single-binary CLI named `monad`.

The purpose of this execution plan is to convert Monad’s product strategy, architecture doctrine, risk register, governance model, work packet roadmap, and traceability model into a practical delivery sequence.

The execution plan answers:

```text id="mlre6v"
What should be built first?
What should be deferred?
What must not be built yet?
What gates prove readiness?
What risks constrain sequencing?
What can happen in parallel?
How should a solo developer execute without losing control?
```

This plan is intentionally staged.

Monad should not attempt to become a full generator, AI coding assistant, hosted dashboard, plugin marketplace, graph database, policy engine, and enterprise control plane all at once.

The correct execution strategy is:

```text id="fr61lg"
trustworthy CLI foundation
  -> read-only repository understanding
    -> docs/governance/context lifecycle
      -> lifecycle graph v0
        -> plan-backed mutation
          -> templates and safe generators
            -> policy and release governance
              -> AI assistance
                -> optional hosted control plane
```

The key principle is that every stage should increase trust before increasing power.

---

## 22.2 Execution Doctrine

The execution plan is governed by the following doctrine:

```text id="yyfz4b"
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

This doctrine is not merely philosophical. It determines implementation order.

It means:

* do not build hosted features before the local CLI is useful,
* do not add AI provider calls before deterministic context exists,
* do not add mutating commands before read-only commands are trustworthy,
* do not add generators before plan/apply exists,
* do not automate repository changes before source-of-truth rules are stable,
* do not deepen command behavior while the command catalog and Clap surface drift,
* do not add graph persistence before graph v0 is useful,
* do not enforce policies before policy findings are explainable,
* do not add plugins before templates and packs have a trust model,
* and do not design only for enterprise workflows before the solo-developer flow works.

The execution plan should be treated as a roadmap guardrail.

If a future task violates the execution doctrine, it should be deferred, reframed, or converted into an explicit ADR.

---

## 22.3 Current Execution Context

The current project is:

```text id="pbssff"
Repository: monad-cli
Runtime: Rust
Binary: monad
Product: Monad OS / Monad CLI
Initial surface: local CLI
Primary near-term goal: trustworthy read-only control plane foundation
```

The current implementation stage is early.

The immediate execution concern is not broad feature development. It is trust stabilization.

The near-term implementation must focus on:

* Rust workspace stability,
* CLI library/binary split,
* command catalog completeness,
* Clap surface alignment,
* placeholder honesty,
* config subcommand availability,
* help/version/list output stability,
* source-of-truth clarity,
* smoke tests,
* command contract tests,
* and documentation alignment.

The current class of failure already observed was command catalog and CLI surface drift, specifically a catalog command such as `config list` not being represented in the Clap command tree.

That kind of failure is strategically important.

It proves that before Monad can inspect, govern, graph, plan, or mutate repositories, it must govern itself.

---

## 22.4 Execution Horizons

Monad’s execution should be organized into horizons.

| Horizon        | Primary Objective                                               | Product Maturity                          |
| -------------- | --------------------------------------------------------------- | ----------------------------------------- |
| First 30 Days  | Stabilize CLI foundation and command catalog contract           | Trustworthy shell                         |
| First 60 Days  | Make Monad useful as a read-only repository understanding tool  | Useful local inspection                   |
| First 90 Days  | Make docs, governance, and context first-class                  | Governed local repository lifecycle       |
| First 6 Months | Add plan-backed mutation foundation                             | Safe evolution engine                     |
| First Year     | Reach stable local-first Monad OS core                          | Local governance-grade SDLC control plane |
| Post Local v1  | Add optional AI, hosted, ecosystem, and enterprise capabilities | Extensible platform                       |

The timeline is directional, not a rigid calendar commitment.

The ordering matters more than the exact dates.

If a foundational layer takes longer, later layers should not be rushed by bypassing trust gates.

---

## 22.5 First 30 Days: CLI Foundation and Command Contract Stabilization

### 22.5.1 Primary Objective

The primary objective for the first 30 days is:

> Stabilize the CLI foundation and command catalog contract.

Monad must first become a trustworthy CLI.

Before users trust Monad to inspect or evolve repositories, they must be able to trust that:

* the help output is accurate,
* the command catalog is honest,
* documented commands exist,
* planned commands do not pretend to be implemented,
* placeholders are explicit,
* command status is visible,
* read-only commands do not mutate files,
* and contract tests prevent command drift.

### 22.5.2 Build Scope

Build:

* command catalog completeness,
* Clap surface alignment,
* placeholder honesty,
* config subcommands,
* version/list/help stability,
* initial documentation updates,
* smoke test reliability,
* command contract tests,
* basic output conventions,
* basic exit code conventions,
* and minimal command metadata.

### 22.5.3 Recommended Work Packets

```text id="7i7wfk"
WP-0004 Command Catalog Model
WP-0005 Clap Surface Contract
WP-0006 Placeholder Honesty
WP-0007 CLI Output and Exit Codes
```

### 22.5.4 Required Behaviors

The first 30-day milestone should ensure:

* `monad --help` works,
* `monad version` works,
* command listing works,
* command catalog can be inspected by tests,
* the Clap command tree matches catalog expectations,
* nested commands such as `config list` exist if they are cataloged,
* placeholders clearly identify themselves,
* placeholders do not perform unsafe writes,
* smoke tests pass,
* and command output is stable enough for snapshots where appropriate.

### 22.5.5 Quality Gates

Minimum quality gate:

```bash id="bya9ub"
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
```

Near-term stronger gate:

```bash id="jtmieo"
cargo clippy --workspace --all-targets -- -D warnings
cargo test -p monad-cli --test command_catalog_contract
```

### 22.5.6 Acceptance Criteria

The first 30-day milestone is complete when:

* the Rust workspace compiles,
* CLI smoke tests pass,
* command catalog exists,
* Clap command tree matches the catalog for exposed commands,
* planned commands are not falsely represented as implemented,
* mutating behavior is either absent or safely declared as placeholder/dry-run only,
* config/source-of-truth commands have honest behavior,
* help/list/version behavior is stable,
* and documentation reflects the actual command surface.

### 22.5.7 Risks Controlled

Primary risks addressed:

* R-001 Scope explosion from huge command surface,
* R-002 Too many placeholders reduce trust,
* R-005 `monad.toml` and `workspace.toml` drift,
* R-010 CLI output changes break users/CI,
* R-013 Rust crate boundaries become premature,
* R-020 Solo developer process becomes too heavy.

### 22.5.8 What Not to Do in This Horizon

Do not build:

* generators,
* plugins,
* AI provider integrations,
* hosted dashboards,
* graph persistence,
* pack registry,
* complex policy engine,
* plan-backed mutation engine,
* or broad native tool orchestration.

The CLI foundation must become trustworthy before deeper features are layered on top.

---

## 22.6 First 60 Days: Read-Only Repository Understanding

### 22.6.1 Primary Objective

The primary objective for the first 60 days is:

> Make Monad useful as a read-only repository understanding tool.

This is the first point where Monad should become directly useful beyond being a trustworthy command shell.

The user should be able to run Monad in a repository and get meaningful answers about the repository without risking changes.

### 22.6.2 Build Scope

Build:

* workspace root detection,
* canonical manifest resolution,
* compatibility manifest handling,
* `monad inspect`,
* `monad check`,
* `monad doctor`,
* initial findings model,
* initial lifecycle graph model,
* fixture repositories,
* read-only safety tests,
* and structured output foundations.

### 22.6.3 Recommended Work Packets

```text id="cllojl"
WP-0008 Workspace Root Detection
WP-0009 Repository Inspection Engine
WP-0010 Baseline Check Engine
WP-0011 Doctor Diagnostics
WP-0012 Lifecycle Graph v0
```

### 22.6.4 Required Behaviors

The first 60-day milestone should enable Monad to:

* locate the workspace root,
* identify `monad.toml`,
* identify `workspace.toml` as compatibility mirror,
* detect source-of-truth drift,
* inspect repository layout,
* identify important docs,
* identify known manifests,
* produce baseline findings,
* distinguish errors from warnings,
* provide human-readable diagnostics,
* optionally produce JSON output for selected commands,
* and construct a simple derived lifecycle graph.

### 22.6.5 Read-Only Safety Rule

All commands in this horizon should be read-only.

The core rule:

```text id="smq7w4"
Read-only commands must not create, modify, or delete canonical repository files.
```

This should be proven with fixture tests or filesystem mutation tests.

### 22.6.6 `monad inspect`

`monad inspect` should answer:

* What repository am I in?
* Where is the workspace root?
* Which Monad manifest exists?
* Which native manifests exist?
* What major directories exist?
* Which docs/governance files are present?
* Which obvious repository capabilities can be inferred?

Early `inspect` should not attempt to deeply understand every language ecosystem. It should start with stable, testable detection.

### 22.6.7 `monad check`

`monad check` should answer:

* Is the repository structurally coherent?
* Are required source-of-truth files present?
* Are manifests conflicting?
* Are docs missing?
* Are known governance files missing?
* Are there obvious policy or baseline issues?

Early `check` should be deterministic and conservative.

### 22.6.8 `monad doctor`

`monad doctor` should answer:

* What is wrong?
* Why does it matter?
* How can it be fixed?
* Which checks passed?
* Which checks failed?
* Which checks are warnings only?

Doctor output should be explanatory, not merely pass/fail.

### 22.6.9 Lifecycle Graph v0

The initial lifecycle graph should remain simple.

It may include nodes such as:

* repository,
* workspace,
* manifests,
* packages,
* docs,
* ADRs,
* work packets,
* policies,
* commands,
* tests,
* and native tools.

It may include edges such as:

* contains,
* configures,
* documents,
* tests,
* implements,
* governs,
* depends-on,
* and relates-to.

Graph v0 should be derived from repository files and should not require persistence.

### 22.6.10 Acceptance Criteria

The first 60-day milestone is complete when:

* workspace root detection works across fixtures,
* manifest resolution is deterministic,
* `monad.toml` wins over `workspace.toml`,
* source-of-truth drift is reported,
* inspect/check/doctor commands are useful and read-only,
* lifecycle graph v0 exists as derived data,
* fixture integration tests prove behavior,
* and docs explain the read-only command model.

### 22.6.11 Risks Controlled

Primary risks addressed:

* R-003 Unsafe mutation damages repos,
* R-005 Manifest drift,
* R-006 Monad tries to replace too many native tools,
* R-007 Lifecycle graph becomes too complex too early,
* R-010 CLI output changes break users/CI,
* R-011 Documentation becomes stale,
* R-014 Native tool adapter behavior inconsistent,
* R-017 Graph/cache data treated as source of truth.

---

## 22.7 First 90 Days: Documentation, Governance, and Context

### 22.7.1 Primary Objective

The primary objective for the first 90 days is:

> Make docs, governance, and context first-class.

At this stage, Monad should begin proving its core product thesis:

A repository can become a governed lifecycle system whose decisions, documentation, work, risks, and context are inspectable through a local control plane.

### 22.7.2 Build Scope

Build:

* `monad docs check`,
* `monad adr list`,
* `monad adr check` if feasible,
* `monad workpacket list`,
* `monad workpacket check` if feasible,
* `monad context handoff`,
* context redaction,
* docs/governance fixture tests,
* ADR index validation,
* work packet validation,
* risk register validation if feasible,
* and basic traceability validation if feasible.

### 22.7.3 Recommended Work Packets

```text id="ihykzw"
WP-0014 Docs Check
WP-0016 ADR List and Validation
WP-0018 Work Packet List and Validation
WP-0020 Context Model
WP-0021 Handoff Generator
WP-0023 Context Redaction and Safety
```

### 22.7.4 Required Behaviors

The first 90-day milestone should enable Monad to:

* check required documentation files,
* validate ADR presence and index consistency,
* list ADRs and statuses,
* list work packets and statuses,
* validate basic work packet shape,
* generate a local handoff document,
* exclude secrets and ignored files from context,
* explain what context was included,
* explain what context was excluded,
* and provide deterministic local context without AI dependency.

### 22.7.5 Documentation Check

`monad docs check` should eventually validate:

* required docs exist,
* required sections exist,
* ADR index matches ADR files,
* command docs match command catalog,
* work packet references are valid,
* risk register IDs are valid,
* broken links are detected,
* and stale markers are reported.

Early docs check should be useful but not overly noisy.

### 22.7.6 ADR Lifecycle

`monad adr list` should provide a local view of architecture decisions.

Possible output fields:

* ADR ID,
* title,
* status,
* file path,
* related risks,
* related work packets,
* and supersession status.

### 22.7.7 Work Packet Lifecycle

`monad workpacket list` should provide a local view of implementation planning.

Possible output fields:

* work packet ID,
* title,
* status,
* related epic,
* related risks,
* related ADRs,
* and acceptance status.

### 22.7.8 Context Handoff

`monad context handoff` should generate a local handoff artifact that helps future humans or AI-assisted sessions understand the repository.

It should include:

* product summary,
* current implementation status,
* source-of-truth files,
* recent work packets,
* relevant ADRs,
* risks,
* command surface state,
* tests,
* known failures,
* and recommended next action.

It must not silently call an AI provider.

It must not include secrets.

It must clearly distinguish generated summary from canonical truth.

### 22.7.9 Context Redaction

Context redaction must be treated as security-sensitive.

Context commands should:

* respect `.gitignore`,
* support `.monadignore` eventually,
* exclude known secret files,
* scan for secret-like values,
* redact sensitive values,
* include redaction metadata,
* and be tested with security fixtures.

### 22.7.10 Acceptance Criteria

The first 90-day milestone is complete when:

* docs check has useful read-only validation,
* ADR listing works,
* work packet listing works,
* context handoff generation works locally,
* context redaction is tested,
* no AI provider is required,
* generated context includes provenance metadata,
* and docs explain the governance/context lifecycle.

### 22.7.11 Risks Controlled

Primary risks addressed:

* R-004 Secret leakage into context packs,
* R-008 AI features undermine deterministic trust,
* R-011 Documentation becomes stale,
* R-012 Work packet process becomes bureaucratic,
* R-016 Hard-to-explain product category,
* R-017 Graph/cache data treated as source of truth,
* R-020 Solo developer process becomes too heavy.

---

## 22.8 First 6 Months: Plan-Backed Mutation Foundation

### 22.8.1 Primary Objective

The primary objective for the first 6 months is:

> Add the plan-backed mutation foundation.

This is the point where Monad begins to safely evolve repositories.

Before this horizon, Monad should primarily understand, validate, explain, document, and generate local context. In this horizon, Monad begins preparing and applying controlled changes.

### 22.8.2 Build Scope

Build:

* plan schema,
* plan domain model,
* plan validation,
* plan creation for docs,
* plan creation for ADRs,
* plan creation for work packets,
* dry-run apply,
* approved apply for low-risk operations,
* apply reports,
* rollback hints,
* file operation model,
* preflight checks,
* conflict detection,
* and policy evaluation for plans.

### 22.8.3 Recommended Work Packets

```text id="8asqkt"
WP-0025 Plan Schema and Domain Model
WP-0026 Plan Creation for Documentation Artifacts
WP-0027 Dry-Run Apply Engine
WP-0028 Apply Engine with Approval
WP-0029 Rollback Hints and Apply Reports
WP-0030 Plan Policy Evaluation
```

### 22.8.4 Required Mutation Model

The mature mutation flow is:

```bash id="pui1rv"
monad plan ...
monad apply plan.json --dry-run
monad apply plan.json --yes
```

No risky mutating workflow should bypass this model.

### 22.8.5 Plan Schema

A plan should describe:

* plan ID,
* plan schema version,
* plan producer,
* created timestamp,
* workspace root,
* preconditions,
* file operations,
* expected changes,
* affected files,
* affected docs,
* related risks,
* related work packets,
* policy findings,
* rollback hints,
* and approval requirements.

### 22.8.6 File Operation Model

Initial file operations may include:

* create file,
* update file,
* delete file,
* rename file,
* copy file,
* create directory,
* and no-op/report-only operation.

Each file operation should specify:

* path,
* operation type,
* expected prior state,
* content hash where appropriate,
* overwrite behavior,
* risk level,
* and rollback hint.

### 22.8.7 Dry-Run Apply

Dry-run must not mutate canonical repository files.

Dry-run should:

* validate the plan,
* check preconditions,
* simulate file operations,
* report conflicts,
* report policy findings,
* and produce a clear summary.

### 22.8.8 Approved Apply

Approved apply should:

* require explicit approval,
* validate the plan again,
* check file state before writing,
* write only planned files,
* avoid writes outside workspace root,
* produce an apply report,
* and report partial failures honestly.

Early apply should support only low-risk operations.

High-risk operations should remain deferred until the safety model is mature.

### 22.8.9 Apply Reports

An apply report should include:

* plan ID,
* operations requested,
* operations applied,
* operations skipped,
* operations failed,
* files changed,
* preflight results,
* policy results,
* warnings,
* rollback hints,
* final status,
* and timestamp.

### 22.8.10 Acceptance Criteria

The first 6-month milestone is complete when:

* plan schema exists,
* plan validation works,
* docs/ADR/work-packet plan creation works,
* dry-run does not write files,
* approved apply writes only planned files,
* apply reports are generated,
* rollback hints exist,
* mutation safety tests pass,
* and docs explain the plan/apply model.

### 22.8.11 Risks Controlled

Primary risks addressed:

* R-003 Unsafe mutation damages repositories,
* R-009 Plugin/packs introduce supply-chain risk,
* R-018 Apply failures leave partial state,
* R-019 Policy false positives frustrate users,
* R-020 Solo developer process becomes too heavy.

---

## 22.9 First Year: Stable Local-First Monad OS Core

### 22.9.1 Primary Objective

The primary objective for the first year is:

> Reach stable local-first Monad OS core.

By this stage, Monad should have a trustworthy local control plane that can understand, validate, document, graph, plan, and safely evolve a repository.

### 22.9.2 Build Scope

Build:

* safe generators,
* core templates,
* pack model,
* policy engine,
* policy explain,
* waiver model,
* native tool adapters,
* release/change lifecycle,
* advanced graph exports,
* JSON schemas,
* stronger CI/release process,
* context verification,
* traceability checks,
* and release readiness checks.

### 22.9.3 Recommended Focus

```text id="jsu70v"
generators after plan/apply
policy after baseline checks
packs after templates
AI after deterministic context
hosted control plane after local v1
```

### 22.9.4 Templates and Generators

Generators should not be direct unsafe writers.

They should produce plans.

Safe generator flow:

```bash id="mlo5cr"
monad generate docs --dry-run
monad plan generate docs
monad apply plan.json --dry-run
monad apply plan.json --yes
```

Early templates should focus on documentation and governance artifacts before complex application scaffolds.

### 22.9.5 Pack Model

Packs should be introduced after templates.

A pack may contain:

* templates,
* policies,
* docs,
* command metadata,
* examples,
* fixtures,
* and recommendations.

Pack install should be previewed through a plan.

Remote pack trust should be deferred until checksum/signature strategy exists.

### 22.9.6 Policy Engine

Policy should evolve in this sequence:

```text id="6ik0mj"
built-in checks
  -> policy explain
    -> severity levels
      -> waivers
        -> waiver expiration
          -> release readiness integration
```

Policy enforcement should not precede policy explainability.

### 22.9.7 Native Tool Adapters

Adapters may include:

* Git adapter,
* Cargo adapter,
* Bun/Node adapter,
* Moon/Turborepo adapter,
* CI adapter foundation.

Adapters should inspect and coordinate. They should not replace native tools.

### 22.9.8 Release Lifecycle

Release commands should help answer:

* Is this release ready?
* What changed?
* What tests passed?
* What policies passed?
* What risks remain?
* What docs changed?
* What artifacts were produced?

Future release commands may include:

```bash id="78wuz8"
monad release plan
monad release readiness
monad release evidence
```

These should begin read-only or dry-run.

### 22.9.9 Acceptance Criteria

The first-year milestone is complete when Monad can locally:

* inspect repository structure,
* validate baseline governance,
* check docs,
* list ADRs and work packets,
* generate safe context handoffs,
* produce lifecycle graph exports,
* create plans,
* dry-run plans,
* apply approved low-risk plans,
* explain policy findings,
* coordinate basic native tool checks,
* and produce release readiness evidence.

### 22.9.10 Risks Controlled

Primary risks addressed:

* R-001 Scope explosion,
* R-003 Unsafe mutation,
* R-006 Native tool replacement risk,
* R-007 Graph complexity,
* R-009 Supply-chain risk,
* R-011 Stale docs,
* R-014 Adapter inconsistency,
* R-018 Partial apply failure,
* R-019 Policy false positives,
* R-020 Solo process heaviness.

---

## 22.10 Post Local v1: Optional AI, Hosted, Ecosystem, and Enterprise Capabilities

### 22.10.1 Primary Objective

After the stable local-first core exists, Monad may expand into optional advanced capabilities.

These should remain additive.

They must not compromise local-first behavior.

### 22.10.2 Candidate Capabilities

Post local v1 capabilities may include:

* AI-assisted ADR drafting,
* AI-assisted plan explanation,
* AI-suggested plan creation,
* local model adapter,
* hosted model adapters,
* pack registry,
* plugin ecosystem,
* optional hosted control plane,
* graph dashboard,
* policy compliance dashboard,
* release governance dashboard,
* organization/team model,
* multi-repo fleet visibility,
* hosted audit evidence,
* enterprise RBAC,
* SSO integration,
* and external GRC integrations.

### 22.10.3 Required Constraints

Before these capabilities are built:

* deterministic context must exist,
* context redaction must be tested,
* plan/apply must be mature,
* policy checks must be explainable,
* pack trust model must exist,
* local graph exports must be useful,
* and release readiness must be meaningful locally.

### 22.10.4 Hosted Rule

The hosted control plane must not become required for:

* `monad inspect`,
* `monad check`,
* `monad doctor`,
* `monad docs check`,
* `monad context handoff`,
* `monad graph`,
* `monad plan`,
* `monad apply --dry-run`,
* or core policy checks.

Hosted features may visualize, synchronize, aggregate, and collaborate. They must not replace local repository truth.

---

## 22.11 What to Build First

Build first:

1. command catalog stability,
2. Clap surface contract,
3. placeholder honesty,
4. config/source-of-truth behavior,
5. output and exit code conventions,
6. workspace root detection,
7. manifest resolution,
8. read-only inspect/check/doctor,
9. docs check,
10. ADR and work packet listing,
11. context handoff,
12. context redaction,
13. graph v0,
14. plan schema,
15. dry-run apply,
16. approved low-risk apply.

This order matters.

Monad should not jump to high-power capabilities while lower-level trust layers are unstable.

---

## 22.12 What to Defer

Defer:

* hosted dashboard,
* plugin marketplace,
* AI provider integrations,
* complex generators,
* graph database,
* multi-cloud hosted deployments,
* enterprise RBAC,
* multi-repo fleet management,
* remote pack registry,
* executable plugin runtime,
* release artifact signing,
* local embedded database,
* and complex policy language.

Deferred does not mean rejected.

It means not yet.

A deferred feature may be correct later, but premature now.

---

## 22.13 What Not to Build Yet

Do not build yet:

* autonomous AI code mutation,
* direct unsafe file-writing commands,
* SaaS-first backend,
* required database,
* Kubernetes-first runtime,
* full replacement for native task/build tools,
* complex plugin runtime before trust model,
* remote code execution,
* AI provider calls without explicit opt-in,
* context upload without redaction,
* mutation without plan/apply,
* graph persistence before graph v0,
* policy enforcement before policy explain,
* hosted sync before local source-of-truth stability.

These items are not merely lower priority. They are actively dangerous if introduced too early.

---

## 22.14 Critical Path

The critical path is:

```text id="ird71x"
command catalog
  -> CLI contract
  -> placeholder honesty
  -> workspace model
  -> manifest resolution
  -> inspect/check/doctor
  -> docs/context/graph
  -> plan schema
  -> dry-run apply
  -> safe apply
  -> templates/generators
  -> policy gates
  -> AI assistance
  -> optional hosted control plane
```

The critical path should be protected.

Parallel work should not distract from the next blocked item on the critical path.

If the critical path fails, pause expansion and stabilize.

Example:

```text id="5khacv"
If command catalog contract fails,
do not continue building graph, policy, AI, or generators.
Fix the contract first.
```

This is not conservatism. It is trust sequencing.

---

## 22.15 Parallelizable Work

Some work can proceed in parallel after CLI foundation is stable.

Parallelizable work:

* docs drafting,
* ADR drafting,
* fixture repo creation,
* output schema design,
* policy rule definitions,
* graph schema design,
* context redaction rules,
* runbooks,
* command reference drafting,
* manifest reference drafting,
* risk register refinement,
* traceability matrix refinement,
* examples and sample repos,
* test fixture planning,
* and release checklist drafting.

Parallel work must not introduce implementation dependencies that bypass the critical path.

Safe parallel work is usually:

* documentation,
* design,
* fixtures,
* tests,
* examples,
* and schema drafts.

Risky parallel work is usually:

* mutation,
* plugins,
* hosted sync,
* AI providers,
* remote registries,
* and executable automation.

---

## 22.16 Layering Model

Execution should proceed through small layers.

A layer is a small, testable increment that can be applied, verified, and committed.

A good layer:

* has a clear goal,
* touches a limited file set,
* can be tested quickly,
* does not mix unrelated concerns,
* has rollback clarity,
* updates docs if behavior changes,
* and leaves the repo greener or more coherent than before.

A poor layer:

* changes many unrelated systems,
* combines architecture, behavior, docs, and formatting unpredictably,
* introduces failing tests without resolution,
* adds large placeholders without metadata,
* writes fragile shell scripts,
* or creates future abstractions without current behavior.

Recommended layer loop:

```text id="zt8568"
choose work packet
  -> define small layer
    -> make change
      -> run tests
        -> update docs
          -> review risks
            -> commit
```

---

## 22.17 Solo Developer Strategy

For solo development:

* use small work packets,
* avoid fragile shell scripts,
* prefer manual file-save patches when needed,
* keep tests green after every layer,
* stop and stabilize when contracts fail,
* commit after each green layer,
* do not build hosted features early,
* minimize context switching,
* avoid premature crate extraction,
* avoid large multi-feature changes,
* and use handoff documents when changing sessions.

The solo developer strategy is not a weaker governance model. It is the proving ground for Monad’s governance model.

The rule is:

```text id="p6az39"
If Monad’s process is too heavy for one serious developer, it is not ready to scale to teams.
```

### 22.17.1 Recommended Solo Loop

```text id="a8dug5"
1. Pick one work packet.
2. Pick one layer inside that work packet.
3. Make the smallest useful change.
4. Run fmt/check/test.
5. Fix failures immediately.
6. Update docs if behavior changed.
7. Commit.
8. Generate or update handoff context.
```

### 22.17.2 When to Stop and Stabilize

Stop feature work and stabilize when:

* `cargo check` fails,
* smoke tests fail,
* command contract tests fail,
* command catalog and Clap surface drift,
* placeholders become misleading,
* docs contradict implementation,
* manifest source-of-truth behavior is unclear,
* or a mutating command appears without plan/apply.

---

## 22.18 Execution Gates by Layer

### 22.18.1 Foundation Gate

Before moving beyond CLI foundation:

```bash id="u5p550"
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
cargo test -p monad-cli --test command_catalog_contract
```

Required proof:

* CLI compiles,
* command catalog exists,
* Clap surface aligns,
* placeholders are honest,
* no unsafe writes exist.

### 22.18.2 Read-Only Gate

Before moving into plan-backed mutation:

Required proof:

* workspace root detection works,
* manifest resolution works,
* inspect/check/doctor are read-only,
* fixture tests pass,
* docs explain findings,
* source-of-truth drift is detected.

### 22.18.3 Context Gate

Before AI provider integration:

Required proof:

* deterministic context handoff works,
* context redaction works,
* ignored files are excluded,
* context reports explain included/excluded files,
* no provider call is implicit,
* security fixtures pass.

### 22.18.4 Mutation Gate

Before generators become real mutators:

Required proof:

* plan schema exists,
* dry-run does not mutate,
* apply requires approval,
* apply writes only planned files,
* apply reports are generated,
* rollback hints exist,
* mutation safety tests pass.

### 22.18.5 Pack/Plugin Gate

Before remote packs or plugins:

Required proof:

* templates work locally,
* pack metadata exists,
* pack install can be previewed,
* plan/apply governs pack changes,
* checksum/signature strategy is defined,
* executable plugin trust model exists.

### 22.18.6 Hosted Gate

Before hosted control plane:

Required proof:

* local v1 is useful,
* local source of truth is stable,
* graph exports exist,
* release evidence exists,
* policy checks are useful,
* hosted sync model has an ADR,
* local workflows remain available without hosted.

---

## 22.19 Execution Metrics

Monad should measure execution quality using evidence, not vanity metrics.

Useful metrics:

| Metric                            | Why It Matters              |
| --------------------------------- | --------------------------- |
| Passing workspace tests           | Basic implementation health |
| Command catalog coverage          | CLI trust                   |
| Placeholder ratio                 | Product honesty             |
| Read-only command mutation checks | Safety                      |
| Fixture coverage                  | Repository understanding    |
| ADR coverage for major decisions  | Architecture governance     |
| Work packet completion rate       | Delivery clarity            |
| Docs check pass rate              | Documentation health        |
| Risk register review status       | Governance maturity         |
| Context redaction test coverage   | Security                    |
| Plan/apply mutation test coverage | Safety                      |
| Release gate pass rate            | Release readiness           |

Avoid over-optimizing for:

* number of commands,
* number of crates,
* number of generated files,
* number of planning documents,
* number of features claimed,
* or hosted/dashboard capabilities before local usefulness.

---

## 22.20 Recommended Near-Term Implementation Order

The next implementation sequence should remain tightly focused.

### 22.20.1 Immediate Stabilization

1. Confirm command catalog entries.
2. Confirm Clap command tree.
3. Add missing nested command surfaces such as `config list`.
4. Ensure placeholders are honest.
5. Ensure contract tests pass.
6. Ensure smoke tests pass.
7. Commit green state.

### 22.20.2 Source-of-Truth Stabilization

1. Define manifest resolution behavior.
2. Ensure `monad.toml` is canonical.
3. Treat `workspace.toml` as compatibility mirror.
4. Detect drift.
5. Report drift clearly.
6. Add fixture tests.

### 22.20.3 Read-Only Usefulness

1. Implement workspace root detection.
2. Implement repository inspection.
3. Implement baseline checks.
4. Implement doctor explanations.
5. Add JSON output where useful.
6. Add fixture integration tests.

### 22.20.4 Governance Usefulness

1. Implement docs check.
2. Implement ADR list.
3. Implement work packet list.
4. Implement risk list/check if feasible.
5. Implement context handoff.
6. Implement context redaction.

### 22.20.5 Mutation Foundation

1. Define plan schema.
2. Implement plan validation.
3. Implement dry-run apply.
4. Implement approved apply for low-risk docs operations.
5. Add apply reports.
6. Add rollback hints.

---

## 22.21 Roadmap Boundaries

The roadmap should preserve the following boundaries.

### 22.21.1 Layer 0002 Boundary

Layer 0002 should stabilize Rust workspace and CLI skeleton behavior.

Completion criteria:

* Rust workspace compiles,
* CLI library/binary split is stable,
* command catalog exists,
* Clap command surface matches catalog,
* placeholders are honest,
* current smoke tests pass,
* and no mutating command performs unsafe writes.

### 22.21.2 Layer 0003 Boundary

Layer 0003 should focus on read-only lifecycle commands.

Examples:

```text id="xb32vk"
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

Layer 0003 should not introduce direct unsafe mutation.

### 22.21.3 Layer 0004 Boundary

Layer 0004 should introduce plan-backed repository mutation.

Scope:

* plan schema,
* plan creation,
* dry-run apply,
* approved apply,
* file operation model,
* rollback hints,
* apply reports,
* and policy gate integration.

Only after Layer 0004 should commands like these become real mutators:

```text id="sd248y"
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

---

## 22.22 Execution Risks

The execution plan must actively manage these risks.

| Risk                      | Execution Control                             |
| ------------------------- | --------------------------------------------- |
| Scope explosion           | Strict milestones and roadmap gates           |
| Placeholder trust erosion | Placeholder honesty and implementation status |
| Unsafe mutation           | Plan/apply before mutators                    |
| Secret leakage            | Context redaction before AI                   |
| Manifest drift            | Source-of-truth checks                        |
| Native tool replacement   | Adapter boundaries                            |
| Graph complexity          | Graph v0 before persistence                   |
| AI trust erosion          | Deterministic context before providers        |
| Supply-chain risk         | Templates before packs, packs before plugins  |
| CLI breakage              | Output conventions and tests                  |
| Stale docs                | Docs check                                    |
| Bureaucratic work packets | Lightweight templates                         |
| Premature crates          | Extract only when behavior justifies          |
| Partial apply failures    | Apply reports and rollback hints              |
| Solo developer drag       | Small layers and green commits                |

Execution risk should be reviewed at the start and end of each work packet.

---

## 22.23 Definition of Done

A Monad work increment is done only when:

* implementation matches the intended behavior,
* tests pass,
* command catalog is updated if command behavior changed,
* docs are updated if user-visible behavior changed,
* risks are reviewed if safety/security/governance changed,
* ADRs are updated or created if architecture changed,
* output behavior is stable or explicitly marked unstable,
* and the repository is left in a coherent state.

A feature is not done merely because code exists.

A command is not done unless it is:

* documented,
* tested,
* honest about status,
* clear about mutability,
* and aligned with the command catalog.

A mutating workflow is not done unless it is:

* plan-backed,
* dry-run capable,
* approval-gated,
* tested against mutation safety,
* and documented.

---

## 22.24 Release Readiness Model

A release should be considered ready only when the relevant gates pass.

Early release readiness:

```bash id="8of3f3"
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
```

Stronger local release readiness:

```bash id="aumcnc"
cargo clippy --workspace --all-targets -- -D warnings
cargo test -p monad-cli --test command_catalog_contract
```

Future release readiness:

```bash id="vxaw4h"
monad docs check
monad policy check
monad trace check
monad risk check
monad release readiness
```

A release readiness report should eventually include:

* version,
* commit SHA,
* command catalog status,
* implemented commands,
* placeholder commands,
* tests run,
* docs status,
* policy status,
* known risks,
* breaking changes,
* migration notes,
* and artifact checksums.

---

## 22.25 Handoff and Continuity Strategy

Monad development may happen across multiple sessions, machines, or contributors.

Handoff should be treated as part of execution.

A good handoff includes:

* current repo path,
* current branch,
* last green commit,
* commands last run,
* current failing tests if any,
* current work packet,
* current layer,
* files changed,
* docs changed,
* known risks,
* next recommended action,
* and explicit stop point.

Future `monad context handoff` should automate much of this.

Until then, handoff should be maintained manually in Markdown.

The handoff principle:

```text id="dh93ls"
A future session should be able to continue without rediscovering project doctrine, current state, or next action.
```

---

## 22.26 Execution Anti-Patterns

Monad should avoid the following execution anti-patterns.

### 22.26.1 Building Width Before Depth

Adding many command families before any command family is useful.

Mitigation:

* stabilize command catalog,
* keep placeholder count visible,
* prioritize read-only usefulness.

### 22.26.2 Mutation Before Understanding

Adding file-writing commands before inspect/check/doctor are reliable.

Mitigation:

* enforce read-only horizon,
* require plan/apply for mutation.

### 22.26.3 AI Before Context Safety

Adding AI provider integrations before deterministic redacted context exists.

Mitigation:

* build `NoopAiAdapter` first,
* build context packs,
* test redaction.

### 22.26.4 Hosted Before Local

Building dashboards, sync, or SaaS backend before the local CLI is valuable.

Mitigation:

* defer hosted control plane,
* preserve local-first source of truth.

### 22.26.5 Plugin Before Trust

Adding executable extension mechanisms before templates, packs, checksums, signatures, and plan/apply.

Mitigation:

* templates first,
* packs second,
* plugins last.

### 22.26.6 Process Before Product

Creating so much governance that implementation stalls.

Mitigation:

* keep work packets small,
* automate checks gradually,
* optimize for solo-developer usability.

---

## 22.27 Summary Execution Plan

Monad should execute in this order:

```text id="snxjl1"
1. Stabilize the Rust CLI foundation.
2. Align command catalog and Clap surface.
3. Make placeholders honest.
4. Standardize output and exit codes.
5. Implement source-of-truth manifest behavior.
6. Build read-only inspect/check/doctor.
7. Add docs, ADR, work packet, and governance checks.
8. Add deterministic context handoff with redaction.
9. Build lifecycle graph v0.
10. Define plan schema.
11. Implement dry-run apply.
12. Implement approved low-risk apply.
13. Add templates and safe generators through plan/apply.
14. Add policy explain and waivers.
15. Add native tool adapters.
16. Add release readiness and evidence.
17. Add AI assistance only after deterministic context safety.
18. Add hosted control plane only after local v1 is useful.
```

The execution strategy is deliberately conservative about power and aggressive about trust.

Monad should become useful by first becoming honest.

The highest-leverage near-term milestone remains:

```text id="pl2eva"
a green, contract-tested, read-only Monad CLI that can explain a repository honestly
```

Everything else should build on that foundation.
