module main

import math
import os

struct North {
	value u16
}

struct South {
	value u16
}

struct East {
	value u16
}

struct West {
	value u16
}

struct Quart {}
struct Half {}
struct Third {}
type Deg = Half | Quart | Third

struct TurnLeft {
	value Deg
}

struct TurnRight {
	value Deg
}

struct Forward {
	value u16
}

type Action = East | Forward | North | South | TurnLeft | TurnRight | West

fn new_action(action rune, value u16) Action {
	deg_fn := fn (value u16) Deg {
		mut deg := Deg(Quart{})
		match value {
			90 {
				deg = Deg(Quart{})
			}
			180 {
				deg = Deg(Half{})
			}
			270 {
				deg = Deg(Third{})
			}
			else {
				panic('Unvalid deg value.')
			}
		}
		return deg
	}

	mut a := Action(Forward{0})
	match action {
		`N` {
			a = Action(North{value})
		}
		`S` {
			a = Action(South{value})
		}
		`E` {
			a = Action(East{value})
		}
		`W` {
			a = Action(West{value})
		}
		`F` {
			a = Action(Forward{value})
		}
		`L` {
			a = Action(TurnLeft{deg_fn(value)})
		}
		`R` {
			a = Action(TurnRight{deg_fn(value)})
		}
		else {
			panic('Unknown action.')
		}
	}

	return a
}

fn parse_input(input string) []Action {
	mut actions := []Action{}
	lines := input.split('\n')

	for l in lines {
		if l.len == 0 {
			continue
		}
		action := l[0]
		value := l.all_after(l.substr(0, 1)).u16()
		actions << new_action(action, value)
	}

	return actions
}

enum BoatDir {
	north
	south
	east
	west
}

struct Pos {
mut:
	x int
	y int
}

struct Boat {
mut:
	pos Pos     = Pos{0, 0}
	dir BoatDir = .east
}

fn new_boat() Boat {
	return Boat{}
}

fn (b Boat) str() string {
	mut str := '⛴ '
	match b.dir {
		.east { str += '→' }
		.west { str += '←' }
		.north { str += '↑' }
		.south { str += '↓' }
	}
	str += ' @$b.pos.x:$b.pos.y'
	return str
}

fn (mut b Boat) move(act Action) {
	move_up := fn (mut b Boat, v u16) {
		b.pos.y += v
	}
	move_do := fn (mut b Boat, v u16) {
		b.pos.y -= v
	}
	move_ri := fn (mut b Boat, v u16) {
		b.pos.x += v
	}
	move_le := fn (mut b Boat, v u16) {
		b.pos.x -= v
	}
	reverse := fn (mut b Boat) {
		match b.dir {
			.east { b.dir = .west }
			.west { b.dir = .east }
			.south { b.dir = .north }
			.north { b.dir = .south }
		}
	}
	turn_le := fn (mut b Boat) {
		match b.dir {
			.east { b.dir = .north }
			.south { b.dir = .east }
			.west { b.dir = .south }
			.north { b.dir = .west }
		}
	}
	turn_ri := fn (mut b Boat) {
		match b.dir {
			.east { b.dir = .south }
			.south { b.dir = .west }
			.west { b.dir = .north }
			.north { b.dir = .east }
		}
	}

	match act {
		Forward {
			match b.dir {
				.east { move_ri(mut b, act.value) }
				.west { move_le(mut b, act.value) }
				.north { move_up(mut b, act.value) }
				.south { move_do(mut b, act.value) }
			}
		}
		North {
			move_up(mut b, act.value)
		}
		South {
			move_do(mut b, act.value)
		}
		East {
			move_ri(mut b, act.value)
		}
		West {
			move_le(mut b, act.value)
		}
		TurnLeft {
			match act.value {
				Quart { turn_le(mut b) }
				Half { reverse(mut b) }
				Third { turn_ri(mut b) }
			}
		}
		TurnRight {
			match act.value {
				Quart { turn_ri(mut b) }
				Half { reverse(mut b) }
				Third { turn_le(mut b) }
			}
		}
	}
}

fn (b Boat) distance() f64 {
	return math.abs(b.pos.x) + math.abs(b.pos.y)
}

fn run_all_actions(mut b Boat, acts []Action) {
	for a in acts {
		b.move(a)
	}
}

fn main() {
	input := os.read_file('input.txt') or { panic(err) }

	mut boat := new_boat()
	run_all_actions(mut boat, parse_input(input))
	distance_1 := boat.distance()

	println('Results:
  Puzzle nº1: $distance_1
  Puzzle nº2: 
	')
}
