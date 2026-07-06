# Monad Testing Strategy Reference

## Purpose

This document defines the governed testing strategy for Monad OS / Monad CLI.

Testing is not merely correctness.  
Testing is evidence.

---

## Testing Doctrine

Testing must ensure:

```text
workspace correctness
command-surface correctness
policy correctness
security correctness
mutation correctness
release correctness
```

Testing is part of governance.

---

## Testing Layers

### Layer 1 — Workspace Tests

```bash
cargo test --workspace
```

Ensures functional correctness.

### Layer 2 — CLI Contract Tests

```bash
cargo test -p monad-cli --test command_catalog_contract
```

Ensures command-surface correctness.

### Layer 3 — Policy Tests (future)

```bash
monad policy check
```

Ensures governance correctness.

### Layer 4 — Docs Tests (future)

```bash
monad docs check
```

Ensures documentation correctness.

### Layer 5 — ADR Tests (future)

```bash
monad adr validate
```

Ensures architectural correctness.

### Layer 6 — Work Packet Tests (future)

```bash
monad workpacket validate
```

Ensures roadmap correctness.

### Layer 7 — Mutation Tests

Ensures plan-backed mutation correctness.

### Layer 8 — Security Tests

Ensures security correctness.

---

## Testing Invariants

```text
tests must be deterministic
tests must be reproducible
tests must be governed
tests must produce evidence
```

Testing is institutional.