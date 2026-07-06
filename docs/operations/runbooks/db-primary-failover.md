# Database Primary Failover Runbook

This runbook defines a future-state operational pattern for database primary failover.

Monad core does not require an external database. This runbook applies only if future hosted projection, registry, telemetry, or control-plane services introduce database-backed infrastructure.

## Scope

Applies to future hosted or service-backed components, not local CLI core behavior.

## Symptoms

- primary database unavailable;
- writes failing or timing out;
- replication lag increasing;
- hosted dashboard unavailable;
- sync/export jobs failing;
- release evidence ingestion stalled.

## Immediate Triage

1. Confirm the affected service and database cluster.
2. Verify whether local CLI workflows remain unaffected.
3. Check replication health and latest recoverable point.
4. Freeze nonessential writes if needed.
5. Identify the current primary and candidate replica.
6. Capture incident evidence before destructive actions.

## Failover Steps

1. Announce incident scope and owner.
2. Confirm backup and replica status.
3. Promote the selected replica according to provider/runbook procedure.
4. Update connection routing or service configuration.
5. Restart or recycle affected services if required.
6. Verify reads and writes.
7. Confirm hosted projection consistency.
8. Record timeline, data loss estimate, and follow-up tasks.

## Safety Rules

- Do not modify local repository source-of-truth artifacts as part of hosted failover.
- Preserve incident evidence.
- Record RPO/RTO impact.
- Avoid split-brain writes.
- Prefer explicit service degradation over silent data inconsistency.

## Post-Incident Review

Document:

- root cause;
- detection time;
- failover time;
- data loss, if any;
- user impact;
- remediation;
- evidence retained;
- test or automation gaps.

## Maintenance Notes

Update this runbook when hosted projection infrastructure becomes concrete. Until then, treat it as future operational guidance.
