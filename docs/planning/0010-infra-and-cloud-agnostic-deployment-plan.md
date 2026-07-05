# 11. Infrastructure and Cloud-Agnostic Deployment Plan

## 11.1 Purpose of This Section

This section defines the infrastructure and deployment posture for Monad OS and Monad CLI.

Its purpose is to clarify:

* what infrastructure Monad requires early,
* what infrastructure Monad must not require early,
* how the local CLI should be deployed and operated,
* how CI/CD should execute Monad without becoming a hosted dependency,
* how optional local infrastructure may support development and testing,
* how containers and devcontainers should be used without becoming mandatory,
* how future hosted infrastructure should be designed without distorting the local-first product,
* how cloud-agnosticism should be preserved,
* how secrets, networking, storage, observability, and disaster recovery should evolve,
* and what infrastructure decisions should be deferred until Monad has a mature local runtime.

This section is intentionally conservative.

Monad is not beginning as a cloud platform, SaaS control plane, Kubernetes application, distributed service, or hosted developer portal. Monad begins as a local Rust binary that operates against a local repository.

The infrastructure baseline is:

```text
Developer machine
  └─ monad binary
      └─ local repository
```

Everything beyond that is optional, additive, and must preserve the local-first trust model.

---

## 11.2 Infrastructure Thesis

Monad’s infrastructure thesis is:

> Monad should require almost no infrastructure to deliver its first serious value.

This is not a limitation. It is a strategic advantage.

A developer should be able to install or build the `monad` binary, move into a repository, and run useful commands without provisioning:

* a cloud account,
* a hosted database,
* a message broker,
* object storage,
* Kubernetes,
* a service mesh,
* a SaaS account,
* an AI provider,
* a local daemon,
* a background agent,
* or a network connection.

The first durable product value should come from local, deterministic repository understanding:

```bash
monad version
monad list
monad config
monad inspect
monad check
monad doctor
monad graph
monad docs check
monad context handoff
```

These commands should operate primarily on repository files, local manifests, native tool configuration, documentation, policies, ADRs, work packets, and generated local state.

Future infrastructure may support richer capabilities such as team dashboards, repository fleet reporting, hosted graph visualization, organization-wide policy evidence, pack registries, or managed collaboration. However, those capabilities must not become prerequisites for the CLI’s core value.

---

## 11.3 Infrastructure Decision Summary

Monad should adopt the following infrastructure posture:

```text
Early Monad:
  Local binary
  Local repository
  Local files
  Optional native tools
  Optional CI execution
  Optional local cache
  Optional containers for reproducibility

Mid-stage Monad:
  Stronger CI integration
  Cross-platform release artifacts
  Optional devcontainers
  Optional local service harnesses for integration tests
  Optional local graph/cache/index storage
  Optional package-manager distribution

Later Monad:
  Optional hosted control plane
  Optional team dashboard
  Optional hosted graph explorer
  Optional policy reporting service
  Optional pack/template registry
  Optional organization-wide evidence store
  Optional enterprise self-hosted deployment

Never required for core CLI use:
  Cloud account
  Hosted database
  AI provider
  SaaS login
  Kubernetes
  Local daemon
  Telemetry backend
  Plugin marketplace
  Enterprise dashboard
```

The guiding infrastructure rule is:

> Infrastructure may amplify Monad, but infrastructure must not be required for Monad to be useful.

---

## 11.4 Infrastructure Principles

Monad infrastructure decisions should follow these principles.

### 11.4.1 Local-First Before Hosted

The local CLI is the primary runtime.

Hosted services may exist later, but the local binary must remain useful without them. The local repository remains the first source of truth for early Monad.

### 11.4.2 Deterministic Before Distributed

Before Monad introduces distributed systems concerns, it must provide deterministic local behavior.

A command should not behave differently because a hosted service is available unless the user explicitly opts into hosted behavior.

### 11.4.3 Files Before Databases

Early Monad should store canonical state in repository files.

Important local files include:

```text
monad.toml
workspace.toml
monad.lock
.monad/
docs/
governance/
policies/
ADRs
work packets
native manifests
CI workflows
```

A database may become useful later for hosted features, graph indexing, search, analytics, or team reporting. It must not become mandatory for the first CLI runtime.

### 11.4.4 Explicit Network Use Only

Monad should not make network calls by default.

Network access should require explicit user action, explicit configuration, or a clearly named command. Examples:

```bash
monad release check-updates
monad pack fetch
monad plugin install
monad hosted login
monad sync
```

A command such as `monad inspect` or `monad check` should not silently call external services.

### 11.4.5 No Telemetry by Default

Early Monad should not emit telemetry by default.

Future telemetry, if implemented, must be:

* opt-in,
* documented,
* inspectable,
* disableable,
* privacy-preserving,
* and unnecessary for core correctness.

### 11.4.6 Infrastructure Should Be Replaceable

Cloud-agnosticism requires all future hosted infrastructure dependencies to be isolated behind capability boundaries.

Monad should avoid hardcoding assumptions around:

* AWS,
* GCP,
* Azure,
* Cloudflare,
* Kubernetes,
* Postgres,
* Redis,
* object storage,
* identity providers,
* secrets managers,
* CI systems,
* observability platforms,
* or AI providers.

Adapters may support specific providers, but the product model should remain provider-neutral.

### 11.4.7 Native Tools Remain Native

Monad should coordinate native infrastructure tools rather than replacing them.

Examples:

* Git remains responsible for version control.
* GitHub Actions, GitLab CI, Buildkite, Woodpecker, Drone, or other CI systems remain responsible for CI execution.
* Docker remains responsible for container build and runtime behavior.
* Terraform, Pulumi, OpenTofu, Helm, or Kustomize remain responsible for infrastructure provisioning where applicable.
* Vault, SOPS, age, Infisical, cloud KMS systems, or environment-specific secret managers remain responsible for secrets where applicable.

