# 12. Observability and Operations

## 12.1 Purpose of This Section

This section defines the observability and operations strategy for Monad OS and Monad CLI.

Its purpose is to clarify:

* what observability means for a local-first CLI,
* how Monad should explain command behavior,
* how errors, warnings, findings, reports, and diagnostics should be modeled,
* how CI/CD should consume Monad output,
* how operations should work before a hosted control plane exists,
* how future hosted observability should evolve,
* how runbooks, incidents, release defects, and safety failures should be handled,
* and how Monad should mature operationally without becoming telemetry-first, cloud-first, or SaaS-dependent.

Monad’s early operational model is not the same as a web service’s operational model.

For early Monad, observability means:

```text
A user runs a local command.
Monad explains what it inspected.
Monad reports what it found.
Monad provides remediation guidance.
Monad exits with a meaningful status code.
Monad can emit stable structured output for automation.
Monad does not send telemetry by default.
```

Future hosted Monad may require logs, metrics, traces, dashboards, alerts, SLOs, incident response, audit evidence, and fleet-level reporting. Those capabilities are important later, but they must not distort the local-first architecture.

The early baseline remains:

```text
Developer machine
  └─ monad binary
      └─ local repository
          └─ terminal output / structured reports / CI exit codes
```

---

## 12.2 Observability Thesis

Monad’s observability thesis is:

> A governance-grade CLI must make its reasoning, checks, decisions, findings, plans, and effects inspectable before it asks users to trust it.

Monad is intended to become a repository lifecycle control plane. That means users must be able to understand not only whether a command succeeded or failed, but also:

* what command was run,
* what repository root was detected,
* what configuration was loaded,
* what files were inspected,
* what native tools were invoked,
* what checks were performed,
* what findings were produced,
* what output artifacts were written,
* what was skipped and why,
* what remediation is recommended,
* what would be changed by a plan,
* what was changed by an apply,
* and what evidence exists after the command completes.

This is especially important because Monad will eventually handle high-trust workflows:

* repository governance,
* documentation lifecycle checks,
* ADR and decision tracking,
* work-packet planning,
* policy evaluation,
* context export,
* AI-assisted planning,
* plan-backed mutation,
* release readiness,
* waiver tracking,
* and compliance evidence.

For Monad, observability is not a hosted dashboard first. It is a product trust primitive.

---

## 12.3 Observability Principles

Monad observability should follow these principles.

### 12.3.1 Explain Before Failing

Every failure should explain:

* what failed,
* why it failed if knowable,
* what file or command was involved,
* whether the issue is blocking,
* and how the user can remediate it.

Bad failure:

```text
Error: invalid config
```

Better failure:

```text
Error: Invalid monad.toml

Path:
  /repo/monad.toml

Problem:
  Field `workspace.name` is missing.

Remediation:
  Add [workspace] name = "..." to monad.toml, or run:
    monad config init --plan
```

### 12.3.2 Findings Before Raw Logs

Human-facing output should prioritize useful findings over raw implementation logs.

Logs help debug Monad. Findings help users improve their repository.

A finding should be structured, stable, and actionable.

### 12.3.3 Stable Output for Automation

Machine-readable output must be stable enough for CI, scripts, dashboards, and future hosted ingestion.

Text output may evolve for readability. JSON output should be versioned and treated as an API contract.

### 12.3.4 Debug and Trace Must Be Opt-In

Default output should be concise and useful.

Debug and trace output should be enabled explicitly by flags or environment variables.

### 12.3.5 No Telemetry by Default

Monad should not send command usage, repository metadata, findings, file paths, context packs, metrics, or error reports anywhere by default.

Future telemetry must be:

* opt-in,
* documented,
* disableable,
* inspectable,
* privacy-preserving,
* and unnecessary for correctness.

### 12.3.6 Local Evidence Before Hosted Observability

Early Monad should create local evidence:

* terminal summaries,
* JSON reports,
* graph outputs,
* diagnostic reports,
* context manifests,
* plan files,
* apply reports,
* policy reports,
* release readiness reports.

Hosted observability may later aggregate this evidence, but local evidence should exist first.

### 12.3.7 Plans and Applies Must Be Auditable

Every plan should disclose intended effects.

Every apply should disclose actual effects.

No mutating workflow should rely only on a success message.

### 12.3.8 Operations Are Part of Product Trust

Operational practices such as release safety, incident response, advisories, regression testing, runbooks, and postmortems are product features for a governance-grade tool.

---

## 12.4 Observability Scope by Deployment Mode

Monad has different observability needs depending on where it runs.

### 12.4.1 Local CLI Mode

Local CLI observability includes:

* terminal output,
* errors and warnings,
* structured findings,
* debug output,
* trace output,
* local reports,
* local graph artifacts,
* local plan/apply evidence,
* local diagnostic bundles,
* clear exit codes.

No hosted observability backend is required.

### 12.4.2 CI Mode

CI observability includes:

* non-interactive output,
* stable exit codes,
* JSON or Markdown reports,
* artifacts that can be uploaded by CI,
* summary output suitable for logs,
* failure details suitable for annotations,
* deterministic behavior,
* no prompts,
* no hidden network calls,
* no hidden mutation.

### 12.4.3 Release Mode

Release observability includes:

* build logs,
* test results,
* command contract checks,
* generated release notes,
* checksums,
* SBOMs later,
* provenance attestations later,
* signed artifacts later,
* vulnerability scan results,
* release readiness reports.

### 12.4.4 Future Hosted Mode

Future hosted observability may include:

* API logs,
* audit logs,
* metrics,
* traces,
* dashboards,
* SLOs,
* alerts,
* repository fleet health,
* policy drift reports,
* release gate trends,
* waiver status,
* context export history,
* AI usage transparency,
* incident tracking.

Hosted observability should be additive, not foundational to the local CLI.

---

## 12.5 Output Channels

Monad should distinguish between several output channels.

### 12.5.1 Human Terminal Output

Default command output should be optimized for human understanding.

It should be:

