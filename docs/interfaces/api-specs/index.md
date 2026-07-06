# Monad API Specifications — Index

## Purpose

This index defines the governed API specification corpus for Monad OS / Monad CLI.

APIs are not merely integration points.  
They are governed institutional interfaces that must be:

```text
deterministic
stable
versioned
policy-aligned
trust-boundary-safe
schema-backed
provenance-traceable
```

APIs must reflect the lifecycle graph, workspace model, and plan-backed mutation engine.

---

## API Specification Doctrine

Monad API specifications must ensure:

```text
the API surface is honest
the API semantics are explicit
the API is deterministic
the API is governed by policy-as-code
the API is versioned and schema-backed
the API is safe across trust boundaries
the API is traceable to ADRs and work packets
```

APIs are institutional artifacts.

---

## API Specification Categories

| Category | Description |
|---------|-------------|
| Core APIs | Workspace, lifecycle graph, plan engine, manifest. |
| CLI APIs | Command catalog, command metadata, exit code taxonomy. |
| Pack APIs | Pack trust model, template trust model, pack metadata. |
| Policy APIs | Policy-as-code evaluation, waiver system. |
| Graph APIs | Node types, edges, invariants, replay semantics. |
| Mutation APIs | Plan diff, plan apply, apply reports. |
| Release APIs | Release bundles, evidence bundles, provenance. |
| Schema APIs | Versioned machine-readable schemas. |

Each category has its own invariants and governance rules.

---

## API Specification Requirements

Every API specification must include:

- Purpose  
- Domain context  
- Governance context  
- ADR lineage  
- Work packet lineage  
- Stability guarantees  
- Versioning rules  
- Schema definitions  
- Trust boundary rules  
- Policy-as-code constraints  
- Error taxonomy  
- Exit code taxonomy  
- Provenance requirements  

---

## API Specification Invariants

```text
no API without schema
no API without versioning
no API without governance
no API without provenance
no API without trust-boundary rules
```

APIs are governed institutional interfaces.