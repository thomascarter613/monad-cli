# Governance Safety

This document defines safety expectations for Monad governance workflows.

Governance safety means the repository can make decisions, enforce policies, record exceptions, and publish evidence without misleading users or weakening trust.

## Safety Goals

Governance workflows should prevent:

- undocumented authority;
- stale decisions;
- fake success from placeholder commands;
- unapproved waivers;
- silent policy bypass;
- release evidence without supporting checks;
- generated docs replacing authored source truth;
- hosted projection replacing local repository truth.

## Governance Safety Rules

| Rule | Description |
| ---- | ----------- |
| GOV-SAFE-001 | Accepted ADRs must be superseded explicitly, not silently rewritten. |
| GOV-SAFE-002 | Waivers must have reason, owner, scope, and review/expiration where practical. |
| GOV-SAFE-003 | Policy failures must be visible and explainable. |
| GOV-SAFE-004 | Release evidence must distinguish passed, failed, skipped, and planned checks. |
| GOV-SAFE-005 | Generated state must be marked as generated. |
| GOV-SAFE-006 | Planned behavior must not be represented as implemented behavior. |
| GOV-SAFE-007 | AI-generated governance text must be reviewed before becoming source. |

## Safety Review Questions

- What is the source of truth?
- Who has authority to approve this change?
- Which policy or ADR applies?
- Is there a waiver?
- Is the evidence generated or authoritative?
- Is any behavior planned but not implemented?
- Could this mislead a future maintainer or AI assistant?

## Maintenance Notes

Keep this document aligned with role authority boundaries, documentation governance, policy-as-code, and the traceability matrix.
