module graph

pub struct Edge {
	id     string
	weight u32
}

pub struct Graph {
mut:
	nodes map[string][]Edge
}

pub fn (mut g Graph) add_node(id string) {
	g.nodes[id] = []Edge{}
}

pub fn (mut g Graph) add_edge(id string, edge Edge) {
	g.nodes[id] << edge
}

pub fn (g Graph) find_all_children_nodes(id string) []string {
	mut nodes := []string{}

	for edge in g.nodes[id] {
		if edge.id in g.nodes {
			nodes << edge.id
			nodes << g.find_all_children_nodes(edge.id)
		}
	}

	return remove_dupes(nodes)
}

pub fn (g Graph) find_all_parent_nodes(id string) []string {
	mut nodes := []string{}

	for k, v in g.nodes {
		for e in v {
			if e.id == id {
				nodes << k
				nodes << g.find_all_parent_nodes(k)
			}
		}
	}

	return remove_dupes(nodes)
}

pub fn (g Graph) weight_tree(id string) u32 {
	mut weight := u32(1)

	for e in g.nodes[id] {
		qty := e.weight
		weight += qty * g.weight_tree(e.id)
	}

	return weight
}

pub fn new_graph() &Graph {
	return &Graph{}
}

fn remove_dupes(strings []string) []string {
	mut filtered_nodes := []string{}

	for s in strings {
		if !(s in filtered_nodes) {
			filtered_nodes << s
		}
	}

	return filtered_nodes
}
