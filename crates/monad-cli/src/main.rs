use clap::{Arg, ArgAction, ArgMatches, Command};
use serde::Serialize;

fn main() -> std::process::ExitCode {
    // __MONAD_NO_ARGS_HELP_GUARD__
    if std::env::args_os().len() == 1 {
        println!("monad\n\nDefault scope: @monad\n\nUsage: monad <COMMAND>\n\nRun `monad --help` for full command help.");
        std::process::exit(0);
    }

    match run() {
        Ok(()) => std::process::ExitCode::SUCCESS,
        Err(error) => {
            eprintln!("error: {error}");
            std::process::ExitCode::from(1)
        }
    }
}

fn run() -> Result<(), String> {
    let matches = cli().get_matches();
    let json = matches.get_flag("json");

    match matches.subcommand() {
        Some(("version", sub)) => emit_version(sub, json),
        Some(("pack", sub)) if matches_subcommand(sub, "list") => emit_pack_list(json),
        Some((command, sub)) => {
            emit_placeholder(json, command_path(command, sub), mutates(command))
        }
        None => Ok(()),
    }
}

fn cli() -> Command {
    Command::new("monad")
        .version(env!("CARGO_PKG_VERSION"))
        .about("Governed monorepo operating-system CLI")
        .long_about("Monad initializes, modifies, evolves, validates, documents, graphs, governs, and manages serious monorepos.")
        .arg(flag("json", "Emit machine-readable JSON output").global(true))
        .arg(flag("no-color", "Disable color output").global(true))
        .subcommand(init_cmd())
        .subcommand(add_cmd())
        .subcommand(remove_cmd())
        .subcommand(rename_cmd())
        .subcommand(move_cmd())
        .subcommand(list_cmd())
        .subcommand(inspect_cmd())
        .subcommand(check_cmd())
        .subcommand(doctor_cmd())
        .subcommand(plan_cmd())
        .subcommand(apply_cmd())
        .subcommand(diff_cmd())
        .subcommand(generate_cmd())
        .subcommand(sync_cmd())
        .subcommand(run_cmd())
        .subcommand(build_cmd())
        .subcommand(test_cmd())
        .subcommand(lint_cmd())
        .subcommand(format_cmd())
        .subcommand(graph_cmd())
        .subcommand(clean_cmd())
        .subcommand(migrate_cmd())
        .subcommand(upgrade_cmd())
        .subcommand(context_cmd())
        .subcommand(config_cmd())
        .subcommand(version_cmd())
        .subcommand(policy_cmd())
        .subcommand(template_cmd())
        .subcommand(pack_cmd())
        .subcommand(plugin_cmd())
        .subcommand(release_cmd())
        .subcommand(docs_cmd())
        .subcommand(adr_cmd())
        .subcommand(workpacket_cmd())
}

fn arg(name: &'static str, help: &'static str) -> Arg {
    Arg::new(name).help(help)
}

fn flag(name: &'static str, help: &'static str) -> Arg {
    Arg::new(name)
        .long(name)
        .help(help)
        .action(ArgAction::SetTrue)
}

fn opt(name: &'static str, help: &'static str) -> Arg {
    Arg::new(name).long(name).help(help).num_args(1)
}

fn fmt_arg() -> Arg {
    opt("format", "Output format")
        .value_parser(["text", "json", "markdown"])
        .default_value("text")
}

fn graph_fmt_arg() -> Arg {
    opt("format", "Graph output format")
        .value_parser(["text", "json", "mermaid", "dot", "svg"])
        .default_value("text")
}

fn init_cmd() -> Command {
    Command::new("init")
        .about("Initialize a new governed monorepo/workspace foundation")
        .arg(arg("path", "Target path").required(false))
        .arg(opt("name", "Workspace name").required(true))
        .arg(
            opt("preset", "Init preset")
                .value_parser(["minimal", "standard", "governed", "ai-ready", "maximal"])
                .default_value("governed"),
        )
        .arg(
            opt("package-manager", "Package manager")
                .value_parser(["bun", "pnpm", "npm", "yarn"])
                .default_value("bun"),
        )
        .arg(opt("template", "Template name"))
        .arg(flag("yes", "Skip safe confirmations"))
        .arg(flag("dry-run", "Preview without writing"))
}

