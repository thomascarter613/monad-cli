# 19. Traceability Matrix

## 19.1 Purpose of This Section

This section defines the initial traceability model for Monad OS and Monad CLI.

Traceability connects:

* business goals,
* user needs,
* product requirements,
* architecture decisions,
* bounded contexts,
* implementation work packets,
* command behavior,
* tests,
* BDD scenarios,
* documentation,
* policies,
* risks,
* and release evidence.

Monad is intended to be a governance-grade SDLC control plane. That means it should not merely contain docs, ADRs, tests, and work packets as disconnected files. It should connect them into a traceable lifecycle system.

The traceability matrix exists to answer questions such as:

* Why does this feature exist?
* What user need does it support?
* Which requirement defines it?
* Which ADR justifies it?
* Which component implements it?
* Which work packet delivers it?
* Which tests prove it?
* Which docs explain it?
* Which policies govern it?
* Which risks does it mitigate?
* Which release evidence proves it is ready?

Traceability is not bureaucracy. In Monad, traceability is part of the product thesis.

The long-term goal is for Monad to help repositories explain not only **what exists**, but also **why it exists**, **how it is governed**, **how it is tested**, and **whether it is safe to change**.

---

## 19.2 Traceability Thesis

Monad’s traceability thesis is:

> A serious repository should be able to connect intent, architecture, implementation, validation, governance, and release evidence without relying on tribal knowledge.

For Monad, traceability should connect the following chain:

```text id="dfoz85"
Business Goal
  -> User Need
    -> Product Requirement
      -> Architecture Decision
        -> Bounded Context / Component
          -> Work Packet
            -> Layer / Task
              -> Test Evidence
                -> Documentation
                  -> Release Evidence
```

This chain does not need to be perfect on day one. It should mature over time.

Early Monad can begin with Markdown traceability tables. Later Monad can validate, query, graph, and report traceability automatically.

---

## 19.3 Traceability Principles

### 19.3.1 Traceability Should Be Useful

Traceability should help developers make better decisions.

It should answer practical questions:

* What does this command support?
* Why is this test required?
* Which work packet introduced this behavior?
* Which ADR does this implementation rely on?
* What breaks if this requirement changes?
* What evidence is needed before release?

### 19.3.2 Traceability Should Be Lightweight First

Early traceability may be Markdown-based.

Do not introduce heavyweight requirements management tools, databases, graph databases, or hosted traceability systems too early.

The initial model can live in:

```text id="54goct"
governance/traceability-matrix.md
docs/planning/0018-traceability-matrix.md
docs/roadmap/work-packets/
docs/architecture/decision-records/
```

### 19.3.3 Traceability Should Become Machine-Readable Over Time

Markdown is acceptable early, but the structure should be predictable enough for future Monad commands.

Future commands may include:

```bash id="c6r806"
monad trace check
monad trace graph
monad trace explain <requirement-id>
monad release readiness
```

These commands should eventually be able to validate whether requirements, ADRs, work packets, tests, and docs are connected.

### 19.3.4 Traceability Should Support the Lifecycle Graph

Traceability is one of the main inputs to Monad’s lifecycle graph.

The lifecycle graph should eventually connect:

* requirements,
* commands,
* docs,
* ADRs,
* work packets,
* policies,
* tests,
* plans,
* releases,
* context packs,
* and risks.

### 19.3.5 Traceability Should Expose Gaps

The matrix should not only show what is connected. It should also expose missing evidence.

Examples:

```text id="wo6f48"
Requirement exists but has no tests.
Command exists but has no docs.
ADR exists but no work packet implements it.
Work packet exists but no acceptance criteria.
Policy exists but no policy check.
Risk exists but no mitigation.
Release claims readiness but lacks evidence.
```

### 19.3.6 Traceability Should Preserve Local-First Operation

The traceability model should work locally from repository files.

It should not require:

* hosted backend,
* external requirements database,
* SaaS project tracker,
* AI provider,
* graph database,
* or organization account.

Hosted traceability views may come later, but local traceability should exist first.

---

## 19.4 Traceability Entities

Monad should track traceability across several entity types.

### 19.4.1 Business Goals

Business goals describe why Monad exists.

Examples:

```text id="e6w548"
Make repositories understandable.
Make repositories governable.
Avoid unsafe repository changes.
Support AI-assisted development safely.
Preserve local-first value.
Reduce vendor lock-in.
Improve release readiness.
```

### 19.4.2 User Needs

User needs describe what users need to accomplish.

Examples:

