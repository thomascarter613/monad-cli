# 14. BDD Specification Set

## 14.1 Purpose of This Section

This section defines the behavior-driven development specification set for Monad OS and Monad CLI.

Its purpose is to translate Monad’s product doctrine, architecture strategy, domain model, testing strategy, and CLI contract into user-visible behavioral scenarios.

The BDD specification set should answer:

* what users can expect Monad to do,
* what Monad must never do silently,
* how local-first behavior is proven,
* how read-only command safety is proven,
* how canonical source-of-truth rules are proven,
* how command catalog integrity is proven,
* how graph, docs, context, policy, and lifecycle workflows behave,
* how plan-backed mutation works,
* how unsafe mutation is blocked,
* how native tools are coordinated,
* how AI remains optional,
* and how future work packets can be validated against product-level behavior.

BDD scenarios are not merely examples. They are executable product promises.

Each scenario should eventually map to one or more of:

* fixture integration tests,
* CLI smoke tests,
* command contract tests,
* schema tests,
* snapshot/golden tests,
* mutation safety tests,
* security/privacy tests,
* or future AI evaluation tests.

The BDD specification set should remain readable by humans while being specific enough to guide implementation.

---

## 14.2 BDD Specification Principles

Monad’s BDD scenarios should follow these principles.

### 14.2.1 Describe User-Visible Behavior

Scenarios should describe what a user observes, not internal implementation details.

Good:

```gherkin id="0u3qrq"
Then Monad reports that "monad.toml" is canonical
```

Less useful:

```gherkin id="dfu7mp"
Then the ManifestResolver returns CanonicalManifest::MonadToml
```

The implementation may use a `ManifestResolver`, but the behavior that matters to users is that Monad treats `monad.toml` as canonical and explains conflicts clearly.

### 14.2.2 Encode Product Doctrine

BDD scenarios should protect Monad’s core doctrine:

* local-first before hosted,
* deterministic before AI,
* read-only before mutation,
* plan-backed before mutation,
* no network by default,
* no telemetry by default,
* `monad.toml` canonical,
* `workspace.toml` compatibility mirror only,
* `monad.lock` records resolved state,
* `.monad/` stores local/generated/cache state,
* native tools are coordinated, not replaced,
* AI is optional,
* lifecycle graph is the long-term moat.

### 14.2.3 Prefer Concrete Commands

BDD scenarios should use actual CLI commands whenever possible.

Good:

```gherkin id="s51edu"
When the user runs "monad doctor"
```

Avoid vague phrasing unless the command does not exist yet.

Less useful:

```gherkin id="gptc4v"
When the user asks Monad to diagnose the repository
```

### 14.2.4 Distinguish Implemented, Planned, and Future Behavior

The BDD set may include scenarios for planned behavior, but each scenario should be categorized by maturity.

Recommended maturity labels:

```text id="z98jmx"
V0 Core
V1 Core
Future
Hosted Future
AI Future
```

This prevents planned behavior from being mistaken for implemented behavior.

### 14.2.5 Keep Mutation Scenarios Strict

Any scenario involving file creation, modification, deletion, command delegation, network access, AI assistance, or apply behavior must include safety expectations.

Examples:

* no files are modified during dry-run,
* apply changes only planned files,
* unsafe mutation is refused,
* AI suggestions become reviewable plans,
* native tools are reported when delegated,
* network is not used by default.

### 14.2.6 Scenarios Should Map to Fixtures

Most repository-facing scenarios should identify a fixture repository.

Example:

```text id="7j2bjq"
fixtures/minimal-monad-repo
fixtures/manifest-conflict-repo
fixtures/context-secret-risk-repo
fixtures/docs-missing-repo
fixtures/policy-violation-repo
```

This makes the BDD set testable.

---

## 14.3 BDD Scenario Metadata Model

Each scenario should eventually be trackable with metadata.

Recommended metadata fields:

```text id="xar7ju"
id
feature
scenario
maturity
priority
bounded_contexts
fixture
command
expected_exit_code
expected_findings
expected_outputs
mutation_allowed
network_allowed
ai_required
schemas
related_work_packets
related_tests
```

Example:

```yaml id="7n3frf"
id: BDD-MANIFEST-002
feature: Canonical manifest resolution
scenario: workspace.toml conflicts with monad.toml
maturity: V0 Core
priority: P0
bounded_contexts:
  - Workspace
  - Command
  - Inspection
fixture: fixtures/manifest-conflict-repo
command: monad check
expected_exit_code: 0-or-1-configurable
expected_findings:
  - MANIFEST-CANONICAL-CONFLICT
mutation_allowed: false
network_allowed: false
ai_required: false
related_tests:
  - manifest_conflict_reports_canonical_source_of_truth_warning
```

This metadata does not need to be implemented immediately, but the BDD specification should be compatible with it.

---

## 14.4 Feature: Version Reporting

### 14.4.1 Scenario: User Checks the Monad Version

```gherkin id="xm3lra"
Feature: Version reporting

  Scenario: User checks the Monad version
    Given the Monad CLI is installed
    When the user runs "monad version"
    Then the command exits successfully
    And the output includes the current Monad version
    And the output does not require a repository
    And the output does not require network access
    And the output does not require AI configuration
```

**Maturity:** V0 Core
**Priority:** P0
**Primary bounded contexts:** Command
**Mutation allowed:** No
**Network allowed:** No
**AI required:** No

**Acceptance notes:**

`monad version` must be safe to run anywhere. It should not require a workspace root, manifest, Git repository, cloud account, hosted service, or AI provider.

---

## 14.5 Feature: Command Catalog Visibility

### 14.5.1 Scenario: User Lists Known Commands

```gherkin id="wmbjyc"
Feature: Command catalog visibility

  Scenario: User lists known commands
    Given the Monad CLI is installed
    When the user runs "monad list"
    Then the command exits successfully
    And the output includes implemented commands
    And the output includes planned commands
    And planned commands are clearly marked as not fully implemented
    And each command includes a category when available
    And mutating commands are distinguishable from read-only commands
```

