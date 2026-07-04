# Monad OS / Monad CLI

# Enterprise-Grade Product Planning Package

# Part 3: Implementation Roadmap, Repository Structure, and Initial Documentation

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

This document covers sections 15 through 17.

---

# 15. Implementation Roadmap

## 15.1 Roadmap Philosophy

Monad OS should be built in disciplined layers.

The vision is intentionally large, but the implementation must remain small, testable, and reversible at each step.

The roadmap should follow these principles:

1. Build local trust before hosted capability.
2. Build read-only understanding before mutation.
3. Build plan-backed mutation before real generators.
4. Build deterministic behavior before AI assistance.
5. Build source-of-truth rules before automation.
6. Build command contracts before command depth.
7. Build graph foundations before graph persistence.
8. Build policy checks before policy enforcement.
9. Build templates before plugins.
10. Build solo-developer usability before enterprise extensibility.

## 15.2 Product Maturity Sequence

Recommended maturity sequence:

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

## 15.3 Version Strategy

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

## 15.4 MVP Definition

The MVP should not be “generate every project type.”

The MVP should prove the core thesis:

> A local repository can describe itself, validate itself, explain itself, graph itself, document itself, and produce safe change plans.

MVP command loop:

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

## 15.5 v1 Definition

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

## 15.6 v1 Non-Goals

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

---

## 15.7 Roadmap Hierarchy

Preferred implementation hierarchy:

```text id="a5e1rt"
Epic
  Work Packet
    Layer
      Task
```

Each work packet should include:

* purpose,
* scope,
* out of scope,
* inputs,
* outputs,
* dependencies,
* implementation steps,
* tests,
* documentation updates,
* acceptance criteria,
* risks,
* rollback strategy,
* definition of done.

---

# 15.8 Epic Map

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

---

# 15.9 Detailed Work Packet Plan

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

Inputs:

* product vision,
* architecture principles,
* roadmap.

Outputs:

* repository skeleton,
* docs,
* ADRs,
* governance files.

Layers:

```text id="s6ceqg"
Layer 0000.1: top-level repository skeleton
Layer 0000.2: product docs
Layer 0000.3: architecture docs
Layer 0000.4: governance docs
Layer 0000.5: roadmap and work-packet docs
```

Acceptance criteria:

* repo has clear README,
* product charter exists,
* ADR index exists,
* roadmap exists,
* governance model exists,
* directory structure is intentional.

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

Inputs:

* repository foundation,
* CLI command vision.

Outputs:

* compiling Rust workspace,
* runnable `monad` binary,
* passing tests.

Layers:

```text id="a6v34z"
Layer 0001.1: Cargo workspace
Layer 0001.2: monad-core crate
Layer 0001.3: monad-cli crate
Layer 0001.4: binary/library split
Layer 0001.5: version/help smoke tests
```

Acceptance criteria:

```bash id="d9re12"
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
```

All pass.

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
* hosted sync.

Layers:

```text id="uf5l7u"
Layer 0002.1: manifest domain types
Layer 0002.2: manifest parser
Layer 0002.3: workspace root detection
Layer 0002.4: compatibility mirror detection
Layer 0002.5: source-of-truth check
```

Acceptance criteria:

* `monad.toml` is recognized as canonical,
* `workspace.toml` is not treated as canonical,
* conflicts are reported,
* tests cover missing, valid, and conflicting manifest states.

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

Layers:

```text id="v9h0rt"
Layer 0003.1: docs/index.md
Layer 0003.2: architecture overview
Layer 0003.3: ADR structure
Layer 0003.4: work-packet structure
Layer 0003.5: security/governance/operations docs
```

Acceptance criteria:

* docs are discoverable,
* ADRs have standard format,
* work packets have standard format,
* docs are suitable for future `monad docs check`.

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

Layers:

```text id="kdoyui"
Layer 0004.1: command metadata type
Layer 0004.2: command catalog entries
Layer 0004.3: command listing output
Layer 0004.4: planned vs implemented display
Layer 0004.5: command examples
```

Acceptance criteria:

* every known command has metadata,
* mutating commands are marked,
* unimplemented commands are honest,
* command list output is useful.

---

## WP-0005: Clap Surface Contract

Purpose:

Ensure the actual CLI surface and command catalog do not drift.

Scope:

* contract tests,
* nested command validation,
* command example validation.

