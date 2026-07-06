# AI Assistance Governance

This document defines governance for AI-assisted Monad workflows.

Monad is AI-native but AI-optional. AI assistance may help explain, draft, summarize, or propose, but it must not become authoritative or required for core correctness.

## Purpose

AI assistance governance ensures that AI use is:

- explicit;
- optional;
- redaction-aware;
- provider-agnostic;
- reviewable;
- non-authoritative;
- bounded by policy and plan/apply safety.

## Governance Rules

- Core commands must work without AI.
- AI provider calls must be explicit or configured.
- AI provider use must go through the AI provider port.
- A no-op adapter must support disabled AI behavior.
- Context must be deterministic and redacted before provider use.
- AI-generated mutation must become a candidate plan, not direct apply.
- AI-generated documentation must be reviewed before becoming source.
- Provider credentials must not be required for local core workflows.

## AI Output Classes

| Output | Authority |
| ------ | --------- |
| Explanation | Informational only. |
| Summary | Informational; verify against source. |
| Draft doc | Requires review before source status. |
| Candidate plan | Requires plan validation and approval. |
| Policy suggestion | Requires policy owner review. |
| Release note draft | Requires release steward review. |

## Testing Expectations

Tests should cover:

- no-AI operation;
- no-op adapter behavior;
- missing provider configuration;
- redaction before provider calls;
- AI output provenance;
- AI candidate plan validation.

## Maintenance Notes

Update this document when AI provider adapters, prompt/context formats, redaction rules, or AI-assisted command workflows change.
