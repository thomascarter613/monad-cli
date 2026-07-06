---
id: ADR-0016
title: Pack and Template Trust Model
status: proposed
date: 2026-07-06
supersedes: []
superseded_by: null
tags: [packs, templates, trust, supply-chain, plan, v1]
---

# ADR-0016: Pack and Template Trust Model

## Status

Proposed.

## Context

Monad will eventually support packs and templates that help generate repository structure, tooling configuration, documentation, policies, examples, and ecosystem-specific defaults.

Packs and templates are powerful because they can create or modify many files at once. They may also encode conventions, dependencies, native tool configuration, CI workflows, security posture, and future generator logic.

That power creates trust and supply-chain risk. A pack or template can introduce insecure defaults, overwrite user files, include stale dependencies, add unexpected network behavior, or generate files that look official but are not trustworthy.

Monad therefore needs a trust model for packs and templates before they become a major extension mechanism.

## Decision

Packs and templates must be treated as untrusted or partially trusted inputs unless their source, version, and permissions are explicitly known.

Pack/template execution must be plan-backed when it changes repository state. Users must be able to inspect intended file operations before apply.

Monad should distinguish:

- built-in packs shipped with the trusted Monad binary;
- local packs from the current repository or local filesystem;
- organization-approved packs;
- registry packs;
- community packs;
- experimental packs.

Each pack or template should eventually carry metadata such as:

- name;
- version;
- source;
- author or publisher;
- trust level;
- license;
- supported Monad version;
- required permissions;
- files it may create or modify;
- native tools it may invoke;
- whether it uses network access;
- whether it can execute code;
- checksum or signature metadata where available.

## Decision Drivers

This decision is driven by:

- **Filesystem safety:** packs and templates can create or overwrite many files.
- **Supply-chain trust:** third-party packs introduce provenance risk.
- **Plan-backed mutation:** generated changes must be reviewable.
- **Local-first behavior:** local packs should work without a hosted registry.
- **User trust:** users need to know where a pack came from and what it intends to do.
- **Policy enforcement:** organizations may need to restrict pack sources or capabilities.
- **AI safety:** AI-suggested pack usage must still pass through trust and plan boundaries.

## Rationale

Packs and templates are part of Monad's value, but they are also a potential attack surface. Treating all templates as harmless text generation would be unsafe. Even a simple template can modify CI, install dependencies, or change security posture.

A trust model lets Monad support extension without losing governance. Built-in packs can be trusted more than arbitrary registry packs, but even built-in packs should produce reviewable plans when they mutate repositories.

This model also keeps registry support optional. Local and built-in packs can work first. Remote registries, signatures, ratings, and organization approval workflows can come later.

## Trust Levels

Recommended trust levels:

- `builtin` — shipped with Monad and versioned with the binary;
- `local` — loaded from local filesystem or current repository;
- `organization-approved` — approved by a configured organization policy;
- `registry-verified` — fetched from a registry with provenance metadata;
- `community` — third-party pack with limited trust;
- `experimental` — unstable or test-only pack.

Trust level should affect warnings, allowed operations, and policy checks. It should not silently bypass plan-backed mutation.

## Permission Model

Packs and templates should declare capabilities when capabilities become relevant.

Possible capabilities include:

- create files;
- modify files;
- delete files;
- update canonical manifest;
- update native manifests;
- invoke native tools;
- run scripts;
- access network;
- generate docs;
- generate CI workflows;
- install dependencies.

High-risk capabilities should require explicit review and may be blocked by policy.

## Implementation Guidance

Recommended implementation steps:

1. Start with built-in and local packs only.
2. Define pack metadata schema.
3. Require plan-backed file operations.
4. Add trust level and source metadata to generated plans.
5. Add policy checks for pack source and capabilities.
6. Add checksum/signature support before trusting remote registry packs.
7. Add registry support only after local pack behavior is safe.
8. Document official versus community pack expectations.

Pack/template rendering should not directly write files. It should produce plan operations that the plan/apply layer validates.

## Consequences

### Positive Consequences

- Packs and templates can grow without bypassing safety boundaries.
- Users can review generated changes.
- Third-party extension risk is made explicit.
- Future registry support has a trust foundation.
- Policy can restrict pack sources and capabilities.
- Built-in, local, and community packs can be handled differently.

### Negative Consequences

- Pack metadata adds authoring overhead.
- Some simple templates may feel more ceremonial.
- Trust and capability rules require documentation.
- Registry support becomes more complex.
- Users may need education about official versus community packs.

### Required Mitigations

- Keep early pack metadata simple.
- Make plan output clear and readable.
- Start with built-in/local packs before remote registry support.
- Add capability checks incrementally.
- Avoid executing arbitrary pack code by default.
- Add policy hooks before high-risk pack behavior is enabled.

## Alternatives Considered

### Treat Templates as Plain Files

Rejected because templates can change repository behavior and security posture.

### Trust All Registry Packs

Rejected because remote packs need provenance, versioning, and policy controls.

### Disable Third-Party Packs Forever

Rejected because extension is valuable, but it must be governed.

### Execute Pack Code Freely

Rejected because arbitrary code execution belongs behind a stricter plugin trust boundary.

## Validation

This decision is validated when:

- pack/template operations produce reviewable plans;
- pack metadata records source and version;
- built-in and local packs are distinguished;
- high-risk operations are visible before apply;
- policy can restrict pack sources or capabilities;
- remote registry packs are not treated as trusted without provenance.

## Review Criteria

This ADR should be reconsidered if the pack system intentionally becomes plugin-like and accepts a different execution trust model, or if registry support requires a stronger supply-chain architecture.

## Related Decisions

This ADR relates to ADR-0006 Plan-Backed Mutation, ADR-0017 Plugin Execution and Trust Boundary, ADR-0010 Policy-as-Code, ADR-0019 No Telemetry by Default, and ADR-0002 Coordinate Native Tools Instead of Replacing Them.
