# 14. BDD Specification Set

## 14.1 Feature: Repository Version Command

```gherkin id="xibhph"
Feature: Version reporting

  Scenario: User checks the Monad version
    Given the Monad CLI is installed
    When the user runs "monad version"
    Then the command exits successfully
    And the output includes the current Monad version
```

## 14.2 Feature: Command Catalog

```gherkin id="yexzi0"
Feature: Command catalog visibility

  Scenario: User lists known commands
    Given the Monad CLI is installed
    When the user runs "monad list"
    Then the command exits successfully
    And the output includes implemented commands
    And the output includes planned commands
    And planned commands are clearly marked as not fully implemented
```

```gherkin id="mz2gza"
Feature: Command catalog contract

  Scenario: CLI surface matches command catalog
    Given the command catalog contains a command named "config list"
    When the command catalog contract test runs
    Then the Clap command tree exposes "config list"
```

## 14.3 Feature: Canonical Manifest

```gherkin id="x278g9"
Feature: Canonical manifest resolution

  Scenario: monad.toml exists
    Given a repository contains "monad.toml"
    When the user runs "monad config inspect"
    Then Monad treats "monad.toml" as the canonical manifest
```

```gherkin id="owl9pa"
Feature: Compatibility mirror handling

  Scenario: workspace.toml conflicts with monad.toml
    Given a repository contains "monad.toml"
    And the repository contains "workspace.toml"
    And the two files disagree
    When the user runs "monad check"
    Then Monad reports a source-of-truth warning or error
    And Monad states that "monad.toml" is canonical
```

## 14.4 Feature: Repository Inspection

```gherkin id="lh4yi2"
Feature: Repository inspection

  Scenario: User inspects a valid Monad workspace
    Given a valid Monad workspace
    When the user runs "monad inspect"
    Then Monad reports the workspace name
    And Monad reports known project areas
    And Monad reports detected native tool manifests
    And Monad does not modify any files
```

```gherkin id="msk8rz"
Feature: Repository inspection safety

  Scenario: Inspect command is read-only
    Given a repository with tracked files
    When the user runs "monad inspect"
    Then no files are created
    And no files are modified
    And no files are deleted
```

## 14.5 Feature: Repository Check

```gherkin id="ft9zvl"
Feature: Repository validation

  Scenario: Valid repository passes baseline checks
    Given a repository that satisfies Monad baseline invariants
    When the user runs "monad check"
    Then the command exits successfully
    And the output reports no blocking findings
```

```gherkin id="l3x3ok"
Feature: Repository validation

  Scenario: Missing canonical manifest is reported
    Given a repository without "monad.toml"
    When the user runs "monad check"
    Then Monad reports a configuration finding
    And the output suggests creating or initializing a canonical manifest
```

## 14.6 Feature: Doctor Diagnostics

```gherkin id="p2vjhf"
Feature: Repository diagnostics

  Scenario: Doctor explains actionable problems
    Given a repository with missing docs and a manifest conflict
    When the user runs "monad doctor"
    Then Monad reports each issue
    And each issue includes a remediation hint
```

## 14.7 Feature: Graph Generation

```gherkin id="r3mgmn"
Feature: Lifecycle graph generation

  Scenario: User generates a text graph
    Given a valid Monad workspace with projects and docs
    When the user runs "monad graph --format text"
    Then Monad emits a graph representation
    And the graph includes workspace nodes
    And the graph includes project nodes
```

```gherkin id="9s8vte"
Feature: Mermaid graph generation

  Scenario: User generates a Mermaid graph
    Given a valid Monad workspace
    When the user runs "monad graph --format mermaid"
    Then Monad emits valid Mermaid syntax
```

## 14.8 Feature: Context Handoff

```gherkin id="llloef"
Feature: Context handoff generation

  Scenario: User creates a deterministic handoff
    Given a valid Monad workspace
    When the user runs "monad context handoff"
    Then Monad emits a Markdown handoff
    And the handoff includes workspace identity
    And the handoff includes current command surface
    And the handoff includes known risks or missing data
```

```gherkin id="1n2tcb"
Feature: Context safety

  Scenario: Context handoff excludes secrets
    Given a repository contains ".env"
    And the repository contains "id_rsa"
    When the user runs "monad context handoff"
    Then the output does not include secret file contents
    And Monad reports that sensitive files were excluded
```

## 14.9 Feature: Documentation Check

