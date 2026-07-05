# 16. Initial Repository and Documentation Structure

## 16.1 Purpose of This Section

This section defines the initial repository and documentation structure for Monad OS and Monad CLI.

Its purpose is to establish:

* the top-level repository shape,
* the early Rust workspace structure,
* the future crate decomposition path,
* the documentation hierarchy,
* the governance artifact layout,
* the policy layout,
* the fixture and example strategy,
* the CI/CD structure,
* the script/tooling structure,
* the `.monad/` local state boundary,
* and the rules that prevent repository structure from overstating implementation maturity.

Monad’s repository should be more than a place where source code lives. It should demonstrate the product’s core thesis:

> A serious repository should be self-describing, governable, inspectable, auditable, graphable, policy-aware, documentation-aware, and safely evolvable.

The repository structure should therefore make the product model visible.

However, the structure must not become ceremony for its own sake. Empty directories, fake modules, placeholder crates, and unimplemented surfaces should be used carefully. Monad should prefer a structure that is:

* serious,
* expandable,
* honest,
* testable,
* local-first,
* source-of-truth aware,
* and aligned with current maturity.

The early repository should support the current implementation path without pretending that later hosted, AI, plugin, policy, graph-persistence, or enterprise features already exist.

---

## 16.2 Repository Structure Thesis

Monad’s repository structure thesis is:

> The repository should visibly encode Monad’s governance model while remaining small enough for the current local Rust CLI implementation.

The repository should accomplish two things at once.

First, it should support immediate work:

```text id="jz9lid"
Rust CLI
command catalog
tests
planning docs
governance docs
fixtures
CI
```

Second, it should leave clear expansion paths for later:

```text id="pc9ggk"
documentation lifecycle
ADR lifecycle
work-packet lifecycle
context handoff
policy checks
plan/apply engine
templates and packs
release governance
AI-optional workflows
hosted control plane, later
```

The structure should not force all later modules to exist as full crates on day one.

A good structure makes the future visible without making the present heavy.

---

## 16.3 Structural Principles

Monad’s repository and documentation structure should follow these principles.

### 16.3.1 Structure Should Reflect Product Doctrine

The repository should encode:

* `monad.toml` as canonical,
* `workspace.toml` as compatibility mirror only,
* `monad.lock` as resolved state,
* `.monad/` as local/generated/cache state,
* docs as lifecycle artifacts,
* ADRs as decision artifacts,
* work packets as implementation planning artifacts,
* policies as governance artifacts,
* fixtures as behavioral proof,
* examples as user-facing demonstrations.

### 16.3.2 Structure Should Be Honest

Do not create directories, crates, or docs that imply implemented functionality when functionality does not exist.

If planned directories exist, they should be documented as planned.

Example:

```text id="q4z6at"
docs/reference/plan-schema.md may describe planned schema direction,
but it must not claim stable apply behavior before apply exists.
```

### 16.3.3 Structure Should Be Testable

The structure should allow future commands such as:

```bash id="pzmpai"
monad docs check
monad adr list
monad workpacket list
monad policy check
monad context handoff
monad graph
```

to inspect and validate repository artifacts.

### 16.3.4 Structure Should Support Local-First Operation

The repository must not assume:

* hosted backend,
* cloud account,
* AI provider,
* Kubernetes,
* database,
* graph database,
* plugin marketplace,
* local daemon,
* remote telemetry.

Everything necessary for the early CLI should live locally in the repository and the Rust workspace.

### 16.3.5 Structure Should Be Phased

Some structures should exist immediately.

Some should be introduced when their work packet begins.

Some should remain documented future targets.

A phased structure prevents the repo from filling with empty placeholders.

### 16.3.6 Source Files and Generated Files Must Be Separated

Canonical source files should not be mixed with generated local state.

Recommended distinction:

```text id="6txr63"
Canonical source:
  Cargo.toml
  monad.toml
  docs/
  governance/
  policies/
  source code
  fixtures/
  examples/

Resolved state:
  monad.lock
  Cargo.lock

Generated/local state:
  .monad/cache/
  .monad/tmp/
  .monad/reports/
  .monad/graphs/
  .monad/plans/
```

### 16.3.7 Scripts Should Be Optional and Transparent

Scripts may improve convenience, but they should not hide core commands.

Given the user’s terminal constraints and prior heredoc issues, scripts should be:

* optional,
* simple,
* directly executable,
* easy to inspect,
* safe to copy manually,
* and never required when explicit terminal commands are clearer.

Avoid fragile script creation workflows.

---

## 16.4 Recommended Top-Level Repository Structure

Recommended top-level structure:

```text id="qugj9s"
monad-cli/
  Cargo.toml
  Cargo.lock
  monad.toml
  workspace.toml
  monad.lock
  README.md
  CONTRIBUTING.md
  CODE_OF_CONDUCT.md
  SECURITY.md
  SUPPORT.md
  LICENSE
  crates/
  docs/
  governance/
  policies/
  examples/
  fixtures/
  scripts/
  tools/
  tests/
  schemas/
  .github/
  .devcontainer/
  .monad/
  .gitignore
```

### 16.4.1 Top-Level File Responsibilities

| Path                 | Responsibility                                               |
| -------------------- | ------------------------------------------------------------ |
| `Cargo.toml`         | Rust workspace manifest                                      |
| `Cargo.lock`         | Rust dependency lockfile                                     |
| `monad.toml`         | Canonical Monad workspace manifest                           |
| `workspace.toml`     | Compatibility mirror only                                    |
| `monad.lock`         | Monad resolved-state lockfile                                |
| `README.md`          | Primary repository introduction                              |
| `CONTRIBUTING.md`    | Contributor workflow                                         |
| `CODE_OF_CONDUCT.md` | Community conduct expectations                               |
| `SECURITY.md`        | Security reporting and posture                               |
| `SUPPORT.md`         | Support expectations                                         |
| `LICENSE`            | License                                                      |
| `crates/`            | Rust source crates                                           |
| `docs/`              | Product, architecture, user, engineering, and reference docs |
| `governance/`        | Governance artifacts and operational decision records        |
| `policies/`          | Human-readable and future machine-readable policies          |
| `examples/`          | Example repositories/use cases                               |
| `fixtures/`          | Test fixture repositories                                    |
| `scripts/`           | Optional helper scripts                                      |
| `tools/`             | Optional helper tooling                                      |
| `tests/`             | Top-level integration tests if needed                        |
| `schemas/`           | JSON/TOML schema definitions when introduced                 |
| `.github/`           | GitHub workflows/templates/CODEOWNERS                        |
| `.devcontainer/`     | Optional contributor devcontainer                            |
| `.monad/`            | Local generated/cache/report/context state                   |
| `.gitignore`         | Ignore rules, especially for `.monad/` generated state       |