```text id="qufc5c"
Inspect repository structure.
Validate source-of-truth consistency.
Understand command surface.
Generate AI-safe handoff context.
Plan before mutation.
Explain policy failures.
Validate docs and ADRs.
Generate lifecycle graph.
```

### 19.4.3 Requirements

Requirements define expected product behavior.

Examples:

```text id="at9c7j"
FR-001: Version reporting
FR-002: Command catalog
FR-003: List commands
FR-004: Config inspection
FR-005: Repository inspection
FR-006: Baseline checks
FR-007: Doctor diagnostics
FR-008: Graph generation
FR-009: Context handoff
FR-010: Docs check
FR-011: Plan creation
FR-012: Apply through approval
```

### 19.4.4 Architecture Decisions

Architecture decisions are captured in ADRs.

Examples:

```text id="rspsjn"
ADR-0001: Rust Single-Binary Runtime
ADR-0002: Coordinate Native Tools Instead of Replacing Them
ADR-0003: Local-First Core
ADR-0004: AI-Native but AI-Optional
ADR-0005: monad.toml Is the Canonical Manifest
ADR-0006: Plan-Backed Mutation
ADR-0012: Honest Placeholder Commands
```

### 19.4.5 Architecture Components

Architecture components describe where behavior belongs.

Examples:

```text id="x43a6i"
monad-cli
monad-core
monad-config
monad-inspect
monad-graph
monad-context
monad-docs
monad-policy
monad-plans
monad-packs
native tool adapters
output layer
finding model
```

### 19.4.6 Work Packets

Work packets define implementation delivery units.

Examples:

```text id="b4w9jr"
WP-0004: Command Catalog Model
WP-0005: Clap Surface Contract
WP-0008: Workspace Root Detection
WP-0009: Repository Inspection Engine
WP-0010: Baseline Check Engine
WP-0011: Doctor Diagnostics
WP-0012: Lifecycle Graph v0
WP-0021: Handoff Generator
WP-0025: Plan Schema and Domain Model
```

### 19.4.7 Tests

Tests provide evidence.

Examples:

```text id="dfkncf"
unit tests
fixture integration tests
CLI smoke tests
command catalog contract tests
snapshot tests
schema tests
security tests
mutation safety tests
BDD scenario tests
future AI evaluation tests
```

### 19.4.8 Documentation

Docs explain the feature, decision, requirement, or workflow.

Examples:

```text id="am37c7"
README.md
docs/product/prd.md
docs/architecture/overview.md
docs/engineering/testing-strategy.md
docs/reference/manifest.md
docs/reference/command-catalog.md
docs/reference/plan-schema.md
docs/user-guide/commands.md
```

### 19.4.9 Policies

Policies define governance rules.

Examples:

```text id="sl6b89"
canonical manifest policy
command catalog policy
docs required policy
no unsafe mutation policy
secret redaction policy
release readiness policy
```

### 19.4.10 Risks

Risks identify what can go wrong.

Examples:

```text id="p8mz9b"
command drift
unsafe mutation
secret leakage
docs drift
policy false positives
AI overreach
hosted prematurity
source-of-truth confusion
```

---

## 19.5 Identifier Strategy

Traceability depends on stable identifiers.

Recommended identifier patterns:

| Entity                     | Pattern            | Example                       |
| -------------------------- | ------------------ | ----------------------------- |
| Business Goal              | `BG-NNN`           | `BG-001`                      |
| User Need                  | `UN-NNN`           | `UN-001`                      |
| Functional Requirement     | `FR-NNN`           | `FR-005`                      |
| Non-Functional Requirement | `NFR-NNN`          | `NFR-001`                     |
| ADR                        | `ADR-NNNN`         | `ADR-0005`                    |
| Work Packet                | `WP-NNNN`          | `WP-0010`                     |
| BDD Scenario               | `BDD-DOMAIN-NNN`   | `BDD-MANIFEST-002`            |
| Policy                     | `POLICY-KEBAB-ID`  | `POLICY-CANONICAL-MANIFEST`   |
| Finding                    | `DOMAIN-STABLE-ID` | `MANIFEST-CANONICAL-CONFLICT` |
| Risk                       | `RISK-NNN`         | `RISK-003`                    |
| Release Evidence           | `EVID-NNN`         | `EVID-001`                    |

These IDs should be stable enough to appear in docs, tests, reports, release evidence, and future graph outputs.

---

## 19.6 Core Traceability Matrix

The matrix below is the initial traceability baseline.

