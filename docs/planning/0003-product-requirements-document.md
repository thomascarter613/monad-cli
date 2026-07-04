# 4. Product Requirements Document

## 4.1 Purpose of This Document

This Product Requirements Document defines the functional, non-functional, operational, safety, governance, and release requirements for Monad OS and Monad CLI.

It is intended to serve as a bridge between the Product Charter, architecture documents, roadmap, implementation work packets, tests, and release gates.

This PRD should answer:

* what Monad must do,
* what Monad must not do yet,
* who the product serves,
* which requirements are mandatory,
* which requirements are deferred,
* how success will be measured,
* what commands must exist,
* how those commands should behave,
* what safety constraints apply,
* what quality bar must be met,
* and what must be true before an early release is credible.

The PRD is not a full technical design. It defines the product requirements that later architecture, implementation, testing, documentation, and governance artifacts must satisfy.

---

## 4.2 Product Summary

Monad OS is a local-first SDLC control plane and monorepo operating system.

Monad CLI is the first executable product surface: a Rust single-binary command-line runtime named `monad`.

Monad helps users inspect, validate, document, graph, govern, plan, and safely evolve software repositories.

Its core product posture is:

* local-first,
* AI-native but AI-optional,
* cloud-agnostic,
* database-agnostic,
* framework-agnostic,
* governance-grade,
* native-tool-coordinating,
* documentation-aware,
* policy-aware,
* lifecycle-aware,
* and plan-backed before mutation.

The product should begin by making repositories understandable and trustworthy before expanding into mutation, generation, plugins, AI-assisted workflows, or hosted control-plane features.

---

## 4.3 Product Objectives

The primary objectives are:

1. Make repositories self-describing.
2. Make repository state inspectable.
3. Make source-of-truth rules explicit.
4. Make command behavior honest and cataloged.
5. Make repository checks deterministic.
6. Make documentation, ADRs, policies, work packets, and context first-class lifecycle artifacts.
7. Make repository relationships graphable.
8. Make AI workflows safer through deterministic context.
9. Make mutation reviewable before execution.
10. Preserve portability across tools, clouds, databases, frameworks, package managers, and AI providers.

---

## 4.4 Requirement Priority Model

Requirements use the following priority levels.

| Priority | Meaning                                                       |
| -------- | ------------------------------------------------------------- |
| P0       | Required for earliest credible CLI foundation.                |
| P1       | Required for useful local read-only repository understanding. |
| P2       | Required for v1 local-first governance-grade core.            |
| P3       | Important future extension, but not required early.           |
| P4       | Long-term or optional hosted/team capability.                 |

Release planning should not pull P3/P4 work ahead of unresolved P0/P1 safety and trust requirements unless there is an explicit ADR justifying the exception.

---

## 4.5 User Roles

The requirements are written with the following user roles in mind.

## 4.5.1 Solo Systems Builder

A solo developer building a serious system and needing strong local workflow, clear docs, deterministic handoffs, safe incremental layers, and no hosted dependency.

## 4.5.2 Platform Engineer

A developer responsible for repository standards, internal developer experience, policy checks, documentation validation, CI integration, and repeatable governance.

## 4.5.3 Staff or Principal Engineer

A senior technical leader responsible for architecture coherence, ADR discipline, dependency visibility, change impact, and lifecycle traceability.

## 4.5.4 AI-Assisted Developer

A developer using ChatGPT, Cursor, Copilot, Claude, or local LLMs who needs deterministic repository context, safety constraints, current work-packet state, and non-secret handoff summaries.

## 4.5.5 Governance, Security, or Compliance Stakeholder

A stakeholder who needs audit evidence, policy traceability, release gates, decision records, security controls, and evidence that the repository is governed.

---

## 4.6 Product Scope

## 4.6.1 Early Scope

The early product scope includes:

* Rust CLI foundation,
* command catalog,
* command surface contract tests,
* source-of-truth manifest handling,
* version/list/config commands,
* honest placeholders,
* read-only inspection,
* baseline checks,
* doctor diagnostics,
* graph output v0,
* docs check v0,
* context handoff v0,
* ADR/work-packet listing and validation,
* machine-readable output foundation,
* CI-friendly exit codes.

## 4.6.2 Mid-Term Scope

The mid-term product scope includes:

* plan schema,
* plan creation,
* dry-run apply,
* approved apply,
* rollback hints,
* policy check/explain,
* waiver model,
* docs/ADR/work-packet generation through plans,
* template metadata,
* pack metadata,
* native tool adapters,
* release readiness checks.

## 4.6.3 Long-Term Scope

