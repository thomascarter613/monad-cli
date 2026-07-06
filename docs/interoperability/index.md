# Interoperability Governance Index

This directory defines Monad's interoperability governance layer.

Monad coordinates native tools and may later interoperate with external systems, registries, hosted projections, AI providers, policy engines, and federated repositories. Interoperability must be explicit, versioned, and governed so local-first behavior remains trustworthy.

## Files

| File | Purpose |
| ---- | ------- |
| `cross-system-contracts.md` | Contract model for data, command, schema, and integration boundaries. |
| `external-governance.md` | Rules for external systems, providers, registries, and services. |
| `federation-governance.md` | Governance for multi-repository or multi-organization coordination. |
| `interoperability-invariants.md` | Rules that interoperability must preserve. |

## Scope

This layer covers:

- native tool coordination;
- machine-readable output contracts;
- external registries;
- hosted projection interfaces;
- AI provider adapters;
- plugin and pack boundaries;
- policy engine adapters;
- future repository federation.

## Principles

- Local behavior must work without external systems.
- Cross-system contracts must be versioned when stable.
- External calls must be explicit.
- Telemetry remains disabled by default.
- AI/provider use remains optional and adapter-based.
- Remote state must not silently replace local source of truth.
- Federation must preserve provenance and ownership.

## Related ADRs

- ADR-0002: Coordinate Native Tools Instead of Replacing Them
- ADR-0003: Local-First Core
- ADR-0013: Versioned Machine-Readable Output Schemas
- ADR-0016: Pack and Template Trust Model
- ADR-0017: Plugin Execution and Trust Boundary
- ADR-0018: Hosted Control Plane Is Optional Projection Layer
- ADR-0019: No Telemetry by Default
- ADR-0020: AI Provider Port and Noop Adapter

## Maintenance Notes

Update this index when interoperability contracts, external integrations, hosted projection interfaces, or federation rules change.