| Business Goal                 | User Need                      | Requirement                     | Architecture Component                              | Test Evidence                          | Work Packet              | Docs                                     |
| ----------------------------- | ------------------------------ | ------------------------------- | --------------------------------------------------- | -------------------------------------- | ------------------------ | ---------------------------------------- |
| Make repos understandable     | Inspect repo structure         | `monad inspect`                 | `monad-inspect`, inspection model                   | Fixture integration tests              | WP-0009                  | `docs/user-guide/commands.md`            |
| Make repos governable         | Validate invariants            | `monad check`                   | `monad-config`, check engine, future `monad-policy` | Check tests, fixture tests             | WP-0010                  | `docs/engineering/testing-strategy.md`   |
| Preserve trust                | Command honesty                | Command metadata                | Command catalog                                     | Catalog contract tests                 | WP-0004, WP-0006         | `docs/engineering/command-catalog.md`    |
| Avoid unsafe changes          | Plan before mutation           | Plan/apply                      | `monad-plans`                                       | Dry-run/apply safety tests             | WP-0025–WP-0029          | `docs/reference/plan-schema.md`          |
| Support AI safely             | Generate deterministic context | Context handoff                 | `monad-context`                                     | Redaction tests, context fixture tests | WP-0020–WP-0024          | `docs/user-guide/context-handoff.md`     |
| Preserve local-first value    | No required backend            | Local file-backed operation     | `monad-config`, filesystem adapters                 | Offline/no-network tests               | WP-0002, WP-0008         | `docs/architecture/overview.md`          |
| Avoid vendor lock-in          | Cloud/database agnostic design | Adapter boundaries              | Ports/adapters, native tool coordination            | Adapter conformance tests              | WP-0044–WP-0049          | `docs/architecture/data-architecture.md` |
| Improve governance            | ADR/work-packet lifecycle      | ADR/workpacket commands         | Governance context, docs model                      | Docs fixture tests                     | WP-0016–WP-0019          | `docs/governance/governance-model.md`    |
| Enable graph moat             | Lifecycle graph                | Graph outputs                   | `monad-graph`                                       | Graph invariant tests                  | WP-0012, WP-0055–WP-0060 | `docs/reference/graph-schema.md`         |
| Enable CI use                 | Machine-readable checks        | JSON output/exit codes          | Output layer, findings model                        | Schema tests, CLI integration tests    | WP-0007                  | `docs/engineering/output-formats.md`     |
| Improve diagnostics           | Explain actionable problems    | `monad doctor`                  | Diagnostics model, findings model                   | Doctor fixture tests, snapshot tests   | WP-0011                  | `docs/operations/operational-model.md`   |
| Prevent source-of-truth drift | Canonical manifest rules       | `monad config`, manifest checks | `monad-config`                                      | Manifest unit and fixture tests        | WP-0002                  | `docs/reference/manifest.md`             |
| Protect secrets               | Exclude sensitive context      | Context redaction               | `monad-context`, redaction model                    | Security fixture tests                 | WP-0023                  | `docs/security/secret-handling.md`       |
| Support safe generation       | Preview generated changes      | Plan-backed generators          | `monad-plans`, `monad-packs`                        | Plan schema and mutation tests         | WP-0031–WP-0037          | `docs/reference/plan-schema.md`          |
| Support policy governance     | Explain policy failures        | `monad policy check/explain`    | `monad-policy`                                      | Policy unit/fixture/schema tests       | WP-0038–WP-0043          | `docs/governance/policy-process.md`      |
| Support release governance    | Determine release readiness    | `monad release readiness`       | Release context, policy, evidence model             | Release readiness tests                | WP-0050–WP-0054          | `docs/governance/release-governance.md`  |

---

## 19.7 Requirement-to-Test Mapping

