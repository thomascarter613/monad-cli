# Architecture Decision Records

This directory contains Monad's Architecture Decision Records (ADRs).

ADRs record durable decisions that shape the architecture, implementation strategy, governance model, safety posture, and long-term product direction of Monad.

The canonical ADR index is:

- [ADR Index](index.md)

## Purpose

Monad is intentionally broad: it is a Rust single-binary, local-first, governance-grade, AI-ready but AI-optional monorepo runtime and SDLC control plane.

Because the project spans CLI design, repository inspection, manifests, graph modeling, policy, documentation, plan-backed mutation, packs, plugins, AI boundaries, and optional hosted projection, major decisions must be explicit.

ADRs help prevent drift between competing directions such as:

- local-first versus hosted-first;
- deterministic runtime versus AI-first agent;
- native-tool coordination versus tool replacement;
- plan-backed mutation versus direct mutation;
- repository documentation versus external-only knowledge;
- reusable machine-readable contracts versus ad hoc output;
- optional telemetry versus silent data collection;
- safe extensibility versus arbitrary execution.

## File Naming

ADR files in this directory use this convention:

```text
ADR-NNNN_kebab-case-title.md
```

Examples:

```text
ADR-0001_rust-single-binary-runtime.md
ADR-0006_plan-backed-mutation.md
ADR-0019_no-telemetry-by-default.md
```

Rules:

- Use a four-digit ADR number.
- Do not reuse ADR numbers.
- Keep filenames stable after publication unless there is a clear cleanup reason.
- If a file is renamed, update `index.md` in the same change.
- Preserve old ADRs when superseded; do not delete historical decisions casually.

## ADR Statuses

Supported statuses:

| Status | Meaning |
| ------ | ------- |
| Proposed | Recommended or under active design; may still be refined. |
| Accepted | Authoritative for current implementation and planning. |
| Superseded | Replaced by a later ADR. |
| Deprecated | Historically relevant but should not guide new work. |
| Rejected | Considered and intentionally not chosen. |

Use lowercase status values in frontmatter where possible, matching the existing files:

```yaml
status: proposed
```

or:

```yaml
status: accepted
```

The body may render the status as title case for readability.

## ADR Structure

A complete ADR should generally include:

```markdown
---
id: ADR-NNNN
title: Decision Title
status: proposed
date: YYYY-MM-DD
supersedes: []
superseded_by: null
tags: [tag-one, tag-two]
---

# ADR-NNNN: Decision Title

## Status

Proposed.

## Context

What problem, pressure, or architectural constraint led to the decision?

## Decision

What has been decided?

## Decision Drivers

What needs, constraints, and priorities shaped the decision?

## Rationale

Why is this decision the right default for Monad?

## Implementation Guidance

How should future work apply the decision?

## Consequences

### Positive Consequences

### Negative Consequences

### Required Mitigations

## Alternatives Considered

What options were rejected, and why?

## Validation

How will we know the decision is being followed?

## Review Criteria

When should this decision be reconsidered?

## Related Decisions

Which ADRs does this decision depend on or constrain?
```

Some ADRs may add domain-specific sections such as `Policy Model`, `Plan Lifecycle`, `Output Formats`, or `Trust Levels` when useful.

## When to Create an ADR

Create an ADR when a decision materially affects:

- runtime architecture;
- crate/module boundaries;
- command surface contracts;
- source-of-truth rules;
- manifest or lockfile behavior;
- filesystem safety;
- plan/diff/apply behavior;
- graph or context models;
- documentation/governance lifecycle;
- policy and waiver behavior;
- AI provider boundaries;
- pack, template, or plugin trust;
- hosted/local boundary;
- telemetry/privacy posture;
- release, evidence, or compatibility contracts.

Do not create an ADR for every small implementation detail. Use ADRs for decisions that future contributors, tests, docs, or work packets should preserve.

## Updating ADRs

Accepted ADRs should be stable.

Acceptable edits:

- typo fixes;
- link fixes;
- formatting improvements;
- clarifying language that does not change the decision;
- index synchronization;
- metadata cleanup.

For material decision changes:

1. Create a new ADR with the next unused number.
2. Set the new ADR's `supersedes` field.
3. Update the old ADR's `superseded_by` field.
4. Mark the old ADR as `superseded` if appropriate.
5. Update `index.md`.

Do not silently rewrite accepted decisions to mean something different.

## Relationship to Work Packets

Work packets should reference relevant ADRs when they implement or depend on architectural decisions.

Example:

```markdown
## Related ADRs

- ADR-0005: `monad.toml` Is the Canonical Manifest
- ADR-0006: Plan-Backed Mutation
- ADR-0013: Versioned Machine-Readable Output Schemas
```

This keeps implementation traceable to architectural intent.

## Relationship to Monad Commands

Future Monad commands should be able to inspect this directory.

Expected future commands include:

```bash
monad adr list
monad adr check
monad adr show ADR-0006
monad docs check
monad context handoff
```

The ADR directory should therefore prefer predictable filenames, stable frontmatter, and consistent headings.

## Current ADR Set

The current set includes ADR-0001 through ADR-0020.

See [index.md](index.md) for the full list, statuses, themes, and dependency notes.
