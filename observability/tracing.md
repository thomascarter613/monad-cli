# Tracing Baseline

Monad should support tracing for complex operations without requiring a hosted telemetry service.

## Traceable Operations

- workspace discovery
- manifest loading
- selector resolution
- plan creation
- diff rendering
- apply execution
- policy checking
- graph generation
- context generation

## Trace Fields

- correlation_id
- command
- operation
- plan_id
- workspace_root
- target
- step
- duration_ms
