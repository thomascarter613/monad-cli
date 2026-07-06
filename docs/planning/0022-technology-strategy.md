# 23. Technology Strategy

## 23.1 Purpose of This Section

This section defines the technology strategy for Monad OS / Monad CLI.

Monad is intended to become a local-first, governance-grade, AI-ready but AI-optional SDLC control plane and monorepo operating system. The first runtime surface is the `monad` CLI, implemented as a Rust single-binary command-line tool.

The purpose of this section is to define the technology choices, sequencing, constraints, and avoidance rules that should guide Monad’s implementation.

Technology strategy should prevent two opposite failures:

1. choosing tools too casually and creating long-term architectural debt;
2. over-engineering the stack before the product has earned the complexity.

Monad should prefer boring, reliable, local-first, testable technologies that support the product doctrine:

```text id="q9y6s4"
Local-first before hosted.
Deterministic before AI.
Read-only understanding before mutation.
Plan-backed mutation before generators.
Source-of-truth rules before automation.
Command contracts before command depth.
Graph foundations before graph persistence.
Policy checks before policy enforcement.
Templates before plugins.
Solo-developer usability before enterprise extensibility.
```

The technology strategy is not a list of fashionable tools.

It is a set of constraints for building a trustworthy local control plane.

---

## 23.2 Technology Strategy Principles

Technology choices should follow architecture needs.

Monad should prefer:

* boring, reliable tools,
* local-first tools,
* testable libraries,
* portable formats,
* minimal required dependencies,
* explicit adapters,
* strong schema and versioning discipline,
* deterministic behavior,
* inspectable generated artifacts,
* and clear source-of-truth boundaries.

Monad should avoid:

* dependencies that require hosted services for core behavior,
* databases before they are needed,
* AI provider SDKs before context safety is stable,
* plugin runtimes before a trust model exists,
* graph databases before graph v0 is useful,
* complex terminal UI before command behavior is trustworthy,
* replacing native build/test/task tools,
* and adding abstraction layers before implementation pressure justifies them.

The preferred decision sequence is:

```text id="zqqfl3"
architecture need
  -> local-first constraint
    -> deterministic behavior
      -> test strategy
        -> dependency choice
          -> schema/versioning decision
            -> documentation
              -> implementation
```

If a technology choice does not support this sequence, it should be reconsidered.

---

## 23.3 Technology Evaluation Criteria

Every significant technology choice should be evaluated against the following criteria.

| Criterion            | Question                                                                                  |
| -------------------- | ----------------------------------------------------------------------------------------- |
| Local-first          | Can this work without a hosted backend, account, daemon, database, or cloud service?      |
| Deterministic        | Does it produce predictable behavior that can be tested?                                  |
| Safety               | Can it support read-only-before-mutation and plan-backed mutation?                        |
| Portability          | Does it work across Linux, macOS, and eventually Windows?                                 |
| Maintainability      | Is it well-maintained and understandable?                                                 |
| Dependency weight    | Does it add acceptable transitive dependency risk?                                        |
| Security             | Does it introduce network access, execution risk, parsing risk, or supply-chain exposure? |
| Testability          | Can behavior be proven with unit, fixture, smoke, schema, or property tests?              |
| Schema discipline    | Can outputs and artifacts be versioned?                                                   |
| Compatibility        | Will it preserve stable CLI, JSON, and file contracts?                                    |
| Solo usability       | Does it keep the project manageable for one developer?                                    |
| Future extensibility | Can it scale later without forcing premature complexity now?                              |

A technology that scores poorly against local-first, deterministic behavior, or safety should not be used in the core runtime.

---

## 23.4 Core Runtime Language

Recommended core language:

```text id="j7mupm"
Rust
```

Decision:

```text id="bq7x9a"
Continue Rust for the Monad core runtime.
```

Rust is the correct core language for Monad because it supports:

* single-binary distribution,
* strong type safety,
* high performance,
* predictable memory behavior,
* strong CLI ecosystem,
* good filesystem tooling,
* good serialization ecosystem,
* good testing ecosystem,
* structured error handling,
* cross-platform binaries,
* and long-term maintainability for local developer tooling.

Monad’s core runtime should remain Rust unless a future ADR supersedes this decision.

### 23.4.1 Why Rust Fits Monad

Monad needs to inspect repositories, parse manifests, model graphs, validate policy, generate context, produce reports, and eventually apply controlled filesystem mutations.

These are tasks where Rust is a strong fit.

Rust also aligns with the single-binary product strategy:

```text id="afzqxu"
download monad
run monad
inspect repository
no daemon required
no database required
no hosted account required
```

The core user experience should not require users to install Node, Python, Java, Docker, Kubernetes, or a database just to run core Monad commands.

### 23.4.2 Alternatives Considered