* concise,
* readable,
* actionable,
* stable enough for users,
* not overly noisy,
* not filled with debug details,
* and explicit when something important was skipped.

Example:

```text
Monad check completed

Workspace:
  Root: /repo
  Manifest: monad.toml
  Profile: local

Summary:
  12 checks passed
  2 warnings
  0 errors

Warnings:
  [DOCS-001] Missing ADR index
    Path: docs/adr/
    Remediation: Create docs/adr/README.md or configure ADR path.

  [TOOLS-003] Optional tool not found: cargo-deny
    Remediation: Install cargo-deny or disable dependency policy checks.

Result:
  Repository is usable with warnings.
```

### 12.5.2 Machine-Readable Output

Machine-readable output should be available for commands that produce meaningful data.

Supported formats may include:

```text
json
markdown
text
mermaid
dot
```

Not every command needs every format, but commands that participate in automation should support at least JSON.

Example:

```bash
monad check --format json
monad graph --format mermaid
monad graph --format dot
monad docs check --format json
monad context handoff --format markdown
```

### 12.5.3 Report Files

Commands should be able to write durable reports.

Examples:

```bash
monad check --format json --output .monad/reports/check.json
monad doctor --format markdown --output .monad/reports/doctor.md
monad graph --format mermaid --output .monad/graphs/workspace.mmd
```

Reports should include enough metadata to be understandable later.

Report metadata should include:

* Monad version,
* command name,
* command arguments where safe,
* repository root,
* profile,
* timestamp where useful,
* schema version,
* input manifest path,
* output format,
* findings summary,
* and command result.

### 12.5.4 Diagnostic Bundles

A future diagnostic command may create a support bundle.

Example:

```bash
monad diagnostics bundle --redact
```

A diagnostic bundle should never include sensitive files by default.

It may include:

* command metadata,
* selected configuration,
* version information,
* tool availability,
* findings,
* report summaries,
* schema versions,
* environment metadata,
* redacted logs.

It should exclude by default:

* secrets,
* source files,
* private documents,
* full context packs,
* environment variables with sensitive names,
* unredacted paths where configured,
* credentials,
* tokens,
* SSH keys,
* `.env` files,
* cloud credential files.

---

## 12.6 Logging Strategy

Monad should have a clear logging model that separates user-facing output from diagnostic output.

### 12.6.1 Log Levels

Recommended log levels:

```text
error
warn
info
debug
trace
```

Meaning:

| Level   | Purpose                                                           |
| ------- | ----------------------------------------------------------------- |
| `error` | Serious failure that prevents requested operation from completing |
| `warn`  | Non-blocking issue or degraded behavior                           |
| `info`  | High-level command progress when verbosity is enabled             |
| `debug` | Diagnostic details useful for developers or support               |
| `trace` | Very detailed execution flow for deep debugging                   |

### 12.6.2 Default Logging Behavior

Default behavior should be quiet and user-focused.

By default:

* show command results,
* show important findings,
* show remediation guidance,
* hide implementation details,
* hide stack traces,
* hide internal debug logs,
* avoid noisy progress logs unless useful.

### 12.6.3 Logging Flags

Potential flags:

```bash
--verbose
--quiet
--debug
--trace
--log-format text
--log-format json
--no-color
```

Recommended semantics:

| Flag                | Behavior                       |
| ------------------- | ------------------------------ |
| `--verbose`         | Show more progress and context |
| `--quiet`           | Show only essential output     |
| `--debug`           | Enable debug diagnostics       |
| `--trace`           | Enable highly detailed tracing |
| `--log-format text` | Human-readable logs            |
| `--log-format json` | Structured logs for machines   |
| `--no-color`        | Disable ANSI color output      |

### 12.6.4 Environment Variables

Possible environment variables:

```text
MONAD_LOG
MONAD_LOG_FORMAT
MONAD_NO_COLOR
MONAD_PROFILE
MONAD_OFFLINE
```

These should be documented and stable once introduced.

### 12.6.5 Sensitive Logging Rules

Monad must avoid logging secrets.

Sensitive values should be redacted when detected.

Examples of sensitive values:

* tokens,
* passwords,
* API keys,
* private keys,
* session cookies,
* cloud credentials,
* database URLs with passwords,
* `.env` contents,
* SSH material,
* OAuth credentials.

Redaction should prefer safety over completeness.

Example:

```text
DATABASE_URL=postgres://user:[REDACTED]@localhost/db
```

---

## 12.7 Tracing Strategy

Tracing for a local CLI should not imply distributed tracing.

Early tracing means local execution tracing.

Trace output should answer:

* which command path executed,
* what configuration files were loaded,
* what repository root was selected,
* what checks ran,
* what native tools were called,
* how long major steps took,
* what files or directories were scanned,
* why certain checks were skipped,
* and where output artifacts were written.

Example future trace output:

```text
trace: command=check profile=local
trace: detected repo root=/repo
trace: loaded manifest=/repo/monad.toml
trace: loaded lockfile=/repo/monad.lock
trace: running check=workspace-root
trace: running check=command-catalog
trace: running check=docs-index
trace: skipped check=cargo-deny reason=tool-not-found
trace: wrote report=.monad/reports/check.json
```

Trace mode should be opt-in because it may expose paths, filenames, and repository structure.

Future hosted Monad may use OpenTelemetry for distributed traces. That should be introduced only when there are hosted services that require it.

---

## 12.8 Findings Model

Many Monad commands should normalize results into findings.

A finding is a structured statement that something was observed, verified, missing, inconsistent, risky, invalid, stale, unsafe, or blocked.

Findings should be used by commands such as:

```bash
monad check
monad doctor
monad inspect
monad docs check
monad policy check
monad context verify
monad plan validate
monad release readiness
```

### 12.8.1 Finding Severity

Recommended severity levels:

```text
info
warning
error
critical
```

Severity meaning:

| Severity   | Meaning                                     | Typical Exit Impact                      |
| ---------- | ------------------------------------------- | ---------------------------------------- |
| `info`     | Useful observation                          | Usually zero                             |
| `warning`  | Non-blocking issue                          | Usually zero locally, configurable in CI |
| `error`    | Blocking issue for requested operation      | Nonzero                                  |
| `critical` | Severe safety, integrity, or security issue | Nonzero                                  |

### 12.8.2 Finding Shape

A conceptual finding should include:

```text
id
severity
title
message
path
span or location, optional
category
remediation
policy id, optional
documentation link, optional
source command
source check
related files
machine-readable code
```

Example JSON-like shape:

```json
{
  "id": "DOCS-ADR-INDEX-MISSING",
  "severity": "warning",
  "title": "ADR index is missing",
  "message": "ADR files were found, but no ADR index document was detected.",
  "path": "docs/adr/",
  "category": "documentation",
  "remediation": "Create docs/adr/README.md listing accepted, proposed, and superseded ADRs.",
  "source_command": "monad docs check",
  "source_check": "adr-index"
}
```

### 12.8.3 Finding Categories

Recommended categories:

```text
workspace
manifest
lockfile
documentation
adr
work-packet
policy
security
privacy
context
ai
graph
native-tool
dependency
release
plan
apply
schema
configuration
```

### 12.8.4 Finding IDs

Finding IDs should be stable.

Good IDs:

```text
WORKSPACE-ROOT-NOT-FOUND
MANIFEST-CANONICAL-CONFLICT
DOCS-ADR-INDEX-MISSING
CONTEXT-SECRET-RISK
POLICY-WAIVER-EXPIRED
PLAN-UNREVIEWED-MUTATION
```

Avoid unstable IDs tied to implementation details.

Bad IDs:

```text
ERR_42
check_failed_17
foo_error
```

### 12.8.5 Finding Remediation

Every warning, error, and critical finding should include a remediation hint when possible.

Remediation may be:

* a manual fix,
* a suggested command,
* a documentation reference,
* a configuration change,
* a policy update,
* or a waiver process.

Example:

```text
Remediation:
  Add the missing section to docs/planning/index.md,
  or configure documentation.required_sections in monad.toml.
```

---

## 12.9 Error Model

Errors are different from findings.

A finding says something about the repository or lifecycle.

An error says the command could not complete as requested.

Examples of command errors:

* invalid CLI arguments,
* unreadable manifest,
* invalid TOML,
* permission denied,
* unsupported output format,
* output path unavailable,
* native tool execution failed,
* plan file malformed,
* schema version unsupported.

Errors should include:

* error code,
* human message,
* optional path,
* optional source error,
* remediation hint,
* exit code mapping,
* whether partial output was produced.

Example:

```text
Error: Unable to read monad.toml

Path:
  /repo/monad.toml

Cause:
  Permission denied

Remediation:
  Check file permissions or run the command from a repository you can read.

Exit code:
  2
```

Errors should not expose internal panics in normal mode.

Panics should be treated as bugs.

---

## 12.10 Exit Code Strategy

Monad should use stable exit codes.

Recommended initial model:

| Exit Code | Meaning                              |
| --------: | ------------------------------------ |
|       `0` | Success                              |
|       `1` | Findings include blocking issues     |
|       `2` | Command usage error                  |
|       `3` | Configuration or manifest error      |
|       `4` | Repository/workspace detection error |
|       `5` | Native tool failure                  |
|       `6` | Plan validation or apply failure     |
|       `7` | Safety/security gate failure         |
|       `8` | Unsupported schema/version           |
|       `9` | Internal error or unexpected failure |

The exact code list should be finalized through implementation and documented as a CLI contract.

CI mode should rely on these exit codes.

Human users should also receive clear terminal explanations.

---

## 12.11 Health Checks and Diagnostics

For a local CLI, health checks are diagnostics.

The primary diagnostic command should be:

```bash
monad doctor
```

`monad doctor` should answer:

```text
Can Monad understand and operate safely in this repository?
```

### 12.11.1 Recommended `monad doctor` Checks

`monad doctor` should check:

* current working directory,
* workspace root detection,
* Git repository detection,
* `monad.toml` presence,
* `workspace.toml` mirror status if present,
* `monad.lock` presence and compatibility,
* `.monad/` path availability,
* command catalog integrity,
* documentation structure,
* ADR index presence,
* work-packet structure,
* policy configuration,
* context output paths,
* ignore rules,
* native tool availability,
* native tool versions,
* output directory permissions,
* schema compatibility,
* known configuration conflicts.

### 12.11.2 `monad doctor` Output

Example:

```text
Monad Doctor

Environment:
  Monad version: 0.1.0
  Profile: local
  OS: linux
  Repository root: /repo

Checks:
  ✓ Workspace root detected
  ✓ monad.toml found
  ✓ command catalog valid
  ⚠ workspace.toml exists but differs from monad.toml
  ⚠ optional tool cargo-deny not found
  ✗ ADR directory configured but missing

Summary:
  10 passed
  2 warnings
  1 error

Result:
  Repository requires attention before full governance checks can pass.
```

### 12.11.3 Doctor Versus Check

`monad doctor` and `monad check` should have distinct meanings.

```text
monad doctor:
  Is this environment/repository usable by Monad?

monad check:
  Does this repository satisfy configured lifecycle, documentation, graph, and governance rules?
```

Doctor is diagnostic.

Check is evaluative.

---

## 12.12 Readiness Checks

Readiness checks determine whether a repository is ready for a particular workflow.

Examples:

```bash
monad check --ci
monad docs check --ci
monad context verify --ci
monad release readiness --ci
```

Readiness checks should be:

* non-interactive,
* deterministic,
* configured by repository policy,
* suitable for CI,
* strict enough to protect important gates,
* flexible enough to support staged adoption.

### 12.12.1 CI Readiness

`monad check --ci` should:

* emit stable output,
* avoid prompts,
* avoid hidden network calls,
* produce a nonzero exit code on blocking issues,
* optionally write a report,
* show a concise failure summary,
* and avoid changing repository files unless explicitly configured.

### 12.12.2 Release Readiness

A future `monad release readiness` command may check:

* changelog status,
* version metadata,
* command contract tests,
* docs status,
* ADR status,
* work-packet completion,
* policy waivers,
* security gates,
* generated artifacts,
* release notes,
* SBOM availability,
* provenance status,
* open critical findings.

Release readiness should become part of Monad’s governance-grade operations model.

---

## 12.13 Liveness, Readiness, and Health in Future Hosted Monad

For local Monad, liveness/readiness are mostly not applicable because the CLI starts, runs, and exits.

For future hosted Monad, the concepts become relevant.

### 12.13.1 Hosted Liveness

Liveness answers:

```text
Is the service process alive and able to respond?
```

Possible endpoint:

```text
GET /health/live
```

### 12.13.2 Hosted Readiness

Readiness answers:

```text
Can the service perform its required work?
```

Possible endpoint:

```text
GET /health/ready
```

Readiness may check:

* database connection,
* object storage connection,
* queue connection,
* identity provider configuration,
* migration status,
* required secrets,
* background worker status,
* graph index availability.

### 12.13.3 Hosted Health

Health answers:

```text
Is the system operating within acceptable bounds?
```

Possible endpoint:

```text
GET /health
```

This may summarize:

* dependencies,
* degraded services,
* active incidents,
* current version,
* uptime,
* migration state.

These hosted patterns should remain future-facing.

---

## 12.14 Metrics Strategy

Early Monad should not emit metrics to a remote backend by default.

However, local metrics can help users understand command behavior and repository scale.

### 12.14.1 Local Metrics

Possible local metrics:

* command duration,
* files scanned,
* directories scanned,
* manifests parsed,
* findings count,
* findings by severity,
* graph nodes count,
* graph edges count,
* documentation pages checked,
* ADRs discovered,
* work packets discovered,
* policies evaluated,
* native tools invoked,
* skipped checks,
* plan steps count,
* files planned for mutation,
* apply success/failure count.

Example report summary:

```json
{
  "metrics": {
    "duration_ms": 248,
    "files_scanned": 312,
    "findings_total": 4,
    "findings_by_severity": {
      "info": 1,
      "warning": 2,
      "error": 1,
      "critical": 0
    },
    "graph_nodes": 86,
    "graph_edges": 143
  }
}
```

### 12.14.2 CI Metrics

CI may use local metrics to track repository health over time.

Examples:

* increasing stale documentation count,
* increasing policy warnings,
* graph growth,
* dependency risk count,
* release readiness failures,
* waivers nearing expiration.

Early Monad does not need to store trends itself. CI artifacts or future hosted ingestion can handle that later.

### 12.14.3 Future Hosted Metrics

Future hosted metrics may include:

* active repositories,
* repositories by health status,
* policy pass/fail rates,
* stale documentation count,
* unreviewed ADRs,
* open waivers,
* expired waivers,
* release readiness status,
* plan generation count,
* plan apply success/failure,
* context export count,
* AI-assisted plan count,
* graph drift indicators,
* command usage by category,
* sync success/failure,
* API latency,
* worker queue depth,
* ingestion failures,
* tenant-level storage usage.

Hosted product metrics must be separated from private repository content.

---

## 12.15 SLO Strategy

SLOs for early Monad should focus on product correctness, safety, and reliability rather than web-service uptime.

### 12.15.1 Local CLI SLOs

Potential local CLI SLOs:

| Area                     | Target                                                      |
| ------------------------ | ----------------------------------------------------------- |
| Command catalog contract | 100% tested                                                 |
| Read-only command safety | No canonical file mutations                                 |
| Plan visibility          | 100% of planned file operations listed before apply         |
| Apply reporting          | 100% of apply operations produce a report                   |
| Secret redaction         | Known secret file patterns excluded from context by default |
| Schema compatibility     | No unversioned machine-readable output schemas              |
| CI reliability           | Main branch remains green                                   |
| Error usefulness         | Blocking errors include remediation where feasible          |
| Output stability         | JSON output changes only through versioned schema changes   |
| Native tool degradation  | Missing optional tools produce findings, not crashes        |

### 12.15.2 Hosted SLOs Later

Future hosted SLOs may include:

* API availability,
* API latency,
* ingestion success rate,
* graph processing latency,
* dashboard availability,
* alert delivery latency,
* report generation success,
* repository sync success,
* tenant isolation controls,
* audit log durability.

Example future SLOs:

| Area                   | Example Target                     |
| ---------------------- | ---------------------------------- |
| API availability       | 99.9% monthly                      |
| Graph report ingestion | 99% processed within target window |
| Audit log durability   | No known accepted audit event loss |
| Alert delivery         | 95% delivered within target window |
| Dashboard availability | 99.5% monthly                      |

These should be defined only when hosted Monad exists.

---

## 12.16 Alerting Strategy

Early local Monad does not require alerting.

A local CLI has no always-on process to alert from.

Instead, early Monad should surface issues at command execution time:

```text
run command
  └─ produce findings
      └─ user or CI sees result
```

### 12.16.1 Local and CI Alerts

In CI, alerts are usually CI failures.

Examples:

* pull request check fails,
* release readiness fails,
* docs check fails,
* policy check fails,
* context safety check fails,
* graph integrity check fails.

Monad should make CI failures clear and actionable.

### 12.16.2 Future Hosted Alerts

Future hosted Monad may alert on:

* policy drift,
* stale docs,
* failed repository sync,
* risky plan generated,
* unreviewed plan waiting too long,
* expired waiver,
* waiver nearing expiration,
* release gate failure,
* audit export failure,
* graph ingestion failure,
* compromised pack signature,
* unsupported CLI version,
* critical security finding,
* AI context export containing risky files,
* hosted service degradation.

Alert channels may include:

* email,
* Slack,
* Microsoft Teams,
* webhooks,
* GitHub issues,
* Jira,
* Linear,
* PagerDuty,
* Opsgenie,
* generic webhook endpoints.

These should be implemented later and should remain optional.

---

## 12.17 Reports and Evidence

Reports are central to Monad observability.