Monad’s role is to understand, validate, document, graph, and govern how those tools fit into the repository lifecycle.

---

## 11.5 Required Infrastructure for Early Monad

The required infrastructure for early Monad should be minimal.

### 11.5.1 Required to Build Monad

For contributors building Monad from source:

```text
Rust stable
Cargo
Git
```

Optional contributor tools may include:

```text
rustfmt
clippy
cargo-nextest
cargo-deny
cargo-audit
cargo-llvm-cov
just
make
Docker
Bun or Node for documentation/tooling if needed
```

The required baseline should remain as small as possible.

### 11.5.2 Required to Run Monad

For users running a released binary:

```text
monad binary
local filesystem
local repository
```

Git should be strongly expected for real repositories, but Monad should still handle non-Git directories honestly where possible. For example, it may report:

```text
Repository type: filesystem directory
Git metadata: not detected
Some lifecycle features: unavailable
```

Early Monad should not require:

```text
Docker
Kubernetes
Postgres
SQLite server
Redis
network access
cloud credentials
AI credentials
daemon process
browser session
login token
```

### 11.5.3 Required to Use Core Commands

Core read-only commands should require only repository access:

```bash
monad version
monad list
monad config
monad inspect
monad check
monad doctor
monad graph
monad docs check
monad context handoff
```

Commands that require optional tools should report missing tool dependencies clearly.

Example:

```text
Finding: Native tool unavailable
Tool: cargo-deny
Severity: warning
Impact: Dependency policy checks were skipped.
Remediation: Install cargo-deny or disable this check in monad.toml.
```

Monad should not fail the entire command unless the missing tool is required for the specific requested operation.

---

## 11.6 Local Deployment Model

The primary deployment model is local execution.

```text
┌─────────────────────────────────────────────┐
│ Developer Machine                           │
│                                             │
│  ┌───────────────┐                          │
│  │ monad binary  │                          │
│  └───────┬───────┘                          │
│          │                                  │
│          ▼                                  │
│  ┌───────────────────────────────────────┐  │
│  │ Local Repository                       │  │
│  │                                       │  │
│  │ monad.toml                            │  │
│  │ workspace.toml                        │  │
│  │ monad.lock                            │  │
│  │ .monad/                               │  │
│  │ docs/                                 │  │
│  │ policies/                             │  │
│  │ ADRs                                  │  │
│  │ work packets                          │  │
│  │ native manifests                      │  │
│  │ source code                           │  │
│  └───────────────────────────────────────┘  │
│                                             │
│  Optional native tools:                     │
│    git, cargo, bun, docker, biome, etc.     │
└─────────────────────────────────────────────┘
```

In this model, Monad is invoked as a process, performs work, emits output, and exits.

It should not require:

* a background daemon,
* a local server,
* a file watcher,
* an open port,
* a persistent IPC socket,
* or a browser session.

A future local daemon may be considered for editor integration, cached indexing, or real-time graph updates, but it must not be part of the early architecture.

---

## 11.7 CI Deployment Model

The second deployment model is CI execution.

```text
┌─────────────────────────────────────────────┐
│ CI Runner                                   │
│                                             │
│  checkout repository                        │
│  install/build monad                        │
│  run monad checks                           │
│  emit reports/artifacts                     │
│  exit with deterministic status code        │
└─────────────────────────────────────────────┘
```

CI should run Monad the same way a developer runs Monad locally.

Initial CI should focus on:

```bash
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
cargo clippy --workspace -- -D warnings
```

As Monad matures, CI should add:

```bash
cargo deny check
cargo audit
cargo nextest run
cargo llvm-cov
schema validation
snapshot tests
golden-output tests
release build checks
SBOM generation
artifact signing
```

Monad-specific CI commands may eventually include:

```bash
monad check --ci
monad doctor --ci
monad graph --format json --output .monad/reports/graph.json
monad docs check --ci
monad policy check --ci
monad release readiness --ci
```

The `--ci` mode should generally mean:

* no interactive prompts,
* stable machine-readable output when requested,
* deterministic exit codes,
* clear findings,
* no mutation unless explicitly requested,
* no network unless explicitly configured,
* and no reliance on user-specific local state.

---

## 11.8 Environment Profiles

Monad should support the concept of environment profiles over time, but early implementation should keep them simple.

Recommended conceptual profiles:

```text
local
ci
devcontainer
release
hosted
self-hosted-enterprise
```

### 11.8.1 `local`

The default profile.

Characteristics:

* developer machine,
* direct CLI execution,
* local repository,
* human-readable output by default,
* no network by default,
* no mutation by default,
* local `.monad/` state permitted.

### 11.8.2 `ci`

The automated validation profile.

Characteristics:

* non-interactive,
* deterministic output,
* stable exit codes,
* optional machine-readable artifacts,
* no prompts,
* no hidden network calls,
* no dependence on user-specific paths,
* output suitable for CI logs and annotations.

### 11.8.3 `devcontainer`

The reproducible development profile.

Characteristics:

* optional,
* useful for contributors,
* useful for standardizing Rust/tooling versions,
* should not be required for ordinary CLI use,
* may include native tools for integration tests.

### 11.8.4 `release`

The release-build profile.

Characteristics:

* deterministic build,
* cross-platform artifacts,
* checksums,
* changelog generation,
* release notes,
* optional signing,
* optional SBOM,
* package manager publishing later.

### 11.8.5 `hosted`

Future optional hosted control-plane profile.

Characteristics:

* web/API service,
* team accounts,
* organization/repository metadata,
* hosted graph visualization,
* policy evidence,
* dashboard/reporting,
* optional repository synchronization,
* not required for local CLI correctness.

### 11.8.6 `self-hosted-enterprise`

Future enterprise deployment profile.

Characteristics:

* customer-controlled infrastructure,
* stronger identity integration,
* audit retention,
* private artifact storage,
* internal policy packs,
* internal graph/reporting services,
* cloud-agnostic deployment targets,
* air-gapped or restricted-network options where feasible.

