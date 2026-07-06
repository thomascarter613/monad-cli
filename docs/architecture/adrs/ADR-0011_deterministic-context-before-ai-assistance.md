---
id: ADR-0011
title: Deterministic Context Before AI Assistance
status: proposed
date: 2026-07-02
supersedes: []
superseded_by: null
tags: [context, ai-safety, deterministic, handoff, redaction, v1]
---

# ADR-0011: Deterministic Context Before AI Assistance

## Status

Proposed.

## Context

AI assistants need repository context. Without context, they guess. With unmanaged context, they can still mislead users by seeing the wrong files, missing constraints, including stale information, ignoring governance artifacts, or omitting safety boundaries.

Unmanaged context can:

- leak secrets;
- omit project constraints;
- misrepresent current state;
- include stale documentation;
- ignore ADRs;
- miss active work packets;
- overlook policies;
- overlook protected files;
- omit command status metadata;
- include generated or cache files as if they were source;
- exceed model limits;
- encourage unsafe mutation;
- make later audit impossible.

Monad is AI-native but AI-optional. That means Monad should make AI assistance safer without requiring AI for core correctness. The safest path is to generate deterministic context before any AI provider is involved.

Context generation is useful even without AI. It helps humans hand off work between sessions, collaborators, maintainers, CI workflows, and future tools. A deterministic handoff can describe repository status, known gaps, active decisions, work packets, risks, command surface, and relevant artifacts without relying on a model to infer them.

## Decision

Monad will first generate deterministic context packs and handoffs without AI.

AI assistance can later consume these artifacts, but AI must not be required to create them. Context generation should work locally, offline, and without a provider key.

Context generation should:

- work offline;
- require no AI provider;
- respect ignore rules;
- exclude known secret files;
- distinguish source, generated, cache, and local state files;
- report included and excluded files where practical;
- include repository identity;
- include command surface and command status;
- include relevant ADRs;
- include relevant work packets;
- include relevant docs and governance artifacts;
- include known risks, placeholders, missing data, and limitations;
- include manifest and source-of-truth information;
- include policy and safety constraints where available;
- produce human-readable and machine-readable artifacts over time.

AI provider integration should come only after deterministic context generation, redaction, and verification exist. AI should consume context; it should not be the authoritative mechanism for discovering repository truth.

## Decision Drivers

This decision is driven by the following needs:

- **Safety:** AI should receive curated, redacted, source-referenced context rather than arbitrary repository contents.
- **Determinism:** context should be reproducible from repository state without model interpretation.
- **Local-first operation:** context generation must work without network access or hosted services.
- **AI optionality:** handoffs should be useful even when AI is disabled or unavailable.
- **Privacy:** context generation must avoid leaking secrets and sensitive files by default.
- **Traceability:** context should reference source artifacts so users can verify claims.
- **Continuity:** context packs and handoffs should support work across sessions and collaborators.
- **Governance:** ADRs, policies, work packets, command status, and known risks should be represented.
- **Auditability:** generated context should explain what it included, excluded, and could not determine.

## Rationale

AI workflows are only as safe as the context they receive. If the context is ad hoc, stale, or overbroad, AI output becomes less trustworthy. Deterministic context generation gives Monad a safer foundation for both human handoffs and future AI assistance.

A deterministic context pack can be inspected by humans, tested in fixtures, generated in CI, and diffed over time. It can include explicit caveats, missing data, source references, known risks, and command status metadata. This makes it more reliable than asking an AI model to infer the repository state directly from a file dump.

The context-first model also supports local-first and privacy principles. Users can decide what to share with an AI provider after reviewing the context. A context pack can be redacted, scoped, and verified before any external call occurs.

This ADR complements the AI-native but AI-optional decision. AI may explain, summarize, or suggest changes later, but deterministic context must come first.

## Scope of the Decision

This ADR applies to:

- context handoff generation;
- context pack generation;
- context manifests;
- included/excluded file reporting;
- context verification;
- context redaction;
- AI-readable repository summaries;
- session handoff artifacts;
- future prompt template inputs;
- future AI provider boundaries.

This ADR does not require live AI integration. It requires context generation to be valuable before live AI integration exists.

## Context Artifact Model

Monad may generate multiple context artifact types over time.

### Handoff Document

A handoff document is a human-readable summary that helps a future session, maintainer, collaborator, or AI assistant understand current state.

It may include:

- repository identity;
- current implementation status;
- recent changes;
- active work packet;
- relevant ADRs;
- command surface status;
- known failing tests or missing features;
- risks and constraints;
- next recommended work;
- important file paths;
- safety constraints.

### Context Pack

A context pack is a structured bundle of selected repository information.

It may include:

- manifest data;
- command catalog data;
- documentation excerpts;
- ADR summaries;
- work packet summaries;
- lifecycle graph slices;
- policy findings;
- plan summaries;
- file inventory;
- source references;
- inclusion/exclusion manifest;
- redaction report.

### Context Manifest

A context manifest records what was included, excluded, summarized, or omitted.