### 16.4.2 Immediate Versus Future Top-Level Directories

Recommended immediate directories:

```text id="tfaocy"
crates/
docs/
governance/
policies/
fixtures/
examples/
scripts/
.github/
```

Recommended near-future directories:

```text id="osqir3"
schemas/
tools/
tests/
.devcontainer/
.monad/
```

Directories should be created when they have a real purpose. If a directory exists before it has content, it should include a `README.md` explaining its purpose and maturity.

---

## 16.5 Canonical Source-of-Truth Files

The top level should make Monad’s source-of-truth hierarchy visible.

### 16.5.1 `monad.toml`

`monad.toml` is canonical.

It should define the repository’s Monad workspace identity and configuration.

It may eventually include:

```toml id="5pmecp"
[workspace]
name = "monad-cli"
type = "rust-cli"

[commands]
catalog = "crates/monad-cli/src/command_catalog.rs"

[docs]
root = "docs"

[governance]
root = "governance"

[policies]
root = "policies"
```

The exact schema should be defined separately in the manifest reference.

### 16.5.2 `workspace.toml`

`workspace.toml` is a compatibility mirror only.

It may exist for compatibility with earlier tooling, previous repo shape, or transitional workflows. It must not supersede `monad.toml`.

If both exist and conflict, Monad should report the conflict and state that `monad.toml` is canonical.

### 16.5.3 `monad.lock`

`monad.lock` records resolved Monad state.

It may eventually include:

* resolved workspace identity,
* resolved command catalog version,
* resolved policy bundle version,
* resolved pack versions,
* schema versions,
* graph/cache metadata,
* resolved native tool assumptions.

`monad.lock` should not become a hidden source of author intent. It records resolved state, not canonical product intent.

### 16.5.4 `.monad/`

`.monad/` stores local generated state, cache, context, reports, plans, temporary files, and inspectable local artifacts.

It is not canonical truth.

---

## 16.6 Source Code Structure Strategy

Monad should use a Rust workspace.

The long-term codebase may decompose into multiple domain-aligned crates, but the immediate repo should avoid premature crate explosion.

The recommended source code strategy has three phases:

```text id="muh17c"
Phase 1: Minimal crate split
Phase 2: Domain crate extraction
Phase 3: Extension crate maturity
```

---

## 16.7 Phase 1 Source Code Structure: Minimal Crate Split

Early Monad should prefer a small, working crate structure.

Recommended near-term structure:

```text id="lkzfzg"
crates/
  monad-cli/
    Cargo.toml
    src/
      main.rs
      lib.rs
      command_catalog.rs
      output.rs
      commands/
        mod.rs
        version.rs
        list.rs
        config.rs
        inspect.rs
        check.rs
        doctor.rs
        graph.rs
        context.rs
        docs.rs
        adr.rs
        workpacket.rs
        policy.rs
        plan.rs
        apply.rs
  monad-core/
    Cargo.toml
    src/
      lib.rs
      workspace.rs
      command.rs
      finding.rs
      error.rs
      format.rs
```

### 16.7.1 `monad-cli`

`monad-cli` owns the executable surface.

Responsibilities:

* `main.rs`,
* Clap command definition,
* command routing,
* CLI output formatting,
* command catalog exposure,
* integration with core/domain crates,
* smoke-testable binary behavior.

`monad-cli` should not become a dumping ground for all domain logic.

### 16.7.2 `monad-core`

`monad-core` owns shared domain primitives.

Responsibilities:

* workspace identity types,
* command metadata types,
* finding model,
* error model,
* output format enums,
* common path helpers,
* shared result types,
* core traits/ports where appropriate.

`monad-core` should avoid depending on CLI-specific code.

### 16.7.3 Early Command Modules

The CLI may include command modules for planned surfaces, but those modules must be honest.

A command module may be:

```text id="x47m8c"
implemented
partially implemented
placeholder
planned only
```

Placeholder commands should not pretend to perform real behavior.

---

## 16.8 Phase 2 Source Code Structure: Domain Crate Extraction

As behavior deepens, domain crates may be extracted.

Candidate future crate structure:

```text id="k48ipu"
crates/
  monad-cli/
  monad-core/
  monad-config/
  monad-inspect/
  monad-graph/
  monad-context/
  monad-docs/
  monad-policy/
  monad-plans/
  monad-packs/
```

### 16.8.1 `monad-config`

Responsibilities:

* manifest parsing,
* workspace root detection,
* source-of-truth checks,
* compatibility mirror handling,
* config schema support.

Potential files:

```text id="3hkeee"
crates/monad-config/
  Cargo.toml
  src/
    lib.rs
    manifest.rs
    root.rs
    source_of_truth.rs
```

Extraction trigger:

* manifest logic becomes large enough to justify separation,
* multiple commands need config resolution,
* source-of-truth behavior needs dedicated tests.

### 16.8.2 `monad-inspect`

Responsibilities:

* repository scanning,
* inspection report model,
* native manifest detection,
* docs/governance detection,
* project area detection.

Potential files:

```text id="lfhig5"
crates/monad-inspect/
  Cargo.toml
  src/
    lib.rs
    report.rs
    scanner.rs
    detectors/
```

Extraction trigger:

* `monad inspect`, `monad check`, `monad graph`, and `monad context` all depend on inspection behavior.

### 16.8.3 `monad-graph`

Responsibilities:

* graph node model,
* graph edge model,
* graph builder,
* graph export formats,
* graph invariants.

Potential files:

```text id="o2mhy2"
crates/monad-graph/
  Cargo.toml
  src/
    lib.rs
    graph.rs
    node.rs
    edge.rs
    export/
```

Extraction trigger:

* lifecycle graph model becomes central enough to deserve independent tests and schemas.

### 16.8.4 `monad-context`

Responsibilities:

* context handoff,
* context pack model,
* redaction,
* inclusion/exclusion manifest,
* AI-safe export boundaries.

Potential files:

```text id="6cvi3j"
crates/monad-context/
  Cargo.toml
  src/
    lib.rs
    handoff.rs
    pack.rs
    redaction.rs
```

Extraction trigger:

* context generation becomes complex enough to require dedicated security and privacy tests.

### 16.8.5 `monad-docs`

Responsibilities:

* docs check,
* docs generation preview,
* docs templates,
* ADR/work-packet document validation if not separated further.

Potential files:

```text id="ay8987"
crates/monad-docs/
  Cargo.toml
  src/
    lib.rs
    check.rs
    generate.rs
    templates.rs
```

Extraction trigger:

* documentation lifecycle commands become more than simple CLI modules.

### 16.8.6 `monad-policy`

Responsibilities:

* policy rule model,
* policy evaluation,
* policy explanation,
* waiver model.

Potential files:

```text id="wjoq9c"
crates/monad-policy/
  Cargo.toml
  src/
    lib.rs
    rule.rs
    evaluate.rs
    explain.rs
    waiver.rs
```

Extraction trigger:

* policy logic needs independent model, tests, and reports.

### 16.8.7 `monad-plans`

Responsibilities:

* plan schema,
* plan validation,
* file operations,
* dry-run apply,
* approved apply,
* apply reports.

Potential files:

```text id="knhe09"
crates/monad-plans/
  Cargo.toml
  src/
    lib.rs
    plan.rs
    step.rs
    file_op.rs
    apply.rs
    dry_run.rs
```

Extraction trigger:

* mutation safety becomes active and requires a hard boundary.

### 16.8.8 `monad-packs`

Responsibilities:

* pack metadata,
* template metadata,
* pack profile model,
* pack install preview,
* pack apply through plan engine.

Potential files:

```text id="x4yb3p"
crates/monad-packs/
  Cargo.toml
  src/
    lib.rs
    pack.rs
    template.rs
    profile.rs
```

Extraction trigger:

* packs/templates become real extension mechanisms.

---

## 16.9 Phase 3 Source Code Structure: Extension Maturity

Later, if the codebase grows, additional crates may be considered.

Possible future crates:

```text id="p8gvvk"
monad-native-tools
monad-release
monad-ai
monad-schemas
monad-testing
monad-hosted-client
```

These should not be introduced until there is clear implementation pressure.

### 16.9.1 Crate Extraction Rule

A new crate should be created only when at least one of these is true:

* the domain boundary is stable,
* multiple commands reuse the logic,
* the crate can have meaningful independent tests,
* the crate reduces dependency coupling,
* the crate protects a safety boundary,
* the crate clarifies public API boundaries.

Do not create crates merely because the roadmap mentions future capabilities.

---

## 16.10 Dependency Direction Rules

Rust crate dependencies should follow clean direction rules.

Recommended direction:

```text id="hjf2qz"
monad-cli
  depends on domain/application crates

domain/application crates
  depend on monad-core

monad-core
  depends on minimal shared libraries only
```

Avoid:

```text id="9iw2h0"
monad-core depending on monad-cli
domain crates depending on CLI presentation logic
policy crate depending on hosted code
AI crate required by deterministic core
plans crate depending on plugin execution
```

### 16.10.1 Dependency Boundary Goals

The dependency structure should preserve:

* AI optionality,
* hosted optionality,
* local-first execution,
* deterministic core behavior,
* testability,
* and clean domain boundaries.

---

## 16.11 Documentation Structure Strategy

The `docs/` directory should be organized by audience and artifact type.

Recommended documentation structure:

```text id="zi8m16"
docs/
  index.md
  product/
  roadmap/
  architecture/
  engineering/
  security/
  operations/
  governance/
  user-guide/
  reference/
  planning/
```

The repository may currently contain `docs/planning/*.md` as the planning package. That should remain clearly distinguished from stable user/reference documentation.

---

## 16.12 Documentation Structure

Recommended structure:

```text id="e288pk"
docs/
  index.md
  product/
    charter.md
    prd.md
    positioning.md
    personas.md
    use-cases.md
  roadmap/
    roadmap.md
    milestones.md
    work-packets/
      index.md
      wp-0000-product-and-repository-foundation.md
      wp-0001-rust-workspace-and-cli-foundation.md
      wp-0002-canonical-manifest-and-workspace-model.md
      wp-0003-documentation-and-governance-foundation.md
  planning/
    index.md
    0000-product-understanding-and-assumptions.md
    0001-executive-summary.md
    0002-product-charter.md
    0003-product-requirements-document.md
    0004-domain-model-and-ddd-design.md
    0005-architecture-strategy.md
    0006-ai-architecture.md
    0007-data-architecture.md
    0008-api-and-integration-design.md
    0009-security-privacy-compliance-governance.md
    0010-infra-and-cloud-agnostic-deployment-plan.md
    0011-observability-and-operations.md
    0012-testing-strategy.md
    0013-BDD-specification-set.md
    0014-implementation-roadmap.md
    0015-initial-repository-documentation-structure.md
  architecture/
    overview.md
    principles.md
    system-context.md
    data-architecture.md
    ai-architecture.md
    security-architecture.md
    decision-records/
      index.md
      adr-0001-rust-single-binary-runtime.md
      adr-0002-coordinate-native-tools.md
      adr-0003-local-first-core.md
      adr-0004-ai-native-but-ai-optional.md
      adr-0005-canonical-manifest.md
  engineering/
    development-workflow.md
    testing-strategy.md
    command-catalog.md
    output-formats.md
    release-process.md
  security/
    security-model.md
    threat-model.md
    secret-handling.md
    supply-chain-security.md
  operations/
    operational-model.md
    runbooks/
      workspace-not-detected.md
      manifest-conflict.md
      command-catalog-mismatch.md
      docs-check-failed.md
      context-export-safety.md
      plan-apply-failed.md
  governance/
    governance-model.md
    adr-process.md
    work-packet-process.md
    policy-process.md
    release-governance.md
  user-guide/
    installation.md
    getting-started.md
    commands.md
    configuration.md
    context-handoff.md
  reference/
    manifest.md
    command-catalog.md
    findings.md
    exit-codes.md
    plan-schema.md
    graph-schema.md
    policy-schema.md
```

