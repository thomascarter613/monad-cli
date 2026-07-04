# 21. Governance and Decision System

## 21.1 Governance Philosophy

Monad governance should make serious development safer and clearer without creating unnecessary bureaucracy.

Governance exists to answer:

```text id="j1b2mz"
What changed?
Why did it change?
Who or what approved it?
What policy applied?
What test proves it?
What docs explain it?
What risk remains?
```

## 21.2 Decision-Making Process

Recommended decision levels:

| Level                        | Example                              | Required Artifact   |
| ---------------------------- | ------------------------------------ | ------------------- |
| Minor implementation         | refactor internals                   | commit message/test |
| User-visible behavior        | command output change                | work packet update  |
| Architecture decision        | new crate, schema, mutation model    | ADR                 |
| Governance/security decision | policy, waiver model, AI safety      | ADR + risk update   |
| Release decision             | version, compatibility, distribution | release plan        |

## 21.3 ADR Process

Lifecycle:

```text id="4c2d0c"
draft -> proposed -> accepted -> superseded -> deprecated
```

ADR required when:

* architecture style changes,
* source-of-truth model changes,
* mutation safety model changes,
* AI architecture changes,
* persistence model changes,
* plugin trust model changes,
* public CLI contract changes significantly.

## 21.4 RFC Process

Use RFCs for large future features before ADR acceptance.

RFC should include:

* problem,
* proposal,
* alternatives,
* compatibility,
* security impact,
* migration impact,
* testing plan,
* rollout plan.

## 21.5 Change Management

Every significant change should map to:

```text id="odgqg8"
Epic -> Work Packet -> Layer -> Commit/PR
```

Minimum change record:

* what changed,
* why,
* files affected,
* tests run,
* docs updated,
* risk notes.

## 21.6 Release Governance

Release gates:

```text id="g3dyqx"
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
command catalog contract
docs check
policy check
changelog update
version update
release notes
security review for sensitive changes
```

## 21.7 Security Review Process

Security review required for:

* context export changes,
* file mutation changes,
* plugin/pack install behavior,
* external command execution,
* network access,
* AI provider integrations,
* release artifact changes.

## 21.8 Architecture Review Process

Architecture review required for:

* new crate boundaries,
* schema changes,
* graph model changes,
* plan/apply changes,
* policy model changes,
* hosted control plane decisions,
* database or cache introduction.

## 21.9 Dependency Governance

Dependency additions should document:

* why needed,
* alternatives,
* maintenance status,
* license,
* security posture,
* transitive dependency risk.

## 21.10 AI Governance

AI workflows require:

* explicit opt-in,
* provider configuration,
* context redaction,
* prompt template versioning,
* human approval for mutation,
* audit metadata,
* deterministic fallback.

## 21.11 Data Governance

Rules:

* `monad.toml` is canonical.
* `workspace.toml` is mirror only.
* `.monad/` is local state/cache unless documented otherwise.
* generated artifacts need lineage metadata.
* context packs must exclude secrets.
* schemas must be versioned.

## 21.12 Documentation Governance

Docs must be updated when:

* command behavior changes,
* architecture changes,
* policies change,
* work packet status changes,
* release process changes,
* security model changes.

`monad docs check` should eventually enforce this.
