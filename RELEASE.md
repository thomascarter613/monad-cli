# Release Process

Monad v1 release gates:

1. All v1 commands exist in help.
2. All v1 commands have smoke tests.
3. All mutating commands support `--dry-run`.
4. All mutating commands use the plan engine.
5. `monad init` creates a valid governed workspace.
6. `monad check --strict` passes on a freshly generated workspace.
7. `monad policy check` works.
8. `monad graph projects/deps/tasks` works.
9. `monad context handoff` works.
10. Monad can dogfood itself.
11. CI passes fmt, clippy, tests, and smoke tests.
12. Docs include install, quickstart, command reference, known limitations, and v1 scope.
13. No known critical data-loss bugs.