**Maturity:** V0 Core
**Priority:** P0
**Primary bounded contexts:** Command
**Mutation allowed:** No
**Network allowed:** No
**AI required:** No

**Acceptance notes:**

The command list should help users understand what Monad can do now and what is planned. It must not pretend planned commands are complete.

### 14.5.2 Scenario: Command List Is Honest About Placeholder Commands

```gherkin id="r4nppo"
Feature: Command catalog visibility

  Scenario: Command list is honest about placeholder commands
    Given the command catalog contains planned commands
    When the user runs "monad list"
    Then planned commands are labeled as planned or not yet implemented
    And implemented commands are distinguishable from placeholder commands
    And placeholder commands do not appear as completed capabilities
```

**Maturity:** V0 Core
**Priority:** P0
**Primary bounded contexts:** Command
**Mutation allowed:** No

---

## 14.6 Feature: Command Catalog Contract

### 14.6.1 Scenario: CLI Surface Matches Command Catalog

```gherkin id="g2pvo2"
Feature: Command catalog contract

  Scenario: CLI surface matches command catalog
    Given the command catalog contains a command named "config list"
    When the command catalog contract test runs
    Then the Clap command tree exposes "config list"
```

**Maturity:** V0 Core
**Priority:** P0
**Primary bounded contexts:** Command
**Test type:** Command contract test

### 14.6.2 Scenario: Catalog Does Not Claim Unknown Commands

```gherkin id="tdf78j"
Feature: Command catalog contract

  Scenario: Catalog does not claim unknown commands
    Given the command catalog contains example commands
    When the command catalog contract test runs
    Then every example command resolves to a known catalog command
    And every implemented example command is exposed by the CLI
```

**Maturity:** V0 Core
**Priority:** P0
**Primary bounded contexts:** Command

### 14.6.3 Scenario: Mutating Commands Declare Mutation Behavior

```gherkin id="g6vbi7"
Feature: Command catalog contract

  Scenario: Mutating commands declare mutation behavior
    Given the command catalog contains a mutating command
    When the command catalog contract test runs
    Then the command declares whether it plans mutation, applies mutation, or writes generated artifacts
    And the command declares whether approval is required
```

**Maturity:** V1 Core
**Priority:** P0
**Primary bounded contexts:** Command, Plan

---

## 14.7 Feature: Canonical Manifest Resolution

### 14.7.1 Scenario: `monad.toml` Exists

```gherkin id="xojj2r"
Feature: Canonical manifest resolution

  Scenario: monad.toml exists
    Given a repository contains "monad.toml"
    When the user runs "monad config inspect"
    Then Monad treats "monad.toml" as the canonical manifest
    And Monad reports the canonical manifest path
    And Monad does not require "workspace.toml"
```

**Maturity:** V0 Core
**Priority:** P0
**Primary bounded contexts:** Workspace, Command
**Fixture:** `fixtures/minimal-monad-repo`
**Mutation allowed:** No

### 14.7.2 Scenario: `workspace.toml` Exists Without `monad.toml`

```gherkin id="xyd6yz"
Feature: Canonical manifest resolution

  Scenario: workspace.toml exists without monad.toml
    Given a repository contains "workspace.toml"
    And the repository does not contain "monad.toml"
    When the user runs "monad config inspect"
    Then Monad reports that the canonical manifest is missing
    And Monad explains that "workspace.toml" is a compatibility mirror only
    And Monad suggests creating "monad.toml"
```

**Maturity:** V0 Core
**Priority:** P0
**Primary bounded contexts:** Workspace
**Fixture:** `fixtures/workspace-mirror-only-repo`

### 14.7.3 Scenario: Compatibility Mirror Conflicts with Canonical Manifest

```gherkin id="mgj1e0"
Feature: Compatibility mirror handling

  Scenario: workspace.toml conflicts with monad.toml
    Given a repository contains "monad.toml"
    And the repository contains "workspace.toml"
    And the two files disagree
    When the user runs "monad check"
    Then Monad reports a source-of-truth warning or error
    And Monad states that "monad.toml" is canonical
    And Monad does not rewrite either file
```

**Maturity:** V0 Core
**Priority:** P0
**Primary bounded contexts:** Workspace, Inspection
**Fixture:** `fixtures/manifest-conflict-repo`
**Mutation allowed:** No

---

## 14.8 Feature: Repository Inspection

### 14.8.1 Scenario: User Inspects a Valid Monad Workspace

```gherkin id="metuhg"
Feature: Repository inspection

  Scenario: User inspects a valid Monad workspace
    Given a valid Monad workspace
    When the user runs "monad inspect"
    Then Monad reports the workspace name
    And Monad reports known project areas
    And Monad reports detected native tool manifests
    And Monad reports the canonical manifest path
    And Monad does not modify any files
```

**Maturity:** V0 Core
**Priority:** P0
**Primary bounded contexts:** Workspace, Inspection, Native Tool Coordination
**Fixture:** `fixtures/valid-monad-repo`
**Mutation allowed:** No

### 14.8.2 Scenario: Inspect Command Is Read-Only

```gherkin id="s1xtkf"
Feature: Repository inspection safety

  Scenario: Inspect command is read-only
    Given a repository with tracked files
    When the user runs "monad inspect"
    Then no files are created
    And no files are modified
    And no files are deleted
```

**Maturity:** V0 Core
**Priority:** P0
**Primary bounded contexts:** Inspection, Command
**Test type:** Read-only mutation safety test

### 14.8.3 Scenario: Inspect Handles Missing Manifest Honestly

```gherkin id="0dp2ck"
Feature: Repository inspection

  Scenario: Inspect handles missing manifest honestly
    Given a repository without "monad.toml"
    When the user runs "monad inspect"
    Then Monad reports that no canonical manifest was detected
    And Monad does not invent workspace metadata
    And Monad suggests initializing or adding "monad.toml"
```

**Maturity:** V0 Core
**Priority:** P0
**Fixture:** `fixtures/empty-repo`

---

## 14.9 Feature: Repository Validation

### 14.9.1 Scenario: Valid Repository Passes Baseline Checks

