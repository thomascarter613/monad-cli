# Dashboards

This document defines dashboard guidance for Monad operations.

Monad core is local-first and has no telemetry by default. Dashboards are therefore optional views over local evidence, CI output, release evidence, or future hosted projection data.

## Dashboard Classes

| Dashboard | Purpose |
| --------- | ------- |
| Local evidence | Summarize local reports and generated artifacts. |
| CI quality | Show check/test/docs/policy/release readiness status. |
| Release readiness | Show evidence completeness and gate status. |
| Governance | Show ADR/work-packet/policy/risk traceability. |
| Hosted projection | Future optional shared view across repositories. |

## Required Principles

- Dashboards do not replace repository source of truth.
- Local reports and schemas should feed dashboards where practical.
- Hosted dashboards require explicit sync/export.
- Telemetry remains opt-in.
- Dashboard data must preserve source commit/ref and schema version.

## Candidate Panels

| Panel | Source |
| ----- | ------ |
| Command outcomes | machine-readable command reports. |
| Policy findings | policy report output. |
| Docs health | docs check output. |
| Graph health | graph check/export output. |
| Context safety | context manifest and redaction report. |
| Release evidence | release readiness report. |
| Drift status | docs/infra/data drift checks. |
| Risk status | risk register and traceability matrix. |

## Maintenance Notes

Add concrete dashboard links only when dashboards exist. Until then, this file defines dashboard design constraints and data-source expectations.