The long-term product scope may include:

* advanced lifecycle graph querying,
* local graph cache,
* plugin system,
* pack registry,
* AI provider abstraction,
* AI-assisted plan explanation,
* AI-assisted artifact drafting,
* optional hosted control plane,
* team dashboards,
* repo fleet governance,
* compliance evidence reporting,
* release approval workflows.

---

## 4.7 Product Non-Goals

Early versions do not need:

* hosted dashboard,
* hosted backend,
* required database,
* real-time collaboration,
* autonomous AI code changes,
* complex distributed execution,
* enterprise SSO,
* fleet-wide repo management,
* visual graph UI,
* all possible language/framework generators,
* deep replacement of native build systems,
* Kubernetes-first deployment,
* plugin marketplace,
* graph database,
* cloud deployment automation,
* multi-tenant SaaS architecture,
* full compliance certification,
* or fully autonomous code-writing agents.

These may be future capabilities, but they are not requirements for the local-first foundation.

---

## 4.8 Core Goals

## Goal 1: Repository Understanding

Monad must inspect a repository and report its structure, projects, manifests, docs, policies, and known lifecycle artifacts.

### Priority

P1

### Rationale

Repository understanding is the foundation for all later validation, graphing, context generation, planning, and mutation.

### Success Criteria

A user can run `monad inspect` and receive a useful summary of the repository without relying on tribal knowledge.

---

## Goal 2: Repository Validation

Monad must validate that the repository conforms to expected structure, source-of-truth rules, command catalog expectations, and documentation lifecycle rules.

### Priority

P1

### Rationale

Monad must detect drift before it can safely govern or mutate repositories.

### Success Criteria

A user can run `monad check` and receive deterministic findings with actionable remediation guidance.

---

## Goal 3: Governed Command Surface

Monad must expose a cataloged CLI surface where each command has metadata describing whether it is implemented, mutating, dry-run capable, and plan-backed.

### Priority

P0

### Rationale

The CLI is the first product interface. It must be trustworthy before deeper features are implemented.

### Success Criteria

The command catalog and actual CLI surface are contract-tested and do not drift.

---

## Goal 4: Lifecycle Graph

Monad must model repository artifacts and relationships as a graph.

### Priority

P2

### Rationale

The lifecycle graph is the long-term product moat. It connects code, docs, ADRs, work packets, tests, policies, plans, releases, and context.

### Success Criteria

A user can generate graph output showing at least workspace, project, documentation, and lifecycle artifact relationships.

---

## Goal 5: Context and Handoff

Monad must produce deterministic context packs and handoff summaries for humans and AI assistants.

### Priority

P1

### Rationale

Context handoff creates immediate value for solo developers, teams, and AI-assisted workflows.

### Success Criteria

A user can run `monad context handoff` and receive a useful Markdown summary that excludes secrets by default.

---

## Goal 6: Plan-Backed Mutation

Monad must eventually require repository mutations to be represented as explicit change plans before application.

### Priority

P2

### Rationale

Mutation safety is central to becoming a governance-grade tool rather than a risky scaffolder.

### Success Criteria

A user can generate a plan, dry-run it, review it, and explicitly approve it before files are modified.

---

## Goal 7: Documentation Integrity

Monad must help validate and generate repository documentation.

### Priority

P1 for validation, P2 for generation

### Rationale

Documentation is a lifecycle artifact and must be connected to repository state.

### Success Criteria

`monad docs check` can identify missing or stale required documentation. Generation is preview-only or plan-backed.

---

## Goal 8: Policy and Governance

Monad must support policy checks, explanations, and eventually waivers.

### Priority

P2

### Rationale

Policy and governance turn repository understanding into enforceable standards.

### Success Criteria

A user can run policy checks, understand policy failures, and eventually record auditable waivers.

---

## Goal 9: Tool Coordination

Monad must coordinate native tools without unnecessarily replacing them.

### Priority

P2

### Rationale

Monad’s role is SDLC control plane, not replacement for Cargo, Bun, Moon, Turborepo, Docker, GitHub Actions, or other mature tools.

### Success Criteria

Monad can detect native tools, report their presence, and eventually delegate to them through adapters.

---

## Goal 10: Portability

Monad must avoid required dependencies on a specific cloud, database, framework, package manager, task runner, forge, or AI provider.

### Priority

P0/P1

### Rationale

Portability is part of the core product identity.

### Success Criteria

Core commands work locally without SaaS, cloud, database, AI provider, or external infrastructure.

---

# 4.9 Functional Requirements

## 4.9.1 Command Surface Requirements

### FR-001: CLI Version Command

