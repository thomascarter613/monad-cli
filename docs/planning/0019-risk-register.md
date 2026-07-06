# 20. Risk Register

## 20.1 Purpose of This Section

This section defines the initial risk register for Monad OS / Monad CLI.

The risk register exists to make product, architecture, safety, security, governance, delivery, and adoption risks explicit before they become implementation failures.

Monad is intentionally ambitious. It is not merely a CLI, not merely a scaffolder, not merely a task runner, and not merely an AI helper. Monad is intended to become a local-first, governance-grade SDLC control plane and monorepo operating system.

That ambition creates risk.

This section ensures that those risks are:

* named,
* classified,
* prioritized,
* owned,
* traceable,
* reviewable,
* testable where possible,
* connected to the roadmap,
* and constrained by explicit mitigations.

The purpose of this register is not to eliminate all risk. That is impossible. Its purpose is to prevent unmanaged risk from silently shaping the product.

Monad’s highest-risk areas are:

* scope control,
* command-surface honesty,
* repository mutation safety,
* context and secret safety,
* source-of-truth clarity,
* local-first discipline,
* AI optionality,
* native-tool coordination,
* documentation freshness,
* graph-model complexity,
* plugin and pack trust,
* solo-developer execution load,
* and premature hosted-platform expansion.

The risk register should be treated as a living governance artifact. It should evolve as Monad moves from planning to implementation, from read-only commands to plan-backed mutation, from local context generation to optional AI assistance, and eventually from local-only workflows to optional hosted control-plane capabilities.

---

## 20.2 Risk Management Philosophy

Monad’s risk model follows the core product doctrine:

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

Risk management must reinforce this doctrine.

Risk mitigation should not make Monad heavier than necessary. Monad is intended to help a solo developer or small team govern serious repositories without requiring enterprise bureaucracy, hosted infrastructure, or a large process burden.

Therefore, Monad’s risk management approach should be:

* local-first,
* lightweight,
* Markdown-compatible,
* version-controlled,
* traceable to work packets,
* tested where behavior is involved,
* and enforceable incrementally through CLI checks.

The early risk register should live in documentation. Later, Monad may add machine-readable risk metadata, risk checks, release-readiness gates, and traceability commands. Those features should not be required for the first useful version.

The ideal progression is:

```text
Markdown risk register
  -> structured identifiers
    -> traceability links
      -> docs/check validation
        -> policy/check integration
          -> release-readiness evidence
```

Monad should not require an external GRC platform, ticketing system, hosted database, graph database, or SaaS dashboard to manage its own risks.

---

## 20.3 Risk Register Scope

This risk register covers risks related to:

* the Monad product concept,
* the `monad-cli` repository,
* the Rust CLI runtime,
* command catalog integrity,
* read-only repository understanding,
* documentation lifecycle,
* governance lifecycle,
* context generation,
* AI-safe handoff,
* plan-backed mutation,
* policy checks,
* graph modeling,
* native tool coordination,
* templates and packs,
* optional future plugins,
* optional hosted control plane,
* release readiness,
* and solo-developer execution.

This section does not attempt to cover every general business risk, funding risk, market risk, legal risk, or long-term organizational risk. Those may be added later if Monad becomes a commercial product, hosted platform, open-source foundation project, or enterprise offering.

For now, the risk register is focused on risks that affect the repository, product architecture, implementation sequence, and trustworthiness of the CLI.

---

## 20.4 Risk Identifier Standard

Risks use stable identifiers.

The initial format is:

```text
R-NNN
```

Examples:

```text
R-001
R-002
R-003
```

Future versions may introduce more specific prefixes if necessary:

```text
R-PRODUCT-NNN
R-SAFETY-NNN
R-SECURITY-NNN
R-AI-NNN
R-GOV-NNN
R-DELIVERY-NNN
```

However, the initial `R-NNN` format is sufficient and easier to maintain.

Risk identifiers should be stable. Once assigned, an identifier should not be reused for a different risk.

If a risk is retired, it should be marked as retired rather than deleted without trace.

If a risk is split into multiple risks, the original risk should reference the successor risks.

If a risk is merged into another risk, the original risk should reference the surviving risk.

---

## 20.5 Risk Categories

Monad uses the following initial risk categories.

| Category      | Meaning                                                                                                                  |
| ------------- | ------------------------------------------------------------------------------------------------------------------------ |
| Product       | Risk that Monad’s scope, positioning, user value, or command experience becomes unclear or untrustworthy.                |
| Safety        | Risk that Monad damages repositories, applies unsafe changes, or mutates without sufficient review.                      |
| Security      | Risk involving secrets, supply chain, external execution, plugins, context export, or sensitive data.                    |
| Governance    | Risk involving source-of-truth drift, stale docs, policy weakness, poor traceability, or unmanaged decisions.            |
| Architecture  | Risk that core design choices become too complex, premature, inconsistent, or misaligned with doctrine.                  |
| Integration   | Risk that Monad coordinates native tools inconsistently or incorrectly.                                                  |
| Compatibility | Risk that command output, schemas, or behavior changes break users, scripts, or CI.                                      |
| AI            | Risk that AI features reduce determinism, leak context, encourage unsafe automation, or become required for correctness. |
| Data          | Risk that generated state, caches, graph data, or local metadata are mistaken for canonical truth.                       |
| Reliability   | Risk that operations fail partially, produce inconsistent state, or cannot be recovered.                                 |
| Strategy      | Risk that long-term hosted, enterprise, or marketplace ambitions distract from the local core.                           |
| GTM           | Risk that users cannot understand Monad’s category, value, or adoption path.                                             |
| Delivery      | Risk that the solo-developer execution model becomes too heavy, fragile, or slow.                                        |

These categories should remain broad. Monad should avoid creating too many risk categories early because over-classification can become bureaucratic.

---

## 20.6 Risk Scoring Model

Each risk is scored using:

* likelihood,
* impact,
* severity,
* and residual risk.

### 20.6.1 Likelihood

Likelihood describes how probable the risk is under the current roadmap and execution model.

| Likelihood | Meaning                                                             |
| ---------- | ------------------------------------------------------------------- |
| Low        | Unlikely under current plans and controls.                          |
| Medium     | Plausible and should be actively monitored.                         |
| High       | Likely unless explicitly constrained.                               |
| Critical   | Already occurring or almost certain without immediate intervention. |

### 20.6.2 Impact

Impact describes how damaging the risk would be if it occurs.

| Impact   | Meaning                                                                                             |
| -------- | --------------------------------------------------------------------------------------------------- |
| Low      | Minor inconvenience or localized issue.                                                             |
| Medium   | Noticeable product, implementation, trust, or workflow damage.                                      |
| High     | Major product trust, safety, usability, or roadmap impact.                                          |
| Critical | Could invalidate core product trust, damage repositories, leak secrets, or make the project unsafe. |

### 20.6.3 Severity

Severity combines likelihood and impact.

| Severity | Meaning                                                              |
| -------- | -------------------------------------------------------------------- |
| Low      | Track but no special action required.                                |
| Medium   | Mitigate during relevant work packets.                               |
| High     | Requires explicit mitigation and review.                             |
| Critical | Must constrain roadmap, implementation order, and release readiness. |