### 16.12.1 `docs/index.md`

The docs index should orient readers.

It should answer:

* what Monad is,
* which docs are stable,
* which docs are planning artifacts,
* where product docs live,
* where architecture docs live,
* where user docs live,
* where governance docs live,
* where reference docs live.

### 16.12.2 `docs/product/`

Product docs should define:

* product charter,
* PRD,
* positioning,
* personas,
* use cases,
* product scope,
* product non-goals.

These docs are primarily for product direction.

### 16.12.3 `docs/roadmap/`

Roadmap docs should define:

* maturity sequence,
* milestones,
* work packets,
* layer plans,
* implementation sequence,
* roadmap status.

These docs are primarily for planning and execution.

### 16.12.4 `docs/planning/`

Planning docs should hold the expanded planning package.

These are high-level source-of-truth planning artifacts, not necessarily concise user documentation.

Rules:

* preserve section numbering,
* keep filenames ordered,
* maintain an index,
* avoid claiming implemented behavior unless implemented,
* distinguish future, planned, and current capabilities.

### 16.12.5 `docs/architecture/`

Architecture docs should define:

* architecture principles,
* system context,
* data architecture,
* AI architecture,
* security architecture,
* decision records,
* major architectural constraints.

### 16.12.6 `docs/engineering/`

Engineering docs should define:

* development workflow,
* testing strategy,
* command catalog,
* output formats,
* release process,
* coding standards,
* CI expectations.

### 16.12.7 `docs/security/`

Security docs should define:

* security model,
* threat model,
* secret handling,
* supply-chain security,
* context export safety,
* plugin/pack safety later,
* AI security later.

### 16.12.8 `docs/operations/`

Operations docs should define:

* operational model,
* runbooks,
* release defect handling,
* incident response,
* diagnostics,
* support procedures.

### 16.12.9 `docs/governance/`

Governance docs should define:

* governance model,
* ADR process,
* work-packet process,
* policy process,
* release governance,
* waiver process.

### 16.12.10 `docs/user-guide/`

User-guide docs should be practical and concise.

They should include:

* installation,
* getting started,
* commands,
* configuration,
* context handoff,
* common workflows.

These should not be overloaded with planning-package depth.

### 16.12.11 `docs/reference/`

Reference docs should be precise and stable.

They may include:

* manifest reference,
* command catalog reference,
* findings reference,
* exit code reference,
* plan schema,
* graph schema,
* policy schema.

Reference docs should clearly mark unstable or pre-v1 schemas.

---

## 16.13 ADR Structure

ADRs should live under:

```text id="r1tqn3"
docs/architecture/decision-records/
```

Recommended structure:

```text id="6b3cc5"
docs/architecture/decision-records/
  index.md
  adr-0001-rust-single-binary-runtime.md
  adr-0002-coordinate-native-tools.md
  adr-0003-local-first-core.md
  adr-0004-ai-native-but-ai-optional.md
  adr-0005-canonical-manifest.md
```

### 16.13.1 ADR Naming Convention

ADR filenames should use:

```text id="qewrpw"
adr-NNNN-kebab-case-title.md
```

Examples:

```text id="1ja4ur"
adr-0001-rust-single-binary-runtime.md
adr-0002-coordinate-native-tools.md
adr-0003-local-first-core.md
```

### 16.13.2 ADR Required Fields

Each ADR should include:

* title,
* status,
* date,
* context,
* decision,
* consequences,
* alternatives considered,
* related work packets,
* related docs.

### 16.13.3 ADR Statuses

Recommended statuses:

```text id="f5vj8g"
proposed
accepted
superseded
deprecated
rejected
```

### 16.13.4 ADR Index

`index.md` should list:

* ADR number,
* title,
* status,
* date,
* summary,
* supersession relationship where applicable.

Future `monad adr list` should be able to read this structure.

---

## 16.14 Work-Packet Structure

Work packets should live under:

```text id="6poxv6"
docs/roadmap/work-packets/
```

Recommended initial structure:

```text id="96af0k"
docs/roadmap/work-packets/
  index.md
  wp-0000-product-and-repository-foundation.md
  wp-0001-rust-workspace-and-cli-foundation.md
  wp-0002-canonical-manifest-and-workspace-model.md
  wp-0003-documentation-and-governance-foundation.md
```

### 16.14.1 Work-Packet Naming Convention

Work-packet filenames should use:

```text id="3e15y3"
wp-NNNN-kebab-case-title.md
```

Examples:

```text id="dscasj"
wp-0001-rust-workspace-and-cli-foundation.md
wp-0002-canonical-manifest-and-workspace-model.md
```

### 16.14.2 Work-Packet Required Fields

Each work packet should include:

* purpose,
* scope,
* out of scope,
* affected bounded contexts,
* inputs,
* outputs,
* dependencies,
* layers,
* tests,
* documentation updates,
* acceptance criteria,
* risks,
* rollback strategy,
* definition of done.

### 16.14.3 Work-Packet Index

`index.md` should list:

* work-packet ID,
* title,
* status,
* epic,
* stage,
* dependencies,
* summary,
* implementation state.

Future `monad workpacket list` should be able to read this structure.

---

## 16.15 Governance Structure

Governance artifacts should live under:

```text id="aouhi1"
governance/
```

Recommended structure:

```text id="ghuk3t"
governance/
  README.md
  decision-log.md
  risk-register.md
  traceability-matrix.md
  release-gates.md
  review-process.md
  waivers/
    README.md
```

### 16.15.1 `governance/README.md`

This should explain:

* what governance means for Monad,
* how decisions are recorded,
* how risks are tracked,
* how work packets are reviewed,
* how releases are gated,
* how waivers work.

