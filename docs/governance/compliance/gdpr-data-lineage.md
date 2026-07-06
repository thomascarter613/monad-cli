# GDPR Data Lineage

This document defines Monad's privacy-oriented data lineage model for repository governance artifacts.

It is not a legal determination. It is an internal architecture and governance aid for mapping where potentially personal or sensitive data may appear, how it flows, and how review/removal workflows should be supported.

## Purpose

Data lineage helps Monad explain:

- where data originated;
- which artifacts reference it;
- which generated outputs include it;
- whether it was redacted;
- whether it was exported, archived, or promoted to evidence;
- what must be reviewed if removal or correction is requested.

## Data Surfaces

| Surface | Examples | Privacy Notes |
| ------- | -------- | ------------- |
| Source docs | ADRs, work packets, planning docs | May include author names, reviewers, issue links, or notes. |
| Governance records | waivers, findings, risks, traceability | May include owner/reviewer fields. |
| Context artifacts | handoffs, context packs, manifests | Must exclude secrets and minimize sensitive data. |
| Graph exports | nodes/edges, ownership, relationships | May include user or team identifiers later. |
| Release evidence | reports, test summaries, approvals | May include reviewer and command provenance. |
| Archives | frozen evidence packages | Must preserve retention and review metadata. |
| Hosted projection | optional future sync/export | Must be explicit and governed separately. |

## Lineage Fields

Lineage-capable records should include, where practical:

- source path;
- generated artifact path;
- source commit or timestamp;
- record owner;
- purpose;
- retention class;
- redaction status;
- export status;
- related ADR/work packet;
- downstream artifacts;
- deletion or review constraints.

## Right-to-Review Workflow

When a privacy review or removal request affects repository artifacts:

1. Identify the subject or data element.
2. Search canonical docs, generated context, archives, release evidence, and hosted projections if any.
3. Classify each occurrence as canonical, generated, archival, forensic, or external projection.
4. Determine whether the occurrence can be removed, redacted, superseded, or must be retained for governance evidence.
5. Apply changes through reviewable commits or plan-backed workflows where practical.
6. Regenerate derived artifacts.
7. Record the action in migration history, archival notes, or compliance review notes as appropriate.

## Redaction Rules

Generated context artifacts should avoid including:

- secrets;
- private keys;
- credentials;
- sensitive local paths where avoidable;
- unnecessary personal data;
- raw logs containing sensitive content;
- unreviewed external payloads.

## Hosted Projection Rules

If future hosted sync exists:

- upload must be explicit;
- synced data classes must be documented;
- deletion/export workflows must be documented;
- local source-of-truth remains inspectable;
- telemetry remains disabled by default.

## Testing Expectations

Privacy lineage tests should eventually cover:

- context redaction;
- generated artifact inclusion/exclusion manifests;
- lineage references from generated reports to source files;
- regeneration after redaction;
- hosted-disabled local behavior.

## Maintenance Notes

Keep this document aligned with context architecture, data retention policy, archival process, and no-telemetry doctrine.
