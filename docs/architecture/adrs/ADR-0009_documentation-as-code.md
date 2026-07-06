---
id: ADR-0009
title: Documentation-as-Code
status: proposed
date: 2026-07-02
supersedes: []
superseded_by: null
tags: [documentation, docs-as-code, governance, traceability, handoff, v1]
---

# ADR-0009: Documentation-as-Code

## Status

Proposed.

## Context

Monad treats documentation as a first-class lifecycle artifact, not an afterthought.

Modern software repositories contain more than source code. They contain product intent, architecture decisions, roadmap commitments, work packets, security rules, operations procedures, testing expectations, policy constraints, support processes, release evidence, and handoff context. When this knowledge is not versioned with the repository, the repository becomes harder to understand, govern, maintain, and safely evolve.

Important documentation includes:

- product docs;
- architecture docs;
- Architecture Decision Records;
- work packets;
- security docs;
- operations docs;
- governance docs;
- roadmap docs;
- testing docs;
- release docs;
- user guides;
- reference docs;
- runbooks;
- generated handoff artifacts.

If these documents live outside the repository, they are harder to version, inspect, validate, test, diff, review, and include in handoffs. External documents can drift from implementation. Hosted-only documentation can also conflict with Monad's local-first doctrine.

Monad's goal is not merely to generate documentation once. Monad should help the repository explain itself over time. Documentation should participate in repository inspection, lifecycle graph generation, context generation, policy checks, release readiness, and future AI handoffs.

## Decision

Product, architecture, governance, security, operations, ADR, work-packet, roadmap, testing, reference, and support documentation will live in the repository and be treated as documentation-as-code.

Documentation should be version-controlled, reviewable, inspectable, and eventually validatable by Monad. Durable repository knowledge should be represented as files in predictable paths rather than only as external wiki pages, chat history, hosted dashboards, or project management records.

Documentation should be treated as source-of-truth where appropriate, not decoration. ADRs record durable decisions. Work packets record planned implementation units. Product and architecture docs record intent. Security, operations, testing, and governance docs record expectations. Reference docs record schemas and command behavior.

Future Monad commands should include documentation lifecycle operations such as:

```bash
monad docs check
monad docs generate --dry-run
monad adr list
monad adr check
monad workpacket list
monad workpacket check
monad context handoff
```

Generated documentation must be distinguishable from authored documentation. Generated docs should have lineage metadata, source references, or clear file ownership rules where practical.

## Decision Drivers

This decision is driven by the following needs:

- **Repository self-description:** a governed repository should explain what it is, why it exists, how it works, and how it changes.
- **Version control:** important knowledge should be diffable, reviewable, and tied to commits.
- **Local-first operation:** documentation should be inspectable without a hosted wiki or SaaS account.
- **Governance:** ADRs, work packets, policies, and roadmap docs must guide implementation and validation.
- **Traceability:** docs should connect to code, policies, tests, releases, plans, and lifecycle graph nodes.
- **Handoff readiness:** future maintainers and AI assistants need durable context inside the repo.
- **Release readiness:** releases should be able to reference validated docs and evidence.
- **AI-readiness:** deterministic docs improve AI context and reduce hallucination risk.
- **Drift detection:** documentation rules make it possible to detect missing, stale, or inconsistent docs.

## Rationale

Documentation-as-code is central to Monad's identity as a monorepo operating runtime. If Monad governs only source code and ignores lifecycle knowledge, it cannot deliver the traceability, context, and safety expected of a governance-grade tool.

Keeping docs in the repository has practical benefits. Docs can be reviewed with code changes. ADRs can explain why code changed. Work packets can link implementation scope to tests and release evidence. Security and operations docs can be validated alongside the commands they describe. Context generators can pull from stable files rather than from external memories.

This model also supports AI safety. AI assistants are more reliable when they receive deterministic context from repository files. Documentation-as-code provides structured, reviewable context that can be included in handoffs without requiring a hosted knowledge base.

However, documentation must not become empty ceremony. Monad should validate high-value documentation expectations without requiring excessive process for every small change. The goal is useful repository knowledge, not bureaucratic overhead.

## Scope of the Decision

This ADR applies to:

- product documentation;
- architecture documentation;
- ADRs;
- work packets;
- roadmap documentation;
- governance documentation;
- security documentation;
- operations documentation;
- testing documentation;
- reference documentation;
- release evidence documentation;
- generated handoff/context documentation;
- documentation checks and future docs generation.

This ADR does not require every possible document to exist from day one. It establishes that durable documentation belongs in the repository and should be structured for future validation.

This ADR also does not require all documentation to be manually authored. Generated docs may exist, but they must be distinguishable from source docs and should preserve lineage where practical.

## Documentation Ownership Model

Monad should classify documentation into ownership categories.

### Authored Source Documentation

Authored source docs are written and maintained by humans. Examples include:

- `README.md`;
- `docs/product/charter.md`;
- `docs/product/prd.md`;
- `docs/architecture/overview.md`;
- `docs/architecture/adrs/*.md`;
- `docs/roadmap/roadmap.md`;
- `docs/security/security-model.md`;
- `docs/operations/operational-model.md`;
- `docs/engineering/testing-strategy.md`;
- `CONTRIBUTING.md`;
- `SECURITY.md`;
- `SUPPORT.md`.

These files may be canonical source-of-truth artifacts.

### Structured Governance Documentation

Structured governance docs are authored files with predictable metadata or headings. Examples include:

- ADRs;
- work packets;
- risk registers;
- traceability matrices;
- policy process docs;
- release governance docs;
- BDD indexes.

Monad may validate their format, required fields, status values, references, and consistency.

