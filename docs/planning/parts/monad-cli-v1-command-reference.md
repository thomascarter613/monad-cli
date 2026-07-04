Below is a v1-ready command reference for the proposed `monad` CLI command surface.

I’m using these conventions:

```txt
<required>
[optional]
... repeatable
--flag value
--flag=value
--json machine-readable output
--dry-run preview without writing
--yes skip confirmation where safe
```

# Monad v1 Command Reference

## Top-Level Commands

| Command          | Brief description / Signature                                                                                                                                  |
| ---------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| `monad init`     | Initializes a new monorepo/workspace foundation with manifests, docs, tooling, policies, and default structure.                                     |
|                  | `monad init [path] --name <name> [--preset <preset>] [--package-manager bun\|pnpm\|npm\|yarn] [--template <template>] [--yes] [--dry-run]`          |
|                  |                                                                                                                                                     |
| `monad add`      | Adds a new app, service, package, library, tool, config, policy, or capability to the workspace.                                                    |
|                  | `monad add <kind> <name> [--to <path>] [--language <lang>] [--framework <framework>] [--template <template>] [--scope <scope>] [--yes] [--dry-run]` |
|                  |                                                                                                                                                     |
| `monad remove`   | Safely removes a workspace unit or managed capability, with dependency/reference checks before deletion.                                            |
|                  | `monad remove <target> [--keep-files] [--force] [--yes] [--dry-run]`                                                                                |
|                  |                                                                                                                                                     |
| `monad rename`   | Renames a package, app, service, scope, domain, module, or workspace entity while updating references.                                              |
|                  | `monad rename <target> <new-name> [--update-imports] [--update-manifests] [--yes] [--dry-run]`                                                      |
|                  |                                                                                                                                                     |
| `monad move`     | Moves a package, app, service, library, or module to a new location while preserving workspace metadata.                                            |
|                  | `monad move <target> <destination> [--update-imports] [--update-manifests] [--yes] [--dry-run]`                                                     |
|                  |                                                                                                                                                     |
| `monad list`     | Lists workspace entities such as apps, packages, services, tasks, templates, plugins, policies, and commands.                                       |
|                  | `monad list [kind] [--scope <scope>] [--format text\|json\|markdown]`                                                                               |
|                  |                                                                                                                                                     |
| `monad inspect`  | Inspects the current repo structure, workspace manifest, dependency graph, package metadata, and tooling state.                                     |
|                  | `monad inspect [target] [--depth <n>] [--include files,tasks,deps,policies] [--format text\|json\|markdown]`                                        |
|                  |                                                                                                                                                     |
| `monad check`    | Runs baseline correctness checks against workspace structure, manifests, generated files, and expected tooling.                                     |
|                  | `monad check [target] [--strict] [--fix] [--format text\|json]`                                                                                     |
|                  |                                                                                                                                                     |
| `monad doctor`   | Diagnoses environment/tooling problems such as missing runtimes, broken package managers, bad configs, or invalid workspace state.                  |
|                  | `monad doctor [--fix] [--include env,tools,repo,cache,policy] [--format text\|json]`                                                                |
|                  |                                                                                                                                                     |
| `monad plan`     | Produces a change plan before modifying the repository. Useful for generation, migration, upgrades, and major changes.                              |
|                  | `monad plan <operation> [args...] [--out <file>] [--format text\|json\|markdown]`                                                                   |
|                  |                                                                                                                                                     |
| `monad apply`    | Applies a previously generated plan or staged change set.                                                                                           |
|                  | `monad apply <plan-file> [--yes] [--dry-run] [--rollback-on-error]`                                                                                 |
|                  |                                                                                                                                                     |
| `monad diff`     | Shows proposed, staged, or actual repo changes.                                                                                                     |
|                  | `monad diff [plan-file] [--against git\|workspace\|snapshot] [--format text\|json\|patch]`                                                          |
|                  |                                                                                                                                                     |
| `monad generate` | Generates code, configs, docs, manifests, scaffolds, policies, or context artifacts.                                                                |
|                  | `monad generate <kind> <name> [--to <path>] [--template <template>] [--data <file>] [--yes] [--dry-run]`                                            |
|                  |                                                                                                                                                     |
| `monad sync`     | Synchronizes Monad’s source-of-truth workspace metadata with native tool configs such as `package.json`, Turbo, Moon, Biome, Docker, etc.           |
|                  | `monad sync [--from monad\|native] [--target <tool>] [--check] [--write] [--dry-run]`                                                               |
|                  |                                                                                                                                                     |
| `monad run`      | Runs a named task across one or more workspace units using the configured task runner.                                                              |
|                  | `monad run <task> [--filter <selector>] [--affected] [--parallel <n>] [--since <ref>]`                                                              |
|                  |                                                                                                                                                     |
| `monad build`    | Builds one or more apps, packages, services, or the full workspace.                                                                                 |
|                  | `monad build [target] [--filter <selector>] [--affected] [--production] [--parallel <n>]`                                                           |
|                  |                                                                                                                                                     |
| `monad test`     | Runs tests for one or more workspace units.                                                                                                         |
|                  | `monad test [target] [--filter <selector>] [--affected] [--unit] [--integration] [--e2e] [--coverage]`                                              |
|                  |                                                                                                                                                     |
| `monad lint`     | Runs linting and static analysis across the workspace or selected targets.                                                                          |
|                  | `monad lint [target] [--filter <selector>] [--affected] [--fix] [--format text\|json]`                                                              |
|                  |                                                                                                                                                     |
| `monad format`   | Formats source files, configs, docs, and generated files according to workspace rules.                                                              | 
|                  | `monad format [target] [--check] [--write] [--filter <selector>]`                                                                                   |
|                  |                                                                                                                                                     |
| `monad graph`    | Produces a workspace graph overview. More specific graph types live under `monad graph ...`.                                                        | 
|                  | `monad graph [--type projects\|tasks\|deps] [--filter <selector>] [--format text\|json\|mermaid\|dot\|svg] [--out <file>]`                          |
|                  |                                                                                                                                                     |
| `monad clean`    | Removes generated state, caches, temporary files, build output, or stale Monad metadata.                                                            | 
|                  | `monad clean [target] [--cache] [--dist] [--temp] [--state] [--all] [--yes] [--dry-run]`                                                            |
|                  |                                                                                                                                                     |
| `monad migrate`  | Migrates repository structure, manifests, package manager config, framework versions, or Monad schema versions.                                     | 
|                  | `monad migrate <migration> [--from <version>] [--to <version>] [--yes] [--dry-run]`                                                                 |
|                  |                                                                                                                                                     |
| `monad upgrade`  | Upgrades Monad-managed templates, packs, plugins, schemas, or workspace conventions.                                                                | 
|                  | `monad upgrade [target] [--to <version>] [--templates] [--packs] [--plugins] [--schema] [--yes] [--dry-run]`                                        |
|                  |                                                                                                                                                     |
| `monad context`  | Manages AI/developer context artifacts. Can show status or dispatch to `pack`, `verify`, or `handoff`.                                              | 
|                  | `monad context [pack\|verify\|handoff] [args...] [--format text\|json\|markdown]`                                                                   |
|                  |                                                                                                                                                     |
| `monad config`   | Reads, writes, validates, or explains Monad workspace and user configuration.                                                                       | 
|                  | `monad config <get\|set\|unset\|list\|validate> [key] [value] [--global] [--workspace] [--format text\|json]`                                       |
|                  |                                                                                                                                                     |
| `monad version`  | Prints the Monad CLI version, workspace schema version, and optionally environment/tool versions.                                                   | 
|                  |                                                                                                                                                     |
|                  | `monad version [--verbose] [--json]`                                                                                                                          |