A report is a durable artifact describing command output, findings, metrics, and evidence.

### 12.17.1 Report Types

Potential report types:

```text
inspection report
doctor report
check report
docs report
graph report
policy report
context report
plan report
apply report
release readiness report
security report
dependency report
```

### 12.17.2 Report Location

Default report paths may use:

```text
.monad/reports/
```

Example:

```text
.monad/reports/
  check.json
  doctor.md
  docs-check.json
  graph-summary.json
  policy.json
  context-handoff.md
  release-readiness.json
```

Reports should be safe to delete and regenerate unless explicitly promoted to evidence.

### 12.17.3 Evidence Promotion

Some reports may become formal governance evidence.

Examples:

* release readiness report attached to a release,
* policy report attached to a compliance review,
* apply report attached to a work packet,
* context export manifest attached to an AI-assisted planning session,
* docs check report attached to lifecycle governance.

Future Monad may support explicit evidence commands:

```bash
monad evidence record
monad evidence list
monad evidence verify
```

This should be deferred until the evidence model is mature.

---

## 12.18 Plan/Apply Observability

Plan-backed mutation is one of Monad’s most important future safety features.

Observability must be designed before mutation becomes powerful.

### 12.18.1 Plan Observability

Every generated plan should include:

* plan ID,
* command that generated it,
* Monad version,
* repository root,
* inputs considered,
* intended file creates,
* intended file updates,
* intended file deletes,
* intended moves/renames,
* native tools to be invoked,
* expected generated artifacts,
* risk classification,
* policy checks,
* preconditions,
* rollback hints if possible,
* human review status,
* timestamp,
* schema version.

### 12.18.2 Dry-Run Observability

Dry-run output should explain:

```text
what would change
what would not change
what checks passed
what checks failed
what risks exist
what manual review is required
```

Example:

```bash
monad plan apply .monad/plans/add-docs.plan.json --dry-run
```

### 12.18.3 Apply Observability

Every apply should produce an apply report.

An apply report should include:

* apply ID,
* plan ID,
* start time,
* end time,
* files created,
* files modified,
* files deleted,
* native tools executed,
* command outputs where safe,
* skipped operations,
* failed operations,
* rollback hints,
* final findings,
* exit status.

### 12.18.4 Failed Apply Handling

A failed apply should never leave the user with only:

```text
Apply failed
```

It should explain:

* what completed,
* what did not complete,
* whether partial changes exist,
* how to inspect the diff,
* whether rollback is possible,
* what command to run next,
* and what manual repair may be required.

---

## 12.19 Context Export Observability

Context export is a sensitive workflow because it may prepare repository information for humans, AI tools, or future external systems.

Commands such as:

```bash
monad context handoff
monad context pack
monad context verify
```

should produce clear observability.

### 12.19.1 Context Export Report

A context export report should include:

* export ID,
* command,
* output path,
* files included,
* files excluded,
* exclusion reasons,
* token/size estimate if applicable,
* secret scan result,
* ignore rules used,
* AI provider involvement, if any,
* whether network was used,
* warnings,
* risks,
* schema version.

### 12.19.2 Context Safety Findings

Possible findings:

```text
CONTEXT-ENV-FILE-EXCLUDED
CONTEXT-SECRET-PATTERN-DETECTED
CONTEXT-LARGE-FILE-SKIPPED
CONTEXT-BINARY-FILE-SKIPPED
CONTEXT-GITIGNORED-FILE-SKIPPED
CONTEXT-POLICY-DENIED-PATH
```

### 12.19.3 AI Transparency

If AI is ever involved in context workflows, reports must disclose:

* whether AI was used,
* provider name,
* model name where applicable,
* whether data left the machine,
* what files or summaries were sent,
* what output was produced,
* and what human approval occurred.

AI must not be hidden behind normal commands.

---

## 12.20 Native Tool Observability

Monad coordinates native tools. It must make native tool interaction visible.

Native tools may include:

* Git,
* Cargo,
* Bun,
* npm,
* pnpm,
* Docker,
* Biome,
* ESLint,
* cargo-deny,
* cargo-audit,
* Trivy,
* OpenSSF Scorecard,
* gitleaks,
* ripgrep,
* graph tools,
* documentation tools.

### 12.20.1 Tool Detection

Monad should report:

* whether a tool is available,
* detected version,
* whether it is required or optional,
* how it was found,
* and what checks depend on it.

Example:

```text
Native tools:
  git: found 2.45.0
  cargo: found 1.88.0
  cargo-deny: not found, optional
  docker: not found, optional
```

### 12.20.2 Tool Invocation

When invoking native tools, debug/trace mode should disclose:

* command path,
* arguments where safe,
* working directory,
* exit status,
* duration,
* captured output if safe,
* whether output was parsed.

Secrets must be redacted.

### 12.20.3 Tool Failure

Native tool failures should be normalized into Monad errors or findings.

Example:

```text
Finding: Optional dependency audit skipped
Tool: cargo-audit
Reason: tool not found
Severity: warning
Remediation: Install cargo-audit or disable dependency audit checks.
```

---

## 12.21 Operational Runbooks

Runbooks are written procedures for known operational problems.

Early Monad should maintain local/project runbooks for common failures.

Recommended initial runbooks:

```text
docs/operations/runbooks/workspace-not-detected.md
docs/operations/runbooks/manifest-conflict.md
docs/operations/runbooks/lockfile-incompatible.md
docs/operations/runbooks/command-catalog-mismatch.md
docs/operations/runbooks/docs-check-failed.md
docs/operations/runbooks/context-export-safety.md
docs/operations/runbooks/native-tool-missing.md
docs/operations/runbooks/plan-validation-failed.md
docs/operations/runbooks/plan-apply-failed.md
docs/operations/runbooks/release-failed.md
docs/operations/runbooks/compromised-release-artifact.md
docs/operations/runbooks/secret-leakage.md
```

### 12.21.1 Runbook Structure

Each runbook should include:

* title,
* symptom,
* likely causes,
* severity,
* affected commands,
* diagnostic commands,
* safe remediation steps,
* unsafe actions to avoid,
* escalation path,
* regression test guidance,
* related ADRs or policies,
* related findings.

### 12.21.2 Example Runbook Outline

````markdown
# Manifest Conflict

## Symptom

`monad doctor` reports that `workspace.toml` differs from `monad.toml`.

## Likely Causes

- Compatibility mirror is stale.
- Manual edit changed the mirror.
- Migration script partially completed.
- Branch merge introduced inconsistent config.

## Diagnostic Commands

```bash
monad doctor
monad config inspect
git diff -- monad.toml workspace.toml
````

## Remediation

1. Treat `monad.toml` as canonical.
2. Regenerate or update the compatibility mirror.
3. Re-run `monad doctor`.
4. Commit the corrected files.

## Avoid

Do not treat `workspace.toml` as canonical.

````

---

## 12.22 Incident Response

For early Monad, incidents are not primarily server outages.

They are safety, correctness, supply-chain, release, or trust failures.

### 12.22.1 Incident Categories

Potential incident categories:

```text
destructive mutation bug
secret leakage bug
incorrect policy pass
incorrect policy failure
context export safety failure
incompatible schema release
broken command contract
broken release artifact
malicious dependency
compromised release artifact
unsafe generated plan
unsafe apply behavior
AI output incorrectly treated as authoritative
hosted sync privacy issue, future
````

### 12.22.2 Severity Levels

Recommended incident severity levels:

| Severity | Meaning                                                                      |
| -------- | ---------------------------------------------------------------------------- |
| SEV-1    | Severe user harm, destructive mutation, secret exposure, compromised release |
| SEV-2    | Major correctness failure, broken release, policy safety failure             |
| SEV-3    | Significant regression with workaround                                       |
| SEV-4    | Minor operational defect or documentation issue                              |

### 12.22.3 Incident Response Process

Incident response should include:

1. Identify and confirm the issue.
2. Classify severity.
3. Freeze affected release or workflow if necessary.
4. Reproduce the failure.
5. Identify affected versions.
6. Publish advisory if users may be affected.
7. Patch or revert.
8. Add regression test.
9. Update runbook.
10. Update risk register.
11. Document postmortem.
12. Improve safety control.

### 12.22.4 Incident Artifacts

Incident artifacts may include:

```text
incident report
timeline
affected versions
reproduction case
patch commit
regression test
advisory
risk register update
postmortem
runbook update
ADR update if architecture changed
```

### 12.22.5 Postmortem Expectations

A postmortem should answer:

* what happened,
* what users were affected,
* how it was detected,
* why existing controls failed,
* what fixed it,
* what tests were added,
* what process changed,
* what remaining risk exists.

Postmortems should be blameless but precise.

---

## 12.23 Release Operations

Release operations are a major part of Monad’s operational maturity.

### 12.23.1 Release Readiness

Before release, Monad should eventually verify:

* tests pass,
* command catalog contract passes,
* help output is stable,
* JSON schemas are versioned,
* docs are updated,
* changelog is updated,
* known critical findings are resolved,
* release notes are prepared,
* supported platforms build,
* artifacts have checksums,
* security scans pass,
* SBOM/provenance/signing are present when implemented.

### 12.23.2 Release Evidence

Release evidence may include:

```text
test report
coverage report
clippy report
dependency audit report
SBOM
checksums
signed artifacts
release readiness report
changelog
migration notes
compatibility notes
```

### 12.23.3 Rollback and Hotfix

A release runbook should define:

* how to yank or mark a release as bad,
* how to publish a patched release,
* how to communicate breaking defects,
* how to document affected versions,
* how to add regression tests,
* how to update compatibility guidance.

For early Monad, rollback may be documentation-based rather than automated.

---

## 12.24 Schema and Contract Observability

Monad should treat machine-readable outputs as contracts.

Schemas may exist for:

* command catalog,
* findings,
* check reports,
* doctor reports,
* graph output,
* context manifests,
* plan files,
* apply reports,
* policy reports,
* release readiness reports.

### 12.24.1 Schema Versioning

Every structured report should include a schema version.

Example:

```json
{
  "schema_version": "monad.check.report.v1",
  "monad_version": "0.1.0",
  "command": "check"
}
```

### 12.24.2 Contract Testing

Contract tests should verify:

* expected commands exist,
* help output remains coherent,
* JSON output has required fields,
* findings contain stable IDs,
* exit codes match expected cases,
* generated reports validate against schema,
* read-only commands do not mutate files.

### 12.24.3 Compatibility Failures

If a report schema changes incompatibly, the change should be:

* versioned,
* documented,
* tested,
* included in release notes,
* and migration guidance should be provided when needed.

---

## 12.25 Security and Privacy Observability

Monad’s operations model must include security and privacy visibility.

### 12.25.1 Security Findings

Security-related findings may include:

```text
SECRET-PATTERN-DETECTED
CONTEXT-EXPORT-RISK
UNTRUSTED-PLUGIN
UNSIGNED-PACK
UNVERIFIED-RELEASE-ARTIFACT
POLICY-WAIVER-EXPIRED
DEPENDENCY-AUDIT-FAILED
NATIVE-TOOL-UNAVAILABLE
```

### 12.25.2 Privacy Observability

Monad should disclose when workflows may expose sensitive data.

Examples:

* context export,
* AI-assisted workflows,
* hosted sync,
* diagnostic bundles,
* report uploads,
* pack/plugin installation,
* remote update checks.

Any command that sends data externally should disclose that clearly.

### 12.25.3 Redaction Reporting

When redaction happens, Monad should report it without exposing the redacted value.

Example:

```text
Redaction:
  3 sensitive values redacted
  2 .env files excluded
  1 private key pattern detected and excluded
```

---

## 12.26 Future Hosted Observability Architecture

Future hosted Monad may require a full observability stack.

### 12.26.1 Hosted Signals

Hosted observability should collect:

* logs,
* metrics,
* traces,
* audit events,
* security events,
* policy events,
* repository sync events,
* graph processing events,
* release governance events,
* alert events.

