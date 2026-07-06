# Onboarding and Doctor Contract

## Goal

A new developer or coding assistant should be able to enter the repo, understand the system, run checks, and find the next work packet.

This document defines the onboarding process for contributors to Monad OS / Monad CLI.

Onboarding is not merely orientation.  
It is the process of entering a governed system.

## First Commands

```bash
git status --short
scripts/check.sh
scripts/graph-integrity.sh
scripts/drift-check.sh
```

## Required Reading

1. `README.md`
2. `AGENTS.md`
3. `docs/product/v1-scope.md`
4. `docs/workpackets/schema.md`
5. `docs/workpackets/index.md`
6. `governance/policies.toml`
7. `governance/boundaries.toml`

## Doctor Contract

`monad doctor` should eventually verify:

- Rust/Cargo availability.
- Bun availability.
- Git availability.
- Workspace root discovery.
- Manifest validity.
- Engine registry validity.
- Policy pack existence.
- Graph invariant files.
- Work packet index validity.
- Local infra availability when requested.

## Onboarding Doctrine

Onboarding must ensure:

```text
contributors understand the workspace model
contributors understand the lifecycle graph
contributors understand plan-backed mutation
contributors understand ADRs
contributors understand work packets
contributors understand release evidence
contributors understand governance
contributors understand policy-as-code
contributors understand trust boundaries
```

Onboarding is institutional.

---

## Onboarding Stages

### Stage 1 — Workspace Model

Contributor must understand:

- Workspace manifest  
- Workspace crates  
- Workspace invariants  

### Stage 2 — Lifecycle Graph

Contributor must understand:

- Graph nodes  
- Graph edges  
- Graph invariants  

### Stage 3 — Plan-Backed Mutation

Contributor must understand:

- Plan diff  
- Plan apply  
- Apply reports  

### Stage 4 — ADR Corpus

Contributor must understand:

- ADR structure  
- ADR lineage  
- ADR governance  

### Stage 5 — Work Packets

Contributor must understand:

- Work packet structure  
- Work packet lineage  
- Work packet governance  

### Stage 6 — Release Evidence

Contributor must understand:

- Evidence IDs  
- Evidence statuses  
- Evidence bundles  

### Stage 7 — Governance

Contributor must understand:

- Policy-as-code  
- Trust boundaries  
- Security posture  
- No-telemetry doctrine  

---

## Onboarding Invariants

```text
no contributor without workspace understanding
no contributor without governance understanding
no contributor without evidence understanding
```

Onboarding is the institutional entry point of Monad.