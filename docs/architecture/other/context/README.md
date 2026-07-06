# Context Architecture

This directory documents Monad's context architecture.

Context artifacts support human handoff continuity, deterministic AI readiness, repository self-description, and future hosted projection without requiring AI, telemetry, or a network connection.

## Purpose

Monad context exists to answer:

- What should a future human or AI assistant know before helping?
- Which source files, docs, ADRs, work packets, policies, plans, and graph slices are relevant?
- What was included, excluded, summarized, redacted, or omitted?
- Which risks, gaps, placeholders, and constraints must be preserved?

Context generation must be useful without AI. AI providers may consume context later, but they must not be required to build it.

## Related ADRs

- ADR-0003: Local-First Core
- ADR-0004: AI-Native but AI-Optional
- ADR-0008: Lifecycle Graph as Core Model
- ADR-0009: Documentation-as-Code
- ADR-0011: Deterministic Context Before AI Assistance
- ADR-0019: No Telemetry by Default
- ADR-0020: AI Provider Port and Noop Adapter

## Context Artifact Types

| Artifact | Purpose |
| -------- | ------- |
| Handoff | Human-readable summary for continuing work across sessions. |
| Context pack | Structured bundle of selected repository knowledge. |
| Context manifest | Record of included, excluded, redacted, summarized, and omitted sources. |
| Graph slice | Lifecycle graph subset relevant to a question, work packet, release, or subsystem. |
| AI input bundle | Optional future provider input built from deterministic context artifacts. |

## Source-of-Truth Rules

- Context artifacts are generated state unless explicitly promoted to durable documentation.
- `monad.toml` remains the canonical Monad manifest.
- ADRs, work packets, docs, policies, and source files remain source artifacts.
- `.monad/context/` may store generated context outputs, manifests, and reports.
- Context output must not silently override source files.

## Safety Rules

Context generation must:

- work without AI;
- work without network access;
- respect ignore rules;
- exclude secrets and credentials by default;
- distinguish source, generated, cache, and local state;
- report limitations and missing data;
- make included/excluded paths inspectable where practical;
- avoid treating stale generated files as authoritative.

## Expected Commands

```bash
monad context handoff
monad context pack
monad context verify
```

Early implementations may expose only a subset, but placeholder behavior must be honest.

## Testing Expectations

Context tests should cover:

- redaction rules;
- ignore file handling;
- inclusion/exclusion manifests;
- missing docs or ADRs;
- generated state exclusion;
- deterministic output for fixture repositories;
- AI-disabled behavior.

## Maintenance Notes

Keep this directory aligned with the context/handoff blueprint when it is added. Context architecture must preserve deterministic-before-AI and no-telemetry-by-default doctrine.
