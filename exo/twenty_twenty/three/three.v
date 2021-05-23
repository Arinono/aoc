module three

struct Pos {
mut:
	x         int
	y         int
	trees_hit u64
}

struct Tree {}

struct Hole {}

struct Hit {}

struct NoHit {}

type Square = Hit | Hole | NoHit | Tree

fn (s Square) str() string {
	match s {
		Tree {
			return '#'
		}
		Hole {
			return '.'
		}
		Hit {
			return 'X'
		}
		NoHit {
			return 'O'
		}
	}
}

struct Map {
mut:
	base    [][]Square
	squares [][]Square
}

fn (mut m Map) parse_map(input string) {
	mut row := []Square{}

	for c in input {
		if rune(c) == `.` {
			row << Hole{}
		} else if rune(c) == `#` {
			row << Tree{}
		} else if rune(c) == `\n` {
			m.base << row
			row = []Square{}
		}
	}

	m.squares = m.base
}

fn (m Map) str() string {
	mut str := ''
	for r in m.squares {
		for s in r {
			str += s.str()
		}
		str += '\n'
	}
	return str
}

fn (mut m Map) expand() {
	for i, r in m.base {
		m.squares[i] << r
	}
}

fn (mut m Map) traverse_map(mut pos Pos, x int, y int) {
	pos.x += x
	pos.y += y

	if pos.x >= m.squares[0].len {
		m.expand()
	}

	match m.squares[pos.y][pos.x] {
		Tree {
			pos.trees_hit++
			m.squares[pos.y][pos.x] = Hit{}
		}
		else {
			m.squares[pos.y][pos.x] = NoHit{}
		}
	}

	if pos.y < m.squares.len - 1 {
		m.traverse_map(mut pos, x, y)
	}
}

fn process(input string, x int, y int) u64 {
	mut carte := Map{}
	mut pos := Pos{0, 0, 0}

	carte.parse_map(input)
	carte.traverse_map(mut pos, x, y)

	return pos.trees_hit
}

fn run(input string) string {
	handle_1 := go process(input, 3, 1)
	handle_r1_d1 := go process(input, 1, 1)
	handle_r3_d1 := go process(input, 3, 1)
	handle_r5_d1 := go process(input, 5, 1)
	handle_r7_d1 := go process(input, 7, 1)
	handle_r1_d2 := go process(input, 1, 2)

	result_1 := handle_1.wait()
	result_2 := handle_r1_d1.wait() * handle_r3_d1.wait() * handle_r5_d1.wait() * handle_r7_d1.wait() * handle_r1_d2.wait()

	return '03:\n  Part 1: $result_1\n  Part 2: $result_2'
}
