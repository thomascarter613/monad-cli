# Logging Baseline

Monad logging should be structured, low-noise, and useful in CI.

## Principles

- Logs should describe actions, not implementation noise.
- Human output and machine output are separate.
- JSON output must not be polluted by color or prose.
- Correlation IDs should be supported for multi-step operations.
- Plan IDs should be included for mutating operations.

## Recommended Fields

- timestamp
- level
- command
- workspace_root
- plan_id
- operation
- target
- result
- duration_ms
- correlation_id

## CLI Doctrine

Human output is for developers. JSON output is for tools.
