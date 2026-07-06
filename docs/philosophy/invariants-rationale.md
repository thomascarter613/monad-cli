# Invariants Rationale

This document explains why Monad uses invariants as a governance and architecture tool.

## What Is an Invariant?

An invariant is a rule that should remain true as the repository evolves.

Examples:

- Inspect commands should not mutate.
- Core commands should not require network access.
- `monad.toml` remains canonical.
- Generated state should be rebuildable unless promoted to evidence.
- Placeholder commands should not fake success.

## Why Invariants Matter

Invariants preserve trust across change.

They help Monad:

- detect drift;
- guide reviews;
- constrain generators;
- protect source-of-truth rules;
- support release readiness;
- generate safer context;
- keep AI and plugins inside boundaries.

## Invariants Versus Policies

Invariants express what must remain true.

Policies check whether the repository currently satisfies those expectations.

## Invariants Versus ADRs

ADRs explain decisions. Invariants turn some decisions into durable rules that can eventually be validated.

## Failure Response

When an invariant fails:

1. Identify the source of truth.
2. Determine whether the invariant or implementation is wrong.
3. Record a finding.
4. Fix, waive, or supersede through review.
5. Add test coverage if recurrence matters.

## Maintenance Notes

Invariants should be few, meaningful, and tied to trust. Avoid turning every preference into an invariant.