| Requirement                                 | Primary Tests                   | Secondary Tests                  |
| ------------------------------------------- | ------------------------------- | -------------------------------- |
| `monad version` reports version             | CLI smoke test                  | Snapshot test                    |
| `monad list` lists commands                 | CLI smoke test                  | Snapshot test, catalog unit test |
| Catalog matches Clap                        | Command catalog contract test   | Example command validation       |
| Placeholder commands are honest             | Placeholder behavior test       | Snapshot test                    |
| Mutating commands declare metadata          | Command metadata test           | Catalog contract test            |
| `monad.toml` is canonical                   | Manifest unit test              | Fixture integration test         |
| `workspace.toml` mirror conflicts reported  | Fixture integration test        | Doctor diagnostic test           |
| Workspace root is detected                  | Root detection unit test        | Nested fixture test              |
| Missing workspace is explained              | CLI integration test            | Doctor diagnostic test           |
| `monad inspect` reports repo structure      | Fixture integration test        | Snapshot/JSON test               |
| `monad inspect` is read-only                | Filesystem mutation safety test | Fixture test                     |
| `monad check` validates invariants          | Check fixture test              | Findings schema test             |
| `monad check --ci` exits nonzero on failure | CLI integration test            | Exit code contract test          |
| `monad doctor` gives remediation hints      | Doctor fixture test             | Snapshot test                    |
| `monad graph` emits valid graph             | Graph invariant test            | Snapshot test                    |
| Mermaid graph output is deterministic       | Snapshot test                   | Graph invariant test             |
| Graph JSON validates schema                 | Schema test                     | Fixture test                     |
| Context excludes secrets                    | Security fixture test           | Redaction unit test              |
| Context handoff works without AI            | CLI fixture test                | No-network/no-AI test            |
| Docs check reports missing docs             | Docs fixture test               | Finding schema test              |
| ADR list reports ADR status                 | Docs/governance fixture test    | Snapshot test                    |
| Work-packet list reports statuses           | Docs/governance fixture test    | Snapshot test                    |
| Policy check reports violation              | Policy fixture test             | Policy unit test                 |
| Policy explain returns remediation          | Policy unit/integration test    | Snapshot test                    |
| Plan creation does not modify files         | Mutation safety test            | Plan schema test                 |
| Dry-run does not modify files               | Dry-run mutation test           | Fixture diff test                |
| Apply only executes planned ops             | Apply contract test             | Filesystem mutation test         |
| Apply produces report                       | Apply report schema test        | Snapshot test                    |
| AI suggestion becomes reviewable plan       | Mocked AI evaluation test       | Plan validation test             |
| Hosted sync is optional                     | Future integration test         | Offline/local test               |

---

## 19.8 Requirement-to-Architecture Mapping

| Requirement              | Architecture Component                           | Related ADR                  |
| ------------------------ | ------------------------------------------------ | ---------------------------- |
| Version reporting        | `monad-cli`                                      | ADR-0001                     |
| Command catalog          | Command catalog model                            | ADR-0012                     |
| Clap/catalog alignment   | `monad-cli`, command catalog                     | ADR-0012                     |
| Canonical manifest       | `monad-config`                                   | ADR-0005                     |
| Workspace root detection | `monad-config`, filesystem adapter               | ADR-0003, ADR-0005           |
| Repository inspection    | `monad-inspect`                                  | ADR-0002, ADR-0003           |
| Baseline check           | Check engine, findings model                     | ADR-0005, ADR-0010           |
| Doctor diagnostics       | Diagnostics model, output layer                  | ADR-0003                     |
| Lifecycle graph          | `monad-graph`                                    | ADR-0008                     |
| Context handoff          | `monad-context`                                  | ADR-0004, ADR-0011           |
| Docs check               | `monad-docs`                                     | ADR-0009                     |
| ADR lifecycle            | Governance/docs context                          | ADR-0009                     |
| Work-packet lifecycle    | Governance/docs context                          | ADR-0009                     |
| Policy check             | `monad-policy`                                   | ADR-0010                     |
| Plan creation            | `monad-plans`                                    | ADR-0006                     |
| Dry-run apply            | `monad-plans`                                    | ADR-0006                     |
| Approved apply           | `monad-plans`                                    | ADR-0006                     |
| Native tool detection    | Native tool adapters                             | ADR-0002                     |
| AI-assisted planning     | AI provider port, `monad-context`, `monad-plans` | ADR-0004, ADR-0011, ADR-0006 |
| Hosted control plane     | Hosted projection layer                          | ADR-0003, future hosted ADR  |

---

## 19.9 ADR-to-Work-Packet Mapping

| ADR      | Decision                        | Primary Work Packets                     |
| -------- | ------------------------------- | ---------------------------------------- |
| ADR-0001 | Rust Single-Binary Runtime      | WP-0001                                  |
| ADR-0002 | Coordinate Native Tools         | WP-0009, WP-0044–WP-0049                 |
| ADR-0003 | Local-First Core                | WP-0002, WP-0008, WP-0009, WP-0021       |
| ADR-0004 | AI-Native but AI-Optional       | WP-0020–WP-0024, WP-0061–WP-0067         |
| ADR-0005 | `monad.toml` Is Canonical       | WP-0002, WP-0008, WP-0010, WP-0011       |
| ADR-0006 | Plan-Backed Mutation            | WP-0025–WP-0030                          |
| ADR-0007 | Modular Rust Workspace          | WP-0001, future crate extraction packets |
| ADR-0008 | Lifecycle Graph as Core Model   | WP-0012, WP-0055–WP-0060                 |
| ADR-0009 | Documentation-as-Code           | WP-0003, WP-0014–WP-0019                 |
| ADR-0010 | Policy-as-Code                  | WP-0038–WP-0043                          |
| ADR-0011 | Deterministic Context Before AI | WP-0020–WP-0024                          |
| ADR-0012 | Honest Placeholder Commands     | WP-0004, WP-0005, WP-0006, WP-0007       |

