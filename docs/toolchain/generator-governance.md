# Generator Governance

This document defines governance for generators used by Monad.

Generators may create code, configuration, documentation, schemas, plans, reports, packs, templates, or release evidence.

## Purpose

Generator governance ensures generated output is safe, reviewable, traceable, and distinguishable from authored source.

## Governance Rules

- Generators that mutate repository files should produce plans where practical.
- Generated files should identify source, template, or generation command where practical.
- Generated output must not silently overwrite user-modified files.
- Generated docs must not become hidden source of truth.
- Pack/template generators must preserve trust metadata.
- AI-assisted generators must produce reviewable drafts or candidate plans.

## Generator Classes

| Class | Examples | Safety Rule |
| ----- | -------- | ----------- |
| Code generator | app/service/package scaffolds | plan-backed mutation |
| Config generator | manifests, native config, CI | protected path review |
| Docs generator | command refs, indexes, handoffs | source/lineage metadata |
| Graph generator | Mermaid, DOT, JSON graph exports | generated-state classification |
| Evidence generator | release, apply, policy reports | schema/version metadata |
| AI generator | drafts, suggestions, candidate plans | non-authoritative review |

## Testing Expectations

Generator tests should cover:

- no overwrite without conflict;
- dry-run output;
- generated file classification;
- plan operation correctness;
- template provenance;
- generated docs lineage.

## Maintenance Notes

Update this document when pack/template generation, docs generation, graph generation, or AI-assisted generation behavior changes.
