# Interoperability Invariants

This document defines invariants that Monad interoperability must preserve.

## Core Invariants

| Invariant | Rule |
| --------- | ---- |
| INT-INV-001 | Local core behavior must work without external systems. |
| INT-INV-002 | External calls must be explicit or configured. |
| INT-INV-003 | External data must not silently override local source of truth. |
| INT-INV-004 | Stable cross-system outputs must be versioned. |
| INT-INV-005 | Provider credentials must not be required for core commands. |
| INT-INV-006 | AI provider use must go through the AI provider port. |
| INT-INV-007 | Hosted projection must remain optional unless superseded by ADR. |
| INT-INV-008 | Pack, template, and plugin sources must preserve provenance. |
| INT-INV-009 | Federation outputs must include source identity. |
| INT-INV-010 | Telemetry remains disabled by default. |

## Validation Strategy

Future checks may validate:

- external integration metadata;
- schema versions;
- no-network default behavior;
- provider disabled behavior;
- hosted sync opt-in behavior;
- registry provenance;
- federation source metadata.

## Maintenance Notes

Update invariants when new integrations, provider adapters, registries, or federation models are introduced.