### Generated Documentation

Generated docs are produced by Monad or another tool. Examples may include:

- generated command references;
- generated graph summaries;
- generated API references;
- generated release evidence;
- generated context packs;
- generated handoff files;
- generated docs indexes.

Generated docs should include clear ownership, source references, and regeneration guidance where practical.

### External Documentation Mirrors

External wikis, docs sites, dashboards, and project management tools may exist, but they should not be the only source of durable repository knowledge. If external docs mirror repository docs, the repository docs should remain authoritative unless a future ADR defines otherwise.

## Documentation Validation Model

Future docs checks should be incremental and useful.

Initial validation may check:

- required documentation files exist;
- ADR files have valid IDs, titles, and statuses;
- work packet files have valid IDs and expected sections;
- docs indexes reference existing files;
- links to local files resolve;
- generated docs are not edited where prohibited;
- required headings exist;
- documentation metadata is parseable.

Later validation may check:

- stale docs based on changed source areas;
- ADR references from work packets;
- work packet references from implementation evidence;
- policy references in docs;
- release readiness docs;
- generated docs lineage;
- lifecycle graph consistency;
- documentation coverage for workspace units;
- context pack completeness.

Validation rules should avoid noisy false positives. Documentation checks should help users improve repository understanding, not punish normal development.

## Implementation Guidance

Monad should treat documentation as inspectable artifacts in the lifecycle graph.

Recommended implementation steps:

1. Define required documentation paths for the governed preset.
2. Add ADR discovery and validation.
3. Add work packet discovery and validation.
4. Add docs index validation.
5. Add local link validation.
6. Add docs check diagnostics.
7. Add documentation nodes to the lifecycle graph.
8. Add generated docs lineage metadata.
9. Add dry-run documentation generation.
10. Add documentation freshness checks only after reliable signals exist.

Documentation checks should produce structured findings with severity, path, rule ID, message, and remediation guidance.

Mutation commands that generate or update documentation should be plan-backed. Generated docs should not be silently overwritten without clear ownership rules.

## Consequences

### Positive Consequences

- Repository knowledge becomes version-controlled and reviewable.
- Monad can inspect and validate docs locally.
- ADRs and work packets become durable governance artifacts.
- Context and handoff generation become more reliable.
- AI assistance can use deterministic repository documentation.
- Release readiness can include documentation evidence.
- Lifecycle graph traceability becomes stronger.
- Knowledge loss is reduced when contributors leave or context shifts.

### Negative Consequences

- Documentation can drift if validation rules are weak or absent.
- Documentation checks can create noise if rules are too strict.
- Generated documentation needs ownership and lineage metadata.
- Users may resist documentation ceremony if it feels heavy.
- Maintaining docs requires discipline alongside code changes.
- Some knowledge may still need external collaboration tools.

### Required Mitigations

- Start with lightweight, high-value documentation checks.
- Avoid requiring excessive docs for trivial changes.
- Make validation findings actionable and severity-based.
- Distinguish authored docs from generated docs.
- Use plan-backed mutation for docs generation or updates.
- Document required files and ownership rules clearly.
- Add freshness checks only when they can be reliable.
- Keep external documentation optional and secondary to repository source docs.

## Alternatives Considered

### External Wiki as Primary Documentation

Monad could use an external wiki or knowledge base as the primary documentation model.

This was rejected as the primary model because external docs drift from code, are harder for local CLI inspection, and may require hosted accounts or services. External docs may still mirror or publish repository docs.

### Hosted Documentation Only

Monad could rely on a future hosted control plane or documentation dashboard.

This was rejected because hosted-only docs conflict with local-first operation. A hosted dashboard may render or enhance repository docs later, but should not be required for core documentation governance.

### No Formal Documentation Validation

Monad could treat documentation as ordinary Markdown with no validation.

This was rejected because Monad's governance-grade value depends on structured, inspectable lifecycle artifacts. Without validation, ADRs, work packets, docs indexes, and release evidence can drift silently.

### Generated Documentation Only

Monad could generate most documentation from code and manifests.

This was rejected because some documentation records human intent, tradeoffs, product goals, decisions, and governance expectations that cannot be fully inferred from code. Generated docs are useful, but authored source docs remain necessary.

## Validation

This decision is validated when:

- required repository docs can be discovered locally;
- ADR files can be listed and validated;
- work packet files can be listed and validated;
- docs checks produce structured findings;
- documentation nodes can be represented in the lifecycle graph;
- docs generation, where mutating, is plan-backed;
- generated docs can be distinguished from authored docs;
- context and handoff generation can include repository documentation;
- documentation validation improves repository understanding without excessive false positives.

## Review Criteria

This ADR should be reconsidered if:

- documentation-as-code creates more friction than governance value;
- a future hosted documentation model supersedes local documentation while explicitly accepting the local-first tradeoff;
- repository documentation proves insufficient for traceability, handoff, and AI context;
- another knowledge-management model provides stronger local-first validation and versioning.

Because this ADR is Proposed, details may evolve as docs commands, ADR validation, work packet validation, and lifecycle graph integration mature. The protected principle is that durable repository knowledge lives with the repository and remains inspectable by Monad.

## Related Decisions

This ADR relates to:

- ADR-0003, which establishes local-first core behavior;
- ADR-0004, which establishes AI-native but AI-optional behavior;
- ADR-0005, which establishes `monad.toml` as canonical manifest;
- ADR-0006, which establishes plan-backed mutation;
- ADR-0008, which establishes lifecycle graph as a core model;
- future decisions about policy-as-code;
- future decisions about deterministic context before AI assistance;
- future decisions about release evidence and traceability.
