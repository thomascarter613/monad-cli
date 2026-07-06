# 21. Governance and Decision System

## 21.1 Purpose of This Section

This section defines the governance and decision system for Monad OS / Monad CLI.

Monad is intended to become a local-first, governance-grade SDLC control plane and monorepo operating system. That means governance is not an accessory feature. Governance is part of the product’s core identity.

The purpose of this section is to define how Monad decisions should be made, recorded, reviewed, traced, and enforced without creating unnecessary bureaucracy.

Monad governance must answer:

```text id="j1b2mz"
What changed?
Why did it change?
Who or what approved it?
What policy applied?
What test proves it?
What docs explain it?
What risk remains?
```

This governance system applies to:

* product decisions,
* architecture decisions,
* command-surface decisions,
* source-of-truth decisions,
* mutation-safety decisions,
* documentation decisions,
* risk decisions,
* release decisions,
* security decisions,
* dependency decisions,
* AI workflow decisions,
* hosted-control-plane decisions,
* and future plugin/pack trust decisions.

The system is intentionally local-first and repository-native. Governance should live in version-controlled artifacts before it lives in external tools.

The early governance model should use:

* Markdown documents,
* ADRs,
* work packets,
* risk register entries,
* command catalog metadata,
* tests,
* local reports,
* and release evidence.

Future Monad commands may validate and explain these artifacts, but the first governance system must be useful even before those commands exist.

---

## 21.2 Governance Philosophy

Monad governance should make serious development safer, clearer, and more traceable without making development slow, ceremonial, or enterprise-heavy.

The goal is disciplined development, not bureaucracy.

Governance should help a solo developer, small team, or future enterprise answer the important questions behind a repository:

* What is this repository?
* What is the source of truth?
* What commands exist?
* Which commands are implemented?
* Which commands are placeholders?
* Which commands mutate files?
* What architecture decisions have been made?
* Which decisions are still proposed?
* What work packets are active?
* What risks are known?
* What policies apply?
* What tests prove behavior?
* What documentation explains the system?
* What release evidence exists?
* What context is safe to hand off to humans or AI?

Monad governance must be lightweight enough to use locally but rigorous enough to support serious software delivery.

The guiding governance doctrine is:

```text id="g6iqtw"
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

Every governance mechanism should reinforce this doctrine.

If a governance mechanism makes Monad harder to use without increasing trust, it should be simplified.

If a governance mechanism allows unsafe ambiguity, it should be strengthened.

---

## 21.3 Governance Scope

Monad governance covers the development, operation, and evolution of the Monad repository and product.

It includes governance for:

* repository structure,
* manifests and source-of-truth files,
* command catalog and CLI surface,
* placeholder command honesty,
* read-only repository inspection,
* graph modeling,
* documentation lifecycle,
* ADR lifecycle,
* work-packet lifecycle,
* risk lifecycle,
* policy lifecycle,
* context generation,
* AI assistance,
* plan-backed mutation,
* native tool coordination,
* templates and packs,
* release readiness,
* optional hosted sync,
* and future extensibility.

It does not initially require:

* external GRC systems,
* Jira,
* Linear,
* ServiceNow,
* hosted dashboards,
* SaaS governance products,
* graph databases,
* centralized approval workflow engines,
* cloud accounts,
* Kubernetes,
* or enterprise identity systems.

Those may become integrations later, but they must not be required for the local-first core.

---

## 21.4 Governance Principles

### 21.4.1 Governance Must Be Local-First

Core governance must work from repository files.

A user should be able to clone the repository and inspect its governance state locally.

Required local governance artifacts include:

* `README.md`,
* `monad.toml`,
* `workspace.toml` as compatibility mirror only,
* `monad.lock`,
* `docs/`,
* `docs/planning/`,
* `docs/architecture/decision-records/`,
* `governance/`,
* `policies/`,
* work packet files,
* risk register files,
* command catalog documentation,
* and tests.

Future hosted features may aggregate or visualize governance, but hosted infrastructure must not become the source of truth for core governance.

### 21.4.2 Governance Must Be Traceable

Significant changes should connect to a traceable path:

```text id="odgqg8"
Epic -> Work Packet -> Layer -> Commit/PR
```

For larger product and architecture decisions, the trace should extend further:

```text id="c3t7xo"
Business Goal
  -> User Need
    -> Product Requirement
      -> ADR
        -> Work Packet
          -> Layer
            -> Test Evidence
              -> Documentation
                -> Release Evidence
