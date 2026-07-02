//! Core workspace model and shared constants for Monad.

use serde::{Deserialize, Serialize};

pub const CLI_NAME: &str = "monad";
pub const CANONICAL_MANIFEST: &str = "monad.toml";
pub const COMPATIBILITY_MANIFEST: &str = "workspace.toml";
pub const LOCKFILE: &str = "monad.lock";
pub const STATE_DIR: &str = ".monad";
pub const DEFAULT_PACKAGE_MANAGER: &str = "bun";
pub const DEFAULT_SCOPE: &str = "@monad";
pub const DEFAULT_INIT_PRESET: &str = "governed";
pub const MANIFEST_SCHEMA_VERSION: u32 = 1;
pub const PLAN_SCHEMA_VERSION: u32 = 1;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub enum WorkspaceUnitKind {
    App,
    Service,
    Package,
    Lib,
    Tool,
    Config,
    Policy,
    Infra,
    Docs,
    Contract,
    Test,
    Agent,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct WorkspaceDefaults {
    pub canonical_manifest: &'static str,
    pub compatibility_manifest: &'static str,
    pub lockfile: &'static str,
    pub state_dir: &'static str,
    pub default_package_manager: &'static str,
    pub default_scope: &'static str,
    pub default_init_preset: &'static str,
}

impl Default for WorkspaceDefaults {
    fn default() -> Self {
        Self {
            canonical_manifest: CANONICAL_MANIFEST,
            compatibility_manifest: COMPATIBILITY_MANIFEST,
            lockfile: LOCKFILE,
            state_dir: STATE_DIR,
            default_package_manager: DEFAULT_PACKAGE_MANAGER,
            default_scope: DEFAULT_SCOPE,
            default_init_preset: DEFAULT_INIT_PRESET,
        }
    }
}

#[derive(Debug, thiserror::Error)]
pub enum MonadError {
    #[error("workspace not found; expected {CANONICAL_MANIFEST}")]
    WorkspaceNotFound,

    #[error("unsupported operation: {0}")]
    UnsupportedOperation(String),

    #[error("validation failed: {0}")]
    Validation(String),
}

#[must_use]
pub fn workspace_defaults() -> WorkspaceDefaults {
    WorkspaceDefaults::default()
}
