# Architecture Decision Record Index

This index lists the current Monad architecture decision records in `docs/architecture/adrs/`.

ADRs preserve durable architecture decisions that shape Monad's runtime, repository model, governance posture, safety model, AI boundaries, extensibility model, and hosted/local split.

## Status Model

| Status | Meaning |
| ------ | ------- |
| Accepted | Authoritative for current implementation and planning. |
| Proposed | Directionally approved for design discussion or implementation validation, but still open to refinement. |
| Superseded | Replaced by a later ADR. |
| Deprecated | Historically relevant but no longer recommended for new work. |
| Rejected | Considered and intentionally not chosen. |

## ADRs

| ADR | Title | Status | Theme |
| --- | ----- | ------ | ----- |
| [ADR-0001](ADR-0001_rust-single-binary-runtime.md) | Rust Single-Binary Runtime | Accepted | Runtime |
| [ADR-0002](ADR-0002_coordinate-native-tools-instead-of-replacing-them.md) | Coordinate Native Tools Instead of Replacing Them | Accepted | Tooling |
| [ADR-0003](ADR-0003_local-first-core.md) | Local-First Core | Accepted | Runtime / Privacy |
| [ADR-0004](ADR-0004_ai-native-but-ai-optional.md) | AI-Native but AI-Optional | Accepted | AI Safety |
| [ADR-0005](ADR-0005_monad-toml-is-the-canonical-manifest.md) | `monad.toml` Is the Canonical Manifest | Accepted | Source of Truth |
| [ADR-0006](ADR-0006_plan-backed-mutation.md) | Plan-Backed Mutation | Accepted | Safety |
| [ADR-0007](ADR-0007_modular-rust-workspace.md) | Modular Rust Workspace | Proposed | Code Architecture |
| [ADR-0008](ADR-0008_lifecycle-graph-as-core-model.md) | Lifecycle Graph as Core Model | Proposed | Domain Model |
| [ADR-0009](ADR-0009_documentation-as-code.md) | Documentation-as-Code | Proposed | Documentation |
| [ADR-0010](ADR-0010_policy-as-code.md) | Policy-as-Code | Proposed | Governance |
| [ADR-0011](ADR-0011_deterministic-context-before-ai-assistance.md) | Deterministic Context Before AI Assistance | Proposed | Context / AI Safety |
| [ADR-0012](ADR-0012_honest-placeholder-commands.md) | Honest Placeholder Commands | Accepted | CLI Trust |
| [ADR-0013](ADR-0013_versioned-machine-readable-output-schemas.md) | Versioned Machine-Readable Output Schemas | Proposed | Automation Contracts |
| [ADR-0014](ADR-0014_stable-cli-exit-code-taxonomy.md) | Stable CLI Exit Code Taxonomy | Proposed | CLI Automation |
| [ADR-0015](ADR-0015_local-graph-cache-is-rebuildable-generated-state.md) | Local Graph Cache Is Rebuildable Generated State | Proposed | Graph / Generated State |
| [ADR-0016](ADR-0016_pack-and-template-trust-model.md) | Pack and Template Trust Model | Proposed | Supply Chain / Trust |
| [ADR-0017](ADR-0017_plugin-execution-and-trust-boundary.md) | Plugin Execution and Trust Boundary | Proposed | Extensibility / Trust |
| [ADR-0018](ADR-0018_hosted-control-plane-is-optional-projection-layer.md) | Hosted Control Plane Is Optional Projection Layer | Accepted | Hosted Boundary |
| [ADR-0019](ADR-0019_no-telemetry-by-default.md) | No Telemetry by Default | Accepted | Privacy |
| [ADR-0020](ADR-0020_ai-provider-port-and-noop-adapter.md) | AI Provider Port and Noop Adapter | Proposed | AI Architecture |

## Dependency Map

```text
ADR-0001 Rust Single-Binary Runtime
  supports local-first execution, deterministic analysis, and plan-backed mutation

ADR-0002 Coordinate Native Tools Instead of Replacing Them
  constrains generator, adapter, pack, and plugin scope

ADR-0003 Local-First Core
  constrains hosted features, telemetry, context generation, and graph storage

ADR-0004 AI-Native but AI-Optional
  depends on deterministic context and provider boundaries

ADR-0005 monad.toml Is the Canonical Manifest
  supports root detection, config, check, doctor, graph, context, and plan workflows

ADR-0006 Plan-Backed Mutation
  constrains generators, packs, plugins, AI suggestions, migrations, and applies

ADR-0008 Lifecycle Graph as Core Model
  connects docs, ADRs, work packets, policies, plans, context, and release evidence

ADR-0012 Honest Placeholder Commands
  protects broad command-surface visibility from fake success

ADR-0018 Hosted Control Plane Is Optional Projection Layer
  preserves the local runtime as the foundation for future hosted views
```

## Maintenance Notes

- Add new ADRs with the next unused numeric ID.
- Do not reuse ADR numbers.
- Keep accepted ADRs stable; supersede with a new ADR when decisions materially change.
- Keep this index synchronized whenever ADR files are added, renamed, superseded, deprecated, or rejected.
- Prefer explicit status changes over silent edits to decision meaning.