---

## 19.10 Work-Packet-to-Evidence Mapping

| Work Packet | Expected Evidence                                      |
| ----------- | ------------------------------------------------------ |
| WP-0000     | Repository foundation docs, README, ADR index          |
| WP-0001     | Rust workspace builds, version/help smoke tests        |
| WP-0002     | Manifest tests, source-of-truth fixtures               |
| WP-0003     | Docs/governance structure, future docs-check readiness |
| WP-0004     | Command catalog unit tests, command list output        |
| WP-0005     | Clap/catalog contract tests                            |
| WP-0006     | Placeholder honesty tests                              |
| WP-0007     | Output snapshots, exit code tests, JSON output tests   |
| WP-0008     | Workspace root detection tests                         |
| WP-0009     | Inspection fixture tests, read-only tests              |
| WP-0010     | Check engine fixture tests, CI exit code tests         |
| WP-0011     | Doctor diagnostics tests, remediation snapshots        |
| WP-0012     | Graph invariant tests, Mermaid/text snapshots          |
| WP-0013     | Drift fixture tests, JSON/text output                  |
| WP-0014     | Docs check fixture tests                               |
| WP-0015     | Docs generation preview/dry-run tests                  |
| WP-0016     | ADR list/validation tests                              |
| WP-0017     | ADR new/supersede dry-run tests                        |
| WP-0018     | Work-packet list/validation tests                      |
| WP-0019     | Work-packet plan output tests                          |
| WP-0020     | Context model tests                                    |
| WP-0021     | Handoff generation snapshot tests                      |
| WP-0022     | Context pack schema/tests                              |
| WP-0023     | Redaction/security fixture tests                       |
| WP-0024     | Context verification tests                             |
| WP-0025     | Plan schema/domain tests                               |
| WP-0026     | Plan creation fixture tests                            |
| WP-0027     | Dry-run no-write tests                                 |
| WP-0028     | Approved apply mutation safety tests                   |
| WP-0029     | Apply report and rollback hint tests                   |
| WP-0030     | Plan policy gate tests                                 |

---

## 19.11 BDD-to-Requirement Mapping

| BDD Feature                   | Requirement                   | Work Packet              | Test Type                  |
| ----------------------------- | ----------------------------- | ------------------------ | -------------------------- |
| Version reporting             | FR-001                        | WP-0001                  | CLI smoke                  |
| Command catalog visibility    | FR-002, FR-003                | WP-0004, WP-0006         | Smoke + snapshot           |
| Command catalog contract      | FR-002                        | WP-0005                  | Contract                   |
| Canonical manifest resolution | FR-004                        | WP-0002                  | Unit + fixture             |
| Repository inspection         | FR-005                        | WP-0009                  | Fixture + mutation safety  |
| Repository validation         | FR-006                        | WP-0010                  | Fixture + schema           |
| Doctor diagnostics            | FR-007                        | WP-0011                  | Fixture + snapshot         |
| Lifecycle graph generation    | FR-008                        | WP-0012                  | Graph invariant + snapshot |
| Context handoff generation    | FR-009                        | WP-0021                  | Snapshot + fixture         |
| Context safety                | FR-009, security requirements | WP-0023                  | Security fixture           |
| Documentation validation      | FR-010                        | WP-0014                  | Docs fixture               |
| ADR lifecycle                 | Governance requirement        | WP-0016, WP-0017         | Docs fixture               |
| Work packet lifecycle         | Governance requirement        | WP-0018, WP-0019         | Docs fixture               |
| Policy evaluation             | Policy requirement            | WP-0040, WP-0041         | Policy fixture             |
| Change planning               | FR-011                        | WP-0025, WP-0026         | Plan schema + fixture      |
| Dry-run apply                 | FR-012                        | WP-0027                  | Mutation safety            |
| Approved apply                | FR-012                        | WP-0028                  | Mutation safety            |
| Unsafe mutation blocking      | Safety requirement            | WP-0027, WP-0028         | Mutation safety            |
| Native tool coordination      | Native-tool requirement       | WP-0044–WP-0049          | Adapter tests              |
| AI-optional behavior          | AI requirement                | WP-0021, WP-0061–WP-0067 | Mocked AI/no-AI tests      |

