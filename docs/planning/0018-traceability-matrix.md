# 19. Traceability Matrix

## 19.1 Traceability Strategy

Monad should connect business goals, user needs, requirements, architecture, tests, work packets, and docs.

The matrix below is an initial traceability baseline.

## 19.2 Core Traceability Matrix

| Business Goal              | User Need                      | Requirement             | Architecture Component              | Test Evidence             | Work Packet             | Docs                                     |
| -------------------------- | ------------------------------ | ----------------------- | ----------------------------------- | ------------------------- | ----------------------- | ---------------------------------------- |
| Make repos understandable  | Inspect repo structure         | `monad inspect`         | `monad-inspect`                     | fixture integration tests | WP-0009                 | `docs/user-guide/commands.md`            |
| Make repos governable      | Validate invariants            | `monad check`           | `monad-policy`, `monad-config`      | check tests               | WP-0010                 | `docs/engineering/testing-strategy.md`   |
| Preserve trust             | Command honesty                | command metadata        | command catalog                     | catalog contract tests    | WP-0004/WP-0006         | `docs/engineering/command-catalog.md`    |
| Avoid unsafe changes       | Plan before mutation           | plan/apply              | `monad-plans`                       | dry-run/apply tests       | WP-0025-WP-0029         | `docs/reference/plan-schema.md`          |
| Support AI safely          | Generate context               | context handoff         | `monad-context`                     | redaction tests           | WP-0020-WP-0024         | `docs/user-guide/context-handoff.md`     |
| Preserve local-first value | No required backend            | local file-backed state | `monad-config`, filesystem adapters | offline tests             | WP-0002                 | `docs/architecture/overview.md`          |
| Avoid vendor lock-in       | Cloud/database agnostic design | adapter boundaries      | ports/adapters                      | adapter conformance tests | WP-0044-WP-0049         | `docs/architecture/data-architecture.md` |
| Improve governance         | ADR/work-packet lifecycle      | ADR/workpacket commands | governance context                  | docs fixture tests        | WP-0016-WP-0019         | `docs/governance/governance-model.md`    |
| Enable graph moat          | Lifecycle graph                | graph outputs           | `monad-graph`                       | graph invariant tests     | WP-0012/WP-0055-WP-0060 | `docs/reference/graph-schema.md`         |
| Enable CI use              | Machine-readable checks        | JSON output/exit codes  | output layer                        | schema tests              | WP-0007                 | `docs/engineering/output-formats.md`     |

## 19.3 Requirement-to-Test Mapping

| Requirement                                    | Tests                        |
| ---------------------------------------------- | ---------------------------- |
| `monad version` reports version                | CLI smoke test               |
| `monad list` lists commands                    | CLI smoke + snapshot         |
| Catalog matches Clap                           | command catalog contract     |
| `monad.toml` is canonical                      | manifest unit tests          |
| `workspace.toml` mirror conflicts reported     | fixture integration test     |
| `monad inspect` is read-only                   | mutation safety test         |
| `monad check` returns nonzero in CI on failure | CLI integration test         |
| `monad graph` emits valid graph                | graph invariant + snapshot   |
| Context excludes secrets                       | security fixture test        |
| Dry-run does not modify files                  | dry-run mutation test        |
| Apply only executes planned ops                | apply contract test          |
| Policy explain returns remediation             | policy unit/integration test |

## 19.4 Artifact-to-Owner Mapping

| Artifact         | Owner Role                  |
| ---------------- | --------------------------- |
| `monad.toml`     | workspace maintainer        |
| command catalog  | CLI maintainer              |
| ADRs             | architecture owner          |
| work packets     | delivery owner              |
| policies         | governance/security owner   |
| plans            | change author               |
| apply reports    | change author/reviewer      |
| context packs    | developer/AI workflow owner |
| risk register    | product/architecture owner  |
| release evidence | release owner               |
