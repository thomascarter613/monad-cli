# Data Governance Index

This directory contains Monad's data governance documentation and schemas.

Monad is local-first and repository-centered. Most durable intent should live in source-controlled files such as `monad.toml`, ADRs, work packets, policies, docs, and release evidence. Generated state, caches, context bundles, reports, and migration artifacts must be clearly classified so they do not become hidden sources of truth.

## Purpose

The `docs/data/` area defines how Monad handles data lifecycle concerns such as:

- canonical records;
- archival records;
- forensic records;
- migration governance;
- migration history;
- migration replay;
- retention and deletion;
- generated state versus durable evidence;
- schema versioning.

## Files

| File | Purpose |
| ---- | ------- |
| `canonical-schema.json` | JSON Schema for canonical Monad data/evidence records. |
| `archival-schema.json` | JSON Schema for archival package manifests. |
| `forensic-schema.json` | JSON Schema for forensic evidence records. |
| `archival-process.md` | Process for creating, validating, storing, and restoring archives. |
| `migration-governance.md` | Governance rules for data/schema migrations. |
| `migration-history.md` | Human-readable migration history register. |
| `migration-replay.md` | Replay model for rebuilding or validating migration state. |
| `retention-policy.md` | Retention classes and deletion rules for data artifacts. |

## Data Classification

| Class | Description | Source of Truth |
| ----- | ----------- | --------------- |
| Canonical | Durable authored or approved state. | Repository files such as `monad.toml`, ADRs, work packets, policies, and committed evidence. |
| Resolved | Deterministic state derived from canonical sources. | Rebuildable from canonical sources unless explicitly committed. |
| Generated | Local/cache/report/context/plan output. | Not canonical unless promoted. |
| Archival | Frozen snapshot intended for later reference or restore. | Archive manifest plus source references. |
| Forensic | Evidence captured to explain an incident, failure, migration, or disputed state. | Immutable evidence package or committed record. |

## Related ADRs

- ADR-0003: Local-First Core
- ADR-0005: `monad.toml` Is the Canonical Manifest
- ADR-0006: Plan-Backed Mutation
- ADR-0008: Lifecycle Graph as Core Model
- ADR-0013: Versioned Machine-Readable Output Schemas
- ADR-0015: Local Graph Cache Is Rebuildable Generated State
- ADR-0018: Hosted Control Plane Is Optional Projection Layer
- ADR-0019: No Telemetry by Default

## Source-of-Truth Rules

- `monad.toml` is canonical Monad intent.
- `monad.lock` is resolved state, not author intent.
- `.monad/` is generated/local/cache/report/context/plan state unless a subpath is explicitly promoted.
- ADRs and work packets are durable governance records.
- Release evidence should be committed or exported deliberately when authoritative.
- Hosted records are optional projections unless a future ADR states otherwise.

## Schema Rules

Schemas in this directory should:

- use JSON Schema Draft 2020-12 unless replaced by a later ADR;
- include stable `$id` values;
- include explicit `schema_version` fields in records;
- avoid unversioned machine-readable contracts;
- remain local-first and repository inspectable;
- be updated through review when compatibility changes.

## Maintenance Notes

Update this index whenever data governance files or schemas are added, renamed, deprecated, or superseded. Keep schema changes aligned with migration governance and migration history.
