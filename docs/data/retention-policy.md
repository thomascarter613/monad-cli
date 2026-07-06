# Data Retention Policy

This document defines retention rules for Monad data artifacts.

Monad is local-first. Data retention begins with repository source control and clearly classified generated state.

## Purpose

Retention policy prevents Monad data from becoming unmanaged, stale, misleading, or hidden. It also clarifies which artifacts are durable evidence and which can be regenerated.

## Retention Classes

| Class | Description | Default Handling |
| ----- | ----------- | ---------------- |
| Ephemeral | Temporary files, scratch output, incomplete reports. | Delete when no longer needed. |
| Operational | Local reports, diagnostics, generated context, graph cache. | Retain while useful; rebuild when possible. |
| Release | Evidence supporting a release. | Retain with release records. |
| Audit | Governance records, waivers, decisions, policy evidence. | Retain according to project governance needs. |
| Forensic | Records explaining failures, disputed state, or incidents. | Retain until reviewed and explicitly closed. |
| Permanent | Canonical durable documents and accepted decisions. | Retain indefinitely unless superseded. |

## Artifact Guidance

| Artifact | Class | Notes |
| -------- | ----- | ----- |
| `monad.toml` | Permanent | Canonical Monad intent. |
| `monad.lock` | Operational or Release | Resolved state; may be committed when reproducibility requires it. |
| ADRs | Permanent | Preserve accepted/superseded decisions. |
| Work packets | Audit or Permanent | Preserve implementation planning and traceability. |
| `.monad/cache/` | Ephemeral | Rebuildable generated state. |
| `.monad/graphs/` | Operational | Rebuildable unless exported as evidence. |
| `.monad/context/` | Operational | Regenerate unless preserved as handoff evidence. |
| Plan files | Operational or Audit | Applied plans may become evidence. |
| Apply reports | Audit or Release | Preserve when supporting releases or investigations. |
| Policy findings | Operational or Audit | Preserve when tied to release, waiver, or governance review. |
| Migration records | Audit | Preserve with migration history. |
| Forensic records | Forensic | Preserve chain-of-custody style metadata. |

## Deletion Rules

Before deleting an artifact, confirm:

- it is not canonical source of truth;
- it is not required release evidence;
- it is not tied to an open migration or review;
- it is not referenced by a retention hold;
- it can be regenerated or is intentionally expired.

Generated state can usually be deleted and rebuilt. Durable governance records should be preserved or superseded, not casually removed.

## Promotion Rules

Generated artifacts may be promoted to durable evidence when they support:

- release readiness;
- migration replay;
- policy waiver review;
- failed apply analysis;
- incident review;
- long-term traceability.

Promotion should record reason, date, owner, and related ADR/work packet where practical.

## Review Cadence

Retention classes should be reviewed when:

- schema versions change;
- migration model changes;
- release evidence model changes;
- hosted projection is introduced;
- new generated state directories are added;
- policy or waiver governance changes.

## Maintenance Notes

Keep this policy aligned with archival process, migration governance, and disaster recovery planning.
