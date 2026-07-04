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