---

## 19.12 Policy-to-Requirement Mapping

| Policy                       | Requirement Protected             | Related Finding                  |
| ---------------------------- | --------------------------------- | -------------------------------- |
| Canonical manifest policy    | `monad.toml` is canonical         | `MANIFEST-CANONICAL-CONFLICT`    |
| Command catalog policy       | Catalog and CLI must align        | `COMMAND-CATALOG-DRIFT`          |
| Docs required policy         | Required docs exist               | `DOCS-REQUIRED-MISSING`          |
| No unsafe mutation policy    | Mutation must be plan-backed      | `MUTATION-PLAN-REQUIRED`         |
| Secret redaction policy      | Context excludes secrets          | `CONTEXT-SECRET-RISK`            |
| Placeholder honesty policy   | Planned commands must be honest   | `COMMAND-PLACEHOLDER-MISLEADING` |
| AI optional policy           | Core commands do not require AI   | `AI-REQUIRED-FOR-CORE-COMMAND`   |
| No network by default policy | Core commands do not call network | `NETWORK-CALL-UNEXPECTED`        |
| Release readiness policy     | Release gates must pass           | `RELEASE-GATE-FAILED`            |

---

## 19.13 Risk-to-Control Mapping

| Risk                      | Control                               | Evidence                                  |
| ------------------------- | ------------------------------------- | ----------------------------------------- |
| Command catalog drift     | Catalog/Clap contract tests           | `command_catalog_contract` test           |
| Source-of-truth confusion | Canonical manifest policy             | Manifest fixture tests                    |
| Unsafe mutation           | Plan-backed mutation                  | Dry-run/apply mutation safety tests       |
| Secret leakage            | Context redaction                     | Security fixture tests                    |
| AI overreach              | AI suggestions become plans           | Mocked AI plan tests                      |
| Hosted prematurity        | Local-first ADR and roadmap non-goals | ADR-0003, roadmap docs                    |
| Native tool inconsistency | Adapter boundaries                    | Adapter conformance tests                 |
| Docs drift                | Docs check                            | Docs fixture tests                        |
| Policy false positives    | Policy explain and waivers            | Policy tests, waiver tests                |
| Release regression        | Release readiness checks              | Release evidence report                   |
| Schema breakage           | Versioned schemas                     | Schema validation tests                   |
| Hidden telemetry          | No telemetry by default policy        | Architecture/security review, future test |
| Hidden network calls      | No network by default policy          | Offline tests                             |

---

## 19.14 Artifact-to-Owner Mapping

| Artifact            | Owner Role                  |
| ------------------- | --------------------------- |
| `monad.toml`        | Workspace maintainer        |
| `workspace.toml`    | Compatibility maintainer    |
| `monad.lock`        | Runtime/tooling maintainer  |
| Command catalog     | CLI maintainer              |
| CLI command surface | CLI maintainer              |
| ADRs                | Architecture owner          |
| Work packets        | Delivery owner              |
| Policies            | Governance/security owner   |
| Plans               | Change author               |
| Apply reports       | Change author/reviewer      |
| Context packs       | Developer/AI workflow owner |
| Risk register       | Product/architecture owner  |
| Traceability matrix | Product/architecture owner  |
| Release evidence    | Release owner               |
| Test fixtures       | Test owner                  |
| JSON schemas        | API/schema owner            |
| Documentation index | Documentation owner         |
| Security docs       | Security owner              |
| Operations runbooks | Operations owner            |

In the current solo-developer phase, one person may hold all roles. The roles are still useful because they clarify responsibility boundaries for future contributors.

---

## 19.15 Documentation Traceability

| Documentation File                            | Supports                              | Related Work Packets      |
| --------------------------------------------- | ------------------------------------- | ------------------------- |
| `README.md`                                   | Product orientation, command overview | WP-0000, WP-0001          |
| `docs/index.md`                               | Documentation navigation              | WP-0003                   |
| `docs/product/charter.md`                     | Product goals and principles          | WP-0000                   |
| `docs/product/prd.md`                         | Product requirements                  | WP-0000                   |
| `docs/architecture/overview.md`               | Architecture model                    | WP-0001–WP-0013           |
| `docs/architecture/decision-records/index.md` | ADR governance                        | WP-0003                   |
| `docs/engineering/testing-strategy.md`        | Test model                            | WP-0005–WP-0013           |
| `docs/security/security-model.md`             | Security posture                      | WP-0023, WP-0027, WP-0028 |
| `docs/operations/operational-model.md`        | Diagnostics and operations            | WP-0011                   |
| `docs/roadmap/roadmap.md`                     | Delivery sequence                     | All work packets          |
| `docs/governance/governance-model.md`         | Governance model                      | WP-0016–WP-0019           |
| `docs/reference/manifest.md`                  | Manifest source-of-truth              | WP-0002                   |
| `docs/reference/command-catalog.md`           | Command metadata                      | WP-0004–WP-0006           |
| `docs/reference/findings.md`                  | Findings and output                   | WP-0007                   |
| `docs/reference/exit-codes.md`                | CI and CLI automation                 | WP-0007                   |
| `docs/reference/plan-schema.md`               | Plan/apply mutation                   | WP-0025–WP-0029           |
| `docs/reference/graph-schema.md`              | Lifecycle graph                       | WP-0012, WP-0055          |
| `docs/reference/policy-schema.md`             | Policy model                          | WP-0038–WP-0043           |

