module main

import os

struct Floor {}

struct FreeSeat {}

struct OccupiedSeat {}

struct Debug {}

type Slot = Debug | Floor | FreeSeat | OccupiedSeat

struct Room {
mut:
	slots [][]Slot
}

fn (s Slot) str() string {
	return match s {
		FreeSeat {
			'L'
		}
		Floor {
			'.'
		}
		OccupiedSeat {
			'#'
		}
		Debug {
			'O'
		}
	}
}

fn (r Room) str() string {
	mut str := ''

	for i, row in r.slots {
		for s in row {
			str += s.str()
		}
		if i != r.slots.len - 1 {
			str += '\n'
		}
	}

	return str
}

fn (r Room) pad() Room {
	mut padded_room := r

	for mut l in r.slots {
		mut new_l := []Slot{}
		new_l << Slot(Floor{})
		new_l << l
		new_l << Slot(Floor{})
		l = new_l.clone()
	}

	pad_row := [Slot(Floor{})].repeat(r.slots[0].len)
	padded_room.slots.prepend(pad_row)
	padded_room.slots << pad_row

	return padded_room
}

fn count_around(r Room, y int, x int) (int, int) {
	count_fn := fn (arr []bool) (int, int) {
		mut trues := 0
		mut falses := 0
		for v in arr {
			match v {
				true {
					trues++
				}
				false {
					falses++
				}
			}
		}
		return trues, falses
	}

	occupied_seats_around := [
		r.slots[y - 1][x - 1] is OccupiedSeat,
		r.slots[y - 1][x] is OccupiedSeat,
		r.slots[y - 1][x + 1] is OccupiedSeat,
		r.slots[y][x - 1] is OccupiedSeat,
		r.slots[y][x + 1] is OccupiedSeat,
		r.slots[y + 1][x - 1] is OccupiedSeat,
		r.slots[y + 1][x] is OccupiedSeat,
		r.slots[y + 1][x + 1] is OccupiedSeat,
	]

	return count_fn(occupied_seats_around)
}

fn count_projected(r Room, y int, x int) (int, int) {
	count_fn := fn (arr []bool) (int, int) {
		mut trues := 0
		mut falses := 0
		for v in arr {
			match v {
				true {
					trues++
				}
				false {
					falses++
				}
			}
		}
		return trues, falses
	}

	projection_fn := fn (r Room, y int, x int, dir_x int, dir_y int) Slot {
		mut m_y := y + dir_y
		mut m_x := x + dir_x

		for m_y > 0 && m_y < r.slots.len - 1 && m_x > 0 && m_x < r.slots[m_y].len - 1 {
			if !(r.slots[m_y][m_x] is Floor) {
				return r.slots[m_y][m_x]
			}
			m_x += dir_x
			m_y += dir_y
		}
		return Floor{}
	}

	occupied_seats_projected := [
		projection_fn(r, y, x, -1, -1) is OccupiedSeat,
		projection_fn(r, y, x, -1, 0) is OccupiedSeat,
		projection_fn(r, y, x, -1, 1) is OccupiedSeat,
		projection_fn(r, y, x, 0, -1) is OccupiedSeat,
		projection_fn(r, y, x, 0, 1) is OccupiedSeat,
		projection_fn(r, y, x, 1, -1) is OccupiedSeat,
		projection_fn(r, y, x, 1, 0) is OccupiedSeat,
		projection_fn(r, y, x, 1, 1) is OccupiedSeat,
	]

	return count_fn(occupied_seats_projected)
}

fn (s Slot) switch_seat(occ_threashold int, count int) (Slot, bool) {
	mut changed := false
	mut new_slot := s

	match s {
		OccupiedSeat {
			if count >= occ_threashold {
				new_slot = FreeSeat{}
				changed = true
			}
		}
		FreeSeat {
			if count == 0 {
				new_slot = OccupiedSeat{}
				changed = true
			}
		}
		else {}
	}

	return new_slot, changed
}

fn (r Room) rotate(count_fn fn (Room, int, int) (int, int), occ_threashold int) (Room, bool) {
	mut m_changed := false
	mut m_slots_cpy := r.slots.clone()
	room_cpy := r

	for y in 1 .. room_cpy.slots.len - 1 {
		for x in 1 .. room_cpy.slots[y].len - 1 {
			occupied, _ := count_fn(room_cpy, y, x)
			new_slot, changed := room_cpy.slots[y][x].switch_seat(occ_threashold, occupied)
			m_slots_cpy[y][x] = new_slot
			if !m_changed {
				m_changed = changed
			}
		}
	}

	return Room{m_slots_cpy}, m_changed
}

fn (r Room) count_all_occupied() int {
	mut count := 0

	for row in r.slots {
		for s in row {
			match s {
				OccupiedSeat {
					count++
				}
				else {}
			}
		}
	}

	return count
}

fn (r Room) rotate_until_stable(count_fn fn (Room, int, int) (int, int), occ_threashold int) int {
	mut m_changed := true
	mut m_room := r

	for m_changed {
		m_room, m_changed = m_room.rotate(count_fn, occ_threashold)
	}

	return m_room.count_all_occupied()
}

fn parse_input(input string) Room {
	mut slots := [][]Slot{}

	for l in input.split('\n') {
		mut row := []Slot{}
		for s in l {
			match rune(s) {
				`L` {
					row << FreeSeat{}
				}
				`.` {
					row << Floor{}
				}
				`#` {
					row << OccupiedSeat{}
				}
				else {}
			}
		}
		slots << row
	}

	return Room{slots}
}

fn main() {
	input := os.read_file('input.txt') or { panic(err) }
	room := parse_input(input).pad()

	occupied_1 := room.rotate_until_stable(count_around, 4)
	occupied_2 := room.rotate_until_stable(count_projected, 5)

	println('Results:
  Puzzle nº1: $occupied_1
  Puzzle nº2: $occupied_2
	')
}
