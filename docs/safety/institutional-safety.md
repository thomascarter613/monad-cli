# Institutional Safety

This document defines Monad's institutional safety model.

Institutional safety means the repository remains understandable, governable, and safe to change over time, even as contributors, tools, generated artifacts, and implementation details change.

## Purpose

Institutional safety protects against long-term degradation such as:

- forgotten decisions;
- undocumented authority;
- stale work packets;
- accumulated waivers;
- hidden generated state;
- lost release evidence;
- overreliance on AI context;
- hosted systems becoming unreviewed source of truth.

## Safety Practices

| Practice | Purpose |
| -------- | ------- |
| ADRs | Preserve decisions and tradeoffs. |
| Traceability matrix | Connect requirements, work, tests, risks, and evidence. |
| Risk register | Track known uncertainty. |
| Documentation audits | Detect stale or missing knowledge. |
| Plan/apply reports | Preserve mutation evidence. |
| Context handoffs | Preserve continuity across sessions. |
| Stewardship contracts | Assign long-term responsibility. |

## Institutional Failure Modes

- Decisions exist only in chat history.
- Generated docs are treated as truth without lineage.
- AI summaries replace source documents.
- Waivers become permanent exceptions without review.
- Release evidence cannot be reconstructed.
- Tooling changes without updating governance docs.
- Hosted dashboards diverge from local source truth.

## Maintenance Notes

Institutional safety should be reviewed whenever the project adds new governance surfaces, hosted projection, AI assistance, release automation, or plugin execution.
