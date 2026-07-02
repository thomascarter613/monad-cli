# Domains

This directory documents Monad's bounded contexts and domain boundaries.

`monad.toml` remains the canonical workspace manifest. Domain rules are declared in:

- `domains/domain-map.toml`
- `governance/boundaries.toml`

## Purpose

Domains make the monorepo behave like a governed system rather than a loose folder tree.

Each domain should define:

- Purpose
- Owned paths
- Allowed dependencies
- Forbidden dependencies
- Public API surface
- Lifecycle rules
- Documentation expectations

## Initial Monad Domains

- CLI
- Core
- Plans
- Packs
- Policy
- Context
- Graph
- Governance
- Operations