Priority: P0

The CLI must expose:

```bash id="gwlwfz"
monad version
```

It must output the binary version.

It should eventually support build metadata such as:

* Git commit,
* build date,
* target platform,
* enabled features,
* schema versions.

Acceptance criteria:

1. `monad version` exits successfully.
2. Output includes the semantic version.
3. Output is stable enough for smoke tests.
4. Command does not require a workspace.
5. Command does not read or write repository files.

---

### FR-002: Command Catalog

Priority: P0

Monad must maintain an internal command catalog.

Each command entry must include:

```text id="7damd5"
name
description
namespace
implemented
mutating
plan_backed
supports_dry_run
stability
```

It should eventually include:

```text id="2aqpdd"
examples
aliases
output_formats
required_workspace
risk_level
related_work_packet
related_docs
```

Acceptance criteria:

1. Every known command has a catalog entry.
2. Mutating commands are explicitly marked.
3. Planned commands are explicitly marked.
4. The command catalog can be rendered by `monad list`.
5. The command catalog can be validated against the CLI command tree.
6. Tests fail if catalog and CLI surface drift.

---

### FR-003: List Commands

Priority: P0

Monad must expose:

```bash id="h2uvzi"
monad list
```

It must list known commands and distinguish:

* implemented commands,
* planned commands,
* read-only commands,
* mutating commands,
* dry-run-capable commands,
* plan-backed commands.

Acceptance criteria:

1. `monad list` exits successfully.
2. It displays implemented and planned commands honestly.
3. It does not claim planned commands are implemented.
4. It should support machine-readable output eventually.
5. It does not require a workspace.

---

### FR-004: Config Inspection

Priority: P0/P1

Monad must expose:

```bash id="go25e0"
monad config
monad config list
monad config inspect
```

The config commands must explain canonical configuration sources and resolved configuration.

Minimum behavior:

* identify `monad.toml` as canonical,
* identify `workspace.toml` as compatibility mirror only,
* identify `monad.lock` as resolved state,
* identify `.monad/` as local runtime/cache/context state,
* report missing config clearly.

Acceptance criteria:

1. `monad config` exits successfully when no workspace is needed for basic help.
2. `monad config list` is exposed in the CLI if listed in the catalog.
3. `monad config inspect` reports canonical configuration if a workspace exists.
4. Conflicts between `monad.toml` and `workspace.toml` are reported.
5. Config commands do not silently modify files.

---

### FR-005: Repository Inspection

Priority: P1

Monad must expose:

```bash id="08fhm0"
monad inspect
```

It must inspect repository structure, manifests, workspace files, docs, and known project areas.

Inspection should eventually detect:

* workspace root,
* canonical manifest,
* compatibility mirror,
* lockfile,
* `.monad/` state,
* apps,
* services,
* packages,
* libraries,
* docs,
* ADRs,
* work packets,
* policies,
* CI workflows,
* native tool manifests,
* likely generated files,
* missing expected directories.

Acceptance criteria:

1. `monad inspect` finds the workspace root.
2. It reports the canonical manifest state.
3. It reports detected project areas.
4. It reports known lifecycle artifacts.
5. It does not mutate files.
6. It supports text output initially.
7. It should support JSON output eventually.

---

### FR-006: Repository Check

Priority: P1

Monad must expose:

```bash id="29oq3j"
monad check
```

It must validate core repository invariants.

Initial checks should include:

* workspace root detection,
* canonical manifest presence,
* source-of-truth consistency,
* command catalog integrity,
* required docs presence,
* required governance paths,
* basic `.monad/` state rules,
* placeholder command honesty.

Acceptance criteria:

1. Valid repositories pass.
2. Invalid repositories produce findings.
3. Findings include severity.
4. Findings include remediation where possible.
5. CI mode should return nonzero on blocking findings.
6. Command is read-only.

---

### FR-007: Doctor

Priority: P1

Monad must expose:

```bash id="6tibsd"
monad doctor
```

It must provide higher-level diagnostics and recommended fixes.

Doctor differs from check:

* `check` validates rules.
* `doctor` explains likely causes and remediation.

Acceptance criteria:

1. `monad doctor` groups related findings.
2. It provides actionable remediation hints.
3. It identifies common setup issues.
4. It identifies manifest conflicts.
5. It identifies missing docs/governance artifacts.
6. It is read-only.

---

### FR-008: Graph Output

Priority: P1/P2

Monad must expose:

```bash id="8wv5cl"
monad graph
```

It should eventually support:

```bash id="mcb4vh"
monad graph --format text
monad graph --format json
monad graph --format mermaid
monad graph --format dot
```