```gherkin id="xi7nf6"
Feature: Documentation validation

  Scenario: Missing architecture docs are reported
    Given a Monad workspace without architecture overview documentation
    When the user runs "monad docs check"
    Then Monad reports a documentation finding
    And the finding includes the expected documentation path
```

## 14.10 Feature: ADR Lifecycle

```gherkin id="nsqkjw"
Feature: ADR listing

  Scenario: User lists ADRs
    Given a workspace with ADR files
    When the user runs "monad adr list"
    Then Monad lists known ADRs
    And each ADR includes status when available
```

```gherkin id="gs1c49"
Feature: ADR creation safety

  Scenario: ADR creation previews before mutation
    Given a valid Monad workspace
    When the user runs "monad adr new --dry-run"
    Then Monad shows the ADR file that would be created
    And no file is written
```

## 14.11 Feature: Work Packet Lifecycle

```gherkin id="ye3njv"
Feature: Work packet listing

  Scenario: User lists work packets
    Given a workspace with work packet documentation
    When the user runs "monad workpacket list"
    Then Monad lists known work packets
    And each work packet includes status when available
```

```gherkin id="5t7eo8"
Feature: Work packet planning

  Scenario: User plans work packet implementation
    Given a valid work packet
    When the user runs "monad workpacket plan"
    Then Monad emits ordered layers
    And each layer includes acceptance criteria
```

## 14.12 Feature: Policy Check

```gherkin id="1wc3od"
Feature: Policy evaluation

  Scenario: Policy violation is reported
    Given a workspace with a policy requiring docs/index.md
    And docs/index.md is missing
    When the user runs "monad policy check"
    Then Monad reports a policy finding
    And the command exits with a validation failure code
```

```gherkin id="q00opv"
Feature: Policy explanation

  Scenario: User asks why a policy failed
    Given a policy finding exists
    When the user runs "monad policy explain <policy-id>"
    Then Monad explains the policy
    And Monad explains the remediation
```

## 14.13 Feature: Plan Creation

```gherkin id="ref36f"
Feature: Change planning

  Scenario: User creates an add-app plan
    Given a valid Monad workspace
    When the user runs "monad plan add app web"
    Then Monad emits a plan
    And the plan lists files to create
    And the plan lists commands to run
    And the plan lists risks
    And no files are modified
```

## 14.14 Feature: Dry-Run Apply

```gherkin id="pi32i4"
Feature: Dry-run apply

  Scenario: User dry-runs a plan
    Given a valid Monad plan
    When the user runs "monad apply plan.json --dry-run"
    Then Monad simulates the plan
    And reports expected file operations
    And no files are modified
```

## 14.15 Feature: Approved Apply

```gherkin id="79i1rh"
Feature: Approved plan application

  Scenario: User applies an approved plan
    Given a valid Monad plan
    And the plan passes policy checks
    When the user runs "monad apply plan.json --yes"
    Then Monad applies only the operations listed in the plan
    And Monad writes an apply result
    And Monad reports verification steps
```

## 14.16 Feature: Unsafe Mutation Blocking

```gherkin id="7kmq2p"
Feature: Unsafe mutation blocking

  Scenario: User attempts mutation without plan or approval
    Given a valid Monad workspace
    When the user runs a mutating command without dry-run, plan, or approval
    Then Monad refuses the operation
    And the output explains how to create a plan or run a dry-run
```

## 14.17 Feature: Native Tool Coordination

```gherkin id="6mpd1t"
Feature: Native tool detection

  Scenario: Rust workspace is detected
    Given a repository with Cargo.toml workspace configuration
    When the user runs "monad inspect"
    Then Monad reports that Cargo workspace metadata was detected
    And Monad does not replace Cargo behavior
```

```gherkin id="9bnvkv"
Feature: Native tool delegation

  Scenario: User runs a delegated test command
    Given a repository with a known native test command
    When the user runs "monad test"
    Then Monad delegates to the configured native tool
    And reports the native tool result
```

## 14.18 Feature: AI-Optional Behavior

```gherkin id="4xq5kb"
Feature: AI-optional operation

  Scenario: User generates context without AI configuration
    Given a valid Monad workspace
    And no AI provider is configured
    When the user runs "monad context handoff"
    Then Monad generates deterministic context
    And the command exits successfully
```

```gherkin id="r5x0vu"
Feature: AI-generated plan safety

  Scenario: AI suggests a repository change
    Given AI assistance is enabled
    When AI generates a suggested change
    Then Monad converts the suggestion into a reviewable plan
    And Monad does not apply the change automatically
```