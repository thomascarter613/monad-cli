# 22. Execution Plan

## 22.1 First 30 Days

Primary objective:

> Stabilize the CLI foundation and command catalog contract.

Build:

* command catalog completeness,
* Clap surface alignment,
* placeholder honesty,
* config subcommands,
* version/list/help stability,
* initial documentation updates.

Quality gates:

```bash id="bya9ub"
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
```

Recommended work packets:

```text id="7i7wfk"
WP-0004 Command Catalog Model
WP-0005 Clap Surface Contract
WP-0006 Placeholder Honesty
WP-0007 CLI Output and Exit Codes
```

## 22.2 First 60 Days

Primary objective:

> Make Monad useful as a read-only repository understanding tool.

Build:

* workspace root detection,
* manifest resolution,
* `monad inspect`,
* `monad check`,
* `monad doctor`,
* initial graph model.

Recommended work packets:

```text id="cllojl"
WP-0008 Workspace Root Detection
WP-0009 Repository Inspection Engine
WP-0010 Baseline Check Engine
WP-0011 Doctor Diagnostics
WP-0012 Lifecycle Graph v0
```

## 22.3 First 90 Days

Primary objective:

> Make docs, governance, and context first-class.

Build:

* `monad docs check`,
* `monad adr list`,
* `monad workpacket list`,
* `monad context handoff`,
* context redaction,
* docs/governance fixture tests.

Recommended work packets:

```text id="ihykzw"
WP-0014 Docs Check
WP-0016 ADR List and Validation
WP-0018 Work Packet List and Validation
WP-0020 Context Model
WP-0021 Handoff Generator
WP-0023 Context Redaction and Safety
```

## 22.4 First 6 Months

Primary objective:

> Add the plan-backed mutation foundation.

Build:

* plan schema,
* plan creation for docs/ADRs/work packets,
* dry-run apply,
* approved apply for low-risk operations,
* apply reports,
* rollback hints,
* policy evaluation for plans.

Recommended work packets:

```text id="8asqkt"
WP-0025 Plan Schema and Domain Model
WP-0026 Plan Creation for Documentation Artifacts
WP-0027 Dry-Run Apply Engine
WP-0028 Apply Engine with Approval
WP-0029 Rollback Hints and Apply Reports
WP-0030 Plan Policy Evaluation
```

## 22.5 First Year

Primary objective:

> Reach stable local-first Monad OS core.

Build:

* safe generators,
* core templates,
* pack model,
* policy engine,
* native tool adapters,
* release/change lifecycle,
* advanced graph exports,
* JSON schemas,
* stronger CI/release process.

Recommended focus:

```text id="jsu70v"
generators after plan/apply
policy after baseline checks
packs after templates
AI after deterministic context
hosted control plane after local v1
```

## 22.6 What to Build First

Build first:

1. command catalog stability,
2. config/source-of-truth behavior,
3. read-only inspect/check/doctor,
4. docs check,
5. context handoff,
6. graph v0,
7. plan schema,
8. dry-run apply.

## 22.7 What to Defer

Defer:

* hosted dashboard,
* plugin marketplace,
* AI provider integrations,
* complex generators,
* graph database,
* multi-cloud hosted deployments,
* enterprise RBAC,
* multi-repo fleet management.

## 22.8 What Not to Build Yet

Do not build yet:

* autonomous AI code mutation,
* direct unsafe file-writing commands,
* SaaS-first backend,
* required database,
* Kubernetes-first runtime,
* full replacement for native task/build tools,
* complex plugin runtime before trust model.

## 22.9 Critical Path

Critical path:

```text id="ird71x"
command catalog
  -> CLI contract
  -> workspace model
  -> inspect/check
  -> docs/context/graph
  -> plan schema
  -> dry-run apply
  -> safe apply
  -> generators
  -> policy gates
```

## 22.10 Parallelizable Work

Parallelizable after CLI foundation:

* docs drafting,
* ADR drafting,
* fixture repo creation,
* output schema design,
* policy rule definitions,
* graph schema design,
* context redaction rules,
* runbooks.

## 22.11 Solo Developer Strategy

For solo development:

* use small work packets,
* avoid fragile shell scripts,
* prefer manual file-save patches when needed,
* keep tests green after every layer,
* stop and stabilize when contracts fail,
* commit after each green layer,
* do not build hosted features early.

---