---

# Namespaced Commands

## Policy Commands

| Command                | Brief description                                                                                                       | Ideal signature                                                                                                   |
| ---------------------- | ----------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| `monad policy check`   | Checks the workspace against configured architecture, security, dependency, naming, ownership, and governance policies. | `monad policy check [target] [--policy <policy>] [--severity error\|warn\|info] [--format text\|json\|sarif]`     |
| `monad policy waive`   | Creates a controlled policy waiver with reason, owner, scope, and expiration.                                           | `monad policy waive <policy-id> --target <target> --reason <text> --owner <owner> [--expires <date>] [--dry-run]` |
| `monad policy explain` | Explains a policy rule, violation, waiver, or enforcement decision.                                                     | `monad policy explain <policy-id\|finding-id> [--target <target>] [--format text\|json\|markdown]`                |

## Template Commands

| Command                  | Brief description                                                                          | Ideal signature                                                                                             |
| ------------------------ | ------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------- |
| `monad template list`    | Lists available local, official, workspace, and registry templates.                        | `monad template list [--source local\|workspace\|official\|registry] [--kind <kind>] [--format text\|json]` |
| `monad template add`     | Adds or installs a template into the workspace or user template registry.                  | `monad template add <source> [--name <name>] [--kind <kind>] [--global] [--workspace] [--yes]`              |
| `monad template inspect` | Shows template metadata, supported variables, generated files, requirements, and examples. | `monad template inspect <template> [--format text\|json\|markdown]`                                         |

