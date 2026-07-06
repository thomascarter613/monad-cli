# Metrics Dictionary

This document defines candidate metrics for Monad operations.

Monad core has no telemetry by default. Metrics may come from local command reports, CI evidence, generated reports, or future opt-in hosted projection.

## Metric Principles

- Metrics should be local-first where possible.
- Metrics should be derived from versioned outputs when stable.
- Metrics must not require telemetry for core use.
- Metrics should preserve source, timestamp, schema version, and command context.
- Sensitive repository data should not be emitted as labels.

## Candidate Metrics

| Metric | Type | Description |
| ------ | ---- | ----------- |
| `monad_command_duration_seconds` | histogram | Duration of a Monad command. |
| `monad_command_exit_code` | gauge/count | Exit code classification by command. |
| `monad_policy_findings_total` | count | Number of policy findings by severity. |
| `monad_docs_findings_total` | count | Number of documentation findings by severity. |
| `monad_graph_nodes_total` | gauge | Lifecycle graph node count. |
| `monad_graph_edges_total` | gauge | Lifecycle graph edge count. |
| `monad_context_items_total` | gauge | Context items included in generated context. |
| `monad_context_redactions_total` | count | Redaction actions during context generation. |
| `monad_plan_operations_total` | gauge | Operations in a generated plan. |
| `monad_apply_failures_total` | count | Failed plan apply operations. |
| `monad_release_evidence_missing_total` | count | Missing required release evidence items. |

## Label Guidance

Safe labels may include:

- command name;
- severity;
- schema version;
- output format;
- status;
- workspace unit kind.

Avoid labels containing:

- full file contents;
- secrets;
- personal data;
- raw paths from private repositories when unnecessary;
- prompts or AI provider payloads.

## Maintenance Notes

Promote metrics to stable only after output schemas and dashboards are mature.
