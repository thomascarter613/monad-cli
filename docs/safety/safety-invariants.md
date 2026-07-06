# Safety Invariants

This document defines safety invariants Monad should preserve.

Safety invariants are rules that should remain true as the repository, command surface, generated state, and governance model evolve.

## Core Invariants

| Invariant | Rule |
| --------- | ---- |
| SAFE-INV-001 | Read-only commands do not mutate repository state. |
| SAFE-INV-002 | Significant mutation is plan-backed where practical. |
| SAFE-INV-003 | Dry-run writes nothing. |
| SAFE-INV-004 | Canonical state is not overridden by generated state. |
| SAFE-INV-005 | AI output is non-authoritative. |
| SAFE-INV-006 | Telemetry is disabled by default. |
| SAFE-INV-007 | Hosted projection remains optional. |
| SAFE-INV-008 | Secrets are excluded from context artifacts by default. |
| SAFE-INV-009 | Placeholder commands do not fake success. |
| SAFE-INV-010 | Policy bypass requires explicit waiver or review. |
| SAFE-INV-011 | Plugins and packs cannot bypass declared trust boundaries. |
| SAFE-INV-012 | Release evidence must not claim checks that did not run. |

## Validation Strategy

Future checkers should validate safety invariants through:

- command contract tests;
- dry-run tests;
- filesystem safety tests;
- no-network/no-telemetry checks;
- context redaction tests;
- policy/waiver tests;
- release evidence validation;
- plugin/pack capability checks.

## Maintenance Notes

Update safety invariants when a new command, extension mechanism, provider adapter, hosted workflow, or release evidence model changes safety posture.
