# Incident Response Runbook

## Incident Definition

A Monad incident is any event that threatens repository integrity, release integrity, security posture, or developer trust.

Examples:

- Accidental destructive file change.
- Secret committed to repository history.
- Release artifact generated from stale state.
- Policy bypass without waiver.
- Dependency compromise or suspicious package update.
- Broken main branch.

## Response Steps

1. Stop further changes.
2. Capture current state.
3. Identify blast radius.
4. Revert or isolate if needed.
5. Open or update a work packet.
6. Add completion evidence and post-incident notes.
7. Add a regression check, policy, or workflow.

## Commands

```bash
git status
git log --oneline -n 20
scripts/drift-check.sh
scripts/dependency-hygiene.sh
scripts/graph-integrity.sh
```

## Post-Incident Artifact

Create a document under `ops/incidents/` if the incident affects release, security, or data integrity.
