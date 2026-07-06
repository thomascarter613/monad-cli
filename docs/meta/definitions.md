# Definitions

This document defines core Monad terms with normative meaning.

## Canonical

Canonical means authoritative source of intent for a given domain.

For Monad workspace intent, `monad.toml` is canonical.

## Resolved State

Resolved state is deterministic state derived from canonical sources. It may be committed for reproducibility, but it is not author intent.

Example: `monad.lock`.

## Generated State

Generated state is produced by tools from source artifacts. It is usually rebuildable and should not become hidden source of truth.

Example: `.monad/graphs/`.

## Local-First

Local-first means the core CLI works from repository files without requiring a hosted service, telemetry, AI provider, external database, or network access.

## Hosted Projection

Hosted projection means an optional service view over local evidence. It may aggregate or visualize local data but does not replace local repository truth.

## Plan-Backed Mutation

Plan-backed mutation means significant file changes are represented as reviewable plans before apply.

## Lifecycle Graph

The lifecycle graph is Monad's derived model connecting repository artifacts, units, docs, ADRs, work packets, policies, plans, releases, context, and evidence.

## Context Pack

A context pack is a deterministic, reviewable bundle of repository knowledge intended for human handoff or future AI assistance.

## Policy Finding

A policy finding is a structured result from a policy or validation rule. It should include severity, affected artifact, message, and remediation guidance.

## Waiver

A waiver is an explicit, reviewable exception to a policy rule. Waivers should have owner, reason, scope, and review/expiration metadata where practical.

## Release Evidence

Release evidence is documentation or machine-readable output used to prove that a release satisfied expected checks and governance gates.

## Interoperability Contract

An interoperability contract defines a boundary between Monad and another system, including data flow, schema, source of truth, failure behavior, and compatibility expectations.

## Maintenance Notes

Update this file when a term becomes durable enough to affect ADRs, governance, schemas, or implementation decisions.
