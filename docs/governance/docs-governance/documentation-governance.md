# Documentation Governance

This document defines governance rules for Monad documentation.

Monad treats documentation as repository source material, not decoration. Documentation records product intent, architecture decisions, implementation scope, safety constraints, release evidence, and handoff context.

## Purpose

Documentation governance ensures that docs are:

- version-controlled;
- reviewable;
- traceable;
- consistent with ADRs;
- aligned with work packets;
- useful to humans and future AI assistants;
- validated where practical.

## Documentation Classes

| Class | Examples | Governance Rule |
| ----- | -------- | --------------- |
| Product | PRD, requirements, roadmap | Must preserve product intent and scope. |
| Architecture | ADRs, blueprints, models | Must align with accepted ADRs. |
| Governance | policies, traceability, risks | Must remain auditable and current. |
| Reference | command refs, schemas, IDs | Must be stable and machine-checkable where possible. |
| Generated | graphs, context, reports | Must identify source and regeneration path. |
| Evidence | release reports, apply reports | Must be retained according to evidence policy. |

## Governance Rules

- Accepted ADRs are authoritative until superseded.
- Work packets should reference relevant ADRs and requirements.
- Generated docs must not silently replace authored source docs.
- Major documentation changes should update indexes.
- Cross-links should be local and reviewable.
- Docs that support releases should be treated as evidence.
- Planned behavior must not be documented as implemented behavior.

## Review Expectations

Reviewers should check:

- Does the doc contradict any accepted ADR?
- Does it link to related work packets or requirements?
- Does it use the right status language?
- Does it distinguish future/planned behavior from current behavior?
- Does it introduce new terminology without defining it?
- Does it create a new source of truth accidentally?

## Ownership

Each durable doc should have an implied or explicit owner by area:

- product docs: product governance;
- ADRs and blueprints: architecture governance;
- testing docs: quality governance;
- release docs: release governance;
- data docs: data governance;
- security docs: security governance.

## Maintenance Notes

Keep this document aligned with ADR-0009, the docs governance index, documentation audit rules, and style guide.
