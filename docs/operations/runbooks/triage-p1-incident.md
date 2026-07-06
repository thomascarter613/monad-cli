# Triage P1 Incident Runbook

This runbook defines the general high-severity incident triage process for Monad.

A P1 incident is any event that blocks critical local workflows, corrupts source-of-truth state, causes unsafe mutation, leaks sensitive context, breaks release readiness, or materially affects future hosted projection availability.

## P1 Criteria

Examples:

- command mutates files unexpectedly;
- plan/apply writes outside allowed scope;
- secrets appear in generated context;
- release evidence is invalid or misleading;
- core commands require network/hosted services unexpectedly;
- hosted projection outage affects critical users;
- migration corrupts canonical or audit data.

## Immediate Response

1. Assign incident owner.
2. Freeze risky mutation paths if needed.
3. Preserve evidence before cleanup.
4. Determine whether local source-of-truth artifacts are affected.
5. Identify affected users, commands, docs, or releases.
6. Apply safe mitigation or rollback.
7. Communicate status and next review point.

## Evidence to Capture

- command run;
- version/commit;
- affected paths;
- plan/apply report;
- policy findings;
- generated context/graph manifest if relevant;
- logs or terminal output;
- reproduction steps;
- timeline.

## Severity Downgrade Conditions

A P1 may be downgraded when:

- unsafe mutation risk is stopped;
- source-of-truth state is verified;
- data exposure risk is contained;
- release-blocking evidence is either fixed or marked invalid;
- users have a safe workaround.

## Post-Incident Actions

- Write incident summary.
- Add or update forensic record if needed.
- Add regression test or policy check.
- Update runbooks and threat models.
- Update traceability/risk records if affected.

## Maintenance Notes

Keep this runbook aligned with threat modeling, data forensic schema, plan/apply model, no-telemetry doctrine, and release evidence governance.
