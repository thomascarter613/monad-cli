# Monad CI/CD Pipeline Specification

## Purpose

This document defines the governed CI/CD pipeline for Monad OS / Monad CLI.

The pipeline is not merely a build system.  
It is an institutional enforcement mechanism for:

```text
formatting
workspace correctness
test correctness
command-surface correctness
policy correctness
security correctness
release readiness
artifact integrity
provenance completeness
```

CI/CD is part of Monad’s governance fabric.

---

## CI/CD Doctrine

Monad CI/CD must ensure:

```text
the workspace builds
the workspace checks
the tests pass
the command catalog is honest
the docs are valid
the ADR index is valid
the work-packet index is valid
security checks pass
policy checks pass
release evidence is generated
```

CI/CD is deterministic, local-first, and reproducible.

---

## Pipeline Stages

### Stage 1 — Formatting Gate

```bash
cargo fmt --all --check
```

Ensures formatting consistency across the workspace.

### Stage 2 — Workspace Check Gate

```bash
cargo check --workspace
```

Ensures type correctness and dependency correctness.

### Stage 3 — Test Gate

```bash
cargo test --workspace
```

Ensures functional correctness.

### Stage 4 — CLI Contract Gate

```bash
cargo test -p monad-cli --test command_catalog_contract
```

Ensures command-surface correctness.

### Stage 5 — Docs Gate (future)

```bash
monad docs check
```

Ensures documentation correctness.

### Stage 6 — ADR Gate (future)

```bash
monad adr validate
```

Ensures architectural correctness.

### Stage 7 — Work Packet Gate (future)

```bash
monad workpacket validate
```

Ensures roadmap correctness.

### Stage 8 — Security Gate

Security CI / review gate.

Ensures security correctness.

### Stage 9 — Policy Gate (future)

```bash
monad policy check
```

Ensures governance correctness.

### Stage 10 — Release Evidence Gate

Ensures release correctness.

---

## Pipeline Invariants

```text
no release without CI/CD success
no CI/CD success without evidence
no evidence without provenance
no provenance without governance
```

CI/CD is the institutional enforcement layer of Monad.