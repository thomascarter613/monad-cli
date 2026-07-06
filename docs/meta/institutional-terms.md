# Institutional Terms

This document records project-specific phrases that preserve Monad doctrine.

Institutional terms are not merely glossary entries. They carry architectural expectations and should be used consistently.

## Deterministic Before Intelligent

Monad should produce deterministic repository understanding before AI is used.

This protects local-first operation, testability, privacy, and trust.

## Read-Only Before Mutation

Commands that inspect should not mutate. Mutation should be explicit and reviewable.

## Plan-Backed Before Mutation

Significant repository changes should be represented as plans before apply.

## Local Evidence Before Hosted Projection

Hosted features may project local evidence, but local repository artifacts remain the foundation.

## AI-Native but AI-Optional

Monad may be designed for AI-assisted workflows, but AI must not be required for core correctness.

## No Telemetry by Default

Monad must not silently upload usage, repository metadata, context, graph, policy, plan, or release evidence.

## Repository as Institution

A serious repository contains institutional memory: decisions, policies, risks, evidence, context, and operating doctrine.

## Governance-Grade

Governance-grade means repeatable, reviewable, auditable, local-first, and explicit enough for humans, CI, and future automation.

## Maintenance Notes

Add terms here only when they encode durable Monad doctrine or decision language.
