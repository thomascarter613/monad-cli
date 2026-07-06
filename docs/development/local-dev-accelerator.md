# Local Dev Accelerator

## Purpose

Make common local development workflows fast, repeatable, and easy to diagnose.

This document defines the governed local development workflow for Monad OS / Monad CLI.

## Accelerator Surfaces

- Hot reload for generated TypeScript apps/services when present.
- Local task graph commands through Monad, Turbo, Moon, or Bun.
- Local caches for build/test where supported.
- Docker Compose profiles for optional services.
- Devcontainer definitions for reproducible development.

## Common Commands

```bash
scripts/check.sh
scripts/autofix.sh
docker compose --profile infra up -d
docker compose --profile infra down
```

## Dev Graph

Future Monad commands should expose:

```bash
monad graph projects
monad graph tasks
monad graph deps
```
Local development must be:

```text
fast
deterministic
safe
governed
reproducible
aligned with CI/CD
aligned with release evidence
```

Local development is not separate from governance.  
It is the first enforcement layer.

---

## Local Development Doctrine

Local development must ensure:

```text
the workspace builds locally
the workspace checks locally
the tests pass locally
the command catalog is honest locally
the docs are updated locally
the ADR index is valid locally
the work-packet index is valid locally
```

Local development is CI/CD in miniature.

---

## Local Development Commands

### Format

```bash
cargo fmt --all
```

### Check

```bash
cargo check --workspace
```

### Test

```bash
cargo test --workspace
```

### CLI Contract

```bash
cargo test -p monad-cli --test command_catalog_contract
```

### Docs (future)

```bash
monad docs check
```

### ADRs (future)

```bash
monad adr validate
```

### Work Packets (future)

```bash
monad workpacket validate
```

### Policy (future)

```bash
monad policy check
```

---

## Local Development Invariants

```text
local development must match CI/CD
local development must produce evidence
local development must be reproducible
local development must be governed
```

Local development is the institutional foundation of Monad.