### 20.6.4 Residual Risk

Residual risk is the expected remaining risk after mitigation.

| Residual Risk | Meaning                                                                         |
| ------------- | ------------------------------------------------------------------------------- |
| Low           | Mitigation should reduce the risk to acceptable levels.                         |
| Medium        | Risk remains meaningful and must be reviewed periodically.                      |
| High          | Risk remains dangerous even after mitigation and requires leadership decision.  |
| Critical      | Risk remains unacceptable; feature or approach should be blocked or redesigned. |

Monad should not ship a stable release with unresolved Critical residual risk in core safety, security, mutation, or source-of-truth behavior.

---

## 20.7 Initial Risk Register

| Risk ID | Description                                   | Category      | Likelihood | Impact   | Severity | Mitigation                                                      | Detection              | Owner Role        | Related WP      | Residual Risk |
| ------- | --------------------------------------------- | ------------- | ---------- | -------- | -------- | --------------------------------------------------------------- | ---------------------- | ----------------- | --------------- | ------------- |
| R-001   | Scope explosion from huge command surface     | Product       | High       | High     | Critical | Strict layering, placeholder honesty, roadmap gates             | Roadmap review         | Product owner     | All             | Medium        |
| R-002   | Too many placeholders reduce trust            | Product       | Medium     | High     | High     | Convert placeholders into real read-only behavior incrementally | Command catalog report | CLI maintainer    | WP-0006         | Medium        |
| R-003   | Unsafe mutation damages repositories          | Safety        | Medium     | Critical | Critical | Plan/apply, dry-run, approval flags, mutation safety tests      | Mutation safety tests  | Plan engine owner | WP-0025-WP-0029 | Low           |
| R-004   | Secret leakage into context packs             | Security      | Medium     | Critical | Critical | Redaction, ignore rules, security tests                         | Context security tests | Security owner    | WP-0023         | Low           |
| R-005   | `monad.toml` and `workspace.toml` drift       | Governance    | High       | Medium   | High     | Canonical manifest policy                                       | `monad check`          | Config owner      | WP-0002         | Low           |
| R-006   | Monad tries to replace too many native tools  | Architecture  | Medium     | High     | High     | Adapter strategy, ADR-0002                                      | Architecture review    | Architect         | WP-0044-WP-0049 | Medium        |
| R-007   | Lifecycle graph becomes too complex too early | Architecture  | Medium     | Medium   | Medium   | Start with v0 graph, avoid persistence early                    | Graph tests            | Graph owner       | WP-0012         | Medium        |
| R-008   | AI features undermine deterministic trust     | AI            | Medium     | High     | High     | AI optionality, noop adapter, human approval                    | AI workflow tests      | AI owner          | WP-0061-WP-0067 | Medium        |
| R-009   | Plugin/packs introduce supply-chain risk      | Security      | Medium     | High     | High     | Defer plugins, checksum/signature model                         | Security review        | Security owner    | WP-0034-WP-0037 | Medium        |
| R-010   | CLI output changes break users/CI             | Compatibility | Medium     | Medium   | Medium   | Schema versions, snapshot tests                                 | CI                     | CLI maintainer    | WP-0007         | Low           |
| R-011   | Documentation becomes stale                   | Governance    | High       | Medium   | High     | `docs check`, docs-as-code                                      | Docs check             | Docs owner        | WP-0014         | Medium        |
| R-012   | Work packet process becomes bureaucratic      | Product       | Medium     | Medium   | Medium   | Lightweight templates, profiles                                 | User feedback          | Product owner     | WP-0018         | Medium        |
| R-013   | Rust crate boundaries become premature        | Architecture  | Medium     | Medium   | Medium   | Create crates when needed, avoid empty abstractions             | Architecture review    | Architect         | WP-0001         | Medium        |
| R-014   | Native tool adapter behavior inconsistent     | Integration   | Medium     | Medium   | Medium   | Fixtures, adapter conformance tests                             | Adapter tests          | Integration owner | WP-0044-WP-0049 | Medium        |
| R-015   | Hosted layer distracts from local core        | Strategy      | Medium     | High     | High     | Defer hosted until local v1                                     | Roadmap gate           | Product owner     | WP-0068+        | Low           |
| R-016   | Hard-to-explain product category              | GTM           | High       | Medium   | High     | Use “local-first SDLC control plane” framing                    | Positioning review     | Product owner     | docs/product    | Medium        |
| R-017   | Graph/cache data treated as source of truth   | Data          | Medium     | Medium   | Medium   | Clear docs, source references                                   | Check command          | Data owner        | WP-0059         | Low           |
| R-018   | Apply failures leave partial state            | Reliability   | Medium     | High     | High     | Preflight, rollback hints, atomic write patterns                | Apply tests            | Plan owner        | WP-0028/WP-0029 | Medium        |
| R-019   | Policy false positives frustrate users        | Governance    | Medium     | Medium   | Medium   | Explain, severity, waivers                                      | Policy feedback        | Policy owner      | WP-0040-WP-0043 | Medium        |
| R-020   | Solo developer process becomes too heavy      | Delivery      | High       | Medium   | High     | Small layers, copy-pasteable patches, no fragile scripts        | Cadence review         | Project owner     | All             | Medium        |

---

## 20.8 Detailed Risk Analysis

### 20.8.1 R-001: Scope Explosion from Huge Command Surface

| Field         | Value         |
| ------------- | ------------- |
| Risk ID       | R-001         |
| Category      | Product       |
| Likelihood    | High          |
| Impact        | High          |
| Severity      | Critical      |
| Owner Role    | Product owner |
| Related WP    | All           |
| Residual Risk | Medium        |

Monad’s intended command surface is broad. It may eventually include commands for inspection, checking, graphing, documentation, ADRs, work packets, context handoff, planning, applying plans, templates, packs, policies, native tools, releases, AI assistance, and hosted sync.

The risk is that Monad tries to expose too much too early.

If the command surface grows faster than the implementation depth, users may perceive Monad as a hollow command catalog rather than a trustworthy control plane. A large CLI with shallow behavior creates confusion, support burden, and false expectations.

This risk is especially important because Monad’s early product trust depends on honesty.

Mitigation:

* enforce roadmap layering,
* mark placeholders explicitly,
* prioritize read-only commands before mutating commands,
* maintain a command catalog with implementation status,
* keep command-contract tests green,
* avoid adding command families that are not connected to near-term work packets,
* and treat command growth as a governed product decision.

Early acceptable state:

```text
A command may exist as an honest placeholder if:
  - it is in the command catalog,
  - its status is clearly planned or placeholder,
  - it does not pretend to perform real work,
  - it exits consistently,
  - and tests verify the placeholder behavior.
```

Unacceptable state:

```text
A command exists, appears implemented, returns success, but does not actually perform the behavior implied by its name.
```

Primary controls:

* command catalog review,
* Clap surface contract tests,
* placeholder honesty tests,
* roadmap gate review,
* release readiness review.

---

### 20.8.2 R-002: Too Many Placeholders Reduce Trust