It may include:

- context schema version;
- generation command;
- timestamp;
- repository root or identity;
- included paths;
- excluded paths;
- exclusion reasons;
- redaction actions;
- size limits;
- missing data warnings;
- source references;
- checksums or fingerprints where useful.

## Redaction and Inclusion Rules

Context generation should be conservative by default.

It should avoid including:

- secrets;
- credentials;
- private keys;
- `.env` files unless explicitly allowed;
- build outputs;
- dependency directories;
- caches;
- binary artifacts;
- large generated files;
- local temporary files;
- files excluded by `.gitignore`, `.monadignore`, `.copilotignore`, `.cursorignore`, or future context-specific ignore rules where appropriate.

Context generation should prefer including:

- `monad.toml`;
- relevant source-of-truth docs;
- ADRs;
- work packets;
- command catalog summaries;
- testing and security docs;
- policy summaries;
- lifecycle graph summaries;
- explicit known gaps and limitations.

Users should be able to inspect context output before sharing it externally.

## Implementation Guidance

Recommended implementation steps:

1. Build `monad context handoff` as deterministic local output.
2. Add context artifact schema/versioning.
3. Add context manifest with included/excluded paths.
4. Add redaction rules for known sensitive files.
5. Add ignore-rule support.
6. Add context verification.
7. Add context pack generation.
8. Add lifecycle graph slices as context input.
9. Add prompt template support only after deterministic context exists.
10. Add AI provider adapters only after context and redaction boundaries are tested.

Context generation should consume structured facts from repository inspection, manifest loading, documentation validation, ADR/work packet discovery, lifecycle graph generation, and policy checks. It should not rely on AI to decide what the repository is.

## Consequences

### Positive Consequences

- Context generation is useful without AI.
- AI workflows become safer and more grounded.
- Human handoffs become repeatable and reviewable.
- Context artifacts can be generated locally and offline.
- Users can inspect and redact context before sharing it.
- Session continuity improves.
- Repository state can be summarized from deterministic sources.
- AI provider integration can remain optional and adapter-based.

### Negative Consequences

- Deterministic summaries may be less polished than AI-generated prose.
- Context relevance rules require iteration.
- Context size management can become difficult.
- Redaction rules must be maintained.
- Inclusion/exclusion reports add implementation complexity.
- Users may expect AI-like summarization before AI integrations exist.

### Required Mitigations

- Start with useful, honest handoff output rather than perfect summaries.
- Clearly report missing or uncertain data.
- Add redaction and ignore rules early.
- Make included/excluded file reporting inspectable.
- Keep context generation local-first and no-network-by-default.
- Add verification tests with fixture repositories.
- Use AI only after deterministic context boundaries are stable.

## Alternatives Considered

### AI-Generated Context Only

Monad could ask an AI model to inspect repository files and generate context.

This was rejected because AI should not be required for context generation, and AI-generated context can hallucinate, omit constraints, leak sensitive content, or misrepresent repository state.

### Manual Handoff Docs Only

Monad could rely on users to manually write handoff documents.

This was rejected because manual handoffs drift, vary in quality, omit important constraints, and are difficult to verify. Manual notes may supplement generated handoffs, but they should not be the only model.

### No Context Feature

Monad could avoid context generation entirely.

This was rejected because context handoff is central to Monad's value for humans and AI-assisted workflows. Repository understanding, lifecycle graphing, documentation-as-code, and policy checks become more useful when they can feed context artifacts.

### Raw File Bundle

Monad could create a bundle of repository files without summarization, redaction, or provenance.

This was rejected because raw bundles are risky, noisy, and hard to review. Deterministic context should be curated, source-referenced, and redaction-aware.

## Validation

This decision is validated when:

- `monad context handoff` can run without AI;
- context generation can run without network access;
- generated context includes repository identity and relevant governance artifacts;
- context output reports known limitations or missing data;
- sensitive files are excluded by default;
- included/excluded paths are inspectable where practical;
- context artifacts are useful to humans before AI integration exists;
- future AI provider adapters consume deterministic context rather than raw repository discovery;
- tests cover redaction, ignore rules, missing files, generated state exclusion, and handoff generation.

## Review Criteria

This ADR should be reconsidered if:

- deterministic context generation proves insufficient for meaningful handoffs;
- AI-assisted context generation becomes safe enough to supersede deterministic context as the primary model;
- context generation creates privacy risk that cannot be mitigated with redaction and verification;
- another context model provides stronger local-first safety and traceability.

Because this ADR is Proposed, exact context schemas and artifact formats may evolve. The protected principle is deterministic, reviewable, local context before AI assistance.

## Related Decisions

This ADR relates to:

- ADR-0003, which establishes local-first core behavior;
- ADR-0004, which establishes AI-native but AI-optional behavior;
- ADR-0008, which establishes lifecycle graph as a core model;
- ADR-0009, which establishes documentation-as-code;
- ADR-0010, which establishes policy-as-code;
- future decisions about prompt templates, AI provider adapters, context redaction, and AI audit metadata.