---

## 11.9 Local Filesystem and State Strategy

Monad’s early infrastructure is mostly filesystem infrastructure.

### 11.9.1 Canonical Repository Files

Canonical or source-of-truth files may include:

```text
monad.toml
monad.lock
docs/
governance/
policies/
ADRs
work packets
native manifests
CI workflows
release metadata
```

`monad.toml` is canonical.

`workspace.toml` may exist as a compatibility mirror but should not supersede `monad.toml`.

### 11.9.2 Local Runtime State

`.monad/` should be used for local state, cache, generated context, reports, and plans.

Possible `.monad/` structure:

```text
.monad/
  cache/
  context/
  graphs/
  plans/
  reports/
  snapshots/
  indexes/
  tmp/
```

This structure should remain implementation-guided rather than prematurely fixed, but the boundaries should be clear:

```text
Canonical truth:
  repository files

Resolved state:
  monad.lock

Local runtime/cache/generated artifacts:
  .monad/
```

### 11.9.3 Cache Rules

Caches should be:

* safe to delete,
* reproducible where possible,
* versioned where necessary,
* invalidated when source inputs change,
* excluded from canonical truth,
* and documented if they influence command performance.

A user should be able to run:

```bash
rm -rf .monad/cache
```

without corrupting the repository’s canonical state.

### 11.9.4 Plan Storage

Plan-backed mutation should eventually store generated plans under `.monad/plans/` or a user-specified output path.

Plans should be:

* reviewable,
* deterministic where possible,
* schema-versioned,
* diff-friendly,
* attributable to the command that generated them,
* explicit about intended mutations,
* and safe to archive as evidence.

Example conceptual structure:

```text
.monad/plans/
  2026-07-04T120000Z-add-package.plan.json
  2026-07-04T121500Z-update-docs.plan.json
```

---

## 11.10 Local Cache and Indexing Strategy

Monad should not require a database early, but it may eventually benefit from local indexing.

Possible local indexes:

```text
repository file index
manifest index
documentation index
ADR index
work-packet index
policy index
dependency graph cache
command catalog snapshot
context pack cache
finding history snapshot
```

Early implementation should prefer simple file-backed indexes.

Possible formats:

```text
JSON
TOML
SQLite file, later optional
binary cache, only if necessary
```

SQLite may be considered later for local graph/query performance, but it should be treated as an implementation detail, not a product prerequisite.

The local index must never become the canonical source of truth.

Correct relationship:

```text
Repository files
  └─ parsed into resolved model
      └─ optionally cached/indexed under .monad/
```

Incorrect relationship:

```text
Local database
  └─ becomes hidden canonical truth
```

Index invalidation should be based on explicit inputs such as:

* file path,
* file hash,
* modified timestamp where acceptable,
* schema version,
* Monad version,
* command version,
* configuration hash,
* native tool version where relevant.

---

## 11.11 Container Strategy

Monad itself should not require containers.

Containers should be used for:

* reproducible development environments,
* contributor onboarding,
* CI parity,
* integration tests,
* release builds,
* packaging experiments,
* local demos of future hosted components.

Possible container-related files:

```text
.devcontainer/devcontainer.json
Dockerfile
docker-compose.yml
compose.yaml
docker-bake.hcl
```

The presence of container support should not imply that Monad is a container-first product.

Correct usage:

```text
Use containers to make development and CI reproducible.
Do not require containers to run the CLI.
```

Incorrect usage:

```text
Require Docker before a user can run monad inspect.
Require Docker Compose before a user can run monad check.
Require Kubernetes before a user can generate a graph.
```

### 11.11.1 Devcontainer Role

A devcontainer may be useful for Monad contributors.

It may include:

```text
Rust stable
Cargo tools
Git
shell utilities
optional Bun/Node
optional Docker client
optional documentation tools
optional security tools
```

The devcontainer should be treated as a convenience, not the canonical development environment.

### 11.11.2 Docker Image Role

A Docker image may eventually be useful for:

* CI runners,
* hermetic checks,
* release verification,
* users who prefer containerized tools,
* enterprise environments with standardized build images.

However, Docker image distribution should not replace native binary distribution.

---

## 11.12 Orchestration Strategy

Early Monad requires no orchestration.

```text
Early orchestration requirement:
  None
```

Future optional orchestration targets may include:

```text
Docker Compose
Kubernetes
Nomad
systemd
serverless/container platforms
```

These are relevant only for future hosted or self-hosted components, not for the local CLI.

### 11.12.1 Docker Compose

Docker Compose may be useful for:

* local hosted-control-plane demos,
* integration testing,
* local database/object-store/queue harnesses,
* examples,
* documentation.

It should not be required for core CLI behavior.

### 11.12.2 Kubernetes

Kubernetes may be useful later for:

* hosted control plane,
* enterprise self-hosting,
* policy reporting services,
* graph explorer services,
* multi-tenant dashboard/API deployments.

Kubernetes should not influence the early CLI architecture.

### 11.12.3 Nomad

Nomad may be considered as an alternative deployment target for self-hosted or enterprise deployments.

Its presence should reinforce cloud-agnosticism, not create a second mandatory platform.

### 11.12.4 No Early Service Mesh

A service mesh is not required early.

Future hosted infrastructure may evaluate service mesh needs based on real requirements such as:

* mTLS between hosted services,
* policy enforcement,
* traffic observability,
* multi-tenant isolation,
* progressive delivery.

Until there are multiple hosted services with real networking concerns, service mesh planning should remain deferred.

---

## 11.13 Cloud-Agnostic Design Model

Cloud-agnosticism does not mean Monad must implement every cloud abstraction immediately.

It means Monad should avoid architectural decisions that make one provider foundational.

The product model should separate infrastructure capabilities from providers.

