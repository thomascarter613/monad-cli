# Drift Detection and Mitigation

Drift is any difference between declared repository intent and actual repository state.

## Drift Types

- Manifest drift: `monad.toml` disagrees with native config.
- Engine drift: tool versions differ from `governance/engines.toml`.
- Dependency drift: dependency versions are inconsistent across packages.
- Domain drift: imports cross boundaries without an allowed rule.
- Graph drift: project, dependency, or task graphs violate invariants.
- Documentation drift: generated docs/context are stale.
- Policy drift: waivers expire or policies are bypassed.

## Detection

Primary commands and scripts:

```bash
scripts/drift-check.sh
scripts/graph-integrity.sh
scripts/dependency-hygiene.sh
monad sync --check
monad policy check
monad context verify
```

## Mitigation

1. Identify the source of truth.
2. Generate a plan.
3. Review the diff.
4. Apply only safe changes.
5. Update docs and completion evidence.
6. Add a policy or test to prevent recurrence.

## CI

Drift detection runs in `.github/workflows/drift-detection.yml`.
