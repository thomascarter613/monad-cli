# Disaster Recovery Plan

This document defines disaster recovery expectations for Monad repository state and future hosted projection layers.

Monad is local-first, so disaster recovery begins with protecting source-controlled repository truth and ensuring generated state can be rebuilt.

## Scope

This plan covers:

- repository source files;
- `monad.toml` canonical manifest;
- `monad.lock` resolved state;
- `.monad/` generated/local state;
- plan/apply reports;
- graph and context cache outputs;
- release evidence;
- future hosted projection data.

## Source-of-Truth Recovery Model

| Artifact | Recovery Rule |
| -------- | ------------- |
| Source code | Recover from Git. |
| `monad.toml` | Recover from Git; canonical Monad intent. |
| `monad.lock` | Recover from Git if committed; otherwise regenerate from manifest and source state when supported. |
| ADRs/work packets/docs | Recover from Git. |
| `.monad/cache/` | Rebuildable generated state. |
| `.monad/graphs/` | Rebuildable generated graph cache. |
| `.monad/context/` | Rebuildable unless intentionally exported as durable evidence. |
| `.monad/plans/` | Generated plan artifacts; important applied plans may be promoted to evidence. |
| Release evidence | Should be committed or stored in a durable release evidence path when authoritative. |

## Local Recovery Priorities

1. Restore repository checkout.
2. Verify `monad.toml` and source-controlled docs/ADRs/work packets.
3. Re-run `monad check` when implemented.
4. Rebuild graph/cache outputs.
5. Regenerate context/handoff artifacts.
6. Re-run policy and release readiness checks.
7. Recreate generated reports where needed.

## RTO/RPO Guidance

For the local CLI baseline:

| Area | RTO | RPO |
| ---- | --- | --- |
| Source-controlled architecture/docs/code | Time to restore Git clone | Last pushed commit |
| Generated graph/context/cache | Time to regenerate | No durable loss expected |
| Applied plan evidence | Depends on storage/commit policy | Last committed/exported evidence |
| Hosted projection | Future: service-specific | Future: sync/export-specific |

Hosted RTO/RPO targets should be defined only when hosted features exist.

## Failure Scenarios

| Scenario | Expected Recovery |
| -------- | ----------------- |
| Local `.monad/` deleted | Regenerate cache, graph, context, and reports from source state. |
| `monad.lock` missing | Re-resolve from `monad.toml` once lockfile behavior exists. |
| Corrupt generated graph cache | Ignore or rebuild cache. |
| Stale context handoff | Regenerate from current repository state. |
| Failed apply | Use apply report and Git diff/status to inspect partial effects. |
| Accidental mutation | Use Git, plan report, and backups to revert. |
| Hosted outage | Continue local workflows; hosted views are optional projections. |

## Backup Guidance

Minimum durable backup strategy:

- use Git as the primary source backup;
- commit ADRs, work packets, policies, docs, and canonical manifests;
- do not rely on `.monad/` cache as sole source of truth;
- export important release evidence deliberately;
- keep applied plan reports when they become audit evidence.

## Future Hosted Recovery

If a hosted control plane is introduced, it must document:

- data stored remotely;
- sync direction;
- retention policy;
- tenant isolation;
- backup cadence;
- restore process;
- export process;
- local fallback behavior.

Hosted recovery must not replace local source-controlled truth.

## Testing Expectations

Recovery tests should eventually cover:

- deleting `.monad/cache/` and rebuilding;
- deleting `.monad/graphs/` and rebuilding;
- missing lockfile behavior;
- stale cache invalidation;
- failed apply reporting;
- release evidence regeneration;
- hosted-offline local operation.

## Maintenance Notes

Update this plan when `monad.lock`, graph cache, context artifacts, plan reports, release evidence, or hosted projection semantics materially change.