```

Traceability does not need to be automated at first. Markdown links and stable identifiers are enough for early stages.

### 21.4.3 Governance Must Be Proportional

Not every change needs an ADR.

Not every refactor needs a formal risk update.

Not every documentation edit needs a release plan.

Governance should scale with consequence.

A small internal refactor may require only:

* clear commit message,
* passing tests,
* and no behavior change.

A public command behavior change may require:

* work packet update,
* command catalog update,
* tests,
* documentation update,
* and release note.

A mutation model change may require:

* ADR,
* risk update,
* security review,
* test plan,
* documentation,
* and release-readiness review.

### 21.4.4 Governance Must Be Test-Backed

Monad must not merely claim governance. It should test the behavior that supports governance.

Examples:

* command catalog matches Clap surface,
* placeholders are honest,
* read-only commands do not write files,
* dry-run commands do not mutate canonical files,
* apply commands write only planned files,
* manifest resolution follows source-of-truth rules,
* context generation excludes secrets,
* policy checks explain findings,
* docs checks validate required documentation,
* release checks validate evidence.

The principle is:

```text id="b5epjq"
If Monad claims to understand, validate, document, graph, govern, plan, or mutate a repository, there must be tests proving that behavior.
```

### 21.4.5 Governance Must Preserve Developer Agency

Monad should inform and constrain unsafe behavior, but it should not hide decisions from the user.

For risky workflows, Monad should prefer:

* explicit findings,
* explainable policy,
* dry-run previews,
* plan files,
* approval flags,
* audit metadata,
* and reversible or recoverable behavior.

It should avoid:

* silent mutation,
* hidden network calls,
* implicit AI provider usage,
* undocumented policy enforcement,
* surprise file rewrites,
* and opaque generated state.

---

## 21.5 Decision Levels

Not all decisions require the same artifact.

The following levels define the minimum artifact needed for different kinds of decisions.

| Level                        | Example                                                             | Required Artifact                                        |
| ---------------------------- | ------------------------------------------------------------------- | -------------------------------------------------------- |
| Minor implementation         | Internal refactor, small helper function, non-user-visible cleanup  | Commit message and tests where applicable                |
| Internal behavior            | Parser behavior, internal module boundary, test fixture design      | Work packet note or implementation note                  |
| User-visible behavior        | Command output change, new flag, changed exit code                  | Work packet update, command catalog update, tests        |
| Public contract              | JSON schema, manifest schema, command contract, exit code standard  | Work packet update, reference docs, schema tests         |
| Architecture decision        | New crate, graph schema, mutation model, source-of-truth change     | ADR                                                      |
| Governance/security decision | Policy model, waiver model, context safety, AI safety               | ADR + risk update                                        |
| Dependency decision          | New core dependency, security-sensitive library, runtime dependency | Dependency review note; ADR if strategically significant |
| Release decision             | Version, compatibility guarantee, distribution method               | Release plan and release evidence                        |
| Strategic decision           | Hosted control plane, plugin registry, enterprise features          | RFC first, ADR if accepted                               |

The artifact should match the risk.

Too little governance creates drift.

Too much governance creates drag.

---

## 21.6 Decision Authority Model

Monad should use role-based decision ownership rather than person-based ownership.

This keeps the governance model useful for solo development while remaining compatible with future teams.

Initial roles:

| Role              | Responsibility                                                                 |
| ----------------- | ------------------------------------------------------------------------------ |
| Product owner     | Product scope, roadmap, user value, command prioritization                     |
| Architect         | Architecture decisions, crate boundaries, source-of-truth model, graph model   |
| CLI maintainer    | Command surface, Clap alignment, output behavior, exit codes                   |
| Config owner      | Manifest resolution, `monad.toml`, compatibility mirrors, lockfiles            |
| Docs owner        | Documentation lifecycle, docs checks, ADR index, reference docs                |
| Security owner    | Context safety, secret redaction, supply-chain risk, external execution        |
| Plan engine owner | Plan schema, dry-run, apply behavior, rollback hints                           |
| Policy owner      | Built-in policies, policy explain, waivers, enforcement model                  |
| Graph owner       | Lifecycle graph model, exports, graph invariants                               |
| AI owner          | AI provider ports, prompt templates, AI audit metadata, deterministic fallback |
| Release owner     | Release gates, changelog, versioning, artifacts, release evidence              |
| Project owner     | Solo-development cadence, work packet flow, repository health                  |

In a solo-developer phase, one person may hold all roles.

The value of roles is not bureaucracy. The value is clarity.

When a decision is made, the relevant role should be obvious.

---

## 21.7 Decision Records

Monad should use different decision artifacts for different scopes.

| Artifact        | Purpose                                                        |
| --------------- | -------------------------------------------------------------- |
| Commit message  | Record small implementation decisions.                         |
| Work packet     | Record scoped implementation intent and acceptance criteria.   |
| ADR             | Record architecture decisions and durable product constraints. |
| RFC             | Explore large future features before acceptance.               |
| Risk register   | Record known risks and mitigations.                            |
| Policy document | Record rules and enforcement expectations.                     |
| Release plan    | Record release intent, gates, and evidence.                    |
| Changelog       | Record user-facing changes.                                    |

The artifact hierarchy should remain simple:

```text id="8dlqf1"
RFC explores.
ADR decides.
Work packet scopes.
Commit implements.
Test proves.
Documentation explains.
Release evidence packages.
```

---

## 21.8 ADR Process

Architecture Decision Records are required for durable decisions that shape Monad’s product, architecture, safety model, or governance model.

### 21.8.1 ADR Lifecycle

The ADR lifecycle is:

```text id="4c2d0c"
draft -> proposed -> accepted -> superseded -> deprecated
```

Recommended status definitions:

| Status     | Meaning                                              |
| ---------- | ---------------------------------------------------- |
| Draft      | Being written; not yet ready for review.             |
| Proposed   | Ready for review; not yet binding.                   |
| Accepted   | Binding decision for future work.                    |
| Superseded | Replaced by a newer ADR.                             |
| Deprecated | No longer recommended, but not necessarily replaced. |
| Rejected   | Considered and intentionally not adopted.            |

If the current repository only uses a subset of these statuses early, that is acceptable. The lifecycle should still be documented so the model can mature without redesign.

### 21.8.2 ADR Required Cases

An ADR is required when:

* architecture style changes,
* source-of-truth model changes,
* mutation safety model changes,
* AI architecture changes,
* persistence model changes,
* plugin trust model changes,
* public CLI contract changes significantly,
* graph model changes significantly,
* policy model changes significantly,
* local-first assumptions change,
* hosted architecture is introduced,
* a new durable crate boundary is introduced,
* or a new external dependency becomes strategically important.

### 21.8.3 ADR Not Required Cases

An ADR is usually not required for:

* small internal refactors,
* test cleanup,
* documentation typo fixes,
* non-user-visible implementation details,
* temporary scaffolding,
* adding a fixture,
* improving error text without changing semantics,
* or implementing behavior already decided by an accepted ADR.

### 21.8.4 ADR Template

A Monad ADR should include:

```markdown id="pwtswr"
# ADR-NNNN: Title

