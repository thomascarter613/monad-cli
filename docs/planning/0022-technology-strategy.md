# 23. Technology Strategy

## 23.1 Technology Strategy Principles

Technology choices should follow architecture needs.

Monad should prefer:

* boring, reliable tools,
* local-first tools,
* testable libraries,
* portable formats,
* minimal required dependencies,
* explicit adapters,
* strong schema/versioning discipline.

## 23.2 Core Language

Recommended:

```text id="j7mupm"
Rust
```

Why:

* single binary,
* performance,
* type safety,
* strong CLI ecosystem,
* suitable for filesystem and graph work.

Alternatives:

* Go: strong alternative, less aligned with current repo.
* TypeScript: good ecosystem, weaker single-binary/local runtime posture.
* Python: good for scripts, not ideal for core runtime.

Decision:

Continue Rust.

## 23.3 CLI Framework

Recommended:

```text id="uv349t"
clap
```

Why:

* mature,
* widely used,
* derive and builder support,
* nested subcommands,
* help output,
* shell completions later.

Lock-in risk:

Low to medium. CLI surface can be modeled separately in command catalog.

## 23.4 Serialization

Recommended:

```text id="jztm4z"
serde
serde_json
toml
```

Why:

* Rust standard ecosystem,
* supports manifests and JSON outputs,
* stable enough for schema-versioned files.

## 23.5 Error Handling

Recommended:

```text id="yb4tzg"
thiserror for library/domain errors
anyhow for CLI boundary if useful
```

Why:

* clean domain errors,
* practical CLI ergonomics.

## 23.6 Terminal Output

Recommended:

```text id="x8luik"
anstream
anstyle
owo-colors or similar, optional
```

Keep color optional and disable in CI.

Avoid over-investing in fancy terminal UI early.

## 23.7 Testing

Recommended:

```text id="i7yhpz"
cargo test
assert_cmd
predicates
insta
tempfile
proptest
```

Purpose:

* CLI smoke tests,
* output assertions,
* snapshots,
* temp fixture repos,
* property-based invariants.

## 23.8 JSON Schema

Recommended later:

```text id="wsvgzb"
schemars
```

Purpose:

* generate JSON schemas from Rust types,
* validate structured outputs.

## 23.9 Graph Export

Recommended:

* build internal graph model in Rust,
* export to JSON,
* export to Mermaid,
* export to DOT.

Avoid requiring a graph database early.

## 23.10 Embedded Store

Recommended later:

```text id="r0l4ki"
SQLite
```

Use only when local graph/index performance requires it.

Avoid making SQLite canonical source of truth.

## 23.11 Hosted Store

Recommended later:

```text id="no7an3"
PostgreSQL
```

Use for optional hosted control plane.

Do not require it for local CLI.

## 23.12 Policy Engine

Recommended sequence:

1. built-in Rust policy rules,
2. structured policy files,
3. policy explain,
4. waivers,
5. optional OPA/Rego integration later if justified.

Do not start with full OPA dependency unless enterprise policy requirements demand it.

## 23.13 AI Provider Strategy

Recommended sequence:

1. `NoopAiAdapter`,
2. deterministic context packs,
3. prompt template model,
4. local model adapter,
5. hosted model adapters,
6. evals and safety reports.

Do not add real AI provider dependency before context safety is stable.

## 23.14 CI/CD

Recommended:

```text id="7msux4"
GitHub Actions initially
```

Because it is common and easy.

Keep CI logic portable by also supporting local scripts/commands.

## 23.15 Security Tooling

Recommended:

```text id="eql6w6"
cargo audit
cargo deny
gitleaks
SBOM generation later
OpenSSF Scorecard later
```

Make optional tools non-fatal locally unless explicitly configured.

## 23.16 Documentation

Recommended:

```text id="tca5ck"
Markdown
Mermaid
ADR markdown files
work-packet markdown files
```

Avoid hosted docs dependency early.

## 23.17 Release Tooling

Recommended later:

```text id="ejo4vr"
cargo-dist or custom release workflow
GitHub Releases
checksums
signing later
Homebrew later
```