## Pack Commands

| Command              | Brief description                                                                                     | Ideal signature                                                                               |
| -------------------- | ----------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| `monad pack list`    | Lists installed and available language/framework/tooling packs.                                       | `monad pack list [--installed] [--available] [--registry <registry>] [--format text\|json]`   |
| `monad pack install` | Installs a pack such as TypeScript, Rust, Go, Python, Java, Next.js, TanStack Start, Docker, CI, etc. | `monad pack install <pack> [--version <version>] [--registry <registry>] [--yes] [--dry-run]` |
| `monad pack update`  | Updates one or more installed packs.                                                                  | `monad pack update [pack] [--to <version>] [--all] [--yes] [--dry-run]`                       |

## Plugin Commands

| Command                | Brief description                                                          | Ideal signature                                                                          |
| ---------------------- | -------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| `monad plugin list`    | Lists installed, enabled, disabled, and available plugins.                 | `monad plugin list [--installed] [--available] [--enabled] [--format text\|json]`        |
| `monad plugin install` | Installs a plugin from a registry, Git URL, local path, or package source. | `monad plugin install <source> [--name <name>] [--version <version>] [--enable] [--yes]` |
| `monad plugin remove`  | Removes or disables a plugin.                                              | `monad plugin remove <plugin> [--disable-only] [--yes] [--dry-run]`                      |

## Release Commands

| Command                 | Brief description                                                                                        | Ideal signature                                                                                                                 |
| ----------------------- | -------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| `monad release plan`    | Creates a release plan including changed packages, versions, changelog entries, tags, and publish steps. | `monad release plan [--since <ref>] [--version major\|minor\|patch\|prerelease] [--out <file>] [--format text\|json\|markdown]` |
| `monad release apply`   | Applies a release plan by updating versions, changelogs, tags, or release metadata.                      | `monad release apply <plan-file> [--no-tag] [--no-changelog] [--yes] [--dry-run]`                                               |
| `monad release publish` | Publishes release artifacts, packages, containers, or GitHub releases according to the release plan.     | `monad release publish [plan-file] [--registry <registry>] [--dry-run] [--yes]`                                                 |

## Context Commands

| Command                 | Brief description                                                                                                               | Ideal signature                                                                                                              |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `monad context pack`    | Generates an AI/developer context pack containing repo summary, structure, decisions, commands, package map, and current state. | `monad context pack [--scope <selector>] [--include docs,adr,graph,tasks,policies] [--out <path>] [--format markdown\|json]` |
| `monad context verify`  | Verifies that generated context is current, complete, non-stale, and consistent with repo state.                                | `monad context verify [--context <path>] [--strict] [--format text\|json]`                                                   |
| `monad context handoff` | Generates a handoff document for another developer, AI session, or future implementation phase.                                 | `monad context handoff [--scope <selector>] [--from <ref>] [--out <path>] [--format markdown\|json]`                         |