### 12.26.2 OpenTelemetry

Future hosted Monad should strongly consider OpenTelemetry as the default observability instrumentation standard.

OpenTelemetry can support:

* traces,
* metrics,
* logs,
* vendor portability,
* local/self-hosted collectors,
* cloud observability exports,
* SaaS observability exports.

### 12.26.3 Hosted Observability Stack Options

Possible future components:

```text
OpenTelemetry Collector
Prometheus
Grafana
Loki
Tempo
Jaeger
ClickHouse
Postgres
cloud-native observability services
SaaS observability providers
```

No single stack should be baked into the core product too early.

### 12.26.4 Hosted Dashboards

Future dashboards may show:

* repository fleet health,
* policy compliance,
* stale documentation,
* ADR status,
* work-packet status,
* release readiness,
* graph drift,
* context export activity,
* AI-assisted workflow status,
* waiver status,
* incident history,
* operational trends.

### 12.26.5 Hosted Audit Logs

Audit logs should record important hosted actions:

* user login,
* repository connected,
* report uploaded,
* policy changed,
* waiver created,
* waiver approved,
* plan uploaded,
* plan approved,
* release gate changed,
* AI context exported,
* integration configured,
* token created,
* token revoked.

Audit logs should be immutable or tamper-evident where possible in enterprise deployments.

---

## 12.27 Operations for AI-Assisted Features

AI features are optional and future-facing, but their operations requirements must be strict.

AI observability should disclose:

* whether AI was used,
* which provider was used,
* which model was used,
* what context was included,
* what files were excluded,
* whether network calls occurred,
* whether output was advisory or actionable,
* whether a human approved the result,
* whether a plan was generated,
* whether a plan was applied.

AI should never silently influence deterministic checks.

### 12.27.1 AI Output Classification

AI outputs should be classified as:

```text
advisory
draft
plan candidate
review comment
explanation
unsafe/rejected
```

AI output should not be treated as authoritative without deterministic validation and human review.

### 12.27.2 AI Incident Categories

Potential AI-related incidents:

* sensitive context sent to provider unexpectedly,
* AI-generated plan omitted risky mutation,
* AI output presented as deterministic truth,
* provider outage blocked optional workflow,
* hallucinated remediation accepted into docs,
* prompt/context version mismatch caused bad output.

These must be handled as operational risks.

---

## 12.28 Operational Maturity Roadmap

Monad’s operational maturity should evolve in stages.

### 12.28.1 Stage 1: Local Diagnostics

Capabilities:

* `monad doctor`,
* structured findings,
* useful errors,
* remediation hints,
* debug flags,
* trace flags,
* stable exit codes,
* CI-safe mode.

Goal:

```text
Users can understand why Monad succeeded, warned, or failed.
```

### 12.28.2 Stage 2: Reports

Capabilities:

* inspection reports,
* doctor reports,
* check reports,
* docs reports,
* graph reports,
* policy reports,
* context reports,
* JSON output,
* Markdown output where useful,
* report metadata.

Goal:

```text
Monad outputs durable local evidence.
```

### 12.28.3 Stage 3: Plan/Apply Audit

Capabilities:

* plan IDs,
* plan schema,
* dry-run reports,
* apply reports,
* rollback hints,
* mutation summaries,
* pre/post checks.

Goal:

```text
Users can review and audit every planned and applied mutation.
```

### 12.28.4 Stage 4: Team Governance

Capabilities:

* release readiness,
* waiver tracking,
* work-packet status,
* ADR status,
* policy status,
* evidence promotion,
* governance dashboards generated locally or in CI.

Goal:

```text
Teams can operate repositories as governed lifecycle systems.
```

### 12.28.5 Stage 5: Hosted Observability

Capabilities:

* fleet dashboards,
* policy compliance trends,
* graph explorer,
* alerts,
* audit evidence,
* repository sync status,
* team-level reports.

Goal:

```text
Organizations can observe repository lifecycle health across many repositories.
```

### 12.28.6 Stage 6: Enterprise Operations

Capabilities:

* self-hosted deployment,
* enterprise identity,
* audit retention,
* SIEM/GRC integrations,
* incident workflows,
* data residency controls,
* air-gapped support where feasible.

Goal:

```text
Enterprises can operate Monad in regulated, private, and high-governance environments.
```

---

## 12.29 Operational Risks

### 12.29.1 Noisy Output Risk

Risk:

Monad may produce too much output, causing users to ignore important findings.

Mitigation:

* concise defaults,
* severity filtering,
* summaries,
* detailed output only when requested,
* report files for full detail.

### 12.29.2 Unstable JSON Contract Risk

Risk:

Automation breaks because structured output changes unexpectedly.

Mitigation:

* schema versions,
* contract tests,
* release notes,
* deprecation windows.

### 12.29.3 Poor Error Remediation Risk

Risk:

Users see errors but do not know what to do.

Mitigation:

* remediation hints,
* runbooks,
* docs links,
* diagnostic commands,
* finding IDs.

### 12.29.4 Hidden Mutation Risk

Risk:

A command writes files unexpectedly.

Mitigation:

* read-only command tests,
* plan-backed mutation,
* explicit apply,
* apply reports,
* filesystem mutation guards.

### 12.29.5 Secret Leakage Risk

Risk:

Logs, reports, context packs, or diagnostics include secrets.

Mitigation:

* redaction,
* denylisted paths,
* secret scanning,
* context manifests,
* explicit export reports,
* safe diagnostic bundle defaults.

### 12.29.6 Telemetry Trust Risk

Risk:

Users lose trust if Monad sends data unexpectedly.

Mitigation:

* no telemetry by default,
* explicit opt-in,
* visible settings,
* network transparency,
* offline mode.

### 12.29.7 Hosted Overreach Risk

Risk:

Hosted dashboards and alerts become the focus before local CLI observability is mature.

Mitigation:

* local reports first,
* hosted aggregation later,
* no hosted dependency for core workflows.

### 12.29.8 Incident Process Immaturity Risk

