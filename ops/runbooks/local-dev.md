# Local Development Runbook

## Goal

Start, inspect, and validate the local Monad development environment.

## Baseline Commands

```bash
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
scripts/check.sh
```

## Optional Local Infrastructure

```bash
docker compose --profile infra up -d
docker compose ps
```

Services exposed by the systems-grade compose layer include:

- Postgres
- Keycloak
- Meilisearch
- Mailpit
- Valkey
- OpenTelemetry Collector
- Prometheus
- Grafana

## Health Checks

```bash
scripts/graph-integrity.sh
scripts/dependency-hygiene.sh
scripts/drift-check.sh
```

## Shutdown

```bash
docker compose --profile infra down
```
