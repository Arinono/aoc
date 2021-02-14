module main

import os

fn find_multiple_2(report []int) ?int {
	for x in report {
		for y in report {
			if x + y == 2020 {
				return x * y
			}
		}
	}
	return error('not found')
}

fn find_multiple_3(report []int) ?int {
	for x in report {
		for y in report {
			for z in report {
				if x + y + z == 2020 {
					return x * y * z
				}
			}
		}
	}
	return error('not found')
}

fn main() {
	mut report := []int{}

	lines := os.read_lines('input.txt') ?

	for line in lines {
		report << line.int()
	}

	value_2 := find_multiple_2(report) or {
		println(err)
		return
	}
	value_3 := find_multiple_3(report) or {
		println(err)
		return
	}

	println(value_2)
	println(value_3)
}
