module six

struct Passenger {
	yes_answers []rune
}

struct Group {
	passengers []Passenger
}

fn (g Group) get_yes_answers() int {
	mut yesses := []rune{}

	for p in g.passengers {
		for r in p.yes_answers {
			if !(rune(r) in yesses) {
				yesses << rune(r)
			}
		}
	}

	return yesses.len
}

// very shitty code here
fn (g Group) get_common_yes_answers() int {
	if g.passengers.len == 1 {
		return g.get_yes_answers()
	}

	mut merged_answers := []rune{}

	for p in g.passengers {
		merged_answers << p.yes_answers
	}

	mut answers := map[rune]int{}

	for a in merged_answers {
		answers[a]++
	}

	mut count := 0
	for _, v in answers {
		if v == g.passengers.len {
			count++
		}
	}

	return count
}

fn (gs []Group) get_sum_yes_answers() int {
	return gs.map(fn (g Group) int {
		return g.get_yes_answers()
	}).reduce(sum, 0)
}

fn (gs []Group) get_sum_common_yes_answers() int {
	return gs.map(fn (g Group) int {
		return g.get_common_yes_answers()
	}).reduce(sum, 0)
}

fn sum(a int, b int) int {
	return a + b
}

fn get_runes(s string) []rune {
	mut runes := []rune{}
	for c in s {
		runes << rune(c)
	}
	return runes
}

fn get_group(input string) Group {
	if !(input.contains('\n')) {
		return Group{[
			Passenger{get_runes(input)},
		]}
	}

	mut group := []Passenger{}
	for s in input.split('\n') {
		group << Passenger{get_runes(s)}
	}
	return Group{group}
}

fn get_groups(input string) []Group {
	mut groups := []Group{}
	for b in input.split('\n\n') {
		groups << get_group(b)
	}
	return groups
}

fn run_puzzle_1(input string) int {
	return get_groups(input).get_sum_yes_answers()
}

fn run_puzzle_2(input string) int {
	return get_groups(input).get_sum_common_yes_answers()
}

fn run(input string) string {
	handle_1 := go run_puzzle_1(input)
	handle_2 := go run_puzzle_2(input)

	result_1 := handle_1.wait()
	result_2 := handle_2.wait()

	return '06:\n  Part 1: $result_1\n  Part 2: $result_2'
}
