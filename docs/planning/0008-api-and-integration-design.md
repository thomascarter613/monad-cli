# 9. API and Integration Design

## 9.1 Purpose of This Section

This section defines Monad’s API and integration strategy.

It explains:

* what counts as an API in Monad,
* how the CLI should be treated as the first public API,
* how structured command output should evolve,
* how file schemas should be versioned,
* how internal Rust APIs should be shaped,
* how native tool integrations should work,
* how future plugin, local daemon, hosted, and AI APIs should be approached,
* how exit codes and errors should behave,
* how command contracts should be tested,
* and how Monad should avoid premature integration complexity.

The core API design decision is:

> Monad’s first API is the CLI. Its second API is structured output. Its third API is local file schemas. Its fourth API is internal Rust domain contracts. Hosted, plugin, daemon, and remote APIs are optional future layers.

This ordering matters because Monad is local-first. The product must earn trust locally before it exposes broader integration surfaces.

---

## 9.2 API Strategy Summary

Monad’s first API is the CLI.

The second API is structured machine-readable command output.

The third API is local file schemas.

The fourth API is the internal Rust crate/domain API.

The fifth future API may be a plugin or pack API.

The sixth future API may be a local daemon/editor integration API.

The seventh future API may be a hosted control-plane API.

Recommended API maturity path:

```text id="u384o1"
1. CLI UX
2. Stable exit codes
3. JSON/Markdown/Mermaid/DOT outputs
4. Local file schemas
5. Internal Rust domain contracts
6. Pack/template metadata API
7. Optional plugin API
8. Optional local daemon/editor API
9. Optional hosted REST/GraphQL/events API
```

The early product should focus on the first four layers:

```text id="pnghxn"
CLI
structured output
exit codes
file schemas
```

Do not build a hosted API before the CLI is trustworthy.

---

## 9.3 API Design Principles

1. **CLI first.**
   The command-line interface is the first product interface and must be treated as a public API.

2. **Human-readable by default.**
   Terminal output should be useful without extra flags.

3. **Machine-readable when requested.**
   JSON, Markdown, Mermaid, and DOT outputs should be stable enough for automation once supported.

4. **Read-only is safe by default.**
   Commands that inspect, check, graph, list, or explain should not mutate files.

5. **Mutation requires explicit boundaries.**
   Mutating commands should use dry-run, plan/apply, or explicit approval.

6. **Exit codes matter.**
   CI systems and scripts need meaningful exit codes.

7. **Schemas are APIs.**
   `monad.toml`, `plan.json`, `graph.json`, and other structured artifacts must be versioned.

8. **Native tools remain authoritative.**
   Monad should integrate with native tools through adapters without replacing them unnecessarily.

9. **Placeholders must be honest.**
   Planned commands should not pretend to be implemented.

10. **Future APIs must not weaken local-first behavior.**
    Plugin, daemon, hosted, and AI APIs must remain optional.

---

# 9.4 API Surface Layers

Monad has multiple API layers.

## 9.4.1 Layer 1: CLI API

The CLI API consists of:

* command names,
* subcommands,
* flags,
* arguments,
* help output,
* exit codes,
* human-readable output,
* command examples,
* command metadata.

Example:

```bash id="exz0uq"
monad inspect --format json
```

The CLI API is user-facing and should be stable enough to document and test.

## 9.4.2 Layer 2: Structured Output API

Structured outputs include:

* JSON reports,
* Markdown reports,
* Mermaid graphs,
* DOT graphs,
* plan files,
* context manifests,
* policy findings,
* inspection reports.

Example:

```bash id="j1s7dr"
monad graph --format mermaid
```

Structured output is an integration API for scripts, CI systems, docs generators, dashboards, AI tools, and future hosted sync.

## 9.4.3 Layer 3: File Schema API

Local files are APIs because users and tools will depend on them.

Examples:

```text id="gtn4v3"
monad.toml
monad.lock
plan.json
context-manifest.json
inspection-report.json
graph.json
policy-result.json
docs-report.json
command-catalog.json
```

These files require schema versioning and compatibility rules.

## 9.4.4 Layer 4: Internal Rust API

Internal Rust APIs are the domain and application-level contracts between crates.

Examples:

```rust id="st7oox"
pub trait InspectRepository {
    fn inspect(&self, workspace: &Workspace) -> Result<InspectionReport>;
}
```

These APIs do not have to be stable for external users early, but they should be coherent enough to avoid architectural drift.

