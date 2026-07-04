# 11. Infrastructure and Cloud-Agnostic Deployment Plan

## 11.1 Infrastructure Summary

The first version of Monad requires almost no infrastructure.

This is a strength.

Initial deployment:

```text id="jk3sfv"
Developer Machine
  └─ monad binary
      └─ local repository
```

Optional future infrastructure:

```text id="x8yt55"
local cache
editor integrations
CI integration
pack registry
hosted control plane
team dashboard
graph explorer
policy reporting service
```

## 11.2 Local Development Environment

Recommended local baseline:

```text id="c7tkk3"
Rust stable
Cargo
Git
optional: Bun / Node
optional: Docker
optional: just / make
optional: cargo-nextest
optional: cargo-deny
optional: cargo-audit
```

## 11.3 Container Strategy

Monad itself should not require containers.

However, the repository should support:

* devcontainers,
* reproducible CI,
* release builds,
* integration test environments,
* future packaged distribution.

Possible files:

```text id="bdqdcw"
.devcontainer/devcontainer.json
Dockerfile
docker-compose.yml
```

Use containers for reproducibility, not as a hard local requirement.

## 11.4 Orchestration Strategy

Early:

```text id="wgb8rh"
None required.
```

Future optional:

```text id="oe57cb"
Docker Compose for local demos
Kubernetes for hosted control plane
Nomad as an alternative deployment target
```

No orchestration should be required to use the CLI.

## 11.5 Infrastructure-as-Code Strategy

Early IaC is not required for the local CLI.

Future hosted control plane may use:

```text id="o1pm94"
Terraform
Pulumi
OpenTofu
Helm
Kustomize
```

Cloud-agnostic design should separate:

```text id="wlaz06"
compute
storage
database
object storage
queue/event bus
secrets
observability
identity
networking
```

## 11.6 Secrets Management Strategy

Local CLI:

* reads no secrets unless explicitly asked,
* avoids including secrets in generated context,
* respects `.gitignore` and Monad-specific ignore rules,
* supports `.monadignore` or context ignore rules in the future.

Future hosted:

* HashiCorp Vault,
* SOPS,
* age,
* cloud KMS adapters,
* External Secrets,
* Infisical as optional provider.

No secret provider should be mandatory.

## 11.7 Cloud Portability Matrix

| Capability     | Local Default     | AWS             | GCP            | Azure              | Cloudflare            | Self-Hosted      |
| -------------- | ----------------- | --------------- | -------------- | ------------------ | --------------------- | ---------------- |
| CLI runtime    | Binary            | Binary          | Binary         | Binary             | Binary                | Binary           |
| Metadata store | Files/SQLite      | RDS             | Cloud SQL      | Azure DB           | D1/Workers KV limited | Postgres         |
| Object storage | Filesystem        | S3              | GCS            | Blob               | R2                    | MinIO            |
| Queue          | None initially    | SQS             | Pub/Sub        | Service Bus        | Queues                | NATS/Redis       |
| Secrets        | Local env ignored | Secrets Manager | Secret Manager | Key Vault          | Secrets               | Vault/SOPS       |
| Observability  | Local logs        | CloudWatch      | Cloud Ops      | Azure Monitor      | Analytics             | OTel stack       |
| Hosted app     | None initially    | ECS/EKS         | Cloud Run/GKE  | Container Apps/AKS | Workers               | Kubernetes/Nomad |

## 11.8 CI/CD Strategy

Initial CI should run:

```bash id="lekf88"
cargo fmt --all --check
cargo check --workspace
cargo test --workspace
cargo clippy --workspace -- -D warnings
```

Later CI should add:

```bash id="2sj9i2"
cargo deny check
cargo audit
cargo nextest run
cargo llvm-cov
schema validation
snapshot tests
release build checks
SBOM generation
artifact signing
```

## 11.9 Release Infrastructure

Recommended release path:

1. local build,
2. CI build,
3. cross-platform release artifacts,
4. checksums,
5. signed release artifacts later,
6. GitHub Releases initially,
7. package managers later.

Potential distribution channels:

```text id="6j4me7"
GitHub Releases
cargo install
Homebrew tap
Scoop
Nix flake
asdf/mise plugin
Docker image, optional
```

## 11.10 Disaster Recovery

For local CLI:

* source code in Git,
* releases in GitHub,
* generated artifacts reproducible from source,
* docs in repo.

For future hosted service:

* database backups,
* object storage versioning,
* IaC redeploy,
* tenant export,
* disaster recovery runbooks,
* recovery time/recovery point objectives.

## 11.11 Infrastructure Non-Goals

Early Monad does not need:

* Kubernetes,
* cloud accounts,
* hosted database,
* message broker,
* object storage,
* service mesh,
* distributed tracing backend,
* multi-region deployment.