fn add_cmd() -> Command {
    Command::new("add")
        .about("Add a workspace unit or managed capability")
        .arg(arg("kind", "Unit kind").required(true))
        .arg(arg("name", "Unit name").required(true))
        .arg(opt("to", "Destination path"))
        .arg(opt("language", "Language"))
        .arg(opt("framework", "Framework"))
        .arg(opt("template", "Template"))
        .arg(opt("scope", "Package scope").default_value("@monad"))
        .arg(flag("yes", "Skip safe confirmations"))
        .arg(flag("dry-run", "Preview without writing"))
}

fn remove_cmd() -> Command {
    Command::new("remove")
        .about("Safely remove a workspace unit or managed capability")
        .arg(arg("target", "Target entity").required(true))
        .arg(flag(
            "keep-files",
            "Remove management metadata but keep files",
        ))
        .arg(flag("force", "Force where safe"))
        .arg(flag("yes", "Skip safe confirmations"))
        .arg(flag("dry-run", "Preview without writing"))
}

fn rename_cmd() -> Command {
    Command::new("rename")
        .about("Rename a workspace entity while preserving references")
        .arg(arg("target", "Target entity").required(true))
        .arg(arg("new-name", "New name").required(true))
        .arg(flag("update-imports", "Update imports where supported"))
        .arg(flag("update-manifests", "Update manifests"))
        .arg(flag("yes", "Skip safe confirmations"))
        .arg(flag("dry-run", "Preview without writing"))
}

fn move_cmd() -> Command {
    Command::new("move")
        .about("Move a workspace entity while preserving metadata")
        .arg(arg("target", "Target entity").required(true))
        .arg(arg("destination", "Destination path").required(true))
        .arg(flag("update-imports", "Update imports where supported"))
        .arg(flag("update-manifests", "Update manifests"))
        .arg(flag("yes", "Skip safe confirmations"))
        .arg(flag("dry-run", "Preview without writing"))
}

fn list_cmd() -> Command {
    Command::new("list")
        .about("List workspace entities")
        .arg(arg("kind", "Entity kind").required(false))
        .arg(opt("scope", "Scope"))
        .arg(fmt_arg())
}

fn inspect_cmd() -> Command {
    Command::new("inspect")
        .about("Inspect workspace structure, metadata, dependencies, and tooling state")
        .arg(arg("target", "Target entity").required(false))
        .arg(opt("depth", "Depth"))
        .arg(opt("include", "Comma-separated sections"))
        .arg(fmt_arg())
}

fn check_cmd() -> Command {
    Command::new("check")
        .about("Run baseline correctness checks")
        .arg(arg("target", "Target entity").required(false))
        .arg(flag("strict", "Enable strict mode"))
        .arg(flag("fix", "Apply safe fixes where supported"))
        .arg(fmt_arg().value_parser(["text", "json"]))
}

fn doctor_cmd() -> Command {
    Command::new("doctor")
        .about("Diagnose environment, tooling, repo, cache, and policy problems")
        .arg(flag("fix", "Apply safe fixes where supported"))
        .arg(opt("include", "Comma-separated diagnostic areas"))
        .arg(fmt_arg().value_parser(["text", "json"]))
}

fn plan_cmd() -> Command {
    Command::new("plan")
        .about("Produce a change plan before modifying the repository")
        .arg(arg("operation", "Operation").required(true))
        .arg(
            arg("args", "Operation arguments")
                .num_args(0..)
                .trailing_var_arg(true),
        )
        .arg(opt("out", "Output file"))
        .arg(fmt_arg())
}

fn apply_cmd() -> Command {
    Command::new("apply")
        .about("Apply a previously generated plan")
        .arg(arg("plan-file", "Plan file").required(true))
        .arg(flag("yes", "Skip safe confirmations"))
        .arg(flag("dry-run", "Preview without writing"))
        .arg(flag(
            "rollback-on-error",
            "Rollback on error where possible",
        ))
}

