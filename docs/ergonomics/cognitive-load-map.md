### **Governance‑Grade Cognitive Load Map**

```markdown
# Cognitive Load Map

## Purpose

The cognitive load map identifies where complexity lives in Monad OS / Monad CLI.

Cognitive load must be governed.

---

## Cognitive Load Doctrine

Cognitive load mapping must ensure:

```text
complexity is visible
complexity is explainable
complexity is governable
complexity is reducible
```

---

## Cognitive Load Zones

### Zone 1 — Workspace Model

High complexity due to:

- Manifest structure  
- Workspace crates  
- Workspace invariants  

### Zone 2 — Lifecycle Graph

High complexity due to:

- Node types  
- Node relationships  
- Graph invariants  

### Zone 3 — Plan-Backed Mutation

High complexity due to:

- Plan diff  
- Plan apply  
- Apply reports  

### Zone 4 — ADR Corpus

High complexity due to:

- ADR lineage  
- ADR governance  

### Zone 5 — Work Packets

High complexity due to:

- Work packet structure  
- Work packet lineage  

---

## Cognitive Load Invariants

```text
cognitive load must be mapped
cognitive load must be governed
cognitive load must be reduced
```