---
id: ADR-0005
title: monad.toml Is the Canonical Manifest
status: accepted
date: 2026-07-02
supersedes: []
superseded_by: null
tags: [manifest, source-of-truth, configuration, drift, v1]
---

# ADR-0005: `monad.toml` Is the Canonical Manifest

## Status

Accepted.

## Context

Monad needs a clear source of truth for repository intent.

A serious monorepo contains many configuration and manifest files. Some describe language ecosystems. Some describe build and task tools. Some describe CI workflows. Some describe infrastructure. Some describe policy, documentation, generated state, or local runtime behavior.

Examples include:

- `Cargo.toml`;
- `package.json`;
- `bun.lock` or other package lockfiles;
- `turbo.json`;
- `moon.yml`;
- `.github/workflows/*.yml`;
- `workspace.toml`;
- `monad.toml`;
- `monad.lock`;
- `.monad/` state files.

Monad must distinguish between repository-native manifests and Monad's own canonical manifest. Native tool manifests remain authoritative for their own ecosystem concerns, but Monad needs a product-specific source of truth for workspace intent, governance metadata, managed repository structure, command expectations, policy wiring, generated artifact ownership, and lifecycle model assumptions.

Previous planning allowed compatibility mirrors such as `workspace.toml`, but competing manifests create drift and ambiguity. If two files can both claim to represent Monad workspace intent, commands such as `monad config`, `monad check`, `monad doctor`, `monad graph`, `monad context`, `monad plan`, and future mutation commands may resolve conflicting intent.

Without a single canonical manifest, Monad cannot reliably answer:

- where the workspace root is;
- which file records Monad-specific workspace intent;
- which file wins during conflict resolution;
- which file should be changed by `monad config`;
- which file should be validated by `monad check`;
- which file is source and which file is mirror or generated state;
- which fields should be synchronized into native manifests;
- how drift should be detected and remediated.

## Decision

`monad.toml` is the canonical Monad manifest.

`monad.toml` records Monad-specific workspace intent. It is the source of truth for Monad-managed workspace identity, conventions, governance expectations, managed units, source-of-truth configuration, and other durable Monad runtime settings.

`workspace.toml` may exist as a compatibility mirror only. It must not have equal canonical status with `monad.toml`. If `monad.toml` and `workspace.toml` conflict, `monad.toml` wins.

`monad.lock` records resolved state. It is not the source of author intent. It should reflect deterministic resolution of manifest data, generated metadata, tool detections, version pins, or future runtime resolution outputs where appropriate.

`.monad/` stores local, generated, cached, report, plan, graph, context, and temporary runtime state. `.monad/` must not become the canonical manifest location.

Native tool manifests remain native-tool source-of-truth files for their respective ecosystems. Monad may inspect, generate, validate, or synchronize native manifests, but it must not blur their role with Monad's canonical configuration.

## Decision Drivers

This decision is driven by the following needs:

- **Clear source of truth:** Monad needs exactly one canonical manifest for Monad-specific repository intent.
- **Deterministic resolution:** commands must resolve workspace intent the same way every time.
- **Drift prevention:** compatibility mirrors and native manifests must not silently diverge from canonical intent.
- **Human clarity:** users should know which file to edit when they want to change Monad behavior.
- **Command consistency:** `monad config`, `monad check`, `monad doctor`, `monad graph`, `monad context`, and `monad plan` need stable manifest rules.
- **Local-first operation:** canonical configuration should live in the repository and work without a service.
- **Generated-state separation:** cache and generated runtime files must not become source-of-truth files.
- **Native tool coordination:** Monad must coordinate native manifests without replacing their ecosystem authority.
- **Future migration support:** clear ownership rules make migrations and schema evolution safer.

## Rationale

`monad.toml` is explicit, product-specific, and easy to recognize. It clearly communicates that the file belongs to Monad and describes Monad workspace intent.

Using `workspace.toml` as canonical would be more ambiguous. A generic workspace file could be confused with unrelated tooling, custom repository metadata, or legacy conventions. It also weakens the product boundary: Monad should be able to identify its own source-of-truth file without guessing.

Using `.monad/` as the canonical source would blur source files with local runtime state. `.monad/` is better suited for generated artifacts, reports, caches, graphs, plans, context packs, and other derived files. Putting author intent there would make the repository harder to reason about and could encourage users to treat generated state as authoritative.