fn diff_cmd() -> Command {
    Command::new("diff")
        .about("Show proposed, staged, or actual repository changes")
        .arg(arg("plan-file", "Plan file").required(false))
        .arg(opt("against", "Diff target").value_parser(["git", "workspace", "snapshot"]))
        .arg(
            opt("format", "Output format")
                .value_parser(["text", "json", "patch"])
                .default_value("text"),
        )
}

fn generate_cmd() -> Command {
    Command::new("generate")
        .about("Generate code, configs, docs, manifests, scaffolds, or policies")
        .arg(arg("kind", "Generated artifact kind").required(true))
        .arg(arg("name", "Artifact name").required(true))
        .arg(opt("to", "Destination path"))
        .arg(opt("template", "Template"))
        .arg(opt("data", "Data file"))
        .arg(flag("yes", "Skip safe confirmations"))
        .arg(flag("dry-run", "Preview without writing"))
}

fn sync_cmd() -> Command {
    Command::new("sync")
        .about("Synchronize Monad intent with native tool configs")
        .arg(opt("from", "Source").value_parser(["monad", "native"]))
        .arg(opt("target", "Target tool"))
        .arg(flag("check", "Check only"))
        .arg(flag("write", "Write changes"))
        .arg(flag("dry-run", "Preview without writing"))
}

fn run_cmd() -> Command {
    Command::new("run")
        .about("Run a named workspace task")
        .arg(arg("task", "Task name").required(true))
        .arg(opt("filter", "Target selector"))
        .arg(flag("affected", "Only affected units"))
        .arg(opt("parallel", "Parallelism"))
        .arg(opt("since", "Git ref"))
}

fn build_cmd() -> Command {
    Command::new("build")
        .about("Build workspace units")
        .arg(arg("target", "Target").required(false))
        .arg(opt("filter", "Target selector"))
        .arg(flag("affected", "Only affected units"))
        .arg(flag("production", "Production build"))
        .arg(opt("parallel", "Parallelism"))
}

fn test_cmd() -> Command {
    Command::new("test")
        .about("Run tests")
        .arg(arg("target", "Target").required(false))
        .arg(opt("filter", "Target selector"))
        .arg(flag("affected", "Only affected units"))
        .arg(flag("unit", "Unit tests"))
        .arg(flag("integration", "Integration tests"))
        .arg(flag("e2e", "End-to-end tests"))
        .arg(flag("coverage", "Coverage"))
}

fn lint_cmd() -> Command {
    Command::new("lint")
        .about("Run linting and static analysis")
        .arg(arg("target", "Target").required(false))
        .arg(opt("filter", "Target selector"))
        .arg(flag("affected", "Only affected units"))
        .arg(flag("fix", "Apply safe fixes"))
        .arg(fmt_arg().value_parser(["text", "json"]))
}

fn format_cmd() -> Command {
    Command::new("format")
        .about("Format source files, configs, docs, and generated files")
        .arg(arg("target", "Target").required(false))
        .arg(flag("check", "Check formatting"))
        .arg(flag("write", "Write formatting changes"))
        .arg(opt("filter", "Target selector"))
}

fn graph_cmd() -> Command {
    Command::new("graph")
        .about("Produce workspace graphs")
        .arg(
            opt("type", "Graph type")
                .long("type")
                .value_parser(["projects", "tasks", "deps"]),
        )
        .arg(opt("filter", "Target selector"))
        .arg(graph_fmt_arg())
        .arg(opt("out", "Output file"))
        .subcommand(graph_projects_cmd())
        .subcommand(graph_tasks_cmd())
        .subcommand(graph_deps_cmd())
}

fn graph_projects_cmd() -> Command {
    Command::new("projects")
        .about("Generate project graph")
        .arg(opt("filter", "Target selector"))
        .arg(graph_fmt_arg())
        .arg(opt("out", "Output file"))
}