```gherkin id="kz0a1v"
Feature: Repository validation

  Scenario: Valid repository passes baseline checks
    Given a repository that satisfies Monad baseline invariants
    When the user runs "monad check"
    Then the command exits successfully
    And the output reports no blocking findings
    And the output includes a summary of checks performed
```

**Maturity:** V0 Core
**Priority:** P0
**Primary bounded contexts:** Workspace, Inspection, Governance
**Fixture:** `fixtures/valid-monad-repo`

### 14.9.2 Scenario: Missing Canonical Manifest Is Reported

```gherkin id="z94bhe"
Feature: Repository validation

  Scenario: Missing canonical manifest is reported
    Given a repository without "monad.toml"
    When the user runs "monad check"
    Then Monad reports a configuration finding
    And the output suggests creating or initializing a canonical manifest
    And Monad does not create the manifest automatically
```

**Maturity:** V0 Core
**Priority:** P0
**Fixture:** `fixtures/empty-repo`
**Mutation allowed:** No

### 14.9.3 Scenario: Check Emits Structured Findings

```gherkin id="2upc2v"
Feature: Repository validation

  Scenario: Check emits structured findings
    Given a repository with a known validation issue
    When the user runs "monad check --format json"
    Then Monad emits valid JSON
    And the JSON contains a schema version
    And the JSON contains a findings array
    And each finding has a stable id, severity, title, and message
```

**Maturity:** V1 Core
**Priority:** P0
**Primary bounded contexts:** Inspection, Observability
**Test type:** Schema test

---

## 14.10 Feature: Doctor Diagnostics

### 14.10.1 Scenario: Doctor Explains Actionable Problems

```gherkin id="1j0rsx"
Feature: Repository diagnostics

  Scenario: Doctor explains actionable problems
    Given a repository with missing docs and a manifest conflict
    When the user runs "monad doctor"
    Then Monad reports each issue
    And each issue includes a remediation hint
    And Monad distinguishes blocking issues from warnings
```

**Maturity:** V0 Core
**Priority:** P0
**Primary bounded contexts:** Workspace, Docs, Observability
**Fixture:** `fixtures/doctor-problem-repo`

### 14.10.2 Scenario: Doctor Reports Native Tool Availability

```gherkin id="lv4nvv"
Feature: Repository diagnostics

  Scenario: Doctor reports native tool availability
    Given a repository with Rust workspace metadata
    When the user runs "monad doctor"
    Then Monad reports whether Git is available
    And Monad reports whether Cargo is available
    And missing optional tools are reported as warnings
    And missing optional tools do not crash the command
```

**Maturity:** V0 Core
**Priority:** P1
**Primary bounded contexts:** Native Tool Coordination, Observability

---

## 14.11 Feature: Lifecycle Graph Generation

### 14.11.1 Scenario: User Generates a Text Graph

```gherkin id="aumgdi"
Feature: Lifecycle graph generation

  Scenario: User generates a text graph
    Given a valid Monad workspace with projects and docs
    When the user runs "monad graph --format text"
    Then Monad emits a graph representation
    And the graph includes workspace nodes
    And the graph includes project nodes
    And the graph output is deterministic
```

**Maturity:** V0 Core
**Priority:** P0
**Primary bounded contexts:** Graph, Workspace
**Fixture:** `fixtures/valid-monad-repo`

### 14.11.2 Scenario: User Generates a Mermaid Graph

```gherkin id="x2bg51"
Feature: Mermaid graph generation

  Scenario: User generates a Mermaid graph
    Given a valid Monad workspace
    When the user runs "monad graph --format mermaid"
    Then Monad emits valid Mermaid syntax
    And the graph contains no edges referencing missing nodes
```

**Maturity:** V0/V1 Core
**Priority:** P1
**Primary bounded contexts:** Graph
**Test type:** Snapshot and graph invariant test

### 14.11.3 Scenario: User Generates a JSON Graph

```gherkin id="09by87"
Feature: JSON graph generation

  Scenario: User generates a JSON graph
    Given a valid Monad workspace
    When the user runs "monad graph --format json"
    Then Monad emits valid JSON
    And the JSON includes a schema version
    And every edge references existing nodes
```

**Maturity:** V1 Core
**Priority:** P0
**Primary bounded contexts:** Graph, Observability
**Test type:** Schema and invariant test

---

## 14.12 Feature: Context Handoff Generation

### 14.12.1 Scenario: User Creates a Deterministic Handoff

```gherkin id="z8fmou"
Feature: Context handoff generation

  Scenario: User creates a deterministic handoff
    Given a valid Monad workspace
    When the user runs "monad context handoff"
    Then Monad emits a Markdown handoff
    And the handoff includes workspace identity
    And the handoff includes current command surface
    And the handoff includes known risks or missing data
    And the handoff does not require AI configuration
```

**Maturity:** V0 Core
**Priority:** P0
**Primary bounded contexts:** Context/Handoff, Command, Governance
**Fixture:** `fixtures/valid-monad-repo`
**AI required:** No

### 14.12.2 Scenario: Context Handoff Excludes Secrets

```gherkin id="rywys9"
Feature: Context safety

  Scenario: Context handoff excludes secrets
    Given a repository contains ".env"
    And the repository contains "id_rsa"
    When the user runs "monad context handoff"
    Then the output does not include secret file contents
    And Monad reports that sensitive files were excluded
    And Monad emits a context safety finding
```

**Maturity:** V0/V1 Core
**Priority:** P0
**Primary bounded contexts:** Context/Handoff, Security, Privacy
**Fixture:** `fixtures/context-secret-risk-repo`
**Mutation allowed:** No
**Network allowed:** No

### 14.12.3 Scenario: Context Handoff Does Not Use Network by Default

```gherkin id="gngh02"
Feature: Context safety

  Scenario: Context handoff does not use network by default
    Given a valid Monad workspace
    And no hosted control plane is configured
    And no AI provider is configured
    When the user runs "monad context handoff"
    Then Monad generates local output only
    And Monad does not call any external service
```

**Maturity:** V0 Core
**Priority:** P0
**Primary bounded contexts:** Context/Handoff, Security
**Network allowed:** No
**AI required:** No

