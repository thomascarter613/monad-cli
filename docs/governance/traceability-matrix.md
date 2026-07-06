# Monad Traceability Matrix

This document is the operational traceability matrix for Monad CLI / Monad OS governance.

It connects requirements, ADRs, work packets, tests, policies, risks, release evidence, and documentation so the repository can explain why artifacts exist and how readiness is proven.

## Traceability Doctrine

Monad should be able to explain:

```text
why an artifact exists
what requirement it serves
what decision shaped it
what work packet delivers it
what test proves it
what policy governs it
what risk it mitigates
what release evidence proves readiness
```

Traceability remains local-first and repository-native. No hosted GRC system is required for core traceability.

## Primary Traceability Chain

```text
Requirement
  -> ADR
    -> Work Packet
      -> BDD Scenario
        -> Test Evidence
          -> Policy / Finding / Risk
            -> Release Evidence
              -> Documentation
```

## Registry Sources

| Registry | Source File |
| -------- | ----------- |
| ADRs | `docs/architecture/adrs/index.md` |
| Architecture blueprints | `docs/architecture/blueprints/README.md` |
| Command architecture | `docs/architecture/other/commands/README.md` |
| Data governance | `docs/data/index.md` |
| Documentation governance | `docs/governance/docs-governance/index.md` |
| Infrastructure governance | `docs/governance/infra-governance/index.md` |
| Compliance governance | `docs/governance/compliance/` |
| RFC process | `docs/governance/rfcs/README.md` |
| Work packets | `docs/roadmap/work-packets/index.md` |
| BDD scenarios | `docs/testing/bdd-index.md` |
| Findings | `docs/reference/findings.md` |
| Release evidence | `docs/reference/release-evidence.md` |
| Risk register | `governance/risk-register.md` |

## Requirement to ADR Matrix

| Requirement | Description | Primary ADRs |
| ----------- | ----------- | ------------ |
| FR-001 | Version and runtime identity reporting | ADR-0001, ADR-0012 |
| FR-002 | Command catalog and honest command status | ADR-0012, ADR-0014 |
| FR-003 | Repository inspection and discovery | ADR-0002, ADR-0003, ADR-0008 |
| FR-004 | Canonical manifest/config resolution | ADR-0005 |
| FR-005 | Baseline validation and diagnostics | ADR-0010, ADR-0014 |
| FR-006 | Lifecycle graph generation | ADR-0008, ADR-0015 |
| FR-007 | Documentation-as-code validation | ADR-0009 |
| FR-008 | Deterministic context/handoff generation | ADR-0011, ADR-0020 |
| FR-009 | Plan, diff, dry-run, and apply | ADR-0006, ADR-0014 |
| FR-010 | Pack/template generation with trust metadata | ADR-0016 |
| FR-011 | Plugin extension boundary | ADR-0017 |
| FR-012 | Optional hosted projection | ADR-0018, ADR-0019 |
| NFR-001 | Local-first operation | ADR-0003 |
| NFR-002 | AI optionality | ADR-0004, ADR-0011, ADR-0020 |
| NFR-003 | No telemetry by default | ADR-0019 |
| NFR-004 | Versioned machine-readable output | ADR-0013 |
| NFR-005 | Stable exit code taxonomy | ADR-0014 |
| NFR-006 | Rebuildable generated state | ADR-0015 |
| NFR-007 | Policy-as-code governance | ADR-0010 |
| NFR-008 | Native tool coordination | ADR-0002 |

## ADR to Governance Documentation Matrix

| ADR | Governance / Architecture Docs |
| --- | ------------------------------ |
| ADR-0001 | `docs/architecture/rust-crate-layout.md`, `docs/architecture/cli-doctrine.md` |
| ADR-0002 | `docs/architecture/tech-radar.md`, `docs/architecture/workspace-model.md` |
| ADR-0003 | `docs/architecture/disaster-recovery-plan.md`, `docs/governance/infra-governance/environment-contracts.md` |
| ADR-0004 | `docs/architecture/other/context/README.md`, `docs/architecture/other/commands/README.md` |
| ADR-0005 | `docs/architecture/workspace-model.md`, `docs/data/index.md` |
| ADR-0006 | `docs/architecture/plan-apply-model.md`, `docs/architecture/cli-doctrine.md` |
| ADR-0007 | `docs/architecture/rust-crate-layout.md` |
| ADR-0008 | `docs/architecture/other/graphs/README.md` |
| ADR-0009 | `docs/governance/docs-governance/index.md` |
| ADR-0010 | `docs/governance/docs-governance/drift-detection.md`, `docs/governance/compliance/soc2-mapping.md` |
| ADR-0011 | `docs/architecture/other/context/README.md`, `docs/governance/compliance/gdpr-data-lineage.md` |
| ADR-0012 | `docs/architecture/other/commands/README.md`, `docs/architecture/cli-doctrine.md` |
| ADR-0013 | `docs/data/canonical-schema.json`, `docs/governance/traceability-matrix.md` |
| ADR-0014 | `docs/architecture/other/commands/README.md`, `docs/architecture/cli-doctrine.md` |
| ADR-0015 | `docs/data/retention-policy.md`, `docs/architecture/other/graphs/README.md` |
| ADR-0016 | `docs/architecture/threat-modeling/README.md`, `docs/governance/compliance/soc2-mapping.md` |
| ADR-0017 | `docs/architecture/threat-modeling/README.md`, `docs/governance/rfcs/README.md` |
| ADR-0018 | `docs/governance/infra-governance/index.md`, `docs/architecture/disaster-recovery-plan.md` |
| ADR-0019 | `docs/governance/compliance/data-retention-policy.md`, `docs/governance/infra-governance/environment-contracts.md` |
| ADR-0020 | `docs/architecture/other/context/README.md`, `docs/governance/compliance/gdpr-data-lineage.md` |

