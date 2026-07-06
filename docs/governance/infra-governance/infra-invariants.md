# Infrastructure Invariants

This document defines infrastructure invariants Monad should preserve.

Infrastructure invariants are rules that should remain true across local, CI, release, and future hosted projection environments.

## Core Invariants

| Invariant | Rule |
| --------- | ---- |
| INFRA-INV-001 | Core local commands do not require hosted infrastructure. |
| INFRA-INV-002 | Core local commands do not require telemetry. |
| INFRA-INV-003 | Core local commands do not require AI provider credentials. |
| INFRA-INV-004 | Secrets are never committed as required configuration. |
| INFRA-INV-005 | Generated state is rebuildable unless explicitly promoted to evidence. |
| INFRA-INV-006 | CI gates use documented commands and exit behavior. |
| INFRA-INV-007 | Provisioning changes are reviewable before apply where practical. |
| INFRA-INV-008 | Hosted projection does not replace local source of truth. |
| INFRA-INV-009 | Environment contracts define required tools and forbidden assumptions. |
| INFRA-INV-010 | Release evidence records environment assumptions. |

## Local-First Invariants

Monad should remain useful from a fresh clone without:

- SaaS account;
- hosted control plane;
- telemetry token;
- AI provider key;
- external database;
- background daemon.

## Generated State Invariants

Generated infrastructure-related outputs should be safe to delete and rebuild unless promoted to release or audit evidence.

## Validation Strategy

Future checks may validate:

- required environment files;
- missing tool diagnostics;
- forbidden secrets;
- unexpected network configuration;
- hosted-only assumptions;
- CI workflow drift;
- generated state classification.

## Maintenance Notes

Update invariants when local-first behavior, CI gates, provisioning model, or hosted projection assumptions change.