fn graph_tasks_cmd() -> Command {
    Command::new("tasks")
        .about("Generate task graph")
        .arg(arg("task", "Task").required(false))
        .arg(opt("filter", "Target selector"))
        .arg(flag("affected", "Only affected units"))
        .arg(graph_fmt_arg())
        .arg(opt("out", "Output file"))
}

fn graph_deps_cmd() -> Command {
    Command::new("deps")
        .about("Generate dependency graph")
        .arg(opt("filter", "Target selector"))
        .arg(
            opt("include", "Dependency inclusion")
                .value_parser(["external", "internal", "all"])
                .default_value("all"),
        )
        .arg(graph_fmt_arg())
        .arg(opt("out", "Output file"))
}

fn clean_cmd() -> Command {
    Command::new("clean")
        .about("Remove generated state, caches, build output, or temp files")
        .arg(arg("target", "Target").required(false))
        .arg(flag("cache", "Clean cache"))
        .arg(flag("dist", "Clean dist/build outputs"))
        .arg(flag("temp", "Clean temporary files"))
        .arg(flag("state", "Clean Monad state"))
        .arg(flag("all", "Clean all supported generated outputs"))
        .arg(flag("yes", "Skip safe confirmations"))
        .arg(flag("dry-run", "Preview without writing"))
}

fn migrate_cmd() -> Command {
    Command::new("migrate")
        .about("Migrate repo structure, config formats, package managers, or schema versions")
        .arg(arg("migration", "Migration name").required(true))
        .arg(opt("from", "From version"))
        .arg(opt("to", "To version"))
        .arg(flag("yes", "Skip safe confirmations"))
        .arg(flag("dry-run", "Preview without writing"))
}

fn upgrade_cmd() -> Command {
    Command::new("upgrade")
        .about("Upgrade Monad-managed templates, packs, plugins, schemas, or conventions")
        .arg(arg("target", "Target").required(false))
        .arg(opt("to", "Version"))
        .arg(flag("templates", "Upgrade templates"))
        .arg(flag("packs", "Upgrade packs"))
        .arg(flag("plugins", "Upgrade plugins"))
        .arg(flag("schema", "Upgrade schema"))
        .arg(flag("yes", "Skip safe confirmations"))
        .arg(flag("dry-run", "Preview without writing"))
}

fn context_cmd() -> Command {
    Command::new("context")
        .about("Manage AI/developer context artifacts")
        .arg(fmt_arg())
        .subcommand(context_pack_cmd())
        .subcommand(context_verify_cmd())
        .subcommand(context_handoff_cmd())
}

fn context_pack_cmd() -> Command {
    Command::new("pack")
        .about("Generate context pack")
        .arg(opt("scope", "Scope selector"))
        .arg(opt("include", "Comma-separated included sections"))
        .arg(opt("out", "Output path"))
        .arg(
            opt("format", "Output format")
                .value_parser(["markdown", "json"])
                .default_value("markdown"),
        )
}

fn context_verify_cmd() -> Command {
    Command::new("verify")
        .about("Verify context freshness and completeness")
        .arg(opt("context", "Context path"))
        .arg(flag("strict", "Strict verification"))
        .arg(fmt_arg().value_parser(["text", "json"]))
}

fn context_handoff_cmd() -> Command {
    Command::new("handoff")
        .about("Generate handoff document")
        .arg(opt("scope", "Scope selector"))
        .arg(opt("from", "Git ref"))
        .arg(opt("out", "Output path"))
        .arg(
            opt("format", "Output format")
                .value_parser(["markdown", "json"])
                .default_value("markdown"),
        )
}

fn config_cmd() -> Command {
    Command::new("config")
        .about("Read, write, validate, or explain Monad configuration")
        .subcommand(
            Command::new("get")
                .arg(arg("key", "Key").required(true))
                .arg(scope_flags())
                .arg(fmt_arg()),
        )
        .subcommand(
            Command::new("set")
                .arg(arg("key", "Key").required(true))
                .arg(arg("value", "Value").required(true))
                .arg(scope_flags())
                .arg(fmt_arg()),
        )
        .subcommand(
            Command::new("unset")
                .arg(arg("key", "Key").required(true))
                .arg(scope_flags()),
        )
        .subcommand(Command::new("list").arg(scope_flags()).arg(fmt_arg()))
        .subcommand(Command::new("validate").arg(fmt_arg()))
}