Initial graph nodes may include:

* workspace,
* project,
* manifest,
* docs,
* ADR,
* work packet,
* policy,
* command.

Initial graph edges may include:

* contains,
* documents,
* governs,
* implements,
* depends_on,
* generated_from,
* validates.

Acceptance criteria:

1. Graph output includes workspace node.
2. Graph output includes detected project nodes.
3. Graph output does not reference missing nodes.
4. Mermaid output is syntactically usable when supported.
5. JSON output is schema-versioned when supported.

---

### FR-009: Diff and Drift Detection

Priority: P2

Monad must expose:

```bash id="h8d767"
monad diff
```

It should eventually compare actual repo state against expected, documented, generated, or planned state.

Examples:

* manifest claims project exists but path missing,
* docs mention command that no longer exists,
* generated file differs from template,
* `workspace.toml` mirror differs from `monad.toml`,
* plan expects state that no longer exists.

Acceptance criteria:

1. `monad diff` reports drift without mutation.
2. Drift findings include affected paths.
3. Drift findings include expected versus actual where practical.
4. Drift output supports text and eventually JSON.

---

### FR-010: Context Handoff

Priority: P1

Monad must expose:

```bash id="dits1l"
monad context handoff
monad context pack
monad context verify
```

It must produce deterministic context artifacts for humans and AI assistants.

Initial handoff should include:

* workspace identity,
* product summary,
* current command surface,
* manifest/source-of-truth rules,
* detected project areas,
* docs/governance summary,
* current work packet if detectable,
* risks or missing data,
* recommended next actions.

Context safety requirements:

* exclude secrets by default,
* exclude `.env` files by default,
* exclude private keys by default,
* identify excluded sensitive paths without printing contents,
* allow deterministic generation without AI.

Acceptance criteria:

1. `monad context handoff` produces Markdown.
2. It works without AI configuration.
3. It excludes common secret files.
4. It includes current repository state.
5. It is deterministic for the same repo state.
6. It does not mutate files unless explicitly writing output to a requested path.

---

### FR-011: Docs Check

Priority: P1

Monad must expose:

```bash id="nwf40y"
monad docs check
```

It must validate documentation existence, freshness, and consistency.

Initial required docs may include:

* README,
* product charter,
* PRD,
* architecture overview,
* ADR index,
* roadmap,
* testing strategy,
* security model,
* governance model.

Acceptance criteria:

1. Missing required docs are reported.
2. Findings include expected paths.
3. Docs check is read-only.
4. Docs check can run in CI.
5. Docs check should eventually support profiles.

---

### FR-012: ADR Lifecycle

Priority: P1/P2

Monad must expose:

```bash id="tp8nmt"
monad adr list
monad adr new
monad adr supersede
```

Early mutating ADR commands should be dry-run or plan-backed.

Initial behavior:

* `monad adr list` is read-only.
* `monad adr new --dry-run` previews a new ADR.
* `monad adr supersede --dry-run` previews supersession changes.

Acceptance criteria:

1. ADR list reads existing ADRs.
2. ADR list reports status when detectable.
3. ADR creation does not write files unless dry-run/plan/apply rules are satisfied.
4. ADR formatting is validated.
5. ADR commands integrate with docs/governance paths.

---

### FR-013: Work Packet Lifecycle

Priority: P1/P2

Monad must expose:

```bash id="cj0aku"
monad workpacket list
monad workpacket new
monad workpacket plan
```

Early mutating work-packet commands should be dry-run or plan-backed.

Acceptance criteria:

1. Work packet list reads existing work packets.
2. Work packet status is reported when detectable.
3. Work packet plan emits ordered layers where possible.
4. New work-packet creation is dry-run or plan-backed.
5. Work-packet files follow a documented structure.

---

### FR-014: Policy Commands

Priority: P2

Monad must expose:

```bash id="7q95vr"
monad policy check
monad policy explain
monad policy waive
```

Policy waivers must eventually be auditable.

Initial behavior:

* `policy check` evaluates built-in or configured rules.
* `policy explain` explains a policy and remediation.
* `policy waive` is disabled, placeholder, dry-run, or plan-backed until waiver governance exists.

Acceptance criteria:

1. Policy findings have stable IDs.
2. Policy findings include severity.
3. Policy explanations include rationale and remediation.
4. Waivers are not silently created.
5. Waiver creation is auditable when implemented.

---

### FR-015: Plan Commands

Priority: P2

Monad must expose:

```bash id="c9m17y"
monad plan
```

It must create structured change plans.

A plan should include:

* plan ID,
* schema version,
* workspace snapshot,
* requested operation,
* files to create,
* files to modify,
* files to delete,
* commands to run,
* expected outputs,
* policy findings,
* risk level,
* rollback hints,
* approval requirements.

Acceptance criteria:

1. Plans are inspectable before apply.
2. Plans are machine-readable.
3. Plans list all intended file operations.
4. Plans identify risky actions.
5. Plans can be dry-run.

---

### FR-016: Apply Commands

Priority: P2

Monad must expose:

```bash id="n8qgp7"
monad apply
```

It must apply plans only through controlled behavior.

Minimum mature flags:

```bash id="vft9ax"
monad apply plan.json --dry-run
monad apply plan.json --yes
```

Acceptance criteria:

1. Apply refuses missing or invalid plans.
2. Dry-run does not write files.
3. Approved apply writes only planned files.
4. Apply reports success/failure.
5. Apply reports partial failure if it occurs.
6. Apply includes rollback hints where practical.
7. Apply is policy-gated when policy integration exists.

---

### FR-017: Mutating Commands

Priority: P2/P3

The following commands should eventually become plan-backed:

```bash id="5jenwv"
monad add
monad remove
monad rename
monad move
monad generate
monad sync
monad clean
monad migrate
monad upgrade
```

Acceptance criteria:

1. Mutating commands do not silently modify files.
2. Mutating commands produce plans or require plan/apply.
3. Dangerous operations require explicit approval.
4. File deletions require clear confirmation.
5. Generated files include traceability metadata where appropriate.

---

### FR-018: Placeholder Honesty

Priority: P0

A planned command that is not fully implemented must say so clearly.

Output should include:

```text id="jcvrrc"
implemented: false
mutating: true|false
plan_backed: true|false
supports_dry_run: true|false
```

Acceptance criteria:

1. Placeholder commands do not pretend to be implemented.
2. Planned mutating commands identify future risk.
3. Placeholder behavior is tested.
4. Placeholder output is consistent.
5. Placeholder commands return a deliberate status code if appropriate.

---

## 4.10 Additional Functional Requirements

### FR-019: Workspace Root Detection

Priority: P1

Monad must detect the workspace root from a nested directory.

Detection order should consider:

1. `monad.toml`,
2. Git root,
3. known workspace markers,
4. explicit `--workspace-root` flag later.

Acceptance criteria:

1. Running from a child directory can find the workspace.
2. Missing workspace produces a clear finding.
3. Root detection is deterministic.

---

### FR-020: Canonical Manifest Rules

Priority: P0/P1

Monad must treat `monad.toml` as canonical.

`workspace.toml` must be treated as a compatibility mirror only.

Acceptance criteria:

1. If both files exist, `monad.toml` wins.
2. Conflicts are reported.
3. Compatibility mirror behavior is documented.
4. No command treats `workspace.toml` as canonical unless explicitly operating in migration/compatibility mode.

---

### FR-021: Output Format Support

Priority: P1/P2

Commands should support appropriate formats.

Common formats:

```bash id="chskrw"
--format text
--format json
--format markdown
```

Graph-specific formats:

```bash id="a9y00e"
--format mermaid
--format dot
```

Acceptance criteria:

1. Human-readable output is default.
2. JSON output is stable when supported.
3. Markdown output is useful for docs/context.
4. Graph output is valid for target format when supported.

---

### FR-022: Exit Code Standardization

Priority: P1

Monad must use consistent exit codes.

Recommended exit codes:

```text id="idrbub"
0  success
1  general failure
2  validation failed
3  configuration error
4  workspace not found
5  command not implemented
6  policy violation
7  unsafe mutation blocked
8  plan required
9  apply failed
10 external tool failed
```

Acceptance criteria:

1. CI-relevant commands return nonzero on blocking failures.
2. Placeholder commands return a deliberate status code.
3. Exit code behavior is documented.
4. Exit code behavior is tested.

---

### FR-023: Native Tool Detection

Priority: P2

Monad must detect native tools and manifests without replacing them.

Initial detection may include:

* Cargo,
* Bun,
* npm,
* pnpm,
* Moon,
* Turborepo,
* Biome,
* Docker,
* GitHub Actions,
* Git.

Acceptance criteria:

1. Tool detection is read-only.
2. Detected tools are reported in inspection.
3. Missing optional tools are not fatal unless required by config.
4. Native tool authority is respected.

---

### FR-024: Generated Artifact Traceability

Priority: P2

Generated files should include traceability metadata where appropriate.

Metadata may include:

* generated by Monad,
* generator name,
* template version,
* plan ID,
* source manifest hash,
* timestamp,
* work packet.

Acceptance criteria:

1. Generated artifacts can be traced to a generator or plan.
2. Regeneration risk is documented.
3. Generated artifacts do not silently overwrite user edits without plan/apply.

---

### FR-025: Documentation Generation

Priority: P2

Monad should eventually support:

```bash id="fckszb"
monad docs generate
```

Initial generation must be preview-only, dry-run, or plan-backed.

Acceptance criteria:

1. Docs generation previews intended files.
2. Docs generation does not overwrite files silently.
3. Generated docs use documented templates.
4. Generation integrates with plan/apply.

---

### FR-026: Release Planning

Priority: P3

Monad should eventually expose:

```bash id="d3pz7h"
monad release plan
monad release apply
monad release publish
```

Early release commands should be placeholders or dry-run.

Acceptance criteria:

1. Release plans summarize changes, tests, policies, docs, and risks.
2. Release apply/publish are disabled until governance exists.
3. Release evidence can be generated later.

---

# 4.11 Non-Functional Requirements

## NFR-001: Local-First Operation

Priority: P0

Monad must work without:

* SaaS account,
* hosted backend,
* cloud account,
* API key,
* AI provider,
* external database,
* Kubernetes cluster.

Acceptance criteria:

1. Core read-only commands work offline.
2. No network call occurs by default.
3. No AI provider is required.
4. No database server is required.

---

## NFR-002: Performance

Priority: P1

Common read-only commands should feel fast enough for everyday use.

Initial target:

```text id="t228bu"
monad version: <100ms typical
monad list: <200ms typical
monad inspect small repo: <1s typical
monad check small repo: <1s typical
```

These are guidance targets, not hard guarantees for all systems.

Acceptance criteria:

1. Basic commands do not feel sluggish.
2. Performance regressions are noticed through tests or benchmarks later.
3. Large repo scans can eventually be optimized or cached.

---

## NFR-003: Determinism

Priority: P0/P1

Given the same repo state and same Monad version, read-only commands should produce stable output.

Acceptance criteria:

1. Snapshot tests can be used for stable outputs.
2. Output ordering is deterministic where practical.
3. Random IDs are avoided in read-only output unless required.
4. Timestamps are omitted or controlled in deterministic outputs.

---

## NFR-004: Machine-Readable Output

Priority: P1/P2

Commands should eventually support structured output:

```bash id="10dz4f"
--format text
--format json
--format markdown
```

Graph commands should also support:

```bash id="1jajzz"
--format mermaid
--format dot
```

Acceptance criteria:

1. JSON output includes schema version when stable.
2. Machine-readable outputs are documented.
3. CI commands can consume structured output.

---

## NFR-005: Safety

Priority: P0

Mutating operations must not silently rewrite repositories.

Acceptance criteria:

1. Read-only commands are proven read-only.
2. Mutating commands are marked in catalog.
3. Mutation requires dry-run, plan, or explicit approval.
4. Dangerous operations are blocked until plan/apply exists.

---

## NFR-006: Testability

Priority: P0/P1

Core behavior must be covered by unit, integration, smoke, contract, snapshot, and fixture tests where appropriate.

Acceptance criteria:

1. Command catalog contract is tested.
2. CLI smoke tests exist.
3. Manifest rules are unit tested.
4. Read-only safety is tested.
5. Fixture repos are used for inspection/check behavior.

---

## NFR-007: Portability

Priority: P1/P2

Monad should run on common developer platforms:

* Linux,
* macOS,
* Windows eventually.

Acceptance criteria:

1. Path handling is platform-aware.
2. Shell assumptions are minimized.
3. Rust single-binary distribution remains viable.
4. CI eventually tests multiple platforms.

---

## NFR-008: Extensibility

Priority: P2

The design must allow future packs, templates, plugins, policies, and profiles without destabilizing the core.

Acceptance criteria:

1. Core types are separated from CLI dispatch.
2. Policy/template/pack metadata can evolve.
3. Plugins are not required early.
4. Extension points are designed after core behavior is proven.

---

## NFR-009: Security

Priority: P0/P1

Monad must avoid dangerous behavior such as executing untrusted code, leaking secrets, or blindly applying generated changes.

Acceptance criteria:

1. Context excludes common secret files.
2. No network calls happen by default.
3. Plugins are disabled or absent by default.
4. External command execution is explicit.
5. AI-generated changes are not applied automatically.

---

## NFR-010: Governance

Priority: P1/P2

Material repository changes must be traceable to plans, work packets, ADRs, or explicit user action where appropriate.