---

## 14.13 Feature: Documentation Validation

### 14.13.1 Scenario: Missing Architecture Docs Are Reported

```gherkin id="fuqs6j"
Feature: Documentation validation

  Scenario: Missing architecture docs are reported
    Given a Monad workspace without architecture overview documentation
    When the user runs "monad docs check"
    Then Monad reports a documentation finding
    And the finding includes the expected documentation path
    And the finding includes a remediation hint
```

**Maturity:** V0/V1 Core
**Priority:** P1
**Primary bounded contexts:** Docs, Governance
**Fixture:** `fixtures/docs-missing-repo`

### 14.13.2 Scenario: Valid Documentation Passes Documentation Check

```gherkin id="g4ku6z"
Feature: Documentation validation

  Scenario: Valid documentation passes documentation check
    Given a Monad workspace with required documentation
    When the user runs "monad docs check"
    Then the command exits successfully
    And the output reports no blocking documentation findings
```

**Maturity:** V0/V1 Core
**Priority:** P1
**Primary bounded contexts:** Docs
**Fixture:** `fixtures/docs-valid-repo`

---

## 14.14 Feature: ADR Lifecycle

### 14.14.1 Scenario: User Lists ADRs

```gherkin id="kf73sw"
Feature: ADR listing

  Scenario: User lists ADRs
    Given a workspace with ADR files
    When the user runs "monad adr list"
    Then Monad lists known ADRs
    And each ADR includes status when available
    And invalid ADR metadata is reported as a finding
```

**Maturity:** V1 Core
**Priority:** P1
**Primary bounded contexts:** Governance, Docs
**Fixture:** `fixtures/adr-valid-repo`

### 14.14.2 Scenario: ADR Creation Previews Before Mutation

```gherkin id="i39qs3"
Feature: ADR creation safety

  Scenario: ADR creation previews before mutation
    Given a valid Monad workspace
    When the user runs "monad adr new --dry-run"
    Then Monad shows the ADR file that would be created
    And no file is written
    And Monad explains how to generate a reviewable plan
```

**Maturity:** V1 Core
**Priority:** P0
**Primary bounded contexts:** Governance, Plan
**Mutation allowed:** No

### 14.14.3 Scenario: ADR Creation Requires Plan or Approval

```gherkin id="zj87qo"
Feature: ADR creation safety

  Scenario: ADR creation requires plan or approval
    Given a valid Monad workspace
    When the user runs "monad adr new"
    Then Monad refuses direct mutation or creates a reviewable plan according to configuration
    And Monad does not silently write files without plan visibility
```

**Maturity:** V1 Core
**Priority:** P0
**Primary bounded contexts:** Governance, Plan, Command

---

## 14.15 Feature: Work Packet Lifecycle

### 14.15.1 Scenario: User Lists Work Packets

```gherkin id="uq8qre"
Feature: Work packet listing

  Scenario: User lists work packets
    Given a workspace with work packet documentation
    When the user runs "monad workpacket list"
    Then Monad lists known work packets
    And each work packet includes status when available
    And invalid work packet metadata is reported as a finding
```

**Maturity:** V1 Core
**Priority:** P1
**Primary bounded contexts:** Governance, Work Packet
**Fixture:** `fixtures/workpacket-valid-repo`

### 14.15.2 Scenario: User Plans Work Packet Implementation

```gherkin id="oylwd1"
Feature: Work packet planning

  Scenario: User plans work packet implementation
    Given a valid work packet
    When the user runs "monad workpacket plan"
    Then Monad emits ordered layers
    And each layer includes acceptance criteria
    And no repository files are modified
```

**Maturity:** V1/Future
**Priority:** P1
**Primary bounded contexts:** Work Packet, Plan
**Mutation allowed:** No

### 14.15.3 Scenario: Invalid Work Packet Is Reported

```gherkin id="n2hojw"
Feature: Work packet validation

  Scenario: Invalid work packet is reported
    Given a workspace with a work packet missing acceptance criteria
    When the user runs "monad workpacket check"
    Then Monad reports a work-packet finding
    And the finding explains what metadata is missing
```

**Maturity:** V1 Core
**Priority:** P1
**Fixture:** `fixtures/workpacket-invalid-repo`

---

## 14.16 Feature: Policy Evaluation

### 14.16.1 Scenario: Policy Violation Is Reported

```gherkin id="dj107n"
Feature: Policy evaluation

  Scenario: Policy violation is reported
    Given a workspace with a policy requiring docs/index.md
    And docs/index.md is missing
    When the user runs "monad policy check"
    Then Monad reports a policy finding
    And the command exits with a validation failure code
    And the finding includes a stable policy id
```

**Maturity:** V1 Core
**Priority:** P0
**Primary bounded contexts:** Policy, Governance, Observability
**Fixture:** `fixtures/policy-violation-repo`

### 14.16.2 Scenario: User Asks Why a Policy Failed

```gherkin id="vqw3y9"
Feature: Policy explanation

  Scenario: User asks why a policy failed
    Given a policy finding exists
    When the user runs "monad policy explain <policy-id>"
    Then Monad explains the policy
    And Monad explains the remediation
    And Monad identifies related repository paths when available
```

**Maturity:** V1 Core
**Priority:** P1
**Primary bounded contexts:** Policy

### 14.16.3 Scenario: Expired Waiver Does Not Suppress Policy Failure

```gherkin id="pzq0i0"
Feature: Policy waivers

  Scenario: Expired waiver does not suppress policy failure
    Given a workspace with a policy violation
    And the violation has an expired waiver
    When the user runs "monad policy check"
    Then Monad reports the original policy violation
    And Monad reports that the waiver is expired
    And the command exits with a validation failure code
```

**Maturity:** V1/Future
**Priority:** P0
**Primary bounded contexts:** Policy, Governance
**Fixture:** `fixtures/policy-waiver-expired-repo`

---

## 14.17 Feature: Change Plan Creation

### 14.17.1 Scenario: User Creates an Add-App Plan

