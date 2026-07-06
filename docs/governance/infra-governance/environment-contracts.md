# Environment Contracts

This document defines governance expectations for Monad environments.

Environment contracts describe what must be true for local development, CI, release, and future hosted projection environments.

## Purpose

Environment contracts help Monad explain:

- what tools are expected;
- what configuration is required;
- what secrets must not be committed;
- which commands are safe to run;
- which outputs are generated or durable;
- how environment drift is detected.

## Environment Classes

| Environment | Purpose |
| ----------- | ------- |
| Local | Developer workstation or local clone. |
| CI | Automated checks, tests, policy, docs, and release gates. |
| Release | Environment used to produce or verify release evidence. |
| Hosted projection | Optional future service layer consuming local evidence. |
| Test fixture | Controlled workspace used for deterministic tests. |

## Contract Fields

Each environment contract should eventually define:

- environment ID;
- purpose;
- required tools;
- required files;
- forbidden files;
- secrets policy;
- network policy;
- AI policy;
- telemetry policy;
- generated state paths;
- validation commands;
- expected outputs.

## Local Contract

The local baseline should support:

- no hosted account;
- no telemetry;
- no AI provider;
- no required external database;
- no network access for core checks;
- deterministic docs, graph, context, and policy workflows where implemented.

## CI Contract

CI should be able to run:

```bash
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
monad docs check
monad policy check
```

Commands may be partial until implemented, but placeholder behavior must be honest.

## Secrets and Sensitive Data

Environment contracts must not require secrets for core local behavior.

Secrets, credentials, private keys, `.env` files, and provider tokens must not be committed and should be excluded from context generation by default.

## Maintenance Notes

Update this document when required tools, CI gates, hosted behavior, or generated state paths change.
