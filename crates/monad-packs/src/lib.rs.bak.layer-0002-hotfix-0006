//! Built-in pack metadata for Monad.

use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct BuiltinPack {
    pub name: &'static str,
    pub kind: &'static str,
    pub description: &'static str,
}

#[must_use]
pub fn builtin_packs() -> Vec<BuiltinPack> {
    vec![
        BuiltinPack {
            name: "typescript-bun",
            kind: "language",
            description: "TypeScript projects using Bun.",
        },
        BuiltinPack {
            name: "rust-crate",
            kind: "language",
            description: "Rust crates and workspace units.",
        },
        BuiltinPack {
            name: "go-service",
            kind: "language",
            description: "Go service scaffold and checks.",
        },
        BuiltinPack {
            name: "python-package",
            kind: "language",
            description: "Python package scaffold and checks.",
        },
        BuiltinPack {
            name: "docs",
            kind: "documentation",
            description: "Documentation templates and indexes.",
        },
        BuiltinPack {
            name: "adr",
            kind: "governance",
            description: "Architecture Decision Record workflows.",
        },
        BuiltinPack {
            name: "workpacket",
            kind: "planning",
            description: "Governance-grade implementation work packets.",
        },
        BuiltinPack {
            name: "policy",
            kind: "governance",
            description: "Policy and waiver primitives.",
        },
        BuiltinPack {
            name: "github-actions",
            kind: "automation",
            description: "GitHub Actions workflows.",
        },
        BuiltinPack {
            name: "docker",
            kind: "infrastructure",
            description: "Docker and Compose surfaces.",
        },
    ]
}