```text
Capability:
  compute
  storage
  database
  object storage
  queue/event bus
  secrets
  identity
  networking
  observability
  artifact storage
  policy/evidence storage

Provider:
  local filesystem
  local process
  Docker
  AWS
  GCP
  Azure
  Cloudflare
  self-hosted open-source stack
```

Future hosted Monad should define provider adapters around capabilities.

### 11.13.1 Capability Abstraction Matrix

| Capability         | Local Default                   | Future Hosted Default       | Provider-Specific Examples                   |
| ------------------ | ------------------------------- | --------------------------- | -------------------------------------------- |
| CLI runtime        | Native binary                   | Native binary / container   | GitHub Releases, Homebrew, cargo install     |
| Canonical metadata | Repository files                | Repository plus hosted sync | Git, hosted API                              |
| Resolved state     | `monad.lock`                    | Hosted state mirror         | Postgres, SQLite, object storage             |
| Runtime cache      | `.monad/`                       | Cache service               | Filesystem, Redis, Valkey                    |
| Graph storage      | Files / generated graph outputs | Graph index service         | Postgres, SQLite, graph DB later             |
| Object artifacts   | Filesystem                      | Object storage              | S3, GCS, Azure Blob, R2, MinIO               |
| Queue/events       | None early                      | Queue/event bus if needed   | SQS, Pub/Sub, Service Bus, NATS, Redis       |
| Secrets            | Environment/ignored files       | Secrets manager             | Vault, SOPS, age, KMS, Infisical             |
| Identity           | Local user/Git identity         | OIDC/SAML later             | Auth0, Keycloak, Entra ID, Google, GitHub    |
| Observability      | Local logs                      | OTel-compatible stack       | Prometheus, Grafana, Loki, Tempo, SaaS tools |
| CI execution       | Native CI runner                | Hosted CI integration       | GitHub Actions, GitLab CI, Buildkite         |
| Release artifacts  | Local/CI build output           | Artifact/release storage    | GitHub Releases, package registries          |

This table is a planning aid, not an implementation mandate.

---

## 11.14 Provider Portability Rules

Future hosted infrastructure should follow these portability rules.

### 11.14.1 Avoid Provider-Specific Domain Models

Monad’s domain model should not contain AWS-, GCP-, Azure-, or Cloudflare-specific concepts unless they are isolated adapter details.

Bad domain concept:

```text
AwsTenantRepositoryGraph
```

Better domain concept:

```text
RepositoryGraphStore
```

Adapter implementation examples:

```text
PostgresRepositoryGraphStore
SqliteRepositoryGraphStore
ObjectStorageGraphSnapshotStore
```

### 11.14.2 Avoid Provider-Specific Configuration as Canonical Truth

Provider-specific configuration may exist, but it should not define Monad’s canonical model.

Good:

```text
monad.toml defines lifecycle concepts.
infra/aws/*.tf defines AWS deployment.
infra/gcp/*.tf defines GCP deployment.
```

Bad:

```text
AWS Terraform files become the only source of truth for Monad concepts.
```

### 11.14.3 Prefer Open Protocols

Where feasible, future hosted components should prefer:

* OpenTelemetry for telemetry,
* OpenAPI for HTTP APIs,
* AsyncAPI for event contracts if events are introduced,
* OIDC/SAML for identity integration,
* OCI for container images,
* SBOM standards for supply-chain evidence,
* JSON/TOML/YAML schemas for configuration,
* Git as a repository source.

### 11.14.4 Keep Provider Adapters Replaceable

Provider adapters should be replaceable without changing the core lifecycle model.

Example:

```text
ObjectArtifactStore
  ├─ FilesystemArtifactStore
  ├─ S3ArtifactStore
  ├─ GcsArtifactStore
  ├─ AzureBlobArtifactStore
  ├─ R2ArtifactStore
  └─ MinioArtifactStore
```

Monad should not implement all adapters early. The important requirement is that the architecture leaves room for them.

---

## 11.15 Infrastructure-as-Code Strategy

Early Monad does not require infrastructure-as-code.

The local CLI can be built, tested, and used without Terraform, Pulumi, OpenTofu, Helm, or Kustomize.

Future hosted Monad may use IaC for:

* hosted API deployment,
* dashboard deployment,
* graph service deployment,
* object storage,
* database provisioning,
* queue provisioning,
* identity integration,
* observability infrastructure,
* policy evidence storage,
* backup and recovery infrastructure,
* environment promotion.

Possible IaC tools:

```text
Terraform
OpenTofu
Pulumi
Helm
Kustomize
Docker Compose
Nomad job specs
```

### 11.15.1 IaC Principles

Future IaC should be:

* environment-specific but model-consistent,
* provider-isolated,
* reproducible,
* reviewable,
* policy-checkable,
* documented,
* version-controlled,
* and non-essential for local CLI value.

### 11.15.2 Suggested Future IaC Layout

A future hosted infrastructure layout may look like:

```text
infra/
  README.md
  local/
    compose.yaml
  terraform/
    modules/
      compute/
      database/
      object-storage/
      secrets/
      observability/
    environments/
      dev/
      staging/
      production/
  pulumi/
    packages/
    stacks/
  kubernetes/
    base/
    overlays/
      dev/
      staging/
      production/
  nomad/
    jobs/
```

This layout should not be introduced before it is needed.

For the current `monad-cli` repository, infrastructure files should remain minimal and contributor-focused.

---

## 11.16 Secrets Management Strategy

Secrets are a major infrastructure boundary.

Early Monad should avoid needing secrets at all.

### 11.16.1 Local CLI Secrets Posture

The local CLI should:

* read no secrets unless explicitly asked,
* avoid printing secrets,
* avoid embedding secrets in generated context,
* respect `.gitignore`,
* support Monad-specific ignore rules later,
* redact known secret patterns in reports where feasible,
* warn before including sensitive files in context packs,
* avoid storing credentials in `.monad/`,
* avoid network calls that require hidden credentials.

