//! Plan, diff, and apply primitives for Monad.

use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct Plan {
    pub schema_version: u32,
    pub id: String,
    pub operation: String,
    pub steps: Vec<PlanStep>,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(tag = "kind", rename_all = "snake_case")]
pub enum PlanStep {
    CreateDir { path: String },
    CreateFile { path: String },
    UpdateFile { path: String },
    DeleteFile { path: String },
    MoveFile { from: String, to: String },
    CommandHint { command: String },
}

impl Plan {
    #[must_use]
    pub fn placeholder(operation: impl Into<String>) -> Self {
        let operation = operation.into();
        Self {
            schema_version: monad_core::PLAN_SCHEMA_VERSION,
            id: format!("plan_{operation}_placeholder"),
            operation,
            steps: Vec::new(),
        }
    }
}
