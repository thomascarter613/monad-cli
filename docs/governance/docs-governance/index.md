# Documentation Governance Index

This directory contains Monad's documentation governance layer.

Documentation governance defines how repository knowledge is authored, validated, indexed, audited, and kept aligned with implementation.

## Files

| File | Purpose |
| ---- | ------- |
| `README.md` | Documentation governance handbook. |
| `documentation-governance.md` | Rules for documentation ownership, source-of-truth, and review. |
| `documentation-invariants.md` | Invariants that documentation should preserve. |
| `documentation-audit.md` | Audit process for documentation presence, consistency, and traceability. |
| `drift-detection.md` | Detection and mitigation for stale or contradictory docs. |
| `style-guide.md` | Writing and formatting conventions. |
| `open-source-licenses.md` | License and SBOM documentation governance. |

## Related ADRs

- ADR-0009: Documentation-as-Code
- ADR-0011: Deterministic Context Before AI Assistance
- ADR-0012: Honest Placeholder Commands
- ADR-0013: Versioned Machine-Readable Output Schemas

## Governance Principles

- Documentation is versioned source material.
- Accepted ADRs are authoritative until superseded.
- Generated docs must be distinguishable from authored docs.
- Planned behavior must not be described as implemented behavior.
- Documentation should be traceable to requirements, ADRs, work packets, tests, policies, risks, and evidence.
- Docs should support humans, CI, and future AI context generation.

## Validation Goals

Future documentation checks should validate:

- required docs;
- ADR index and status;
- work packet index and status;
- local links;
- generated docs lineage;
- command status honesty;
- release evidence references;
- traceability links.

## Maintenance Notes

Update this index whenever documentation governance files are added, renamed, or superseded.