## 9.4.5 Layer 5: Pack and Template API

Packs and templates are future extension surfaces.

Examples:

```text id="qzfcth"
pack manifest
template metadata
template inputs
template outputs
profile definitions
policy bundle metadata
```

These should be versioned before third-party usage.

## 9.4.6 Layer 6: Plugin API

Plugins may eventually extend Monad behavior.

This should be deferred until the core domain model, command surface, plan/apply engine, and trust model are mature.

## 9.4.7 Layer 7: Local Daemon or Editor API

A local daemon may eventually support:

* editor integrations,
* cached graph queries,
* file watching,
* local API access,
* background indexing.

This should be deferred.

## 9.4.8 Layer 8: Hosted API

A hosted control plane may eventually expose:

* REST resources,
* GraphQL graph exploration,
* event streams,
* webhooks,
* policy dashboards,
* release evidence,
* team workflows.

This is explicitly not an early requirement.

---

# 9.5 CLI API

The CLI should be treated as a public API.

Command names, namespaces, flags, output formats, and exit codes should be designed carefully.

## 9.5.1 CLI Design Principles

1. Commands should be discoverable.
2. Commands should have clear help text.
3. Commands should have stable names.
4. Read-only commands should be safe by default.
5. Mutating commands should use dry-run or plan/apply.
6. Structured output should be available where useful.
7. Human output should be clear and actionable.
8. JSON output should be stable once declared stable.
9. Placeholder commands should be honest.
10. Exit codes should be meaningful.
11. Commands should compose well in scripts.
12. CI-facing commands should support non-interactive behavior.
13. Commands should avoid surprising network, AI, or filesystem behavior.

## 9.5.2 Command Naming Rules

Recommended rules:

* use lowercase command names,
* use kebab-case for multi-word command names if needed,
* prefer verbs for operations,
* prefer nouns for namespaces,
* avoid ambiguous aliases early,
* keep nested commands predictable.

Examples:

```bash id="ruxxwk"
monad docs check
monad context handoff
monad policy explain
monad workpacket plan
```

Avoid excessive aliasing early. Aliases become API commitments.

## 9.5.3 Command Categories

Recommended categories:

| Category                 | Examples                                           | Mutation Risk                                    |
| ------------------------ | -------------------------------------------------- | ------------------------------------------------ |
| Identity                 | `version`, `help`                                  | None                                             |
| Discovery                | `list`, `config`, `inspect`                        | None                                             |
| Validation               | `check`, `doctor`, `docs check`, `policy check`    | None                                             |
| Graph/report             | `graph`, `diff`                                    | None/read-only                                   |
| Context                  | `context handoff`, `context pack`                  | Usually read-only; may write output if requested |
| Governance               | `adr list`, `workpacket list`                      | Read-only initially                              |
| Planning                 | `plan`                                             | Creates or previews plans                        |
| Mutation                 | `apply`, `add`, `remove`, `generate`               | High                                             |
| Native tool coordination | `run`, `build`, `test`, `lint`, `format`           | Delegates execution                              |
| Extension                | `pack`, `template`, `plugin`                       | Medium/high later                                |
| Release                  | `release plan`, `release apply`, `release publish` | High later                                       |

---

# 9.6 Recommended Top-Level Command Surface

Recommended top-level command surface:

```text id="lb6m4x"
monad init
monad add
monad remove
monad rename
monad move
monad list
monad inspect
monad check
monad doctor
monad plan
monad apply
monad diff
monad generate
monad sync
monad run
monad build
monad test
monad lint
monad format
monad graph
monad clean
monad migrate
monad upgrade
monad context
monad config
monad version
```

## 9.6.1 Early Top-Level Commands

Early implemented or near-term commands should be:

```text id="ap8q9w"
monad version
monad list
monad config
monad inspect
monad check
monad doctor
monad graph
monad diff
monad context
monad docs
monad adr
monad workpacket
monad policy
monad plan
monad apply
```

## 9.6.2 Commands That Should Be Placeholder or Deferred Early

These should remain placeholder, dry-run, preview-only, or deferred until plan/apply exists:

```text id="jyf8pm"
monad init
monad add
monad remove
monad rename
monad move
monad generate
monad sync
monad clean
monad migrate
monad upgrade
monad pack install
monad plugin install
monad release apply
monad release publish
```

## 9.6.3 Command Surface Rule