Layers:

```text id="qniuy9"
Layer 0005.1: catalog-to-Clap traversal
Layer 0005.2: top-level command test
Layer 0005.3: nested command test
Layer 0005.4: examples command test
Layer 0005.5: implemented command coverage test
```

Acceptance criteria:

* catalog commands expected in CLI are exposed,
* Clap commands are known to catalog,
* tests fail when catalog and CLI drift.

---

## WP-0006: Placeholder Honesty and Command Metadata

Purpose:

Prevent the CLI from pretending unimplemented behavior exists.

Scope:

* placeholder renderer,
* metadata output,
* planned command messaging,
* exit code for unimplemented commands.

Layers:

```text id="i0jzhe"
Layer 0006.1: placeholder output model
Layer 0006.2: implemented=false behavior
Layer 0006.3: mutating metadata display
Layer 0006.4: plan-backed metadata display
Layer 0006.5: tests for placeholder honesty
```

Acceptance criteria:

* unimplemented commands are explicitly marked,
* placeholder commands do not silently succeed as if implemented,
* mutating planned commands warn about future mutation behavior.

---

## WP-0007: CLI Output and Exit Code Standardization

Purpose:

Create consistent human and machine output behavior.

Scope:

* standard output format,
* error format,
* findings format,
* exit codes.

Layers:

```text id="wpi26y"
Layer 0007.1: finding model
Layer 0007.2: output formatter
Layer 0007.3: JSON output foundation
Layer 0007.4: exit code mapping
Layer 0007.5: snapshot tests
```

Acceptance criteria:

* command errors are consistent,
* validation failures have specific exit codes,
* JSON output is possible for key commands.

---

## WP-0008: Workspace Root Detection

Purpose:

Allow Monad to reliably identify the workspace root.

Scope:

* root detection from current directory,
* root detection by manifest,
* Git root awareness,
* error handling.

Layers:

```text id="p7s5bf"
Layer 0008.1: current directory root detection
Layer 0008.2: walk-up manifest discovery
Layer 0008.3: Git root fallback
Layer 0008.4: workspace-not-found finding
Layer 0008.5: fixture tests
```

Acceptance criteria:

* running in nested directories still finds workspace,
* missing workspace produces useful error,
* no files are modified.

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

Layers:

```text id="2t08e6"
Layer 0009.1: inspection report model
Layer 0009.2: project area detection
Layer 0009.3: native manifest detection
Layer 0009.4: docs/governance detection
Layer 0009.5: text and JSON output
```

Acceptance criteria:

* `monad inspect` reports meaningful repo state,
* fixture repos are inspected correctly,
* command is read-only.

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

Layers:

```text id="k1pnxw"
Layer 0010.1: check runner
Layer 0010.2: invariant registry
Layer 0010.3: baseline findings
Layer 0010.4: CI mode
Layer 0010.5: tests and snapshots
```

Acceptance criteria:

* valid repo passes,
* invalid repo reports clear findings,
* CI mode returns useful exit codes.

---

## WP-0011: Doctor Diagnostics

Purpose:

Provide higher-level guidance and remediation hints.

Scope:

* diagnostic checks,
* grouped findings,
* remediation hints,
* severity levels.

Layers:

```text id="82c4os"
Layer 0011.1: diagnostic model
Layer 0011.2: manifest diagnostics
Layer 0011.3: docs diagnostics
Layer 0011.4: native tool diagnostics
Layer 0011.5: remediation output
```

Acceptance criteria:

* `monad doctor` helps users fix problems,
* output is actionable,
* diagnostics are test-backed.

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

Layers:

```text id="ncc0g4"
Layer 0012.1: graph domain model
Layer 0012.2: graph builder from inspection report
Layer 0012.3: text graph output
Layer 0012.4: Mermaid output
Layer 0012.5: graph invariant tests
```

Acceptance criteria:

* graph contains workspace and project nodes,
* graph edges are valid,
* Mermaid output is usable.

---

## WP-0013: Diff and Drift Detection v0

Purpose:

Detect drift between expected and actual repo state.

Scope:

* manifest-vs-files drift,
* docs-vs-code drift,
* command catalog drift,
* compatibility mirror drift.

Layers:

```text id="ip6a5r"
Layer 0013.1: drift model
Layer 0013.2: manifest drift
Layer 0013.3: docs drift
Layer 0013.4: catalog drift
Layer 0013.5: diff output
```