## Status

Proposed | Accepted | Superseded | Deprecated | Rejected

## Context

What problem, constraint, risk, or decision pressure led to this ADR?

## Decision

What decision is being made?

## Rationale

Why is this the right decision?

## Alternatives Considered

What other options were considered?

## Consequences

What improves?
What gets harder?
What constraints does this create?

## Impacted Areas

Commands:
Manifests:
Docs:
Tests:
Risks:
Work packets:

## Follow-Up Work

What must happen after this ADR?
```

### 21.8.5 ADR Index

The ADR index should list:

* ADR ID,
* title,
* status,
* date if available,
* related work packets,
* related risks,
* superseded-by links,
* and short summary.

The ADR index should eventually be validated by `monad docs check` or a future `monad adr check`.

### 21.8.6 Accepted ADRs Are Binding

Accepted ADRs must guide future planning and implementation.

If future work contradicts an accepted ADR, there are only three valid options:

1. change the future work,
2. create a superseding ADR,
3. explicitly document the contradiction as an open decision.

Future work must not silently drift away from accepted ADRs.

---

## 21.9 RFC Process

RFCs should be used for large future features before ADR acceptance.

An RFC is exploratory. It does not bind the architecture until converted into one or more ADRs or work packets.

RFCs are appropriate for:

* hosted control plane,
* plugin marketplace,
* pack registry,
* AI-assisted plan generation,
* graph persistence,
* organization/team model,
* enterprise policy model,
* remote sync,
* release artifact signing,
* local database introduction,
* or major command-surface expansion.

An RFC should include:

* problem,
* goals,
* non-goals,
* proposal,
* alternatives,
* compatibility,
* security impact,
* privacy impact,
* local-first impact,
* migration impact,
* testing plan,
* rollout plan,
* open questions,
* and decision path.

Recommended RFC lifecycle:

```text id="dtncq2"
draft -> review -> accepted for ADR/work-packet conversion -> closed
```

RFCs should not be used to bypass ADRs.

An accepted RFC means the idea is worth pursuing. It does not automatically make every technical decision inside it binding.

---

## 21.10 Work Packet Governance

Work packets are the primary unit of planned implementation.

A work packet should define:

* what is being built,
* why it matters,
* what is in scope,
* what is out of scope,
* which risks are affected,
* which ADRs apply,
* which tests are required,
* which docs must change,
* and what acceptance means.

Work packets should remain lightweight enough for solo development.

A work packet should not become a substitute for implementation.

A good work packet is specific enough to guide work but small enough to complete.

### 21.10.1 Work Packet Minimum Fields

Recommended minimum fields:

```markdown id="h1eb53"
# WP-NNNN: Title

## Status

Planned | Active | Complete | Deferred | Superseded

## Purpose

## Scope

## Out of Scope

## Related ADRs

## Related Risks

## Required Behavior

## Required Tests

## Required Documentation

