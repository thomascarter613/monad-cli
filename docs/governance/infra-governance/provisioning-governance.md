# Provisioning Governance

This document defines governance rules for provisioning infrastructure related to Monad.

Monad is local-first, so provisioning governance applies mainly to CI, release infrastructure, generated evidence paths, optional registries, and future hosted projection layers.

## Purpose

Provisioning governance ensures that infrastructure changes are:

- intentional;
- reviewable;
- documented;
- reversible or reproducible where practical;
- aligned with environment contracts;
- traceable to ADRs, work packets, policies, and release evidence.

## Provisioning Scope

| Scope | Examples |
| ----- | -------- |
| Local | devcontainer, toolchain files, local generated state. |
| CI | workflows, caches, test matrices, release gates. |
| Release | artifact generation, evidence storage, checksums. |
| Registry | future pack/template/plugin registry configuration. |
| Hosted projection | future dashboard, sync, auth, tenancy, storage. |

## Governance Rules

- Core local workflows must not require provisioned hosted services.
- Provisioning changes should be reviewed with docs and evidence.
- Secrets must be external to source control.
- Changes that affect release gates must update release docs.
- Hosted resources must be optional unless a later ADR changes the architecture.
- Generated infrastructure outputs should not become hidden source of truth.
- Destructive provisioning changes should be plan-backed or explicitly approved.

## Provisioning Evidence

Evidence may include:

- configuration files;
- CI workflow changes;
- plan/diff output;
- release readiness reports;
- environment validation output;
- policy findings;
- infrastructure drift reports;
- rollback notes.

## Review Checklist

Before approving provisioning changes, verify:

- What environment is affected?
- Is local-first behavior preserved?
- Are secrets excluded from source control?
- Are new network or telemetry behaviors explicit?
- Are docs and environment contracts updated?
- Is rollback or rebuild documented?
- Is release evidence affected?

## Maintenance Notes

Update this document when CI, release infrastructure, registry behavior, or hosted projection assumptions change.
