# Security Baseline

## Baseline Controls

- No committed secrets.
- Dependency trust policy exists.
- License policy exists.
- SBOM workflow exists.
- Static analysis workflow exists.
- Release requires green CI.
- Work packets require completion evidence.
- Destructive operations require plan/diff/apply.

## Required Checks

```bash
scripts/dependency-hygiene.sh
scripts/sbom.sh
scripts/drift-check.sh
monad policy check
```

## Evidence

Compliance evidence should live under `.monad/reports/` or `compliance/audits/` depending on whether the artifact is transient or committed.
