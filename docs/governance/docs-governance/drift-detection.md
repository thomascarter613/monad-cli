# Documentation Drift Detection

Drift is any difference between declared repository intent and actual repository state.

This document focuses on documentation drift: stale, missing, contradictory, or untraceable documentation.

## Drift Types

| Drift Type | Description |
| ---------- | ----------- |
| ADR drift | ADR index/status does not match ADR files. |
| Work packet drift | Work packet docs do not match roadmap or implementation state. |
| Command drift | Command docs differ from command catalog or implementation. |
| Schema drift | Docs reference outdated JSON/output schemas. |
| Traceability drift | Requirements, ADRs, work packets, tests, risks, and evidence no longer align. |
| Generated docs drift | Generated docs are stale or lack regeneration lineage. |
| Policy drift | Documentation references old policy IDs or waiver behavior. |
| Link drift | Local links point to missing or renamed files. |

## Detection Sources

Potential commands and scripts:

```bash
monad docs check
monad adr check
monad workpacket check
monad context verify
monad policy check
scripts/drift-check.sh
```

## Detection Rules

Initial drift checks should verify:

- required docs exist;
- indexes include known files;
- ADR statuses are valid;
- local links resolve;
- command docs do not claim placeholder behavior is implemented;
- generated docs are marked as generated;
- traceability references current file paths;
- release evidence references existing artifacts.

## Mitigation Workflow

1. Identify the source of truth.
2. Determine whether docs, implementation, or governance records are stale.
3. Generate or draft a correction.
4. Review the diff.
5. Apply the update.
6. Add a test, policy, or invariant when recurrence is likely.
7. Update traceability or release evidence if affected.

## Severity

| Severity | Meaning |
| -------- | ------- |
| Info | Non-blocking improvement. |
| Warning | Possible drift or stale reference. |
| Error | Required doc, link, or index is invalid. |
| Blocking | Release/governance evidence cannot be trusted. |

## CI Guidance

Documentation drift checks should eventually run in CI for release readiness. Early checks may warn before they block.

## Maintenance Notes

Keep this document aligned with documentation invariants, command metadata, traceability matrix, and release evidence model.
