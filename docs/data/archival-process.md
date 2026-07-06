# Archival Process

This document defines how Monad data and evidence artifacts are archived.

Archival is the process of freezing selected repository, generated, report, migration, release, or review artifacts so they can be inspected, restored, or replayed later.

## Purpose

The archival process ensures important data artifacts are:

- intentionally selected;
- classified;
- described by a manifest;
- checksummed where practical;
- stored with retention expectations;
- validated before reliance;
- restorable or explainable later.

## Related Files

- `archival-schema.json`
- `canonical-schema.json`
- `forensic-schema.json`
- `retention-policy.md`
- `migration-governance.md`
- `migration-history.md`
- `migration-replay.md`

## Archive Types

| Archive Type | Description |
| ------------ | ----------- |
| Release evidence | Snapshot of evidence supporting a release. |
| Migration snapshot | State captured before or after a migration. |
| Incident snapshot | Data captured during a failure or disputed state. |
| Context snapshot | Handoff/context bundle preserved for continuity. |
| Graph snapshot | Lifecycle graph output preserved for review. |
| Policy snapshot | Policy findings and waivers preserved for audit. |
| Repository snapshot | Selected repository state captured for recovery. |

## Archive Lifecycle

1. **Identify:** decide which artifacts need archival.
2. **Classify:** assign archive type and retention class.
3. **Collect:** gather source files, reports, checksums, and metadata.
4. **Manifest:** create a manifest using `archival-schema.json`.
5. **Validate:** verify required files, checksums, and metadata.
6. **Store:** commit, export, or reference according to retention policy.
7. **Review:** ensure reason and ownership are clear.
8. **Restore or replay:** use archive metadata when recovery or migration replay is needed.
9. **Expire:** delete or supersede when retention expires and no review hold applies.

## Required Metadata

Every archive should record:

- archive ID;
- archive type;
- reason;
- created date/time;
- creator;
- source commit or source range where available;
- retention class;
- retain-until date where applicable;
- included paths;
- checksums where practical;
- validation status.

## Storage Rules

- Source-controlled archives should be small and reviewable.
- Large archives should be stored externally only through a documented reference.
- External archive references should include checksum and retrieval notes.
- Generated caches should not be archived unless needed as evidence.
- Canonical source files should be recoverable from Git where possible.
- Review-sensitive archives should preserve custody and access notes.

## Validation Rules

Before relying on an archive:

- validate the manifest against `archival-schema.json`;
- confirm included paths exist or external references are documented;
- verify checksums where available;
- confirm retention class and owner;
- confirm whether the archive is ordinary evidence or under review hold.

## Restore Guidance

Restoring from an archive should be explicit and reviewable.

If restore changes repository files, it should be plan-backed where practical. Restores should not silently overwrite current source-of-truth artifacts.

## Maintenance Notes

Keep this process aligned with retention policy, migration replay, and future release evidence workflows.
