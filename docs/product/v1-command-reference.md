# Monad v1 Command Reference

This document is the approved v1 command surface for Monad.

## Signature conventions

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

## Top-Level Commands

| Command | Brief description | Ideal signature |
|---|---|---|
| `monad init` | Initializes a new monorepo/workspace foundation with manifests, docs, tooling, policies, and default structure. | `monad init [path] --name <name> [--preset <preset>] [--package-manager bun|pnpm|npm|yarn] [--template <template>] [--yes] [--dry-run]` |
| `monad add` | Adds a new app, service, package, library, tool, config, policy, or capability to the workspace. | `monad add <kind> <name> [--to <path>] [--language <lang>] [--framework <framework>] [--template <template>] [--scope <scope>] [--yes] [--dry-run]` |
| `monad remove` | Safely removes a workspace unit or managed capability with dependency and reference checks. | `monad remove <target> [--keep-files] [--force] [--yes] [--dry-run]` |
| `monad rename` | Renames a package, app, service, scope, domain, module, or workspace entity while updating references. | `monad rename <target> <new-name> [--update-imports] [--update-manifests] [--yes] [--dry-run]` |
| `monad move` | Moves a package, app, service, library, or module to a new location while preserving workspace metadata. | `monad move <target> <destination> [--update-imports] [--update-manifests] [--yes] [--dry-run]` |
| `monad list` | Lists workspace entities such as apps, packages, services, tasks, templates, plugins, policies, and commands. | `monad list [kind] [--scope <scope>] [--format text|json|markdown]` |
| `monad inspect` | Inspects the current repo structure, workspace manifest, dependency graph, package metadata, and tooling state. | `monad inspect [target] [--depth <n>] [--include files,tasks,deps,policies] [--format text|json|markdown]` |
| `monad check` | Runs baseline correctness checks against workspace structure, manifests, generated files, and expected tooling. | `monad check [target] [--strict] [--fix] [--format text|json]` |
| `monad doctor` | Diagnoses environment/tooling problems such as missing runtimes, broken package managers, bad configs, or invalid workspace state. | `monad doctor [--fix] [--include env,tools,repo,cache,policy] [--format text|json]` |
| `monad plan` | Produces a change plan before modifying the repository. | `monad plan <operation> [args...] [--out <file>] [--format text|json|markdown]` |
| `monad apply` | Applies a previously generated plan or staged change set. | `monad apply <plan-file> [--yes] [--dry-run] [--rollback-on-error]` |
| `monad diff` | Shows proposed, staged, or actual repo changes. | `monad diff [plan-file] [--against git|workspace|snapshot] [--format text|json|patch]` |
| `monad generate` | Generates code, configs, docs, manifests, scaffolds, policies, or context artifacts. | `monad generate <kind> <name> [--to <path>] [--template <template>] [--data <file>] [--yes] [--dry-run]` |
| `monad sync` | Synchronizes Monad source-of-truth metadata with native tool configs. | `monad sync [--from monad|native] [--target <tool>] [--check] [--write] [--dry-run]` |
| `monad run` | Runs a named workspace task using the configured task runner. | `monad run <task> [--filter <selector>] [--affected] [--parallel <n>] [--since <ref>]` |
| `monad build` | Builds one or more apps, packages, services, or the full workspace. | `monad build [target] [--filter <selector>] [--affected] [--production] [--parallel <n>]` |
| `monad test` | Runs tests for one or more workspace units. | `monad test [target] [--filter <selector>] [--affected] [--unit] [--integration] [--e2e] [--coverage]` |
| `monad lint` | Runs linting and static analysis across the workspace or selected targets. | `monad lint [target] [--filter <selector>] [--affected] [--fix] [--format text|json]` |
| `monad format` | Formats source files, configs, docs, and generated files. | `monad format [target] [--check] [--write] [--filter <selector>]` |
| `monad graph` | Produces workspace graph output. | `monad graph [--type projects|tasks|deps] [--filter <selector>] [--format text|json|mermaid|dot] [--out <file>]` |
| `monad clean` | Removes generated state, caches, temporary files, build output, or stale Monad metadata. | `monad clean [target] [--cache] [--dist] [--temp] [--state] [--all] [--yes] [--dry-run]` |
| `monad migrate` | Migrates repository structure, manifests, package manager config, framework versions, or Monad schema versions. | `monad migrate <migration> [--from <version>] [--to <version>] [--yes] [--dry-run]` |
| `monad upgrade` | Upgrades Monad-managed templates, packs, plugins, schemas, or workspace conventions. | `monad upgrade [target] [--to <version>] [--templates] [--packs] [--plugins] [--schema] [--yes] [--dry-run]` |
| `monad context` | Manages AI/developer context artifacts. | `monad context [pack|verify|handoff] [args...] [--format text|json|markdown]` |
| `monad config` | Reads, writes, validates, or explains Monad workspace and user configuration. | `monad config <get|set|unset|list|validate> [key] [value] [--global] [--workspace] [--format text|json]` |
| `monad version` | Prints the Monad CLI version, workspace schema version, and optionally environment/tool versions. | `monad version [--verbose] [--json]` |

