# SOC 2 Mapping

This document maps Monad governance artifacts to SOC 2-style control themes.

It is not a formal audit report. It is an internal readiness map that helps the project organize evidence, controls, and gaps around common trust-service themes.

## Purpose

The SOC 2 mapping helps Monad explain:

- which controls exist;
- which docs or ADRs define the control;
- which tests or reports provide evidence;
- which gaps remain;
- which work packets should implement missing evidence.

## Control Theme Mapping

| Theme | Monad Control Surface | Evidence Candidates |
| ----- | --------------------- | ------------------- |
| Security | plan-backed mutation, filesystem safety, policy checks, plugin trust boundary | ADRs, tests, policy reports, threat models |
| Availability | disaster recovery plan, rebuildable generated state, local-first operation | DR docs, graph/cache rebuild tests, release evidence |
| Processing integrity | command metadata, exit codes, schema validation, plan/apply reports | command contract tests, schema tests, apply reports |
| Confidentiality | no telemetry by default, context redaction, explicit AI/network access | redaction tests, no-network tests, privacy lineage docs |
| Privacy | data lineage, retention policy, archive manifests, hosted projection rules | lineage docs, retention records, deletion/review logs |

## Core Controls

| Control | Description | Evidence |
| ------- | ----------- | -------- |
| GOV-ADR-001 | Architecture decisions are recorded and indexed. | `docs/architecture/adrs/` |
| GOV-DOC-001 | Documentation is versioned and governed. | docs governance files, docs checks |
| GOV-TRACE-001 | Requirements trace to ADRs, work packets, tests, policies, risks, and evidence. | `docs/governance/traceability-matrix.md` |
| SEC-MUT-001 | Significant mutation is plan-backed and reviewable. | ADR-0006, plan/apply model, tests |
| SEC-CTX-001 | Context generation excludes secrets and reports limitations. | context architecture, redaction tests |
| SEC-TEL-001 | Telemetry is disabled by default. | ADR-0019, no-network/no-telemetry checks |
| REL-DR-001 | Generated state can be rebuilt from canonical sources. | disaster recovery plan, graph/cache docs |
| REL-SCHEMA-001 | Machine-readable outputs use versioned schemas when stable. | ADR-0013, schema files, fixture tests |

## Evidence Classes

Evidence may include:

- accepted ADRs;
- work packet completion records;
- policy reports;
- BDD scenarios;
- test results;
- release evidence;
- threat models;
- archival manifests;
- migration history;
- apply reports;
- context manifests.

## Gap Register

| Gap | Status | Expected Follow-Up |
| --- | ------ | ------------------ |
| Formal control IDs are not yet machine-validated. | Open | Define control registry schema. |
| Evidence collection is not yet automated. | Open | Add release evidence generator. |
| Policy findings are not yet fully implemented. | Open | Implement policy check/report model. |
| Hosted projection controls are future-state. | Open | Revisit when hosted sync exists. |

## Maintenance Notes

Update this mapping when controls, evidence formats, release gates, or hosted projection behavior changes. Formal compliance review should supersede this internal readiness map where applicable.