```gherkin id="pdo1na"
Feature: Change planning

  Scenario: User creates an add-app plan
    Given a valid Monad workspace
    When the user runs "monad plan add app web"
    Then Monad emits a plan
    And the plan lists files to create
    And the plan lists commands to run
    And the plan lists risks
    And the plan includes a schema version
    And no files are modified
```

**Maturity:** V1/Future
**Priority:** P0
**Primary bounded contexts:** Plan, Command, Workspace
**Mutation allowed:** No

### 14.17.2 Scenario: Plan Rejects Path Traversal

```gherkin id="zwuk9f"
Feature: Change planning safety

  Scenario: Plan rejects path traversal
    Given a generated plan attempts to write outside the workspace root
    When the user runs "monad plan validate plan.json"
    Then Monad rejects the plan
    And Monad reports a safety finding
    And no files are modified
```

**Maturity:** V1 Core
**Priority:** P0
**Primary bounded contexts:** Plan, Security
**Mutation allowed:** No

---

## 14.18 Feature: Dry-Run Apply

### 14.18.1 Scenario: User Dry-Runs a Plan

```gherkin id="ni7w19"
Feature: Dry-run apply

  Scenario: User dry-runs a plan
    Given a valid Monad plan
    When the user runs "monad apply plan.json --dry-run"
    Then Monad simulates the plan
    And reports expected file operations
    And no files are modified
    And no files are created
    And no files are deleted
```

**Maturity:** V1 Core
**Priority:** P0
**Primary bounded contexts:** Plan
**Mutation allowed:** No
**Test type:** Mutation safety test

### 14.18.2 Scenario: Dry-Run Reports Policy Blocks

```gherkin id="5xifsm"
Feature: Dry-run apply

  Scenario: Dry-run reports policy blocks
    Given a valid Monad plan
    And the plan violates a configured policy
    When the user runs "monad apply plan.json --dry-run"
    Then Monad reports that the plan is blocked by policy
    And no files are modified
```

**Maturity:** V1/Future
**Priority:** P0
**Primary bounded contexts:** Plan, Policy

---

## 14.19 Feature: Approved Plan Application

### 14.19.1 Scenario: User Applies an Approved Plan

```gherkin id="kzunt7"
Feature: Approved plan application

  Scenario: User applies an approved plan
    Given a valid Monad plan
    And the plan passes policy checks
    When the user runs "monad apply plan.json --yes"
    Then Monad applies only the operations listed in the plan
    And Monad writes an apply result
    And Monad reports verification steps
    And Monad reports every file created, modified, or deleted
```

**Maturity:** V1/Future
**Priority:** P0
**Primary bounded contexts:** Plan, Policy, Observability
**Mutation allowed:** Yes, only planned operations

### 14.19.2 Scenario: Apply Refuses Unapproved Plan

```gherkin id="xstcl1"
Feature: Approved plan application

  Scenario: Apply refuses unapproved plan
    Given a Monad plan requiring approval
    And the plan has not been approved
    When the user runs "monad apply plan.json"
    Then Monad refuses to apply the plan
    And Monad explains how to review, approve, or dry-run the plan
    And no files are modified
```

**Maturity:** V1 Core
**Priority:** P0
**Primary bounded contexts:** Plan
**Mutation allowed:** No

### 14.19.3 Scenario: Failed Apply Reports Partial State

```gherkin id="h9qa37"
Feature: Approved plan application

  Scenario: Failed apply reports partial state
    Given a valid Monad plan with multiple file operations
    And one operation fails
    When the user runs "monad apply plan.json --yes"
    Then Monad reports which operations completed
    And Monad reports which operation failed
    And Monad writes an apply failure report
    And Monad provides rollback or repair hints when possible
```

**Maturity:** V1/Future
**Priority:** P0
**Primary bounded contexts:** Plan, Observability

---

## 14.20 Feature: Unsafe Mutation Blocking

### 14.20.1 Scenario: User Attempts Mutation Without Plan or Approval

```gherkin id="jmin45"
Feature: Unsafe mutation blocking

  Scenario: User attempts mutation without plan or approval
    Given a valid Monad workspace
    When the user runs a mutating command without dry-run, plan, or approval
    Then Monad refuses the operation
    And the output explains how to create a plan or run a dry-run
    And no files are modified
```

**Maturity:** V1 Core
**Priority:** P0
**Primary bounded contexts:** Command, Plan, Security

### 14.20.2 Scenario: File Deletion Requires Explicit Approval

```gherkin id="oknf30"
Feature: Unsafe mutation blocking

  Scenario: File deletion requires explicit approval
    Given a Monad plan includes a file deletion
    When the user runs "monad apply plan.json --yes"
    Then Monad requires explicit deletion approval unless policy allows it
    And Monad identifies the file that would be deleted
    And Monad refuses deletion if approval is missing
```

**Maturity:** V1/Future
**Priority:** P0
**Primary bounded contexts:** Plan, Security

---

## 14.21 Feature: Native Tool Coordination

### 14.21.1 Scenario: Rust Workspace Is Detected

```gherkin id="1qy6k4"
Feature: Native tool detection

  Scenario: Rust workspace is detected
    Given a repository with Cargo.toml workspace configuration
    When the user runs "monad inspect"
    Then Monad reports that Cargo workspace metadata was detected
    And Monad does not replace Cargo behavior
    And Monad does not modify Cargo.toml
```

**Maturity:** V0 Core
**Priority:** P0
**Primary bounded contexts:** Native Tool Coordination, Inspection
**Fixture:** `fixtures/rust-workspace`
**Mutation allowed:** No

### 14.21.2 Scenario: User Runs a Delegated Test Command

```gherkin id="kt6g3w"
Feature: Native tool delegation

  Scenario: User runs a delegated test command
    Given a repository with a known native test command
    When the user runs "monad test"
    Then Monad delegates to the configured native tool
    And reports the native tool result
    And reports the command that was delegated
```

**Maturity:** V1/Future
**Priority:** P1
**Primary bounded contexts:** Native Tool Coordination, Command

### 14.21.3 Scenario: Missing Optional Native Tool Produces Warning

