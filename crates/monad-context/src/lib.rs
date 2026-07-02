//! Context pack and handoff primitives for Monad.

use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct ContextArtifact {
    pub kind: ContextArtifactKind,
    pub path: String,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub enum ContextArtifactKind {
    CurrentState,
    RepoMap,
    CommandCatalog,
    Handoff,
}
