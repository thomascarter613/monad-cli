# Open Source Licenses

This document defines documentation governance for open-source licenses, third-party dependencies, and SBOM evidence.

It does not replace legal review. It provides repository-level governance expectations for tracking dependency and license evidence.

## Purpose

License governance helps Monad ensure that third-party software use is:

- visible;
- reviewable;
- compatible with project policy;
- tied to dependency evidence;
- available for release review;
- traceable to SBOM or dependency reports.

## License Evidence

License evidence may include:

- dependency manifest files;
- lockfiles;
- generated SBOMs;
- dependency audit output;
- license scan reports;
- policy findings;
- waiver records;
- release evidence references.

## Governance Rules

- Dependency manifests and lockfiles should remain source-controlled when required for reproducibility.
- License findings should be reviewable and severity-based.
- Unknown licenses should not be silently ignored in release evidence.
- License exceptions should be recorded as waivers with owner and reason.
- Generated SBOMs should include source and generation metadata where practical.
- Release evidence should reference dependency/license review status.

## Suggested Policy Categories

| Category | Meaning |
| -------- | ------- |
| Allowed | License is allowed by default. |
| Review | License requires human review. |
| Restricted | License is allowed only under specific conditions. |
| Denied | License is not allowed without explicit exception. |
| Unknown | License could not be determined. |

## Relationship to Native Tools

Monad should coordinate native ecosystem tools rather than replace them.

Examples of future integrations may include:

- Cargo dependency/license reports;
- Node package license scans;
- SBOM generators;
- security scanners;
- policy-as-code checks.

## Release Readiness

Before release, the project should know:

- whether dependency manifests are current;
- whether lockfiles are reproducible;
- whether license findings are unresolved;
- whether SBOM evidence exists where required;
- whether exceptions are documented.

## Maintenance Notes

Keep this document aligned with dependency hygiene, release evidence, policy checks, and future SBOM generation workflows.