If a command appears in the command catalog and is intended to be exposed, it must exist in the CLI parser.

If it is not implemented, it must render an honest placeholder.

---

# 9.7 Recommended Namespaced Command Surface

```text id="0f8kw8"
monad policy check
monad policy waive
monad policy explain

monad template list
monad template add
monad template inspect

monad pack list
monad pack install
monad pack update

monad plugin list
monad plugin install
monad plugin remove

monad release plan
monad release apply
monad release publish

monad context pack
monad context verify
monad context handoff

monad graph projects
monad graph tasks
monad graph deps

monad docs generate
monad docs check

monad adr new
monad adr list
monad adr supersede

monad workpacket new
monad workpacket list
monad workpacket plan

monad config list
monad config inspect
monad config validate
```

## 9.7.1 Namespaced Command Rules

* Namespaces should group lifecycle concerns.
* Namespaces should not become dumping grounds.
* Mutating subcommands must be identified.
* Planned subcommands must be honest.
* Nested commands must be contract-tested.
* Help output should explain namespace purpose.

---

# 9.8 Command Metadata API

Every command should have metadata.

Minimum metadata:

```text id="yzq7ql"
name
path
namespace
description
implemented
mutating
plan_backed
supports_dry_run
stability
```

Recommended future metadata:

```text id="fqnvt7"
examples
aliases
output_formats
requires_workspace
requires_git
requires_network
requires_ai
requires_approval
risk_level
related_work_packet
related_docs
related_adrs
exit_codes
```

Example conceptual metadata:

```json id="mwxg8z"
{
  "schema_version": "0.1",
  "path": "config list",
  "description": "List recognized Monad configuration sources.",
  "implemented": true,
  "mutating": false,
  "plan_backed": false,
  "supports_dry_run": false,
  "stability": "experimental",
  "requires_workspace": false,
  "requires_ai": false,
  "requires_network": false
}
```

## 9.8.1 Command Metadata Rules

1. Mutating commands must declare mutation status.
2. Planned commands must declare `implemented: false`.
3. AI-dependent commands must declare AI requirements, though core commands should not require AI.
4. Network-dependent commands must declare network requirements.
5. Workspace-dependent commands must declare workspace requirements.
6. Command metadata must be testable.

---

# 9.9 Global CLI Flags

Monad should standardize global flags.

Recommended global flags:

```bash id="oaxm1x"
--format <text|json|markdown|mermaid|dot>
--workspace-root <path>
--config <path>
--profile <name>
--output <path>
--quiet
--verbose
--no-color
--ci
--dry-run
--yes
```

Not every flag applies to every command.

## 9.9.1 Format Flag

```bash id="8j4msj"
--format json
```

Specifies output format where supported.

## 9.9.2 Workspace Root Flag

```bash id="47a7ez"
--workspace-root /path/to/repo
```

Overrides workspace root detection.

## 9.9.3 Config Flag

```bash id="ymf8mz"
--config path/to/monad.toml
```

Allows explicit manifest selection.

## 9.9.4 Profile Flag

```bash id="aibklk"
--profile solo
--profile team
--profile enterprise
```

Selects a governance/profile mode where supported.

## 9.9.5 Output Flag

```bash id="s7f0kd"
--output .monad/context/current-state.md
```

Writes output to a file when the command supports file output.

Commands that write output should make that behavior explicit.

## 9.9.6 Quiet and Verbose Flags

```bash id="0vdp2q"
--quiet
--verbose
```

Control output detail.

## 9.9.7 No Color Flag

```bash id="7ysia0"
--no-color
```

Disables terminal color.

## 9.9.8 CI Flag

```bash id="upbxz5"
--ci
```

Enables CI-friendly behavior where supported:

* stable output,
* non-interactive behavior,
* meaningful exit codes,
* no prompts,
* no color by default.

## 9.9.9 Dry Run Flag

```bash id="f8p2rd"
--dry-run
```

Simulates behavior without writing files.

## 9.9.10 Yes Flag

```bash id="uy325z"
--yes
```

Confirms an operation where explicit approval is required.

Use carefully. `--yes` should not bypass plan validation or safety checks.

---

# 9.10 Output Format Strategy

Recommended standard flags:

```bash id="8n7hv8"
--format text
--format json
--format markdown
--format mermaid
--format dot
```

Not every command needs every format.

Recommended defaults:

| Command Type      | Default  | Additional Formats |
| ----------------- | -------- | ------------------ |
| Human diagnostics | text     | json, markdown     |
| Reports           | markdown | json               |
| Graphs            | text     | json, mermaid, dot |
| Plans             | text     | json, markdown     |
| Context           | markdown | json               |
| CI checks         | text     | json               |
| Catalog/listing   | text     | json               |

## 9.10.1 Human Output

Human output should be:

* readable,
* grouped,
* actionable,
* not overly noisy by default,
* clear about status,
* clear about severity,
* clear about next steps.

## 9.10.2 JSON Output

JSON output should be:

* schema-versioned,
* deterministic where practical,
* stable once documented,
* suitable for CI and future hosted sync,
* free from terminal color codes,
* complete enough for tools.

## 9.10.3 Markdown Output

Markdown output should be used for:

* context handoffs,
* reports,
* docs,
* release summaries,
* governance artifacts.

## 9.10.4 Mermaid and DOT Output

Mermaid and DOT output should be used for graph visualization.

Graph outputs should avoid invalid references.

---

# 9.11 Standard Output Envelopes

Structured output should use standard envelopes where practical.

## 9.11.1 Report Envelope

Example:

```json id="0fukt2"
{
  "schema_version": "0.1",
  "kind": "inspection_report",
  "generated_by": "monad",
  "monad_version": "0.1.0",
  "workspace": {
    "name": "monad-cli",
    "root": "."
  },
  "summary": {},
  "findings": [],
  "data": {}
}
```

## 9.11.2 Finding Object

Example:

```json id="4y5n76"
{
  "id": "MONAD-CONFIG-001",
  "severity": "error",
  "message": "workspace.toml conflicts with monad.toml",
  "path": "workspace.toml",
  "category": "configuration",
  "remediation": "Update workspace.toml or regenerate it from monad.toml."
}
```

## 9.11.3 Error Object

Example:

```json id="l7zma8"
{
  "schema_version": "0.1",
  "kind": "error",
  "error": {
    "code": "WORKSPACE_NOT_FOUND",
    "message": "No Monad workspace was found.",
    "remediation": "Run this command from a repository containing monad.toml or pass --workspace-root."
  }
}
```

## 9.11.4 Plan Envelope

Example:

```json id="xj5fuo"
{
  "schema_version": "0.1",
  "kind": "plan",
  "plan_id": "plan_000001",
  "workspace": {},
  "operation": {},
  "steps": [],
  "risks": [],
  "policy_findings": [],
  "approval_required": true
}
```

## 9.11.5 Context Manifest Envelope

Example:

```json id="zi4yai"
{
  "schema_version": "0.1",
  "kind": "context_pack_manifest",
  "context_pack_id": "ctx_000001",
  "purpose": "handoff",
  "sources": [],
  "outputs": [],
  "redaction": {
    "enabled": true,
    "redacted_count": 0
  }
}
```

These examples are illustrative, not final stable schemas.

---

# 9.12 Exit Code Strategy

Recommended exit codes:

```text id="fok364"
0  success
1  general failure
2  validation failed
3  configuration error
4  workspace not found
5  command not implemented
6  policy violation
7  unsafe mutation blocked
8  plan required
9  apply failed
10 external tool failed
11 schema error
12 context safety error
13 ai disabled or unavailable
14 network disabled or unavailable
```

## 9.12.1 Exit Code Rules

1. `0` means success.
2. Validation/check failures should not use generic failure if a more specific code applies.
3. Placeholder commands should use a deliberate code when executed as behavior.
4. CI mode should return nonzero on blocking findings.
5. Read-only commands should not return mutation-related codes.
6. Exit codes should be documented and tested.

## 9.12.2 Exit Code Examples

| Scenario                                            | Exit Code |
| --------------------------------------------------- | --------: |
| `monad version` succeeds                            |         0 |
| `monad check --ci` finds blocking validation errors |         2 |
| malformed `monad.toml`                              |         3 |
| no workspace found                                  |         4 |
| planned command not implemented                     |         5 |
| policy violation blocks operation                   |         6 |
| mutating command blocked because plan required      |         8 |
| apply fails                                         |         9 |
| native tool command fails                           |        10 |

---

# 9.13 Error and Finding Design

Monad should distinguish errors from findings.

## 9.13.1 Error

An error prevents the command from completing.

Examples:

* invalid CLI arguments,
* unreadable config file,
* malformed JSON plan,
* workspace not found,
* IO permission failure.

## 9.13.2 Finding