| Field         | Value          |
| ------------- | -------------- |
| Risk ID       | R-002          |
| Category      | Product        |
| Likelihood    | Medium         |
| Impact        | High           |
| Severity      | High           |
| Owner Role    | CLI maintainer |
| Related WP    | WP-0006        |
| Residual Risk | Medium         |

Placeholders are acceptable when they are honest. They are dangerous when they accumulate and become the primary user experience.

Monad may need placeholder commands to stabilize command contracts before implementation depth exists. However, if too many commands only say “not implemented yet,” users may lose confidence.

This risk differs from R-001. R-001 is about scope explosion. R-002 is about the trust impact of shallow behavior.

Mitigation:

* categorize commands by status,
* prefer fewer useful read-only commands over many placeholders,
* upgrade placeholders into real read-only behavior incrementally,
* expose status in command catalog output,
* document placeholder semantics,
* and avoid placeholder commands for high-risk mutating workflows until plan/apply exists.

Placeholder status values should eventually include:

| Status      | Meaning                                                                         |
| ----------- | ------------------------------------------------------------------------------- |
| Implemented | Command performs its documented behavior.                                       |
| Partial     | Command performs a safe subset of documented behavior.                          |
| Placeholder | Command exists for contract visibility but does not perform the final behavior. |
| Planned     | Command is known to the catalog but not exposed as implemented behavior.        |
| Deferred    | Command is intentionally postponed.                                             |
| Removed     | Command was removed or superseded.                                              |

Detection:

* command catalog report,
* smoke tests,
* snapshot tests,
* command contract tests,
* user feedback,
* release-readiness checklist.

---

### 20.8.3 R-003: Unsafe Mutation Damages Repositories

| Field         | Value             |
| ------------- | ----------------- |
| Risk ID       | R-003             |
| Category      | Safety            |
| Likelihood    | Medium            |
| Impact        | Critical          |
| Severity      | Critical          |
| Owner Role    | Plan engine owner |
| Related WP    | WP-0025-WP-0029   |
| Residual Risk | Low               |

This is one of Monad’s most important risks.

Monad is intended to help repositories evolve. That may eventually include creating files, editing files, generating docs, adding templates, installing packs, renaming things, migrating structures, cleaning artifacts, and applying plan-backed changes.

Any tool that mutates a repository can damage user work.

Unsafe mutation can include:

* overwriting files,
* deleting files,
* editing the wrong path,
* following symlinks unexpectedly,
* writing outside the repository root,
* ignoring `.gitignore` or ignore policy,
* applying partial changes,
* generating invalid manifests,
* changing canonical source-of-truth files incorrectly,
* or making irreversible modifications without review.

Monad must not rely on user trust alone. It must earn trust through mutation architecture.

Required mitigation:

```text
No mature mutating workflow should bypass:
  monad plan ...
  monad apply plan.json --dry-run
  monad apply plan.json --yes
```

Mutation controls:

* explicit plan schema,
* dry-run mode,
* approval flags,
* preflight checks,
* file operation model,
* no writes outside workspace root,
* overwrite detection,
* content hash checks,
* backup or rollback hints,
* apply reports,
* policy evaluation,
* mutation safety tests,
* and fixture-based integration tests.

Read-only commands must not write canonical files.

Dry-run commands must not write canonical files.

Apply commands must write only planned files.

---

### 20.8.4 R-004: Secret Leakage into Context Packs

| Field         | Value          |
| ------------- | -------------- |
| Risk ID       | R-004          |
| Category      | Security       |
| Likelihood    | Medium         |
| Impact        | Critical       |
| Severity      | Critical       |
| Owner Role    | Security owner |
| Related WP    | WP-0023        |
| Residual Risk | Low            |

Monad is AI-ready but AI-optional. One major future feature is context generation: handoff files, context packs, repository summaries, graph exports, and AI-consumable artifacts.

Context export can leak secrets if not carefully controlled.

Potential leaked data:

* API keys,
* tokens,
* private keys,
* credentials,
* `.env` files,
* service account JSON,
* SSH keys,
* certificates,
* proprietary source code,
* customer data,
* internal architecture details,
* personal data,
* CI secrets,
* cloud credentials,
* and generated artifacts containing sensitive snippets.

Monad must treat context generation as a security-sensitive feature, even when no AI provider is used.

Mitigation:

* default deny for known secret paths,
* respect `.gitignore`,
* support `.monadignore`,
* support explicit include/exclude rules,
* scan for secret-like patterns,
* redact high-risk values,
* generate redaction reports,
* never silently send context to external providers,
* require explicit opt-in for AI provider use,
* and test context generation against security fixtures.

Context export should be local by default.

The safe early model:

```text
monad context handoff
  -> writes local Markdown summary only
  -> excludes ignored and secret-like files
  -> includes provenance metadata
  -> explains what was included and excluded
```

Unsafe model:

```text
monad context ai
  -> silently sends repository content to a hosted model
```

That model must never be allowed.

---

### 20.8.5 R-005: `monad.toml` and `workspace.toml` Drift

| Field         | Value        |
| ------------- | ------------ |
| Risk ID       | R-005        |
| Category      | Governance   |
| Likelihood    | High         |
| Impact        | Medium       |
| Severity      | High         |
| Owner Role    | Config owner |
| Related WP    | WP-0002      |
| Residual Risk | Low          |

Monad’s source-of-truth model must remain clear.

The established rule is:

```text
monad.toml      canonical Monad manifest
workspace.toml  compatibility mirror only
monad.lock      resolved state
.monad/         local generated/cache/context/report/plan state
```

If both `monad.toml` and `workspace.toml` exist and conflict, `monad.toml` wins.

The risk is that users, commands, tests, or documentation treat `workspace.toml` as equally canonical.

This would undermine governance and create inconsistent behavior.

Mitigation:

* document source-of-truth rules clearly,
* implement manifest resolution consistently,
* make `monad check` detect drift,
* make drift findings explicit,
* include fixture tests for conflict cases,
* and avoid writing to compatibility mirrors unless the plan clearly states that behavior.

Required behavior:

```text
If monad.toml exists:
  use monad.toml as canonical.

If workspace.toml exists:
  treat it as compatibility mirror.

If both exist and conflict:
  report drift and use monad.toml.

If only workspace.toml exists:
  support migration or compatibility behavior according to documented policy.
```

---

### 20.8.6 R-006: Monad Tries to Replace Too Many Native Tools

| Field         | Value           |
| ------------- | --------------- |
| Risk ID       | R-006           |
| Category      | Architecture    |
| Likelihood    | Medium          |
| Impact        | High            |
| Severity      | High            |
| Owner Role    | Architect       |
| Related WP    | WP-0044-WP-0049 |
| Residual Risk | Medium          |

Monad should coordinate native tools instead of replacing them.

Git remains responsible for version control.

Cargo remains responsible for Rust builds.

Bun, npm, pnpm, and similar tools remain responsible for JavaScript package workflows.

Moon and Turborepo remain responsible for their own task graph execution.

CI systems remain responsible for CI execution.

Monad should inspect, coordinate, validate, graph, and govern relationships between tools. It should not attempt to become a universal replacement for all of them.

The risk is that Monad becomes a lower-quality clone of many mature tools.

Mitigation:

