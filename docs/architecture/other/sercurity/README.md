# Security Architecture

This directory documents Monad's security architecture notes for the requested path.

Note: the current directory name is `sercurity`. If this was intended to be `security`, it should be renamed in a separate cleanup change so links and references can be updated deliberately.

## Purpose

Security architecture for Monad focuses on protecting repository integrity, local-first privacy, safe mutation, extension trust boundaries, context redaction, and explicit network/AI behavior.

Security questions this area should answer:

- What files and paths are protected?
- What must never be uploaded by default?
- What mutation requires a plan?
- How are packs, templates, and plugins trusted?
- How is AI provider access controlled?
- How are secrets excluded from context artifacts?
- Which policy checks enforce security expectations?

## Related ADRs

- ADR-0003: Local-First Core
- ADR-0004: AI-Native but AI-Optional
- ADR-0006: Plan-Backed Mutation
- ADR-0010: Policy-as-Code
- ADR-0011: Deterministic Context Before AI Assistance
- ADR-0016: Pack and Template Trust Model
- ADR-0017: Plugin Execution and Trust Boundary
- ADR-0019: No Telemetry by Default
- ADR-0020: AI Provider Port and Noop Adapter

## Security Boundaries

| Boundary | Rule |
| -------- | ---- |
| Filesystem | Never write outside workspace root; protect user files; avoid unsafe symlink traversal. |
| Manifest | `monad.toml` is canonical and must not be silently overridden. |
| Generated state | `.monad/` is local/generated/cache/report/context/plan state unless explicitly promoted. |
| Context | Secrets and sensitive files are excluded by default. |
| Plans | Significant mutation is reviewable before apply. |
| Native tools | Monad coordinates native tools but should expose invocation and failure clearly. |
| Packs/templates | Source, version, trust level, and capabilities must be visible. |
| Plugins | Executable extension behavior is a trust boundary. |
| AI | Provider calls are optional, explicit, and adapter-based. |
| Telemetry | No telemetry by default. |

## Policy Expectations

Security policy checks may eventually cover:

- protected path writes;
- unsafe plan operations;
- missing redaction rules;
- network use in local commands;
- AI use without explicit provider configuration;
- untrusted pack/template sources;
- plugin capability violations;
- generated file ownership;
- manifest conflicts;
- stale or expired waivers.

## Threat Modeling Linkage

Detailed threat modeling belongs in:

- `docs/architecture/threat-modeling/README.md`

Security architecture should feed threat models, and threat model findings should feed policy rules, plan gates, and tests.

## Testing Expectations

Security tests should cover:

- path traversal rejection;
- writes outside root rejection;
- protected file handling;
- dry-run no-write behavior;
- context redaction;
- no-network/no-telemetry defaults;
- pack/template trust metadata;
- plugin permission checks when implemented.

## Maintenance Notes

Keep this directory aligned with ADRs, security docs, policy docs, and future threat-modeling artifacts. Rename the directory to `security` only through an explicit path cleanup commit.