## Graph Commands

| Command                | Brief description                                                                                      | Ideal signature                                                                                                                      |
| ---------------------- | ------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------ |
| `monad graph projects` | Generates a graph of apps, packages, services, libraries, domains, and ownership relationships.        | `monad graph projects [--filter <selector>] [--format text\|json\|mermaid\|dot\|svg] [--out <file>]`                                 |
| `monad graph tasks`    | Generates the task graph for build, test, lint, deploy, release, and custom task dependencies.         | `monad graph tasks [task] [--filter <selector>] [--affected] [--format text\|json\|mermaid\|dot\|svg] [--out <file>]`                |
| `monad graph deps`     | Generates the dependency graph between packages, apps, services, libraries, and external dependencies. | `monad graph deps [--filter <selector>] [--include external\|internal\|all] [--format text\|json\|mermaid\|dot\|svg] [--out <file>]` |

## Docs Commands

| Command               | Brief description                                                                                                        | Ideal signature                                                                      |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------ |
| `monad docs generate` | Generates or refreshes documentation such as README files, package docs, command references, ADR indexes, and repo maps. | `monad docs generate [kind] [--scope <selector>] [--out <path>] [--yes] [--dry-run]` |
| `monad docs check`    | Checks documentation for missing files, stale generated sections, broken links, and invalid repo references.             | `monad docs check [--strict] [--fix] [--format text\|json]`                          |

## ADR Commands

| Command               | Brief description                                                                                     | Ideal signature                                                                                       |
| --------------------- | ----------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| `monad adr new`       | Creates a new Architecture Decision Record using the workspace ADR template and numbering convention. | `monad adr new <title> [--status proposed\|accepted\|deprecated\|superseded] [--tags <tags>] [--yes]` |
| `monad adr list`      | Lists ADRs with status, number, title, tags, and supersession relationships.                          | `monad adr list [--status <status>] [--tag <tag>] [--format text\|json\|markdown]`                    |
| `monad adr supersede` | Marks an ADR as superseded by another ADR and updates ADR metadata/indexes.                           | `monad adr supersede <old-adr> <new-adr> [--reason <text>] [--yes] [--dry-run]`                       |

## Work Packet Commands

| Command                 | Brief description                                                                                                     | Ideal signature                                                                                                     |
| ----------------------- | --------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| `monad workpacket new`  | Creates a new implementation work packet with scope, tasks, acceptance criteria, dependencies, and status.            | `monad workpacket new <title> [--epic <epic>] [--status planned\|active\|done] [--priority <priority>] [--yes]`     |
| `monad workpacket list` | Lists work packets by status, epic, priority, dependency, owner, or milestone.                                        | `monad workpacket list [--status <status>] [--epic <epic>] [--priority <priority>] [--format text\|json\|markdown]` |
| `monad workpacket plan` | Produces an implementation plan from one or more work packets, including order, dependencies, and suggested commands. | `monad workpacket plan [workpacket-id...] [--milestone <milestone>] [--out <file>] [--format text\|json\|markdown]` |

---

# Recommended Signature Pattern

For consistency, every command that can change files should support:

```txt
--dry-run
--yes
--format text|json
```

Every command that produces structured output should support:

```txt
--format text|json|markdown
--out <file>
```

Every command that operates on part of the workspace should support:

```txt
--filter <selector>
--scope <scope>
--affected
```

Every command that could be used in CI should support:

```txt
--strict
--json
--no-color
```

# My Recommended v1 Command Contract

The most important design rule is this:

```txt
Commands that inspect should not mutate.
Commands that mutate should support --dry-run.
Commands that produce changes should be plannable.
Commands that apply plans should be auditable.
Commands used in CI should support machine-readable output.
```

For `monad`, I would make this a formal CLI doctrine in the repo docs and tests.