* preserve ADR-0002,
* define adapter boundaries,
* avoid reimplementing build systems,
* call or inspect native tools only when useful,
* keep native tool behavior test-backed,
* and document what Monad does and does not own.

Correct posture:

```text
Monad owns:
  - repository lifecycle understanding,
  - governance checks,
  - command catalog,
  - documentation lifecycle,
  - traceability,
  - context generation,
  - plan/apply safety model,
  - policy coordination,
  - graph representation.

Native tools own:
  - actual builds,
  - package installation,
  - test execution internals,
  - version control internals,
  - task runner internals,
  - CI execution internals.
```

---

### 20.8.7 R-007: Lifecycle Graph Becomes Too Complex Too Early

| Field         | Value        |
| ------------- | ------------ |
| Risk ID       | R-007        |
| Category      | Architecture |
| Likelihood    | Medium       |
| Impact        | Medium       |
| Severity      | Medium       |
| Owner Role    | Graph owner  |
| Related WP    | WP-0012      |
| Residual Risk | Medium       |

The lifecycle graph is central to Monad’s long-term value.

However, graph ambition can become a trap.

If Monad tries to model every file, dependency, command, policy, ADR, work packet, test, package, service, owner, release, and AI context relationship too early, implementation may stall.

The early graph should be useful but modest.

A safe v0 graph may include:

* workspace root,
* packages/projects,
* manifests,
* docs,
* ADRs,
* work packets,
* commands,
* tests,
* policies,
* and basic relationships.

It should not require graph persistence, graph database infrastructure, complex query language, or exhaustive dependency analysis in early layers.

Mitigation:

* define v0 graph schema,
* keep graph local and derived,
* export to JSON, Mermaid, and DOT,
* avoid persistence until needed,
* treat graph output as generated state,
* and test graph invariants using fixtures.

The graph should evolve from simple to rich:

```text
v0: derived local graph
v1: structured graph exports and checks
v2: optional local cache
v3: optional hosted graph dashboard
```

---

### 20.8.8 R-008: AI Features Undermine Deterministic Trust

| Field         | Value           |
| ------------- | --------------- |
| Risk ID       | R-008           |
| Category      | AI              |
| Likelihood    | Medium          |
| Impact        | High            |
| Severity      | High            |
| Owner Role    | AI owner        |
| Related WP    | WP-0061-WP-0067 |
| Residual Risk | Medium          |

Monad is AI-native but AI-optional.

AI may eventually help:

* explain findings,
* summarize context,
* draft ADRs,
* draft work packets,
* explain plans,
* propose plan candidates,
* and assist with documentation.

AI must not become required for correctness.

AI must not silently call external providers.

AI must not override deterministic checks.

AI must not apply repository changes automatically.

AI must not become the source of truth.

The risk is that AI features become attractive enough to bypass deterministic architecture.

Mitigation:

* introduce `NoopAiAdapter` first,
* build deterministic context packs before AI use,
* require explicit provider configuration,
* require explicit user opt-in,
* version prompt templates,
* record AI audit metadata,
* require human approval for mutation,
* and ensure deterministic fallback behavior.

Safe AI posture:

```text
AI can suggest.
AI can explain.
AI can draft.
AI cannot silently mutate.
AI cannot silently exfiltrate.
AI cannot replace deterministic validation.
```

---

### 20.8.9 R-009: Plugin/Packs Introduce Supply-Chain Risk

| Field         | Value           |
| ------------- | --------------- |
| Risk ID       | R-009           |
| Category      | Security        |
| Likelihood    | Medium          |
| Impact        | High            |
| Severity      | High            |
| Owner Role    | Security owner  |
| Related WP    | WP-0034-WP-0037 |
| Residual Risk | Medium          |

Templates, packs, and plugins are powerful. They are also supply-chain risk vectors.

A malicious or poorly designed pack could:

* write unsafe files,
* alter CI behavior,
* introduce vulnerable dependencies,
* exfiltrate secrets,
* execute untrusted scripts,
* weaken security settings,
* or create confusing repository state.

Monad should distinguish between:

| Mechanism                         | Risk Level |
| --------------------------------- | ---------- |
| Built-in templates                | Lower      |
| Local user-authored templates     | Medium     |
| Packs applied through plan engine | Medium     |
| Remote pack registry              | High       |
| Executable plugins                | Highest    |

Mitigation sequence:

```text
templates before packs
packs before plugins
plan preview before pack apply
checksums before registry trust
signatures before broad ecosystem
no arbitrary plugin execution early
```

Early Monad should avoid a general plugin runtime.

Packs should be declarative where possible.

Any pack that mutates a repository should flow through the plan/apply engine.

---

### 20.8.10 R-010: CLI Output Changes Break Users/CI

| Field         | Value          |
| ------------- | -------------- |
| Risk ID       | R-010          |
| Category      | Compatibility  |
| Likelihood    | Medium         |
| Impact        | Medium         |
| Severity      | Medium         |
| Owner Role    | CLI maintainer |
| Related WP    | WP-0007        |
| Residual Risk | Low            |

Monad will be used both by humans and automation.

Human output can evolve more freely. Machine output must be stable.

The risk is that command output changes break scripts, CI checks, tests, or downstream integrations.

Mitigation:

* distinguish human output from machine output,
* support `--format json` for structured output,
* version JSON schemas,
* use snapshot tests for human output,
* use schema tests for JSON output,
* standardize exit codes,
* and document output stability levels.

Recommended stability classes:

| Output Type      | Stability                                   |
| ---------------- | ------------------------------------------- |
| Human text       | Best-effort stable, may improve over time.  |
| JSON output      | Schema-versioned and compatibility-managed. |
| Exit codes       | Stable once documented.                     |
| Error categories | Stable once documented.                     |
| Debug output     | Unstable unless explicitly documented.      |

---

### 20.8.11 R-011: Documentation Becomes Stale

| Field         | Value      |
| ------------- | ---------- |
| Risk ID       | R-011      |
| Category      | Governance |
| Likelihood    | High       |
| Impact        | Medium     |
| Severity      | High       |
| Owner Role    | Docs owner |
| Related WP    | WP-0014    |
| Residual Risk | Medium     |

Monad’s documentation is part of the product.

If docs become stale, Monad loses governance credibility.

Documentation risk is especially high because Monad has many planning artifacts:

* README,
* product charter,
* PRD,
* architecture overview,
* ADRs,
* roadmap,
* work packets,
* testing strategy,
* security model,
* governance model,
* command catalog,
* manifest reference,
* traceability matrix,
* and risk register.

Mitigation:

* treat docs as code,
* require docs updates for behavior changes,
* implement `monad docs check`,
* validate links and required sections,
* connect docs to work packets,
* keep ADR index current,
* and include documentation review in release readiness.

Future `monad docs check` may validate:

* required files exist,
* ADR index matches ADR files,
* work packet references are valid,
* command catalog documentation matches CLI surface,
* risk register IDs are unique,
* traceability links are not broken,
* and stale TODO markers are flagged.

---

### 20.8.12 R-012: Work Packet Process Becomes Bureaucratic

| Field         | Value         |
| ------------- | ------------- |
| Risk ID       | R-012         |
| Category      | Product       |
| Likelihood    | Medium        |
| Impact        | Medium        |
| Severity      | Medium        |
| Owner Role    | Product owner |
| Related WP    | WP-0018       |
| Residual Risk | Medium        |