Possible future ignore files:

```text
.monadignore
.monad/context-ignore
.monad/secrets-denylist
```

The naming should be decided later through ADR or product design.

### 11.16.2 Environment Variables

Environment variables may be used by optional integrations, but Monad should treat them carefully.

Examples:

```text
MONAD_CONFIG
MONAD_PROFILE
MONAD_NO_COLOR
MONAD_OUTPUT_FORMAT
MONAD_HOSTED_TOKEN
MONAD_AI_PROVIDER
MONAD_AI_API_KEY
```

AI or hosted environment variables must not be required for core commands.

### 11.16.3 Future Hosted Secrets Providers

Future hosted or enterprise deployments may support:

```text
HashiCorp Vault
SOPS
age
cloud KMS
AWS Secrets Manager
GCP Secret Manager
Azure Key Vault
Cloudflare Secrets
External Secrets Operator
Infisical
1Password Secrets Automation
environment-provided secrets
```

No single provider should become mandatory.

### 11.16.4 Secret Evidence and Audit

Future governance features may report on secret hygiene:

* whether secrets appear in tracked files,
* whether secret scanning is configured,
* whether CI has secret scanning gates,
* whether generated context excludes sensitive paths,
* whether required secret-management documentation exists.

Monad should coordinate or inspect existing secret tools rather than become a secret manager itself.

---

## 11.17 Networking Posture

Early Monad should not require networking.

### 11.17.1 Default Network Behavior

Default network behavior:

```text
No outbound network calls.
No inbound listener.
No daemon.
No telemetry.
No hosted sync.
No AI calls.
No package fetches.
```

### 11.17.2 Explicit Network Commands

Future network-enabled commands should be explicit.

Examples:

```bash
monad pack search
monad pack install
monad plugin install
monad hosted login
monad hosted sync
monad release check-updates
monad ai suggest
```

Network-enabled commands should clearly disclose:

* what service is being contacted,
* what data may be sent,
* what authentication is required,
* where configuration is stored,
* whether the command mutates local files,
* and whether output is cached.

### 11.17.3 Offline Mode

Monad should eventually support an explicit offline posture.

Example:

```bash
monad check --offline
monad context handoff --offline
```

Or configuration:

```toml
[network]
default = "disabled"
```

Offline mode should be meaningful, not cosmetic.

### 11.17.4 Future Hosted Networking

Future hosted components may expose:

* HTTP APIs,
* web dashboards,
* webhook receivers,
* repository sync endpoints,
* artifact upload endpoints,
* policy report endpoints,
* graph query endpoints.

These should be designed later and should not affect early local command behavior.

---

## 11.18 Observability Strategy

Early Monad observability should be local and simple.

### 11.18.1 Local CLI Observability

The local CLI should support:

* clear human-readable output,
* structured output formats,
* deterministic findings,
* verbose mode,
* debug mode,
* trace/debug logs when requested,
* stable exit codes,
* optional timing information,
* command metadata.

Possible flags:

```bash
--verbose
--quiet
--debug
--trace
--format json
--output report.json
```

Observability should help users understand what Monad did without requiring a telemetry backend.

### 11.18.2 CI Observability

CI should produce:

* logs,
* structured reports,
* failure summaries,
* artifacts,
* annotations where supported,
* reproducible command output.

Possible generated artifacts:

```text
.monad/reports/check.json
.monad/reports/doctor.json
.monad/reports/docs-check.json
.monad/reports/graph.json
.monad/reports/policy.json
```

### 11.18.3 Future Hosted Observability

Future hosted Monad may use OpenTelemetry-compatible observability.

Possible components:

```text
OpenTelemetry SDK
OpenTelemetry Collector
Prometheus
Grafana
Loki
Tempo
Jaeger
ClickHouse
cloud provider logs/metrics/traces
SaaS observability integrations
```

Hosted observability should support:

* operational reliability,
* auditability,
* policy evidence,
* performance debugging,
* tenant-level troubleshooting,
* security monitoring.

It should not become required for the local CLI.

---

## 11.19 Distribution and Release Infrastructure

Monad should be distributed first as a native CLI binary.

### 11.19.1 Initial Distribution

Initial distribution may use:

```text
GitHub Releases
source builds through Cargo
```

Expected release artifacts:

```text
monad-linux-x86_64
monad-linux-aarch64
monad-macos-x86_64
monad-macos-aarch64
monad-windows-x86_64.exe
checksums.txt
release notes
```

### 11.19.2 Later Distribution Channels

Later channels may include:

```text
cargo install
Homebrew tap
Scoop
Nix flake
asdf plugin
mise plugin
Docker image
package-manager-specific installers
curl installer script, only if secure and signed
```

### 11.19.3 Release Hardening

Release infrastructure should eventually support:

* reproducible release builds,
* cross-platform CI,
* checksums,
* artifact signing,
* SBOM generation,
* changelog generation,
* release notes,
* provenance attestations,
* vulnerability scanning,
* backward-compatibility checks,
* command-surface contract checks.

### 11.19.4 Release Non-Goals Early

Early releases do not need:

* hosted auto-update service,
* mandatory installer,
* daemon-based update agent,
* enterprise license server,
* private package registry,
* remote activation,
* telemetry-based adoption tracking.

---

## 11.20 CI/CD Integration Boundaries

Monad should integrate with CI/CD systems but should not become a CI/CD platform early.

### 11.20.1 CI Systems to Support Conceptually

Monad should be designed to run in:

```text
GitHub Actions
GitLab CI
Buildkite
CircleCI
Jenkins
Woodpecker
Drone
Azure Pipelines
local shell scripts
```

Early implementation may only include GitHub Actions examples because the repository is hosted on GitHub, but the model should not become GitHub-only.

### 11.20.2 What Monad Should Do in CI

Monad should eventually:

* validate repository structure,
* validate manifest consistency,
* validate command catalog integrity,
* check documentation lifecycle,
* check ADR references,
* check work-packet consistency,
* emit dependency and graph reports,
* validate policy configuration,
* verify generated artifacts are current,
* produce context/handoff artifacts,
* report release readiness.

### 11.20.3 What Monad Should Not Do Early

Monad should not initially:

* replace the CI runner,
* host pipelines,
* schedule jobs,
* manage CI secrets,
* become a build farm,
* replace GitHub Actions/GitLab CI/etc.,
* require remote execution.

---

## 11.21 Future Hosted Control Plane Infrastructure

A hosted control plane is optional and future-facing.

It may eventually provide:

* organization and team management,
* repository fleet inventory,
* hosted graph visualization,
* hosted policy evidence,
* compliance reporting,
* release governance,
* work-packet dashboards,
* ADR and decision traceability,
* context pack registry,
* pack/template distribution,
* team-level configuration,
* audit logs,
* collaboration workflows.

### 11.21.1 Future Hosted Logical Architecture

A future hosted architecture may look like:

```text
┌─────────────────────────────────────────────┐
│ Browser Dashboard                           │
└───────────────────┬─────────────────────────┘
                    │
┌───────────────────▼─────────────────────────┐
│ Hosted Monad API                            │
│                                             │
│  organization management                    │
│  repository inventory                       │
│  graph/report query APIs                    │
│  policy evidence APIs                       │
│  release governance APIs                    │
└───────────────────┬─────────────────────────┘
                    │
┌───────────────────▼─────────────────────────┐
│ Hosted Persistence Layer                    │
│                                             │
│  relational metadata                        │
│  graph/index snapshots                      │
│  object artifacts                           │
│  audit logs                                 │
│  policy evidence                            │
└───────────────────┬─────────────────────────┘
                    │
┌───────────────────▼─────────────────────────┐
│ Optional Worker Layer                       │
│                                             │
│  repository sync                            │
│  report processing                          │
│  graph indexing                             │
│  notification jobs                          │
└─────────────────────────────────────────────┘
```

This architecture should remain deferred until the local CLI has proven value.

### 11.21.2 Hosted Control Plane Boundary

The hosted control plane should not replace the local CLI.

Correct relationship:

```text
Local CLI remains authoritative for local repository operations.
Hosted control plane aggregates, visualizes, coordinates, and reports.
```

Incorrect relationship:

```text
Local CLI becomes a thin client that cannot work without hosted Monad.
```

### 11.21.3 Hosted Data Source Boundary

The hosted service may store copies, indexes, summaries, reports, evidence, and collaboration metadata.

It should be careful about storing:

* source code,
* secrets,
* proprietary documentation,
* AI context packs,
* full repository snapshots,
* customer-sensitive compliance artifacts.

Tenant-controlled configuration should govern what is uploaded.

---

## 11.22 Future Self-Hosted and Enterprise Infrastructure

Enterprise users may eventually require self-hosted Monad.

Possible motivations:

* regulated environments,
* private repositories,
* data residency,
* air-gapped networks,
* internal policy packs,
* centralized governance,
* internal compliance evidence,
* avoidance of SaaS dependency.

Self-hosted Monad should be designed as a later deployment profile, not an early requirement.

### 11.22.1 Self-Hosted Deployment Targets

Potential targets:

```text
single-node Docker Compose
Kubernetes
Nomad
VM/systemd deployment
private cloud
air-gapped package bundle
```

### 11.22.2 Enterprise Integrations

Possible future integrations:

```text
OIDC
SAML
LDAP
SCIM
internal Git forges
internal artifact registries
internal secrets managers
internal policy engines
SIEM systems
GRC systems
ticketing systems
```

These integrations are valuable later but must not distract from local CLI maturity.

---

## 11.23 Backup and Disaster Recovery Strategy

Disaster recovery requirements differ by deployment model.

### 11.23.1 Local CLI Disaster Recovery

For the local CLI, disaster recovery is simple:

* source code is in Git,
* canonical project state is in repository files,
* release artifacts are reproducible,
* generated artifacts can be recreated,
* local caches can be deleted and rebuilt,
* `.monad/` should not contain irreplaceable canonical truth.

Recommended local recovery posture:

```text
Delete cache:
  rm -rf .monad/cache

Regenerate reports:
  monad check
  monad graph
  monad docs check

Recover source of truth:
  git checkout
```

### 11.23.2 CI Disaster Recovery

CI recovery depends on:

* version-controlled workflows,
* pinned dependencies where feasible,
* reproducible build scripts,
* documented release process,
* artifact retention,
* rebuildable reports.

CI should avoid storing unique canonical state outside Git.

### 11.23.3 Future Hosted Disaster Recovery

Future hosted Monad should define:

* database backups,
* object storage versioning,
* audit log retention,
* tenant export,
* restore testing,
* infrastructure redeploy from IaC,
* secrets recovery process,
* incident response runbooks,
* recovery time objectives,
* recovery point objectives.

Potential future targets:

```text
RPO: to be defined by deployment tier
RTO: to be defined by deployment tier
```

These should not be over-specified before hosted Monad exists.

---

## 11.24 Security Implications of Infrastructure Choices

Infrastructure choices affect Monad’s security posture.

Early local-first infrastructure reduces several risks:

* no hosted data breach surface,
* no mandatory cloud credentials,
* no mandatory network egress,
* no centralized repository ingestion,
* no default telemetry,
* no always-on daemon,
* no remote code execution service.

However, local-first does not eliminate risk.

Local risks include:

* accidentally including secrets in context packs,
* executing native tools unsafely,
* trusting malicious repository files,
* loading untrusted plugins or packs later,
* writing unsafe plans,
* leaking sensitive paths in reports,
* insecure release artifact distribution.

Infrastructure planning should therefore reinforce:

* explicit execution boundaries,
* safe defaults,
* no hidden network access,
* signed release artifacts later,
* plugin isolation later,
* context redaction,
* and plan-backed mutation.

---

## 11.25 Infrastructure Phasing

Infrastructure should evolve in phases.

### 11.25.1 Phase 0: Repository and CLI Foundation

Focus:

* Rust workspace,
* local binary,
* command catalog,
* tests,
* local docs,
* GitHub Actions,
* minimal release process.

Infrastructure:

```text
Git
Cargo
GitHub repository
basic CI
```

Avoid:

```text
database
cloud deployment
Kubernetes
hosted API
dashboard
```

### 11.25.2 Phase 1: Trustworthy Local CLI

Focus:

* read-only commands,
* deterministic output,
* local config,
* local reports,
* structured output,
* exit codes,
* local `.monad/` state.

Infrastructure:

```text
local filesystem
optional CI artifacts
optional devcontainer
```

Avoid:

```text
network dependency
hosted sync
AI dependency
daemon
```

### 11.25.3 Phase 2: CI and Release Hardening

Focus:

* cross-platform builds,
* checksums,
* release notes,
* CI contract tests,
* security checks,
* artifact publishing.

Infrastructure:

```text
GitHub Actions or equivalent
release artifacts
optional signing
optional SBOM
```

Avoid:

```text
complex deployment stack
multi-service architecture
```

### 11.25.4 Phase 3: Local Indexing and Plan Artifacts

Focus:

* local graph caches,
* context caches,
* generated plans,
* report directories,
* plan/apply safety.

Infrastructure:

```text
.monad/cache
.monad/plans
.monad/reports
optional SQLite file later
```

Avoid:

```text
hosted database requirement
remote plan execution
```

### 11.25.5 Phase 4: Optional Pack and Plugin Distribution

Focus:

* trusted pack distribution,
* pack metadata,
* checksums,
* signatures,
* local install cache,
* plugin sandboxing model.

Infrastructure:

```text
static registry index
artifact storage
signature verification
local cache
```

Avoid:

```text
untrusted arbitrary execution
mandatory marketplace
```

### 11.25.6 Phase 5: Optional Hosted Control Plane

Focus:

* team dashboard,
* hosted graph/reporting,
* policy evidence,
* organization-level configuration,
* repository fleet visibility.

Infrastructure:

```text
API service
web dashboard
database
object storage
queue if needed
observability
identity
secrets management
IaC
```

Avoid:

```text
making local CLI dependent on hosted service
```

### 11.25.7 Phase 6: Enterprise and Self-Hosted Deployment

Focus:

* private deployments,
* enterprise identity,
* audit retention,
* policy packs,
* data residency,
* air-gapped operation where feasible.

Infrastructure:

```text
Kubernetes or Nomad
private registries
enterprise identity
customer-managed secrets
backup/restore
runbooks
```

Avoid:

```text
cloud-specific lock-in
```

---

## 11.26 Infrastructure Risks

### 11.26.1 Premature Cloud Platform Risk

Risk:

Monad may become distracted by hosted infrastructure before the local CLI is valuable.

Impact:

* slower implementation,
* higher complexity,
* unclear product boundary,
* weaker trust model,
* more operational burden.

Mitigation:

* keep hosted control plane deferred,
* prioritize read-only local commands,
* require ADRs for hosted infrastructure,
* avoid cloud dependencies in core crates.

### 11.26.2 Kubernetes-First Drift

Risk:

Planning may over-index on Kubernetes, service mesh, and cloud-native deployment patterns.

Impact:

* solo developers face unnecessary complexity,
* local CLI becomes secondary,
* product scope becomes inflated.

Mitigation:

* no Kubernetes requirement for CLI,
* no orchestration early,
* container support only for reproducibility,
* hosted infrastructure separated into future phases.

### 11.26.3 Hidden Network Dependency Risk

Risk:

Commands may begin making implicit network calls for updates, telemetry, AI, packs, or hosted sync.

Impact:

* privacy concerns,
* broken offline workflows,
* non-deterministic behavior,
* enterprise adoption barriers.

Mitigation:

* no network by default,
* explicit network commands,
* offline mode,
* documented data flows,
* tests for offline behavior.

### 11.26.4 Local State Confusion Risk

Risk:

`.monad/` may accidentally become canonical truth.

Impact:

* repository state becomes hard to reason about,
* generated artifacts become required,
* cache corruption causes correctness issues.

Mitigation:

* define source-of-truth hierarchy,
* keep caches rebuildable,
* schema-version generated artifacts,
* document `.monad/` semantics,
* test cache invalidation.

### 11.26.5 Provider Lock-In Risk

Risk:

Future hosted architecture may become tied to one cloud provider.

Impact:

* enterprise limitations,
* portability loss,
* weaker cloud-agnostic claim.

Mitigation:

* capability-based abstractions,
* provider adapters,
* IaC module boundaries,
* no provider concepts in core domain.

### 11.26.6 Release Supply-Chain Risk

Risk:

Users may install compromised binaries or unverified artifacts.

Impact:

* severe trust loss,
* security exposure,
* enterprise adoption blockers.

Mitigation:

* checksums early,
* signing later,
* SBOM later,
* provenance later,
* secure release process,
* documented installation paths.

### 11.26.7 Optional Tool Fragility

Risk:

Native tools may be missing, version-incompatible, or behave differently across platforms.

Impact:

* inconsistent checks,
* confusing failures,
* degraded user trust.

Mitigation:

* tool detection,
* version reporting,
* graceful degradation,
* clear findings,
* adapters per native tool,
* compatibility tests.

---

## 11.27 Infrastructure Fitness Functions

Infrastructure fitness functions should verify that Monad remains local-first, portable, and safe.

Recommended fitness functions:

1. **No required cloud account**

   A fresh user can run core CLI commands without cloud credentials.

2. **No required network**

   Core read-only commands pass in an offline environment.

