# Formal Methods

This document defines Monad's future formal methods posture.

Formal methods are not required for the early CLI baseline, but some Monad subsystems have correctness properties that may benefit from formal modeling later.

## Purpose

Formal methods may help verify high-risk behavior such as path safety, plan/apply semantics, graph invariants, policy evaluation, and migration replay.

## Candidate Areas

| Area | Candidate Property |
| ---- | ------------------ |
| Filesystem safety | No operation writes outside workspace root. |
| Plan/apply | Apply executes only validated planned operations. |
| Dry-run | Dry-run performs no writes. |
| Graph model | No dangling required edges; node IDs are stable. |
| Policy model | Waivers only suppress scoped findings. |
| Migration replay | Replay from same inputs produces equivalent state. |
| Output schemas | Stable schemas remain backward compatible. |

## Adoption Posture

Formal methods should be introduced only where they provide clear value beyond ordinary tests.

Preferred order:

1. executable tests;
2. schema validation;
3. invariant checkers;
4. model-based tests;
5. formal specification or proof.

## Non-Goals

- Do not block early implementation on formal proof.
- Do not claim formal verification unless a property is actually modeled and checked.
- Do not replace practical tests with speculative proof plans.

## Maintenance Notes

Update this document when a subsystem adopts model checking, property testing, theorem proving, or formal specification artifacts.
