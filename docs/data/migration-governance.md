# Migration Governance

This document defines governance rules for Monad data and schema migrations.

Migrations may affect canonical manifests, lockfiles, generated state, schema versions, graph outputs, context artifacts, plan formats, policy findings, and release evidence.

## Purpose

Migration governance ensures that migrations are:

- intentional;
- versioned;
- reviewable;
- reversible or replayable where practical;
- recorded in migration history;
- tested against fixtures;
- safe for local-first workflows.

## Migration Types

| Type | Description |
| ---- | ----------- |
| Manifest migration | Changes `monad.toml` schema or semantics. |
| Lock migration | Changes `monad.lock` schema or resolution model. |
| Generated-state migration | Changes `.monad/` cache/report/context/graph structure. |
| Plan schema migration | Changes plan, diff, dry-run, or apply report format. |
| Policy schema migration | Changes findings, rules, waivers, or severities. |
| Graph schema migration | Changes node/edge schema or graph output shape. |
| Context schema migration | Changes context pack, handoff, or manifest format. |
| Release evidence migration | Changes release report or evidence model. |

## Governance Rules

A migration should define:

- migration ID;
- migration title;
- source schema version;
- target schema version;
- affected artifacts;
- related ADRs;
- related work packets;
- preconditions;
- migration steps;
- validation steps;
- rollback or replay notes;
- owner;
- status.

## Status Values

| Status | Meaning |
| ------ | ------- |
| Draft | Not ready for execution. |
| Proposed | Ready for review. |
| Approved | Accepted for implementation. |
| Applied | Executed successfully. |
| Failed | Attempted and failed. |
| Superseded | Replaced by a later migration. |
| Reverted | Rolled back or neutralized. |

## Safety Rules

- Migrations that write files should be plan-backed where practical.
- Migration plans should show affected paths and schemas.
- Dry-run should be supported before destructive changes.
- Canonical source artifacts must not be silently overwritten.
- Generated state should be rebuilt instead of migrated when cheaper and safer.
- Stale migration state must be detected before replay.

## Approval Expectations

A migration should be reviewed when it affects:

- canonical manifest semantics;
- machine-readable output schemas;
- plan/apply behavior;
- policy findings or waivers;
- release evidence;
- archival or forensic records;
- hosted projection compatibility.

## Testing Expectations

Migration tests should cover:

- old-to-new schema conversion;
- idempotency where required;
- dry-run output;
- failure handling;
- replay behavior;
- generated-state rebuild alternatives;
- fixture repositories with old schema versions.

## Related Files

- `migration-history.md`
- `migration-replay.md`
- `canonical-schema.json`
- `archival-schema.json`
- `forensic-schema.json`

## Maintenance Notes

Every material migration should update `migration-history.md`. Replayable migrations should include enough information for future verification.
