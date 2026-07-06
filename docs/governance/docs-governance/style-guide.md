# Documentation Style Guide

This document defines writing and formatting guidance for Monad governance documentation.

## Goals

Monad documentation should be:

- clear;
- durable;
- traceable;
- implementation-aware;
- honest about maturity;
- easy to review in Git;
- useful to humans and future AI context generation.

## Voice and Tone

Use direct, plain language.

Prefer:

- "Monad will..." for accepted decisions.
- "Monad should..." for proposed guidance.
- "Future support may..." for roadmap items.
- "This document defines..." for governance docs.

Avoid:

- claiming implementation exists when it is planned;
- vague claims without source or decision reference;
- excessive marketing language;
- hidden assumptions.

## Headings

Use predictable heading structure.

Recommended common sections:

```markdown
# Title

## Purpose

## Scope

## Related ADRs

## Rules

## Testing Expectations

## Maintenance Notes
```

## Status Language

Use explicit maturity/status terms:

- Draft
- Proposed
- Accepted
- Active
- Superseded
- Deprecated
- Rejected
- Planned
- Preview
- Partial
- Implemented

Do not blur planned behavior with implemented behavior.

## Links

Prefer local relative links when referencing repository files.

Link to:

- ADRs;
- work packets;
- schemas;
- related governance docs;
- release evidence;
- policies;
- risk records.

Keep indexes synchronized when files move or are renamed.

## Tables

Use tables for maps, registers, controls, matrices, and status overviews.

Keep table rows concise. Move detailed explanation below the table when needed.

## Code Blocks

Use code blocks for:

- commands;
- file trees;
- schemas or snippets;
- deterministic examples.

Label code fences when useful:

```bash
monad docs check
```

## Generated Docs

Generated docs should state:

- that they are generated;
- source inputs;
- generation command where practical;
- timestamp or version if appropriate;
- whether they may be edited manually.

## Maintenance Notes

Update this guide when documentation conventions, ADR templates, work packet templates, or generated documentation behavior changes.
