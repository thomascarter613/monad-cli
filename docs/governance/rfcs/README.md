# RFCs

This directory contains governance documentation for Monad Request for Comments (RFCs).

RFCs are used for substantial proposed changes that need structured review before implementation or ADR acceptance.

## Purpose

Use an RFC when a proposal affects:

- command surface;
- manifest/schema behavior;
- plan/apply behavior;
- policy model;
- plugin/pack trust boundaries;
- AI provider architecture;
- hosted projection;
- release governance;
- compatibility guarantees;
- cross-cutting workflows.

## RFC vs ADR

| Artifact | Purpose |
| -------- | ------- |
| RFC | Explores a proposal and gathers feedback. |
| ADR | Records a durable architecture decision. |
| Work packet | Defines implementation scope. |

An accepted RFC may lead to one or more ADRs and work packets.

## Recommended RFC Template

```markdown
# RFC-NNNN: <Title>

Status: Draft | Proposed | Accepted | Rejected | Superseded

## Summary

## Motivation

## Proposal

## Alternatives Considered

## Compatibility Impact

## Security and Privacy Impact

## Migration Plan

## Related ADRs

## Related Work Packets

## Open Questions
```

## Status Values

| Status | Meaning |
| ------ | ------- |
| Draft | Early proposal. |
| Proposed | Ready for review. |
| Accepted | Approved direction. |
| Rejected | Not chosen. |
| Superseded | Replaced by a later RFC or ADR. |

## Governance Rules

- Do not use RFCs to bypass ADRs.
- Accepted RFCs should result in ADRs when they create durable architecture decisions.
- RFCs that imply mutation, hosted sync, telemetry, or AI behavior must address safety and privacy.
- RFCs should link to traceability matrix entries when implementation begins.

## Maintenance Notes

Add an RFC index if the directory grows beyond a small number of RFCs.
