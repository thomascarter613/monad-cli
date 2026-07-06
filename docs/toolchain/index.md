# Toolchain Governance Index

This directory defines governance for Monad's toolchain surfaces.

Monad coordinates native tools rather than replacing them. Toolchain governance ensures compilers, generators, AI assistance, package managers, linters, formatters, and other tools remain explicit, reviewable, and safe.

## Files

| File | Purpose |
| ---- | ------- |
| `toolchain-governance.md` | Overall rules for toolchain selection, invocation, and evidence. |
| `compiler-governance.md` | Governance for compilers and build/check tools. |
| `generator-governance.md` | Governance for file/code/docs generators. |
| `ai-assistance-governance.md` | Governance for AI-assisted workflows and provider boundaries. |

## Principles

- Native tools own native execution.
- Monad owns intent, coordination, validation, context, and evidence.
- Tool invocation should be explicit and diagnosable.
- Generators must not bypass plan/apply safety.
- AI assistance must be optional and non-authoritative.
- Tool versions and output contracts should be stable where release-critical.

## Related ADRs

- ADR-0002: Coordinate Native Tools Instead of Replacing Them
- ADR-0004: AI-Native but AI-Optional
- ADR-0006: Plan-Backed Mutation
- ADR-0013: Versioned Machine-Readable Output Schemas
- ADR-0020: AI Provider Port and Noop Adapter

## Maintenance Notes

Update this index when Monad adds new native tool adapters, generators, compiler workflows, or AI provider integrations.
