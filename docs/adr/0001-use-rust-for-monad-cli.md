---
id: ADR-0001
title: Use Rust for Monad CLI
status: accepted
date: 2026-07-02
supersedes: []
superseded_by: null
tags: [rust, cli, v1]
---

# ADR-0001: Use Rust for Monad CLI

## Status

Accepted.

## Context

Monad is a single-binary, local-first, governance-grade monorepo CLI.

## Decision

Use Rust for Monad's core CLI and runtime.

## Consequences

- Strong performance and single-binary distribution.
- Strong type safety.
- Excellent CLI ecosystem.
- Slightly higher implementation ceremony than scripting languages.

## Alternatives Considered

- TypeScript
- Go
- Python