## Acceptance Criteria
```

### 21.10.2 Work Packet Status

| Status     | Meaning                                      |
| ---------- | -------------------------------------------- |
| Planned    | Identified but not started.                  |
| Active     | Currently being implemented.                 |
| Complete   | Implemented, tested, and documented.         |
| Deferred   | Intentionally postponed.                     |
| Superseded | Replaced by another work packet.             |
| Blocked    | Cannot proceed until dependency is resolved. |

### 21.10.3 Work Packet Completion Rule

A work packet is not complete until:

* implementation is done,
* tests pass,
* docs are updated,
* related command catalog entries are updated,
* related risks are reviewed,
* related ADRs are linked,
* and acceptance criteria are satisfied.

---

## 21.11 Change Management

Every significant change should map to:

```text id="1cbmh5"
Epic -> Work Packet -> Layer -> Commit/PR
```

For the current solo-development workflow, a “layer” is a small implementation increment that can be applied, tested, and committed independently.

A minimum change record should include:

* what changed,
* why it changed,
* files affected,
* tests run,
* docs updated,
* risks affected,
* and follow-up work.

### 21.11.1 Change Classes

| Change Class             | Examples                                                  | Governance Required                                 |
| ------------------------ | --------------------------------------------------------- | --------------------------------------------------- |
| Class 0: Trivial         | Typos, formatting, comments                               | Commit message                                      |
| Class 1: Internal        | Refactor, test helper, fixture cleanup                    | Commit message + tests                              |
| Class 2: User-visible    | Command output, flag, error text, docs behavior           | Work packet update + tests + docs                   |
| Class 3: Contract        | JSON schema, manifest format, exit codes                  | Work packet + reference docs + compatibility review |
| Class 4: Architecture    | Crate boundary, graph model, plan/apply model             | ADR + tests + risk review                           |
| Class 5: Safety/Security | Mutation, context export, external execution, AI provider | ADR + security review + risk update                 |
| Class 6: Release         | Version/distribution/release artifacts                    | Release plan + evidence                             |

### 21.11.2 Change Control Rules

Monad should follow these rules:

* Do not introduce mutating behavior without plan/apply governance.
* Do not change public command behavior without tests.
* Do not change machine-readable output without schema review.
* Do not add AI provider behavior without opt-in and audit controls.
* Do not introduce executable plugins without trust model.
* Do not make hosted services required for local CLI behavior.
* Do not treat generated state as canonical source of truth.
* Do not remove or contradict accepted ADRs without superseding decision records.

---

## 21.12 Command Surface Governance

The command surface is a governed product contract.

Monad must prevent drift between:

* the command catalog,
* the Clap command tree,
* CLI help output,
* command documentation,
* placeholder status,
* tests,
* and roadmap expectations.

### 21.12.1 Command Catalog Rules

Each command should eventually have catalog metadata:

* command path,
* description,
* status,
* mutability,
* output formats,
* exit code behavior,
* related work packet,
* related docs,
* related tests,
* and implementation notes.

Example:

```text id="h2snvl"
command: config list
status: placeholder
mutability: read-only
related_wp: WP-0005
output: text
tests:
  - command_catalog_contract
