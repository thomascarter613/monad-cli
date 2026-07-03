#[test]
fn cli_crate_can_use_workspace_domain_crates() {
    let defaults = monad_core::RuntimeDefaults::monad();
    assert_eq!(defaults.cli_name, "monad");
    assert_eq!(defaults.scope, "@monad");

    let mut plan = monad_plans::ChangePlan::dry_run("add app web");
    plan.push_step(monad_plans::PlanStep::new(
        monad_plans::PlanStepKind::CreateDirectory,
        "create apps/web",
    ));
    assert_eq!(plan.steps.len(), 1);

    let pack =
        monad_packs::PackManifest::new("official.typescript", "Official TypeScript", "0.1.0")
            .with_capability("app");
    assert!(pack.provides("app"));

    let mut policy = monad_policy::PolicyCheckResult::default();
    policy.push(monad_policy::PolicyFinding::new(
        "MONAD_TEST",
        monad_policy::Severity::Warning,
        "test warning",
    ));
    assert!(!policy.has_blocking_findings());

    let context_pack = monad_context::ContextPack::new("WP-0001").include_file(
        monad_context::ContextFile::new("Cargo.toml", "workspace manifest"),
    );
    assert_eq!(context_pack.file_count(), 1);

    let mut graph = monad_graph::WorkspaceGraph::default();
    graph.add_node(monad_graph::GraphNode::new("crates/monad-cli", "crate"));
    assert_eq!(graph.node_count(), 1);
}
