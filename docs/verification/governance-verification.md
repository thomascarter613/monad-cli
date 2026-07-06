# Governance Verification

This document defines how Monad verifies governance controls.

Governance verification checks whether decisions, policies, roles, risks, waivers, documentation, and release evidence are connected and trustworthy.

## Purpose

Governance verification should prove or support claims such as:

- ADRs are indexed and statused;
- work packets are traceable;
- documentation invariants hold;
- waivers are explicit;
- risks have controls;
- release evidence references real checks;
- policy findings are explainable;
- generated docs have lineage.

## Verification Sources

| Source | Evidence |
| ------ | -------- |
| ADR index | decision coverage and status. |
| Traceability matrix | requirement-to-evidence mapping. |
| Risk register | risk state, controls, and mitigation evidence. |
| Docs audit | documentation presence and drift findings. |
| Policy report | findings, severities, waivers, gates. |
| Release evidence | readiness proof and check results. |
| BDD index | behavior scenario registry. |

## Verification Checks

- every accepted ADR is indexed;
- every critical requirement has related evidence;
- every release evidence claim maps to a command, test, or report;
- every waiver has reason and scope;
- every generated evidence artifact declares source where practical;
- every blocking policy finding is resolved, waived, or documented.

## Maintenance Notes

Update this document when governance controls, traceability, risk management, or release evidence models change.