```gherkin id="fmh59a"
Feature: Native tool detection

  Scenario: Missing optional native tool produces warning
    Given a repository configured to use an optional native tool
    And the optional native tool is not installed
    When the user runs "monad doctor"
    Then Monad reports that the tool is unavailable
    And Monad explains which checks were skipped
    And Monad does not crash
```

**Maturity:** V0/V1 Core
**Priority:** P1
**Primary bounded contexts:** Native Tool Coordination, Observability

---

## 14.22 Feature: AI-Optional Behavior

### 14.22.1 Scenario: User Generates Context Without AI Configuration

```gherkin id="nw0zj1"
Feature: AI-optional operation

  Scenario: User generates context without AI configuration
    Given a valid Monad workspace
    And no AI provider is configured
    When the user runs "monad context handoff"
    Then Monad generates deterministic context
    And the command exits successfully
    And no AI provider is called
```

**Maturity:** V0 Core
**Priority:** P0
**Primary bounded contexts:** Context/Handoff, AI
**AI required:** No
**Network allowed:** No

### 14.22.2 Scenario: AI Suggests a Repository Change

```gherkin id="7zsd4e"
Feature: AI-generated plan safety

  Scenario: AI suggests a repository change
    Given AI assistance is enabled
    When AI generates a suggested change
    Then Monad converts the suggestion into a reviewable plan
    And Monad does not apply the change automatically
    And deterministic policy checks are run before apply is allowed
```

**Maturity:** AI Future
**Priority:** P0 when AI planning exists
**Primary bounded contexts:** AI, Plan, Policy, Security
**Mutation allowed:** No automatic mutation

### 14.22.3 Scenario: AI Provider Failure Does Not Break Deterministic Commands

```gherkin id="4k8uic"
Feature: AI-optional operation

  Scenario: AI provider failure does not break deterministic commands
    Given AI assistance is configured
    And the AI provider is unavailable
    When the user runs "monad check"
    Then Monad completes deterministic checks without AI
    And Monad does not fail because the AI provider is unavailable
```

**Maturity:** AI Future
**Priority:** P0 when AI configuration exists
**Primary bounded contexts:** AI, Inspection, Policy

---

## 14.23 Feature: Network and Telemetry Safety

### 14.23.1 Scenario: Core Commands Do Not Use Network by Default

```gherkin id="jm1laq"
Feature: Network safety

  Scenario: Core commands do not use network by default
    Given a valid Monad workspace
    And network access is unavailable
    When the user runs "monad check"
    Then the command completes using local repository data
    And Monad does not require a hosted service
```

**Maturity:** V0 Core
**Priority:** P0
**Primary bounded contexts:** Security, Infrastructure, Command
**Network allowed:** No

### 14.23.2 Scenario: Telemetry Is Not Sent by Default

```gherkin id="sf9bfj"
Feature: Telemetry safety

  Scenario: Telemetry is not sent by default
    Given the Monad CLI is installed
    When the user runs a core read-only command
    Then Monad does not send telemetry
    And Monad does not require telemetry configuration
```

**Maturity:** V0 Core
**Priority:** P0
**Primary bounded contexts:** Security, Privacy, Observability

---

## 14.24 Feature: Report and Schema Output

### 14.24.1 Scenario: Check Report Contains Schema Version

```gherkin id="apc7ck"
Feature: Structured report output

  Scenario: Check report contains schema version
    Given a valid Monad workspace
    When the user runs "monad check --format json"
    Then the output is valid JSON
    And the output contains a schema version
    And the output contains the Monad version
    And the output contains a findings summary
```

**Maturity:** V1 Core
**Priority:** P0
**Primary bounded contexts:** Observability, Inspection
**Test type:** Schema test

### 14.24.2 Scenario: Report Can Be Written to Local Path

```gherkin id="xbufsl"
Feature: Structured report output

  Scenario: Report can be written to local path
    Given a valid Monad workspace
    When the user runs "monad check --format json --output .monad/reports/check.json"
    Then Monad writes the report to the requested path
    And Monad reports where the file was written
    And Monad does not modify canonical repository files
```

**Maturity:** V1 Core
**Priority:** P1
**Primary bounded contexts:** Observability
**Mutation allowed:** Writes generated artifact only

---

## 14.25 Feature: Release Readiness

### 14.25.1 Scenario: Repository Passes Release Readiness

```gherkin id="x0gwrj"
Feature: Release readiness

  Scenario: Repository passes release readiness
    Given a repository with passing checks, updated docs, and valid release metadata
    When the user runs "monad release readiness"
    Then Monad reports that the repository is release-ready
    And the output includes release evidence
```

**Maturity:** V1/Future
**Priority:** P1
**Primary bounded contexts:** Release, Governance, Observability

### 14.25.2 Scenario: Release Readiness Blocks Critical Finding

```gherkin id="1yf0z4"
Feature: Release readiness

  Scenario: Release readiness blocks critical finding
    Given a repository with a critical policy finding
    When the user runs "monad release readiness"
    Then Monad reports that release readiness failed
    And the critical finding is listed
    And the command exits with a validation failure code
```

**Maturity:** V1/Future
**Priority:** P0
**Primary bounded contexts:** Release, Policy

---

## 14.26 Feature: Fixture-Based BDD Execution

### 14.26.1 Scenario: BDD Scenario Maps to Fixture Repository

```gherkin id="5vcz5e"
Feature: Fixture-based BDD execution

  Scenario: BDD scenario maps to fixture repository
    Given a BDD scenario declares a fixture repository
    When the test harness executes the scenario
    Then the fixture is copied to a temporary directory
    And the Monad command runs inside the temporary directory
    And assertions are made against output, exit code, findings, and file changes
    And the original fixture is not modified
```

**Maturity:** V0/V1 Testing Infrastructure
**Priority:** P0
**Primary bounded contexts:** Testing, Workspace

### 14.26.2 Scenario: Read-Only Scenario Proves No Mutation

