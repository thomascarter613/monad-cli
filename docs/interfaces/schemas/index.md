# Monad Interface Schemas — Index

## Purpose

This index defines the governed schema corpus for Monad OS / Monad CLI.

Schemas are the institutional contracts that define:

```text
the shape of data
the meaning of fields
the stability of interfaces
the invariants of the domain
the safety of mutation
the determinism of the lifecycle graph
```

Schemas are governance artifacts.  
They must be versioned, validated, and preserved.

---

## Schema Doctrine

Monad schemas must ensure:

```text
schemas are deterministic
schemas are versioned
schemas are governed
schemas are stable
schemas are machine-readable
schemas are human-readable
schemas are traceable to ADRs and work packets
schemas are validated in CI/CD
schemas are linked to release evidence
```

Schemas are institutional contracts.

---

## Schema Categories

| Category | Description |
|----------|-------------|
| Workspace Schemas | Manifest, workspace model, pack metadata. |
| Graph Schemas | Node types, edges, invariants, replay semantics. |
| Plan Schemas | Plan diff, plan apply, apply report. |
| Policy Schemas | Policy-as-code, waiver system, evaluation output. |
| Release Schemas | Release bundles, evidence bundles, provenance. |
| Artifact Schemas | Artifact metadata, integrity metadata, retention metadata. |
| CLI Schemas | Command catalog, command metadata, exit code taxonomy. |

Each schema category has its own invariants and governance rules.

---

## Schema Requirements

Every schema must include:

- Purpose  
- Domain context  
- Governance context  
- ADR lineage  
- Work packet lineage  
- Stability guarantees  
- Versioning rules  
- Field definitions  
- Field invariants  
- Trust boundary rules  
- Policy-as-code constraints  
- Validation rules  
- Provenance requirements  

---

## Schema Versioning Rules

Schema versioning must be:

- Explicit  
- Semantic  
- Governed  
- Traceable  

Versioning rules:

1. **Major version increments** require ADR + governance approval.  
2. **Minor version increments** require work packet + evidence.  
3. **Patch version increments** require provenance update.  

---

## Schema Validation Requirements

Schemas must be validated through:

- CI/CD  
- Docs check  
- Policy check  
- ADR validation  
- Work packet validation  
- Release evidence  

Validation must be deterministic.

---

## Schema Provenance Requirements

Schemas must be recorded in provenance:

- Schema version  
- Stability contract  
- Trust boundary contract  
- ADR lineage  
- Work packet lineage  

Provenance must be:

- Append-only  
- Immutable  
- Replayable  
- Governance-aligned  

---

## Schema Invariants

```text
no schema without versioning
no schema without governance
no schema without invariants
no schema without validation
no schema without provenance
no schema without trust-boundary rules
```

Schemas are governed institutional contracts.