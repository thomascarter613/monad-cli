# Cross-System Contracts

This document defines how Monad should describe and govern contracts with external systems.

A cross-system contract is any stable boundary between Monad and another tool, service, repository, provider, or runtime.

## Purpose

Cross-system contracts make integration behavior explicit and reviewable.

They should define:

- what system is being integrated;
- what data crosses the boundary;
- what schema or protocol is used;
- which side is source of truth;
- whether network access is required;
- whether credentials are required;
- how failures are reported;
- how compatibility is versioned.

## Contract Types

| Type | Examples |
| ---- | -------- |
| Native tool contract | Cargo, Bun, Git, Docker, task runners, linters. |
| Schema contract | JSON reports, graph exports, context manifests, plans. |
| Registry contract | future pack/template/plugin registries. |
| AI provider contract | provider port, no-op adapter, hosted or local model adapters. |
| Hosted projection contract | optional sync/export to a dashboard or control plane. |
| Policy engine contract | built-in policy or future external policy engine adapters. |
| Federation contract | multi-repository evidence sharing and graph aggregation. |

## Contract Fields

A mature contract should record:

- contract ID;
- owner;
- system name;
- direction of data flow;
- schema/protocol;
- authentication requirements;
- network requirements;
- retry/timeout behavior;
- failure categories;
- privacy/security notes;
- versioning and compatibility rules;
- related ADRs and work packets.

## Source-of-Truth Rules

- Local repository artifacts remain authoritative unless a future ADR says otherwise.
- Hosted projections consume local evidence; they do not silently become source of truth.
- Native tools own their native semantics; Monad coordinates and validates.
- AI providers may generate suggestions but do not own decisions.
- External registries are untrusted unless provenance and policy say otherwise.

## Testing Expectations

Contract tests should cover:

- schema compatibility;
- missing external system behavior;
- provider disabled behavior;
- no-network defaults;
- malformed response handling;
- version mismatch diagnostics;
- provenance recording.

## Maintenance Notes

Create or update a contract when a new external system becomes operationally significant.