Acceptance criteria:

1. Significant generated artifacts can identify source.
2. Plans can map to work packets later.
3. ADR and work-packet docs are discoverable.
4. Policy waivers are eventually auditable.

---

## NFR-011: Usability

Priority: P1

Monad must be understandable from terminal output.

Acceptance criteria:

1. Error messages explain the problem.
2. Findings include remediation where possible.
3. Commands have clear help text.
4. Common workflows are discoverable.
5. Output avoids unnecessary jargon where possible.

---

## NFR-012: Reliability

Priority: P1

Monad must fail safely.

Acceptance criteria:

1. Failed commands do not leave hidden partial state.
2. Apply failures report what happened.
3. Read-only failures do not mutate files.
4. Missing optional files produce findings, not panics.

---

## NFR-013: Auditability

Priority: P2

Monad should produce evidence for significant checks and changes.

Acceptance criteria:

1. Plans are reviewable.
2. Apply results are recordable.
3. Policy findings have stable identifiers.
4. Context exports can identify generation source.
5. Release evidence can be generated later.

---

## NFR-014: Privacy

Priority: P1

Monad must not expose repository content externally by default.

Acceptance criteria:

1. No telemetry by default.
2. No AI calls by default.
3. No network calls by default.
4. Context generation excludes sensitive files.
5. External export requires explicit user action.

---

# 4.12 Data Requirements

## DR-001: Manifest Data

Monad must read and interpret `monad.toml` as the canonical manifest.

## DR-002: Compatibility Mirror Data

Monad may read `workspace.toml` as a compatibility mirror, but it must not treat it as canonical.

## DR-003: Lockfile Data

Monad should eventually read and write `monad.lock` as resolved state.

## DR-004: Local State Data

Monad may use `.monad/` for cache, context, inspections, graphs, plans, and temporary files.

## DR-005: Documentation Data

Monad must be able to discover docs, ADRs, work packets, security docs, governance docs, and roadmap docs.

## DR-006: Graph Data

Monad must be able to represent lifecycle graph nodes and edges in memory and eventually export them.

## DR-007: Plan Data

Monad must define a structured plan model before enabling meaningful mutation.

## DR-008: Policy Data

Monad must define policy identifiers, severities, findings, explanations, and eventual waivers.

---

# 4.13 Security and Privacy Requirements

## SPR-001: Secret Exclusion

Context generation must exclude common secret files by default.

Examples:

