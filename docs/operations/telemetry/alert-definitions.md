# Alert Definitions

This document defines alert concepts for Monad operations.

Monad core has no telemetry by default. These alert definitions apply to local diagnostics, CI/release gates, generated reports, and future opt-in hosted projection telemetry.

## Alert Principles

- Local CLI behavior must not require alerting infrastructure.
- Alerts should be actionable.
- Alerts should distinguish local findings from hosted telemetry.
- Telemetry must be opt-in if introduced.
- Release-blocking alerts should map to evidence and traceability.

## Severity Levels

| Severity | Meaning | Response |
| -------- | ------- | -------- |
| Info | Informational signal. | Review when convenient. |
| Warning | Drift or degradation risk. | Triage before release. |
| Error | Expected behavior failed. | Fix or waive before release. |
| Critical | Safety, data, or availability risk. | Immediate triage. |

## Candidate Alerts

| Alert | Trigger |
| ----- | ------- |
| DocsDriftDetected | Documentation invariant or link check fails. |
| PolicyGateFailed | Policy check blocks readiness. |
| PlanApplyBlocked | Apply failed due to unsafe or stale plan. |
| ContextRedactionRisk | Context generation detects sensitive data risk. |
| GraphCacheStale | Graph cache is stale or incompatible. |
| ReleaseEvidenceMissing | Required release evidence is unavailable. |
| UnexpectedNetworkAccess | Core local workflow attempts unexpected network access. |
| UnexpectedTelemetry | Telemetry path is detected without opt-in. |
| HostedProjectionUnavailable | Future hosted projection is unavailable. |

## Routing Guidance

- Local/CI alerts should appear as command output and exit codes.
- Release alerts should become release evidence findings.
- Hosted alerts, if implemented, should route through explicit configured channels.

## Maintenance Notes

Keep alert definitions aligned with metrics dictionary, dashboards, policy findings, and release readiness checks.
