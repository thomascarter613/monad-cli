# Verification Index

This directory defines Monad's verification documentation layer.

Verification asks whether Monad's claims, invariants, correctness expectations, and governance rules can be proven, checked, or supported with evidence.

## Files

| File | Purpose |
| ---- | ------- |
| `correctness-proofs.md` | Evidence and proof model for correctness-critical behavior. |
| `formal-methods.md` | Future formal methods posture and candidate applications. |
| `governance-verification.md` | Verification of governance controls, traceability, and evidence. |
| `invariant-checkers.md` | Checker model for validating invariants over time. |

## Verification Layers

| Layer | Examples |
| ----- | -------- |
| Tests | unit, integration, fixture, contract, snapshot, BDD. |
| Schemas | JSON Schema, manifest schema, output schema. |
| Invariants | safety, docs, graph, infra, interoperability invariants. |
| Proofs | correctness arguments for plan/apply and source-of-truth behavior. |
| Evidence | release reports, policy findings, apply reports, traceability matrix. |

## Related ADRs

- ADR-0006: Plan-Backed Mutation
- ADR-0008: Lifecycle Graph as Core Model
- ADR-0010: Policy-as-Code
- ADR-0013: Versioned Machine-Readable Output Schemas
- ADR-0014: Stable CLI Exit Code Taxonomy

## Maintenance Notes

Update this index when verification methods, invariant checkers, formal methods, or release evidence models change.
