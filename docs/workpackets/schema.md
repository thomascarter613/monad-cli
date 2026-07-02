# Monad Work Packet Specification and Schema

A Monad work packet is a repo-native implementation contract.

It must be:

- Human-readable.
- Machine-readable.
- LLM-ingestible.
- Serializable.
- Ordered.
- Testable.
- Validatable.
- Relationship-aware.
- Explicit about scope and non-goals.
- Clear about expected outcomes.
- Clear about completion evidence.

## Canonical source format

Markdown with YAML front matter is canonical.

Generated JSON indexes are derived artifacts:

```txt
.monad/index/workpackets.json
.monad/index/epics.json
.monad/index/sprints.json
.monad/index/workpacket-graph.json
```

## Lifecycle statuses

| Status | Meaning |
|---|---|
| `proposed` | Idea exists but is not committed to the plan. |
| `planned` | Approved but not ready to implement. |
| `ready` | Fully specified and implementable. |
| `active` | Currently being implemented. |
| `blocked` | Cannot proceed due to dependency or decision. |
| `review` | Implemented and awaiting validation. |
| `done` | Accepted and complete. |
| `deferred` | Intentionally postponed. |
| `superseded` | Replaced by another work packet. |

## Product hierarchy

```txt
Product
  -> Release
    -> Milestone
      -> Epic
        -> Sprint
          -> Work Packet
            -> Task
              -> Subtask
```

## Required Markdown sections

1. Purpose
2. Outcome Summary
3. Context
4. Scope
5. Non-Goals
6. Dependencies
7. Inputs
8. Outputs
9. Implementation Order
10. Tasks
11. Subtasks
12. Expected File Changes
13. Command Behavior
14. Data Model / Schema Changes
15. Safety Requirements
16. Test Requirements
17. Validation Commands
18. Acceptance Criteria
19. Completion Evidence
20. Notes for Human Implementers
21. Notes for AI Implementers
22. Follow-Up Work

## AI implementation contract

AI implementers must:

- Follow tasks in numeric order.
- Respect dependencies and blockers.
- Not implement non-goals.
- Run validation commands.
- Report conflicts with ADRs, scope, or previous packets.
- Never fabricate completion evidence.
