---
id: ADR-0006
title: Plan-Backed Mutation
status: accepted
date: 2026-07-02
supersedes: []
superseded_by: null
tags: [mutation, safety, plan, dry-run, auditability, v1]
---

# ADR-0006: Plan-Backed Mutation

## Status

Accepted.

## Context

Monad is intended to do more than inspect repositories. Over time, it will add, remove, rename, move, generate, synchronize, migrate, upgrade, and repair repository artifacts.

Those operations are useful, but they are also risky. A monorepo runtime can affect source code, manifests, lockfiles, generated files, documentation, policies, work packets, ADRs, CI configuration, local state, native tool configuration, and future AI-generated change candidates.

Risky operations include:

- creating files;
- modifying files;
- deleting files;
- moving or renaming files;
- changing `monad.toml`;
- updating `monad.lock`;
- synchronizing native manifests;
- invoking package managers or generators;
- generating documentation;
- generating ADRs and work packets;
- installing packs or templates;
- applying policy remediations;
- accepting AI-suggested changes;
- migrating repository structure;
- updating CI, release, or infrastructure files.

Direct mutation would make Monad less trustworthy. Users should be able to inspect intended changes before they happen, understand why a change is proposed, review what files will be touched, and decide whether to apply the change.

Monad's broader doctrine already implies this: read-only before mutation, deterministic before intelligent, safety before convenience, no silent damage, and human approval before applied change.

## Decision

Repository mutation should be plan-backed by default.

A plan is an explicit, reviewable description of intended repository changes before those changes are applied. The mature mutation flow is:

```bash
monad plan ...
monad diff plan.json
monad apply plan.json --dry-run
monad apply plan.json --yes
```

A generated plan should list intended effects before mutation. A diff should show proposed changes in human-readable and machine-readable forms. A dry-run should simulate the apply without writing files. An approved apply should write only operations represented in the plan.

Commands that mutate repository state may offer convenience shortcuts, but those shortcuts should either generate and apply an internal plan transparently or remain limited to low-risk changes. Significant repository mutation must be expressible as a plan.

AI-suggested mutations must also become reviewable plans before apply. AI output must not directly mutate the repository outside the plan-backed boundary.

## Decision Drivers

This decision is driven by the following needs:

- **Safety:** users must know what Monad intends to change before files are modified.
- **Trust:** a governance-grade CLI must avoid surprising or silent destructive behavior.
- **Auditability:** mutation intent and applied changes should leave reviewable evidence.
- **CI compatibility:** planned changes can be checked, diffed, stored, and reviewed in automation.
- **AI safety:** AI-generated suggestions must pass through deterministic review and validation boundaries.
- **Repeatability:** a plan can be inspected, validated, and potentially re-applied or replayed under controlled conditions.
- **Policy enforcement:** planned operations can be checked against protected-file rules and policy gates before apply.
- **Dry-run support:** users need a safe preview mode for mutating workflows.
- **Separation of concerns:** planning and applying can be implemented, tested, and reasoned about independently.

## Rationale

Monad's long-term value depends on user confidence. A repository runtime that can change files must be more cautious than an ordinary generator. It must be able to explain both intent and effect.

Plan-backed mutation provides a safety boundary. Planning answers: what would happen? Diffing answers: what would change? Dry-run answers: can this be applied safely without writing? Applying answers: did the approved operations execute as expected?

This boundary also supports future governance features. Plans can be validated against policy, protected paths, ownership rules, work packet scope, ADR requirements, dependency graph constraints, and generated-file ownership. Plans can also be attached to reviews, reports, releases, or future audit evidence.

Plan-backed mutation is especially important for AI-assisted workflows. AI may suggest useful changes, but suggestions must not bypass deterministic safety rules. Converting AI suggestions into plans keeps human review, policy checks, and filesystem protection in control.

## Scope of the Decision

This ADR applies to mutating workflows such as:

- `monad add`;
- `monad remove`;
- `monad rename`;
- `monad move`;
- `monad generate` when it writes files;
- `monad sync --write`;
- `monad migrate`;
- `monad upgrade`;
- `monad clean` when it deletes state;
- `monad config set` and related configuration writes;
- `monad docs generate` when it writes files;
- `monad adr new` and ADR updates;
- `monad workpacket new` and work packet updates;
- pack/template/plugin installation when it changes repository state;
- AI-suggested repository changes.

This ADR does not require every read-only command to generate a plan. Inspection, graphing, validation, listing, explaining, and reporting commands should remain non-mutating and may not need plan artifacts.

This ADR also does not prohibit simple commands from offering direct convenience behavior, but direct behavior must still obey filesystem safety rules and should not become the default for complex changes.

## Plan Model

A plan should represent intended change in a structured way.

A mature plan may include:

- plan identifier;
- plan schema version;
- operation type;
- command that produced the plan;
- user-supplied inputs;
- repository root;
- workspace identity;
- related work packet or ADR references;
- preconditions;
- affected paths;
- protected path checks;
- native tool invocations;
- file create/update/delete/move operations;
- expected before/after fingerprints;
- generated diff previews;
- policy findings;
- warnings and risk level;
- rollback hints;
- approval requirements;
- AI provenance when applicable;
- timestamps where appropriate;
- apply report reference once executed.

The exact schema can evolve, but the core idea must remain: a plan records intent before mutation.

## Plan Lifecycle

The expected lifecycle is:

1. **Create:** a command produces a candidate plan from repository state and user intent.
2. **Validate:** Monad validates plan schema, preconditions, protected paths, and policy constraints.
3. **Review:** the user or CI reviews the plan and diff.
4. **Dry-run:** Monad simulates apply behavior without writing files.
5. **Approve:** the user provides explicit approval, such as `--yes`, an interactive confirmation, or a future policy gate.
6. **Apply:** Monad performs only the approved operations in the plan.
7. **Report:** Monad records what happened, including successes, failures, skipped operations, and resulting diagnostics.
8. **Verify:** follow-up checks can confirm that repository state matches expected outcomes.

