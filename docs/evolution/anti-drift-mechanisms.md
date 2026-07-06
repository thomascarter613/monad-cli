# Anti-Drift Mechanisms

## Purpose

Anti-drift mechanisms prevent divergence between:

- Code  
- Docs  
- ADRs  
- Work packets  
- Policy  
- Release evidence  

Drift is a governance failure.

---

## Anti-Drift Doctrine

Anti-drift must ensure:

```text
drift is detected
drift is prevented
drift is governed
drift is remediated
```

---

## Anti-Drift Mechanisms

- Docs check  
- Policy check  
- ADR validation  
- Work packet validation  
- Release evidence  
- Provenance replay  

---

## Anti-Drift Invariants

```text
no drift between code and docs
no drift between docs and ADRs
no drift between ADRs and work packets
no drift between work packets and releases
```