## Namespaced Commands

| Command | Brief description | Ideal signature |
|---|---|---|
| `monad policy check` | Checks workspace policies. | `monad policy check [target] [--policy <policy>] [--severity error|warn|info] [--format text|json|sarif]` |
| `monad policy waive` | Creates a controlled policy waiver. | `monad policy waive <policy-id> --target <target> --reason <text> --owner <owner> [--expires <date>] [--dry-run]` |
| `monad policy explain` | Explains a policy rule, violation, waiver, or enforcement decision. | `monad policy explain <policy-id|finding-id> [--target <target>] [--format text|json|markdown]` |
| `monad template list` | Lists templates. | `monad template list [--source local|workspace|official|registry] [--kind <kind>] [--format text|json]` |
| `monad template add` | Adds or installs a template. | `monad template add <source> [--name <name>] [--kind <kind>] [--global] [--workspace] [--yes]` |
| `monad template inspect` | Shows template metadata. | `monad template inspect <template> [--format text|json|markdown]` |
| `monad pack list` | Lists packs. | `monad pack list [--installed] [--available] [--registry <registry>] [--format text|json]` |
| `monad pack install` | Installs a pack. | `monad pack install <pack> [--version <version>] [--registry <registry>] [--yes] [--dry-run]` |
| `monad pack update` | Updates packs. | `monad pack update [pack] [--to <version>] [--all] [--yes] [--dry-run]` |
| `monad plugin list` | Lists plugins. | `monad plugin list [--installed] [--available] [--enabled] [--format text|json]` |
| `monad plugin install` | Installs a plugin adapter. | `monad plugin install <source> [--name <name>] [--version <version>] [--enable] [--yes]` |
| `monad plugin remove` | Removes or disables a plugin. | `monad plugin remove <plugin> [--disable-only] [--yes] [--dry-run]` |
| `monad release plan` | Creates a release plan. | `monad release plan [--since <ref>] [--version major|minor|patch|prerelease] [--out <file>] [--format text|json|markdown]` |
| `monad release apply` | Applies a release plan. | `monad release apply <plan-file> [--no-tag] [--no-changelog] [--yes] [--dry-run]` |
| `monad release publish` | Publishes release artifacts or performs a release dry run. | `monad release publish [plan-file] [--registry <registry>] [--dry-run] [--yes]` |
| `monad context pack` | Generates an AI/developer context pack. | `monad context pack [--scope <selector>] [--include docs,adr,graph,tasks,policies] [--out <path>] [--format markdown|json]` |
| `monad context verify` | Verifies generated context. | `monad context verify [--context <path>] [--strict] [--format text|json]` |
| `monad context handoff` | Generates a handoff document. | `monad context handoff [--scope <selector>] [--from <ref>] [--out <path>] [--format markdown|json]` |
| `monad graph projects` | Generates project graph. | `monad graph projects [--filter <selector>] [--format text|json|mermaid|dot] [--out <file>]` |
| `monad graph tasks` | Generates task graph. | `monad graph tasks [task] [--filter <selector>] [--affected] [--format text|json|mermaid|dot] [--out <file>]` |
| `monad graph deps` | Generates dependency graph. | `monad graph deps [--filter <selector>] [--include external|internal|all] [--format text|json|mermaid|dot] [--out <file>]` |
| `monad docs generate` | Generates or refreshes documentation. | `monad docs generate [kind] [--scope <selector>] [--out <path>] [--yes] [--dry-run]` |
| `monad docs check` | Checks documentation. | `monad docs check [--strict] [--fix] [--format text|json]` |
| `monad adr new` | Creates an ADR. | `monad adr new <title> [--status proposed|accepted|deprecated|superseded] [--tags <tags>] [--yes]` |
| `monad adr list` | Lists ADRs. | `monad adr list [--status <status>] [--tag <tag>] [--format text|json|markdown]` |
| `monad adr supersede` | Supersedes an ADR. | `monad adr supersede <old-adr> <new-adr> [--reason <text>] [--yes] [--dry-run]` |
| `monad workpacket new` | Creates a structured work packet. | `monad workpacket new <title> [--epic <epic>] [--status planned|active|done] [--priority <priority>] [--yes]` |
| `monad workpacket list` | Lists work packets. | `monad workpacket list [--status <status>] [--epic <epic>] [--priority <priority>] [--format text|json|markdown]` |
| `monad workpacket plan` | Produces an implementation plan from work packets. | `monad workpacket plan [workpacket-id...] [--milestone <milestone>] [--out <file>] [--format text|json|markdown]` |

## Command Contract

```txt
Commands that inspect should not mutate.
Commands that mutate should support --dry-run.
Commands that produce changes should be plannable.
Commands that apply plans should be auditable.
Commands used in CI should support machine-readable output.
```