```

### 21.12.2 Placeholder Honesty

Placeholder commands are allowed only if they are honest.

A placeholder command must:

* clearly state that it is not implemented or is partially implemented,
* avoid pretending to complete work,
* return a consistent exit code,
* avoid mutating files,
* appear in command catalog metadata,
* and be tested.

A placeholder command must not:

* silently succeed as if real behavior occurred,
* write files,
* generate incomplete artifacts without warning,
* call external tools unexpectedly,
* or imply safety guarantees that do not exist.

### 21.12.3 Mutability Metadata

Every command should eventually be classified as:

| Mutability     | Meaning                                                       |
| -------------- | ------------------------------------------------------------- |
| Read-only      | Does not write canonical repository files.                    |
| Dry-run        | Computes planned changes but does not write canonical files.  |
| Plan-producing | Produces a plan artifact but does not directly apply changes. |
| Mutating       | Writes files or changes repository state.                     |
| External       | Calls external tools or services.                             |

Mutation metadata should be visible in command catalog documentation.

---

## 21.13 Source-of-Truth Governance

Monad’s source-of-truth model is foundational.

The canonical rules are:

```text id="s5hfjs"
monad.toml      canonical Monad manifest
workspace.toml  compatibility mirror only
monad.lock      resolved state
.monad/         local generated/cache/context/report/plan state
```

### 21.13.1 `monad.toml`

`monad.toml` is the canonical Monad manifest.

It should define repository-level Monad configuration and intent.

If another file disagrees with `monad.toml`, `monad.toml` wins unless a future accepted ADR changes this rule.

### 21.13.2 `workspace.toml`

`workspace.toml` is a compatibility mirror only.

It may exist to support earlier workflows, migration, compatibility, or external tooling expectations.

It must not silently become equal to or more authoritative than `monad.toml`.

### 21.13.3 `monad.lock`

`monad.lock` represents resolved state.

It should be treated as generated/resolved state derived from canonical inputs.

It may be committed if the project decides that reproducibility requires it, but it must not override `monad.toml`.

### 21.13.4 `.monad/`

`.monad/` is local generated state unless explicitly documented otherwise.

Possible contents:

```text id="efsq6w"
.monad/cache/
.monad/context/
.monad/reports/
.monad/plans/
.monad/graphs/
```

`.monad/` must not become hidden canonical truth.

Generated artifacts should include lineage metadata when appropriate:

* command that generated it,
* Monad version,
* timestamp,
* input files,
* output format,
* and whether the artifact is canonical or derived.

---

## 21.14 Data Governance

Data governance defines how Monad handles repository data, generated data, context data, and future hosted data.

Rules:

* `monad.toml` is canonical.
* `workspace.toml` is mirror only.
* `.monad/` is local state/cache unless documented otherwise.
* Generated artifacts need lineage metadata.
* Context packs must exclude secrets.
* Schemas must be versioned.
* Machine-readable outputs should be stable and documented.
* Derived graph data must reference source files.
* Local state should be regenerable where possible.

### 21.14.1 Local Data

Local data should be stored in predictable repository-relative locations.

Local state must not require a database early.

If a local embedded store such as SQLite is introduced later, it must be treated as a cache or index unless an ADR explicitly changes the source-of-truth model.

### 21.14.2 Hosted Data

Hosted data is deferred.

If Monad eventually adds a hosted control plane, hosted data should be a sync, aggregation, dashboard, or collaboration layer. It should not replace local repository truth for core workflows.

### 21.14.3 Schema Versioning

Schemas should be versioned for:

* JSON command output,
* plan files,
* graph exports,
* policy results,
* context manifests,
* release evidence,
* and future risk/traceability metadata.

Schema changes must be governed as public contract changes once users depend on them.

---

## 21.15 Documentation Governance

Documentation is a first-class governance artifact.

Docs must be updated when:

* command behavior changes,
* architecture changes,
* policies change,
* work packet status changes,
* release process changes,
* security model changes,
* source-of-truth rules change,
* output formats change,
* AI behavior changes,
* context behavior changes,
* or mutation behavior changes.

### 21.15.1 Required Documentation Families

Recommended documentation families:

```text id="zd0k7j"
docs/product/
docs/architecture/
docs/engineering/
docs/reference/
docs/security/
docs/operations/
docs/roadmap/
docs/governance/
docs/planning/
```

### 21.15.2 Documentation Checks

`monad docs check` should eventually validate:

* required documents exist,
* required headings exist,
* ADR index matches ADR files,
* command docs match command catalog,
* work packet references are valid,
* risk IDs are unique,
* broken links are detected,
* docs are not obviously stale,
* and source-of-truth rules are documented.

Early docs checks should be conservative.

A docs check should not become so noisy that users ignore it.

### 21.15.3 Documentation as Source of Truth

Some documentation files are canonical for planning and governance.

Examples:

* product charter,
* PRD,
* ADRs,
* risk register,
* governance model,
* roadmap,
* testing strategy,
* security model,
* command reference,
* manifest reference.

Generated docs may summarize canonical docs, but generated docs should not silently replace canonical docs.

---

## 21.16 Security Review Process

Security review is required for any change that could expose sensitive data, weaken repository safety, execute untrusted code, introduce supply-chain risk, or alter trust boundaries.

Security review is required for:

* context export changes,
* file mutation changes,
* plugin/pack install behavior,
* external command execution,
* network access,
* AI provider integrations,
* release artifact changes,
* dependency additions with security impact,
* credential handling,
* ignore/redaction behavior,
* policy enforcement changes,
* and hosted sync behavior.

### 21.16.1 Security Review Questions

A security review should answer:

```text id="xrbs64"
Does this change read sensitive files?
Does this change write files?
Does this change execute external commands?
Does this change call the network?
Does this change send data to an AI provider?
Does this change alter ignore/redaction behavior?
Does this change introduce a dependency?
Does this change affect release artifacts?
Does this change affect user trust?
```

### 21.16.2 Security Review Outcomes

Possible outcomes:

| Outcome                  | Meaning                                                                    |
| ------------------------ | -------------------------------------------------------------------------- |
| Approved                 | Change may proceed.                                                        |
| Approved with mitigation | Change may proceed only with listed controls.                              |
| Deferred                 | Change should wait for safer foundation.                                   |
| Blocked                  | Change should not proceed in current form.                                 |
| Requires ADR             | Change is significant enough to require an architecture/security decision. |

### 21.16.3 Security-Sensitive Areas

Security-sensitive areas include:

* context packs,
* `.env` handling,
* `.gitignore` and `.monadignore`,
* secret redaction,
* plan/apply writes,
* external command adapters,
* dependency installation,
* templates,
* packs,
* plugins,
* AI providers,
* hosted sync,
* release binaries,
* signing,
* and generated artifacts.

---

## 21.17 Architecture Review Process

Architecture review is required when a change affects durable structure, source of truth, extensibility, or long-term constraints.

Architecture review is required for:

* new crate boundaries,
* schema changes,
* graph model changes,
* plan/apply changes,
* policy model changes,
* hosted control plane decisions,
* database or cache introduction,
* command hierarchy changes,
* plugin/pack model changes,
* AI provider architecture,
* and native tool adapter strategy.

### 21.17.1 Architecture Review Questions

Architecture review should answer:

```text id="kp75of"
Does this preserve local-first behavior?
Does this preserve deterministic core behavior?
Does this introduce premature abstraction?
Does this create a new source of truth?
Does this require a database?
Does this require a hosted service?
Does this change command contracts?
Does this fit current roadmap layer?
Does this need an ADR?
Does this increase or reduce known risks?
```

### 21.17.2 Crate Boundary Review

New Rust crates require extra care.

A crate should not be created merely because a future domain might exist.

A new crate is justified when there is:

* stable behavior,
* clear domain boundary,
* meaningful tests,
* reusable API,
* dependency isolation benefit,
* or strong compile-time/ownership reason.

The initial crate structure should remain:

```text id="uftimf"
crates/
  monad-cli/
  monad-core/