Work packets are intended to make implementation manageable and traceable.

The risk is that they become too heavy for solo development.

A governance process that requires too much ceremony may slow the project more than it helps.

Mitigation:

* keep work packet templates lightweight,
* use progressive detail,
* allow small layers,
* avoid heavyweight approval workflows early,
* provide profiles for solo, team, and enterprise usage,
* and let CLI tooling reduce documentation burden over time.

A work packet should answer:

```text
What is being changed?
Why is it needed?
What is in scope?
What is out of scope?
What tests prove it?
What docs change?
What risks are affected?
```

It should not become a miniature enterprise program-management document unless the work truly requires that level of detail.

---

### 20.8.13 R-013: Rust Crate Boundaries Become Premature

| Field         | Value        |
| ------------- | ------------ |
| Risk ID       | R-013        |
| Category      | Architecture |
| Likelihood    | Medium       |
| Impact        | Medium       |
| Severity      | Medium       |
| Owner Role    | Architect    |
| Related WP    | WP-0001      |
| Residual Risk | Medium       |

Monad is a Rust workspace and may eventually contain multiple crates.

The initial crate structure should remain minimal:

```text
crates/
  monad-cli/
  monad-core/
```

Future crates may include:

```text
monad-config
monad-inspect
monad-graph
monad-context
monad-docs
monad-policy
monad-plans
monad-packs
```

The risk is premature crate explosion.

Too many crates too early can create:

* empty abstractions,
* complex dependency relationships,
* slow refactoring,
* confusing ownership,
* excessive boilerplate,
* and architecture that looks mature but is behaviorally thin.

Mitigation:

* extract crates only when behavior justifies extraction,
* keep domain boundaries clear inside existing crates first,
* avoid creating crates for planned concepts without implementation,
* use tests to reveal stable boundaries,
* and prefer simple modules before workspace fragmentation.

Extraction should be justified by at least one of:

* independent domain model,
* clear dependency boundary,
* reusable API,
* substantial tests,
* separate feature maturity,
* or compile-time/ownership benefit.

---

### 20.8.14 R-014: Native Tool Adapter Behavior Inconsistent

| Field         | Value             |
| ------------- | ----------------- |
| Risk ID       | R-014             |
| Category      | Integration       |
| Likelihood    | Medium            |
| Impact        | Medium            |
| Severity      | Medium            |
| Owner Role    | Integration owner |
| Related WP    | WP-0044-WP-0049   |
| Residual Risk | Medium            |

Monad will eventually coordinate native tools such as Git, Cargo, Bun, Node package managers, Moon, Turborepo, and CI systems.

The risk is inconsistent adapter behavior.

Examples:

* one adapter treats missing tool as an error while another treats it as a warning,
* one adapter parses output loosely while another requires strict structure,
* one adapter mutates state unexpectedly,
* one adapter shells out in unsafe ways,
* one adapter does not handle workspaces correctly,
* one adapter behaves differently across operating systems.

Mitigation:

* define adapter contracts,
* use fixture repositories,
* test missing-tool behavior,
* test command invocation behavior,
* standardize error categories,
* standardize finding severity,
* and document adapter expectations.

Adapter behavior should be explicit:

```text
Detect.
Inspect.
Report.
Optionally coordinate.
Do not silently mutate.
```

---

### 20.8.15 R-015: Hosted Layer Distracts from Local Core

| Field         | Value         |
| ------------- | ------------- |
| Risk ID       | R-015         |
| Category      | Strategy      |
| Likelihood    | Medium        |
| Impact        | High          |
| Severity      | High          |
| Owner Role    | Product owner |
| Related WP    | WP-0068+      |
| Residual Risk | Low           |

Monad may eventually support an optional hosted control plane.

Hosted capabilities could include:

* repo metadata sync,
* organization/team model,
* graph dashboard,
* policy dashboard,
* release governance dashboard,
* audit evidence,
* and multi-repo fleet visibility.

However, building hosted features too early would violate the product doctrine.

The local CLI is the trust foundation.

Mitigation:

* defer hosted control plane until local v1,
* avoid database dependencies in core commands,
* avoid SaaS-first architecture,
* avoid requiring accounts or cloud infrastructure,
* and ensure every hosted concept has a local-first equivalent or fallback.

Hosted features should be additive, not foundational.

Correct sequence:

```text
local CLI
  -> local docs/governance/context/graph
    -> local plan/apply
      -> local policy/release evidence
        -> optional hosted sync/dashboard
```

---

### 20.8.16 R-016: Hard-to-Explain Product Category

| Field         | Value         |
| ------------- | ------------- |
| Risk ID       | R-016         |
| Category      | GTM           |
| Likelihood    | High          |
| Impact        | Medium        |
| Severity      | High          |
| Owner Role    | Product owner |
| Related WP    | docs/product  |
| Residual Risk | Medium        |

Monad’s product category is not obvious.

It overlaps with:

* CLIs,
* scaffolders,
* monorepo tools,
* task runners,
* documentation tools,
* architecture governance tools,
* policy-as-code,
* AI coding context tools,
* release governance tools,
* and internal developer platforms.

The risk is that users do not understand what Monad is for.

The recommended framing is:

```text
Monad is a local-first SDLC control plane.
```

Expanded framing:

```text
Monad turns a repository into a governed lifecycle graph and exposes a safe local control plane for understanding, validating, documenting, planning, and evolving it.
```

Mitigation:

* keep positioning consistent,
* avoid describing Monad as merely a scaffolder,
* avoid leading with AI,
* demonstrate value through concrete read-only commands,
* show before/after repository understanding,
* and document adoption paths for solo developers, teams, and future enterprises.

A clear category statement should appear in:

* README,
* product charter,
* docs index,
* architecture overview,
* CLI help text,
* release notes,
* and future website copy.

---

### 20.8.17 R-017: Graph/Cache Data Treated as Source of Truth

| Field         | Value      |
| ------------- | ---------- |
| Risk ID       | R-017      |
| Category      | Data       |
| Likelihood    | Medium     |
| Impact        | Medium     |
| Severity      | Medium     |
| Owner Role    | Data owner |
| Related WP    | WP-0059    |
| Residual Risk | Low        |

Monad may generate local state in `.monad/`.

Examples:

```text
.monad/cache/
.monad/context/
.monad/reports/
.monad/plans/
.monad/graphs/
```

The risk is that generated state or cached graph data becomes confused with canonical repository truth.

Canonical truth should remain in source-controlled files such as:

* `monad.toml`,
* documentation,
* ADRs,
* work packets,
* policy files,
* manifests,
* source code,
* and native tool configuration files.

`.monad/` should generally be local generated state unless explicitly documented otherwise.

Mitigation:

* document source-of-truth rules,
* include provenance metadata in generated artifacts,
* distinguish derived state from canonical state,
* allow regeneration,
* include cache invalidation strategy,
* and make `monad check` detect stale or conflicting generated state where appropriate.

Generated artifacts should answer:

```text
Generated by what command?
From which inputs?
At what time?
Using what Monad version?
Is this canonical or derived?
Can it be regenerated?
```

