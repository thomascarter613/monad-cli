//! Graph primitives for Monad.

use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub enum GraphKind {
    Projects,
    Tasks,
    Deps,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct GraphSummary {
    pub kind: GraphKind,
    pub nodes: usize,
    pub edges: usize,
}
