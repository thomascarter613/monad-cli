# Threat Model

## Scope

This threat model covers the Monad repository and CLI development process.

## Assets

- Source code
- Work packets
- Release artifacts
- Plan files
- Generated templates
- Policy files
- CI credentials
- Developer machines
- Dependency graph
- Engine registry

## Attack Surfaces

- GitHub Actions
- Dependency updates
- Generated files
- Local scripts
- Docker Compose services
- Plugin adapters
- Template sources
- Work packet instructions
- Release workflow
- Secrets in environment files

## Primary Threats

| Threat | Risk | Control |
|---|---|---|
| Secret committed to repo | High | Secret governance, scanning, review |
| Malicious dependency | High | Dependency trust rules, lockfiles, audits |
| Destructive CLI mutation | High | Plan/diff/apply, dry-run, path guards |
| Policy bypass | Medium | Waivers, policy checks, CI |
| Drifted generated docs | Medium | Drift detection |
| Compromised workflow | High | Least privilege, pinned actions, review |
| Unsafe plugin adapter | Medium | Declarative adapters only in v1 |

## v1 Security Doctrine

- Do not silently overwrite user work.
- Do not execute arbitrary generated scripts by default.
- Do not load dynamic native plugins in v1.
- Treat plugin adapters as explicit external commands.
- Require plan-backed mutation.
