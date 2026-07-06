docs
├── 00-index.md
├── architecture
│   ├── adrs
│   │   ├── ADR-0001_rust-single-binary-runtime.md
│   │   ├── ADR-0002_coordinate-native-tools-instead-of-replacing-them.md
│   │   ├── ADR-0003_local-first-core.md
│   │   ├── ADR-0004_ai-native-but-ai-optional.md
│   │   ├── ADR-0005_monad-toml-is-the-canonical-manifest.md
│   │   ├── ADR-0006_plan-backed-mutation.md
│   │   ├── ADR-0007_modular-rust-workspace.md
│   │   ├── ADR-0008_lifecycle-graph-as-core-model.md
│   │   ├── ADR-0009_documentation-as-code.md
│   │   ├── ADR-0010_policy-as-code.md
│   │   ├── ADR-0011_deterministic-context-before-ai-assistance.md
│   │   ├── ADR-0012_honest-placeholder-commands.md
│   │   ├── ADR-0013_versioned-machine-readable-output-schemas.md
│   │   ├── ADR-0014_stable-cli-exit-code-taxonomy.md
│   │   ├── ADR-0015_local-graph-cache-is-rebuildable-generated-state.md
│   │   ├── ADR-0016_pack-and-template-trust-model.md
│   │   ├── ADR-0017_plugin-execution-and-trust-boundary.md
│   │   ├── ADR-0018_hosted-control-plane-is-optional-projection-layer.md
│   │   ├── ADR-0019_no-telemetry-by-default.md
│   │   ├── ADR-0020_ai-provider-port-and-noop-adapter.md
│   │   ├── index.md
│   │   └── README.md
│   ├── blueprints
│   │   └── README.md
│   ├── cli-doctrine.md
│   ├── decision-records
│   │   └── index.md
│   ├── disaster-recovery-plan.md
│   ├── other
│   │   ├── commands
│   │   │   ├── monad-cli.md
│   │   │   └── README.md
│   │   ├── context
│   │   │   └── README.md
│   │   ├── graphs
│   │   │   └── README.md
│   │   ├── observability
│   │   │   └── README.md
│   │   ├── releases
│   │   │   └── README.md
│   │   └── security
│   │       └── README.md
│   ├── plan-apply-model.md
│   ├── rust-crate-layout.md
│   ├── tech-radar.md
│   ├── threat-modeling
│   │   └── README.md
│   └── workspace-model.md
├── artifacts
│   ├── artifact-audit.md
│   ├── artifact-governance.md
│   ├── artifact-lifecycle.md
│   ├── artifact-provenance-ledger.md
│   ├── index.md
│   └── release-evidence.md
├── data
│   ├── archival-process.md
│   ├── archival-schema.json
│   ├── canonical-schema.json
│   ├── forensic-schema.json
│   ├── index.md
│   ├── migration-governance.md
│   ├── migration-history.md
│   ├── migration-replay.md
│   └── retention-policy.md
├── development
│   ├── ci-cd-pipeline-spec.md
│   ├── local-dev-accelerator.md
│   ├── onboarding.md
│   ├── style-and-patterns.md
│   └── testing-strategy.md
├── epistemics
│   ├── ambiguity-elimination.md
│   ├── index.md
│   ├── institutional-interpretation.md
│   ├── meaning-preservation.md
│   └── semantic-stability.md
├── ergonomics
│   ├── cognitive-load-map.md
│   ├── complexity-controls.md
│   ├── index.md
│   ├── safe-onboarding.md
│   └── steward-ergonomics.md
├── evolution
│   ├── anti-drift-mechanisms.md
│   ├── architectural-evolution.md
│   ├── domain-evolution.md
│   ├── evolution-constraints.md
│   ├── index.md
│   └── rule-evolution.md
├── governance
│   ├── compliance
│   │   ├── data-retention-policy.md
│   │   ├── gdpr-data-lineage.md
│   │   └── soc2-mapping.md
│   ├── docs-governance
│   │   ├── documentation-audit.md
│   │   ├── documentation-governance.md
│   │   ├── documentation-invariants.md
│   │   ├── drift-detection.md
│   │   ├── index.md
│   │   ├── open-source-licenses.md
│   │   ├── README.md
│   │   └── style-guide.md
│   ├── infra-governance
│   │   ├── environment-contracts.md
│   │   ├── index.md
│   │   ├── infra-drift-detection.md
│   │   ├── infra-invariants.md
│   │   └── provisioning-governance.md
│   ├── rfcs
│   └── traceability-matrix.md
├── interfaces
│   ├── api-specs
│   ├── schemas
│   └── webhooks-and-events.md
├── interoperability
│   ├── cross-system-contracts.md
│   ├── external-governance.md
│   ├── federation-governance.md
│   ├── index.md
│   └── interoperability-invariants.md
├── meta
│   ├── definitions.md
│   ├── glossary.md
│   ├── index.md
│   ├── institutional-terms.md
│   └── taxonomy.md
├── operations
│   ├── capacity-planning.md
│   ├── runbooks
│   │   ├── cache-stampede-mitigation.md
│   │   ├── db-primary-failover.md
│   │   └── triage-p1-incident.md
│   └── telemetry
│       ├── alert-definitions.md
│       ├── dashboards.md
│       └── metrics-dictionary.md
├── philosophy
│   ├── design-rationale.md
│   ├── governance-rationale.md
│   ├── index.md
│   ├── invariants-rationale.md
│   ├── stewardship-philosophy.md
│   └── system-philosophy.md
├── planning
│   ├── 0000-product-understanding-and-assumptions.md
│   ├── 0001-executive-summary.md
│   ├── 0002-product-charter.md
│   ├── 0003-product-requirements-document.md
│   ├── 0004-domain-model-and-ddd-design.md
│   ├── 0005-architecture-strategy.md
│   ├── 0006-ai-architecture.md
│   ├── 0007-data-architecture.md
│   ├── 0008-api-and-integration-design.md
│   ├── 0009-security-privacy-compliance-governance.md
│   ├── 0010-infra-and-cloud-agnostic-deployment-plan.md
│   ├── 0011-observability-and-operations.md
│   ├── 0012-testing-strategy.md
│   ├── 0013-BDD-specification-set.md
│   ├── 0014-implementation-roadmap.md
│   ├── 0015-initial-repository-documentation-structure.md
│   ├── 0016-initial-documentation-files.md
│   ├── 0017-ADR-set.md
│   ├── 0018-traceability-matrix.md
│   ├── 0019-risk-register.md
│   ├── 0020-gvernance-and-decision-system.md
│   ├── 0021-execution-plan.md
│   ├── 0022-technology-strategy.md
│   ├── 0023-final-review.md
│   ├── index.md
│   ├── master-prompt.md
│   └── parts
│       ├── monad-cli-v1-command-reference.md
│       ├── monad-planning-package-part-1.md
│       ├── monad-planning-package-part-2.md
│       ├── monad-planning-package-part-3.md
│       └── monad-planning-package-part-4.md
├── product-and-domain
│   ├── domain-glossary.md
│   ├── prd.md
│   ├── pre-v1-convergence-iterations.md
│   ├── product-requirements-matrix.md
│   ├── requirements-index.md
│   ├── tenant-isolation-model.md
│   ├── v1-command-reference.md
│   ├── v1-defaults.md
│   ├── v1-non-goals.md
│   └── v1-scope.md
├── reference
│   ├── findings.md
│   └── ids.md
├── risk-register.md
├── roadmap
│   ├── roadmap.md
│   └── workpackets
│       ├── categories
│       │   ├── compliance.md
│       │   ├── evolution.md
│       │   ├── governance.md
│       │   ├── initialization.md
│       │   ├── README.md
│       │   └── release.md
│       ├── epics
│       │   ├── epic-0000-work-packet-standard.md
│       │   ├── epic-0001-cli-and-workspace-foundation.md
│       │   ├── epic-0002-plan-and-safety-foundation.md
│       │   ├── epic-0003-generation-foundation.md
│       │   ├── epic-0004-core-workspace-operations.md
│       │   ├── epic-0005-native-tool-coordination.md
│       │   ├── epic-0006-graph-engine.md
│       │   ├── epic-0007-docs-adr-workpacket.md
│       │   ├── epic-0008-context-and-handoff.md
│       │   ├── epic-0009-policy-and-governance.md
│       │   ├── epic-0010-repository-evolution.md
│       │   ├── epic-0011-release-workflow.md
│       │   ├── epic-0012-quality-gates.md
│       │   ├── epic-0013-dogfood.md
│       │   ├── epic-0014-pre-v1-stabilization.md
│       │   └── epic-0015-release.md
│       ├── index.md
│       ├── README.md
│       ├── schema.md
│       ├── sprints
│       │   ├── sprint-0000-work-packet-standard.md
│       │   ├── sprint-0001-foundation.md
│       │   ├── sprint-0002-safety-and-plans.md
│       │   ├── sprint-0003-init-and-packs.md
│       │   ├── sprint-0004-generate-and-inspect.md
│       │   ├── sprint-0005-native-tooling.md
│       │   ├── sprint-0006-graph-docs-adr-workpacket.md
│       │   ├── sprint-0007-context-and-policy.md
│       │   ├── sprint-0008-evolution-and-release.md
│       │   ├── sprint-0009-testing-and-ci.md
│       │   ├── sprint-0010-dogfood.md
│       │   ├── sprint-0011-stabilization-a.md
│       │   ├── sprint-0012-stabilization-b.md
│       │   ├── sprint-0013-stabilization-c.md
│       │   ├── sprint-0014-final-stabilization.md
│       │   └── sprint-0015-release.md
│       ├── templates
│       │   ├── epic-template.md
│       │   ├── sprint-template.md
│       │   └── workpacket-template.md
│       ├── WP-0000-work-packet-specification-and-schema.md
│       ├── WP-0001-rust-workspace-and-cli-skeleton.md
│       ├── WP-0002-core-workspace-model-and-manifest-schema.md
│       ├── WP-0003-filesystem-safety-layer.md
│       ├── WP-0004-plan-diff-apply-engine.md
│       ├── WP-0005-monad-init.md
│       ├── WP-0006-built-in-packs-and-templates.md
│       ├── WP-0007-monad-add-and-monad-generate.md
│       ├── WP-0008-inspect-list-check-doctor-config-version.md
│       ├── WP-0009-sync-run-build-test-lint-format-clean.md
│       ├── WP-0010-graph-engine.md
│       ├── WP-0011-docs-adr-and-workpacket-commands.md
│       ├── WP-0012-context-pack-and-handoff.md
│       ├── WP-0013-policy-and-waiver-system.md
│       ├── WP-0014-remove-rename-move-migrate-upgrade.md
│       ├── WP-0015-release-commands.md
│       ├── WP-0016-test-matrix-and-fixtures.md
│       ├── WP-0017-ci-security-and-quality-gates.md
│       ├── WP-0018-dogfood-monad-on-monad.md
│       ├── WP-0019-scope-lock-iteration.md
│       ├── WP-0020-command-contract-iteration.md
│       ├── WP-0021-workspace-model-integrity-iteration.md
│       ├── WP-0022-plan-diff-apply-safety-iteration.md
│       ├── WP-0023-generator-completeness-iteration.md
│       ├── WP-0024-native-tool-interop-iteration.md
│       ├── WP-0025-governance-and-policy-iteration.md
│       ├── WP-0026-graph-and-context-iteration.md
│       ├── WP-0027-ux-and-diagnostics-iteration.md
│       ├── WP-0028-test-matrix-iteration.md
│       ├── WP-0029-dogfood-iteration.md
│       ├── WP-0030-release-candidate-iteration.md
│       └── WP-0031-v100-release.md
├── roles
│   ├── authority-boundaries.md
│   ├── index.md
│   ├── philosophy
│   ├── role-charters.md
│   └── stewardship-contracts.md
├── safety
│   ├── governance-safety.md
│   ├── harm-model.md
│   ├── index.md
│   ├── institutional-safety.md
│   ├── risk-register.md
│   └── safety-invariants.md
├── testing
│   └── bdd-index.md
├── toolchain
│   ├── ai-assistance-governance.md
│   ├── compiler-governance.md
│   ├── generator-governance.md
│   ├── index.md
│   └── toolchain-governance.md
├── validation
│   ├── cross-domain-validation.md
│   ├── domain-validation.md
│   ├── index.md
│   └── institutional-validation.md
└── verification
    ├── correctness-proofs.md
    ├── formal-methods.md
    ├── governance-verification.md
    ├── index.md
    └── invariant-checkers.md

50 directories, 262 files
