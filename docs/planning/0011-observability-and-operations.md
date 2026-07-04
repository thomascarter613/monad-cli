# 12. Observability and Operations

## 12.1 Observability Summary

For a local CLI, observability means:

* clear terminal output,
* structured JSON output,
* useful error messages,
* debug mode,
* trace mode,
* diagnostic reports,
* reproducible findings,
* CI-friendly exit codes.

For future hosted control plane, observability expands to logs, metrics, traces, dashboards, SLOs, and incident response.

## 12.2 Observability Principles

1. Every command should explain what it did.
2. Every failure should include a useful remediation hint.
3. Every check should produce structured findings.
4. Every plan should list intended effects.
5. Every apply should produce an apply report.
6. Debug output should be opt-in.
7. Machine-readable outputs should be stable.
8. Future hosted telemetry must be opt-in.

## 12.3 Logging Strategy

Local CLI log levels:

```text id="az2wvs"
error
warn
info
debug
trace
```

Potential flags:

```bash id="ho387s"
--verbose
--quiet
--debug
--trace
--log-format text
--log-format json
```

Default output should not be noisy.

## 12.4 Findings Model

Many commands should normalize output into findings.

Recommended model:

```rust id="njixfe"
pub enum Severity {
    Info,
    Warning,
    Error,
    Critical,
}

pub struct Finding {
    pub id: String,
    pub severity: Severity,
    pub title: String,
    pub message: String,
    pub path: Option<PathBuf>,
    pub remediation: Option<String>,
    pub policy_id: Option<String>,
}
```

## 12.5 Health Checks

For a CLI, health checks become diagnostics.

Command:

```bash id="4p2v59"
monad doctor
```

Should check:

* workspace root,
* manifest presence,
* canonical source-of-truth consistency,
* command catalog integrity,
* expected docs presence,
* native tool availability,
* known config problems,
* policy configuration,
* context output path,
* Git repository status.

## 12.6 Readiness Checks

For CI:

```bash id="lbzdhk"
monad check --ci
```

Should exit nonzero on blocking issues.

## 12.7 SLOs for Local CLI

Potential product-level SLOs:

| Area                     | Target                                            |
| ------------------------ | ------------------------------------------------- |
| Command catalog contract | 100% tested                                       |
| Read-only command safety | No file mutations                                 |
| Plan visibility          | 100% of file ops listed before apply              |
| Secret redaction         | No known secret file patterns included by default |
| Schema compatibility     | No unversioned output schemas                     |
| CI reliability           | Main branch remains green                         |

## 12.8 Metrics

Local CLI metrics are not sent anywhere by default.

Possible local metrics:

* command duration,
* files scanned,
* findings count,
* graph nodes/edges count,
* plan steps count,
* policy evaluation count.

Future hosted metrics:

* active repos,
* policy pass/fail rate,
* stale docs count,
* unreviewed ADRs,
* open waivers,
* release readiness,
* AI context exports,
* plan apply success/failure.

## 12.9 Alerting

Early local CLI:

* no alerting required.

Future hosted:

* policy drift alerts,
* stale docs alerts,
* failed check alerts,
* risky plan alerts,
* expired waiver alerts,
* release gate alerts,
* sync failure alerts.

## 12.10 Runbooks

Initial runbooks:

```text id="f6tkfs"
docs/operations/runbooks/workspace-not-detected.md
docs/operations/runbooks/manifest-conflict.md
docs/operations/runbooks/command-catalog-mismatch.md
docs/operations/runbooks/docs-check-failed.md
docs/operations/runbooks/context-export-safety.md
docs/operations/runbooks/plan-apply-failed.md
```

## 12.11 Incident Response

For local CLI, incidents are mostly release defects or unsafe behavior.

Incident categories:

* destructive mutation bug,
* secret leakage bug,
* incorrect policy pass,
* incompatible schema release,
* broken command contract,
* malicious dependency,
* compromised release artifact.

Incident response should include:

1. freeze release,
2. publish advisory,
3. patch,
4. add regression test,
5. update risk register,
6. document postmortem,
7. improve safety control.

## 12.12 Operational Maturity Roadmap

### Stage 1: Local Diagnostics

* `monad doctor`
* structured findings
* debug flags
* CI exit codes

### Stage 2: Reports

* inspection reports,
* docs reports,
* graph reports,
* policy reports,
* context reports.

### Stage 3: Plan/Apply Audit

* plan IDs,
* dry-run reports,
* apply reports,
* rollback hints.

### Stage 4: Team Governance

* release readiness,
* waiver tracking,
* work packet status,
* ADR status.

### Stage 5: Hosted Observability

* fleet dashboards,
* policy compliance trends,
* graph explorer,
* alerts,
* audit evidence.
