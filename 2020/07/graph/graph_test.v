module graph

fn test_create_graph() {
	graph := new_graph()

	assert graph.nodes.len == 0
}

fn test_add_node() {
	mut graph := new_graph()

	graph.add_node('red')
	graph.add_node('green')

	assert graph.nodes.len == 2
	assert graph.nodes['red'].len == 0
	assert graph.nodes['green'].len == 0
}

fn test_add_edge() {
	mut graph := new_graph()
	graph.add_node('red')

	graph.add_edge('red', Edge{'green', 2})

	assert graph.nodes['red'].len == 1
	assert graph.nodes['red'].first().id == 'green'
	assert graph.nodes['red'].first().weight == 2
}

fn test_find_all_children_nodes() {
	mut graph := new_graph()
	graph.add_node('red')
	graph.add_node('green')
	graph.add_node('blue')
	graph.add_node('white')

	graph.add_edge('red', Edge{'green', 2})
	graph.add_edge('red', Edge{'invalid', 2})
	graph.add_edge('green', Edge{'blue', 1})

	red_children := graph.find_all_children_nodes('red')

	assert red_children.len == 2
	assert ('green' in red_children) == true
	assert ('blue' in red_children) == true
	assert ('white' in red_children) == false
	assert ('invalid' in red_children) == false
}

fn test_find_all_parent_nodes() {
	mut graph := new_graph()
	graph.add_node('red')
	graph.add_node('green')
	graph.add_node('blue')
	graph.add_node('white')

	graph.add_edge('red', Edge{'green', 2})
	graph.add_edge('red', Edge{'blue', 1})
	graph.add_edge('green', Edge{'blue', 1})

	white_parents := graph.find_all_parent_nodes('white')
	blue_parents := graph.find_all_parent_nodes('blue')

	assert white_parents.len == 0
	assert blue_parents.len == 2
	assert ('green' in blue_parents) == true
	assert ('red' in blue_parents) == true
	assert ('red' in blue_parents) == true
	assert ('white' in blue_parents) == false
}

fn test_weight_subtree() {
	mut graph := new_graph()
	graph.add_node('shiny gold')
	graph.add_node('dark olive')
	graph.add_node('vibrant plum')
	graph.add_node('faded blue')
	graph.add_node('dotted black')

	graph.add_edge('shiny gold', Edge{'dark olive', 1})
	graph.add_edge('shiny gold', Edge{'vibrant plum', 2})
	graph.add_edge('vibrant plum', Edge{'faded blue', 5})
	graph.add_edge('vibrant plum', Edge{'dotted black', 6})
	graph.add_edge('dark olive', Edge{'faded blue', 3})
	graph.add_edge('dark olive', Edge{'dotted black', 4})

	assert graph.weight_tree('shiny gold') - 1 == 32
}
