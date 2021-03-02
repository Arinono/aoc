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
	wp  Pos     = Pos{10, 1}
}

fn new_boat() Boat {
	return Boat{}
}

fn (b Boat) str() string {
	return '⛴ @$b.pos.x:$b.pos.y'
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

fn (mut b Boat) move_waypoint(act Action) {
	reverse := fn (mut b Boat) {
		if b.wp.x >= 0 { b.wp.x = -b.wp.x } else { b.wp.x = int(math.abs(b.wp.x)) }
		if b.wp.y >= 0 {
			b.wp.y = -b.wp.y
		} else {
			b.wp.y = int(math.abs(b.wp.y))
		}
	}
	turn_le := fn (mut b Boat) {
		hold_y := b.wp.y
		b.wp.y = b.wp.x
		if hold_y >= 0 {
			b.wp.x = -hold_y
		} else {
			b.wp.x = int(math.abs(hold_y))
		}
	}
	turn_ri := fn (mut b Boat) {
		hold_y := b.wp.y
		if b.wp.x >= 0 {
			b.wp.y = -b.wp.x
		} else {
			b.wp.y = int(math.abs(b.wp.x))
		}
		b.wp.x = hold_y
	}

	match act {
		Forward {
			b.pos.x += act.value * b.wp.x
			b.pos.y += act.value * b.wp.y
		}
		North {
			b.wp.y += act.value
		}
		South {
			b.wp.y -= act.value
		}
		East {
			b.wp.x += act.value
		}
		West {
			b.wp.x -= act.value
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

fn main() {
	input := os.read_file('input.txt') or { panic(err) }
	acts := parse_input(input)

	mut boat := new_boat()
	mut boat_2 := new_boat()
	for a in acts {
		boat.move(a)
		boat_2.move_waypoint(a)
	}
	distance_1 := boat.distance()
	distance_2 := boat_2.distance()

	println('Results:
  Puzzle nº1: $distance_1
  Puzzle nº2: $distance_2
	')
}