### 16.15.2 `decision-log.md`

The decision log should capture smaller decisions that do not require full ADRs.

Examples:

* naming choices,
* short-term sequencing choices,
* temporary compatibility choices,
* tooling choices that do not materially alter architecture.

### 16.15.3 `risk-register.md`

The risk register should track:

* risk ID,
* description,
* category,
* likelihood,
* impact,
* mitigation,
* owner if applicable,
* status,
* related work packets,
* related ADRs.

### 16.15.4 `traceability-matrix.md`

The traceability matrix should connect:

* product requirements,
* architecture decisions,
* work packets,
* tests,
* BDD scenarios,
* policies,
* release gates.

### 16.15.5 `release-gates.md`

Release gates should define:

* required checks,
* blocking findings,
* documentation requirements,
* security requirements,
* test requirements,
* release evidence.

### 16.15.6 `review-process.md`

The review process should define:

* how changes are reviewed,
* what requires ADR,
* what requires work-packet update,
* what requires test update,
* what requires docs update.

### 16.15.7 `waivers/`

Waivers should eventually capture approved exceptions to policies.

Early waivers may be documentation-only.

Future waiver records may become structured.

---

## 16.16 Policy Structure

Policies should live under:

```text id="639i53"
policies/
```

Recommended structure:

```text id="hn1yvh"
policies/
  README.md
  core/
    canonical-manifest.policy.md
    command-catalog.policy.md
    docs-required.policy.md
    no-unsafe-mutation.policy.md
    secret-redaction.policy.md
  examples/
    enterprise-governance.policy.md
    solo-developer.policy.md
```

### 16.16.1 Human-Readable First

Early policies may be Markdown.

This is acceptable because early Monad policy behavior should focus on:

* documenting governance expectations,
* defining future checks,
* creating stable policy IDs,
* preparing for future machine-readable policy.

### 16.16.2 Future Machine-Readable Policies

Later policy files may become structured.

Possible future formats:

```text id="j4yc1v"
TOML
YAML
JSON
Rego
custom policy DSL
```

The format should not be chosen before policy needs are clearer.

### 16.16.3 Core Policy Examples

Core policies should include:

* canonical manifest policy,
* command catalog policy,
* required documentation policy,
* no unsafe mutation policy,
* secret redaction policy.

### 16.16.4 Policy Metadata

Each policy should eventually include:

* policy ID,
* title,
* purpose,
* severity,
* rationale,
* rule,
* remediation,
* waiver rules,
* related findings,
* related tests.

---

## 16.17 Fixture Structure

Fixtures should live under:

```text id="e0jv1h"
fixtures/
```

Recommended structure:

```text id="jazt9q"
fixtures/
  empty-repo/
  minimal-monad-repo/
  manifest-conflict-repo/
  rust-workspace/
  polyglot-workspace/
  docs-missing-repo/
  policy-violation-repo/
  context-secret-repo/
```

### 16.17.1 Fixture Purpose

Fixtures exist to prove Monad behavior against realistic repository states.

They should support tests for:

* root detection,
* manifest parsing,
* source-of-truth conflicts,
* inspection,
* check,
* doctor,
* graph,
* docs check,
* policy check,
* context redaction,
* plan/apply safety.

### 16.17.2 Fixture Rules

Fixtures should be:

* small,
* intentional,
* safe,
* stable,
* documented when non-obvious,
* free of real secrets,
* copied to temporary directories before mutation tests.

### 16.17.3 Fake Secret Fixtures

When testing redaction, fixtures may include fake secrets.

Fake secrets must be clearly marked.

Example:

```text id="g61ivo"
FAKE_TEST_API_KEY=monad_test_fake_key_do_not_use
```

### 16.17.4 Fixture README Files

Complex fixtures should include:

```text id="v0kfxo"
README.md
```

The README should explain:

* what scenario the fixture represents,
* expected findings,
* related BDD scenarios,
* related tests.

---

## 16.18 Examples Structure

Examples should live under:

```text id="eduywu"
examples/
```

Recommended structure:

```text id="ne4uxk"
examples/
  minimal/
  rust-workspace/
  polyglot-monorepo/
  docs-governed-repo/
  ai-context-handoff/
  plan-backed-mutation/
```

### 16.18.1 Examples Versus Fixtures

Examples and fixtures are different.

```text id="banrp8"
fixtures/
  test inputs used to prove behavior

examples/
  user-facing demonstrations of intended usage
```

A fixture may be intentionally invalid.

An example should generally demonstrate a recommended pattern.

### 16.18.2 Example Maturity

Examples should be introduced only when the behavior they demonstrate is implemented or clearly marked as planned.

For example:

```text id="r8bfng"
examples/plan-backed-mutation/
```

should not imply real approved apply behavior before the plan/apply engine exists.

### 16.18.3 Example README Files

Each example should include a `README.md` explaining:

* purpose,
* commands to run,
* expected output,
* whether behavior is current or planned,
* safety notes.

---

## 16.19 CI/CD Structure

GitHub-specific automation should live under:

```text id="z1qbdg"
.github/
```

Recommended structure:

```text id="kvdffc"
.github/
  workflows/
    ci.yml
    release.yml
    security.yml
  ISSUE_TEMPLATE/
    bug_report.yml
    feature_request.yml
    work_packet.yml
    adr_request.yml
  PULL_REQUEST_TEMPLATE.md
  CODEOWNERS
```

### 16.19.1 `ci.yml`

The early CI workflow should run:

```bash id="xyazwg"
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
```

Near-term CI may add:

```bash id="m4omep"
cargo clippy --workspace --all-targets -- -D warnings
cargo test -p monad-cli --test command_catalog_contract
```

Future CI may add:

```bash id="7kewbj"
cargo deny check
cargo audit
cargo nextest run
schema validation
snapshot tests
docs check
policy check
release readiness
```

### 16.19.2 `release.yml`

Release workflow should eventually handle:

* cross-platform builds,
* checksums,
* release notes,
* artifact upload,
* SBOM later,
* signing later,
* provenance later.

This should not be overbuilt before releases are real.

### 16.19.3 `security.yml`

