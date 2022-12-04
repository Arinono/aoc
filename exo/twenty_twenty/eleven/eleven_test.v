module eleven

fn test_padding() {
	input := 'L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL'

	assert parse_input(input).pad().str() == '............
.L.LL.LL.LL.
.LLLLLLL.LL.
.L.L.L..L...
.LLLL.LL.LL.
.L.LL.LL.LL.
.L.LLLLL.LL.
...L.L......
.LLLLLLLLLL.
.L.LLLLLL.L.
.L.LLLLL.LL.
............'
}

fn test_count_seats_around() {
	input := 'L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL'

	occupied, free_or_floor := count_around(parse_input(input).pad(), 1, 1)

	assert occupied == 0
	assert free_or_floor == 8
}

fn test_switch_seat_to_occupied() {
	seat, changed := Slot(FreeSeat{}).switch_seat(4, 0)

	assert seat.str() == '#'
	assert changed == true
}

fn test_switch_seat_to_free() {
	seat, changed := Slot(OccupiedSeat{}).switch_seat(4, 4)

	assert seat.str() == 'L'
	assert changed == true
}

fn test_no_switch_seat() {
	seat, changed := Slot(OccupiedSeat{}).switch_seat(4, 2)

	assert seat.str() == '#'
	assert changed == false
}

fn test_floor_never_changes() {
	mut seat, mut changed := Slot(Floor{}).switch_seat(4, 2)

	assert seat.str() == '.'
	assert changed == false

	seat, changed = Slot(Floor{}).switch_seat(4, 4)

	assert seat.str() == '.'
	assert changed == false
}

fn test_rotate() {
	input := 'L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL'

	room_gen_1, mut changed := parse_input(input).pad().rotate(count_around, 4)

	assert changed == true
	assert room_gen_1.str() == '............
.#.##.##.##.
.#######.##.
.#.#.#..#...
.####.##.##.
.#.##.##.##.
.#.#####.##.
...#.#......
.##########.
.#.######.#.
.#.#####.##.
............'

	room_gen_2, changed_2 := room_gen_1.rotate(count_around, 4)

	assert changed_2 == true
	assert room_gen_2.str() == '............
.#.LL.L#.##.
.#LLLLLL.L#.
.L.L.L..L...
.#LLL.LL.L#.
.#.LL.LL.LL.
.#.LLLL#.##.
...L.L......
.#LLLLLLLL#.
.#.LLLLLL.L.
.#.#LLLL.##.
............'
}

fn test_rotate_room_until_stable() {
	input := 'L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL'

	occupied := parse_input(input).pad().rotate_until_stable(count_around, 4)

	assert occupied == 37
}

fn test_count_projected() {
	input := '.......#.
	...#.....
	.#.......
	.........
	..#L....#
	....#....
	.........
	#........
	...#.....'

	mut occupied, _ := count_projected(parse_input(input).pad(), 5, 4)

	assert occupied == 8

	input_2 := '.............
.L.L.#.#.#.#.
.............'

	occupied, _ = count_projected(parse_input(input_2).pad(), 2, 2)

	assert occupied == 0

	input_3 := '.##.##.
	#.#.#.#
	##...##
	...L...
	##...##
	#.#.#.#
	.##.##.'

	occupied, _ = count_projected(parse_input(input_3).pad(), 4, 4)

	assert occupied == 0
}

fn test_rotate_projected() {
	input := 'L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL'

	room_gen_1, mut changed := parse_input(input).pad().rotate(count_projected, 5)

	assert changed == true
	assert room_gen_1.str() == '............
.#.##.##.##.
.#######.##.
.#.#.#..#...
.####.##.##.
.#.##.##.##.
.#.#####.##.
...#.#......
.##########.
.#.######.#.
.#.#####.##.
............'

	room_gen_2, changed_2 := room_gen_1.rotate(count_projected, 5)

	assert changed_2 == true
	assert room_gen_2.str() == '............
.#.LL.LL.L#.
.#LLLLLL.LL.
.L.L.L..L...
.LLLL.LL.LL.
.L.LL.LL.LL.
.L.LLLLL.LL.
...L.L......
.LLLLLLLLL#.
.#.LLLLLL.L.
.#.LLLLL.L#.
............'
}

fn test_rotate_projected_room_until_stable() {
	input := 'L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL'

	occupied := parse_input(input).pad().rotate_until_stable(count_projected, 5)

	assert occupied == 26
}