---

### 20.8.18 R-018: Apply Failures Leave Partial State

| Field         | Value           |
| ------------- | --------------- |
| Risk ID       | R-018           |
| Category      | Reliability     |
| Likelihood    | Medium          |
| Impact        | High            |
| Severity      | High            |
| Owner Role    | Plan owner      |
| Related WP    | WP-0028/WP-0029 |
| Residual Risk | Medium          |

Even with plan-backed mutation, apply operations can fail.

Failures may happen because of:

* file permission errors,
* concurrent edits,
* changed file hashes,
* invalid paths,
* disk issues,
* interrupted process,
* invalid plan,
* failed preconditions,
* symlink behavior,
* or platform-specific filesystem behavior.

The risk is partial state.

A plan may apply some operations and fail before applying others, leaving the repository inconsistent.

Mitigation:

* preflight validation,
* operation ordering,
* content hash checks,
* temporary files for writes,
* atomic rename where possible,
* rollback hints,
* apply reports,
* idempotency where possible,
* and explicit partial-failure status.

Monad does not need perfect transactional filesystem semantics early, but it must be honest about apply results.

Apply reports should include:

* operations planned,
* operations skipped,
* operations applied,
* operations failed,
* files changed,
* preflight checks,
* warnings,
* rollback hints,
* and final status.

---

### 20.8.19 R-019: Policy False Positives Frustrate Users

| Field         | Value           |
| ------------- | --------------- |
| Risk ID       | R-019           |
| Category      | Governance      |
| Likelihood    | Medium          |
| Impact        | Medium          |
| Severity      | Medium          |
| Owner Role    | Policy owner    |
| Related WP    | WP-0040-WP-0043 |
| Residual Risk | Medium          |

Policy checks can help repositories stay governed. They can also frustrate users if they are too noisy, too rigid, or poorly explained.

False positives may cause users to disable policies entirely.

Mitigation:

* start with advisory checks,
* use severity levels,
* provide explanations,
* support waivers,
* support expiration dates for waivers,
* document policy rationale,
* and avoid enforcing policy before checks are trustworthy.

Policy severity levels may include:

| Severity | Meaning                                  |
| -------- | ---------------------------------------- |
| Info     | Helpful observation.                     |
| Warning  | Should be reviewed.                      |
| Error    | Should block readiness unless waived.    |
| Critical | Unsafe or governance-breaking condition. |

Policy checks should answer:

```text
What rule fired?
Why does it matter?
What evidence triggered it?
How can it be fixed?
Can it be waived?
When should the waiver expire?
```

---

### 20.8.20 R-020: Solo Developer Process Becomes Too Heavy

| Field         | Value         |
| ------------- | ------------- |
| Risk ID       | R-020         |
| Category      | Delivery      |
| Likelihood    | High          |
| Impact        | Medium        |
| Severity      | High          |
| Owner Role    | Project owner |
| Related WP    | All           |
| Residual Risk | Medium        |

Monad is ambitious, but current development may be driven by a solo developer.

The risk is that the process becomes too heavy to execute.

Too much ceremony can create drag:

* too many docs,
* too many work packets,
* too many generated files,
* too many scripts,
* too many failing checks,
* too many abstractions,
* too many roadmap branches,
* too many hotfix layers,
* and too much context required to continue.

Mitigation:

* use small layers,
* keep tests green,
* commit after each stable increment,
* avoid fragile shell scripts,
* prefer copy-pasteable file patches when needed,
* stabilize before expanding,
* defer hosted features,
* defer complex plugin systems,
* and keep local commands useful before enterprise workflows.

The solo-developer operating principle:

```text
A governance system that cannot be used by one serious developer should not be scaled to a team.
```

Monad should make disciplined development easier, not heavier.

---

## 20.9 Risk-to-Doctrine Mapping

| Doctrine                                                 | Related Risks       |
| -------------------------------------------------------- | ------------------- |
| Local-first before hosted                                | R-015, R-020        |
| Deterministic before AI                                  | R-008, R-004        |
| Read-only understanding before mutation                  | R-003, R-018        |
| Plan-backed mutation before generators                   | R-003, R-009, R-018 |
| Source-of-truth rules before automation                  | R-005, R-017        |
| Command contracts before command depth                   | R-001, R-002, R-010 |
| Graph foundations before graph persistence               | R-007, R-017        |
| Policy checks before policy enforcement                  | R-019               |
| Templates before plugins                                 | R-009               |
| Solo-developer usability before enterprise extensibility | R-012, R-015, R-020 |

This mapping should be reviewed when doctrine changes, new ADRs are accepted, or major roadmap decisions are made.

---

## 20.10 Risk-to-Work-Packet Mapping

| Work Packet Area                                 | Primary Risks       |
| ------------------------------------------------ | ------------------- |
| WP-0001 Rust Workspace and CLI Foundation        | R-013, R-020        |
| WP-0002 Canonical Manifest and Workspace Model   | R-005, R-017        |
| WP-0004 Command Catalog Model                    | R-001, R-002, R-010 |
| WP-0005 Clap Surface Contract                    | R-001, R-002, R-010 |
| WP-0006 Placeholder Honesty and Command Metadata | R-001, R-002        |
| WP-0007 CLI Output and Exit Code Standardization | R-010               |
| WP-0008 Workspace Root Detection                 | R-003, R-005        |
| WP-0009 Repository Inspection Engine             | R-006, R-014        |
| WP-0010 Baseline Check Engine                    | R-005, R-011, R-017 |
| WP-0012 Lifecycle Graph v0                       | R-007, R-017        |
| WP-0014 Docs Check                               | R-011               |
| WP-0018 Work Packet List and Validation          | R-012, R-020        |
| WP-0020 Context Model                            | R-004, R-008        |
| WP-0021 Handoff Generator                        | R-004, R-011        |
| WP-0023 Context Redaction and Safety             | R-004               |
| WP-0025 Plan Schema and Domain Model             | R-003, R-018        |
| WP-0027 Dry-Run Apply Engine                     | R-003, R-018        |
| WP-0028 Apply Engine with Approval               | R-003, R-018        |
| WP-0029 Rollback Hints and Apply Reports         | R-018               |
| WP-0030 Plan Policy Evaluation                   | R-003, R-019        |
| WP-0031-WP-0037 Templates, Packs, Generators     | R-001, R-003, R-009 |
| WP-0038-WP-0043 Policy Engine and Waivers        | R-019               |
| WP-0044-WP-0049 Native Tool Coordination         | R-006, R-014        |
| WP-0055-WP-0060 Advanced Graph and Query Layer   | R-007, R-017        |
| WP-0061-WP-0067 AI-Assisted Workflows            | R-004, R-008        |
| WP-0068+ Hosted Control Plane                    | R-015               |

A work packet should identify which risks it affects.

If a work packet increases a High or Critical risk, it should document the mitigation before implementation begins.

---

## 20.11 Risk-to-Test Mapping