A finding is a diagnostic result about repository state, policy state, docs state, graph state, or plan state.

Examples:

* missing docs,
* manifest mirror drift,
* policy violation,
* command catalog mismatch,
* stale ADR index,
* missing workspace field.

## 9.13.3 Finding Severity

Recommended severities:

```text id="a9c4gw"
info
warning
error
critical
```

## 9.13.4 Finding Categories

Recommended categories:

```text id="jx4ejd"
configuration
command_catalog
inspection
documentation
governance
policy
security
context
graph
plan
native_tool
release
```

---

# 9.14 Internal Rust API Boundaries

Internal crates should expose domain-facing APIs.

These are not necessarily stable public library APIs early, but they should be designed cleanly.

Example traits:

```rust id="06s5tc"
pub trait InspectRepository {
    fn inspect(&self, workspace: &Workspace) -> Result<InspectionReport>;
}

pub trait BuildGraph {
    fn build_graph(
        &self,
        workspace: &Workspace,
        inspection: &InspectionReport,
    ) -> Result<LifecycleGraph>;
}

pub trait EvaluatePolicy {
    fn evaluate_workspace(&self, workspace: &Workspace) -> Result<PolicyEvaluation>;
    fn evaluate_plan(&self, plan: &Plan) -> Result<PolicyEvaluation>;
}

pub trait GenerateContext {
    fn generate_handoff(&self, workspace: &Workspace) -> Result<Handoff>;
}

pub trait CreatePlan {
    fn create_plan(&self, request: PlanRequest) -> Result<Plan>;
}

pub trait ApplyPlan {
    fn dry_run(&self, plan: &Plan) -> Result<ApplyResult>;
    fn apply(&self, plan: &Plan, approval: Approval) -> Result<ApplyResult>;
}
```

## 9.14.1 Internal API Rules

1. Domain APIs should not expose Clap types.
2. Domain APIs should not expose provider-specific AI types.
3. Domain APIs should not expose raw shell command execution details unnecessarily.
4. Domain APIs should return domain results and findings.
5. IO should be behind adapters.
6. Internal APIs should be testable without real repositories where possible.

---

# 9.15 File Schema API

Monad file formats are also APIs.

Versioned schemas should exist for:

```text id="9yqzls"
monad.toml
monad.lock
plan.json
inspection-report.json
graph.json
context-pack.json
context-manifest.json
policy-result.json
docs-report.json
command-catalog.json
apply-result.json
```

## 9.15.1 Schema Requirements

Schemas should:

* include `schema_version`,
* include `generated_by` where applicable,
* include `monad_version` where applicable,
* include workspace identity where relevant,
* avoid unstable field names,
* support future-compatible parsing where possible,
* preserve unknown user fields where practical,
* produce warnings rather than crashes for unknown generated fields where safe.

## 9.15.2 Schema Compatibility Rules

1. Patch changes should not break readers.
2. Minor changes may add optional fields.
3. Major changes may introduce breaking changes.
4. Breaking changes require migration notes.
5. Source-of-truth files must not be silently migrated.
6. Migrations should be plan-backed.

---

# 9.16 Native Tool Integration Strategy

Monad should integrate with native tools through adapters.

Potential adapters:

```text id="hdtr1e"
CargoAdapter
BunAdapter
NpmAdapter
PnpmAdapter
MoonAdapter
TurborepoAdapter
BiomeAdapter
DockerAdapter
GitAdapter
GitHubActionsAdapter
PolicyToolAdapter
SecurityToolAdapter
```

## 9.16.1 Adapter Principles

1. Detect native tool presence.
2. Read native manifests without overwriting.
3. Delegate execution only when appropriate.
4. Normalize results into Monad findings.
5. Preserve native tool authority.
6. Avoid becoming a replacement unless explicitly intended.
7. Treat external command execution as risky.
8. Do not require optional tools unless configured.

## 9.16.2 Adapter Maturity Levels

| Level | Description                                    |
| ----- | ---------------------------------------------- |
| L0    | No support.                                    |
| L1    | Detect manifest/config files.                  |
| L2    | Parse basic metadata.                          |
| L3    | Normalize into Monad project/tool findings.    |
| L4    | Delegate safe read-only commands.              |
| L5    | Delegate mutating commands through plan/apply. |
| L6    | Full governance integration.                   |

Early Monad should target L1-L3 for most tools.

## 9.16.3 Native Tool Anti-Corruption Rule

