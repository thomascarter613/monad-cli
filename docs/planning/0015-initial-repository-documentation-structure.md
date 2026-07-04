# 16. Initial Repository and Documentation Structure

## 16.1 Repository Structure Strategy

Monad should use a systems-grade monorepo structure even while the executable is initially a Rust CLI.

The repository should make the product’s governance model visible.

Recommended top-level structure:

```text id="xtg780"
monad-cli/
  Cargo.toml
  Cargo.lock
  monad.toml
  workspace.toml
  monad.lock
  README.md
  CONTRIBUTING.md
  CODE_OF_CONDUCT.md
  SECURITY.md
  SUPPORT.md
  LICENSE
  crates/
  docs/
  governance/
  policies/
  examples/
  fixtures/
  scripts/
  tools/
  tests/
  .github/
  .devcontainer/
  .monad/
```

## 16.2 Source Code Structure

```text id="lq8f5c"
crates/
  monad-cli/
    Cargo.toml
    src/
      main.rs
      lib.rs
      command_catalog.rs
      output.rs
      commands/
        mod.rs
        version.rs
        list.rs
        config.rs
        inspect.rs
        check.rs
        doctor.rs
        graph.rs
        diff.rs
        context.rs
        docs.rs
        adr.rs
        workpacket.rs
        policy.rs
        plan.rs
        apply.rs
  monad-core/
    Cargo.toml
    src/
      lib.rs
      workspace.rs
      command.rs
      finding.rs
      error.rs
      format.rs
  monad-config/
    Cargo.toml
    src/
      lib.rs
      manifest.rs
      root.rs
      source_of_truth.rs
  monad-inspect/
    Cargo.toml
    src/
      lib.rs
      report.rs
      scanner.rs
      detectors/
  monad-graph/
    Cargo.toml
    src/
      lib.rs
      graph.rs
      node.rs
      edge.rs
      export/
  monad-context/
    Cargo.toml
    src/
      lib.rs
      handoff.rs
      pack.rs
      redaction.rs
  monad-docs/
    Cargo.toml
    src/
      lib.rs
      check.rs
      generate.rs
      templates.rs
  monad-policy/
    Cargo.toml
    src/
      lib.rs
      rule.rs
      evaluate.rs
      explain.rs
      waiver.rs
  monad-plans/
    Cargo.toml
    src/
      lib.rs
      plan.rs
      step.rs
      file_op.rs
      apply.rs
      dry_run.rs
  monad-packs/
    Cargo.toml
    src/
      lib.rs
      pack.rs
      template.rs
      profile.rs
```

## 16.3 Documentation Structure

```text id="e288pk"
docs/
  index.md
  product/
    charter.md
    prd.md
    positioning.md
    personas.md
    use-cases.md
  roadmap/
    roadmap.md
    milestones.md
    work-packets/
      index.md
      wp-0000-product-and-repository-foundation.md
      wp-0001-rust-workspace-and-cli-foundation.md
      wp-0002-canonical-manifest-and-workspace-model.md
      wp-0003-documentation-and-governance-foundation.md
  architecture/
    overview.md
    principles.md
    system-context.md
    data-architecture.md
    ai-architecture.md
    security-architecture.md
    decision-records/
      index.md
      adr-0001-rust-single-binary-runtime.md
      adr-0002-coordinate-native-tools.md
      adr-0003-local-first-core.md
      adr-0004-ai-native-but-ai-optional.md
      adr-0005-canonical-manifest.md
  engineering/
    development-workflow.md
    testing-strategy.md
    command-catalog.md
    output-formats.md
    release-process.md
  security/
    security-model.md
    threat-model.md
    secret-handling.md
    supply-chain-security.md
  operations/
    operational-model.md
    runbooks/
      workspace-not-detected.md
      manifest-conflict.md
      command-catalog-mismatch.md
      docs-check-failed.md
      context-export-safety.md
      plan-apply-failed.md
  governance/
    governance-model.md
    adr-process.md
    work-packet-process.md
    policy-process.md
    release-governance.md
  user-guide/
    installation.md
    getting-started.md
    commands.md
    configuration.md
    context-handoff.md
  reference/
    manifest.md
    command-catalog.md
    plan-schema.md
    graph-schema.md
    policy-schema.md
```

## 16.4 Governance Structure

```text id="ghuk3t"
governance/
  README.md
  decision-log.md
  risk-register.md
  traceability-matrix.md
  release-gates.md
  review-process.md
  waivers/
    README.md
```

## 16.5 Policy Structure

```text id="hn1yvh"
policies/
  README.md
  core/
    canonical-manifest.policy.md
    command-catalog.policy.md
    docs-required.policy.md
    no-unsafe-mutation.policy.md
    secret-redaction.policy.md
  examples/
    enterprise-governance.policy.md
    solo-developer.policy.md
```

## 16.6 Fixtures Structure

```text id="jazt9q"
fixtures/
  empty-repo/
  minimal-monad-repo/
  manifest-conflict-repo/
  rust-workspace/
  polyglot-workspace/
  docs-missing-repo/
  policy-violation-repo/
  context-secret-repo/
```

## 16.7 Examples Structure

```text id="ne4uxk"
examples/
  minimal/
  rust-workspace/
  polyglot-monorepo/
  docs-governed-repo/
  ai-context-handoff/
  plan-backed-mutation/
```

## 16.8 CI/CD Structure

```text id="kvdffc"
.github/
  workflows/
    ci.yml
    release.yml
    security.yml
  ISSUE_TEMPLATE/
    bug_report.yml
    feature_request.yml
    work_packet.yml
    adr_request.yml
  PULL_REQUEST_TEMPLATE.md
  CODEOWNERS
```

## 16.9 Script Structure

```text id="j9jpm4"
scripts/
  check-rust-workspace.sh
  generate-command-catalog-report.py
  validate-docs.py
  validate-adrs.py
  validate-work-packets.py
  release-check.py
```

Given your terminal constraints, scripts should be optional, simple, and executable with explicit commands. Avoid relying on fragile heredoc creation workflows.

## 16.10 `.monad/` Structure

```text id="fyb8j5"
.monad/
  README.md
  cache/
  context/
  inspections/
  graph/
  plans/
  tmp/
```

`.monad/README.md` should explain:

* which files are cache,
* which files are safe to delete,
* which files should not be committed,
* which files may be intentionally promoted.

Recommended `.gitignore` treatment:

```text id="u670qw"
.monad/cache/
.monad/tmp/
.monad/inspections/
.monad/graph/
.monad/plans/*.tmp.json
```

Context outputs may be either ignored or committed depending on project policy.
