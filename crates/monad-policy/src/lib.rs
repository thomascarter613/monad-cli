//! Policy primitives for Monad governance checks.

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub enum Severity {
    Info,
    Warning,
    Error,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PolicyFinding {
    pub code: String,
    pub severity: Severity,
    pub message: String,
}

impl PolicyFinding {
    pub fn new(code: impl Into<String>, severity: Severity, message: impl Into<String>) -> Self {
        Self {
            code: code.into(),
            severity,
            message: message.into(),
        }
    }

    pub fn is_blocking(&self) -> bool {
        self.severity == Severity::Error
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Default)]
pub struct PolicyCheckResult {
    pub findings: Vec<PolicyFinding>,
}

impl PolicyCheckResult {
    pub fn push(&mut self, finding: PolicyFinding) {
        self.findings.push(finding);
    }

    pub fn has_blocking_findings(&self) -> bool {
        self.findings.iter().any(PolicyFinding::is_blocking)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn errors_are_blocking_policy_findings() {
        let mut result = PolicyCheckResult::default();
        assert!(!result.has_blocking_findings());

        result.push(PolicyFinding::new(
            "MONAD_POLICY_TEST",
            Severity::Error,
            "test finding",
        ));

        assert!(result.has_blocking_findings());
    }
}