Native tool concepts must be translated into Monad concepts.

Example:

```text id="pw9wpk"
Cargo package -> ProjectCandidate / NativeManifest / ToolCapability
package.json script -> NativeTaskCandidate
GitHub Actions workflow -> CIWorkflowArtifact
Dockerfile -> ContainerBuildArtifact
```

Native tool concepts should not dominate Monad’s core domain model.

---

# 9.17 Integration Categories

## 9.17.1 Filesystem Integration

Required early.

Used for:

* reading repository files,
* resolving workspace root,
* loading manifests,
* scanning docs,
* writing plans/context only when explicitly requested,
* applying approved plans later.

Rules:

* read-only commands use read/list/exists only,
* writes go through plan/apply or explicit output paths.

## 9.17.2 Git Integration

Useful early.

Used for:

* detecting repository root,
* reporting dirty working tree,
* including branch/status in context,
* warning before apply,
* release/change lifecycle later.

Rules:

* Git detection is read-only.
* Git commands should not be required for all workflows.
* Git mutation should be explicit and deferred.

## 9.17.3 CI Integration

Useful in early/mid stages.

Used for:

```bash id="tdm2kx"
monad check --ci
monad docs check --ci
monad policy check --ci
```

CI output should be:

* deterministic,
* non-interactive,
* no color by default,
* meaningful exit codes,
* JSON-capable.

## 9.17.4 Editor Integration

Future.

Potential integrations:

* VS Code,
* JetBrains,
* Zed,
* Cursor,
* Neovim.

Do not build before CLI and structured output are stable.

## 9.17.5 AI Tool Integration

AI integration should begin with context artifacts, not provider calls.

Used for:

* handoff summaries,
* context packs,
* graph exports,
* command catalog exports,
* policy findings.

Rules:

* no AI required,
* no AI calls by default,
* context excludes secrets.

## 9.17.6 Hosted Control Plane Integration

Future.

Used for:

* dashboard projections,
* repo fleet reports,
* release evidence,
* team workflows,
* policy compliance.

Rules:

* hosted is optional,
* local source of truth remains authoritative,
* sync is explicit.

---

# 9.18 Pack, Template, and Plugin API

## 9.18.1 Pack API

A pack is a curated bundle of:

* templates,
* policies,
* docs,
* commands,
* conventions,
* profiles.

Pack metadata should include:

```text id="bgz3kh"
pack_id
name
version
description
compatibility
templates
policies
profiles
checksum
```

Pack installation should be preview-only or plan-backed.

## 9.18.2 Template API

Template metadata should include:

```text id="mb5z0i"
template_id
version
description
inputs
outputs
required_files
generated_files
overwrite_policy
risk_level
```

Templates should declare intended outputs before rendering.

## 9.18.3 Plugin API

Plugin API should be deferred.

Before plugins exist, Monad needs:

* trust model,
* permissions model,
* version compatibility,
* checksum/signature model,
* sandboxing or execution policy,
* installation/update/removal lifecycle,
* audit metadata.

Plugin commands should remain placeholder until this exists.

---

# 9.19 AI Integration API

AI integration should use context and plan APIs.

Potential future provider port:

```rust id="mlqmvk"
pub trait AiProviderPort {
    fn complete(&self, request: AiCompletionRequest) -> Result<AiCompletionResponse>;
    fn summarize(&self, request: AiSummarizeRequest) -> Result<AiSummarizeResponse>;
    fn explain_finding(&self, finding: &Finding) -> Result<AiExplanation>;
    fn suggest_plan(&self, request: AiPlanRequest) -> Result<PlanDraft>;
}
```

Rules:

1. `NoopAiAdapter` must be valid.
2. AI is disabled by default.
3. AI outputs are suggestions.
4. AI-generated mutation becomes a plan.
5. AI provider-specific types do not enter core domain.
6. Hosted providers require explicit opt-in.
7. AI context excludes secrets.

---

# 9.20 Future Hosted API

If a hosted control plane is added later, recommended APIs:

```text id="t6lr3c"
REST for resource operations
GraphQL for graph/dashboard exploration
AsyncAPI/events for repo sync and governance events
Webhooks for CI/release integration
```

Do not build this first.

## 9.20.1 Possible Hosted Resources

Potential resources:

```text id="x2afqg"
organizations
teams
repositories
workspaces
graphs
policies
findings
plans
apply-results
context-packs
release-evidence
waivers
users
audit-events
```