---

## 19.16 Release Evidence Traceability

A future release readiness check should collect evidence across the traceability chain.

Minimum release evidence may include:

| Evidence                                                           | Source                 | Related Requirement     |
| ------------------------------------------------------------------ | ---------------------- | ----------------------- |
| Formatting passed                                                  | CI                     | Engineering quality     |
| Workspace check passed                                             | CI                     | Build correctness       |
| Tests passed                                                       | CI                     | Product behavior        |
| Command contract passed                                            | CI                     | Command honesty         |
| Docs updated                                                       | Docs check             | Documentation-as-code   |
| ADRs updated if needed                                             | ADR index              | Architecture governance |
| Work packets updated                                               | Work-packet index      | Delivery governance     |
| Security checks passed                                             | Security CI            | Supply-chain/security   |
| Policy checks passed                                               | Policy report          | Governance              |
| Release notes prepared                                             | Changelog/release docs | Release governance      |
| Plan/apply evidence present if release changed generated artifacts | Apply report           | Mutation safety         |

Future `monad release readiness` should be able to summarize this evidence.

---

## 19.17 Traceability Gap Register

The traceability matrix should expose gaps.

Initial likely gaps:

| Gap ID  | Gap                                                | Impact                         | Suggested Resolution                      |
| ------- | -------------------------------------------------- | ------------------------------ | ----------------------------------------- |
| GAP-001 | Requirements may not yet have stable IDs           | Harder automated traceability  | Add FR/NFR IDs to PRD                     |
| GAP-002 | BDD scenarios may not have IDs yet                 | Harder test mapping            | Add scenario IDs                          |
| GAP-003 | Work packets may not exist as individual files yet | Harder delivery tracking       | Create work-packet docs                   |
| GAP-004 | JSON schemas may not exist yet                     | Harder schema tests            | Add schemas when outputs stabilize        |
| GAP-005 | Policy files may be Markdown only                  | Harder machine validation      | Start human-readable, add structure later |
| GAP-006 | Release evidence not yet formalized                | Harder release readiness       | Add release evidence report later         |
| GAP-007 | Risk register may not be linked                    | Harder governance              | Link risks to requirements/work packets   |
| GAP-008 | Hosted/AI traceability is future-only              | Avoid premature implementation | Keep as future traceability rows          |

Gaps are not failures. They are work to schedule.

---

## 19.18 Traceability Validation Strategy

Traceability validation should mature in phases.

### 19.18.1 Phase 1: Manual Markdown Traceability

Initial state:

* traceability matrix maintained in Markdown,
* work packets manually reference ADRs/tests/docs,
* PRs manually mention related work packets.

### 19.18.2 Phase 2: Docs Check Integration

Future `monad docs check` may verify:

* required traceability file exists,
* required sections exist,
* work-packet IDs are formatted correctly,
* ADR IDs are formatted correctly,
* referenced docs exist.

### 19.18.3 Phase 3: Work-Packet Validation

Future `monad workpacket check` may verify:

* work packets have related requirements,
* related ADRs exist,
* tests are listed,
* docs are listed,
* acceptance criteria exist.

### 19.18.4 Phase 4: Trace Graph

Future `monad trace graph` may emit:

* requirement-to-test graph,
* ADR-to-work-packet graph,
* policy-to-risk graph,
* release-evidence graph.

### 19.18.5 Phase 5: Release Readiness Integration

Future `monad release readiness` may verify:

* no P0 requirement lacks tests,
* no accepted ADR lacks implementation mapping,
* no completed work packet lacks evidence,
* no release-critical policy lacks test evidence.

---

## 19.19 Traceability File Locations

Recommended file locations:

```text id="4g0lbm"
docs/planning/0018-traceability-matrix.md
governance/traceability-matrix.md
```

The planning file may contain the full source-of-truth discussion.

The governance file may contain the operational matrix used by future commands.

Recommended approach:

* Keep the detailed planning section under `docs/planning/`.
* Keep a concise operational matrix under `governance/traceability-matrix.md`.
* Ensure they do not contradict each other.
* Prefer the governance file for future machine validation.

---

## 19.20 Traceability Anti-Patterns

Monad should avoid the following traceability anti-patterns.

### 19.20.1 Traceability Theater

Do not create large matrices that nobody uses.

Every traceability row should support decisions, tests, release readiness, or governance.

### 19.20.2 Unstable IDs

Do not constantly rename requirement IDs, ADR IDs, work-packet IDs, or finding IDs.

Unstable IDs break traceability.

### 19.20.3 Requirements Without Evidence

A requirement without tests, docs, or work-packet mapping is not ready to claim as implemented.

### 19.20.4 Tests Without Requirements

A test with no known requirement may still be useful, but critical tests should be traceable to product behavior or risk.

### 19.20.5 ADRs Without Implementation Path

An accepted ADR should eventually map to work packets and tests.

### 19.20.6 Work Packets Without Acceptance Evidence

A completed work packet should have evidence.

### 19.20.7 Docs Without Ownership

Docs that are not linked to requirements, owners, or validation are likely to drift.

---

## 19.21 Recommended Immediate Implementation Order

Recommended immediate traceability work:

1. Add stable requirement IDs to the PRD.
2. Add stable ADR index and ADR IDs.
3. Add stable work-packet IDs.
4. Add this traceability matrix to the planning docs.
5. Add a concise operational copy to `governance/traceability-matrix.md`.
6. Link work packets to related ADRs.
7. Link work packets to required tests.
8. Link BDD scenarios to requirements.
9. Link policy files to protected requirements.
10. Link risks to controls and evidence.
11. Add traceability checks to future `monad docs check`.
12. Add traceability summary to future `monad release readiness`.

---

## 19.22 Early Non-Goals

Early traceability does not require:

* external requirements management tool,
* hosted traceability dashboard,
* graph database,
* formal compliance suite,
* enterprise GRC integration,
* Jira/Linear synchronization,
* AI-generated traceability,
* automatic impact analysis,
* multi-repo portfolio reporting.

These may become useful later, but early Monad should keep traceability local, Markdown-based, and practical.

---

## 19.23 Open Questions

The following questions should remain open until implementation pressure justifies decisions.

1. Should requirements use `FR-NNN` and `NFR-NNN` IDs in the PRD?

2. Should BDD scenarios receive permanent IDs?

3. Should work packets include frontmatter for machine-readable traceability?

4. Should ADRs include related work-packet IDs directly?

5. Should policies include related requirement IDs?

6. Should tests include requirement IDs in test names, comments, or metadata?

7. Should the traceability matrix live primarily under `governance/` or `docs/`?

8. Should future `monad trace check` be part of `monad docs check` or a separate command?

9. Should release readiness fail if P0 requirements lack tests?

10. Should risk register entries be linked to requirements and policies?

11. Should traceability eventually be exported as JSON?

12. Should lifecycle graph nodes include traceability IDs?

13. Should CI publish a traceability report artifact?

14. Should AI-generated plans be required to cite related requirements, ADRs, and policies?

---

## 19.24 Section Acceptance Criteria

This section is successful if a reader understands that:

1. Traceability connects Monad’s business goals, user needs, requirements, architecture, work packets, tests, docs, policies, risks, and release evidence.
2. Traceability is part of Monad’s governance-grade product model.
3. The traceability matrix should begin as Markdown and become more machine-readable over time.
4. Stable IDs are necessary for requirements, ADRs, work packets, BDD scenarios, policies, findings, risks, and evidence.
5. Requirements should map to architecture components.
6. Requirements should map to tests.
7. ADRs should map to work packets.
8. Work packets should map to evidence.
9. BDD scenarios should map to requirements.
10. Policies should map to protected requirements.
11. Risks should map to controls and evidence.
12. Release readiness should eventually summarize traceability evidence.
13. Traceability gaps should be visible and actionable.
14. Traceability should remain local-first and not require hosted tooling.
15. Traceability should support the lifecycle graph.
16. Traceability should prevent undocumented, untested, or unjustified product claims.

The final traceability rule is:

> Monad should be able to explain not only what a repository contains, but why each important artifact exists, what requirement it serves, what decision shaped it, what work delivered it, what test proves it, and what evidence supports releasing it.
