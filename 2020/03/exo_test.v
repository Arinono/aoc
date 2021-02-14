module main

fn test_traverse_map() {
	carte := '..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#
'

	result := process(carte, 3, 1)

	assert result == 7
}

fn test_traverse_map_from_multiple_starting_points() {
	carte := '..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#
'
	start_r1_d1 := process(carte, 1, 1)
	assert start_r1_d1 == 2
	start_r3_d1 := process(carte, 3, 1)
	assert start_r3_d1 == 7
	start_r5_d1 := process(carte, 5, 1)
	assert start_r5_d1 == 3
	start_r7_d1 := process(carte, 7, 1)
	assert start_r7_d1 == 4
	start_r1_d2 := process(carte, 1, 2)
	assert start_r1_d2 == 2

	assert start_r1_d1 * start_r1_d2 * start_r3_d1 * start_r5_d1 * start_r7_d1 == 336
}
