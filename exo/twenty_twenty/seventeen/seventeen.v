module seventeen

// import part_1
import part_2

fn run(input string) string {
	// act_1 := part_1.parse_input(input)
	act_2 := part_2.parse_input(input)
	// handle_1 := go part_1.gol(act_1, 6)
	handle_2 := go part_2.gol(act_2, 6)

	// result_1 := handle_1.wait()
	result_1 := ''
	result_2 := handle_2.wait()

	return '06:\n  Part 1: $result_1\n  Part 2: $result_2'
}