fn scope_flags() -> Arg {
    // Clap cannot add a group of args through one helper. This placeholder arg
    // keeps config help compact in WP-0001; later packets can expand it.
    opt("scope", "Config scope: global or workspace").value_parser(["global", "workspace"])
}

fn version_cmd() -> Command {
    Command::new("version")
        .about("Print Monad CLI and workspace version information")
        .arg(flag("verbose", "Show verbose version information"))
}

fn policy_cmd() -> Command {
    Command::new("policy")
        .about("Manage governance policies")
        .subcommand(
            Command::new("check")
                .arg(arg("target", "Target").required(false))
                .arg(opt("policy", "Policy ID"))
                .arg(opt("severity", "Minimum severity").value_parser(["error", "warn", "info"]))
                .arg(
                    opt("format", "Output format")
                        .value_parser(["text", "json", "sarif"])
                        .default_value("text"),
                ),
        )
        .subcommand(
            Command::new("waive")
                .arg(arg("policy-id", "Policy ID").required(true))
                .arg(opt("target", "Target").required(true))
                .arg(opt("reason", "Reason").required(true))
                .arg(opt("owner", "Owner").required(true))
                .arg(opt("expires", "Expiration date"))
                .arg(flag("dry-run", "Preview without writing")),
        )
        .subcommand(
            Command::new("explain")
                .arg(arg("id", "Policy or finding ID").required(true))
                .arg(opt("target", "Target"))
                .arg(fmt_arg()),
        )
}

fn template_cmd() -> Command {
    Command::new("template")
        .about("Manage templates")
        .subcommand(
            Command::new("list")
                .arg(opt("source", "Template source").value_parser([
                    "local",
                    "workspace",
                    "official",
                    "registry",
                ]))
                .arg(opt("kind", "Template kind"))
                .arg(fmt_arg().value_parser(["text", "json"])),
        )
        .subcommand(
            Command::new("add")
                .arg(arg("source", "Template source").required(true))
                .arg(opt("name", "Name"))
                .arg(opt("kind", "Kind"))
                .arg(flag("global", "Install globally"))
                .arg(flag("workspace", "Install in workspace"))
                .arg(flag("yes", "Skip safe confirmations")),
        )
        .subcommand(
            Command::new("inspect")
                .arg(arg("template", "Template").required(true))
                .arg(fmt_arg()),
        )
}

fn pack_cmd() -> Command {
    Command::new("pack")
        .about("Manage language, framework, and tooling packs")
        .subcommand(
            Command::new("list")
                .arg(flag("installed", "Show installed packs"))
                .arg(flag("available", "Show available packs"))
                .arg(opt("registry", "Registry"))
                .arg(fmt_arg().value_parser(["text", "json"])),
        )
        .subcommand(
            Command::new("install")
                .arg(arg("pack", "Pack").required(true))
                .arg(opt("version", "Version"))
                .arg(opt("registry", "Registry"))
                .arg(flag("yes", "Skip safe confirmations"))
                .arg(flag("dry-run", "Preview without writing")),
        )
        .subcommand(
            Command::new("update")
                .arg(arg("pack", "Pack").required(false))
                .arg(opt("to", "Version"))
                .arg(flag("all", "Update all"))
                .arg(flag("yes", "Skip safe confirmations"))
                .arg(flag("dry-run", "Preview without writing")),
        )
}

