# Governance Handbook

Monad treats governance as a first-class system surface.

Governance is expressed through:

- `monad.toml` as canonical workspace intent.
- `.monorepo.json` as a generated compatibility/governance mirror.
- `governance/engines.toml` for deterministic engine declarations.
- `governance/boundaries.toml` for domain boundaries.
- `governance/graph-invariants.toml` for graph safety.
- `governance/lifecycle.toml` for creation/evolution/deprecation/archive rules.
- `governance/policies.toml` for repo-wide policy doctrine.
- `policies/` for detailed enforceable policy packs.

## Governance Doctrine

1. Intent is explicit.
2. Engines are declared.
3. Boundaries are documented.
4. Mutations are planned.
5. Drift is detected.
6. Exceptions are waivable but auditable.
7. Releases require evidence.