```gherkin id="8txfvz"
Feature: Fixture-based BDD execution

  Scenario: Read-only scenario proves no mutation
    Given a BDD scenario is marked mutation_allowed false
    When the test harness executes the scenario
    Then the file tree before and after command execution is identical
    Except for explicitly allowed generated report or cache paths
```

**Maturity:** V0/V1 Testing Infrastructure
**Priority:** P0
**Primary bounded contexts:** Testing, Security

---

## 14.27 Scenario Priority Matrix

The BDD scenarios should be prioritized by product risk.

### 14.27.1 P0 Scenarios

P0 scenarios protect foundational doctrine and safety.

P0 includes:

```text id="5ydvm6"
version works without repository
command catalog is honest
CLI surface matches catalog
monad.toml is canonical
workspace.toml conflict is reported
inspect is read-only
check reports missing manifest
doctor explains actionable problems
context handoff excludes secrets
context handoff does not require AI
core commands do not use network by default
telemetry is not sent by default
plan creation does not mutate files
dry-run does not mutate files
apply only performs planned operations
unsafe mutation is blocked
AI suggestion does not auto-apply
```

### 14.27.2 P1 Scenarios

P1 scenarios protect important workflows after the baseline is stable.

P1 includes:

```text id="4x3lhn"
graph output formats
docs check
ADR listing
work packet listing
policy explain
native tool delegation
structured report output
release readiness
missing optional native tool warning
```

### 14.27.3 P2 Scenarios

P2 scenarios support maturity, polish, and future expansion.

P2 includes:

```text id="p67cjy"
waiver expiration
release evidence
diagnostic bundles
hosted sync behavior
advanced graph validation
AI provider fallback
enterprise/self-hosted operations
```

---

## 14.28 Scenario Maturity Map

The BDD set should evolve in stages.

### 14.28.1 V0 Core

V0 Core should cover:

* version command,
* list command,
* command catalog contract,
* canonical manifest behavior,
* inspect command,
* check command,
* doctor command,
* basic graph command if exposed,
* context handoff if exposed,
* no-AI baseline,
* no-network baseline,
* read-only safety.

### 14.28.2 V1 Core

V1 Core should cover:

* structured JSON outputs,
* schema-versioned reports,
* docs check,
* ADR lifecycle,
* work packet lifecycle,
* policy check,
* plan validation,
* dry-run apply,
* unsafe mutation blocking,
* report output,
* native tool coordination.

### 14.28.3 Future

Future should cover:

* approved apply,
* rollback/repair hints,
* release readiness,
* waiver lifecycle,
* pack/plugin workflows,
* migration workflows,
* generated docs,
* advanced graph queries.

### 14.28.4 AI Future

AI Future should cover:

* AI-assisted planning,
* AI output classification,
* AI provider failure handling,
* AI-generated plan validation,
* context safety with AI,
* no automatic apply,
* deterministic policy validation after AI suggestions.

### 14.28.5 Hosted Future

Hosted Future should cover:

* hosted login,
* hosted sync,
* report upload,
* hosted graph dashboard,
* team policy evidence,
* audit logs,
* alerts,
* organization-level settings.

Hosted scenarios should not be implemented before local CLI behavior is mature.

---

## 14.29 BDD-to-Test Mapping

Each BDD scenario should map to concrete tests.

Recommended mapping:

| BDD Scenario Type     | Primary Test Type                              |
| --------------------- | ---------------------------------------------- |
| Simple command works  | CLI smoke test                                 |
| CLI/catalog alignment | Command contract test                          |
| Manifest behavior     | Unit + fixture integration test                |
| Read-only safety      | Fixture integration + filesystem mutation test |
| JSON output           | Schema test                                    |
| Human output          | Snapshot/golden test                           |
| Graph invariant       | Unit + property + fixture test                 |
| Context safety        | Security/privacy fixture test                  |
| Native tool behavior  | Adapter + integration test                     |
| Policy behavior       | Unit + fixture + schema test                   |
| Plan validation       | Unit + fixture + schema test                   |
| Apply behavior        | Mutation safety fixture test                   |
| AI behavior           | Mocked AI evaluation test                      |
| Hosted behavior       | Future integration/E2E test                    |

A scenario is not fully accepted until its mapped tests exist and pass.

---

## 14.30 BDD File Organization

Future executable BDD specifications may be organized as:

```text id="82wbx0"
features/
  command/
    version.feature
    catalog.feature
  workspace/
    manifest.feature
    inspection.feature
  graph/
    graph-generation.feature
  context/
    handoff.feature
    context-safety.feature
  docs/
    docs-check.feature
    adr.feature
  governance/
    workpacket.feature
    policy.feature
  plan/
    planning.feature
    apply.feature
    mutation-safety.feature
  native-tools/
    detection.feature
    delegation.feature
  ai/
    ai-optional.feature
    ai-plan-safety.feature
  infrastructure/
    network-safety.feature
    telemetry-safety.feature
  release/
    release-readiness.feature
```

Monad does not need to adopt a Gherkin runner immediately. These scenarios may first live as specification documentation and be implemented as Rust integration tests with scenario-style names.

---

## 14.31 BDD Implementation Guidance

BDD scenarios can be implemented gradually.

### 14.31.1 Early Implementation

Early BDD implementation may use ordinary Rust tests.

Example test name:

```text id="05e2r6"
bdd_manifest_workspace_toml_conflict_reports_canonical_warning
```

The test can:

1. copy fixture repository to a temp directory,
2. run the CLI command,
3. assert exit code,
4. assert stdout/stderr,
5. assert findings,
6. assert no file mutation.

### 14.31.2 Later Implementation

Later, Monad may introduce:

* `.feature` files,
* a Gherkin parser,
* custom scenario runner,
* generated Rust tests,
* scenario metadata,
* traceability reports,
* work-packet acceptance mapping.

This should happen only if it improves maintainability.

### 14.31.3 Scenario Traceability

Eventually, test output may show:

```text id="ypwsba"
BDD-MANIFEST-002 passed
BDD-CONTEXT-SECRET-001 passed
BDD-PLAN-DRYRUN-001 passed
```

This would allow work packets and release readiness checks to cite behavioral evidence.

---

## 14.32 BDD Acceptance Criteria