fn plugin_cmd() -> Command {
    Command::new("plugin")
        .about("Manage declarative plugin adapters")
        .subcommand(
            Command::new("list")
                .arg(flag("installed", "Show installed"))
                .arg(flag("available", "Show available"))
                .arg(flag("enabled", "Show enabled"))
                .arg(fmt_arg().value_parser(["text", "json"])),
        )
        .subcommand(
            Command::new("install")
                .arg(arg("source", "Source").required(true))
                .arg(opt("name", "Name"))
                .arg(opt("version", "Version"))
                .arg(flag("enable", "Enable after install"))
                .arg(flag("yes", "Skip safe confirmations")),
        )
        .subcommand(
            Command::new("remove")
                .arg(arg("plugin", "Plugin").required(true))
                .arg(flag("disable-only", "Disable but do not remove"))
                .arg(flag("yes", "Skip safe confirmations"))
                .arg(flag("dry-run", "Preview without writing")),
        )
}

fn release_cmd() -> Command {
    Command::new("release")
        .about("Plan, apply, and publish releases")
        .subcommand(
            Command::new("plan")
                .arg(opt("since", "Git ref"))
                .arg(opt("version", "Version bump").value_parser([
                    "major",
                    "minor",
                    "patch",
                    "prerelease",
                ]))
                .arg(opt("out", "Output file"))
                .arg(fmt_arg()),
        )
        .subcommand(
            Command::new("apply")
                .arg(arg("plan-file", "Plan file").required(true))
                .arg(flag("no-tag", "Do not tag"))
                .arg(flag("no-changelog", "Do not update changelog"))
                .arg(flag("yes", "Skip safe confirmations"))
                .arg(flag("dry-run", "Preview without writing")),
        )
        .subcommand(
            Command::new("publish")
                .arg(arg("plan-file", "Plan file").required(false))
                .arg(opt("registry", "Registry"))
                .arg(flag("dry-run", "Preview without writing"))
                .arg(flag("yes", "Skip safe confirmations")),
        )
}

fn docs_cmd() -> Command {
    Command::new("docs")
        .about("Generate and check documentation")
        .subcommand(
            Command::new("generate")
                .arg(arg("kind", "Doc kind").required(false))
                .arg(opt("scope", "Scope selector"))
                .arg(opt("out", "Output path"))
                .arg(flag("yes", "Skip safe confirmations"))
                .arg(flag("dry-run", "Preview without writing")),
        )
        .subcommand(
            Command::new("check")
                .arg(flag("strict", "Strict mode"))
                .arg(flag("fix", "Apply safe fixes"))
                .arg(fmt_arg().value_parser(["text", "json"])),
        )
}

fn adr_cmd() -> Command {
    Command::new("adr")
        .about("Create, list, and supersede Architecture Decision Records")
        .subcommand(
            Command::new("new")
                .arg(arg("title", "ADR title").required(true))
                .arg(opt("status", "Status").value_parser([
                    "proposed",
                    "accepted",
                    "deprecated",
                    "superseded",
                ]))
                .arg(opt("tags", "Comma-separated tags"))
                .arg(flag("yes", "Skip safe confirmations")),
        )
        .subcommand(
            Command::new("list")
                .arg(opt("status", "Status"))
                .arg(opt("tag", "Tag"))
                .arg(fmt_arg()),
        )
        .subcommand(
            Command::new("supersede")
                .arg(arg("old-adr", "Old ADR").required(true))
                .arg(arg("new-adr", "New ADR").required(true))
                .arg(opt("reason", "Reason"))
                .arg(flag("yes", "Skip safe confirmations"))
                .arg(flag("dry-run", "Preview without writing")),
        )
}

fn workpacket_cmd() -> Command {
    Command::new("workpacket")
        .about("Create, list, and plan implementation work packets")
        .subcommand(
            Command::new("new")
                .arg(arg("title", "Work packet title").required(true))
                .arg(opt("epic", "Epic"))
                .arg(opt("status", "Status"))
                .arg(opt("priority", "Priority"))
                .arg(flag("yes", "Skip safe confirmations")),
        )
        .subcommand(
            Command::new("list")
                .arg(opt("status", "Status"))
                .arg(opt("epic", "Epic"))
                .arg(opt("priority", "Priority"))
                .arg(fmt_arg()),
        )
        .subcommand(
            Command::new("plan")
                .arg(arg("workpacket-ids", "Work packet IDs").num_args(0..))
                .arg(opt("milestone", "Milestone"))
                .arg(opt("out", "Output file"))
                .arg(fmt_arg()),
        )
}

