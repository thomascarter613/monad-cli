# Safety Index

This directory defines Monad's safety documentation layer.

Safety documentation explains how Monad prevents unsafe repository changes, misleading governance state, privacy leaks, AI overreach, hidden telemetry, and institutional drift.

## Files

| File | Purpose |
| ---- | ------- |
| `governance-safety.md` | Safety rules for governance workflows and evidence. |
| `harm-model.md` | Harm model for unsafe behavior, data leakage, and trust failure. |
| `institutional-safety.md` | Long-term safety model for repository stewardship. |
| `risk-register.md` | Operational risk register. |
| `safety-invariants.md` | Safety invariants that should remain true. |

## Safety Principles

- Read-only commands should not mutate.
- Significant mutation should be plan-backed.
- AI assistance must be optional and non-authoritative.
- Telemetry is disabled by default.
- Hosted projection is optional.
- Context generation must be redaction-aware.
- Generated state must not become hidden source of truth.
- Placeholders must not fake success.

## Related ADRs

- ADR-0003: Local-First Core
- ADR-0004: AI-Native but AI-Optional
- ADR-0006: Plan-Backed Mutation
- ADR-0010: Policy-as-Code
- ADR-0011: Deterministic Context Before AI Assistance
- ADR-0012: Honest Placeholder Commands
- ADR-0019: No Telemetry by Default

## Maintenance Notes

Update this index when safety doctrine, risk categories, threat models, or policy controls change.