A BDD scenario is well-formed when it has:

* a clear feature name,
* one behavior per scenario,
* concrete preconditions,
* a concrete command or action,
* observable outcomes,
* expected mutation behavior,
* expected network behavior if relevant,
* expected AI behavior if relevant,
* and a known maturity level.

A BDD scenario is implementation-ready when it also has:

* fixture repository,
* expected exit code,
* expected finding IDs,
* expected output format,
* expected file changes or no-change assertion,
* test type mapping,
* related work packet,
* and priority.

A BDD scenario is complete when:

* its test exists,
* the test passes,
* the scenario is linked to documentation or work-packet acceptance criteria,
* and any relevant schemas/snapshots are updated.

---

## 14.33 BDD Anti-Patterns

Monad should avoid the following BDD anti-patterns.

### 14.33.1 Vague Scenarios

Bad:

```gherkin id="cg4x70"
Scenario: Monad works
```

Good:

```gherkin id="5bfz42"
Scenario: Missing canonical manifest is reported
```

### 14.33.2 Implementation-Only Scenarios

BDD should describe behavior, not internal function calls.

### 14.33.3 Too Many Assertions in One Scenario

Each scenario should focus on one user-visible behavior.

It is acceptable to include safety assertions, but unrelated behaviors should be split.

### 14.33.4 Mutating Scenarios Without Safety Assertions

Every mutating scenario must state what is allowed to change and what must not change.

### 14.33.5 AI Scenarios Without Human Review

AI scenarios must not imply automatic mutation or deterministic authority.

### 14.33.6 Hosted Scenarios Too Early

Hosted scenarios should not become acceptance criteria for local CLI milestones.

### 14.33.7 Planned Behavior Presented as Implemented

The BDD set may describe planned behavior, but maturity labels must prevent confusion.

---

## 14.34 Recommended Initial Implementation Order

The recommended implementation order for this BDD set is:

1. Add or strengthen version command scenario test.
2. Add or strengthen command list scenario test.
3. Add command catalog contract scenario tests.
4. Add canonical manifest scenario tests.
5. Add workspace mirror conflict scenario tests.
6. Add inspect scenario tests.
7. Add inspect read-only mutation test.
8. Add check valid repository scenario test.
9. Add check missing manifest scenario test.
10. Add doctor actionable remediation scenario test.
11. Add context handoff no-AI scenario test.
12. Add context secret exclusion scenario test.
13. Add no-network default scenario test where feasible.
14. Add no-telemetry default assertion at design/contract level.
15. Add graph text/json/mermaid scenario tests as graph features mature.
16. Add docs check scenario tests.
17. Add ADR listing/dry-run scenario tests.
18. Add work-packet listing/planning scenario tests.
19. Add policy check/explain scenario tests.
20. Add plan creation scenario tests.
21. Add dry-run no-mutation scenario tests.
22. Add unsafe mutation blocking scenario tests.
23. Add approved apply scenario tests only after apply exists.
24. Add native tool coordination tests.
25. Add AI future tests only after AI features are explicitly introduced.

---

## 14.35 Early Non-Goals

The early BDD set does not need to cover:

* hosted SaaS dashboard behavior,
* multi-tenant organization management,
* cloud deployment,
* Kubernetes deployment,
* enterprise identity,
* plugin marketplace behavior,
* live AI provider behavior,
* fleet dashboards,
* billing,
* remote telemetry,
* alert routing,
* browser UI behavior,
* graph database behavior,
* local daemon behavior.

These may be added later if Monad grows into those product surfaces.

---

## 14.36 Open Questions

The following questions should remain open until implementation pressure justifies decisions.

1. Should Monad store BDD specs as Markdown sections, `.feature` files, or both?

2. Should scenario IDs be manually assigned or generated?

3. Should scenario metadata live in frontmatter, sidecar YAML, or a registry file?

4. Should BDD scenarios be executed by a Gherkin runner or ordinary Rust integration tests?

5. What is the minimum BDD evidence required for a work packet to be considered complete?

6. Should BDD scenarios be referenced directly from work packets?

7. Should release readiness report which BDD scenarios passed?

8. How should planned-but-not-implemented scenarios be marked in generated documentation?

9. Should BDD scenarios use exact output text or finding IDs where possible?

10. Should no-network behavior be tested with a sandbox/mock layer?

11. Should no-telemetry behavior be enforced through tests, code review, or architecture policy?

12. Should fixtures be generated or hand-authored?

13. How should BDD tests normalize platform-specific paths and line endings?

14. Should AI future scenarios use recorded responses, mocks, or deterministic local fixtures?

15. Should hosted future scenarios live in this repo before hosted work begins?

---

## 14.37 Section Acceptance Criteria

This section is successful if a reader understands that:

1. BDD scenarios are executable product promises for Monad.
2. The BDD set translates product doctrine into observable behavior.
3. Scenarios should be concrete, command-oriented, and user-visible.
4. Scenarios must distinguish implemented, planned, future, hosted future, and AI future behavior.
5. Scenarios should map to fixture repositories and automated tests.
6. Command catalog behavior must be covered by BDD and contract tests.
7. Canonical manifest behavior must be covered by BDD.
8. Read-only command safety must be covered by BDD.
9. Context safety and AI-optional operation must be covered by BDD.
10. Plan/apply mutation safety must be covered before mutation becomes powerful.
11. Native tool coordination must be covered without replacing native tools.
12. Network and telemetry safety must be covered as product trust requirements.
13. BDD scenarios should map to work-packet acceptance criteria.
14. BDD implementation can begin as ordinary Rust tests and later evolve into `.feature` execution if useful.
15. Hosted and AI scenarios are future-facing and must not distort early local CLI scope.
16. The BDD set reinforces Monad’s core doctrine: local-first, deterministic, governance-grade, AI-optional, read-only-before-mutation, plan-backed-before-mutation, native-tool-coordinating, and lifecycle-graph-centered.

The final BDD rule is:

> A Monad behavior is not truly part of the product contract until it can be described as a scenario, exercised against a fixture or command, and proven by an automated test.