```

Future crates may be extracted only when behavior justifies extraction.

---

## 21.18 Dependency Governance

Dependencies are part of Monad’s trust boundary.

Dependency additions should document:

* why the dependency is needed,
* what alternatives were considered,
* whether the dependency is runtime or development-only,
* maintenance status,
* license,
* security posture,
* transitive dependency risk,
* binary size impact where relevant,
* portability impact,
* and whether the dependency affects local-first behavior.

### 21.18.1 Dependency Classes

| Class                         | Examples                               | Governance                           |
| ----------------------------- | -------------------------------------- | ------------------------------------ |
| Dev/test dependency           | `assert_cmd`, `predicates`, `tempfile` | Lightweight review                   |
| CLI/core dependency           | `clap`, `serde`, `toml`                | Document rationale                   |
| Security-sensitive dependency | secret scanner, crypto, signing        | Security review                      |
| External execution dependency | shell/process adapter library          | Security + architecture review       |
| Network dependency            | HTTP client, API SDK                   | Security review + local-first review |
| AI dependency                 | provider SDK, prompt framework         | AI governance + security review      |
| Persistence dependency        | SQLite, database client                | ADR likely required                  |

### 21.18.2 Dependency Hygiene

Recommended checks:

```bash id="osfokk"
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
cargo clippy --workspace --all-targets -- -D warnings
```

Future optional checks:

```bash id="kg9s2k"
cargo audit
cargo deny
gitleaks detect
OpenSSF Scorecard
SBOM generation
```

Optional tools should be non-fatal locally unless explicitly configured.

---

## 21.19 AI Governance

Monad is AI-native but AI-optional.

AI workflows require:

* explicit opt-in,
* provider configuration,
* context redaction,
* prompt template versioning,
* human approval for mutation,
* audit metadata,
* deterministic fallback.

AI must not:

* be required for core commands,
* silently call external providers,
* apply repository changes automatically,
* override deterministic policy checks,
* become source of truth,
* or receive secrets through context packs.

### 21.19.1 Allowed AI Roles

AI may eventually:

* explain findings,
* summarize context,
* draft ADRs,
* draft work packets,
* explain plans,
* suggest plan candidates,
* assist with docs,
* and help users understand repository state.

### 21.19.2 Disallowed AI Roles

AI must not:

* silently mutate files,
* bypass plan/apply,
* decide policy outcomes,
* approve releases,
* replace tests,
* infer source of truth contrary to repository files,
* or exfiltrate context without explicit user action.

### 21.19.3 AI Audit Metadata

AI-assisted outputs should eventually record:

* provider,
* model,
* prompt template version,
* context pack ID,
* redaction status,
* user approval status,
* generated artifact path,
* and whether output was applied.

### 21.19.4 Deterministic Fallback

Every AI-assisted workflow should have deterministic fallback behavior.

Example:

```text id="k30uip"
AI-assisted ADR drafting may produce a draft faster.
But ADR creation must still be possible from a deterministic template.
```

---

## 21.20 Policy Governance

Policies should help users understand and improve repository health.

Policy governance should evolve in this order:

```text id="xric8n"
policy checks
  -> policy explanations
    -> severity levels
      -> waivers
        -> waiver expiration
          -> release gates
            -> optional enforcement