| Language    | Strengths                                                               | Weaknesses for Monad Core                                                                        |
| ----------- | ----------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| Go          | Strong CLI language, simple deployment, good cross-compilation          | Less aligned with current repo; weaker type modeling for some domain patterns compared with Rust |
| TypeScript  | Excellent ecosystem, fast iteration, good for templates and web tooling | Weaker single-binary/local runtime posture; Node/Bun dependency likely required                  |
| Python      | Excellent scripting and AI ecosystem                                    | Not ideal for core single-binary runtime; packaging/distribution complexity                      |
| Java/Kotlin | Strong ecosystem and enterprise maturity                                | Heavy runtime for a local CLI; less aligned with single-binary lightweight distribution          |
| Zig         | Interesting systems language                                            | Smaller ecosystem; less mature for this product’s needs                                          |

Rust remains the best fit for the core.

Other languages may still be used later for examples, generated templates, hosted services, SDKs, or integrations.

---

## 23.5 Rust Workspace Strategy

The initial Rust workspace should remain intentionally small.

Recommended early structure:

```text id="nfzpuo"
crates/
  monad-cli/
  monad-core/
```

`monad-cli` should own:

* Clap command definitions,
* CLI boundary behavior,
* formatting of human output,
* CLI argument parsing,
* command dispatch,
* exit code mapping,
* and integration with core domain behavior.

`monad-core` should own:

* domain types,
* repository inspection models,
* manifest resolution,
* findings,
* graph primitives,
* context models,
* policy models,
* plan models,
* and reusable behavior independent of the CLI boundary.

Future crates may include:

```text id="x799aq"
monad-config
monad-inspect
monad-graph
monad-context
monad-docs
monad-policy
monad-plans
monad-packs
```

However, these should be extracted only when behavior justifies extraction.

Do not create crates merely because a future domain exists.

A new crate should require at least one of:

* stable domain boundary,
* meaningful tests,
* significant reusable API,
* dependency isolation benefit,
* compile-time improvement,
* or strong architectural reason.

Premature crate explosion is a risk.

The technology strategy should favor modules before crates and behavior before abstraction.

---

## 23.6 CLI Framework

Recommended CLI framework:

```text id="uv349t"
clap
```

Decision:

```text id="wqq5ky"
Use Clap for the CLI command surface.
```

Clap is appropriate because it supports:

* mature Rust CLI ergonomics,
* nested subcommands,
* help output,
* argument parsing,
* derive and builder APIs,
* validation,
* shell completions later,
* and broad ecosystem familiarity.

The main technology risk is not Clap itself. The main risk is allowing Clap definitions to become the only command model.

Monad should maintain a separate command catalog model so the product can reason about:

* command path,
* status,
* implementation maturity,
* mutability,
* related work packet,
* output formats,
* tests,
* docs,
* and placeholder honesty.

Clap should expose the CLI.

The command catalog should govern the CLI.

### 23.6.1 Clap Lock-In Risk

Clap lock-in is low to medium.

The mitigation is:

```text id="hj7gs6"
Model command intent separately from Clap.
Use tests to ensure Clap surface matches command catalog.
```

If Monad ever changes CLI frameworks, the command catalog should remain the stable conceptual model.

### 23.6.2 Command Surface Contract

The CLI technology strategy must support command contract tests.

Required alignment:

```text id="mbzhrf"
command catalog
  -> Clap command tree
    -> help output
      -> docs
        -> tests
```

If the command catalog says `config list` exists, the Clap tree must expose `config list`, or the catalog must clearly mark it as not exposed.

The correct fix for command drift is usually to align the surface, not to hide the product intent.

---

## 23.7 Serialization and Manifest Formats

Recommended serialization stack:

```text id="jztm4z"
serde
serde_json
toml
```

Decision:

```text id="yn2odz"
Use Serde for Rust serialization, JSON for machine output, and TOML for human-authored manifests.
```

### 23.7.1 Serde

Serde is the standard Rust serialization ecosystem.

It should be used for:

* command output models,
* manifest models,
* lockfile models,
* plan models,
* graph exports,
* policy findings,
* context metadata,
* and release evidence.

### 23.7.2 JSON

JSON should be used for:

* machine-readable command output,
* graph export,
* plan files if appropriate,
* reports,
* policy results,
* release evidence,
* and integration boundaries.

JSON output should become schema-versioned once external users or CI systems depend on it.

### 23.7.3 TOML

TOML should be used for human-authored configuration.

Core files:

```text id="v6x37b"
monad.toml
workspace.toml
```

The source-of-truth rule is:

```text id="aw0em2"
monad.toml is canonical.
workspace.toml is compatibility mirror only.
```

TOML is appropriate for configuration because it is readable, widely understood, and already common in Rust ecosystems.

### 23.7.4 YAML

YAML may appear later for policy or ecosystem compatibility, but it should not be the default core format unless justified.

YAML risks include:

* ambiguous parsing,
* inconsistent tooling behavior,
* indentation fragility,
* and schema complexity.

If YAML is supported later, it should be supported deliberately and tested carefully.

---

## 23.8 Schema Strategy

Recommended later:

```text id="wsvgzb"
schemars
```