fn command_path(command: &str, sub: &ArgMatches) -> String {
    if let Some((nested, _)) = sub.subcommand() {
        format!("{command} {nested}")
    } else {
        command.to_string()
    }
}

fn matches_subcommand(sub: &ArgMatches, name: &str) -> bool {
    sub.subcommand().is_some_and(|(nested, _)| nested == name)
}

fn mutates(command: &str) -> bool {
    matches!(
        command,
        "init"
            | "add"
            | "remove"
            | "rename"
            | "move"
            | "apply"
            | "generate"
            | "sync"
            | "format"
            | "clean"
            | "migrate"
            | "upgrade"
            | "context"
            | "config"
            | "policy"
            | "template"
            | "pack"
            | "plugin"
            | "release"
            | "docs"
            | "adr"
            | "workpacket"
    )
}

#[derive(Serialize)]
struct CommandOutcome {
    ok: bool,
    command: String,
    status: &'static str,
    message: String,
    mutates_files: bool,
    plan_backed: bool,
}

fn emit_placeholder(json: bool, command: String, mutates_files: bool) -> Result<(), String> {
    let outcome = CommandOutcome {
        ok: true,
        command: command.clone(),
        status: "placeholder",
        message: format!("{command} is present in the WP-0001 CLI skeleton; behavior arrives in later work packets."),
        mutates_files,
        plan_backed: mutates_files,
    };

    if json {
        println!(
            "{}",
            serde_json::to_string_pretty(&outcome).map_err(|error| error.to_string())?
        );
    } else {
        println!("{}", outcome.message);
    }

    Ok(())
}

fn emit_pack_list(json: bool) -> Result<(), String> {
    let packs = monad_packs::builtin_packs();

    if json {
        println!(
            "{}",
            serde_json::to_string_pretty(&packs).map_err(|error| error.to_string())?
        );
    } else {
        for pack in packs {
            println!("{} ({}) - {}", pack.name, pack.kind, pack.description);
        }
    }

    Ok(())
}

fn emit_version(matches: &ArgMatches, json: bool) -> Result<(), String> {
    #[derive(Serialize)]
    struct VersionOutput {
        ok: bool,
        cli: &'static str,
        version: &'static str,
        manifest_schema_version: u32,
        plan_schema_version: u32,
        canonical_manifest: &'static str,
        compatibility_manifest: &'static str,
        default_scope: &'static str,
        verbose: bool,
    }

    let verbose = matches.get_flag("verbose");
    let output = VersionOutput {
        ok: true,
        cli: monad_core::CLI_NAME,
        version: env!("CARGO_PKG_VERSION"),
        manifest_schema_version: monad_core::MANIFEST_SCHEMA_VERSION,
        plan_schema_version: monad_core::PLAN_SCHEMA_VERSION,
        canonical_manifest: monad_core::CANONICAL_MANIFEST,
        compatibility_manifest: monad_core::COMPATIBILITY_MANIFEST,
        default_scope: monad_core::DEFAULT_SCOPE,
        verbose,
    };

    if json {
        println!(
            "{}",
            serde_json::to_string_pretty(&output).map_err(|error| error.to_string())?
        );
    } else if verbose {
        println!("monad {}", env!("CARGO_PKG_VERSION"));
        println!("manifest schema {}", monad_core::MANIFEST_SCHEMA_VERSION);
        println!("plan schema {}", monad_core::PLAN_SCHEMA_VERSION);
        println!("canonical manifest {}", monad_core::CANONICAL_MANIFEST);
        println!(
            "compatibility manifest {}",
            monad_core::COMPATIBILITY_MANIFEST
        );
        println!("default scope {}", monad_core::DEFAULT_SCOPE);
    } else {
        println!("monad {}", env!("CARGO_PKG_VERSION"));
    }

    Ok(())
}
