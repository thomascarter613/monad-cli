# Documentation Invariants

This document defines documentation invariants that Monad should preserve.

Invariants are rules that should remain true over time and should eventually be checkable by `monad docs check` or related validation workflows.

## Core Invariants

| Invariant | Rule |
| --------- | ---- |
| DOC-INV-001 | Every accepted ADR appears in the ADR index. |
| DOC-INV-002 | ADR numbers are unique and never reused. |
| DOC-INV-003 | Work packet IDs are unique and indexed. |
| DOC-INV-004 | Canonical manifest documentation points to `monad.toml`, not an older primary source. |
| DOC-INV-005 | Generated docs are distinguishable from authored source docs. |
| DOC-INV-006 | Planned commands are not described as fully implemented. |
| DOC-INV-007 | Local links in governed docs should resolve. |
| DOC-INV-008 | Release evidence references existing artifacts. |
| DOC-INV-009 | Traceability matrix references current ADR and work packet paths. |
| DOC-INV-010 | Superseded decisions remain historically available. |

## ADR Invariants

- ADR files use `ADR-NNNN_slug.md` naming.
- ADR frontmatter contains `id`, `title`, `status`, `date`, `supersedes`, `superseded_by`, and `tags` where practical.
- Accepted ADRs should not be materially rewritten; use superseding ADRs.
- ADR index links must resolve.

## Work Packet Invariants

- Work packets should map to roadmap hierarchy.
- Work packets should include related ADRs where applicable.
- Work packet status should not conflict with implementation evidence.
- Completed work packets should have test/evidence references where practical.

## Generated Documentation Invariants

- Generated docs identify source inputs or regeneration command where practical.
- Generated docs should not be edited as if authored unless promoted.
- Generated docs should not become hidden source of truth.

## Command Documentation Invariants

- Command docs must distinguish planned, preview, partial, and implemented behavior.
- Mutating commands must document dry-run and plan behavior where applicable.
- Network-aware and AI-aware behavior must be explicit.
- Machine-readable outputs should reference schema maturity.

## Validation Strategy

Initial validation can be simple:

- required file checks;
- ADR filename/status checks;
- work packet index checks;
- local link checks;
- known placeholder detection;
- stale generated docs warnings.

## Maintenance Notes

Update invariants when ADR conventions, work packet structure, command metadata, or generated documentation rules change.
