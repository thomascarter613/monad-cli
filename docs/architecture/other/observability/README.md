# Observability Architecture

This directory documents Monad's observability architecture.

Monad is primarily a local-first CLI, so observability starts with local diagnostics, structured findings, machine-readable output, and inspectable reports rather than hosted telemetry.

## Purpose

Observability helps users and maintainers understand:

- what command ran;
- which repository root and manifest were used;
- what inputs were inspected;
- what checks produced findings;
- what plans would change;
- why a command failed;
- which native tools were invoked;
- whether output is stable, preview, or experimental.

## Related ADRs

- ADR-0003: Local-First Core
- ADR-0010: Policy-as-Code
- ADR-0013: Versioned Machine-Readable Output Schemas
- ADR-0014: Stable CLI Exit Code Taxonomy
- ADR-0018: Hosted Control Plane Is Optional Projection Layer
- ADR-0019: No Telemetry by Default

## Observability Surfaces

| Surface | Purpose |
| ------- | ------- |
| Human output | Clear terminal feedback for local use. |
| Structured findings | Policy, validation, docs, graph, and plan diagnostics. |
| JSON reports | CI, automation, future hosted projection, and release evidence. |
| Exit codes | Process-level outcome classification. |
| Apply reports | Evidence for what changed during plan application. |
| Context manifests | Evidence of included/excluded/redacted handoff material. |
| Local logs | Optional future local troubleshooting artifacts. |

## No Telemetry by Default

Monad must not upload telemetry, analytics, crash reports, repository metadata, context artifacts, graph data, policy findings, or plan data by default.

Future hosted observability may exist, but it must be explicit, opt-in, and separate from core local correctness.

## Diagnostic Model

Diagnostics should be structured around:

- severity;
- category;
- rule or diagnostic ID;
- message;
- affected path or graph node;
- source reference;
- remediation guidance;
- related ADR/work packet when useful;
- machine-readable outcome.

## Testing Expectations

Observability tests should cover:

- exit code mapping;
- JSON report shape;
- finding severity and categories;
- command failure classification;
- native tool missing/failure diagnostics;
- no-network/no-telemetry defaults.

## Maintenance Notes

Keep observability aligned with the CLI doctrine, output schema ADR, exit code ADR, policy model, and release evidence model. Prefer local, structured, inspectable reports over hidden logging or implicit remote collection.
