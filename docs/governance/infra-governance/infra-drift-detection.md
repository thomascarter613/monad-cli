# Infrastructure Drift Detection

This document defines how Monad should detect and respond to infrastructure drift.

Infrastructure drift is any mismatch between declared environment/provisioning intent and actual runtime, CI, generated, or hosted state.

## Drift Types

| Drift Type | Description |
| ---------- | ----------- |
| Tool drift | Required tool version differs from expected version. |
| CI drift | Workflow behavior differs from documented gates. |
| Environment drift | Local/CI/release environment no longer matches contract. |
| Secret drift | Secrets appear where they should not, or required secrets are undocumented. |
| Generated state drift | Cache/report/context/graph state is stale. |
| Hosted projection drift | Hosted view no longer matches local evidence. |
| Provisioning drift | Provisioned resources differ from declared intent. |

## Detection Sources

Potential detection sources:

- environment contracts;
- CI workflow files;
- tool version declarations;
- policy reports;
- generated state metadata;
- release evidence;
- hosted sync/export reports when hosted features exist.

## Detection Workflow

1. Identify declared intent.
2. Inspect actual state.
3. Classify drift type and severity.
4. Determine source of truth.
5. Generate a remediation plan when mutation is needed.
6. Review and apply safely.
7. Add invariant, test, or policy to prevent recurrence.

## Severity Model

| Severity | Meaning |
| -------- | ------- |
| Info | Drift exists but does not affect correctness. |
| Warning | Drift may affect reproducibility or confidence. |
| Error | Drift breaks documented behavior or checks. |
| Blocking | Drift invalidates release readiness or safety guarantees. |

## Expected Commands

```bash
monad doctor
monad check
monad policy check
monad release check
```

Future dedicated infra drift commands may be added later.

## Maintenance Notes

Keep drift detection aligned with infra invariants, environment contracts, provisioning governance, and release evidence.
