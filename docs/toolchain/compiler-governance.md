# Compiler Governance

This document defines governance for compilers, build systems, and check tools coordinated by Monad.

## Purpose

Compiler governance ensures that build/check behavior is reproducible, diagnosable, and compatible with native ecosystem expectations.

## Scope

Compiler governance applies to:

- Rust toolchain and Cargo;
- TypeScript/JavaScript tooling;
- Go tooling;
- Python tooling;
- Java tooling;
- future native tool adapters;
- CI build/check workflows.

## Governance Rules

- Native compilers remain authoritative for their language semantics.
- Monad may detect, invoke, and normalize compiler diagnostics.
- Compiler version expectations should be declared where reproducibility matters.
- Build/check output used as evidence should record command and environment context.
- Missing compiler/toolchain state should produce actionable diagnostics.
- Compiler invocation must not imply hidden network, telemetry, or AI behavior.

## Evidence

Compiler evidence may include:

- `cargo check --workspace` output;
- test/build report summaries;
- tool version records;
- CI workflow results;
- release evidence entries;
- normalized diagnostics.

## Testing Expectations

Tests should cover:

- missing compiler detection;
- invalid manifest diagnostics;
- command exit-code mapping;
- fixture repositories with multiple toolchains;
- CI evidence formatting.

## Maintenance Notes

Update this document when compiler adapters, CI gates, or release evidence requirements change.
