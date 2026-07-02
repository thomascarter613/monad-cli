# Metrics Baseline

Monad should eventually emit metrics for local and CI workflows.

## Initial Metrics

- command duration
- plan step count
- files created/updated/deleted
- conflict count
- policy finding count
- graph node count
- graph edge count
- test duration
- cache hit/miss when available

## CI Metrics

- build duration
- test duration
- graph integrity duration
- dependency hygiene duration
- drift detection duration
- cache hit rates when exposed by native tools