Purpose:

* generate JSON schemas from Rust types,
* validate structured outputs,
* document machine-readable contracts,
* support plan validation,
* support graph export validation,
* support policy result validation,
* and support release evidence validation.

### 23.8.1 Schema-Versioned Artifacts

The following artifacts should eventually include schema versions:

* JSON command output,
* plan files,
* graph exports,
* policy result files,
* context manifests,
* release evidence reports,
* risk exports,
* traceability exports,
* and hosted sync payloads.

Example pattern:

```json id="dn14eo"
{
  "schema_version": "1.0.0",
  "kind": "monad.plan",
  "data": {}
}
```

### 23.8.2 Schema Governance

Schema changes should be treated as public contract changes once users depend on them.

Breaking schema changes should require:

* work packet update,
* reference documentation,
* tests,
* changelog note,
* and possibly ADR if the change is foundational.

### 23.8.3 Timing

Do not introduce schema generation before structured outputs exist.

The sequence should be:

```text id="wc59zg"
domain model
  -> JSON output
    -> tests
      -> schema generation
        -> schema validation
          -> compatibility policy
```

---

## 23.9 Error Handling Strategy

Recommended:

```text id="yb4tzg"
thiserror for library/domain errors
anyhow for CLI boundary if useful
```

Decision:

```text id="n87l9n"
Use typed domain errors in core logic and ergonomic error handling at the CLI boundary.
```

### 23.9.1 Domain Errors

`thiserror` should be used for errors that are part of the domain model.

Examples:

* manifest parse error,
* manifest drift error,
* workspace root not found,
* invalid plan,
* unsafe path,
* missing required documentation,
* command catalog mismatch,
* policy rule failure,
* context redaction failure,
* graph invariant failure.

Typed errors make behavior testable.

### 23.9.2 CLI Boundary Errors

`anyhow` may be useful at the CLI boundary where errors need to be assembled, enriched, and converted into user-facing output.

The CLI should convert errors into:

* human-readable message,
* structured machine-readable output where requested,
* exit code,
* and optionally remediation guidance.

### 23.9.3 Error Quality

Monad errors should answer:

```text id="uowasb"
What failed?
Why did it fail?
What file or input caused it?
Is it an error, warning, or info finding?
How can the user fix it?
What command can provide more detail?
```

### 23.9.4 Exit Codes

Exit codes should be standardized.

Possible model:

| Exit Code | Meaning                             |
| --------- | ----------------------------------- |
| 0         | Success                             |
| 1         | General error                       |
| 2         | Invalid usage or arguments          |
| 3         | Findings detected                   |
| 4         | Policy failure                      |
| 5         | Plan validation failure             |
| 6         | Apply failure                       |
| 7         | Security/redaction failure          |
| 8         | Configuration/source-of-truth error |

This table should be finalized in the CLI output and exit code work packet.

---

## 23.10 Terminal Output Strategy

Recommended:

```text id="x8luik"
anstream
anstyle
owo-colors or similar, optional
```

Terminal output should be useful, readable, and stable enough for humans.

Monad should avoid over-investing in fancy terminal UI early.

### 23.10.1 Output Modes

Monad should support at least:

* human text output,
* JSON output for automation,
* and possibly Markdown output for reports.

Potential format flag:

```bash id="jzgn3q"
monad check --format text
monad check --format json
monad graph --format mermaid
monad graph --format dot
```

### 23.10.2 Color

Color should be optional.

Rules:

* disable color in CI by default,
* respect `NO_COLOR`,
* avoid color as the only signal,
* keep output readable without styling,
* and avoid introducing a heavy TUI dependency early.

### 23.10.3 Human Output

Human output should prioritize:

* clarity,
* stable headings,
* useful summaries,
* remediation guidance,
* and honest status.

Human output can evolve, but should not churn unnecessarily.

### 23.10.4 Machine Output

Machine output must be more stable.

Machine output should use:

* JSON,
* schema versions,
* predictable keys,
* explicit status fields,
* and tests.

---

## 23.11 Testing Technology Strategy

Recommended:

```text id="i7yhpz"
cargo test
assert_cmd
predicates
insta
tempfile
proptest
```

Testing is not optional for Monad.

Testing is a product trust requirement.

Core rule:

```text id="oomczb"
If Monad claims to understand, validate, document, graph, govern, plan, or mutate a repository, there must be tests proving that behavior.
```

### 23.11.1 Core Rust Tests

Use `cargo test` for:

* unit tests,
* domain tests,
* integration tests,
* fixture tests,
* command catalog tests,
* graph invariant tests,
* plan validation tests,
* policy tests,
* and mutation safety tests.

### 23.11.2 CLI Tests

Use `assert_cmd` and `predicates` for:

* CLI smoke tests,
* command invocation tests,
* help output checks,
* exit code checks,
* placeholder honesty checks,
* and simple output assertions.

### 23.11.3 Snapshot Tests

Use `insta` for:

* human output snapshots,
* report snapshots,
* command listing snapshots,
* doctor output snapshots,
* and graph text snapshots where useful.

Snapshots should be used carefully. They should catch unintended drift without making intentional improvements painful.

### 23.11.4 Fixture Tests

Use `tempfile` and fixture repositories for:

* workspace root detection,
* manifest resolution,
* source-of-truth drift,
* docs check,
* ADR validation,
* work packet validation,
* context redaction,
* graph generation,
* native adapter behavior,
* plan/apply safety,
* and policy checks.

### 23.11.5 Property-Based Tests

Use `proptest` for:

* graph invariants,
* path normalization,
* plan operation ordering,
* ID parsing,
* schema constraints,
* and other logic where many input variations matter.

### 23.11.6 Minimum Test Gates

Minimum early gate:

```bash id="ujo8yw"
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
```

Stronger near-term gate:

```bash id="zrrz88"
cargo clippy --workspace --all-targets -- -D warnings
cargo test -p monad-cli --test command_catalog_contract
```

---

## 23.12 Graph Technology Strategy

Recommended:

* build internal graph model in Rust,
* export to JSON,
* export to Mermaid,
* export to DOT,
* avoid requiring a graph database early.

The lifecycle graph is a core Monad model, but graph infrastructure should not become heavy too early.

### 23.12.1 Graph v0

Graph v0 should be derived from repository files.

It may include:

* repository,
* workspace,
* projects,
* manifests,
* commands,
* docs,
* ADRs,
* work packets,
* policies,
* tests,
* plans,
* context artifacts,
* and release evidence.

Edges may include:

* contains,
* configures,
* documents,
* implements,
* tests,
* governs,
* relates-to,
* depends-on,
* supersedes,
* and generated-from.

### 23.12.2 Graph Exports

Initial graph exports:

| Format  | Purpose                           |
| ------- | --------------------------------- |
| JSON    | Machine-readable graph data       |
| Mermaid | Human-readable docs diagrams      |
| DOT     | Graphviz-compatible visualization |

### 23.12.3 Graph Persistence

Avoid graph persistence early.

The sequence should be:

```text id="j14d2j"
derived graph model
  -> graph tests
    -> JSON export
      -> Mermaid/DOT export
        -> query v0
          -> optional local cache
            -> optional hosted graph
```

### 23.12.4 Graph Database

Do not introduce a graph database early.

A graph database may be considered only if:

* local derived graph and exports are useful,
* query needs exceed simple in-memory traversal,
* hosted control plane needs justify it,
* and an ADR is accepted.

---

## 23.13 Embedded Store Strategy

Recommended later:

```text id="r0l4ki"
SQLite
```

SQLite may be appropriate later for:

* local graph cache,
* repository index cache,
* query acceleration,
* local report history,
* release evidence index,
* and offline analysis.

SQLite should not be introduced at the beginning.

### 23.13.1 Embedded Store Rules

If SQLite is introduced:

* it must be optional for core correctness,
* it must not become canonical source of truth unless an ADR explicitly says so,
* it must be regenerable where possible,
* it must include schema versioning,
* it must support migration strategy,
* and it must not be required for simple commands like `monad version`, `monad check`, or `monad inspect`.

### 23.13.2 Recommended Timing

Introduce SQLite only when:

* graph/index performance requires it,
* repeated repository scans become costly,
* local query features justify it,
* and file-based derived state is no longer sufficient.

Before that point, prefer in-memory models and generated files.

---

## 23.14 Hosted Store Strategy

Recommended later:

```text id="no7an3"
PostgreSQL
```

PostgreSQL is appropriate for an optional hosted control plane because it is mature, reliable, widely understood, and well-suited to relational governance data.

Potential hosted uses:

* organizations,
* teams,
* repositories,
* metadata sync,
* policy results,
* release evidence,
* graph summaries,
* audit records,
* user permissions,
* and dashboard state.

### 23.14.1 Hosted Store Rules

PostgreSQL must not be required for the local CLI.

Hosted storage should be additive.

The local repository remains the source of truth for core artifacts.

Hosted storage may aggregate, index, synchronize, visualize, or collaborate around local data, but it must not silently override local source-of-truth files.

### 23.14.2 Hosted Deferral

Do not build hosted storage before local v1.

Hosted control plane work should require:

* stable local graph exports,
* stable local policy results,
* stable release evidence,
* stable source-of-truth model,
* sync model ADR,
* privacy model,
* and security model.

---

## 23.15 Policy Engine Strategy

Recommended sequence:

```text id="tez2om"
1. built-in Rust policy rules,
2. structured policy files,
3. policy explain,
4. waivers,
5. optional OPA/Rego integration later if justified.
```

Do not start with a full OPA dependency unless enterprise policy requirements demand it.

### 23.15.1 Built-In Rust Rules

Start with built-in Rust policy checks because they are:

* simple,
* deterministic,
* testable,
* easy to version,
* easy to explain,
* and local-first.

Examples:

* required docs exist,
* `monad.toml` is canonical,
* command catalog matches CLI surface,
* placeholders are honest,
* context excludes secret-like files,
* dry-run does not mutate,
* plan writes stay inside workspace root.

### 23.15.2 Structured Policy Files

Later, allow policy configuration through local files.

Potential locations:

```text id="gbylf5"
policies/
governance/policies/
monad.toml
```

Policy files should be schema-versioned and testable.

### 23.15.3 Policy Explain

Policy findings must be explainable.

A finding should include:

* policy ID,
* title,
* severity,
* evidence,
* affected path,
* rationale,
* remediation,
* waiver eligibility,
* and related docs.

### 23.15.4 Waivers

Waivers should be explicit, scoped, and expiring.

A waiver should not become a hidden permanent exception.

### 23.15.5 OPA/Rego

OPA/Rego may be valuable later for enterprise policy compatibility.

However, OPA should not be the first policy engine because it adds complexity and may exceed early local-first needs.

Introduce OPA only if:

* built-in rules are insufficient,
* enterprise policy requirements justify it,
* integration can remain optional,
* and an ADR accepts the trade-off.

---

## 23.16 AI Provider Strategy

Recommended sequence:

```text id="tnbztt"
1. NoopAiAdapter
2. deterministic context packs
3. prompt template model
4. local model adapter
5. hosted model adapters
6. evals and safety reports
```

Do not add real AI provider dependencies before context safety is stable.

Monad is AI-native but AI-optional.

AI should assist, not control.

### 23.16.1 Noop Adapter First

The first AI adapter should be a no-op or deterministic placeholder.

Purpose:

* define the port,
* test workflows without external calls,
* preserve AI-optional behavior,
* and prevent provider coupling.

### 23.16.2 Deterministic Context Before AI

Before any real AI provider is used, Monad must support deterministic context generation.

Context generation must:

* be local,
* respect ignore rules,
* exclude secrets,
* include provenance,
* explain included/excluded files,
* and be test-backed.

### 23.16.3 Prompt Template Model

Prompt templates should be versioned and inspectable.

Prompt templates should not be hidden inside code where users cannot audit them.

### 23.16.4 Local Model Adapter

A local model adapter may be added before hosted providers if it helps preserve privacy and local-first behavior.

However, local model support should remain optional. Monad should not require local model installation for core behavior.

### 23.16.5 Hosted Model Adapters

Hosted model adapters must require:

* explicit opt-in,
* provider configuration,
* clear data flow,
* redaction,
* audit metadata,
* and human approval for mutations.

### 23.16.6 Evals and Safety Reports

AI-assisted behavior should eventually have evaluations.

AI outputs that influence ADRs, plans, policies, or mutation suggestions should be auditable.

AI must not:

* silently call external providers,
* mutate files without plan/apply,
* override deterministic policy,
* become source of truth,
* or be required for core commands.

---

## 23.17 Native Tool Coordination Strategy

Monad coordinates native tools instead of replacing them.

This technology strategy should preserve ADR-0002.

Native tools remain responsible for their own domains:

| Native Tool      | Owns                                 |
| ---------------- | ------------------------------------ |
| Git              | Version control                      |
| Cargo            | Rust build/test/package behavior     |
| Bun/npm/pnpm     | JavaScript package workflows         |
| Moon/Turborepo   | Task graph execution                 |
| CI systems       | CI execution                         |
| Docker           | Container runtime behavior           |
| Terraform/Pulumi | Infrastructure provisioning behavior |

Monad should inspect, coordinate, validate, graph, and govern relationships between these tools.

### 23.17.1 Adapter Pattern

Use explicit adapters for native tools.

An adapter should define:

* detection,
* version inspection,
* configuration inspection,
* command availability,
* supported operations,
* findings,
* error mapping,
* and test fixtures.

Adapters should not silently mutate.

### 23.17.2 Shelling Out

Shelling out should be controlled.

Rules:

* avoid shell invocation when direct process execution is sufficient,
* avoid interpolated shell strings,
* validate paths,
* capture stdout/stderr,
* map exit codes,
* handle missing tools consistently,
* and test cross-platform behavior where possible.

### 23.17.3 Missing Tool Behavior

Missing native tools should usually produce findings, not panics.

Example:

```text id="w2x8cl"
Cargo manifest found, but cargo is not installed.
Severity: warning or error depending on command.
Suggested fix: install Rust/Cargo or skip Rust checks.
```

---

## 23.18 Filesystem and Path Strategy

Monad’s core behavior depends heavily on filesystem correctness.

Filesystem strategy must support:

* workspace root detection,
* path normalization,
* safe relative paths,
* ignore rules,
* read-only safety,
* dry-run safety,
* plan/apply safety,
* and cross-platform behavior.

### 23.18.1 Path Rules

Rules:

* represent repository paths relative to workspace root where possible,
* never write outside workspace root during apply,
* treat symlinks carefully,
* avoid unsafe path traversal,
* avoid assuming Unix-only paths,
* and test path behavior with fixtures.

