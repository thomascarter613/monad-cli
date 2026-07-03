//! Plan primitives for mutating Monad operations.
//!
//! Monad mutating commands are expected to become plan-backed. At WP-0001 this
//! crate provides the minimal stable data model for representing a plan.

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PlanMode {
    DryRun,
    Apply,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum PlanStepKind {
    CreateFile,
    UpdateFile,
    DeleteFile,
    CreateDirectory,
    RunCommand,
    Validate,
    Other(String),
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PlanStep {
    pub kind: PlanStepKind,
    pub summary: String,
}

impl PlanStep {
    pub fn new(kind: PlanStepKind, summary: impl Into<String>) -> Self {
        Self {
            kind,
            summary: summary.into(),
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ChangePlan {
    pub operation: String,
    pub mode: PlanMode,
    pub steps: Vec<PlanStep>,
}

impl ChangePlan {
    pub fn dry_run(operation: impl Into<String>) -> Self {
        Self {
            operation: operation.into(),
            mode: PlanMode::DryRun,
            steps: Vec::new(),
        }
    }

    pub fn apply(operation: impl Into<String>) -> Self {
        Self {
            operation: operation.into(),
            mode: PlanMode::Apply,
            steps: Vec::new(),
        }
    }

    pub fn push_step(&mut self, step: PlanStep) {
        self.steps.push(step);
    }

    pub fn is_empty(&self) -> bool {
        self.steps.is_empty()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn dry_run_plan_starts_empty_and_accepts_steps() {
        let mut plan = ChangePlan::dry_run("add app web");
        assert_eq!(plan.mode, PlanMode::DryRun);
        assert!(plan.is_empty());

        plan.push_step(PlanStep::new(
            PlanStepKind::CreateDirectory,
            "create apps/web",
        ));

        assert!(!plan.is_empty());
        assert_eq!(plan.steps.len(), 1);
    }
}
