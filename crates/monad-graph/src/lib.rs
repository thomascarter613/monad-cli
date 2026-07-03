//! Graph primitives for Monad workspace introspection.

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum GraphFormat {
    Text,
    Json,
    Mermaid,
    Dot,
    Svg,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct GraphNode {
    pub id: String,
    pub kind: String,
}

impl GraphNode {
    pub fn new(id: impl Into<String>, kind: impl Into<String>) -> Self {
        Self {
            id: id.into(),
            kind: kind.into(),
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct GraphEdge {
    pub from: String,
    pub to: String,
    pub kind: String,
}

impl GraphEdge {
    pub fn new(from: impl Into<String>, to: impl Into<String>, kind: impl Into<String>) -> Self {
        Self {
            from: from.into(),
            to: to.into(),
            kind: kind.into(),
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Default)]
pub struct WorkspaceGraph {
    pub nodes: Vec<GraphNode>,
    pub edges: Vec<GraphEdge>,
}

impl WorkspaceGraph {
    pub fn add_node(&mut self, node: GraphNode) {
        self.nodes.push(node);
    }

    pub fn add_edge(&mut self, edge: GraphEdge) {
        self.edges.push(edge);
    }

    pub fn node_count(&self) -> usize {
        self.nodes.len()
    }

    pub fn edge_count(&self) -> usize {
        self.edges.len()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn workspace_graph_tracks_nodes_and_edges() {
        let mut graph = WorkspaceGraph::default();

        graph.add_node(GraphNode::new("apps/web", "app"));
        graph.add_node(GraphNode::new("packages/ui", "package"));
        graph.add_edge(GraphEdge::new("apps/web", "packages/ui", "depends_on"));

        assert_eq!(graph.node_count(), 2);
        assert_eq!(graph.edge_count(), 1);
    }
}