Security workflow may eventually handle:

* dependency audit,
* cargo deny,
* secret scanning,
* supply-chain checks,
* SBOM,
* release artifact verification.

### 16.19.4 Issue Templates

Issue templates should reflect Monad’s governance model.

Recommended templates:

* bug report,
* feature request,
* work packet,
* ADR request.

### 16.19.5 Pull Request Template

The PR template should ask:

* what changed,
* why it changed,
* related work packet,
* related ADR,
* tests added,
* docs updated,
* safety implications,
* whether behavior is read-only, dry-run, or mutating.

### 16.19.6 CODEOWNERS

Even if the project is currently solo-developed, `CODEOWNERS` documents ownership expectations for future collaboration.

---

## 16.20 Script Structure

Scripts should live under:

```text id="vjjw9i"
scripts/
```

Recommended structure:

```text id="j9jpm4"
scripts/
  check-rust-workspace.sh
  generate-command-catalog-report.py
  validate-docs.py
  validate-adrs.py
  validate-work-packets.py
  release-check.py
```

### 16.20.1 Script Principles

Scripts should be:

* optional,
* simple,
* idempotent where possible,
* easy to inspect,
* executable with explicit commands,
* safe to run locally,
* documented,
* and not required for core understanding.

### 16.20.2 Avoid Fragile Script Creation

Given known terminal constraints, instructions should avoid workflows like fragile heredoc copy/paste when not necessary.

Preferred documentation style:

```text id="ig21d8"
Save this file at:
  scripts/check-rust-workspace.sh

Then run:
  chmod +x scripts/check-rust-workspace.sh
  ./scripts/check-rust-workspace.sh
```

When commands are simpler than scripts, prefer commands.

### 16.20.3 Script Non-Goals

Scripts should not become hidden infrastructure.

Avoid scripts that:

* hide errors,
* silently mutate many files,
* require undisclosed tools,
* depend on a specific shell unless documented,
* call network services unexpectedly,
* modify canonical files without review.

---

## 16.21 Tools Structure

Optional helper tooling may live under:

```text id="v25ry7"
tools/
```

Possible structure:

```text id="5xz0vu"
tools/
  README.md
  generators/
  validators/
  reports/
```

This directory should remain optional.

Use `tools/` only for repository-specific helper code that does not belong in the main Rust crates.

If helper tooling becomes product logic, move it into Rust crates.

---

## 16.22 Test Structure

Rust tests may live in crate-local `tests/` directories and/or top-level `tests/`.

Recommended approach:

```text id="kaxv3g"
crates/
  monad-cli/
    tests/
      smoke.rs
      command_catalog_contract.rs
      fixtures.rs
  monad-core/
    tests/
      domain.rs
tests/
  README.md
```

### 16.22.1 Crate-Local Tests

Use crate-local tests for:

* CLI smoke tests,
* command contract tests,
* crate-specific integration tests,
* domain crate tests.

### 16.22.2 Top-Level Tests

Use top-level tests only when a test spans multiple crates or repository-level behavior.

### 16.22.3 Test Fixture Location

Fixtures may live at top-level:

```text id="f9k303"
fixtures/
```

or under a test crate path.

Top-level `fixtures/` is preferred because Monad itself treats fixture repositories as repository lifecycle artifacts and they may be referenced by docs and BDD scenarios.

---

## 16.23 Schema Structure

Schemas should live under:

```text id="l46nqx"
schemas/
```

Recommended future structure:

```text id="6ztmmr"
schemas/
  README.md
  command-catalog.schema.json
  finding.schema.json
  inspection-report.schema.json
  doctor-report.schema.json
  check-report.schema.json
  graph.schema.json
  context-manifest.schema.json
  plan.schema.json
  apply-report.schema.json
  policy-report.schema.json
  docs-report.schema.json
```

### 16.23.1 Schema Timing

Do not create schemas before there is an output worth stabilizing.

Early schemas should be marked pre-v1 if they are not stable.

### 16.23.2 Schema Rules

Schemas should include:

* schema ID,
* schema version,
* required fields,
* enum values,
* compatibility notes,
* example payloads.

Schemas should be tested against generated output.

---

## 16.24 `.monad/` Structure

`.monad/` is local Monad state.

Recommended structure:

```text id="fyb8j5"
.monad/
  README.md
  cache/
  context/
  inspections/
  graph/
  plans/
  reports/
  tmp/
```

### 16.24.1 `.monad/README.md`

`.monad/README.md` should explain:

* what `.monad/` is,
* which files are cache,
* which files are safe to delete,
* which files should not be committed,
* which files may be intentionally promoted,
* how context output is handled,
* how plans are handled,
* how reports are handled.

### 16.24.2 `.monad/cache/`

Cache files are safe to delete.

They should be rebuildable.

### 16.24.3 `.monad/context/`

Context outputs may be sensitive.

They should be ignored by default unless project policy intentionally commits them.

### 16.24.4 `.monad/inspections/`

Inspection reports are generated artifacts.

They may be ignored by default.

### 16.24.5 `.monad/graph/`

Graph outputs are generated artifacts.

Some graph outputs may be intentionally committed if used as documentation, but generated graph cache should be ignored.

### 16.24.6 `.monad/plans/`

Plans are reviewable generated artifacts.

Temporary plans should be ignored.

Approved plans may be committed if the project treats them as governance evidence.

### 16.24.7 `.monad/reports/`

Reports are generated artifacts.

Some reports may be promoted to evidence, especially release readiness or policy reports.

### 16.24.8 `.monad/tmp/`

Temporary files are always safe to delete and should never be committed.

---

## 16.25 Recommended `.gitignore` Treatment

Recommended `.gitignore` entries:

```gitignore id="13gr7i"
# Monad local/generated state
.monad/cache/
.monad/tmp/
.monad/inspections/
.monad/graph/
.monad/reports/
.monad/plans/*.tmp.json

# Sensitive context exports should be ignored unless policy says otherwise
.monad/context/
```

Optional project-specific treatment:

```gitignore id="5teyf4"
# If approved plans are committed as evidence, do not ignore all plans.
# Keep temporary plans ignored instead.
.monad/plans/*.tmp.json
```

