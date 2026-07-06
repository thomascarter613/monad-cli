# Compliance Data Retention Policy

This document defines compliance-facing retention guidance for Monad governance artifacts.

It complements `docs/data/retention-policy.md`, which defines the general data lifecycle model. This file focuses on compliance evidence, auditability, privacy review, and release governance.

## Purpose

The compliance retention policy ensures that Monad keeps durable evidence long enough to support governance, while avoiding unmanaged accumulation of generated state.

It defines retention expectations for:

- ADRs;
- work packets;
- policy findings;
- waivers;
- release evidence;
- migration records;
- archival manifests;
- forensic records;
- context manifests;
- graph exports;
- generated reports.

## Retention Classes

| Class | Examples | Default Handling |
| ----- | -------- | ---------------- |
| Canonical governance | ADRs, accepted policies, work packet records | Retain indefinitely or supersede explicitly. |
| Audit evidence | release evidence, waiver approvals, applied plan reports | Retain with release or review record. |
| Operational reports | local diagnostics, generated graph/context reports | Retain while useful; regenerate when possible. |
| Forensic evidence | incident records, failed apply records, disputed state records | Retain until review is closed and hold is released. |
| Ephemeral generated state | cache, temporary context, intermediate reports | Delete or rebuild as needed. |

## Compliance Rules

- Do not treat `.monad/` cache as canonical evidence unless explicitly promoted.
- Do not delete accepted ADRs or work packet history; supersede instead.
- Preserve release evidence that supports published releases.
- Preserve waiver records while the waiver is active and through any review window.
- Preserve migration history even when generated migration output is rebuilt.
- Preserve forensic records until explicitly closed.
- Keep retention decisions traceable to a class and owner where practical.

## Data Minimization

Compliance evidence should include enough information to prove governance state without unnecessarily retaining sensitive content.

Prefer:

- checksums over full payloads when enough;
- summaries over raw context dumps when enough;
- local path references over copied file contents when enough;
- redacted context manifests over unredacted bundles.

## Deletion and Expiration

Before deleting compliance-relevant data, confirm:

- it is not canonical governance documentation;
- it is not release evidence;
- it is not under review, hold, or active waiver;
- it is not required for migration replay;
- it is not referenced by traceability matrix or risk register;
- it can be regenerated or is intentionally expired.

## Relationship to Hosted Projection

If a hosted control plane is introduced, local retention remains authoritative for repository evidence unless a future ADR states otherwise.

Hosted copies should be treated as projections and governed by explicit sync and retention rules.

## Maintenance Notes

Update this policy when retention classes, release evidence, migration records, or hosted projection behavior changes.
