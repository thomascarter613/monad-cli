# 13. Testing Strategy

## 13.1 Testing Summary

Monad must be built with a serious TDD/BDD/DDD-compatible testing model.

Testing must protect:

* command surface,
* manifest parsing,
* source-of-truth rules,
* read-only command safety,
* graph generation,
* context generation,
* policy evaluation,
* plan/apply safety,
* output schemas,
* documentation consistency,
* native tool integration,
* migration behavior.

## 13.2 Testing Philosophy

Monad’s test strategy should be based on this principle:

> If Monad claims to understand, validate, document, or mutate a repository, there must be tests proving that behavior.

## 13.3 Test Categories

### 13.3.1 Unit Tests

Purpose:

* validate pure domain logic,
* test manifest resolution,
* test command metadata,
* test policy rules,
* test plan models,
* test graph node/edge creation.

Examples:

```text id="wpu3hy"
canonical_manifest_wins_over_workspace_mirror
command_metadata_declares_mutation_status
plan_requires_steps_before_apply
policy_finding_has_stable_id
context_redaction_excludes_env_files
```

### 13.3.2 Integration Tests

Purpose:

* test commands against fixture repositories.

Example fixtures:

```text id="1g2osn"
fixtures/empty-repo
fixtures/minimal-monad-repo
fixtures/manifest-conflict-repo
fixtures/rust-workspace
fixtures/polyglot-workspace
fixtures/docs-missing-repo
fixtures/policy-violation-repo
```

### 13.3.3 CLI Smoke Tests

Purpose:

* verify real binary behavior.

Examples:

```bash id="vel6to"
monad version
monad list
monad config
monad inspect
monad check
monad doctor
```

### 13.3.4 Contract Tests

Purpose:

* ensure command catalog and CLI surface remain aligned.

Existing contract pattern should be expanded:

```text id="ru6t61"
clap_surface_exposes_every_catalog_command
catalog_does_not_claim_unknown_example_commands
implemented_commands_have_tests
mutating_commands_declare_plan_status
placeholder_commands_are_honest
```

### 13.3.5 Snapshot Tests

Purpose:

* prevent accidental output regressions.

Use for:

* help output,
* command list output,
* inspect output,
* graph Mermaid output,
* context handoff output,
* docs reports,
* policy reports.

### 13.3.6 Schema Tests

Purpose:

* validate JSON outputs.

Schemas:

```text id="dbq5m9"
command-catalog.schema.json
inspection-report.schema.json
graph.schema.json
context-pack.schema.json
plan.schema.json
policy-report.schema.json
docs-report.schema.json
```

### 13.3.7 Property-Based Tests

Useful for:

* path normalization,
* graph invariants,
* command name parsing,
* manifest merge behavior,
* plan operation ordering.

Examples:

```text id="sgwos9"
graph_edges_never_reference_missing_nodes
normalized_paths_are_idempotent
manifest_resolution_is_deterministic
plan_step_ordering_is_stable
```

### 13.3.8 Mutation Safety Tests

Before enabling mutation, test:

* dry-run does not write files,
* apply writes only planned files,
* apply refuses unapproved plans,
* file deletion requires explicit approval,
* failed apply reports partial state,
* rollback hints are generated.

### 13.3.9 Security Tests

Test:

* context excludes secrets,
* `.env` files ignored,
* private key patterns redacted,
* plugins disabled by default,
* network disabled by default,
* unsafe command blocked without approval.

### 13.3.10 BDD Tests

Use Gherkin-style scenarios for core workflows:

* inspect repo,
* check repo,
* generate handoff,
* create plan,
* dry-run plan,
* apply plan,
* detect manifest conflict,
* block unsafe mutation.

### 13.3.11 AI Evaluation Tests

Since AI is optional, early tests should validate deterministic AI-free behavior.

Future AI tests:

* context pack quality,
* prompt template rendering,
* provider fallback,
* AI output converted to plan,
* unsafe AI suggestion rejected by policy.

## 13.4 Test Pyramid / Trophy

Recommended shape:

```text id="mx7osx"
Many unit tests
Many fixture integration tests
Moderate CLI smoke tests
Moderate contract/schema tests
Some BDD end-to-end tests
Few expensive native-tool integration tests
```

## 13.5 TDD Workflow

Recommended cycle:

```text id="dbj8ab"
1. Write failing unit/contract/fixture test.
2. Implement smallest domain behavior.
3. Add CLI integration if command-facing.
4. Add snapshot/schema test if output-facing.
5. Update docs.
6. Run full workspace tests.
```

## 13.6 BDD Workflow

For each user-visible workflow:

```text id="cvzp26"
Feature
  Scenario
    Given repo fixture
    When command runs
    Then expected finding/output/exit code occurs
```

BDD scenarios should map to work packet acceptance criteria.

## 13.7 DDD Testing Alignment

Each bounded context should own tests:

```text id="qfn8u4"
Workspace Context -> manifest/source-of-truth tests
Command Context -> catalog/CLI contract tests
Inspection Context -> fixture repo tests
Graph Context -> graph invariant tests
Governance Context -> ADR/work-packet tests
Plan Context -> plan/apply tests
Policy Context -> policy evaluation tests
Context Context -> handoff/context tests
Docs Context -> docs check/generate tests
```

## 13.8 CI Quality Gates

Minimum early gate:

```bash id="spw5ip"
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
```

Stronger gate:

```bash id="rsmcyv"
cargo clippy --workspace --all-targets -- -D warnings
cargo test --workspace
cargo test -p monad-cli --test command_catalog_contract
```

Future gate:

```bash id="r8tm9q"
cargo deny check
cargo audit
cargo nextest run
cargo llvm-cov
schema validation
snapshot tests
docs check
policy check
```

## 13.9 Definition of Ready

A work packet is ready when it has:

* purpose,
* scope,
* out-of-scope,
* affected bounded contexts,
* acceptance criteria,
* tests to add,
* docs to update,
* risks,
* rollback plan if mutating,
* known dependencies.

## 13.10 Definition of Done

A work packet is done when:

* implementation is complete,
* tests pass,
* command catalog is updated,
* docs are updated,
* ADRs are added if needed,
* examples are updated if needed,
* safety constraints are preserved,
* acceptance criteria are satisfied,
* CI is green.