### 23.18.2 Write Safety

Any writing behavior must be plan-backed once the mutation engine exists.

Before that, early commands should be read-only or explicit dry-run.

### 23.18.3 Ignore Rules

Monad should eventually support:

* `.gitignore`,
* `.monadignore`,
* built-in secret path exclusions,
* command-specific include/exclude options,
* and context redaction rules.

---

## 23.19 Documentation Technology Strategy

Recommended:

```text id="tca5ck"
Markdown
Mermaid
ADR markdown files
work-packet markdown files
```

Documentation should remain local, version-controlled, portable, and readable without a hosted system.

### 23.19.1 Markdown

Markdown is the default documentation format because it is:

* portable,
* readable in GitHub,
* easy to diff,
* easy to write,
* compatible with ADRs,
* compatible with work packets,
* and compatible with local-first workflows.

### 23.19.2 Mermaid

Mermaid is appropriate for diagrams because it is:

* text-based,
* GitHub-friendly,
* local-docs-friendly,
* easy to version,
* and useful for architecture diagrams.

### 23.19.3 ADRs and Work Packets

ADRs and work packets should remain Markdown-first.

Structured metadata may be added later if validation requires it, but the human-readable document should remain primary.

### 23.19.4 Hosted Docs

Avoid hosted docs dependency early.

A docs site may be generated later, but core documentation must remain useful directly from the repository.

---

## 23.20 CI/CD Strategy

Recommended:

```text id="7msux4"
GitHub Actions initially
```

GitHub Actions is appropriate initially because it is common, accessible, and integrated with the repository.

However, CI logic should remain portable.

### 23.20.1 Local Commands First

Every important CI check should have a local equivalent.

Examples:

```bash id="1czscv"
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
cargo clippy --workspace --all-targets -- -D warnings
```

CI should run local commands, not hide important behavior in CI-only scripts.

### 23.20.2 CI Responsibilities

CI should eventually check:

* formatting,
* compilation,
* tests,
* command contract,
* clippy,
* docs checks,
* policy checks,
* security checks,
* release readiness,
* and artifact generation.

### 23.20.3 Avoid CI Lock-In

GitHub Actions may be the first CI implementation, but Monad should not make GitHub Actions the only conceptual CI model.

Future CI adapters may inspect or coordinate:

* GitHub Actions,
* GitLab CI,
* Buildkite,
* CircleCI,
* Jenkins,
* or other systems.

Early support should focus on GitHub Actions only if needed.

---

## 23.21 Security Tooling Strategy

Recommended:

```text id="eql6w6"
cargo audit
cargo deny
gitleaks
SBOM generation later
OpenSSF Scorecard later
```

Security tooling should increase confidence without making local development fragile.

Optional tools should be non-fatal locally unless explicitly configured.

### 23.21.1 Cargo Audit

`cargo audit` can detect known vulnerable Rust dependencies.

Use as an optional security check initially.

### 23.21.2 Cargo Deny

`cargo deny` can help with:

* license checks,
* advisory checks,
* duplicate dependency checks,
* banned dependencies,
* and source checks.

It should be configured carefully to avoid excessive noise.

### 23.21.3 Gitleaks

`gitleaks` can help detect secrets.

It is relevant to Monad because context export and repository inspection must avoid secret leakage.

### 23.21.4 SBOM

Software Bill of Materials generation may be added later for releases.

SBOM support is useful for governance-grade distribution but should not block early local development.

### 23.21.5 OpenSSF Scorecard

OpenSSF Scorecard may be useful later for repository health.

It should not be a core local dependency.

### 23.21.6 Security Tooling Rule

The rule is:

```text id="m4x176"
Security tooling should protect the project without making the local developer loop brittle.
```

---

## 23.22 Release Tooling Strategy

Recommended later:

```text id="ejo4vr"
cargo-dist or custom release workflow
GitHub Releases
checksums
signing later
Homebrew later
```

Release tooling should be introduced gradually.

### 23.22.1 Early Release

Early releases may be source-only or simple binary builds.

The priority is correctness, not distribution polish.

### 23.22.2 Binary Distribution

Monad’s long-term runtime strategy supports binary distribution.

Potential release artifacts:

* Linux binary,
* macOS binary,
* Windows binary later,
* checksums,
* signatures later,
* changelog,
* release notes,
* and release evidence report.

### 23.22.3 Cargo Dist

`cargo-dist` may be useful when Monad is ready for multi-platform binary releases.

It should not be introduced before the release model is clear.

### 23.22.4 GitHub Releases

GitHub Releases are appropriate for early public distribution.

### 23.22.5 Checksums and Signing

Checksums should be added before broader binary distribution.

Signing should be added later when release maturity justifies it.

### 23.22.6 Homebrew

Homebrew distribution is useful later, but should not distract from local core maturity.

---

## 23.23 Technology Sequencing

Technology should be introduced in this order:

```text id="jfk18u"
Rust workspace
  -> Clap CLI
    -> command catalog
      -> Serde/TOML/JSON models
        -> tests and fixtures
          -> read-only repository inspection
            -> graph exports
              -> docs/context checks
                -> plan schema
                  -> dry-run/apply engine
                    -> policy model
                      -> templates/packs
                        -> optional AI adapters
                          -> optional local cache
                            -> optional hosted control plane
```

This sequence prevents premature infrastructure.

Do not introduce:

* SQLite before local graph/cache need,
* PostgreSQL before hosted control plane,
* OPA before built-in policy rules,
* AI SDKs before context redaction,
* plugin runtime before trust model,
* graph database before graph exports,
* release signing before release artifacts,
* or dashboards before local reports.

---

## 23.24 Technology Decisions by Roadmap Layer

### 23.24.1 CLI Foundation Layer

Use:

* Rust,
* Clap,
* Serde where needed,
* command catalog model,
* assert_cmd,
* predicates,
* cargo test.

Avoid:

* database,
* AI SDK,
* plugin runtime,
* hosted backend,
* graph persistence.

### 23.24.2 Read-Only Repository Understanding Layer

Use:

* Rust filesystem APIs,
* TOML parsing,
* JSON output models,
* fixture tests,
* typed findings,
* simple graph model.

Avoid:

* mutating writes,
* embedded database,
* external service dependency,
* heavyweight native tool orchestration.

### 23.24.3 Docs/Governance/Context Layer

Use:

* Markdown parsing where needed,
* local docs checks,
* deterministic context models,
* redaction logic,
* fixture/security tests,
* generated local reports.

Avoid:

* AI provider calls,
* remote upload,
* hosted context storage,
* unredacted context bundles.

### 23.24.4 Plan/Apply Layer

Use:

* schema-versioned plan model,
* file operation model,
* dry-run engine,
* approval-gated apply,
* apply reports,
* rollback hints,
* mutation safety tests.

Avoid:

* direct generator writes,
* unplanned file changes,
* implicit approval,
* writes outside workspace root.

### 23.24.5 Policy/Pack/Generator Layer

Use:

* built-in Rust policy rules,
* explainable findings,
* local templates,
* pack metadata,
* plan-backed pack application,
* optional checksums later.

Avoid:

* executable plugins,
* remote registry trust,
* OPA-first complexity,
* direct unsafe generation.

### 23.24.6 AI Layer

Use:

* Noop AI adapter,
* deterministic context packs,
* prompt template model,
* audit metadata,
* optional local model adapter,
* optional hosted adapters later.

Avoid:

* AI-required core behavior,
* hidden network calls,
* mutation without human approval,
* unversioned prompts,
* unredacted context.

### 23.24.7 Hosted Layer

Use later:

* PostgreSQL,
* API service,
* dashboard,
* sync model,
* hosted audit evidence,
* graph visualization,
* policy dashboard.

Avoid:

* hosted as source of truth,
* hosted required for local CLI,
* SaaS-first architecture before local v1.

---

## 23.25 Dependency Addition Process

Before adding a dependency, answer:

```text id="b9dg63"
What problem does this solve?
Can it be solved with the standard library?
Is this a core dependency or dev dependency?
Does this affect binary size?
Does this affect startup time?
Does this affect security posture?
Does this introduce network access?
Does this introduce native/system dependencies?
Is it actively maintained?
What is its license?
What transitive dependencies does it bring?
How will it be tested?
Can it be removed later?
```

A dependency should be rejected or deferred if:

* it solves a non-current problem,
* it introduces large complexity for small value,
* it weakens local-first behavior,
* it adds hidden network behavior,
* it is poorly maintained,
* it has unclear licensing,
* it duplicates existing functionality,
* or it exists only to support deferred features.

---

## 23.26 Technology Risk Register Mapping

| Technology Area                  | Related Risk                       |
| -------------------------------- | ---------------------------------- |
| Broad command surface            | R-001 Scope explosion              |
| Placeholder command model        | R-002 Placeholder trust            |
| File mutation technology         | R-003 Unsafe mutation              |
| Context generation and redaction | R-004 Secret leakage               |
| Manifest parsing                 | R-005 Manifest drift               |
| Native adapters                  | R-006 Native tool replacement risk |
| Graph model                      | R-007 Graph complexity             |
| AI provider adapters             | R-008 AI trust risk                |
| Packs/plugins                    | R-009 Supply-chain risk            |
| Output formatting and JSON       | R-010 CLI/CI compatibility         |
| Documentation tooling            | R-011 Stale docs                   |
| Work packet tooling              | R-012 Bureaucratic process         |
| Rust workspace/crates            | R-013 Premature crate boundaries   |
| Native tool adapters             | R-014 Adapter inconsistency        |
| Hosted database/backend          | R-015 Hosted distraction           |
| Product docs/positioning         | R-016 Category clarity             |
| Cache/embedded store             | R-017 Cache as source of truth     |
| Apply engine                     | R-018 Partial apply state          |
| Policy engine                    | R-019 Policy false positives       |
| Tooling/process load             | R-020 Solo developer heaviness     |