## 9.20.2 Hosted API Boundary

Hosted APIs should consume projections from the local repository.

Recommended default sync direction:

```text id="zjrr1t"
local repository -> generated projection -> hosted control plane
```

Avoid hosted-to-local mutation early.

## 9.20.3 Hosted API Non-Goals Early

Do not build early:

* auth,
* tenancy,
* billing,
* dashboards,
* org management,
* hosted graph database,
* real-time sync,
* hosted plan apply.

---

# 9.21 API Versioning Strategy

Use layered versioning:

```text id="kax3ck"
CLI version: semantic versioning
Manifest schema version: explicit schema_version
Plan schema version: explicit schema_version
JSON output version: explicit schema_version
Pack version: semantic versioning
Template version: semantic versioning
Policy bundle version: semantic versioning
Plugin API version: explicit compatibility range
Hosted API version: route/header versioning later
```

## 9.21.1 CLI Versioning

The CLI binary should use semantic versioning.

Breaking changes include:

* removing commands,
* renaming commands,
* changing required arguments,
* changing exit code semantics,
* breaking stable JSON output.

## 9.21.2 Schema Versioning

Every structured artifact should include schema version.

## 9.21.3 Experimental Stability

Early commands may be marked:

```text id="tiwx78"
experimental
preview
stable
deprecated
removed
```

Command stability should appear in command metadata.

---

# 9.22 Deprecation Strategy

APIs should have clear deprecation behavior.

Deprecation applies to:

* commands,
* flags,
* schemas,
* output fields,
* policy IDs,
* pack versions,
* template versions,
* plugin APIs.

Deprecation guidance:

1. Mark deprecated in metadata.
2. Show warning in human output.
3. Preserve machine-readable deprecation fields.
4. Provide replacement when possible.
5. Avoid removing before a documented compatibility window once stable.
6. Do not over-promise compatibility during early experimental stages.

---

# 9.23 Security Requirements for APIs and Integrations

## 9.23.1 No Network by Default

Core CLI commands must not make network calls.

## 9.23.2 No AI Calls by Default

AI provider calls require explicit configuration.

## 9.23.3 No Secret Leakage

Context and structured exports must exclude secrets by default.

## 9.23.4 Explicit External Command Execution

Native tool commands must not execute unexpectedly.

## 9.23.5 Plugin Trust Required

Plugins must not be executed without a trust model.

## 9.23.6 Plan-Bound Mutation

Any API that mutates files must flow through plan/apply or be explicitly unsafe and temporary.

## 9.23.7 Hosted Sync Is Opt-In

Hosted integrations must require explicit configuration and user consent.

---

# 9.24 Contract Testing Strategy

Contract tests should verify:

* command catalog matches CLI surface,
* nested commands are exposed,
* command examples reference known commands,
* JSON output conforms to schema,
* manifest parsing supports documented schema,
* plan schema remains compatible,
* graph exports are valid enough for target format,
* context output excludes secrets,
* native tool adapter outputs normalize correctly,
* exit codes match documented behavior,
* generated docs match documented behavior,
* read-only commands do not mutate files.

## 9.24.1 Critical Early Contract Tests

Critical early tests:

```text id="sjcg8h"
clap_surface_exposes_every_catalog_command
catalog_does_not_claim_unknown_example_commands
planned_commands_are_honest
mutating_commands_declare_mutation_status
config_list_is_exposed_if_cataloged
read_only_commands_do_not_write_files
```

The current class of failure where a catalog command such as `config list` is missing from the Clap surface should be treated as a high-priority contract failure.

---

# 9.25 Integration Testing Strategy

Integration tests should use fixture repositories.

Recommended fixtures:

```text id="xev8ms"
empty-repo
minimal-monad-repo
manifest-conflict-repo
rust-workspace
polyglot-workspace
docs-missing-repo
policy-violation-repo
context-secret-repo
native-tools-repo
```

Test categories:

* workspace resolution,
* config inspection,
* repository inspection,
* docs checks,
* graph output,
* context handoff,
* policy checks,
* plan/dry-run/apply safety,
* native tool detection.

---

# 9.26 Observability for APIs and Integrations

Even as a CLI, Monad should produce observable behavior.

## 9.26.1 Local Observability

Useful observability outputs:

* verbose logs,
* debug mode later,
* structured findings,
* apply reports,
* context manifests,
* plan reports,
* timing summaries later.

## 9.26.2 CI Observability

