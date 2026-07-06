# Monad Artifact Provenance Ledger Reference

## Purpose

This document defines the provenance ledger for all artifacts produced by Monad OS / Monad CLI.

The provenance ledger is the institutional memory of the repository.  
It records *who produced what, when, how, and why*.

Provenance ensures:

```text
artifacts are traceable
artifacts are explainable
artifacts are replayable
artifacts are integrity-verified
artifacts are linked to governance
```

---

## Provenance Doctrine

Provenance must be:

```text
append-only
immutable
complete
cross-domain consistent
replayable
governance-aligned
```

Provenance is not optional.  
A release without provenance is not a release.

---

## Provenance Entry Format

Each artifact entry must include:

| Field                | Description                                                   |
|----------------------|---------------------------------------------------------------|
| Artifact ID          | Unique identifier (`ARTIF-NNN`).                              |
| Artifact Type        | Build, plan, graph, release, evidence, schema.                |
| Origin Command       | Deterministic CLI invocation.                                 |
| Workspace Context    | Workspace root, manifest version, domain context.             |
| Lifecycle Graph Node | Node ID, node type, dependencies.                             |
| Governance Context   | ADR lineage, work packet lineage, policy evaluation results.  |
| Integrity Metadata   | Hashes, signatures, schema version.                           |
| Timestamps           | Created, validated, archived.                                 |

Entries must be complete.

---

## Provenance Operations

### Append

New entries are appended.  
No entry may be modified in place.

### Query

Provenance may be queried by:

- Artifact ID  
- Artifact type  
- Release  
- Work packet  
- ADR lineage  

### Export

Provenance may be exported for:

- Release evidence  
- Governance review  
- Security audit  
- Compliance  

### Replay

Replay reconstructs:

- Artifact creation  
- Graph transitions  
- Plan application  
- Policy evaluation  
- Release history  

Replay must match provenance exactly.

---

## Provenance Invariants

```text
no artifact without provenance
no provenance without integrity metadata
no provenance without governance context
no provenance without replayability
```

Provenance is the institutional backbone of Monad.