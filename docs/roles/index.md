# Roles Index

This directory defines Monad role governance.

Role governance clarifies who or what is allowed to make decisions, approve changes, execute workflows, steward artifacts, and cross trust boundaries.

## Files

| File | Purpose |
| ---- | ------- |
| `role-charters.md` | Defines core human, automation, and future system roles. |
| `authority-boundaries.md` | Defines what each role may and may not decide or execute. |
| `stewardship-contracts.md` | Defines long-term responsibility contracts for governed artifacts. |

## Role Categories

| Category | Examples |
| -------- | -------- |
| Human roles | maintainer, reviewer, release steward, security steward, documentation steward. |
| Automation roles | CI, policy checker, docs checker, release evidence generator. |
| Runtime roles | Monad CLI, native tool adapter, AI provider adapter, hosted projection adapter. |
| Governance roles | ADR owner, work packet owner, risk owner, waiver approver. |

## Principles

- Authority must be explicit.
- Automation can report, validate, and propose; it should not silently override governance decisions.
- AI can assist but is not authoritative.
- Hosted projection can aggregate evidence but does not replace local source of truth.
- Stewardship duties should be traceable to artifacts, not vague ownership.

## Related ADRs

- ADR-0003: Local-First Core
- ADR-0004: AI-Native but AI-Optional
- ADR-0006: Plan-Backed Mutation
- ADR-0010: Policy-as-Code
- ADR-0012: Honest Placeholder Commands
- ADR-0017: Plugin Execution and Trust Boundary
- ADR-0018: Hosted Control Plane Is Optional Projection Layer
- ADR-0020: AI Provider Port and Noop Adapter

## Maintenance Notes

Update this index when new role categories, authority rules, or stewardship contracts are introduced.
