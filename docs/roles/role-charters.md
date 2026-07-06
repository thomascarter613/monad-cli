# Role Charters

This document defines core Monad role charters.

A role charter explains a role's purpose, authority, responsibilities, and limits.

## Human Roles

| Role | Purpose | Responsibilities |
| ---- | ------- | ---------------- |
| Maintainer | Preserve project direction and implementation quality. | Review code, docs, ADRs, work packets, risks, and releases. |
| Architecture Steward | Preserve architectural coherence. | Maintain ADRs, blueprints, invariants, crate boundaries, and traceability. |
| Documentation Steward | Preserve repository knowledge quality. | Maintain docs indexes, style, drift detection, and documentation audits. |
| Security Steward | Preserve security and privacy posture. | Review threat models, redaction, no-telemetry, plugin/pack trust, and unsafe mutation. |
| Release Steward | Preserve release readiness evidence. | Coordinate release checks, evidence, notes, and risk review. |
| Risk Owner | Track a specific risk. | Maintain risk state, controls, mitigations, and evidence. |
| Waiver Approver | Approve bounded exceptions. | Ensure waivers have scope, reason, owner, and review/expiration. |

## Automation Roles

| Role | Purpose | Limits |
| ---- | ------- | ------ |
| CI | Run checks and report results. | Must not silently change source files. |
| Policy Checker | Evaluate governance rules. | Reports findings; does not override humans by default. |
| Docs Checker | Validate documentation invariants. | Reports drift; does not rewrite accepted decisions silently. |
| Release Evidence Generator | Produce release evidence. | Generated output must identify source and schema where practical. |

## Runtime Roles

| Role | Purpose | Limits |
| ---- | ------- | ------ |
| Monad CLI | Local runtime for repository governance. | Must preserve local-first, no-telemetry, and plan-backed mutation doctrine. |
| Native Tool Adapter | Coordinate ecosystem tools. | Native tools own execution; Monad owns intent and governance. |
| AI Provider Adapter | Optional AI assistance boundary. | AI output is non-authoritative and must not bypass plans/policy. |
| Hosted Projection Adapter | Optional future sync/export layer. | Hosted state is projection unless future ADR says otherwise. |

## Charter Rules

- Roles should be explicit when they approve, mutate, validate, or publish evidence.
- Automation authority should be narrow and testable.
- AI assistance must remain optional and reviewable.
- Human stewardship remains responsible for accepted decisions and release evidence.

## Maintenance Notes

Update role charters when governance workflows, automation authority, AI behavior, hosted projection, or release approval changes.
