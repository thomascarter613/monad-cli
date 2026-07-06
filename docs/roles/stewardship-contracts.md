# Stewardship Contracts

This document defines stewardship contracts for Monad artifacts and governance surfaces.

A stewardship contract describes what must be cared for over time, who or what is responsible, and how drift is detected.

## Purpose

Stewardship contracts ensure that durable repository knowledge does not decay after initial generation.

They apply to:

- ADRs;
- work packets;
- documentation;
- policies;
- risks;
- release evidence;
- schemas;
- context artifacts;
- graph outputs;
- generated state;
- hosted projection records.

## Contract Fields

A stewardship contract should identify:

- artifact or domain;
- steward role;
- source of truth;
- maintenance cadence;
- drift detection method;
- escalation path;
- related ADRs;
- related work packets;
- evidence requirements.

## Core Contracts

| Domain | Steward | Contract |
| ------ | ------- | -------- |
| ADRs | Architecture Steward | Keep decisions indexed, statused, and superseded explicitly. |
| Work packets | Planning Steward | Keep implementation scope traceable to roadmap and evidence. |
| Docs | Documentation Steward | Keep docs honest, indexed, linked, and style-consistent. |
| Policies | Governance Steward | Keep checks explainable, waivable, and aligned with ADRs. |
| Risks | Risk Owner | Keep risk status, controls, and evidence current. |
| Releases | Release Steward | Keep release evidence complete, reviewable, and retained. |
| Schemas | Data Steward | Keep machine-readable schemas versioned and migration-aware. |
| Context | Context Steward | Keep handoffs deterministic, redacted, and source-referenced. |

## Escalation

Escalate when:

- accepted ADRs conflict;
- release evidence is incomplete;
- generated state becomes hidden source of truth;
- policy findings are ignored without waiver;
- context artifacts risk leaking sensitive data;
- hosted projection diverges from local truth.

## Maintenance Notes

Update stewardship contracts when a new governance surface becomes durable or release-critical.
