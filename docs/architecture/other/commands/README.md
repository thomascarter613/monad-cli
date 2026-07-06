# Command Architecture

This directory documents the architecture of Monad's command surface.

Product-facing command descriptions belong in product/reference documentation. This directory focuses on the architecture rules that make the command surface trustworthy, testable, automatable, and safe.

## Canonical References

Current and planned command references:

- `docs/reference/command-catalog.md` — planned canonical machine/human command catalog reference.
- `docs/product/v1-command-reference.md` — planned product-facing v1 command reference.
- `docs/architecture/adrs/ADR-0012_honest-placeholder-commands.md` — command honesty and placeholder behavior.
- `docs/architecture/adrs/ADR-0013_versioned-machine-readable-output-schemas.md` — structured output contracts.
- `docs/architecture/adrs/ADR-0014_stable-cli-exit-code-taxonomy.md` — exit code taxonomy.

Until the reference files exist, this README records the architecture expectations for command design.

## Purpose

Monad's command surface is intentionally broad. It needs to support local repository initialization, inspection, validation, graphing, documentation lifecycle, ADR/work-packet governance, policy checks, plan-backed mutation, packs/templates, context generation, and future AI/hosted integrations.

The command architecture must preserve these principles:

- command behavior is honest;
- command status is explicit;
- read-only commands do not mutate;
- mutating commands are plan-backed where practical;
- network use is explicit;
- AI use is explicit;
- machine-readable output is versioned when stable;
- exit behavior is predictable;
- placeholder commands never fake success;
- command catalog metadata remains testable.

## Command Categories

Monad commands are grouped by lifecycle responsibility.

| Category | Example Commands | Purpose |
| -------- | ---------------- | ------- |
| Core orientation | `version`, `help`, `info` | Explain the CLI, runtime, and current command surface. |
| Repository discovery | `inspect`, `list`, `graph` | Read repository state and produce structured understanding. |
| Validation | `check`, `doctor`, `policy check`, `docs check` | Detect issues, rule violations, missing docs, and repair opportunities. |
| Configuration | `config`, `init` | Manage source-of-truth configuration and workspace initialization. |
| Planning and mutation | `plan`, `diff`, `apply`, `add`, `remove`, `rename`, `move`, `generate`, `sync`, `migrate`, `upgrade`, `clean` | Change repository state safely through explicit plans. |
| Documentation lifecycle | `docs`, `adr`, `workpacket` | Manage docs-as-code, decisions, work packets, and handoff readiness. |
| Execution orchestration | `run`, `build`, `test`, `lint`, `format` | Coordinate native tools without replacing them. |
| Extension lifecycle | `pack`, `template`, `plugin` | Manage packs, templates, and future plugin boundaries. |
| Context and AI readiness | `context` | Generate deterministic handoffs and context packs before AI assistance. |
| Release/governance | `release`, `policy` | Support readiness, gates, findings, waivers, and evidence. |

Not every listed command is necessarily fully implemented. Command status must be explicit.

## Command Metadata Model

Every command should eventually have metadata that is readable by humans, tests, and future automation.

Recommended metadata fields:

```text
name
summary
status
implemented
mutating
plan_backed
supports_dry_run
uses_network
uses_ai
invokes_native_tools
stability
output_formats
exit_behavior
related_adrs
related_work_packets
```

This metadata allows Monad to answer:

- Is the command implemented?
- Is it safe to run locally?
- Can it mutate files?
- Does it require a plan?
- Does it use network access?
- Does it call AI?
- Can CI rely on its output?
- Which ADRs constrain its behavior?

## Command Status Values

Recommended command maturity statuses:

| Status | Meaning |
| ------ | ------- |
| `implemented` | Performs its documented behavior. |
| `partial` | Performs some behavior but has known missing scope. |
| `preview` | Available for early feedback; not stable. |
| `planned` | Intentionally visible but not implemented. |
| `deprecated` | Exists but should not be used for new workflows. |
| `removed` | No longer available; retained only for history or compatibility docs. |

Placeholder and planned commands must not claim real success.

## Safety Posture

Commands should be classified by safety behavior.

### Read-Only Commands

Read-only commands may inspect files, parse manifests, render reports, and produce diagnostics, but they must not write repository state.

Examples:

```bash
monad inspect
monad list
monad graph
monad check
monad docs check
monad policy check
monad context handoff
```

Some read-only commands may write explicit output files in the future if the user asks for an output path. That behavior should be documented and plan-backed if it touches governed repository paths.

### Mutating Commands

Mutating commands can create, update, delete, move, or generate files.

Examples:

```bash
monad init
monad add
monad remove
monad rename
monad move
monad generate
monad sync --write
monad migrate
monad upgrade
monad apply
```

Significant mutation should be plan-backed. The mature flow is:

```bash
monad plan ...
monad diff plan.json
monad apply plan.json --dry-run
monad apply plan.json --yes
```

### Network-Aware Commands

Network access must be explicit. Core local commands should not call network services by default.

Network-aware command behavior may include future hosted sync, remote registries, update checks, or provider calls. Such behavior must be documented and configurable.

### AI-Aware Commands

AI use must be explicit and optional. AI commands or AI-assisted command modes should consume deterministic context and should not bypass policy, plan, or human approval boundaries.

AI-disabled behavior must be honest.

## Output Formats

Commands may support one or more output formats.

Recommended output classes:

| Format | Purpose |
| ------ | ------- |
| `text` | Human-readable terminal output. |
| `json` | Machine-readable automation output. |
| `markdown` | Handoff, documentation, and report artifacts. |
| `mermaid` | Lightweight graph/diagram rendering. |
| `dot` | Graphviz-compatible graph rendering. |

Stable machine-readable output must use versioned schemas.

A non-trivial JSON output should include schema metadata such as:

```json
{
  "schema": "monad.command.output",
  "schema_version": "1.0.0",
  "monad_version": "0.1.0",
  "data": {}
}
```

Experimental outputs should be marked as experimental or preview until stabilized.

## Exit Codes

Commands should use the stable taxonomy defined by ADR-0014.

Proposed high-level categories:

| Code | Meaning |
| ---: | ------- |
| 0 | Success. |
| 1 | General failure. |
| 2 | Usage error. |
| 3 | Validation failure. |
| 4 | Policy failure. |
| 5 | Plan/apply blocked. |
| 6 | Missing dependency. |
| 7 | Manifest/config error. |
| 8 | Placeholder or unimplemented command. |
| 9 | Explicit external operation failed. |
| 10 | Runtime invariant failure. |

The final taxonomy should be documented in `docs/reference/exit-codes.md`.

## Placeholder Command Rules

Placeholder commands must follow ADR-0012.

They must:

- state that they are not fully implemented;
- describe intended future behavior;
- avoid mutating files;
- avoid calling network services;
- avoid calling AI providers;
- avoid fake success messages;
- use documented exit behavior;
- expose status through command metadata where practical.

A planned command may appear in help or the command catalog, but it must not behave as if completed.

## Command Catalog Contract

The command catalog should become a testable source of command metadata.

Contract tests should verify:

- every catalog command exists in the CLI surface, or is explicitly hidden/planned;
- every visible placeholder is honest;
- mutating commands declare mutation behavior;
- commands that support dry-run declare it;
- commands that use network or AI declare it;
- output formats match command metadata;
- exit behavior is documented;
- command docs do not claim more than implementation provides.

## Relationship to ADRs

Command architecture is constrained by these ADRs:

| ADR | Constraint |
| --- | ---------- |
| ADR-0001 | Commands are implemented through the Rust single-binary runtime. |
| ADR-0002 | Commands coordinate native tools rather than replacing them by default. |
| ADR-0003 | Core commands are local-first and no-network-by-default. |
| ADR-0004 | AI behavior is optional and non-authoritative. |
| ADR-0005 | Commands use `monad.toml` as canonical manifest. |
| ADR-0006 | Significant mutation is plan-backed. |
| ADR-0012 | Placeholder commands must be honest. |
| ADR-0013 | Machine-readable outputs are versioned. |
| ADR-0014 | Exit codes follow a stable taxonomy. |
| ADR-0019 | Telemetry is disabled by default. |
| ADR-0020 | AI provider behavior goes through a provider port/no-op adapter. |

## Recommended Files

This directory may eventually contain:

| File | Purpose |
| ---- | ------- |
| `README.md` | Command architecture overview. |
| `command-metadata.md` | Command metadata schema and examples. |
| `command-status.md` | Command maturity/status model. |
| `command-safety.md` | Mutation, dry-run, network, AI, and native-tool safety rules. |
| `output-formats.md` | Human and machine output architecture. |
| `exit-codes.md` | Architecture-side notes for exit behavior; canonical reference should live in `docs/reference/exit-codes.md`. |
| `placeholder-behavior.md` | Placeholder rendering and test expectations. |
| `command-catalog-contract.md` | Contract test expectations for catalog/CLI alignment. |

## Maintenance Rules

- Keep product-facing command docs separate from architecture command rules.
- Keep command metadata aligned with implementation.
- Do not document planned behavior as implemented behavior.
- Update ADR references when command decisions change.
- Keep command safety metadata explicit.
- Prefer structured findings and versioned schemas over text scraping.
- Keep local-first/no-network/no-AI defaults visible.

## Current State

This README defines the architecture expectations for Monad's command surface.

The canonical product command reference and command catalog reference are planned repository artifacts and should be created or updated as implementation stabilizes.
