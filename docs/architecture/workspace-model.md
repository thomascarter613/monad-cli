# Workspace Model

This document defines Monad's workspace model.

The workspace model is the domain model Monad uses to understand a repository as a governed lifecycle system rather than a loose file tree.

## Related ADRs

- ADR-0002: Coordinate Native Tools Instead of Replacing Them
- ADR-0003: Local-First Core
- ADR-0005: `monad.toml` Is the Canonical Manifest
- ADR-0008: Lifecycle Graph as Core Model
- ADR-0013: Versioned Machine-Readable Output Schemas
- ADR-0015: Local Graph Cache Is Rebuildable Generated State

## Source-of-Truth Model

Monad distinguishes source, resolved state, generated state, and native tool facts.

| Artifact | Role |
| -------- | ---- |
| `monad.toml` | Canonical Monad manifest and author intent. |
| `workspace.toml` | Compatibility mirror only, if present. |
| `monad.lock` | Resolved state, not author intent. |
| `.monad/` | Generated/local/cache/report/context/plan state. |
| Native manifests | Ecosystem-owned facts or generated/synchronized outputs. |
| Docs/ADRs/work packets | Versioned governance and documentation source artifacts. |

If `monad.toml` and `workspace.toml` conflict, `monad.toml` wins.

## Workspace Root

A Monad workspace root is the repository directory that contains the canonical Monad manifest or another documented root marker.

Root detection should eventually consider:

- `monad.toml`;
- compatibility `workspace.toml`;
- VCS root;
- native workspace files;
- `.monad/` state;
- explicit `--root` overrides.

Root detection must be deterministic and explainable.

## Workspace Units

A workspace is composed of units.

Candidate unit kinds:

```text
app
service
package
lib
tool
config
policy
infra
docs
contract
test
agent
```

## Unit Identity

Recommended unit ID format:

```text
<kind>:<name>
```

Examples:

```text
app:web
service:api
package:ui
lib:core
tool:cli
docs:architecture
policy:security
```

Unit IDs should be stable enough for graph nodes, policy findings, context packs, and plan impact reports.

## Native Manifests

Native files such as `package.json`, `turbo.json`, `moon.yml`, `biome.json`, `Cargo.toml`, `go.work`, `pyproject.toml`, and `.github/workflows/*` remain native-tool-owned facts unless Monad explicitly generates or synchronizes them through a plan.

Monad should inspect native manifests, classify them, and connect them to workspace units without pretending to replace their native semantics.

## Generated State

Generated state may include:

```text
.monad/cache/
.monad/graphs/
.monad/context/
.monad/plans/
.monad/reports/
.monad/tmp/
```

Generated state should be rebuildable unless intentionally promoted to release evidence or committed documentation.

## Graph Relationship

The workspace model feeds the lifecycle graph.

Workspace units become graph nodes. Relationships such as `contains`, `depends_on`, `documents`, `configured_by`, `governed_by`, and `affected_by` connect units to artifacts, decisions, policies, plans, and docs.

## Policy Relationship

Policy checks may use workspace units to scope findings.

A policy finding should eventually be able to reference:

- workspace ID;
- unit ID;
- affected path;
- related manifest;
- related ADR/work packet;
- related graph node.

## Plan Relationship

Plans should identify affected workspace units where practical.

This enables review, impact analysis, release evidence, and safer mutation.

## Testing Expectations

Workspace model tests should cover:

- root detection;
- canonical manifest precedence;
- mirror-only compatibility;
- native manifest discovery;
- unit ID parsing;
- generated state classification;
- graph node emission;
- policy finding scope;
- plan impact references.

## Maintenance Notes

Keep this document synchronized with manifest schema, graph schema, policy findings, context artifacts, and plan/apply docs as implementation matures.