Keeping `monad.toml` canonical also supports the local-first and documentation-as-code doctrine. The manifest can be reviewed in version control, diffed in pull requests, validated in CI, and referenced from ADRs, work packets, and docs.

## Source-of-Truth Model

Monad should classify repository configuration into distinct categories.

### Canonical Monad Source

`monad.toml` is the canonical source for Monad workspace intent.

It may include or eventually include concepts such as:

- workspace identity;
- schema version;
- workspace conventions;
- package manager preference;
- managed units;
- governance settings;
- policy references;
- documentation expectations;
- graph and context settings;
- pack, template, and plugin declarations;
- source-of-truth and generated-file rules;
- default command behavior;
- migration metadata.

### Resolved Monad State

`monad.lock` records resolved state derived from the canonical manifest and runtime resolution.

It may include or eventually include:

- resolved schema versions;
- resolved packs, templates, and plugins;
- resolved managed units;
- checksums or fingerprints;
- tool resolution metadata;
- deterministic generated state inputs;
- compatibility-mirror state.

`monad.lock` should be treated like a lockfile: important for reproducibility, but not the primary file users edit to express intent.

### Local and Generated State

`.monad/` stores local runtime outputs and generated artifacts.

Possible subdirectories include:

- `.monad/cache/`;
- `.monad/tmp/`;
- `.monad/reports/`;
- `.monad/graphs/`;
- `.monad/plans/`;
- `.monad/context/`;
- `.monad/snapshots/`.

These files may be useful, but they must not silently override `monad.toml`.

### Compatibility Mirror

`workspace.toml` may exist for compatibility with previous planning or transitional workflows.

If supported, mirror behavior must be explicit:

- `monad.toml` wins on conflict;
- mirror-only repositories should produce clear diagnostics;
- mirror synchronization should be documented;
- `monad check` should detect drift;
- `monad doctor` may suggest remediation;
- future migration commands may convert mirror state into canonical `monad.toml`.

### Native Tool Manifests

Native manifests remain authoritative for their own tools.

Examples:

- `Cargo.toml` for Rust crates and Cargo workspace details;
- `package.json` for JavaScript package metadata;
- package lockfiles for package resolution;
- `turbo.json` or `moon.yml` for task runner configuration;
- `.github/workflows/*.yml` for GitHub Actions workflows;
- Docker, Terraform, Pulumi, or Nomad files for infrastructure concerns.

Monad may generate or synchronize these files when it owns the corresponding workflow, but it should do so through explicit plans and validation rules.

## Conflict Resolution Rules

Manifest resolution should follow these rules:

1. If `monad.toml` exists, it is canonical.
2. If `workspace.toml` also exists, it is treated as compatibility/mirror state.
3. If `monad.toml` and `workspace.toml` conflict, `monad.toml` wins.
4. If only `workspace.toml` exists, Monad should treat the repository as legacy or mirror-only and produce an actionable diagnostic.
5. If neither `monad.toml` nor a recognized legacy mirror exists, Monad should report that the repository is not initialized or cannot find a Monad workspace root.
6. `monad.lock` must not override `monad.toml` author intent.
7. `.monad/` state must not override `monad.toml` author intent.
8. Native manifests should be read as ecosystem facts and synchronized only through explicit rules.

## Implementation Guidance

The manifest loader should model manifest state explicitly rather than returning only a parsed configuration object.

A useful representation should distinguish:

- canonical manifest found;
- canonical manifest missing;
- mirror manifest found;
- mirror-only repository;
- canonical/mirror conflict;
- invalid manifest syntax;
- unsupported schema version;
- missing required fields;
- lockfile present or absent;
- local state present or absent;
- native manifest facts.

Diagnostics should be structured and actionable. A conflict should report which files conflict, which fields conflict, which value wins, and which command or manual action can repair the repository.

Mutation commands should update `monad.toml` when changing Monad intent. If mirror files are supported, mirror updates should be explicit and plan-backed. Native manifest updates should be separate plan operations with clear ownership and rationale.

`monad config` should read and write canonical configuration by default. Commands that inspect mirror or native configuration should say so explicitly.