### 16.25.1 Commit Policy for `.monad/`

Recommended default:

| Path                      | Commit?    | Reason                            |
| ------------------------- | ---------- | --------------------------------- |
| `.monad/README.md`        | Yes        | Documents local state semantics   |
| `.monad/cache/`           | No         | Rebuildable cache                 |
| `.monad/tmp/`             | No         | Temporary files                   |
| `.monad/context/`         | Usually no | May contain sensitive context     |
| `.monad/inspections/`     | Usually no | Generated reports                 |
| `.monad/graph/`           | Usually no | Generated graph outputs/cache     |
| `.monad/reports/`         | Usually no | Generated reports                 |
| `.monad/plans/*.tmp.json` | No         | Temporary plans                   |
| approved plan files       | Maybe      | If treated as governance evidence |

---

## 16.26 Devcontainer Structure

A devcontainer may be useful but should remain optional.

Recommended future structure:

```text id="wv5n3f"
.devcontainer/
  devcontainer.json
  Dockerfile
  README.md
```

The devcontainer may include:

* Rust stable,
* Cargo tools,
* Git,
* shell utilities,
* optional documentation tools,
* optional security tools.

It should not be required to run Monad.

Devcontainer non-goals:

* hosted service simulation,
* mandatory Docker workflow,
* Kubernetes dependency,
* AI provider setup.

---

## 16.27 README Structure

The top-level `README.md` should be concise and useful.

Recommended sections:

```text id="lc4kf1"
# Monad CLI

## What Monad Is

## Current Status

## What Works Today

## What Is Planned

## Install / Build

## Common Commands

## Repository Structure

## Development

## Testing

## Documentation

## Safety Model

## License
```

### 16.27.1 Current Status Honesty

The README should clearly distinguish:

* implemented,
* partially implemented,
* planned,
* future,
* non-goals.

This prevents users from mistaking roadmap ambition for current behavior.

### 16.27.2 Common Commands

README should include currently valid commands only, with planned commands clearly marked.

---

## 16.28 CONTRIBUTING Structure

`CONTRIBUTING.md` should explain:

* how to set up the repo,
* how to run tests,
* how to add commands,
* how to update the command catalog,
* how to update docs,
* how to propose ADRs,
* how to add work packets,
* how to maintain read-only safety,
* how to avoid unsafe mutation,
* how to handle generated files.

It should include explicit commands:

```bash id="v71lx4"
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
cargo clippy --workspace --all-targets -- -D warnings
```

---

## 16.29 SECURITY Structure

`SECURITY.md` should define:

* supported versions,
* how to report vulnerabilities,
* what counts as a security issue,
* secret leakage policy,
* unsafe mutation policy,
* release artifact integrity expectations,
* supply-chain concerns,
* AI/context safety concerns.

Early security-sensitive issue categories include:

* destructive mutation bug,
* secret leakage in context output,
* hidden network call,
* hidden telemetry,
* compromised dependency,
* compromised release artifact,
* incorrect policy pass,
* unsafe apply behavior.

---

## 16.30 SUPPORT Structure

`SUPPORT.md` should define:

* what support is available,
* how to report issues,
* what information to include,
* how to produce diagnostics safely,
* what not to share publicly,
* how to handle logs/reports/context output.

It should warn users not to share:

* `.env`,
* private keys,
* tokens,
* sensitive context packs,
* proprietary code,
* unredacted diagnostic bundles.

---

## 16.31 Documentation Indexing Rules

Docs should be indexable by humans and future Monad commands.

Rules:

* each major docs directory should have `README.md` or `index.md`,
* long docs should have clear headings,
* ADRs should be listed in an ADR index,
* work packets should be listed in a work-packet index,
* references should identify schema stability,
* planning docs should preserve numbering,
* deprecated docs should be marked, not silently removed.

---

## 16.32 Structure Validation Strategy

Future `monad docs check`, `monad doctor`, and `monad check` should validate this structure.

Possible checks:

```text id="z5pl3n"
README exists
SECURITY exists
CONTRIBUTING exists
monad.toml exists
workspace.toml is not canonical
docs/index.md exists
ADR index exists
work-packet index exists
governance/risk-register.md exists
policies/README.md exists
fixtures directory exists
command catalog docs exist
.monad/README.md exists if .monad exists
```

These checks should start as warnings unless the repository explicitly enables strict mode.

---

## 16.33 Structure Maturity Phases

Repository structure should mature in phases.

### 16.33.1 Phase 0: Foundation

Create:

```text id="9zjxyh"
README.md
Cargo.toml
crates/
docs/planning/
docs/architecture/
governance/
policies/
.github/workflows/ci.yml
```

Goal:

```text id="95avx8"
The repo can explain what it is and build the initial CLI.
```

### 16.33.2 Phase 1: CLI Foundation

Add or stabilize:

```text id="lyd2mx"
crates/monad-cli/
crates/monad-core/
command catalog
smoke tests
command contract tests
engineering docs
```

Goal:

```text id="uzgbuw"
The repo has a real CLI surface and tests protecting it.
```

### 16.33.3 Phase 2: Read-Only Lifecycle

Add:

```text id="q2smie"
fixtures/
docs/user-guide/
docs/reference/
docs/operations/runbooks/
inspection/check/doctor docs
graph docs
context docs
```

Goal:

```text id="59qwov"
The repo can support inspection, validation, diagnostics, graphing, and handoff.
```

### 16.33.4 Phase 3: Plan and Policy

Add:

```text id="b9bel0"
schemas/
docs/reference/plan-schema.md
docs/reference/policy-schema.md
policies/core/
.monad/plans/
.monad/reports/
plan/apply runbooks
```

Goal:

```text id="d3ywjd"
The repo can support safe plan-backed mutation and policy checks.
```

### 16.33.5 Phase 4: Packs and Extension

Add:

```text id="y01rg1"
examples/plan-backed-mutation/
pack metadata docs
template docs
pack fixtures
```

Goal:

```text id="8ul4kw"
The repo can support safe templates and packs.
```

### 16.33.6 Phase 5: AI and Hosted Future

Add only when needed:

