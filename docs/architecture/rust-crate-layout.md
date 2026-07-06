# Rust Crate Layout

This document defines Monad's Rust workspace layout doctrine.

Monad is distributed as a Rust single-binary CLI, but the implementation should use modular crates when real domain boundaries justify extraction.

## Related ADRs

- ADR-0001: Rust Single-Binary Runtime
- ADR-0007: Modular Rust Workspace
- ADR-0006: Plan-Backed Mutation
- ADR-0010: Policy-as-Code
- ADR-0011: Deterministic Context Before AI Assistance
- ADR-0017: Plugin Execution and Trust Boundary
- ADR-0020: AI Provider Port and Noop Adapter

## Near-Term Layout

The near-term workspace may remain small:

```text
crates/
  monad-cli/
  monad-core/
```

This is acceptable while implementation boundaries are still forming.

## Candidate Long-Term Layout

Candidate long-term crates:

```text
crates/
  monad-cli/
  monad-core/
  monad-config/
  monad-inspect/
  monad-graph/
  monad-context/
  monad-docs/
  monad-policy/
  monad-plans/
  monad-fs/
  monad-native-tools/
  monad-packs/
  monad-ai/
  monad-hosted/
```

This list is directional. Do not create empty crates just because they are listed here.

## Crate Responsibilities

| Crate | Responsibility |
| ----- | -------------- |
| `monad-cli` | CLI parsing, dispatch, presentation, help text, and exit-code mapping. |
| `monad-core` | Shared foundational types, identifiers, diagnostics, and result contracts. |
| `monad-config` | Manifest loading, mirror handling, lockfile behavior, and config diagnostics. |
| `monad-inspect` | Read-only repository discovery and artifact classification. |
| `monad-graph` | Lifecycle graph model, exports, and invariants. |
| `monad-context` | Handoffs, context packs, manifests, redaction, and verification. |
| `monad-docs` | Docs-as-code, ADR/work-packet validation, and generated docs lineage. |
| `monad-policy` | Policy rules, findings, severities, explanations, waivers, and gates. |
| `monad-plans` | Plan schema, diff, dry-run, apply, reports, and stale-plan checks. |
| `monad-fs` | Safe filesystem operations and protected path rules. |
| `monad-native-tools` | Native tool discovery, invocation models, and normalized diagnostics. |
| `monad-packs` | Packs, templates, trust metadata, and install planning. |
| `monad-ai` | AI provider port, no-op adapter, provider adapters, and provenance. |
| `monad-hosted` | Optional hosted projection adapters and sync boundaries. |

## Dependency Rules

- `monad-cli` may depend on domain crates.
- Domain crates must not depend on `monad-cli`.
- Deterministic local crates must not depend on AI or hosted crates.
- AI and hosted crates may depend on core/context abstractions, not the reverse.
- Plan/apply may depend on filesystem safety, but filesystem safety should not depend on plan/apply.
- Circular dependencies are not allowed.

## Extraction Rules

Create a new crate when:

- the domain has meaningful behavior;
- it has tests or fixtures;
- it has a coherent public API;
- dependency isolation improves safety or clarity;
- the boundary supports local-first, AI-optional, or plan-backed doctrine.

Avoid a new crate when it would be empty, roadmap-only, premature, or better represented as a private module.

## Testing Expectations

Review and tests should guard:

- no domain dependency on `monad-cli`;
- no deterministic core dependency on AI or hosted crates;
- no circular dependencies;
- CLI smoke tests remain thin;
- domain logic can be tested without command parsing.

## Maintenance Notes

This document should evolve with implementation evidence. Practical modularity is the goal; premature crate explosion is not.
