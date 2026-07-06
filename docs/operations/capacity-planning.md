# Capacity Planning

This document defines capacity planning guidance for Monad operations.

Monad is primarily a local-first CLI, so capacity planning focuses on local repository scale, CI runtime, generated state size, graph/context generation cost, and future hosted projection load.

## Purpose

Capacity planning helps answer:

- How large can repositories become before commands slow down?
- Which generated artifacts may grow quickly?
- Which checks are safe for CI?
- Which outputs should be cached or rebuilt?
- What capacity concerns appear if hosted projection is introduced?

## Capacity Dimensions

| Dimension | Examples |
| --------- | -------- |
| Repository size | file count, directory depth, manifest count, generated files. |
| Workspace units | apps, services, packages, docs, policies, tests. |
| Graph size | node count, edge count, export size, cache size. |
| Context size | included files, summarized docs, redaction reports, token-like budgets. |
| Policy scale | rule count, finding count, waiver count. |
| CI runtime | format/check/test/docs/policy duration. |
| Generated state | `.monad/cache/`, `.monad/graphs/`, `.monad/context/`, reports. |

## Local Baseline

Core Monad commands should remain usable on ordinary developer machines.

Guidance:

- prefer streaming or bounded scans where practical;
- avoid reading dependency directories by default;
- respect ignore rules;
- avoid network by default;
- avoid AI/provider calls by default;
- make expensive operations explicit;
- cache only rebuildable generated state.

## Capacity Thresholds

Initial thresholds are advisory until measured:

| Area | Watch Point |
| ---- | ----------- |
| File scan | large file count or ignored directory leakage. |
| Graph generation | high node/edge count or repeated full rebuilds. |
| Context generation | oversized context bundles or missing redaction pruning. |
| Policy checks | slow rule evaluation or duplicate repository scans. |
| CI | checks exceeding acceptable feedback loop. |

## Scaling Strategies

- cache rebuildable graph/context summaries;
- reuse inspection facts across checks;
- make output filtering available;
- scope commands to units or paths;
- split machine-readable reports by domain when large;
- avoid hosted dependency for local scale problems;
- add performance fixtures for large workspaces.

## Future Hosted Projection

If hosted projection is introduced, capacity planning should cover:

- repository count;
- graph export size;
- policy report volume;
- release evidence retention;
- tenant isolation;
- sync frequency;
- storage and query costs.

## Maintenance Notes

Update this document when command performance, graph/context cache behavior, CI gates, or hosted projection assumptions change.
