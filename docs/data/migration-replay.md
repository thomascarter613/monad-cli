# Migration Replay

This document defines how Monad migrations should be replayed or verified.

Migration replay is the ability to reconstruct, validate, or re-run migration effects from documented inputs, schema versions, and repository state.

## Purpose

Replay supports:

- disaster recovery;
- migration verification;
- schema compatibility testing;
- release evidence;
- forensic review;
- regression testing;
- confidence in generated-state rebuilds.

## Replay Principles

- Replay should be deterministic where practical.
- Replay should prefer source-of-truth artifacts over generated cache.
- Replay should not mutate files unless explicitly run through a plan/apply flow.
- Replay should report missing inputs and stale state.
- Replay should be able to validate outcomes without rewriting files.
- Replay evidence should be machine-readable once schema contracts stabilize.

## Replay Inputs

A replay may require:

- migration ID;
- source schema version;
- target schema version;
- repository commit or source snapshot;
- canonical manifest;
- relevant lockfile;
- migration plan;
- archive manifest;
- expected checksums;
- fixture repository;
- generated-state rebuild instructions.

## Replay Modes

| Mode | Description |
| ---- | ----------- |
| Validate-only | Check whether current state matches expected migrated state. |
| Dry-run replay | Simulate migration actions without writing files. |
| Rebuild generated state | Delete and regenerate derived state from canonical sources. |
| Apply replay | Re-run a plan-backed migration with explicit approval. |
| Evidence replay | Reconstruct reports needed to support release or review evidence. |

## Replay Workflow

1. Identify migration ID from `migration-history.md`.
2. Gather source and target schema information.
3. Resolve required repository state or archive manifest.
4. Validate preconditions.
5. Run validate-only or dry-run replay first.
6. Review diff, findings, and warnings.
7. Apply only when explicit approval is provided.
8. Generate replay report.
9. Update migration history if replay changes status or findings.

## Generated State Replay

Generated state should usually be rebuilt rather than migrated.

Examples:

- `.monad/cache/`
- `.monad/graphs/`
- `.monad/context/`
- derived reports

Rebuild replay should verify that regenerated output is compatible with current schemas or clearly report drift.

## Failure Handling

Replay failures should report:

- migration ID;
- failed precondition;
- missing input;
- incompatible schema version;
- affected paths;
- partial output, if any;
- recommended remediation;
- whether retry is safe.

## Testing Expectations

Replay tests should cover:

- replay from fixture repository state;
- validation-only mode;
- dry-run replay;
- stale migration detection;
- missing archive input;
- generated-state rebuild;
- incompatible schema handling;
- replay report generation.

## Maintenance Notes

Keep replay guidance aligned with migration governance, migration history, archival process, disaster recovery, and plan/apply behavior.
