# Local Dev Accelerator

## Purpose

Make common local development workflows fast, repeatable, and easy to diagnose.

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
