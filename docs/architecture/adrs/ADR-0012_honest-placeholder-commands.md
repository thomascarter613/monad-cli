---
id: ADR-0012
title: Honest Placeholder Commands
status: accepted
date: 2026-07-02
supersedes: []
superseded_by: null
tags: [cli, command-catalog, placeholders, trust, metadata, v1]
---

# ADR-0012: Honest Placeholder Commands

## Status

Accepted.

## Context

Monad's command surface is intentionally broad. The product vision includes repository initialization, inspection, validation, graphing, documentation lifecycle, ADR and work packet management, policy checks, plan-backed mutation, pack/template/plugin workflows, context generation, release support, and future AI-assisted behavior.

Early implementation will not complete that full surface immediately. Some commands may be implemented, some may be partially implemented, and some may exist as planned placeholders so that the command catalog, help structure, documentation, tests, and roadmap can converge around a stable product direction.

Planned command visibility is useful. It communicates direction, enables command catalog contract tests, helps documentation stay aligned, and prevents accidental command drift.

However, broad planned command visibility creates risk. Users must not be misled into thinking an unimplemented command performs real validation, planning, mutation, policy evaluation, AI behavior, or safety checks. A CLI that silently succeeds without performing real behavior damages trust.

Monad's governance-grade posture requires command honesty. Placeholder commands must clearly state what they do and do not do.

## Decision

Unimplemented, partial, or planned commands must be clearly marked as such.

Command metadata must include enough information to make command status and safety posture visible to humans, tests, and future automation.

Recommended command metadata includes:

```text
name
summary
status
implemented
mutating
plan_backed
supports_dry_run
uses_network
uses_ai
stability
output_formats
exit_behavior
related_work_packet
```

Placeholder commands should:

- say they are not fully implemented;
- describe intended future behavior;
- avoid pretending success;
- avoid mutating files;
- avoid calling network services;
- avoid calling AI providers;
- avoid claiming real validation if none occurred;
- use documented exit behavior;
- expose command status in machine-readable metadata where practical.

A planned command may exist in help output or command catalogs, but it must not silently behave as if completed.

## Decision Drivers

This decision is driven by the following needs:

- **User trust:** users must be able to tell whether a command actually did work.
- **Roadmap visibility:** planned commands can communicate product direction without deception.
- **Contract testing:** command catalog tests can protect the intended command surface.
- **Safety:** placeholder mutating commands must not write files or perform risky actions.
- **CI clarity:** automation must not treat fake success as real validation.
- **Documentation alignment:** docs can reference planned commands if status is clear.
- **Incremental development:** broad CLI architecture can be developed without lying about completeness.
- **AI safety:** future AI agents must not infer that placeholder commands are safe operational tools.

## Rationale

Monad is not merely a toy CLI. It aims to become a governance-grade repository runtime. Trust is therefore a core product requirement.

Early-stage tools often expose placeholder commands. That is acceptable if placeholders are honest. It is not acceptable for a placeholder to return output implying that validation, mutation, planning, or policy checks occurred when they did not.

Honest placeholders let Monad preserve the intended command shape while implementation catches up. They also make the command catalog a useful artifact. A command can exist in the catalog with a status such as `planned`, `preview`, `partial`, or `implemented`, and tests can verify that the CLI surface and catalog stay aligned.

This model also supports plan-backed mutation. A planned mutating command can be visible while still refusing to mutate until the plan/apply engine and safety boundaries exist.

## Command Status Model

Commands should have explicit status values.

Recommended statuses include:

- `implemented` — command performs its documented behavior;
- `partial` — command performs some behavior but has known missing scope;
- `preview` — command is available for inspection or early feedback but is not stable;
- `planned` — command is intentionally visible but not implemented;
- `deprecated` — command exists but should not be used for new workflows;
- `removed` — command is no longer available, if retained in docs or compatibility metadata.

The exact enum may evolve, but command status must be explicit and testable.

## Safety Metadata

Commands should also expose safety posture.

Important fields include:

- whether the command mutates files;
- whether mutation is plan-backed;
- whether dry-run is supported;
- whether the command uses network access;
- whether the command uses AI;
- whether it can invoke native tools;
- whether it can delete or overwrite files;
- whether it is safe for CI;
- what output formats it supports;
- what exit codes mean.

This metadata helps users, docs, CI workflows, and future AI agents understand command behavior without guessing.

## Placeholder Behavior Rules

Placeholder commands must follow these rules:

- They must identify themselves as not fully implemented.
- They must not perform hidden mutation.
- They must not call network services unless explicitly documented and configured.
- They must not call AI providers.
- They must not claim validation, policy checking, planning, or apply behavior that did not occur.
- They must not produce fake success messages.
- They should point to related roadmap/work packet context where practical.
- They should use a consistent exit behavior.
- They should be covered by command catalog tests.

For example, a planned `monad policy check` command should not print `Policy check passed` unless real policy checks executed. It may instead print that policy checking is planned, describe future behavior, and return the documented placeholder status.

## Exit Code Strategy

Placeholder exit behavior must be documented.

Possible strategies include:

- return success only when the user explicitly requested help or metadata;
- return a distinct non-zero exit code for unimplemented behavior;
- return success for status display but not for operational checks;
- expose machine-readable status so CI can distinguish placeholders from real checks.

The exact exit code strategy may be finalized in CLI output and exit code documentation, but fake success must be avoided.

## Implementation Guidance

The command catalog should be the source for command status and safety metadata.

Recommended implementation steps:

1. Define command metadata model.
2. Add status values.
3. Add safety fields.
4. Add placeholder renderer.
5. Add command catalog contract tests.
6. Add tests that planned commands do not mutate files.
7. Add tests that planned commands do not call network or AI.
8. Document placeholder exit behavior.
9. Ensure help output and docs do not imply implemented behavior where status is planned.
10. Add machine-readable command catalog output where useful.

Command handlers should not each invent their own placeholder language. A shared renderer should make placeholder behavior consistent.

## Consequences

### Positive Consequences

- Users can trust command output.
- Planned command visibility remains useful without deception.
- Command catalog tests can protect intended surface area.
- Development sequencing is clearer.
- CI can avoid treating placeholders as real checks.
- Mutating placeholders remain safe.
- Documentation can describe future commands with clear status.
- Future AI agents can inspect command metadata before using commands.

### Negative Consequences

- Output may feel unfinished while implementation is incomplete.
- Command metadata requires discipline to maintain.
- The planned command surface may appear larger than current capability.
- Placeholder exit code behavior must be designed carefully.
- Users may be confused if planned commands are too visible by default.
- Tests must distinguish command presence from command implementation.

### Required Mitigations

- Use explicit status labels in command output.
- Keep placeholder text consistent and honest.
- Add command catalog contract tests.
- Document command status and exit code semantics.
- Prevent mutating placeholders from writing files.
- Prevent placeholders from calling network or AI.
- Consider hiding planned commands by default if UX becomes confusing.
- Keep documentation aligned with implementation status.

## Alternatives Considered

### Hide Future Commands

Monad could hide all unimplemented commands until they are ready.

This was rejected as the only approach because planned command visibility helps communicate product direction, validate command catalog design, and align docs with the intended runtime surface. However, hiding planned commands by default may be considered if UX becomes confusing.

### Show Commands Without Status

Monad could expose planned commands in help output without clearly marking status.

This was rejected because it misleads users and weakens trust.

### Allow Placeholder Success Messages

Monad could let placeholders return success messages such as `Done` or `Check passed` before implementation exists.

This was rejected because success implies real behavior. Fake success is incompatible with a governance-grade CLI.

### Remove Broad Command Catalog Until Late

Monad could avoid defining the larger command catalog until the implementation is mature.

This was rejected because the command catalog is a useful planning and contract artifact. The better approach is to keep the catalog honest.

## Validation

This decision is validated when:

- command metadata includes implementation status;
- placeholder commands clearly state they are not fully implemented;
- placeholder commands do not mutate files;
- placeholder commands do not call network services;
- placeholder commands do not call AI providers;
- placeholder commands do not emit fake success messages;
- command catalog tests verify that CLI surface and catalog metadata stay aligned;
- docs and help output reflect command maturity;
- CI can distinguish real checks from placeholder status.

## Review Criteria

This ADR should be reconsidered if:

- planned command visibility creates more confusion than value;
- placeholder exit behavior proves incompatible with CI workflows;
- the command catalog strategy changes materially;
- future UX research indicates planned commands should be hidden by default;
- another command maturity model better protects trust and roadmap visibility.

This ADR does not require all planned commands to be visible forever. It requires that any visible incomplete command be honest.

## Related Decisions

This ADR relates to:

- ADR-0001, which establishes the Rust single-binary runtime;
- ADR-0003, which establishes local-first operation;
- ADR-0004, which establishes AI-native but AI-optional behavior;
- ADR-0006, which establishes plan-backed mutation;
- ADR-0007, which proposes modular Rust workspace boundaries;
- future decisions about CLI output format and exit codes;
- future decisions about command catalog schema and stability;
- future decisions about AI agent command safety.
