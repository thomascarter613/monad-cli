# Domain Validation

This document defines validation within a single Monad domain or subsystem.

A domain may be a command group, data model, schema area, documentation area, policy bundle, graph model, context artifact type, or plan/apply subsystem.

## Purpose

Domain validation ensures each domain is internally coherent before cross-domain validation occurs.

## Domain Validation Checks

| Domain | Checks |
| ------ | ------ |
| Manifest | schema validity, canonical/mirror conflict, required fields. |
| Commands | metadata, status, output formats, exit behavior. |
| ADRs | ID uniqueness, status validity, index membership. |
| Work packets | ID uniqueness, required sections, roadmap alignment. |
| Graph | node/edge validity, dangling references, schema version. |
| Context | redaction, inclusion/exclusion manifest, source references. |
| Policy | rule IDs, severity, waiver handling, explainability. |
| Plans | schema validity, operations, preconditions, protected paths. |
| Data | schema versions, retention class, provenance. |

## Finding Model

Domain validation findings should include:

- finding ID;
- severity;
- domain;
- affected path or node;
- message;
- remediation guidance;
- related ADR or policy;
- machine-readable category.

## Testing Expectations

Tests should include fixtures for valid, invalid, missing, partial, and deprecated domain states.

## Maintenance Notes

Update domain validation rules when domain schemas, ADR conventions, command metadata, or policy rules change.