| Risk                            | Test Evidence                                                             |
| ------------------------------- | ------------------------------------------------------------------------- |
| R-001 Scope explosion           | Command catalog tests, roadmap review checklist                           |
| R-002 Placeholder trust         | Placeholder honesty tests, CLI smoke tests                                |
| R-003 Unsafe mutation           | Mutation safety tests, fixture integration tests                          |
| R-004 Secret leakage            | Context redaction tests, security fixtures                                |
| R-005 Manifest drift            | Manifest resolution tests, drift fixtures                                 |
| R-006 Replacing native tools    | Architecture tests where possible, adapter contract tests                 |
| R-007 Graph complexity          | Graph schema tests, graph invariant tests                                 |
| R-008 AI trust                  | Noop adapter tests, AI audit metadata tests, deterministic fallback tests |
| R-009 Supply-chain risk         | Pack validation tests, checksum/signature tests later                     |
| R-010 Output breakage           | Snapshot tests, JSON schema tests, exit code tests                        |
| R-011 Stale documentation       | Docs check tests, link/reference validation                               |
| R-012 Bureaucratic work packets | Template usability review, workflow tests                                 |
| R-013 Premature crates          | Architecture review, workspace dependency checks                          |
| R-014 Adapter inconsistency     | Adapter conformance tests, native tool fixtures                           |
| R-015 Hosted distraction        | Roadmap gates, local-first release checklist                              |
| R-016 Category confusion        | README/product docs review                                                |
| R-017 Cache as truth            | Source provenance tests, check command fixtures                           |
| R-018 Partial apply             | Apply failure tests, rollback hint tests                                  |
| R-019 Policy false positives    | Policy explain tests, waiver tests                                        |
| R-020 Solo process heaviness    | Cadence review, layer-size review                                         |

The risk register should not rely only on human review. Where a risk maps to observable behavior, there should eventually be test evidence.

---

## 20.12 Risk Review Cadence

Risk review should happen at practical boundaries.

Recommended review points:

| Review Point                            | Purpose                                              |
| --------------------------------------- | ---------------------------------------------------- |
| Before starting a new work packet       | Identify relevant risks and mitigation requirements. |
| Before merging a layer                  | Confirm no unmanaged risk was introduced.            |
| After a failing contract test           | Determine whether a known risk is materializing.     |
| Before implementing mutation            | Reassess R-003 and R-018.                            |
| Before implementing context export      | Reassess R-004 and R-008.                            |
| Before implementing AI provider support | Reassess R-004 and R-008.                            |
| Before implementing packs/plugins       | Reassess R-009.                                      |
| Before release                          | Review all High and Critical risks.                  |
| After major architecture change         | Update risk register and ADR links.                  |

For solo development, the review should remain lightweight. A brief risk note in the work packet or commit summary is usually enough.

---

## 20.13 Risk Status Lifecycle

Each risk should eventually have a status.

Recommended statuses:

| Status     | Meaning                                                        |
| ---------- | -------------------------------------------------------------- |
| Open       | Risk is active and requires monitoring.                        |
| Mitigating | Active mitigation is underway.                                 |
| Controlled | Mitigations are in place and residual risk is acceptable.      |
| Accepted   | Risk is knowingly accepted without further mitigation for now. |
| Deferred   | Risk is tied to deferred scope.                                |
| Retired    | Risk no longer applies.                                        |
| Escalated  | Risk requires architecture/product decision.                   |

Initial risks may omit explicit status, but future versions should add it.

Suggested initial status:

| Risk  | Suggested Status                   |
| ----- | ---------------------------------- |
| R-001 | Open                               |
| R-002 | Open                               |
| R-003 | Open                               |
| R-004 | Open                               |
| R-005 | Mitigating                         |
| R-006 | Controlled by ADR, still monitored |
| R-007 | Open                               |
| R-008 | Deferred but monitored             |
| R-009 | Deferred                           |
| R-010 | Open                               |
| R-011 | Open                               |
| R-012 | Open                               |
| R-013 | Open                               |
| R-014 | Deferred                           |
| R-015 | Controlled by roadmap              |
| R-016 | Open                               |
| R-017 | Open                               |
| R-018 | Deferred until apply engine        |
| R-019 | Deferred until policy engine       |
| R-020 | Open                               |

---

## 20.14 Risk Triggers and Escalation

Some risks should trigger immediate review when certain events occur.

| Risk  | Trigger                                                                                   |
| ----- | ----------------------------------------------------------------------------------------- |
| R-001 | New command family proposed before current layer is stable.                               |
| R-002 | More placeholder commands than implemented useful commands in a release.                  |
| R-003 | Any command writes files without plan/apply semantics.                                    |
| R-004 | Context command includes ignored files, secrets, or unreviewed sensitive paths.           |
| R-005 | `monad.toml` and `workspace.toml` disagree without a clear finding.                       |
| R-006 | Monad begins reimplementing behavior owned by Cargo, Git, Bun, Moon, Turborepo, or CI.    |
| R-007 | Graph implementation requires persistence before v0 graph is useful.                      |
| R-008 | AI is required for a core command to work correctly.                                      |
| R-009 | Remote packs or executable plugins are introduced before trust model.                     |
| R-010 | JSON output changes without schema versioning.                                            |
| R-011 | Behavior changes without corresponding docs update.                                       |
| R-012 | Work packet preparation takes longer than the implementation layer it governs.            |
| R-013 | New crate created without stable behavior or tests.                                       |
| R-014 | Adapter behavior differs across tools without documented reason.                          |
| R-015 | Hosted backend becomes required for local CLI behavior.                                   |
| R-016 | Product docs describe Monad inconsistently across README, charter, and architecture docs. |
| R-017 | `.monad/` data becomes required as canonical truth.                                       |
| R-018 | Apply operation can partially fail without report or rollback hints.                      |
| R-019 | Policy check blocks work without explanation or waiver path.                              |
| R-020 | Scripts, process, or documentation become too fragile for solo continuation.              |

Escalation should not automatically mean stopping all work. It means the risk must be explicitly acknowledged and either mitigated, accepted, deferred, or converted into an ADR/work-packet decision.

---

## 20.15 Risk Acceptance Rules

Not every risk must be eliminated.

Risk acceptance is allowed when:

* the risk is understood,
* the residual risk is tolerable,
* mitigation would cost more than the risk justifies,
* the affected scope is experimental or deferred,
* and the acceptance is documented.

Risk acceptance is not allowed for:

* silent repository mutation,
* known secret leakage,
* canonical source-of-truth ambiguity,
* AI provider calls without opt-in,
* executable plugin behavior without trust controls,
* or release claims that are not supported by tests.

Critical risks require explicit treatment before stable release.

High risks require mitigation or documented acceptance.

Medium risks require monitoring.

Low risks may be tracked with minimal ceremony.

---

## 20.16 Risk Relationship to ADRs

Risks and ADRs should reinforce each other.

ADRs define decisions. Risks explain why decisions matter and what could go wrong.

Examples:

