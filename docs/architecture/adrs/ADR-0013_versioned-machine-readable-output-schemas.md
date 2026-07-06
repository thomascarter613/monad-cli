---
id: ADR-0013
title: Versioned Machine-Readable Output Schemas
status: proposed
date: 2026-07-06
supersedes: []
superseded_by: null
tags: [output, schema, json, ci, compatibility, v1]
---

# ADR-0013: Versioned Machine-Readable Output Schemas

## Status

Proposed.

## Context

Monad is intended to serve both humans and automation. Human-readable terminal output is necessary for local developer workflows, but CI systems, scripts, future hosted projections, policy tools, AI context pipelines, and release evidence workflows require stable machine-readable output.

Many Monad commands will eventually expose structured data, including:

- command catalogs;
- diagnostics and findings;
- repository inspection reports;
- graph outputs;
- context manifests;
- policy reports;
- plan files;
- apply reports;
- documentation check reports;
- ADR and work packet indexes;
- release readiness evidence.

If machine-readable output is ad hoc, downstream tools will break whenever a field is renamed, removed, or reinterpreted. A governance-grade CLI needs explicit schema versioning so that users, CI systems, and future integrations can rely on stable contracts.

## Decision

Monad machine-readable outputs will use versioned schemas.

Commands that support `--format json` or another machine-readable format must include enough schema metadata for consumers to identify the output contract. The preferred shape is a top-level schema envelope for non-trivial outputs.

A typical envelope should include:

```json
{
  "schema": "monad.<domain>.<name>",
  "schema_version": "1.0.0",
  "monad_version": "0.1.0",
  "generated_at": "2026-07-06T00:00:00Z",
  "data": {}
}
```

Exact fields may vary by output type, but each stable machine-readable output must define:

- schema identity;
- schema version;
- output domain;
- compatibility expectations;
- required and optional fields;
- whether unknown fields may be ignored;
- whether the output is stable, preview, or experimental.

Human-readable output may evolve more freely. Machine-readable output requires compatibility discipline.

## Decision Drivers

This decision is driven by:

- **CI compatibility:** automation should not break from undocumented shape changes.
- **Governance:** policy, evidence, and release workflows need reliable structured data.
- **AI-readiness:** AI context pipelines benefit from stable JSON artifacts.
- **Hosted optionality:** future dashboards should consume local evidence through stable schemas.
- **Testing:** schemas make fixture tests and contract tests clearer.
- **Versioning:** schema changes should be explicit rather than accidental.
- **Trust:** users should know whether an output is stable enough for automation.

## Rationale

Monad's value depends on repeatable repository understanding. Structured outputs are how that understanding moves between commands, CI, reports, future hosted services, and AI context generators.

Versioned schemas make those outputs durable. They allow the project to evolve while giving consumers a compatibility contract. They also make it easier to distinguish stable output from preview output.

This ADR does not require perfect schemas for every command immediately. It requires that machine-readable output intended for consumption be versioned before users are expected to automate against it.

## Schema Stability Model

Monad should classify machine-readable outputs by maturity.

Recommended maturity levels:

- `experimental` — shape may change without compatibility promises;
- `preview` — shape is intended but may still change before stabilization;
- `stable` — compatibility rules apply;
- `deprecated` — supported temporarily but scheduled for removal or replacement.

Stable schemas should avoid breaking changes within the same major schema version.

Breaking changes include:

- removing required fields;
- changing field meaning;
- changing field type;
- changing enum values incompatibly;
- changing exit behavior tied to schema semantics;
- moving data without compatibility aliases.

Non-breaking changes may include:

- adding optional fields;
- adding new enum values when documented as extensible;
- adding metadata fields;
- adding new warning categories when consumers are told to tolerate unknown values.

## Implementation Guidance

Schema definitions should live in predictable repository paths once formalized, such as:

```text
schemas/
  command-catalog.schema.json
  findings.schema.json
  graph.schema.json
  context-manifest.schema.json
  plan.schema.json
  apply-report.schema.json
```

Recommended implementation steps:

1. Define shared output envelope conventions.
2. Mark early JSON output as experimental or preview unless stable.
3. Add schema identity and schema version to machine-readable outputs.
4. Add fixture tests for JSON output.
5. Add JSON Schema files for stable contracts.
6. Add compatibility tests before changing stable schemas.
7. Document output formats and stability levels.

Output schemas should be generated from or aligned with Rust types where practical, but the public schema contract matters more than internal representation.

## Consequences

### Positive Consequences

- CI and automation can rely on stable output contracts.
- JSON outputs become testable and documentable.
- Future hosted projection layers can consume local evidence consistently.
- AI context workflows can use structured data rather than scraping text.
- Breaking changes become explicit decisions.
- Users can distinguish preview outputs from stable outputs.

### Negative Consequences

- Schema versioning adds implementation overhead.
- Early commands may need to label outputs as experimental.
- Backward compatibility requires discipline.
- Public schemas may constrain internal refactoring.
- Documentation must keep up with output contracts.

### Required Mitigations

- Start with a small shared envelope.
- Mark immature outputs as experimental or preview.
- Add stable schemas only when output contracts are ready.
- Test schema fixtures.
- Document compatibility rules.
- Prefer additive changes when possible.

## Alternatives Considered

### Human Output Only

Monad could avoid machine-readable output early.

This was rejected because CI, policy, graph, context, plan, and release evidence workflows require structured data.

### Ad Hoc JSON Per Command

Each command could emit its own unversioned JSON shape.

This was rejected because ad hoc JSON becomes a hidden API without compatibility rules.

### Single Global Schema for Everything

Monad could define one large schema covering all outputs.

This was rejected because command domains differ. A shared envelope plus domain-specific schemas is more practical.

## Validation

This decision is validated when:

- machine-readable outputs include schema identity and version metadata;
- stable schemas are documented;
- JSON fixture tests exist for key commands;
- breaking schema changes require explicit review;
- consumers can distinguish experimental, preview, stable, and deprecated output;
- schema docs exist for command catalog, findings, graph, context, plan, and apply reports as those outputs stabilize.

## Review Criteria

This ADR should be reconsidered if schema versioning creates more overhead than compatibility value, or if another contract mechanism provides stronger stability for CLI automation.

## Related Decisions

This ADR relates to ADR-0012 Honest Placeholder Commands, ADR-0014 Stable CLI Exit Code Taxonomy, ADR-0008 Lifecycle Graph as Core Model, ADR-0010 Policy-as-Code, ADR-0011 Deterministic Context Before AI Assistance, and ADR-0006 Plan-Backed Mutation.
