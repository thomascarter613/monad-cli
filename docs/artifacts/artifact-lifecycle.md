# Monad Artifact Lifecycle Reference

## Purpose

This document defines the governed lifecycle for all artifacts produced by Monad OS / Monad CLI.

Artifacts represent the durable outputs of the workspace model, lifecycle graph, plan-backed mutation engine, and release system.  
Every artifact must be reproducible, traceable, auditable, and governed.

The artifact lifecycle ensures:

```text
artifacts are created deterministically
artifacts are validated against policy
artifacts are registered with provenance
artifacts are retained or retired according to governance
artifacts support release readiness
```

Artifacts are institutional records. Their lifecycle must be explicit.

---

## Artifact Lifecycle Doctrine

Monad is a governance‑grade repository runtime.

Artifacts must satisfy:

```text
the artifact is reproducible
the artifact is integrity-checked
the artifact is policy-compliant
the artifact is traceable to a command
the artifact is traceable to a workspace
the artifact is traceable to a work packet
the artifact is traceable to ADRs
the artifact is registered in provenance
the artifact is retained according to policy
```

Artifacts must never rely on hidden state, nondeterministic behavior, or implicit mutation.

---

## Artifact Types

| Type            | Description                                                     |
|-----------------|-----------------------------------------------------------------|
| Build Artifact  | Compiled binaries, images, or bundles.                          |
| Plan Artifact   | Plan diffs, apply logs, mutation reports.                       |
| Graph Artifact  | Lifecycle graph snapshots, caches, node metadata.               |
| Release Artifact| Release bundles, notes, changelog entries.                      |
| Evidence Artifact| Test, policy, governance, or security evidence.                |
| Schema Artifact | Versioned machine-readable schemas.                             |

Each artifact type has its own invariants and governance rules.

---

## Lifecycle Phases

### Phase 1 — Deterministic Creation

Artifacts are created only through governed commands:

```bash
monad plan
monad apply
monad graph
monad build
monad release
monad generate
```

Creation must be deterministic:

- Workspace model → lifecycle graph → plan → artifact  
- No telemetry  
- No nondeterministic inputs  
- No hidden state  

### Phase 2 — Registration

Artifacts must be registered with:

- Artifact ID  
- Artifact type  
- Origin command  
- Workspace context  
- Manifest version  
- ADR lineage  
- Work packet lineage  
- Integrity metadata  

Registration is append‑only.

### Phase 3 — Validation

Artifacts must pass:

- Structural validation  
- Policy‑as‑code evaluation  
- Safety envelope checks  
- Trust boundary checks  
- Schema validation  

Validation failures block release unless explicitly waived.

### Phase 4 — Provenance Append

Artifacts must be appended to the provenance ledger.

Ledger entries must be:

- Immutable  
- Replayable  
- Complete  
- Cross‑domain consistent  

### Phase 5 — Retention & Archival

Retention rules must be explicit:

- Short‑lived artifacts: caches, ephemeral diffs  
- Long‑lived artifacts: releases, evidence, provenance  
- Permanent artifacts: ADR‑linked artifacts  

### Phase 6 — Retirement

Artifacts may be retired only through governed change‑control.

Retirement must be recorded in provenance.

---

## Lifecycle Invariants

```text
every artifact is reproducible
every artifact is traceable
every artifact is governed
every artifact is replayable
every artifact is policy-aligned
every artifact is integrity-checked
```

Artifacts are institutional records. Their lifecycle must reflect that.