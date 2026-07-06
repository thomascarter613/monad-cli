# Design Rationale

This document explains the rationale behind Monad's core design choices.

## Rust Single Binary

Monad uses Rust because it supports a portable, fast, local-first CLI with strong type safety and reliable distribution.

A single binary keeps adoption simple while the internal implementation can remain modular.

## Native Tool Coordination

Monad coordinates native tools instead of replacing them by default.

Ecosystems already have package managers, compilers, linters, formatters, test runners, and deployment tools. Monad should add governance, context, validation, and orchestration around those tools rather than pretending to own all execution.

## Canonical Manifest

`monad.toml` is canonical so workspace intent is explicit and inspectable.

Native manifests remain native-tool facts. Compatibility mirrors may exist, but they should not create source-of-truth ambiguity.

## Plan-Backed Mutation

Direct mutation is risky. Plans create a review boundary between intent and change.

This is especially important for generators, migrations, packs, plugins, and AI-assisted suggestions.

## Documentation-as-Code

Monad's value depends on decisions and evidence living with the repository.

Docs, ADRs, work packets, policies, and release evidence are not side channels; they are part of the system.

## Optional AI

AI can make repository work easier, but it should not be required for correctness.

Provider ports, no-op adapters, deterministic context, and plan-backed AI suggestions preserve trust.

## Maintenance Notes

Update this rationale when accepted ADRs materially change Monad's architecture posture.
