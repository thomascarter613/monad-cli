---
id: ADR-0017
title: Plugin Execution and Trust Boundary
status: proposed
date: 2026-07-06
supersedes: []
superseded_by: null
tags: [plugins, trust-boundary, execution, safety, extension, v1]
---

# ADR-0017: Plugin Execution and Trust Boundary

## Status

Proposed.

## Context

Monad may eventually support plugins that extend behavior beyond built-in commands, packs, templates, and native tool adapters. Plugins could add custom checks, generators, policies, output formats, integrations, or organization-specific workflows.

Plugins are more powerful and riskier than static templates. A plugin may execute code, inspect repository contents, call tools, use network access, produce plans, evaluate policy, or integrate with external systems.

Because Monad is local-first and governance-grade, plugin execution must not be treated as ordinary configuration. It is a trust boundary.

## Decision

Plugin execution must be explicit, permissioned, and isolated from core deterministic behavior.

Plugins must not be required for core Monad functionality. The core CLI must remain useful without plugins. Deterministic local workflows such as manifest loading, inspection, graph generation, docs checks, context handoff, policy checks, and plan validation should not depend on arbitrary plugin execution.

Before a plugin can run, Monad should know:

- plugin identity;
- version;
- source;
- trust level;
- requested capabilities;
- whether it can read files;
- whether it can write files through plans;
- whether it can invoke native tools;
- whether it can access network;
- whether it can use AI providers;
- whether it is allowed in CI;
- what outputs it can produce.

Plugin-generated repository changes must go through plan-backed mutation. Plugins must not directly bypass filesystem safety.

## Decision Drivers

This decision is driven by:

- **Safety:** plugins can execute arbitrary or semi-arbitrary logic.
- **Local-first trust:** users must know when external code is running locally.
- **Core reliability:** core workflows must not depend on plugin behavior.
- **Policy enforcement:** organizations may need to allow, deny, or restrict plugins.
- **Filesystem safety:** plugin writes must be plan-backed.
- **Supply-chain risk:** plugin source and version matter.
- **AI/network boundaries:** plugin use of AI or network must be explicit.

## Rationale

Plugins can make Monad extensible, but premature plugin architecture can weaken the core product. Monad first needs stable domain models, command metadata, policy findings, graph semantics, and plan/apply safety.

A plugin boundary should be introduced only after the core runtime can define what plugins are allowed to extend. Otherwise plugins become an escape hatch around missing architecture.

This ADR separates plugins from packs/templates. Packs and templates primarily generate files or metadata. Plugins execute behavior. Execution requires stronger trust controls.

## Plugin Capability Model

Possible plugin capabilities include:

- read repository files;
- read generated state;
- emit diagnostics;
- emit graph nodes or edges;
- emit policy findings;
- create candidate plans;
- invoke native tools;
- use network access;
- use AI providers;
- write local cache;
- request file mutation through plan/apply.

Capabilities should be explicit and policy-checkable. High-risk capabilities should require user approval or organization policy approval.

## Execution Rules

Plugin execution should follow these rules:

- no plugin execution by default for core commands unless configured;
- plugin source and version must be visible;
- plugin capabilities must be declared;
- file writes must go through plans;
- network and AI access must be explicit;
- plugin failures must not corrupt core state;
- plugin outputs must be distinguishable from core outputs;
- plugins must not silently alter canonical manifests;
- plugins must not override core policy or safety checks.

## Implementation Guidance

Recommended implementation steps:

1. Stabilize core command, manifest, graph, policy, and plan models first.
2. Define plugin metadata schema.
3. Define plugin capability model.
4. Add plugin discovery without execution.
5. Add plugin allow/deny policy checks.
6. Add safe plugin execution for low-risk diagnostic plugins.
7. Add plan-backed plugin mutation later.
8. Add network/AI permissions only after explicit policy support exists.

Potential execution models may include external process plugins, WASM plugins, or restricted adapter interfaces. The execution model should be chosen in a future ADR after requirements are clearer.

## Consequences

### Positive Consequences

- Monad can become extensible without sacrificing core trust.
- Core workflows remain deterministic and plugin-independent.
- Plugin risks are visible and policy-checkable.
- File mutation remains plan-backed.
- Future organization-specific integrations have a safe boundary.

### Negative Consequences

- Plugin support will arrive later than templates and built-in behavior.
- Capability modeling adds complexity.
- Sandboxing or process isolation may require significant design work.
- Some users may want plugins before the trust model is ready.

### Required Mitigations

- Do not rush plugin execution.
- Keep packs/templates separate from executable plugins.
- Require explicit plugin metadata.
- Keep plugin writes behind plan/apply.
- Make network and AI capabilities explicit.
- Add policy gates before high-risk plugin capabilities.

## Alternatives Considered

### Plugin-First Architecture

Rejected because plugin architecture should not precede core trust and safety models.

### No Plugins Ever

Rejected because extension will likely be valuable for organizations and advanced users.

### Arbitrary Script Plugins

Rejected as the default because unrestricted scripts would bypass Monad safety boundaries.

### Treat Plugins Like Templates

Rejected because executable behavior has a stronger trust boundary than static generation.

## Validation

This decision is validated when:

- core Monad workflows work with no plugins;
- plugin metadata can describe source, version, and capabilities;
- plugin execution is explicit;
- plugin-generated mutations become plans;
- policy can restrict plugin execution and capabilities;
- plugin output is distinguishable from core output.

## Review Criteria

This ADR should be reconsidered if Monad chooses a specific plugin runtime that materially changes the trust boundary, such as WASM-only plugins or external-process-only plugins.

## Related Decisions

This ADR relates to ADR-0016 Pack and Template Trust Model, ADR-0006 Plan-Backed Mutation, ADR-0010 Policy-as-Code, ADR-0007 Modular Rust Workspace, ADR-0019 No Telemetry by Default, and ADR-0020 AI Provider Port and Noop Adapter.