Technology choices should be reviewed against these risks before adoption.

---

## 23.27 Technology Anti-Patterns

Monad should avoid the following technology anti-patterns.

### 23.27.1 Stack Collection

Adding tools because they are impressive rather than because the architecture needs them.

Mitigation:

* require dependency rationale,
* link to work packet,
* link to risk mitigation,
* test actual behavior.

### 23.27.2 Hosted-First Drift

Introducing services, databases, queues, dashboards, or sync before the local CLI is useful.

Mitigation:

* local-first release gate,
* hosted ADR required,
* local fallback required.

### 23.27.3 AI Provider Coupling

Adding a direct dependency on a hosted AI provider before deterministic context and redaction are stable.

Mitigation:

* Noop adapter first,
* provider port,
* explicit opt-in,
* no hidden network calls.

### 23.27.4 Plugin Runtime Prematurity

Adding executable extension mechanisms before templates, packs, plan/apply, checksums, and signatures.

Mitigation:

* templates first,
* packs second,
* plugins later,
* trust model required.

### 23.27.5 Graph Infrastructure Prematurity

Adding graph database or persistence before derived graph exports are useful.

Mitigation:

* graph v0 first,
* JSON/Mermaid/DOT exports,
* cache only when performance requires.

### 23.27.6 Crate Explosion

Creating many Rust crates before boundaries are proven.

Mitigation:

* modules first,
* extraction only with behavior,
* architecture review for new crates.

### 23.27.7 Fancy Terminal Before Trust

Adding rich terminal UI before command behavior, output stability, and contract tests are mature.

Mitigation:

* simple readable output,
* optional color,
* JSON for machines,
* snapshots for stability.

---

## 23.28 Recommended Initial Technology Baseline

The near-term baseline should be:

```text id="e53glw"
Rust
Clap
Serde
serde_json
toml
thiserror
anyhow at CLI boundary if useful
assert_cmd
predicates
insta
tempfile
proptest where justified
Markdown
Mermaid
GitHub Actions
optional cargo audit/cargo deny/gitleaks later
```

The near-term baseline should not include:

```text id="y3xlca"
SQLite
PostgreSQL
OPA
AI provider SDKs
plugin runtime
pack registry
graph database
hosted dashboard
Kubernetes
message queues
web backend
TUI framework
complex release automation
```

This does not mean those tools are bad.

It means they are not needed for the current trust foundation.

---

## 23.29 Future Technology Candidates

Future technology candidates may be considered when the roadmap reaches the appropriate layer.

| Candidate                     | Possible Use                    | Timing                                |
| ----------------------------- | ------------------------------- | ------------------------------------- |
| `schemars`                    | JSON schema generation          | After structured models stabilize     |
| SQLite                        | Local graph/index cache         | After graph/query needs justify it    |
| PostgreSQL                    | Hosted control plane            | After local v1                        |
| OPA/Rego                      | Enterprise policy compatibility | After built-in policy model           |
| cargo-dist                    | Binary release automation       | After release model stabilizes        |
| Sigstore/cosign or equivalent | Artifact signing                | Later release maturity                |
| Homebrew tap                  | Distribution                    | Later public adoption                 |
| Local model runtime adapter   | Optional local AI               | After deterministic context           |
| Hosted AI adapters            | Optional AI assistance          | After context safety and audit        |
| Graph database                | Hosted graph analytics          | Only if hosted graph needs justify it |

Each candidate should require a work packet and possibly an ADR.

---

## 23.30 Summary

Monad’s technology strategy is intentionally disciplined.

The correct stack is not the largest stack.

The correct stack is the smallest trustworthy stack that supports the next layer of the product.

The core technology direction is:

```text id="qo2bkg"
Rust single-binary CLI
  -> Clap command surface
    -> command catalog governance
      -> Serde/TOML/JSON models
        -> test-backed read-only repository understanding
          -> local docs/governance/context
            -> derived graph exports
              -> schema-versioned plans
                -> dry-run and approved apply
                  -> built-in policy rules
                    -> templates and packs
                      -> optional AI
                        -> optional hosted control plane
```

Monad should continue with:

* Rust for the core runtime,
* Clap for CLI parsing,
* Serde/TOML/JSON for data modeling,
* typed errors and stable exit behavior,
* simple terminal output with optional color,
* strong test tooling,
* Markdown and Mermaid for documentation,
* built-in policy before OPA,
* deterministic context before AI,
* derived graph exports before graph persistence,
* SQLite only when local cache/index needs justify it,
* PostgreSQL only for optional hosted control plane,
* GitHub Actions initially,
* security tooling incrementally,
* and release tooling only when the release model is mature.

The strategy is simple:

```text id="xr945f"
Add technology only when it increases trust, safety, clarity, or necessary capability.
Defer technology that only increases surface area, dependency weight, or premature ambition.
```
