# CI Failure Runbook

## Goal

Diagnose failing CI without guessing.

## Order of Operations

1. Identify the failing workflow.
2. Re-run the closest local script.
3. Check whether the failure is deterministic.
4. Inspect changed files.
5. Check drift.
6. Fix the root cause.
7. Add a regression test or policy where appropriate.

## Local Equivalents

| Workflow | Local Command |
|---|---|
| Monorepo validation | `scripts/check.sh` |
| Graph integrity | `scripts/graph-integrity.sh` |
| Dependency hygiene | `scripts/dependency-hygiene.sh` |
| Drift detection | `scripts/drift-check.sh` |
| SBOM | `scripts/sbom.sh` |

## Required Evidence

When fixing CI, include the failing command and the passing command in the work packet completion evidence.