Acceptance criteria:

* `monad diff` reports meaningful drift,
* no mutations occur,
* output supports text and JSON.

---

# 15.10 Recommended Near-Term Layer Boundary

The current phase should stop treating new feature work as Layer 0002 hotfixes.

Recommended boundary:

```text id="lhj3kb"
Layer 0002: Rust workspace and CLI skeleton stabilization
Layer 0003: read-only lifecycle commands
Layer 0004: plan-backed repository mutation engine
```

## Layer 0002 Completion Criteria

Layer 0002 is complete when:

* Rust workspace compiles,
* CLI library/binary split is stable,
* command catalog exists,
* Clap command surface matches catalog,
* placeholders are honest,
* current smoke tests pass,
* no mutating command performs unsafe writes.

## Layer 0003 Entry Criteria

Layer 0003 can begin when:

* command catalog contract is green,
* `config list` and other known catalog commands are exposed,
* command placeholder behavior is stable,
* tests confirm catalog/CLI alignment.

## Layer 0003 Scope

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

## Layer 0004 Scope

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

---

# 16. Initial Repository and Documentation Structure

## 16.1 Repository Structure Strategy

Monad should use a systems-grade monorepo structure even while the executable is initially a Rust CLI.

The repository should make the product’s governance model visible.

Recommended top-level structure:

```text id="xtg780"
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
  .github/
  .devcontainer/
  .monad/
```

## 16.2 Source Code Structure

```text id="lq8f5c"
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
        diff.rs
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
  monad-config/
    Cargo.toml
    src/
      lib.rs
      manifest.rs
      root.rs
      source_of_truth.rs
  monad-inspect/
    Cargo.toml
    src/
      lib.rs
      report.rs
      scanner.rs
      detectors/
  monad-graph/
    Cargo.toml
    src/
      lib.rs
      graph.rs
      node.rs
      edge.rs
      export/
  monad-context/
    Cargo.toml
    src/
      lib.rs
      handoff.rs
      pack.rs
      redaction.rs
  monad-docs/
    Cargo.toml
    src/
      lib.rs
      check.rs
      generate.rs
      templates.rs
  monad-policy/
    Cargo.toml
    src/
      lib.rs
      rule.rs
      evaluate.rs
      explain.rs
      waiver.rs
  monad-plans/
    Cargo.toml
    src/
      lib.rs
      plan.rs
      step.rs
      file_op.rs
      apply.rs
      dry_run.rs
  monad-packs/
    Cargo.toml
    src/
      lib.rs
      pack.rs
      template.rs
      profile.rs
```

## 16.3 Documentation Structure

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
    plan-schema.md
    graph-schema.md
    policy-schema.md
```

## 16.4 Governance Structure

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

## 16.5 Policy Structure

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

## 16.6 Fixtures Structure

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

## 16.7 Examples Structure

```text id="ne4uxk"
examples/
  minimal/
  rust-workspace/
  polyglot-monorepo/
  docs-governed-repo/
  ai-context-handoff/
  plan-backed-mutation/
```

## 16.8 CI/CD Structure

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

## 16.9 Script Structure

```text id="j9jpm4"
scripts/
  check-rust-workspace.sh
  generate-command-catalog-report.py
  validate-docs.py
  validate-adrs.py
  validate-work-packets.py
  release-check.py
```

Given your terminal constraints, scripts should be optional, simple, and executable with explicit commands. Avoid relying on fragile heredoc creation workflows.

## 16.10 `.monad/` Structure

```text id="fyb8j5"
.monad/
  README.md
  cache/
  context/
  inspections/
  graph/
  plans/
  tmp/
```

`.monad/README.md` should explain:

* which files are cache,
* which files are safe to delete,
* which files should not be committed,
* which files may be intentionally promoted.

Recommended `.gitignore` treatment:

```text id="u670qw"
.monad/cache/
.monad/tmp/
.monad/inspections/
.monad/graph/
.monad/plans/*.tmp.json
```

Context outputs may be either ignored or committed depending on project policy.

---

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

---

# End of Part 3

Next logical continuation:

* ADR Set
* Traceability Matrix
* Risk Register
* Governance and Decision System
* Execution Plan
* Recommended Technology Strategy
* Final Review
