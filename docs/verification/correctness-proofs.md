# Correctness Proofs

This document defines how Monad should explain correctness-critical behavior.

A correctness proof may be formal, semi-formal, test-backed, schema-backed, or evidence-backed depending on subsystem maturity.

## Purpose

Correctness proofs help justify claims such as:

- read-only commands do not mutate;
- dry-run writes nothing;
- apply performs only planned operations;
- paths cannot escape the workspace root;
- generated state does not override canonical state;
- stable output schemas remain compatible;
- exit code mapping is consistent.

## Proof Classes

| Class | Description |
| ----- | ----------- |
| Test-backed | Verified through automated tests and fixtures. |
| Schema-backed | Verified through schema validation. |
| Invariant-backed | Verified through invariant checkers. |
| Review-backed | Verified by documented review and evidence. |
| Formal | Verified through formal methods or mechanized proof. |

## Candidate Proof Obligations

| Obligation | Evidence |
| ---------- | -------- |
| Read-only safety | mutation safety tests, fixture diff checks. |
| Dry-run safety | no-write tests. |
| Plan/apply scope | plan schema, path normalization tests, apply reports. |
| Manifest authority | canonical manifest tests. |
| Context redaction | redaction fixtures and inclusion/exclusion manifests. |
| Output compatibility | JSON schema tests and fixture snapshots. |
| Policy explainability | policy fixture tests and findings reports. |

## Maintenance Notes

Update proof obligations when correctness-critical behavior, schemas, or safety invariants change.
