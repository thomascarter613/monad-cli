# Documentation Audit

This document defines how Monad documentation is audited for presence, consistency, freshness, and traceability.

## Purpose

Documentation audits ensure that repository knowledge remains useful, versioned, and aligned with implementation.

An audit should answer:

- Which required documents exist?
- Which documents are missing?
- Which links are broken?
- Which docs are stale or contradicted by current ADRs?
- Which generated docs lack lineage?
- Which work packets lack required docs?
- Which release evidence references missing artifacts?

## Audit Scope

Documentation audits should cover:

- product docs;
- architecture docs;
- ADRs;
- work packets;
- governance docs;
- security docs;
- operations docs;
- testing docs;
- reference docs;
- release evidence;
- generated handoffs/context docs.

## Audit Checks

| Check | Description |
| ----- | ----------- |
| Required files | Required documentation files are present. |
| Frontmatter | Structured docs include required metadata where applicable. |
| Local links | Relative links resolve. |
| ADR index | ADR files are indexed and statuses are valid. |
| Work packet index | Work packets are indexed and linked. |
| Traceability | Requirements, ADRs, work packets, tests, risks, and evidence are connected. |
| Generated lineage | Generated docs identify source and regeneration path. |
| Staleness | Docs changed by affected code areas are reviewed. |
| Style | Docs follow naming and formatting guidance. |

## Audit Output

A future `monad docs check` command should produce:

- human-readable findings;
- machine-readable JSON output;
- severity levels;
- affected paths;
- remediation guidance;
- related ADR/work packet references;
- exit code aligned with CLI taxonomy.

## Severity Model

| Severity | Meaning |
| -------- | ------- |
| Info | Useful improvement or optional note. |
| Warning | Drift risk or incomplete documentation. |
| Error | Required documentation missing or invalid. |
| Blocking | Release or governance gate cannot pass. |

## Evidence

Documentation audit evidence may include:

- audit report;
- docs check output;
- broken link report;
- ADR/work-packet validation report;
- release evidence references;
- traceability matrix validation.

## Maintenance Notes

Keep this document aligned with documentation invariants, style guide, drift detection, and ADR-0009 Documentation-as-Code.
