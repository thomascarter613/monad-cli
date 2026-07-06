# Glossary

This glossary provides short explanations for common Monad terms.

## ADR

Architecture Decision Record. A durable record of an architecture decision and its consequences.

## Apply Report

A report produced after applying a plan, describing operations executed, skipped, failed, or blocked.

## Artifact

Any repository file, generated output, report, schema, plan, documentation page, or evidence record that Monad can reference.

## Canonical Manifest

The authoritative Monad workspace manifest. The canonical manifest is `monad.toml`.

## Context Handoff

A human-readable artifact that summarizes repository state for a future session, maintainer, or AI assistant.

## Drift

A mismatch between declared intent and actual state.

## Generated State

Rebuildable output produced by tooling, usually under `.monad/`.

## Governance

The system of decisions, policies, evidence, traceability, and review rules that keeps the repository understandable and safe to evolve.

## Lifecycle Graph

A graph connecting repository units, dependencies, docs, ADRs, work packets, policies, plans, context, and releases.

## Native Tool

An ecosystem tool that Monad coordinates rather than replaces, such as Git, Cargo, Bun, Docker, or a linter.

## Plan

A structured proposal for repository mutation that can be reviewed, diffed, dry-run, and applied.

## Policy

A repeatable rule that evaluates repository state and emits findings.

## Projection

A derived view of local evidence, often used to describe future hosted dashboards or aggregated views.

## Source of Truth

The authoritative artifact for a given decision, configuration, or record.

## Waiver

A documented exception to a policy finding, scoped and reviewable.

## Work Packet

A structured implementation unit that connects roadmap intent to tasks, acceptance criteria, tests, and evidence.

## Maintenance Notes

Promote frequently used glossary terms into `definitions.md` when they become normative.
