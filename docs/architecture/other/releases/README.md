# Release Architecture

This directory documents Monad's release architecture.

Release architecture defines how Monad moves from local repository state to release readiness, release evidence, changelogs, versioned artifacts, and future hosted projection.

## Purpose

Release architecture should answer:

- What must be true before a release is ready?
- Which checks gate release readiness?
- Which ADRs, work packets, policies, tests, and plans are relevant?
- What release evidence is generated?
- Which artifacts are source, generated, or published?
- How do local release reports relate to future hosted dashboards?

## Related ADRs

- ADR-0003: Local-First Core
- ADR-0006: Plan-Backed Mutation
- ADR-0008: Lifecycle Graph as Core Model
- ADR-0009: Documentation-as-Code
- ADR-0010: Policy-as-Code
- ADR-0013: Versioned Machine-Readable Output Schemas
- ADR-0018: Hosted Control Plane Is Optional Projection Layer

## Release Evidence

Release evidence may include:

- version information;
- changelog entries;
- work packets included;
- ADRs referenced or added;
- tests run;
- policy findings;
- docs check status;
- graph consistency status;
- plan/apply reports;
- known risks and waivers;
- generated release notes;
- artifact checksums.

Evidence should be local-first and machine-readable where practical.

## Release Readiness Model

A release readiness check should evaluate:

- workspace manifest validity;
- command catalog status;
- tests, lint, and format status;
- docs and ADR/work-packet status;
- policy findings and waivers;
- unresolved plans or unsafe mutation state;
- release notes completeness;
- generated evidence availability.

## Expected Commands

```bash
monad release check
monad release notes
monad release evidence
```

Early commands may be planned or partial. Placeholder behavior must be honest.

## Source-of-Truth Rules

- Release intent belongs in versioned repository files.
- Generated evidence belongs under a documented generated/report path.
- Hosted release views are optional projections.
- Release reports should not silently change source files without a plan.

## Testing Expectations

Release tests should cover:

- readiness pass/fail scenarios;
- missing docs;
- failed policy gates;
- unresolved waiver behavior;
- evidence schema compatibility;
- generated release report determinism.

## Maintenance Notes

Keep this directory aligned with release governance docs, release evidence reference docs, work packets, and future `monad release` command behavior.
