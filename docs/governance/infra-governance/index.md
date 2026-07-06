# Infrastructure Governance Index

This directory contains Monad's infrastructure governance documentation.

Infrastructure governance defines how environments, provisioning, drift detection, and infrastructure invariants should be documented and validated.

## Files

| File | Purpose |
| ---- | ------- |
| `environment-contracts.md` | Environment identity, configuration, secrets, and promotion expectations. |
| `provisioning-governance.md` | Rules for provisioning workflows, plans, approvals, and evidence. |
| `infra-invariants.md` | Infrastructure rules that should remain true over time. |
| `infra-drift-detection.md` | Detection and mitigation for infrastructure drift. |

## Scope

This governance layer covers:

- local development environments;
- CI environments;
- generated infrastructure state;
- future hosted projection environments;
- secrets and configuration boundaries;
- provisioning evidence;
- drift detection;
- release readiness gates.

## Principles

- Local-first workflows remain usable without hosted infrastructure.
- Infrastructure changes should be reviewable and plan-backed where practical.
- Environment contracts should be explicit.
- Secrets must not be committed or included in generated context.
- Generated infrastructure reports are not source of truth unless promoted.
- Hosted infrastructure is optional projection until a future ADR changes that.

## Related ADRs

- ADR-0003: Local-First Core
- ADR-0006: Plan-Backed Mutation
- ADR-0010: Policy-as-Code
- ADR-0018: Hosted Control Plane Is Optional Projection Layer
- ADR-0019: No Telemetry by Default

## Maintenance Notes

Update this index when infrastructure governance files, environment contracts, or provisioning workflows change.