```text id="lrj6e2"
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

## SPR-002: No External Calls by Default

Monad must not call external services by default.

## SPR-003: No AI Calls by Default

Monad must not call AI providers unless explicitly configured.

## SPR-004: No Telemetry by Default

Monad must not send telemetry by default.

## SPR-005: External Tool Execution Control

Monad must not execute external tools unexpectedly.

## SPR-006: Plugin Safety

Plugins, if added later, must use a trust model with explicit installation, checksums, permissions, and eventually signatures.

## SPR-007: AI Suggestion Safety

AI-generated suggestions must become reviewable plans before any mutation.

---

# 4.14 AI Requirements

## AIR-001: AI Optionality

All core workflows must work without AI.

## AIR-002: Deterministic Context

Context generation must be deterministic before AI enhancement.

## AIR-003: Provider Abstraction

Future AI support must use provider abstraction.

## AIR-004: Noop Provider

A no-op provider must exist conceptually so AI absence is a supported state.

## AIR-005: Human Approval

AI-assisted mutation must require human approval.

## AIR-006: Prompt and Context Versioning

Future AI prompt/context templates should be versioned.

## AIR-007: AI Audit Metadata

Future AI-assisted workflows should record provider, prompt version, context version, plan ID, and approval status where appropriate.

---

# 4.15 CLI UX Requirements

## CUX-001: Command Discoverability

Users must be able to discover commands through help and `monad list`.

## CUX-002: Clear Help Text

Each command must explain what it does.

## CUX-003: Honest Status

Commands that are planned but incomplete must say so.

## CUX-004: Safe Defaults

Commands should default to read-only, dry-run, preview, or explicit approval modes where risk exists.

## CUX-005: Human and Machine Modes

Human-readable output is default. Machine-readable output should be available for automation where appropriate.

## CUX-006: Actionable Findings

Findings should include severity, path, message, and remediation where possible.

---

# 4.16 Integration Requirements

## IR-001: Native Tool Detection

Monad must detect native tools and manifests before delegating to them.

## IR-002: Native Tool Authority

Native tools remain authoritative for their own domains.

## IR-003: Adapter-Based Coordination

Future native tool integration should use adapters.

## IR-004: CI Integration

`monad check`, `monad docs check`, and `monad policy check` should eventually support CI-friendly behavior.

## IR-005: Git Awareness

Monad should detect Git root and Git state where useful, but not require Git for all commands unless necessary.

---

# 4.17 Release Criteria for Early v0

A credible early release should satisfy:

1. CLI installs and runs locally.
2. `monad version` works.
3. `monad list` reflects command catalog accurately.
4. Command catalog and Clap surface remain contract-tested.
5. `monad config` explains canonical manifest rules.
6. `monad config list` is exposed if cataloged.
7. `monad inspect` provides useful read-only repo state.
8. `monad check` validates baseline invariants.
9. `monad doctor` provides actionable diagnostics.
10. `monad graph` emits at least text or JSON.
11. `monad context handoff` emits deterministic Markdown.
12. `monad docs check` identifies missing required docs.
13. Placeholder commands are honest.
14. Mutating commands are not dangerous.
15. No AI provider is required.
16. No hosted backend is required.
17. No external database is required.
18. Tests pass in CI.
19. README explains status honestly.
20. ADRs document the architecture choices.
21. Work packets document implementation sequencing.

---

# 4.18 MVP Definition

The MVP should be:

> A local CLI that can understand, validate, summarize, and explain a repository safely and honestly.

The MVP should not be:

> A universal app/service/package generator.

Minimum MVP commands:

```bash id="3rl0sh"
monad version
monad list
monad config
monad inspect
monad check
monad doctor
monad graph
monad docs check
monad context handoff
```

Minimum MVP properties:

* local-first,
* no required AI,
* no required database,
* no required cloud,
* read-only by default,
* deterministic output where practical,
* honest placeholders,
* test-backed command surface.

---

# 4.19 v1 Definition

A credible v1 local-first Monad core should include:

* stable CLI command surface,
* stable command catalog,
* canonical manifest model,
* workspace root detection,
* repository inspection,
* repository checks,
* doctor diagnostics,
* docs check,
* ADR lifecycle support,
* work-packet lifecycle support,
* context handoff,
* lifecycle graph v0/v1,
* plan schema,
* dry-run apply,
* safe apply for selected low-risk operations,
* policy check/explain,
* initial template/pack metadata,
* native tool detection,
* structured output,
* CI integration,
* documented testing strategy,
* documented security model,
* documented governance model,
* documented release process.

---

# 4.20 Acceptance Criteria Summary

The PRD is satisfied for early local core when:

1. The CLI is runnable locally.
2. The command catalog is complete for known commands.
3. The command catalog and CLI surface match.
4. Placeholder commands are honest.
5. `monad.toml` is canonical.
6. `workspace.toml` is mirror-only.
7. Read-only commands do not mutate files.
8. Inspection reports useful repository state.
9. Checks report meaningful findings.
10. Doctor output is actionable.
11. Graph output is useful.
12. Context handoff is deterministic and secret-safe.
13. Docs checks identify required documentation gaps.
14. Mutation is blocked, dry-run, preview-only, or plan-backed.
15. Tests prove the above.
16. Documentation accurately reflects product state.

---

# 4.21 Open Questions

The following questions should be resolved through later ADRs, work packets, or implementation experiments:

1. What is the exact initial schema for `monad.toml`?
2. What is the exact initial JSON schema for command catalog output?
3. Which docs are required by default versus profile-specific?
4. What is the first stable graph node/edge schema?
5. Should `monad check` and `monad doctor` share a common findings engine?
6. What should be the exact exit code behavior for placeholder commands?
7. Which commands require a workspace and which do not?
8. How should `.monad/` artifacts be ignored, committed, or promoted?
9. What is the first safe plan-backed mutation?
10. Should ADR/work-packet creation be implemented before general project generation?
11. Which native tool adapter should be first after Git/Cargo detection?
12. When should SQLite/local indexing become justified?
13. When should AI provider support become justified?
14. What is the minimum required policy model for v1?
15. What is the first hosted-control-plane feature, if any, that would justify leaving local-only operation?

---

# 4.22 PRD Change Control

This PRD should be updated when:

* product scope changes,
* command behavior changes,
* release criteria change,
* source-of-truth rules change,
* AI assumptions change,
* mutation safety rules change,
* governance requirements change,
* or architecture decisions alter product behavior.

Significant changes to this PRD should be linked to:

* an ADR,
* a work packet,
* a roadmap update,
* and relevant tests.

This PRD should not drift away from actual CLI behavior. Future `monad docs check` or similar documentation validation should eventually help enforce that alignment.