Schema evolution should be versioned. Future migrations should preserve `monad.toml` as the canonical author-intent file while updating `monad.lock` and generated state as derived artifacts.

## Consequences

### Positive Consequences

- Monad has one clear source of truth for product-specific workspace intent.
- Manifest resolution becomes deterministic and testable.
- Drift detection is easier to define.
- `monad check` and `monad doctor` have clear rules for conflicts.
- Users know where to make durable configuration changes.
- Generated state and cache state remain separate from source files.
- Native tool coordination is clearer because native manifests are not confused with Monad intent.
- Future migrations, schema validation, and config commands have a stable foundation.

### Negative Consequences

- Repositories that previously used `workspace.toml` as a primary file require migration or compatibility handling.
- Users must understand the difference between canonical, mirror, native, lockfile, and generated state.
- Maintaining compatibility mirrors adds implementation and testing complexity.
- Some duplication may exist between `monad.toml` and native manifests until synchronization rules mature.
- A strict canonical manifest may feel more opinionated than a fully auto-detected model.

### Required Mitigations

- Document the manifest ownership model clearly.
- Add diagnostics for missing, invalid, mirror-only, and conflicting manifests.
- Add fixtures for manifest resolution edge cases.
- Provide migration or doctor remediation for `workspace.toml`-only repositories.
- Keep `.monad/` generated state inspectable and non-canonical.
- Treat native manifests as native facts and synchronize them through explicit, plan-backed operations.
- Avoid silently overwriting compatibility mirrors or native manifests.

## Alternatives Considered

### Use `workspace.toml` as Canonical

`workspace.toml` could be the canonical file for workspace intent.

This was rejected because the name is generic and less clearly tied to Monad. It also conflicts with the desire for an obvious product-specific source-of-truth file.

### Allow `monad.toml` and `workspace.toml` Equally

Both files could be treated as equal sources of truth.

This was rejected because equal canonical status creates drift. When both files exist and disagree, every command would need ambiguous resolution behavior. A governance-grade runtime needs stronger rules.

### Store Canonical Configuration Under `.monad/`

Monad could put canonical configuration in `.monad/config.toml` or a similar path.

This was rejected because `.monad/` is intended for local, generated, cached, report, context, plan, and runtime state. Canonical author intent should live at the repository root where it is visible, reviewable, and not confused with generated state.

### Infer Everything from Native Manifests

Monad could avoid a product-specific manifest and infer workspace intent from `Cargo.toml`, `package.json`, task runner files, CI files, and repository layout.

This was rejected because inference alone cannot reliably express Monad-specific governance intent, policy settings, generated-file ownership, future pack/template declarations, AI/context settings, or lifecycle model expectations.

## Validation

This decision is validated when:

- the workspace root can be resolved from `monad.toml`;
- `monad.toml` is read as the canonical Monad manifest;
- `workspace.toml` is treated as a compatibility mirror rather than equal source of truth;
- conflicts between `monad.toml` and `workspace.toml` are detected;
- conflict diagnostics clearly state that `monad.toml` wins;
- `monad.lock` is treated as resolved state, not author intent;
- `.monad/` state does not override canonical manifest values;
- `monad config` reads and writes canonical configuration by default;
- tests cover valid, missing, invalid, mirror-only, and conflicting manifest scenarios.

## Review Criteria

This ADR should be reconsidered only if:

- another manifest path becomes clearly superior for product, usability, or ecosystem reasons;
- the project intentionally removes a product-specific manifest and accepts inference-only behavior;
- a future workspace model supersedes root-level `monad.toml` with a stronger source-of-truth design;
- compatibility with existing repositories requires a different canonical path and the migration tradeoff is explicitly accepted.

A future ADR may refine schema structure, lockfile semantics, or mirror synchronization rules. It should not silently change which file is canonical without superseding this ADR.

## Related Decisions

This ADR relates to:

- ADR-0001, which establishes the Rust single-binary runtime;
- ADR-0002, which establishes native tool coordination over replacement;
- ADR-0003, which establishes local-first operation;
- ADR-0006, which establishes plan-backed mutation;
- future decisions about workspace root detection;
- future decisions about `monad.lock` semantics;
- future decisions about `.monad/` local state;
- future decisions about manifest schema versioning and migrations;
- future decisions about native manifest synchronization.