```

Policy enforcement should not come before policy checks are useful and explainable.

### 21.20.1 Policy Rule Requirements

A policy rule should define:

* stable ID,
* title,
* rationale,
* severity,
* detection logic,
* remediation guidance,
* waiver eligibility,
* related risks,
* related docs,
* and test fixtures.

### 21.20.2 Policy Severity

| Severity | Meaning                                        |
| -------- | ---------------------------------------------- |
| Info     | Useful observation.                            |
| Warning  | Should be reviewed.                            |
| Error    | Should block readiness unless waived.          |
| Critical | Indicates unsafe or governance-breaking state. |

### 21.20.3 Waivers

Waivers should be explicit and auditable.

A waiver should include:

* policy ID,
* reason,
* scope,
* owner role,
* expiration,
* related work packet,
* and review date.

Waivers should not become permanent hidden exceptions.

---

## 21.21 Plan/Apply Governance

Plan-backed mutation is one of Monad’s most important governance commitments.

The mature mutation flow is:

```bash id="fxdjd6"
monad plan ...
monad apply plan.json --dry-run
monad apply plan.json --yes
```

Any risky generator, migration, pack install, AI suggestion, cleanup, rename, or file-writing operation should flow through the plan/apply model.

### 21.21.1 Plan Governance

A plan should describe:

* intended changes,
* file operations,
* preconditions,
* expected outputs,
* risk level,
* affected policies,
* affected docs,
* rollback hints,
* and approval requirements.

### 21.21.2 Apply Governance

Apply behavior must:

* validate the plan,
* perform preflight checks,
* detect file conflicts,
* avoid writing outside workspace root,
* avoid unplanned writes,
* require approval for mutation,
* produce an apply report,
* and report partial failure honestly.

### 21.21.3 Dry-Run Governance

Dry-run must not write canonical files.

Dry-run may write temporary or report files only if documented and explicitly allowed. The safer early rule is:

```text id="3bczf4"
Dry-run computes and reports.
Dry-run does not mutate.
```

---

## 21.22 Release Governance

Release governance defines the gates for producing a trustworthy version of Monad.

Initial release gates:

```text id="g3dyqx"
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
command catalog contract
docs check
policy check
changelog update
version update
release notes
security review for sensitive changes
```

Because not all future commands exist yet, the early practical gate is:

```bash id="oybcz4"
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
```

Near-term stronger gate:

```bash id="t1lgcc"
cargo clippy --workspace --all-targets -- -D warnings
cargo test -p monad-cli --test command_catalog_contract
```

### 21.22.1 Release Evidence

A release should eventually include:

* version,
* commit SHA,
* changelog,
* test commands run,
* test results,
* command catalog status,
* known risks,
* open critical issues,
* docs status,
* security review notes,
* artifacts produced,
* checksums,
* and compatibility notes.

### 21.22.2 Release Blocking Conditions

A release should be blocked if:

* command catalog and Clap surface drift,
* read-only commands mutate files,
* dry-run mutates files,
* context export leaks secrets,
* `monad.toml` source-of-truth behavior is unclear,
* JSON schemas break without versioning,
* critical risks are unmanaged,
* or tests fail.

### 21.22.3 Release Decision Record

A release decision should answer:

```text id="f5lg7w"
What is being released?
Why is it ready?
What changed?
What tests passed?
What risks remain?
What compatibility promises apply?
What should users watch for?
```

---

## 21.23 Risk Governance

The risk register is a living governance artifact.

Risks should be updated when:

* architecture decisions change,
* work packet scope changes,
* command behavior changes,
* mutation behavior is introduced,
* context export behavior changes,
* AI provider support is introduced,
* pack/plugin behavior changes,
* hosted control-plane work begins,
* or release-readiness criteria change.

Risk governance should ensure that risks are:

* identified,
* classified,
* scored,
* owned by role,
* linked to work packets,
* linked to ADRs where relevant,
* linked to tests where possible,
* and reviewed before release.

High and Critical risks require explicit mitigation or documented acceptance.

Some risks should not be accepted without redesign, including:

* silent unsafe mutation,
* known secret leakage,
* hidden AI provider calls,
* source-of-truth ambiguity,
* and executable plugin behavior without trust controls.

---

## 21.24 Context and Handoff Governance

Context handoff is a core Monad concept.

Context artifacts may be used by humans, future sessions, or AI systems. Therefore, they must be governed.

Context generation should answer:

* what files were included,
* what files were excluded,
* why exclusions happened,
* whether redaction occurred,
* what command generated the context,
* when it was generated,
* and whether it is safe for external use.

Context packs must:

* be local by default,
* exclude secrets,
* respect ignore rules,
* include provenance metadata,
* avoid hidden provider calls,
* and distinguish generated summaries from canonical truth.

Future context commands should be test-backed with security fixtures.

---

## 21.25 Native Tool Governance

Monad coordinates native tools instead of replacing them.

Native tool governance defines what Monad owns and what it does not own.

Monad owns:

* repository lifecycle understanding,
* governance checks,
* command catalog,
* documentation lifecycle,
* traceability,
* context generation,
* plan/apply safety model,
* policy coordination,
* graph representation,
* and native tool relationship modeling.

Native tools own:

* version control internals,
* build execution,
* package installation,
* test execution internals,
* task runner internals,
* CI execution internals,
* and language-specific package semantics.

Native adapters should be governed by:

* clear contracts,
* fixture tests,
* missing-tool behavior,
* structured findings,
* consistent severity,
* and no silent mutation.

---

## 21.26 Hosted Control Plane Governance

The hosted control plane is optional and deferred.

Hosted features may eventually include:

* repository metadata sync,
* organization and team model,
* graph dashboard,
* policy compliance dashboard,
* release governance dashboard,
* hosted audit evidence,
* and multi-repository visibility.

Hosted governance rules:

* hosted must not be required for core local commands,
* hosted must not replace repository source of truth,
* hosted sync must be explicit,
* hosted data must have clear lineage,
* privacy boundaries must be documented,
* local-first workflows must remain useful without hosted services,
* and hosted work should not begin before local v1 is trustworthy.

Hosted features should be additive.

They should not become the foundation.

---

## 21.27 Governance Automation Roadmap

Governance should begin as documentation and evolve into CLI-supported validation.

Possible command progression:

```bash id="czwb94"
monad docs check
monad adr list
monad adr check
monad workpacket list
monad workpacket check
monad risk check
monad trace check
monad policy check
monad release readiness
```

All early governance commands should be read-only.

Later commands that create or update governance artifacts should use the plan/apply model.

Examples:

```bash id="buhgso"
monad adr new --dry-run
monad workpacket new --dry-run
monad docs generate --dry-run
monad policy waiver new --dry-run
```

Mature mutation should follow:

```bash id="qd4fvm"
monad plan ...
monad apply plan.json --dry-run
monad apply plan.json --yes
```

---

## 21.28 Governance Anti-Patterns

Monad should avoid the following governance anti-patterns.

### 21.28.1 Governance Theater

Creating documents that are not used, tested, referenced, or updated.

Mitigation:

* connect docs to work packets,
* connect work packets to tests,
* connect tests to release readiness.

### 21.28.2 Hidden Source of Truth

Allowing generated files, cache files, hosted data, or AI outputs to become canonical without explicit decision.

Mitigation:

* document source-of-truth rules,
* include lineage metadata,
* make generated artifacts regenerable.

### 21.28.3 Placeholder Inflation

Adding many commands that appear real but do not perform real behavior.

Mitigation:

* command status metadata,
* placeholder honesty tests,
* roadmap gates.

### 21.28.4 AI Shortcutting

Using AI to bypass deterministic checks, tests, plans, or user approval.

Mitigation:

* deterministic fallback,
* AI audit metadata,
* explicit opt-in,
* human approval.

### 21.28.5 Premature Enterprise Process

Making solo development feel like enterprise compliance before the product is useful.

Mitigation:

* lightweight templates,
* small layers,
* role-based ownership,
* local-first docs,
* progressive automation.

### 21.28.6 Premature Hosted Governance

Building dashboards and sync before the local control plane is trustworthy.

Mitigation:

* defer hosted scope,
* require local equivalent first,
* preserve local source of truth.

---

## 21.29 Minimum Governance System for Early Monad

The minimum governance system for early Monad should include:

* clear product doctrine,
* canonical source-of-truth rules,
* command catalog,
* Clap surface contract test,
* placeholder honesty rules,
* ADR set,
* work packet map,
* risk register,
* testing strategy,
* documentation structure,
* release gate checklist,
* and current implementation roadmap.

Early governance should focus on the current milestone:

```text id="eeolqo"
a green, contract-tested, read-only Monad CLI that can explain a repository honestly
```

The highest-leverage near-term governance controls are:

1. command catalog and Clap surface alignment,
2. placeholder honesty,
3. manifest source-of-truth clarity,
4. read-only command safety,
5. docs-as-code,
6. risk tracking,
7. and test-backed behavior.

---

## 21.30 Governance Readiness Checklist

Before moving from one layer to the next, review:

```text id="ah0l8o"
Does the work fit the current roadmap layer?
Is there a related work packet?
Does an accepted ADR already govern this?
Is a new ADR needed?
Does this affect known risks?
Does this affect command catalog metadata?
Does this affect source-of-truth rules?
Does this mutate files?
Does this need dry-run or plan/apply?
Does this affect docs?
Does this affect tests?
Does this affect release readiness?
```

For mutating features, additionally review:

```text id="ja2ym3"
Is there a plan representation?
Is dry-run non-mutating?
Is apply explicit?
Are writes limited to planned files?
Are rollback hints available?
Are mutation safety tests present?
```

For AI features, additionally review:

```text id="e57wns"
Is AI optional?
Is provider use explicit?
Is context redacted?
Is there deterministic fallback?
Is there audit metadata?
Is mutation still human-approved?
```

For hosted features, additionally review:

```text id="u1l7xs"
Does local-first still work?
Is hosted optional?
Is data lineage clear?
Is sync explicit?
Is repository truth preserved?
```

---

## 21.31 Future Governance Commands

Future Monad governance commands may include:

```bash id="g44qu8"
monad governance check
monad governance explain
monad governance report
monad adr list
monad adr check
monad risk list
monad risk check
monad trace check
monad release readiness
```

Potential behavior:

| Command                    | Behavior                                                                                  |
| -------------------------- | ----------------------------------------------------------------------------------------- |
| `monad governance check`   | Runs local governance checks across docs, ADRs, risks, work packets, and command catalog. |
| `monad governance explain` | Explains governance state and missing artifacts.                                          |
| `monad governance report`  | Generates a local governance report.                                                      |
| `monad adr list`           | Lists ADRs and statuses.                                                                  |
| `monad adr check`          | Validates ADR IDs, statuses, index, and references.                                       |
| `monad risk list`          | Lists known risks.                                                                        |
| `monad risk check`         | Validates risk register structure and references.                                         |
| `monad trace check`        | Validates traceability links.                                                             |
| `monad release readiness`  | Checks whether release gates are satisfied.                                               |

These should be read-only first.

Any command that creates or modifies governance artifacts should use dry-run and eventually plan/apply.

---

## 21.32 Open Governance Questions

The following questions should remain open until the relevant work packets or ADRs are reached.

### 21.32.1 Structured Governance Metadata

Should governance artifacts remain Markdown-only, or should Monad introduce structured metadata files?

Recommendation:

Start with Markdown. Add structured metadata only when read-only validation needs it.

### 21.32.2 Governance Profiles

Should Monad support governance profiles such as solo, team, enterprise?

Recommendation:

Eventually yes. Early Monad should optimize for solo-developer usability while preserving future extensibility.

Potential profiles:

| Profile    | Description                                                         |
| ---------- | ------------------------------------------------------------------- |
| Solo       | Minimal ceremony, local checks, lightweight work packets.           |
| Team       | Stronger review expectations, release notes, policy checks.         |
| Enterprise | Formal approvals, evidence packs, hosted dashboards, audit exports. |

### 21.32.3 Governance Enforcement

Should governance checks block commands?

Recommendation:

Start advisory. Add blocking behavior only for safety-critical operations and release readiness.

### 21.32.4 Hosted Governance

Should hosted Monad become the main governance interface?

Recommendation:

No for core behavior. Hosted governance may visualize and aggregate, but local repository governance remains authoritative.

---

## 21.33 Summary

Monad governance exists to preserve trust.

It should make the repository understandable, auditable, and safely evolvable without turning development into bureaucracy.

The governance system should ensure that every significant change can answer:

```text id="rqnifs"
What changed?
Why did it change?
Who or what approved it?
What policy applied?
What test proves it?
What docs explain it?
What risk remains?
```

The correct governance sequence is:

```text id="fmdu1o"
local Markdown governance
  -> stable identifiers
    -> work packets and ADRs
      -> command catalog contracts
        -> docs/risk/trace checks
          -> policy checks
            -> release readiness
              -> optional hosted evidence
```

Monad’s governance system should remain:

* local-first,
* deterministic,
* test-backed,
* source-of-truth aware,
* command-contract aware,
* risk-aware,
* documentation-centered,
* AI-optional,
* plan-backed for mutation,
* and usable by a solo developer before it scales to teams or enterprises.