3. **No required container runtime**

   Core CLI usage works without Docker or Kubernetes.

4. **No required database**

   Core CLI behavior does not require Postgres, SQLite server, Redis, or any hosted store.

5. **No required AI provider**

   Core correctness does not depend on AI credentials or AI network calls.

6. **Canonical state remains file-backed**

   `monad.toml`, `monad.lock`, repository files, docs, policies, ADRs, and work packets remain primary sources of truth.

7. **`.monad/` is rebuildable**

   Deleting `.monad/cache` does not corrupt canonical repository state.

8. **CI execution is non-interactive**

   CI mode does not prompt for input.

9. **Output is deterministic**

   Given the same repository and configuration, core command output is stable except for explicitly marked timestamps or environment-specific metadata.

10. **Optional native tools degrade gracefully**

Missing optional tools produce findings rather than uncontrolled failures.

11. **No hidden telemetry**

Tests or audits can verify that default commands do not emit telemetry.

12. **No hidden mutation**

Read-only commands do not write outside allowed cache/report locations.

13. **Network-enabled commands are explicit**

Commands that contact remote services are clearly named, documented, and configurable.

14. **Provider-specific code is isolated**

Future cloud/provider integrations do not leak into core domain models.

15. **Release artifacts are verifiable**

Release artifacts have checksums early and signatures/provenance later.

---

## 11.28 Recommended Initial Implementation Order

For infrastructure-related implementation, the recommended order is:

1. Stabilize local Rust workspace build and test workflow.
2. Keep required contributor dependencies minimal.
3. Maintain basic GitHub Actions CI for format, check, test, and clippy.
4. Define `.monad/` local state semantics.
5. Ensure read-only commands do not mutate canonical files.
6. Add structured output and CI-safe command modes.
7. Add optional report output directories.
8. Add devcontainer only as contributor convenience.
9. Add release artifact generation.
10. Add checksums.
11. Add cargo install or other package distribution later.
12. Add SBOM/signing/provenance after release flow stabilizes.
13. Add optional local indexing only when performance requires it.
14. Add pack/plugin distribution infrastructure only after pack/plugin contracts mature.
15. Add hosted infrastructure only after local CLI, graph, policy, docs, context, and plan/apply workflows prove value.

---

## 11.29 Infrastructure Non-Goals

Early Monad does not need:

* Kubernetes,
* Nomad,
* Docker Compose as a runtime requirement,
* cloud accounts,
* hosted database,
* hosted object storage,
* message broker,
* service mesh,
* distributed tracing backend,
* multi-region deployment,
* SaaS dashboard,
* local daemon,
* plugin marketplace,
* hosted graph database,
* remote execution workers,
* enterprise identity integration,
* license server,
* telemetry pipeline,
* AI inference infrastructure,
* vector database,
* repository fleet manager,
* or always-on background synchronization.

These may be considered later only if they support proven product needs.

The local CLI should remain valuable without them.

---

## 11.30 Open Questions

The following infrastructure questions should remain open until implementation pressure justifies decisions.

1. Should `.monad/` be committed, ignored, or partially committed by default?

   Likely answer: most `.monad/` state should be ignored, but selected generated artifacts may be committed if explicitly configured.

2. Should Monad eventually use SQLite for local indexing?

   Likely answer: only if file-backed JSON/TOML indexes become insufficient.

3. Should there be an official Docker image?

   Likely answer: yes eventually for CI and reproducible execution, but not as the primary install path.

4. Should there be an official devcontainer?

   Likely answer: yes for contributor convenience, but not as a requirement.

5. Which release channels should be prioritized after GitHub Releases?

   Candidate order: `cargo install`, Homebrew, Nix, mise/asdf, Scoop.

6. Should update checking exist?

   Likely answer: maybe, but it must be explicit or opt-in.

7. Should Monad support a local daemon?

   Likely answer: defer until editor integration or large-repository indexing proves the need.

8. What hosted persistence model should be used later?

   Candidate answer: Postgres for relational metadata, object storage for artifacts, optional graph-specific indexing only if necessary.

9. What IaC tool should future hosted Monad prefer?

   Candidate answer: keep Terraform/OpenTofu and Pulumi options open until hosted architecture is real.

10. What is the minimum viable hosted control plane?

Candidate answer: repository inventory, graph/report upload, policy evidence, and team dashboard, but only after local CLI value is proven.

---

## 11.31 Section Acceptance Criteria

This section is successful if a reader understands that:

1. Monad’s first infrastructure target is the developer machine.
2. The primary runtime is the local `monad` binary.
3. The primary operating context is a local repository.
4. Early Monad should require no cloud account.
5. Early Monad should require no hosted database.
6. Early Monad should require no Kubernetes or orchestration platform.
7. Early Monad should require no AI provider.
8. Early Monad should make no network calls by default.
9. Early Monad should emit no telemetry by default.
10. Containers are useful for reproducibility but not required for core CLI use.
11. CI should run Monad as a normal command-line process.
12. `.monad/` should store local state, cache, context, reports, and plans, not canonical truth.
13. `monad.toml` remains canonical.
14. `workspace.toml` remains a compatibility mirror only.
15. `monad.lock` records resolved state.
16. Future hosted infrastructure is optional and deferred.
17. Cloud-agnosticism means provider capabilities should be abstracted, not that every provider must be implemented early.
18. Future IaC should support hosted and self-hosted deployment but should not distort local CLI architecture.
19. Secrets must be avoided by default and handled explicitly when integrations require them.
20. Disaster recovery for local Monad is primarily Git plus reproducible generated artifacts.
21. The infrastructure plan reinforces Monad’s core doctrine: local-first, deterministic, governance-grade, AI-optional, native-tool-coordinating, and lifecycle-graph-centered.

The final infrastructure rule is:

> Monad should be easy to run locally, safe to execute in CI, portable across environments, and architected for future hosted infrastructure without depending on that hosted infrastructure for core value.
