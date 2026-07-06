# Rule Evolution

## Purpose

Rule evolution governs how Monad’s rules (policy, invariants, schemas) change across releases.

Rules must evolve safely.

---

## Rule Evolution Doctrine

Rule evolution must ensure:

```text
rules are stable
rules are governed
rules are traceable
rules are invariant-preserving
```

---

## Rule Evolution Mechanisms

- Policy-as-code  
- Schema versioning  
- Invariant versioning  
- ADRs  
- Work packets  

---

## Rule Evolution Invariants

```text
no rule change without governance
no rule change without evidence
no rule change without invariants
```