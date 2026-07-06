# Documentation Governance Handbook

Monad treats documentation as a first-class governance surface.

This handbook explains how documentation should be authored, indexed, validated, audited, and kept aligned with code, ADRs, work packets, policies, risks, and release evidence.

## Governance Doctrine

1. Intent is explicit.
2. Decisions are recorded.
3. Documentation is versioned.
4. Generated docs are distinguishable.
5. Mutations are planned.
6. Drift is detected.
7. Exceptions are waivable but auditable.
8. Releases require evidence.

## Documentation Sources

Governance is expressed through:

- `monad.toml` as canonical workspace intent;
- ADRs as durable architecture decisions;
- work packets as implementation scope;
- docs as source-controlled knowledge;
- policies as executable or structured governance;
- risks as known uncertainty;
- release evidence as readiness proof;
- context artifacts as handoff support.

## Directory Map

| File | Purpose |
| ---- | ------- |
| `index.md` | File map and governance summary. |
| `documentation-governance.md` | Source-of-truth and review rules. |
| `documentation-invariants.md` | Rules that should remain true. |
| `documentation-audit.md` | Audit process and finding model. |
| `drift-detection.md` | Drift detection and mitigation. |
| `style-guide.md` | Writing and formatting conventions. |
| `open-source-licenses.md` | License and SBOM documentation governance. |

## Review Checklist

Before merging documentation changes, review:

- Does the document have a clear purpose?
- Does it contradict accepted ADRs?
- Does it distinguish planned from implemented behavior?
- Are local links valid?
- Are related ADRs/work packets referenced where useful?
- Does it introduce a new source of truth accidentally?
- Does the index need updating?

## Future Commands

Expected future support:

```bash
monad docs check
monad adr check
monad workpacket check
monad context handoff
```

## Maintenance Notes

Keep this handbook aligned with ADR-0009 Documentation-as-Code and related docs governance files.