## Governance Area Matrix

| Governance Area | Primary Files | Protected Outcomes |
| --------------- | ------------- | ------------------ |
| Compliance | `docs/governance/compliance/*.md` | retention, lineage, SOC 2-style readiness mapping |
| Documentation governance | `docs/governance/docs-governance/*.md` | documentation invariants, audits, style, drift detection |
| Infrastructure governance | `docs/governance/infra-governance/*.md` | environment contracts, provisioning rules, infrastructure invariants |
| RFC governance | `docs/governance/rfcs/README.md` | structured proposal workflow before durable decisions |
| Data governance | `docs/data/*.md`, `docs/data/*.json` | retention, archival, canonical, forensic, and migration evidence |
| Threat modeling | `docs/architecture/threat-modeling/README.md` | trust boundaries, mitigations, policy/test linkage |

## Policy to Evidence Matrix

| Policy / Control | Protected Requirements | Evidence Candidates |
| ---------------- | ---------------------- | ------------------- |
| POLICY-CANONICAL-MANIFEST | FR-004, NFR-001 | workspace model, manifest tests, canonical schema |
| POLICY-COMMAND-HONESTY | FR-002, NFR-005 | command architecture docs, command contract tests |
| POLICY-DOCS-REQUIRED | FR-007 | documentation audit, docs governance index |
| POLICY-NO-UNSAFE-MUTATION | FR-009 | plan/apply model, dry-run tests, apply reports |
| POLICY-SECRET-REDACTION | FR-008, NFR-002 | context docs, GDPR lineage, redaction tests |
| POLICY-NO-TELEMETRY-BY-DEFAULT | FR-012, NFR-003 | ADR-0019, environment contracts, observability docs |
| POLICY-PACK-PLUGIN-TRUST | FR-010, FR-011 | threat models, SOC 2 mapping, RFC process |
| POLICY-GENERATED-STATE-CLASSIFICATION | FR-006, NFR-006 | data governance, graph docs, retention policy |
| POLICY-RELEASE-READINESS | FR-009, FR-012 | release architecture, release evidence, traceability matrix |

## Risk to Control Matrix

| Risk | Control | Evidence |
| ---- | ------- | -------- |
| Command catalog drift | command honesty policy, catalog contract tests | command architecture docs |
| Source-of-truth confusion | canonical manifest policy | workspace model, data governance index |
| Unsafe mutation | plan-backed mutation | plan/apply model, apply reports |
| Secret leakage | redaction and context rules | context docs, privacy lineage docs |
| AI overreach | no-op adapter and deterministic context | ADR-0020, context docs |
| Hosted prematurity | hosted projection is optional | infra governance, ADR-0018 |
| Docs drift | docs audit and invariants | docs-governance files |
| Schema breakage | versioned output schemas | data schemas, ADR-0013 |
| Hidden telemetry | no telemetry by default | compliance retention, environment contracts |
| Infrastructure drift | environment contracts and infra invariants | infra-governance docs |

## Maintenance Rules

- Update this matrix when ADRs are added, superseded, or renamed.
- Update this matrix when governance directories add new canonical files.
- Prefer local repository paths over external trackers.
- Do not reference planned artifacts as implemented evidence without marking them planned.
- Keep traceability aligned with release evidence and risk register.

## Future Automation

Future Monad commands should be able to validate this matrix by checking:

- referenced files exist;
- ADR IDs exist;
- work packet IDs exist;
- policy IDs exist;
- release evidence exists where claimed;
- planned evidence is not mistaken for accepted evidence.
