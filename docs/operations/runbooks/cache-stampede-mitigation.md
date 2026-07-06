# Cache Stampede Mitigation Runbook

This runbook describes how to respond when many processes repeatedly rebuild the same expensive generated state.

For Monad, cache stampede risk mainly applies to graph generation, context generation, report generation, CI caches, and future hosted projection queries.

## Symptoms

- repeated regeneration of `.monad/graphs/` or `.monad/context/`;
- CI jobs spending excessive time rebuilding the same artifacts;
- high CPU or disk activity during docs/graph/context checks;
- repeated cache invalidation from unstable fingerprints;
- future hosted projection reads repeatedly recomputing the same view.

## Immediate Triage

1. Identify the command or workflow causing repeated generation.
2. Confirm whether cache invalidation is expected.
3. Check whether ignored/generated directories are being scanned accidentally.
4. Disable nonessential regeneration in CI if safe.
5. Prefer read-only validation before deleting generated state.

## Mitigation Options

| Mitigation | Use When |
| ---------- | -------- |
| Add source fingerprints | Cache is invalidated too often. |
| Scope command to paths/units | Full workspace scan is unnecessary. |
| Serialize generation | Parallel jobs race to rebuild same cache. |
| Use CI cache keys | CI repeatedly rebuilds identical generated state. |
| Rebuild on demand | Cache maintenance is more expensive than generation. |
| Mark cache as stale but usable | Exact freshness is not required for noncritical preview. |

## Safety Notes

- Cache is generated state unless promoted to evidence.
- Do not treat stale cache as canonical truth.
- Do not delete release evidence when clearing cache.
- Preserve forensic or incident records if the stampede caused failure.

## Follow-Up

- Add performance fixture or regression test.
- Add cache invalidation diagnostics.
- Document expected cache paths.
- Update capacity planning if thresholds change.
