## Current Epic / WP / Layer Map

This is the working map I would use unless the repo’s actual work-packet files say otherwise.

### Epic 0 — Foundation, Governance, and Work Packet System

| WP      | Work Packet                            | Layers                                                                                                                                                                                                                                                                                      |
| ------- | -------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| WP-0000 | Work Packet Specification and Schema   | L0: Define WP schema; L1: Create WP index; L2: Create acceptance criteria model; L3: Create repo execution rules; L4: Create handoff/status conventions                                                                                                                                     |
| WP-0001 | Rust Workspace and CLI Skeleton        | L0: Cargo workspace; L1: `monad-cli` lib+bin; L2: baseline crates; L3: approved command surface; L4: help smoke tests; L5: command catalog; L6: placeholder metadata; L7: `plan`; L8: `apply` preview; L9: `check`; L10: `doctor`; L11: `inspect`; L12: `list`; L13: `config`; L14: `graph` |
| WP-0002 | Manifest Model and Workspace Discovery | L0: `monad.toml` parser; L1: `workspace.toml` mirror model; L2: discovery upward from cwd; L3: manifest validation; L4: schema tests                                                                                                                                                        |
| WP-0003 | Lockfile and State Directory           | L0: `monad.lock` model; L1: `.monad/` state model; L2: read/write safety; L3: deterministic serialization; L4: lock/state tests                                                                                                                                                             |

### Epic 1 — CLI Kernel and Command Runtime

| WP      | Work Packet                  | Layers                                                                                                                 |
| ------- | ---------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| WP-0004 | Command Dispatch Kernel      | L0: shared command context; L1: global flags; L2: output format routing; L3: error model; L4: dispatch tests           |
| WP-0005 | Output, Diagnostics, and UX  | L0: text output conventions; L1: JSON schemas; L2: Markdown output; L3: machine-readable errors; L4: UX smoke tests    |
| WP-0006 | Repository Inspection Engine | L0: file inventory; L1: crate inventory; L2: managed surface inventory; L3: manifest summaries; L4: inspect/list tests |
| WP-0007 | Environment Doctor Engine    | L0: required tools; L1: optional tools; L2: version probes; L3: remediation hints; L4: doctor tests                    |

### Epic 2 — Planning and Safe Mutation System

| WP      | Work Packet                    | Layers                                                                                                                |
| ------- | ------------------------------ | --------------------------------------------------------------------------------------------------------------------- |
| WP-0008 | Plan Model and Plan Documents  | L0: plan schema; L1: plan step types; L2: text/JSON/Markdown renderers; L3: `--out`; L4: plan tests                   |
| WP-0009 | Apply Engine Safety Model      | L0: read plan file; L1: validate schema; L2: approval gates; L3: no-mutation preview; L4: future execution hooks      |
| WP-0010 | Diff Engine                    | L0: filesystem diff model; L1: manifest diff; L2: generated-file diff; L3: text/JSON output; L4: diff tests           |
| WP-0011 | Transaction and Rollback Model | L0: operation journal; L1: preflight snapshots; L2: rollback plan format; L3: failure handling; L4: transaction tests |

### Epic 3 — Workspace Creation and Structural Commands

| WP      | Work Packet                                  | Layers                                                                                                                               |
| ------- | -------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| WP-0012 | Real `init` Command                          | L0: target validation; L1: governed preset files; L2: manifest generation; L3: `.monad/` init; L4: init tests                        |
| WP-0013 | Real `add` Command                           | L0: unit-kind model; L1: destination rules; L2: template resolution; L3: generated starter files; L4: add tests                      |
| WP-0014 | Real `remove`, `rename`, and `move` Commands | L0: target discovery; L1: reference updates; L2: safe deletion/keep-files; L3: import/manifest update planning; L4: structural tests |
| WP-0015 | Workspace Sync and Upgrade                   | L0: sync model; L1: compatibility mirror regeneration; L2: schema migration; L3: upgrade planner; L4: sync/upgrade tests             |

### Epic 4 — Packs, Templates, Plugins, and Generation

| WP      | Work Packet                     | Layers                                                                                                                                        |
| ------- | ------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| WP-0016 | Pack Catalog and Built-in Packs | L0: built-in pack manifest; L1: pack list; L2: pack inspect; L3: pack install/update plan; L4: pack tests                                     |
| WP-0017 | Template Engine                 | L0: template manifest; L1: variable model; L2: file renderer; L3: safety filters; L4: template tests                                          |
| WP-0018 | Generator Engine                | L0: `generate` command; L1: app/package/service generators; L2: language/framework options; L3: generated test scaffolds; L4: generator tests |
| WP-0019 | Plugin System                   | L0: plugin manifest; L1: plugin list/install/remove; L2: trust boundaries; L3: local plugin loading; L4: plugin tests                         |

### Epic 5 — Policy, Governance, Docs, ADRs, and Work Packets

| WP      | Work Packet        | Layers                                                                                                   |
| ------- | ------------------ | -------------------------------------------------------------------------------------------------------- |
| WP-0020 | Policy Engine      | L0: policy finding model; L1: `policy check`; L2: `policy explain`; L3: `policy waive`; L4: policy tests |
| WP-0021 | Docs Engine        | L0: docs inventory; L1: `docs generate`; L2: `docs check`; L3: stale-doc detection; L4: docs tests       |
| WP-0022 | ADR Engine         | L0: ADR model; L1: `adr new`; L2: `adr list`; L3: `adr supersede`; L4: ADR tests                         |
| WP-0023 | Work Packet Engine | L0: WP model; L1: `workpacket new`; L2: `workpacket list`; L3: `workpacket plan`; L4: WP lifecycle tests |

### Epic 6 — Context, AI-Ready Handoff, and Graph

| WP      | Work Packet                | Layers                                                                                                                           |
| ------- | -------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| WP-0024 | Context Pack Engine        | L0: context file model; L1: `context pack`; L2: context verify; L3: token/budget metadata; L4: context tests                     |
| WP-0025 | Handoff Engine             | L0: handoff summary model; L1: `context handoff`; L2: current-state generation; L3: continuation instructions; L4: handoff tests |
| WP-0026 | Workspace Graph Engine     | L0: crate graph; L1: command graph; L2: task graph; L3: Mermaid/DOT/JSON output; L4: graph tests                                 |
| WP-0027 | Dependency and Task Graphs | L0: dependency extraction; L1: task graph model; L2: affected-unit detection; L3: graph filtering; L4: graph correctness tests   |

### Epic 7 — Native Tool Orchestration

| WP      | Work Packet                              | Layers                                                                                                                            |
| ------- | ---------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| WP-0028 | Run/Build/Test/Lint/Format Orchestration | L0: native tool registry; L1: command execution model; L2: package manager routing; L3: target filtering; L4: orchestration tests |
| WP-0029 | Cache, Clean, and Local State Management | L0: cache inventory; L1: clean planning; L2: safe deletion rules; L3: state repair; L4: clean tests                               |
| WP-0030 | Release and Migration Workflow           | L0: `release plan`; L1: `release apply`; L2: `release publish`; L3: `migrate`; L4: release/migration tests                        |
| WP-0031 | Hardening, Acceptance, and v1 Readiness  | L0: full acceptance suite; L1: docs completeness; L2: smoke tests; L3: CI workflows; L4: v1 readiness report                      |

