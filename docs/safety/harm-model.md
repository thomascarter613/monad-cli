# Harm Model

This document defines Monad's harm model.

A harm is an outcome that weakens repository safety, privacy, correctness, governance trust, or maintainability.

## Harm Categories

| Harm | Description |
| ---- | ----------- |
| Unsafe mutation | Files are changed without review, plan, or scope control. |
| Source-of-truth confusion | Generated or external state is mistaken for canonical state. |
| Secret leakage | Sensitive data appears in context, logs, reports, or exports. |
| AI overreach | AI output is treated as authoritative or mutates without review. |
| Hidden telemetry | Data leaves the local environment unexpectedly. |
| Policy bypass | Rules are ignored without visible waiver or approval. |
| Placeholder deception | Planned commands imply completed validation or mutation. |
| Release misrepresentation | Evidence claims readiness that was not actually verified. |
| Governance drift | ADRs, docs, risks, policies, or work packets become stale. |
| Extension abuse | Packs, templates, or plugins exceed declared trust boundaries. |

## Severity Guidance

| Severity | Meaning |
| -------- | ------- |
| Low | Confusing but unlikely to cause unsafe action. |
| Medium | Can cause incorrect decisions or stale evidence. |
| High | Can cause unsafe mutation, privacy exposure, or release misrepresentation. |
| Critical | Can corrupt source truth, leak secrets, or invalidate core trust guarantees. |

## Mitigation Patterns

- Use plan-backed mutation.
- Keep context deterministic and redacted.
- Keep telemetry off by default.
- Require explicit AI provider configuration.
- Use policy findings and waivers.
- Preserve source-of-truth classification.
- Keep release evidence structured and reviewable.
- Test invariants and command honesty.

## Maintenance Notes

Update this harm model as new features introduce new trust boundaries, external integrations, or generated evidence types.