Risk:

Safety or release defects are handled informally.

Mitigation:

* incident categories,
* severity levels,
* advisories,
* postmortems,
* regression tests,
* risk register updates.

---

## 12.30 Observability and Operations Fitness Functions

Recommended fitness functions:

1. **Every blocking error has a useful message**

   Errors should explain what failed and provide remediation when possible.

2. **Findings are structured**

   Check-like commands should emit normalized findings.

3. **Findings have stable IDs**

   Finding IDs should be suitable for docs, runbooks, tests, and future automation.

4. **JSON output is schema-versioned**

   Machine-readable output should include schema version metadata.

5. **CI mode is non-interactive**

   `--ci` commands should not prompt.

6. **CI mode exits correctly**

   Blocking findings should produce nonzero exit codes.

7. **Read-only commands do not mutate canonical files**

   Commands such as inspect, check, doctor, graph, and docs check should not modify source-of-truth files.

8. **Debug output is opt-in**

   Default output should not include debug or trace logs.

9. **Trace output is opt-in**

   Detailed execution tracing should require explicit activation.

10. **No telemetry by default**

Core local commands should not send remote telemetry.

11. **Reports are reproducible**

Given the same repository and configuration, reports should be stable except for explicitly variable metadata.

12. **Secrets are redacted**

Known sensitive values should not appear in logs, reports, or diagnostics.

13. **Native tool failures are normalized**

Optional missing tools should produce findings, not uncontrolled crashes.

14. **Plans disclose effects**

Plan files should list intended changes before apply.

15. **Applies produce evidence**

Apply operations should produce apply reports.

16. **Runbooks exist for known failures**

Common operational problems should have documented remediation.

17. **Incidents create regression tests**

Safety or correctness incidents should result in tests that prevent recurrence.

18. **Hosted observability remains optional**

Local CLI correctness must not require hosted dashboards, metrics, or telemetry.

---

## 12.31 Recommended Initial Implementation Order

The recommended implementation order is:

1. Define the core finding model.
2. Define severity levels and finding categories.
3. Define stable error codes and exit codes.
4. Add remediation hints to command errors.
5. Ensure command catalog contract tests remain comprehensive.
6. Add `monad doctor` diagnostics.
7. Add `--format json` for check-like commands.
8. Add report output support.
9. Add `--ci` behavior for non-interactive checks.
10. Add debug and trace flags.
11. Add read-only command mutation tests.
12. Add context export safety reporting.
13. Add plan report schema before apply exists.
14. Add apply report schema before apply becomes powerful.
15. Add runbooks for known operational failures.
16. Add release readiness reporting.
17. Add incident response documentation.
18. Add release artifact checksums.
19. Add SBOM/signing/provenance later.
20. Add hosted observability only after local reports and evidence are mature.

---

## 12.32 Early Non-Goals

Early Monad does not need:

* remote telemetry,
* hosted dashboards,
* hosted metrics,
* distributed tracing,
* alerting system,
* PagerDuty integration,
* Slack alerts,
* OpenTelemetry collector,
* Prometheus,
* Grafana,
* Loki,
* Tempo,
* SIEM integration,
* GRC integration,
* centralized audit log service,
* fleet health dashboard,
* always-on daemon,
* background agent,
* auto-uploaded diagnostics,
* remote crash reporting,
* AI usage analytics,
* enterprise incident console.

These may become relevant later, but they are not required for the first serious local CLI.

---

## 12.33 Open Questions

The following questions should remain open until implementation pressure justifies decisions.

1. What exact exit code taxonomy should Monad guarantee?

2. Which commands must support JSON output in v0?

3. Should all findings use a single global ID namespace?

4. Should finding IDs be documented in a dedicated catalog?

5. Should report schemas be published under `schemas/`?

6. Should `monad doctor` be purely diagnostic, or should it optionally suggest plans?

7. Should `--ci` imply JSON output, or only non-interactive strictness?

8. Should warning severity fail CI by default or only when configured?

9. What default report paths should Monad use?

10. Should report timestamps be optional for deterministic output?

11. Should diagnostic bundles be implemented before hosted support exists?

12. How aggressive should secret redaction be in local reports?

13. Should Monad maintain a local command history under `.monad/`?

14. Should plan/apply reports be committed as governance evidence?

15. What is the first hosted observability feature that justifies a backend?

16. Should future hosted audit logs be append-only, tamper-evident, or externally exportable?

17. Which operational events belong in the risk register?

18. How should incident advisories be published for a CLI tool?

---

## 12.34 Section Acceptance Criteria

This section is successful if a reader understands that:

1. Observability for early Monad means clear local command behavior, not hosted telemetry.
2. Monad should explain what it did, what it found, what failed, and how to remediate issues.
3. Findings should be structured, stable, categorized, and actionable.
4. Errors and findings are related but distinct.
5. CI needs stable output, non-interactive behavior, and meaningful exit codes.
6. `monad doctor` is the primary local diagnostic command.
7. `monad check --ci` is the primary CI readiness pattern.
8. Logs, debug output, and trace output should be opt-in.
9. Machine-readable outputs should be schema-versioned.
10. Reports are local evidence artifacts.
11. Plan-backed mutation requires plan observability before apply.
12. Apply operations require apply reports.
13. Context export must produce safety and inclusion/exclusion evidence.
14. Native tool invocation must be visible and normalized.
15. Secrets must be redacted from logs, reports, and diagnostics.
16. Telemetry must not be enabled by default.
17. Hosted observability is future optional infrastructure.
18. Operations include release safety, runbooks, incident response, advisories, and postmortems.
19. Local CLI reliability and trust are the first operational goals.
20. The operations model reinforces Monad’s core doctrine: local-first, deterministic, governance-grade, AI-optional, native-tool-coordinating, plan-backed, and lifecycle-graph-centered.

The final operational rule is:

> Monad should be observable enough that users can trust what it inspected, what it concluded, what it planned, what it changed, and what evidence remains afterward — without requiring a hosted service or sending data anywhere by default.