A failed apply should stop safely and report partial effects. Future rollback support may use plan and report metadata, but rollback is not a substitute for review-before-apply.

## Filesystem Safety Rules

The plan/apply engine should enforce filesystem safety rules such as:

- never write outside the repository root unless explicitly allowed;
- normalize paths before checking safety;
- reject path traversal attempts;
- distinguish create, overwrite, append, delete, move, and chmod-like operations;
- avoid overwriting user-owned files without explicit policy;
- detect existing files before create operations;
- avoid deleting unknown user files by default;
- protect canonical manifests, lockfiles, policies, ADRs, and work packets according to command scope;
- avoid following unsafe symlink paths without explicit handling;
- surface conflict diagnostics before apply;
- ensure dry-run uses the same validation path as apply.

Filesystem safety should live behind a controlled boundary rather than scattered direct writes across command handlers.

## Implementation Guidance

Planning and applying should be separate concerns.

Recommended boundaries:

- plan domain model;
- plan schema versioning;
- plan renderer for human-readable output;
- plan serializer for machine-readable output;
- diff renderer;
- policy/precondition validator;
- filesystem operation model;
- native tool invocation model;
- dry-run executor;
- apply executor;
- apply report model;
- protected-file and path safety layer.

Command handlers should describe desired operations and ask the planning layer to build a plan. They should not directly mutate the repository for complex changes.

The apply layer should not infer new operations that were not present in the plan. If repository state changes between planning and apply, the apply layer should detect stale preconditions and stop or request a new plan.

Machine-readable plan output should be stable enough for CI and tests. Human-readable plan output should be clear enough for a developer to review before approving.

## Consequences

### Positive Consequences

- Repository mutation becomes safer and more trustworthy.
- Users can review intended changes before they happen.
- Dry-run behavior becomes a first-class workflow.
- Plans provide a basis for audit evidence.
- CI can validate plans without applying them.
- Policy gates can evaluate intended operations before mutation.
- AI suggestions can be constrained by deterministic plan validation.
- Apply behavior can be tested independently from plan generation.
- Future rollback, evidence, and approval workflows become easier to design.

### Negative Consequences

- Implementation complexity increases.
- Simple workflows may feel more ceremonial.
- A plan schema must be designed, versioned, and maintained.
- Some native tools do not provide clean dry-run or preview semantics.
- Users may still expect direct generator-like behavior for common tasks.
- Partial apply failures require careful reporting.
- Stale plans introduce validation and user-experience complexity.

### Required Mitigations

- Provide clear human-readable plan summaries.
- Provide machine-readable plan output for CI and tests.
- Support `--dry-run` consistently for mutating commands where practical.
- Allow carefully designed convenience flows while preserving an internal plan boundary.
- Add strong tests for filesystem safety and protected paths.
- Validate preconditions again during apply.
- Make stale-plan and conflict diagnostics actionable.
- Keep direct file writes behind a shared filesystem safety layer.
- Ensure AI-suggested changes become plans before apply.

## Alternatives Considered

### Direct Mutation Commands

Monad could make commands directly create, modify, move, or delete files immediately.

This was rejected as the default because direct mutation weakens trust, makes previews harder, reduces auditability, and increases the chance of accidental damage.

### Interactive Prompts Without Plans

Monad could ask users for confirmation before mutating files but avoid explicit plan artifacts.

This was rejected because prompts alone are not enough for CI, auditability, repeatability, AI safety, or structured policy checks. A prompt says the user approved something, but a plan records what was approved.

### Git-Only Rollback

Monad could rely on Git to recover from unwanted changes.

This was rejected as sufficient because users still need to know what Monad intends before mutation. Git is useful as a safety net, but it does not replace plan review, dry-run, protected path checks, or policy gates.

### Template-Only Generation

Monad could restrict itself to initial template generation and avoid later mutation workflows.

This was rejected because Monad's intended value includes evolving, checking, documenting, synchronizing, and governing a repository over time, not merely creating a starter scaffold.

## Validation

This decision is validated when:

- mutating commands can produce reviewable plans;
- significant repository changes support `--dry-run` or an equivalent preview;
- `monad apply` performs only operations represented in the approved plan;
- plans include affected paths and operation types;
- plan validation detects unsafe paths and protected-file violations;
- stale plans are detected before apply;
- applied plans produce reports or diagnostics;
- tests cover create, update, delete, move, conflict, dry-run, protected path, and stale-state scenarios;
- AI-generated changes are represented as candidate plans before mutation.

## Review Criteria

This ADR should be reconsidered only if:

- plan-backed mutation proves too heavy for the product and a safer alternative is accepted;
- Monad intentionally narrows scope to read-only inspection and no longer mutates repositories;
- a future transactional workspace model supersedes the current plan/apply architecture;
- a later ADR defines a stronger safety model that replaces this one.

Convenience shortcuts may be added without superseding this ADR if they still preserve reviewability, dry-run behavior, or an internal plan boundary for significant changes.

## Related Decisions

This ADR relates to:

- ADR-0001, which establishes the Rust single-binary runtime;
- ADR-0002, which establishes native tool coordination over replacement;
- ADR-0003, which establishes local-first operation;
- ADR-0004, which establishes AI-native but AI-optional behavior;
- ADR-0005, which establishes `monad.toml` as canonical manifest;
- future decisions about filesystem safety and protected-file policy;
- future decisions about plan schema and apply reports;
- future decisions about AI-suggested plan creation;
- future decisions about policy gates, waivers, and audit evidence.
