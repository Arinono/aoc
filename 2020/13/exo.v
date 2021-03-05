module main

import os

fn parse_input(input string) (u32, []u32) {
	mut ts := u32(0)
	mut busses := []u32{}

	for i, l in input.split('\n') {
		if i == 0 {
			ts = u32(l.int())
		} else {
			for b in l.split(',') {
				if l.len == 0 {
					continue
				}
				match b {
					'x' {
						continue
					}
					else {
						busses << u32(b.int())
					}
				}
			}
		}
	}

	return ts, busses
}

fn get_next_departure(ts u32, b u32) u32 {
	if b == 0 {
		return 0
	}
	return (ts + b - 1) / b * b
}

fn find_next_departing_bus(ts u32, busses []u32) (u32, u32) {
	mut next_departures := map[u32]u32{}

	for b in busses {
		next_departures[get_next_departure(ts, b)] = b
	}

	mut base_ts := ts
	for {
		if base_ts in next_departures.keys() {
			return base_ts, next_departures[base_ts]
		}
		base_ts++
	}

	return 0, 0
}

fn main() {
	input := os.read_file('input.txt') or { panic(err) }

	ts, busses := parse_input(input)

	departure, bus := find_next_departing_bus(ts, busses)
	res_1 := bus * (departure - ts)

	println('Results:
  Puzzle nº1: $res_1
  Puzzle nº2: 
	')
}
