# SBOM Generation

Monad should support SBOM generation for release evidence.

## Preferred Tools

- Syft for filesystem/container SBOM generation.
- CycloneDX tooling where ecosystem-specific output is needed.

## Local Command

```bash
scripts/sbom.sh
```

## CI Workflow

SBOM generation is configured in:

```txt
.github/workflows/sbom.yml
```

## Output

Generated SBOM artifacts should go under:

```txt
.monad/sbom/
```

Committed release summaries may be added under:

```txt
compliance/audits/
```
