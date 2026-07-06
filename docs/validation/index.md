# Validation Index

This directory defines Monad's validation documentation layer.

Validation asks whether repository artifacts satisfy declared rules, contracts, schemas, policies, and domain expectations.

## Files

| File | Purpose |
| ---- | ------- |
| `domain-validation.md` | Validation rules inside a single domain or subsystem. |
| `cross-domain-validation.md` | Validation across domains, artifacts, and lifecycle layers. |
| `institutional-validation.md` | Validation of governance, stewardship, evidence, and long-term repository health. |

## Validation Layers

| Layer | Examples |
| ----- | -------- |
| Syntax | TOML/JSON/Markdown/schema parse checks. |
| Semantic | Manifest meaning, command status, work packet status. |
| Policy | Governance rules, waivers, safety gates. |
| Structural | Graph invariants, docs indexes, traceability links. |
| Institutional | ADR coherence, release evidence, risk stewardship. |

## Principles

- Validation should be deterministic where practical.
- Validation should report actionable findings.
- Validation should distinguish warnings from blocking failures.
- Validation should not mutate state unless explicitly invoked through a safe workflow.
- Validation findings should be machine-readable when stable.

## Related ADRs

- ADR-0005: `monad.toml` Is the Canonical Manifest
- ADR-0008: Lifecycle Graph as Core Model
- ADR-0010: Policy-as-Code
- ADR-0013: Versioned Machine-Readable Output Schemas
- ADR-0014: Stable CLI Exit Code Taxonomy

## Maintenance Notes

Update this index when validation models, policy checks, schemas, or release gates change.
