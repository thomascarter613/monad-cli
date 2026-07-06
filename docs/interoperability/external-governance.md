# External Governance

This document defines governance rules for external systems that Monad may call, read, write, or coordinate.

Monad is local-first. External governance exists to ensure optional integrations do not weaken local correctness, privacy, or trust.

## External System Classes

| Class | Examples | Default Posture |
| ----- | -------- | --------------- |
| Native local tools | Git, Cargo, Bun, Docker | Allowed when explicit and detected locally. |
| Remote registries | package registries, future pack registries | Explicit use; provenance required for trust. |
| AI providers | hosted model APIs, local model servers | Optional; provider port required. |
| Hosted projection | future Monad dashboard/control plane | Optional; explicit sync/export. |
| Policy services | future external policy engines | Optional adapter; local checks first. |
| Observability services | future dashboards or telemetry sinks | Opt-in only; no telemetry by default. |

## Governance Rules

- Core commands must not require external systems.
- External calls must be explicit or clearly configured.
- Credentials must not be required for local core behavior.
- External responses must be treated as untrusted until validated.
- Machine-readable contracts should be versioned where stable.
- External failures must produce actionable diagnostics.
- Remote state must not silently override local source of truth.

## Approval Triggers

Review is required when an external integration:

- uploads repository data;
- uses AI or provider credentials;
- changes local files;
- changes release evidence;
- changes policy results;
- requires network access in CI;
- introduces persistent remote state.

## Evidence

External integration evidence may include:

- contract docs;
- provider config docs;
- schema references;
- policy findings;
- sync/export reports;
- release evidence;
- threat model entries.

## Maintenance Notes

Keep this document aligned with no-telemetry, hosted projection, AI provider, pack/template, and plugin ADRs.
