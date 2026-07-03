//! Context and handoff primitives for Monad.
//!
//! Monad is AI-ready but AI-optional. This crate owns neutral context packaging
//! concepts that can be used by humans, scripts, and AI tools.

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ContextFile {
    pub path: String,
    pub purpose: String,
}

impl ContextFile {
    pub fn new(path: impl Into<String>, purpose: impl Into<String>) -> Self {
        Self {
            path: path.into(),
            purpose: purpose.into(),
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ContextPack {
    pub title: String,
    pub files: Vec<ContextFile>,
}

impl ContextPack {
    pub fn new(title: impl Into<String>) -> Self {
        Self {
            title: title.into(),
            files: Vec::new(),
        }
    }

    pub fn include_file(mut self, file: ContextFile) -> Self {
        self.files.push(file);
        self
    }

    pub fn file_count(&self) -> usize {
        self.files.len()
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct HandoffSummary {
    pub current_workpacket: String,
    pub summary: String,
    pub next_actions: Vec<String>,
}

impl HandoffSummary {
    pub fn new(current_workpacket: impl Into<String>, summary: impl Into<String>) -> Self {
        Self {
            current_workpacket: current_workpacket.into(),
            summary: summary.into(),
            next_actions: Vec::new(),
        }
    }

    pub fn with_next_action(mut self, action: impl Into<String>) -> Self {
        self.next_actions.push(action.into());
        self
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn context_pack_counts_included_files() {
        let pack = ContextPack::new("WP-0001")
            .include_file(ContextFile::new("monad.toml", "canonical manifest"))
            .include_file(ContextFile::new("Cargo.toml", "workspace manifest"));

        assert_eq!(pack.file_count(), 2);
    }

    #[test]
    fn handoff_summary_tracks_next_actions() {
        let handoff = HandoffSummary::new("WP-0001", "CLI skeleton")
            .with_next_action("run cargo test --workspace");

        assert_eq!(handoff.current_workpacket, "WP-0001");
        assert_eq!(handoff.next_actions.len(), 1);
    }
}
