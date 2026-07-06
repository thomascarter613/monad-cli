# Monad Webhooks & Events Reference

## Purpose

This document defines the governed webhook and event interface for Monad OS / Monad CLI.

Webhooks and events are not merely integration points.  
They are governed institutional signals that communicate:

```text
workspace changes
graph changes
plan changes
mutation changes
release changes
policy changes
evidence changes
```

Webhooks and events must be deterministic, stable, versioned, schema-backed, and safe across trust boundaries.

---

## Webhooks & Events Doctrine

Monad webhook and event interfaces must ensure:

```text
events are deterministic
events are reproducible
events are governed by policy-as-code
events are safe across trust boundaries
events are stable across releases
events are versioned and schema-backed
events are traceable to ADRs and work packets
events produce evidence
events are recorded in provenance
```

Events are institutional artifacts.

---

## Event Categories

| Category | Description |
|----------|-------------|
| Workspace Events | Manifest changes, workspace model changes, pack changes. |
| Graph Events | Node creation, node mutation, node deletion, graph rebuild. |
| Plan Events | Plan diff creation, plan apply, apply report generation. |
| Mutation Events | File creation, file deletion, file modification. |
| Release Events | Release creation, evidence generation, provenance updates. |
| Policy Events | Policy evaluation, waiver creation, governance changes. |
| Security Events | Trust boundary checks, security posture changes. |

Each event category has its own invariants and governance rules.

---

## Webhook Delivery Guarantees

Webhooks must guarantee:

- **Deterministic payloads**  
- **Stable schemas**  
- **Stable versioning**  
- **Stable semantics**  
- **Stable trust boundaries**  
- **Replayability**  
- **Provenance traceability**  

Webhook delivery must be:

- **At-least-once** for governance events  
- **At-most-once** for mutation events  
- **Exactly-once** for release events  

Delivery guarantees must be documented and governed.

---

## Event Schema Requirements

Every event must have:

- A versioned machine-readable schema  
- A human-readable specification  
- A stability contract  
- A trust boundary contract  
- A policy-as-code contract  
- A provenance contract  

Event schemas must be:

- Deterministic  
- Validated  
- Versioned  
- Governed  

---

## Event Versioning Rules

Event versioning must be:

- Explicit  
- Semantic  
- Governed  
- Traceable  

Versioning rules:

1. **Major version increments** require ADR + governance approval.  
2. **Minor version increments** require work packet + evidence.  
3. **Patch version increments** require provenance update.  

---

## Event Trust Boundary Rules

Events must respect:

- Pack trust boundaries  
- Template trust boundaries  
- Plugin trust boundaries  
- No-telemetry doctrine  
- No-network-by-default posture  

Events must not:

- Leak sensitive data  
- Introduce nondeterminism  
- Introduce implicit behavior  

Events must be safe across trust boundaries.

---

## Event Provenance Requirements

Events must be recorded in provenance:

- Event ID  
- Event type  
- Event schema version  
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

## Event Evidence Requirements

Event changes must produce evidence:

- Schema diffs  
- Contract tests  
- Policy evaluations  
- ADR references  
- Work packet references  
- Release evidence  

Evidence IDs must follow:

```text
EVID-NNN
```

Events must be part of release evidence.

---

## Event Delivery Mechanisms

### 1. Local-First Delivery

Events must be deliverable locally without requiring:

- Network access  
- Remote services  
- Telemetry  

Local-first delivery is mandatory.

### 2. Optional Remote Delivery

Remote delivery must be:

- Opt-in  
- Governed  
- Safe  
- Policy-aligned  

Remote delivery must never be required for correctness.

### 3. Delivery Replay

Event delivery must be replayable from:

- Provenance  
- Release evidence  
- Workspace model  
- Lifecycle graph  

Replay must match provenance exactly.

---

## Event Stability Contracts

Every event must define:

- Stability guarantees  
- Breaking change rules  
- Deprecation rules  
- Replacement rules  
- Schema versioning rules  

Stability contracts must be governed.

---

## Event Error Taxonomy

Events must define:

- Delivery errors  
- Schema errors  
- Trust boundary errors  
- Policy errors  
- Provenance errors  

Errors must follow Monad’s stable exit code taxonomy.

---

## Event Invariants

```text
no event without schema
no event without versioning
no event without governance
no event without trust-boundary rules
no event without provenance
no event without evidence
no event without stability contract
```

Events are governed institutional signals.