| ADR                                                        | Related Risks |
| ---------------------------------------------------------- | ------------- |
| ADR-0001 Rust Single-Binary Runtime                        | R-013, R-020  |
| ADR-0002 Coordinate Native Tools Instead of Replacing Them | R-006, R-014  |
| ADR-0003 Local-First Core                                  | R-015, R-020  |
| ADR-0004 AI-Native but AI-Optional                         | R-004, R-008  |
| ADR-0005 `monad.toml` Is the Canonical Manifest            | R-005, R-017  |
| ADR-0006 Plan-Backed Mutation                              | R-003, R-018  |
| ADR-0008 Lifecycle Graph as Core Model                     | R-007, R-017  |
| ADR-0010 Policy-as-Code                                    | R-019         |
| ADR-0011 Deterministic Context Before AI Assistance        | R-004, R-008  |
| ADR-0012 Honest Placeholder Commands                       | R-001, R-002  |

When an ADR is added, superseded, or deprecated, the risk register should be reviewed.

If a risk reveals that an accepted ADR is wrong or incomplete, the correct response is not to silently change direction. The correct response is to draft a new ADR or superseding ADR.

---

## 20.17 Risk Relationship to Release Readiness

Release readiness should include risk review.

A local-first release should not be considered ready if:

* command catalog and Clap surface are drifting,
* mutating commands can write without plan/apply controls,
* context export can include secrets,
* `monad.toml` source-of-truth behavior is unclear,
* JSON output is unstable without versioning,
* documentation does not match behavior,
* tests do not prove claimed behavior,
* or High/Critical risks are unmanaged.

Minimum release risk gate:

```bash
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
```

Near-term stronger gate:

```bash
cargo clippy --workspace --all-targets -- -D warnings
cargo test -p monad-cli --test command_catalog_contract
```

Future release risk checks may include:

```bash
monad risk check
monad docs check
monad policy check
monad trace check
monad release readiness
```

These future commands should be introduced only when the underlying behavior exists.

---

## 20.18 Future `monad risk` Command Concepts

Monad may eventually include risk-related commands.

Potential command surface:

```bash
monad risk list
monad risk show R-003
monad risk check
monad risk graph
monad risk explain R-004
monad risk affected-by WP-0023
monad risk release-readiness
```

These commands should remain read-only at first.

Possible future behavior:

| Command                          | Behavior                                                                   |
| -------------------------------- | -------------------------------------------------------------------------- |
| `monad risk list`                | Lists known risks from local risk register files.                          |
| `monad risk show R-003`          | Shows a single risk and related work packets, ADRs, tests, and docs.       |
| `monad risk check`               | Validates risk IDs, required fields, duplicate IDs, and broken references. |
| `monad risk graph`               | Exports risk relationships to Mermaid, DOT, or JSON.                       |
| `monad risk explain R-004`       | Explains why the risk matters and how it is mitigated.                     |
| `monad risk affected-by WP-0023` | Shows risks related to a work packet.                                      |
| `monad risk release-readiness`   | Reports unmanaged High/Critical risks before release.                      |

These should not become mutating commands until the plan/apply model exists.

---

## 20.19 Minimum Viable Risk Controls

Before Monad moves beyond CLI foundation work, it should have minimum risk controls for the current layer.

### 20.19.1 During CLI Foundation

Required controls:

* command catalog exists,
* Clap surface matches catalog,
* placeholders are honest,
* smoke tests pass,
* no unsafe write behavior exists,
* source-of-truth rules are documented.

Primary risks:

* R-001,
* R-002,
* R-005,
* R-010,
* R-013,
* R-020.

### 20.19.2 During Read-Only Repository Understanding

Required controls:

* inspect/check/doctor commands are read-only,
* fixture repositories test expected behavior,
* manifest resolution is deterministic,
* findings are structured,
* docs reflect command behavior.

Primary risks:

* R-005,
* R-006,
* R-010,
* R-011,
* R-014,
* R-017.

### 20.19.3 During Context and Handoff Features

Required controls:

* context generation is local,
* ignored files are excluded,
* secret-like values are redacted,
* reports explain included/excluded sources,
* AI providers are not called implicitly.

Primary risks:

* R-004,
* R-008,
* R-011,
* R-017.

### 20.19.4 During Plan-Backed Mutation

Required controls:

* plan schema exists,
* dry-run performs no writes,
* apply requires approval,
* apply writes only planned files,
* overwrite detection exists,
* rollback hints exist,
* mutation safety tests pass.

Primary risks:

* R-003,
* R-018,
* R-019.

### 20.19.5 During Templates, Packs, and Generators

Required controls:

* templates are inspectable,
* generated changes flow through plans,
* pack metadata is validated,
* remote trust is deferred or explicitly controlled,
* executable plugin behavior is deferred.

Primary risks:

* R-001,
* R-003,
* R-009,
* R-018.

---

## 20.20 Open Risk Questions

The following questions should remain open until the relevant work packets are reached.

### 20.20.1 Risk File Format

Should the risk register remain purely Markdown, or should Monad introduce a structured risk file?

Possible future formats:

```text
docs/risk/risk-register.md
governance/risks.yaml
.monad/risk.generated.json
```

Recommendation:

Start with Markdown. Add structured metadata only when `monad risk check` or traceability automation requires it.

### 20.20.2 Risk Ownership in Solo Development

How should owner roles work when there is only one developer?

Recommendation:

Use roles, not people. A solo developer can temporarily hold multiple roles without changing the governance model.

### 20.20.3 Risk Enforcement

Should High/Critical risks block releases automatically?

Recommendation:

Eventually yes, but not before risk metadata and release-readiness checks are reliable.

### 20.20.4 Hosted Risk Register

Should hosted Monad eventually aggregate risk posture across repositories?

Recommendation:

Possibly, but only after local-first risk, traceability, policy, and release evidence are useful locally.

---

## 20.21 Risk Register Maintenance Rules

The risk register should be updated when:

* a new High or Critical risk is identified,
* a major ADR is accepted,
* a work packet changes scope,
* a command changes from placeholder to implemented,
* a read-only command becomes mutating,
* context export behavior changes,
* AI provider support is introduced,
* plan/apply behavior changes,
* policy enforcement behavior changes,
* pack/plugin behavior changes,
* hosted control-plane work begins,
* or release readiness criteria change.

A risk update should include:

* changed risk description,
* changed likelihood/impact/severity,
* changed mitigation,
* changed detection method,
* changed owner role,
* changed related work packets,
* changed residual risk,
* and rationale if the change is significant.

---

## 20.22 Summary

Monad’s greatest risks are not technical difficulty alone.

The greatest risks are trust risks.

Monad must be trusted not to:

* pretend planned commands are implemented,
* mutate repositories unsafely,
* leak secrets into context packs,
* confuse generated state with source of truth,
* require AI for correctness,
* replace native tools poorly,
* let documentation drift,
* or bury a solo developer under process weight.

The correct mitigation is not to make Monad smaller in vision. The correct mitigation is to make the implementation sequence disciplined.

The risk register reinforces the roadmap:

```text
trustworthy CLI foundation
  -> read-only repository understanding
    -> documentation and context lifecycle
      -> lifecycle graph v0
        -> plan-backed mutation
          -> templates and packs
            -> policy and release governance
              -> AI assistance
                -> optional hosted control plane
```

A risk-aware Monad should remain:

* local-first,
* deterministic,
* governance-grade,
* AI-optional,
* source-of-truth aware,
* read-only before mutation,
* plan-backed before generation,
* native-tool coordinating,
* test-backed,
* and honest about what is implemented versus planned.
