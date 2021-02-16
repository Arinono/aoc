module main

import os

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
	if !('\n' in input) {
		return Group{[
			Passenger{get_runes(input)},
		]}
	}
	return Group{input.split_by_whitespace().map(fn (s string) Passenger {
		return Passenger{get_runes(s)}
	})}
}

fn get_groups(input string) []Group {
	return input.split('\n\n').map(fn (b string) Group {
		return get_group(b)
	})
}

fn run_puzzle_1(input string) int {
	return get_groups(input).get_sum_yes_answers()
}

fn main() {
	input := os.read_file('input.txt') or { panic(err) }

	g := go run_puzzle_1(input)
	res_2 := get_groups(input).get_sum_common_yes_answers()
	res_1 := g.wait()

	println('Results:
  Puzzle nº1: $res_1
  Puzzle nº2: $res_2
	')
}
