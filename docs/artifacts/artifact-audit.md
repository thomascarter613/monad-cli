# Monad Artifact Audit Reference

## Purpose

This document defines the audit process for artifacts produced by Monad OS / Monad CLI.

Artifact audit ensures:

```text
artifacts are correct
artifacts are safe
artifacts are compliant
artifacts are reproducible
artifacts are governance-aligned
```

Audit is an institutional requirement.

---

## Audit Doctrine

Artifact audit must ensure:

```text
replay matches provenance
integrity metadata is correct
policy checks are satisfied
trust boundaries are respected
release evidence is complete
```

Audit failures block release unless explicitly waived.

---

## Audit Inputs

- Provenance ledger  
- Release evidence  
- Workspace manifests  
- Lifecycle graph snapshots  
- Plan diffs  
- ADR references  
- Work packets  
- CI/CD logs  
- Machine‑readable schemas  

---

## Audit Phases

### Phase 1 — Selection

Artifacts selected by:

- Release  
- Work packet  
- ADR impact  
- Risk category  
- Mutation scope  

### Phase 2 — Deterministic Replay

Replay reconstructs:

- Artifact creation  
- Graph transitions  
- Plan application  
- Policy evaluation  

Replay must match provenance exactly.

### Phase 3 — Integrity Verification

Checks:

- Hashes  
- Signatures  
- Schema validation  
- Domain invariants  

### Phase 4 — Governance Verification

Checks:

- Policy‑as‑code compliance  
- Pack trust boundaries  
- Plugin trust boundaries  
- ADR alignment  

### Phase 5 — Findings

Findings include:

- Violations  
- Risks  
- Drift  
- Invariant breaks  

### Phase 6 — Remediation

Remediation must be:

- Governed  
- Traceable  
- Linked to roadmap  
- Linked to work packets  

---

## Audit Invariants

```text
every artifact must be replayable
every artifact must be integrity-verified
every artifact must be policy-checked
every artifact must be provenance-complete
every release must have audit coverage
```

Artifact audit is the institutional verification layer of Monad.