```text id="imw5ix"
docs/reference/ai-provider.md
docs/security/ai-context-safety.md
docs/architecture/hosted-control-plane.md
hosted examples
```

Goal:

```text id="t9adfy"
The repo can document optional AI and hosted capabilities without making them core.
```

---

## 16.34 Repository Structure Anti-Patterns

Monad should avoid these structure anti-patterns.

### 16.34.1 Empty Architecture Theater

Do not create many empty directories or crates just to look mature.

Every directory should have either real content or a README explaining its future role.

### 16.34.2 Premature Crate Explosion

Do not create all future domain crates before the behavior exists.

Start with `monad-cli` and `monad-core`, then extract as boundaries become real.

### 16.34.3 Generated State as Source of Truth

Do not treat `.monad/` as canonical truth.

Generated reports, graphs, caches, and temporary plans should be rebuildable or explicitly promoted.

### 16.34.4 Docs Without Ownership

Do not create docs that no command, work packet, or contributor process owns.

Unowned docs will drift.

### 16.34.5 Examples That Do Not Run

Do not add examples unless they are either tested or clearly marked as conceptual/planned.

### 16.34.6 Fixtures With Real Secrets

Never include real credentials in fixtures.

Use fake, clearly marked test values only.

### 16.34.7 Scripts That Hide Critical Behavior

Avoid scripts that obscure what commands are being run or silently mutate repository files.

### 16.34.8 Planning Docs Mistaken for User Docs

The planning package is deep source-of-truth documentation. It should not be the only user-facing documentation.

Concise user-guide docs should eventually exist separately.

---

## 16.35 Recommended Immediate Implementation Order

Recommended immediate implementation order:

1. Confirm current top-level repo files are intentional.
2. Ensure `monad.toml` exists and is canonical.
3. Keep `workspace.toml` only as a compatibility mirror if needed.
4. Ensure `Cargo.toml` workspace includes current crates only.
5. Keep `crates/monad-cli` and `crates/monad-core` stable before extracting more crates.
6. Add or stabilize `docs/index.md`.
7. Add or stabilize `docs/planning/index.md`.
8. Add or stabilize `docs/architecture/decision-records/index.md`.
9. Add or stabilize `docs/roadmap/work-packets/index.md`.
10. Add or stabilize `governance/README.md`.
11. Add or stabilize `governance/risk-register.md`.
12. Add or stabilize `policies/README.md`.
13. Add fixtures only as tests require them.
14. Add examples only when they demonstrate working behavior or are clearly marked planned.
15. Add `.monad/README.md` before relying on `.monad/` structure.
16. Add `.gitignore` rules for `.monad/` generated state.
17. Add schemas only when JSON outputs become real contracts.
18. Add devcontainer only as optional contributor convenience.
19. Add scripts only when they simplify repeated explicit commands.
20. Add future crates only when domain boundaries justify extraction.

---

## 16.36 Early Non-Goals

The initial repository structure does not need:

* all future domain crates,
* hosted service directories,
* Kubernetes manifests,
* Terraform/Pulumi infrastructure,
* graph database setup,
* plugin marketplace structure,
* enterprise dashboard app,
* AI provider runtime,
* local daemon,
* multi-repo fleet structure,
* full pack registry,
* browser UI,
* database migrations,
* service mesh manifests.

These should be deferred until the corresponding roadmap stage is active.

---

## 16.37 Open Questions

The following questions should remain open until implementation pressure justifies decisions.

1. Should `schemas/` exist immediately, or only once JSON schemas stabilize?

2. Should fixtures live at top-level `fixtures/` or under `crates/monad-cli/tests/fixtures/`?

3. Should examples be tested in CI from the beginning?

4. Should `.monad/README.md` be committed even if most `.monad/` content is ignored?

5. Should approved plans be committed as governance evidence?

6. Should context outputs be ignored by default, committed by policy, or configurable per repository?

7. Should ADRs live under `docs/architecture/decision-records/` or `docs/adr/`?

8. Should work packets live under `docs/roadmap/work-packets/` or top-level `work-packets/`?

9. Should policies begin as Markdown or structured TOML/YAML?

10. Should `governance/` duplicate some docs under `docs/governance/`, or should one link to the other?

11. When should `monad-config`, `monad-inspect`, `monad-graph`, and other future crates be extracted?

12. Should scripts be shell-only, Rust-based, Python-based, or avoided where explicit commands are enough?

13. Should `.devcontainer/` be introduced now or later?

14. How much planned behavior should appear in README before implementation catches up?

15. Should generated graph/report artifacts ever be committed?

---

## 16.38 Section Acceptance Criteria

This section is successful if a reader understands that:

1. Monad’s repository structure should make the governance model visible.
2. The structure should support a Rust CLI first.
3. The structure should not create premature empty architecture.
4. `monad.toml` is canonical.
5. `workspace.toml` is compatibility mirror only.
6. `monad.lock` records resolved state.
7. `.monad/` stores local/generated/cache/context/report/plan state, not canonical truth.
8. `crates/monad-cli` and `crates/monad-core` are the correct early crate foundation.
9. Additional crates should be extracted only when domain boundaries justify them.
10. Documentation should be organized by product, roadmap, planning, architecture, engineering, security, operations, governance, user guide, and reference.
11. ADRs and work packets should have stable, inspectable locations.
12. Governance artifacts should be visible at the repository level.
13. Policies should begin as understandable governance artifacts and may become machine-readable later.
14. Fixtures should prove behavior and never contain real secrets.
15. Examples should demonstrate intended usage and should not imply unimplemented behavior.
16. CI/CD should support local-first Rust CLI quality gates.
17. Scripts should be optional, simple, and transparent.
18. `.gitignore` should protect generated and sensitive `.monad/` state.
19. The structure should support future `monad docs check`, `monad adr list`, `monad workpacket list`, `monad policy check`, and `monad context handoff`.
20. Hosted, AI, plugin, graph database, and enterprise structures should be deferred until their roadmap stages.

The final repository-structure rule is:

> Monad’s repository should be structured enough to be governable and inspectable, but not so overbuilt that it claims maturity the implementation has not earned.
