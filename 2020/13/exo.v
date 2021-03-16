module main

import os

struct AnyBus {}

struct KnownBus {
	id u64
}

type Bus = AnyBus | KnownBus

fn parse_input(input string) (u64, []Bus) {
	mut ts := u64(0)
	mut busses := []Bus{}

	for i, l in input.split('\n') {
		if i == 0 {
			ts = u64(l.int())
		} else {
			for b in l.split(',') {
				if l.len == 0 {
					continue
				}
				match b {
					'x' {
						busses << AnyBus{}
					}
					else {
						busses << KnownBus{u64(b.int())}
					}
				}
			}
		}
	}

	return ts, busses
}

fn get_next_departure(ts u64, b KnownBus) u64 {
	if b.id == 0 {
		return 0
	}
	return (ts + b.id - 1) / b.id * b.id
}

fn find_next_departing_bus(ts u64, busses []Bus) (u64, KnownBus) {
	mut next_departures := map[u64]KnownBus{}

	for b in busses {
		if b is KnownBus {
			next_departures[get_next_departure(ts, b)] = b
		}
	}

	mut base_ts := ts
	for {
		if base_ts in next_departures.keys() {
			return base_ts, next_departures[base_ts]
		}
		base_ts++
	}

	return 0, KnownBus{0}
}

fn find_ts_where_busses_depart_one_after_the_other(busses []Bus) u64 {
	mut step := (busses.first() as KnownBus).id
	mut m_ts := u64(1)

	for i, b in busses[1..] {
		bus := if b is KnownBus { b.id } else { 1 }
		for (m_ts + u64(i)) % bus != 0 {
			m_ts += step
		}
		step *= bus
	}

	return m_ts - 1
}

fn main() {
	input := os.read_file('input.txt') or { panic(err) }

	ts, busses := parse_input(input)

	departure, bus := find_next_departing_bus(ts, busses)
	res_1 := bus.id * (departure - ts)
	res_2 := find_ts_where_busses_depart_one_after_the_other(busses)

	println('Results:
  Puzzle nº1: $res_1
  Puzzle nº2: $res_2
	')
}
