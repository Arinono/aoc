module main

import regex
import os

struct ValidBoardingPass {
	row_id string
	col_id string
mut:
	row int = -1
	col int = -1
	uid int = -1
}

fn (p ValidBoardingPass) str() string {
	return '$p.row_id$p.col_id: Pass nº$p.uid, located at $p.row:$p.col'
}

fn find(input string, len int, delim_low rune, delim_up rune) int {
	mut lower := 0
	mut upper := len - 1
	mut new_len := len

	for c in input {
		new_len = (upper + 1 - lower) / 2

		match rune(c) {
			delim_up {
				lower += new_len
			}
			delim_low {
				upper -= new_len
			}
			else {}
		}
	}

	return lower
}

fn (mut p ValidBoardingPass) find_col() {
	p.col = find(p.col_id, 8, `L`, `R`)
}

fn (mut p ValidBoardingPass) find_row() {
	p.row = find(p.row_id, 128, `F`, `B`)
}

fn (mut p ValidBoardingPass) find_seat() {
	p.find_row()
	p.find_col()
	p.uid = p.row * 8 + p.col
}

fn validate_boarding_pass(input string) ?ValidBoardingPass {
	mut re := regex.regex_opt(r'^([FB]{7})([LR]{3})$') or { panic(err) }

	start, _ := re.match_string(input)
	if start == -1 || re.groups.len != 4 {
		return error('invalid boarding pass')
	}

	return ValidBoardingPass{
		row_id: input[re.groups[0]..re.groups[1]]
		col_id: input[re.groups[2]..re.groups[3]]
	}
}

fn analise_all_passes(input []string) []ValidBoardingPass {
	mut passes := []ValidBoardingPass{}

	for l in input {
		mut pass := validate_boarding_pass(l) or { panic(err) }
		pass.find_seat()
		passes << pass
	}

	return passes
}

fn find_highest_seat_uid(passes []ValidBoardingPass) int {
	mut m_passes := passes.clone()
	m_passes.sort(a.uid > b.uid)
	return m_passes.first().uid
}

fn find_your_seat(passes []ValidBoardingPass) ?int {
	mut m_passes := passes.clone()
	m_passes.sort(a.uid < b.uid)
	uids := passes.map(fn (p ValidBoardingPass) int {
		return p.uid
	})

	for i in m_passes.first().uid .. m_passes.last().uid {
		if !(i in uids) {
			return i
		}
	}

	return error('seat not found 😢')
}

fn main() {
	input := os.read_lines('input.txt') or { panic(err) }

	passes := analise_all_passes(input)

	println(find_highest_seat_uid(passes))
	your_seat := find_your_seat(passes) or { panic(err) }
	println(your_seat)
}
