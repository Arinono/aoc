module seven

import exo.twenty_twenty.seven.graph
import regex

struct Bag {
	colour   string
	contains map[string]u32
}

fn (b Bag) str() string {
	mut str := 'Bag $b.colour:\n'
	for k, v in b.contains {
		str += '  $v $k\n'
	}
	return str
}

fn new_bag(line string) Bag {
	mut re_main := regex.regex_opt(r'^(?P<colour>[\w]+ [\w]+) bags contain (?P<rest>.+$)') or {
		panic(err)
	}
	mut re_rest := regex.regex_opt(r'^\d+ [\w]+ [\w]+') or { panic(err) }

	re_main.match_string(line)
	bag_colour := re_main.get_group_by_name(line, 'colour')
	rest := re_main.get_group_by_name(line, 'rest')

	rests := re_rest.find_all_str(rest)
	mut contains := map[string]u32{}

	for r in rests {
		num := r.u32()
		colour := r.replace('$num ', '')
		contains[colour] = num
	}

	return Bag{bag_colour, contains}
}

fn (bs []Bag) get_graph() &graph.Graph {
	mut bags_graph := graph.new_graph()

	for b in bs {
		bags_graph.add_node(b.colour)

		for k, v in b.contains {
			bags_graph.add_edge(b.colour, graph.Edge{k, v})
		}
	}

	return bags_graph
}

fn which_bags_can_contain(bags []Bag, bag_colour string) []string {
	if bags.len == 0 {
		return []
	}

	bag_graph := bags.get_graph()
	parents := bag_graph.find_all_parent_nodes(bag_colour)

	return parents
}

fn how_many_bags_can_contain(bags []Bag, bag_colour string) u32 {
	if bags.len == 0 {
		return 0
	}

	bag_graph := bags.get_graph()

	return bag_graph.weight_tree(bag_colour)
}

fn parse_input(input string) []Bag {
	mut bags := []Bag{}

	for l in input.split('\n') {
		if l.len > 0 {
			bags << new_bag(l)
		}
	}

	return bags
}

fn run_puzzle_1(input string) int {
	return which_bags_can_contain(parse_input(input), 'shiny gold').len
}

fn run_puzzle_2(input string) u32 {
	return how_many_bags_can_contain(parse_input(input), 'shiny gold') - 1
}

fn run(input string) string {
	handle_1 := go run_puzzle_1(input)
	handle_2 := go run_puzzle_2(input)

	result_1 := handle_1.wait()
	result_2 := handle_2.wait()

	return '07:\n  Part 1: $result_1\n  Part 2: $result_2'
}
