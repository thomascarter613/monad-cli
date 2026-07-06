# Authority Boundaries

This document defines authority boundaries for Monad roles, automation, AI assistance, plugins, and hosted projection.

## Purpose

Authority boundaries prevent tools, generated artifacts, and external systems from silently becoming decision makers.

They clarify who or what may:

- propose changes;
- validate state;
- approve exceptions;
- mutate files;
- publish evidence;
- call external systems;
- use AI assistance;
- override or supersede decisions.

## Boundary Matrix

| Actor | May Propose | May Validate | May Mutate | May Approve | Notes |
| ----- | ----------- | ------------ | ---------- | ----------- | ----- |
| Maintainer | Yes | Yes | Yes, through reviewable workflow | Yes | Final human authority for ordinary changes. |
| CI | No | Yes | No | No | Reports status only. |
| Policy checker | No | Yes | No | No | Produces findings; does not approve waivers. |
| Docs checker | No | Yes | No | No | Reports drift and missing docs. |
| Monad CLI | Yes | Yes | Yes, when explicitly invoked | No | Must follow plan/apply safety. |
| AI adapter | Yes | No authoritative validation | No direct mutation | No | Suggestions only. |
| Plugin | Maybe | Maybe | Only through plans | No | Must declare capabilities. |
| Hosted projection | Maybe | Maybe | No local mutation by default | No | Projection, not source of truth. |

## Non-Negotiable Boundaries

- AI must not be authoritative.
- Telemetry must not be enabled by default.
- Hosted projection must not replace local source of truth.
- Generated state must not override canonical state.
- Plugins must not bypass policy or plan/apply safety.
- Placeholders must not fake operational success.

## Approval Boundaries

Approval is required for:

- accepting ADRs;
- approving waivers;
- applying risky plans;
- publishing release evidence;
- enabling hosted sync;
- enabling telemetry;
- enabling AI provider access;
- trusting remote packs or plugins.

## Maintenance Notes

Update this document when automation, AI, plugin, pack, hosted, or release authority changes.
