# CLI Doctrine

Monad is a Rust single-binary CLI for serious monorepo management and local-first SDLC control-plane workflows.

This doctrine defines how Monad commands should behave so users, CI systems, future AI agents, and hosted projection layers can trust the CLI surface.

## Core Doctrine

```text
Commands that inspect should not mutate.
Commands that mutate should be plan-backed where practical.
Commands that produce changes should be reviewable before apply.
Commands that apply plans should be auditable.
Commands used in CI should support machine-readable output.
Commands that are incomplete should be honest.
Commands that use network or AI should say so explicitly.
```

## Related ADRs

- ADR-0001: Rust Single-Binary Runtime
- ADR-0002: Coordinate Native Tools Instead of Replacing Them
- ADR-0003: Local-First Core
- ADR-0004: AI-Native but AI-Optional
- ADR-0005: `monad.toml` Is the Canonical Manifest
- ADR-0006: Plan-Backed Mutation
- ADR-0012: Honest Placeholder Commands
- ADR-0013: Versioned Machine-Readable Output Schemas
- ADR-0014: Stable CLI Exit Code Taxonomy
- ADR-0019: No Telemetry by Default

## Command Honesty

A command must not claim more than it actually does.

Placeholder, planned, preview, or partial commands must:

- state their status;
- avoid fake success;
- avoid hidden mutation;
- avoid network and AI calls unless explicitly documented;
- use documented exit behavior;
- expose status through command metadata where practical.

## Mutation Doctrine

Mutating commands should follow this lifecycle:

```bash
monad plan ...
monad diff plan.json
monad apply plan.json --dry-run
monad apply plan.json --yes
```

Rules:

- dry runs write nothing;
- conflicts are reported before writes;
- protected paths are checked before apply;
- user-modified files are not silently overwritten;
- AI-suggested changes become candidate plans before mutation;
- applied plans produce diagnostics or reports.

## Tooling Doctrine

```text
Monad owns intent.
Native tools own execution.
Monad coordinates, validates, explains, and documents.
```

Monad should not replace ecosystem tools by default. It should detect, invoke, validate, and normalize native tools behind clear adapters.

## Output Doctrine

Human-readable output should be clear and honest.

Machine-readable output should be:

- versioned once stable;
- schema identifiable;
- CI-friendly;
- consistent with exit codes;
- explicit about warnings, findings, and limitations.

## Local-First Doctrine

Core commands should not require:

- hosted services;
- AI providers;
- telemetry;
- external databases;
- network access;
- organization accounts.

Network-aware or hosted commands may exist later, but they must be explicit and optional.

## Failure Doctrine

Failure is part of the command contract.

Commands should:

- use stable exit categories;
- prefer actionable diagnostics;
- distinguish user input errors from repository validation failures;
- distinguish policy failures from runtime faults;
- distinguish placeholders from real checks;
- include machine-readable outcome metadata where practical.

## Testing Doctrine

Command tests should verify:

- command catalog alignment;
- placeholder honesty;
- no mutation in read-only commands;
- dry-run behavior;
- exit-code mapping;
- structured output shape;
- no network/AI by default;
- native tool failure diagnostics.

## Maintenance Notes

This doctrine should be treated as command architecture source material. Keep it synchronized with `docs/architecture/other/commands/README.md`, ADR-0012, ADR-0013, and ADR-0014.
