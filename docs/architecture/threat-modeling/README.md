# Threat Modeling

This directory contains Monad threat-modeling documentation.

Threat modeling identifies trust boundaries, attack surfaces, abuse cases, mitigations, tests, and policy gates for Monad's local-first repository runtime.

## Purpose

Threat models should help answer:

- What can an attacker or unsafe workflow do?
- Which assets must be protected?
- Which trust boundaries are crossed?
- Which mitigations are required?
- Which tests or policy checks prove the mitigation exists?
- Which residual risks are accepted or deferred?

## Scope

Threat modeling should cover:

- filesystem mutation;
- path traversal and symlink behavior;
- canonical manifest handling;
- generated state under `.monad/`;
- context and handoff generation;
- secret redaction;
- native tool invocation;
- pack and template trust;
- plugin execution;
- AI provider adapters;
- optional hosted projection;
- telemetry and network behavior;
- policy waivers;
- release evidence.

## Related ADRs

- ADR-0003: Local-First Core
- ADR-0005: `monad.toml` Is the Canonical Manifest
- ADR-0006: Plan-Backed Mutation
- ADR-0010: Policy-as-Code
- ADR-0011: Deterministic Context Before AI Assistance
- ADR-0016: Pack and Template Trust Model
- ADR-0017: Plugin Execution and Trust Boundary
- ADR-0018: Hosted Control Plane Is Optional Projection Layer
- ADR-0019: No Telemetry by Default
- ADR-0020: AI Provider Port and Noop Adapter

## Threat Model Template

Use this structure for new threat models.

```markdown
# <Subsystem> Threat Model

## Status

Draft | Proposed | Active | Superseded

## Assets

What must be protected?

## Trust Boundaries

Which boundaries are crossed?

## Data Flows

How does data move through the subsystem?

## Threats

What can go wrong?

## Mitigations

How is each threat reduced?

## Required Tests

Which tests prove mitigations exist?

## Policy Gates

Which policy rules or waivers apply?

## Residual Risk

What risk remains accepted or deferred?
```

## Initial Threat Models

Recommended initial files:

| File | Focus |
| ---- | ----- |
| `filesystem-mutation.md` | path traversal, protected files, symlinks, overwrite/delete safety. |
| `context-generation.md` | secret leakage, stale docs, redaction, inclusion/exclusion manifests. |
| `packs-and-templates.md` | untrusted generation, dependency injection, CI modification, provenance. |
| `plugins.md` | arbitrary execution, capabilities, network/AI access, sandboxing. |
| `hosted-projection.md` | upload, sync, tenancy, repository metadata exposure. |
| `ai-provider-boundary.md` | provider calls, prompt/context leakage, provenance, disabled behavior. |

## Diagram Guidance

Use text-based diagrams where possible:

- Mermaid for data-flow and sequence diagrams;
- PlantUML for C4-style trust boundary diagrams;
- DOT/Graphviz for generated graph relationships;
- plain text for simple path and boundary sketches.

Avoid image-only diagrams unless source is also committed.

## Maintenance Notes

Threat models should link to related ADRs, work packets, tests, policies, and known risks. New mutating or network-aware subsystems should not be considered architecture-complete until their trust boundaries are documented.
