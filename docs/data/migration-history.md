# Migration History

This document records Monad data and schema migrations.

It is a human-readable register. Machine-readable migration metadata may be added later when migration tooling matures.

## Purpose

Migration history preserves:

- what changed;
- when it changed;
- why it changed;
- who or what applied it;
- which schema versions were affected;
- which artifacts were touched;
- how the migration was validated;
- whether replay or rollback is possible.

## Migration Register

| Migration ID | Date | Status | From | To | Area | Summary | Related ADRs |
| ------------ | ---- | ------ | ---- | -- | ---- | ------- | ------------ |
| MIG-0000 | TBD | Draft | none | initial | data-governance | Establish initial data governance schemas and process docs. | ADR-0013, ADR-0015 |

## Entry Template

Use this template for future migration entries.

```markdown
## MIG-0000: <Migration Title>

Status: Draft | Proposed | Approved | Applied | Failed | Superseded | Reverted

Date: YYYY-MM-DD

Owner: <person/tool>

### Summary

What changed?

### Reason

Why was the migration needed?

### From

Source schema/version/state.

### To

Target schema/version/state.

### Affected Artifacts

- path/to/artifact

### Related ADRs

- ADR-0000

### Related Work Packets

- WP-0000

### Validation

How was the migration validated?

### Replay Notes

How can it be replayed or verified later?

### Rollback Notes

How can it be reverted or mitigated if needed?
```

## Rules

- Do not remove migration history entries.
- Mark superseded or reverted migrations explicitly.
- Link related ADRs and work packets where practical.
- Record schema version changes clearly.
- Record generated-state rebuild migrations even if no source files changed.
- Keep migration history aligned with replay documentation.

## Maintenance Notes

Update this file whenever a migration affects canonical schemas, archive manifests, forensic records, graph/context/plan schemas, migration tooling, or release evidence formats.
