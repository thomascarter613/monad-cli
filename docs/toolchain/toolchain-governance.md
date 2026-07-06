# Toolchain Governance

This document defines overall governance for Monad's toolchain.

A toolchain includes compilers, interpreters, package managers, linters, formatters, test runners, generators, scanners, policy engines, and AI/provider adapters.

## Purpose

Toolchain governance ensures that tools are:

- declared where required;
- detected accurately;
- invoked explicitly;
- coordinated without replacing native semantics;
- represented in diagnostics and evidence;
- safe for local-first operation.

## Governance Rules

- Core Monad behavior must not require unnecessary external tools.
- Native tool invocations should be visible in diagnostics.
- Missing tools should produce actionable findings.
- Tool versions should be captured when relevant to reproducibility.
- Tools must not be allowed to mutate governed files without explicit flow.
- Network-aware tools must be explicit.
- Tool output used by Monad should be normalized before becoming evidence.

## Tool Classes

| Class | Examples | Governance Concern |
| ----- | -------- | ------------------ |
| Compiler/build | Rust, TypeScript, Go, Java, Python tooling | correctness, reproducibility, diagnostics |
| Package manager | Cargo, Bun, pnpm, npm, pip | dependency and lockfile behavior |
| Quality tool | formatter, linter, test runner | CI and release evidence |
| Generator | template/code/docs generators | plan-backed mutation and provenance |
| Policy/scanner | policy engine, secret scanner, SBOM tool | findings, waivers, release gates |
| AI adapter | provider or local model adapter | optional, redacted, non-authoritative |

## Evidence

Toolchain evidence may include:

- detected tool versions;
- command invocation summaries;
- test/check output;
- schema-validated reports;
- release evidence entries;
- policy findings;
- generated artifact provenance.

## Maintenance Notes

Update this document when toolchain assumptions, engine declarations, generated state, or release gates change.