CI-friendly output should include:

* clear failure reason,
* stable exit code,
* JSON report option,
* file paths,
* remediation hints,
* severity counts.

## 9.26.3 Future Hosted Observability

Future hosted sync may include:

* audit events,
* policy trends,
* graph changes,
* release evidence,
* apply results,
* AI involvement metadata.

Do not build hosted observability before local reports are valuable.

---

# 9.27 API and Integration Risks

| Risk                    | Description                                   | Mitigation                             |
| ----------------------- | --------------------------------------------- | -------------------------------------- |
| CLI instability         | Commands/flags change too often.              | Mark stability levels; contract tests. |
| Catalog drift           | Catalog and Clap surface disagree.            | Contract tests.                        |
| Output instability      | JSON fields change and break tools.           | Schema versions and stability labels.  |
| Exit code ambiguity     | CI cannot rely on results.                    | Document and test exit codes.          |
| Native tool overreach   | Monad replaces tools instead of coordinating. | Adapter principles.                    |
| Unsafe integration      | External commands run unexpectedly.           | Explicit execution and plan model.     |
| Plugin security         | Plugins execute untrusted code.               | Defer plugins; trust model required.   |
| Hosted distraction      | Hosted API diverts from local core.           | Defer hosted APIs.                     |
| AI lock-in              | AI provider types leak into core.             | Provider abstraction.                  |
| Secret leakage          | Context/API outputs leak secrets.             | Redaction tests.                       |
| Too many commands       | Broad surface overwhelms implementation.      | Placeholder honesty and layering.      |
| Premature API stability | Early APIs become frozen too soon.            | Experimental stability labels.         |

---

# 9.28 Recommended Initial API Implementation Order

Recommended order:

1. Define command metadata model.
2. Define command catalog.
3. Define command surface contract tests.
4. Expose missing catalog commands in Clap.
5. Implement honest placeholder renderer.
6. Standardize basic output formatting.
7. Standardize exit codes.
8. Add `--format text/json` where useful.
9. Define finding model.
10. Define JSON report envelope.
11. Define `monad.toml` schema draft.
12. Define command catalog JSON export.
13. Add fixture-based integration tests.
14. Add docs for command stability.
15. Add native tool detection only after inspection foundation.
16. Add plan schema only after read-only commands are useful.
17. Defer plugin/local daemon/hosted APIs.

This order preserves the current priority:

```text id="mppf5w"
CLI trust
-> structured output
-> file schemas
-> read-only integration
-> plan/apply
-> native tool delegation
-> plugin/AI/hosted APIs
```

---

# 9.29 Open Questions

The following should be resolved through ADRs, work packets, or implementation experiments:

1. Which commands are considered stable for v0?
2. What exact metadata fields are required for every command?
3. Should placeholder commands exit with code `5` or `0` plus warning?
4. What is the initial JSON output envelope?
5. Which commands get JSON output first?
6. What is the exact `monad.toml` schema?
7. Which file schemas need JSON Schema files first?
8. How should command aliases be handled?
9. How should deprecated commands be represented?
10. Which native tool adapter should be first after Git/Cargo detection?
11. Should `run/build/test/lint/format` delegate to native tools in v1 or remain planned?
12. Should `monad context handoff --output` write files before plan/apply exists?
13. Should generated context be considered a safe explicit output path exception?
14. How should plugin API permissions be represented?
15. What is the first hosted API endpoint, if a hosted control plane is ever built?

---

# 9.30 Section Acceptance Criteria

This section is complete when it clearly defines:

1. Monad’s API surface layers.
2. The CLI as the first public API.
3. CLI design principles.
4. Top-level command surface.
5. Namespaced command surface.
6. Command metadata requirements.
7. Global flag strategy.
8. Output format strategy.
9. Structured output envelopes.
10. Exit code strategy.
11. Error and finding model.
12. Internal Rust API boundaries.
13. File schema API.
14. Native tool integration strategy.
15. Integration categories.
16. Pack/template/plugin API posture.
17. AI integration API posture.
18. Future hosted API posture.
19. Versioning strategy.
20. Deprecation strategy.
21. Security requirements.
22. Contract testing strategy.
23. Integration testing strategy.
24. Observability posture.
25. API and integration risks.
26. Recommended implementation order.
27. Open questions.

Future API work should preserve this section’s central rule:

> The CLI is the first public API; everything else should grow from a trustworthy local command surface.
