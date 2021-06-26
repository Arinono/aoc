module seventeen

// import part_1
// import part_2
import os

const test_input = '.#.
..#
###'

fn test_works() {
	assert true == true
}

// fn test_pos3d_equality_overloading() {
// 	assert (part_1.Pos3D{0, 0, 0} == part_1.Pos3D{0, 0, 0}) == true
// 	assert (part_1.Pos3D{0, 0, 0} == part_1.Pos3D{0, 0, 1}) == false
// 	assert (part_1.Pos3D{0, 0, 0} == part_1.Pos3D{0, 1, 0}) == false
// 	assert (part_1.Pos3D{0, 0, 0} == part_1.Pos3D{1, 0, 0}) == false
// }

// fn test_parsing() {
// 	actives := part_1.parse_input(test_input)

// 	assert actives.size == 5
// 	assert actives.has(part_1.new_pos_3d(1, 0, 0)) == true
// 	assert actives.has(part_1.new_pos_3d(2, 1, 0)) == true
// 	assert actives.has(part_1.new_pos_3d(0, 2, 0)) == true
// 	assert actives.has(part_1.new_pos_3d(1, 2, 0)) == true
// 	assert actives.has(part_1.new_pos_3d(2, 2, 0)) == true
// }

// fn test_get_neighbours() {
// 	test_base_actives := part_1.parse_input(test_input)
// 	base_cube := part_1.new_pos_3d(0, 0, 0)
// 	neighbours := part_1.get_neighbours(base_cube)

// 	assert neighbours.size == 26
// 	assert neighbours.has(base_cube) == false
// }

// fn test_cycle() {
// 	test_base_actives := part_1.parse_input(test_input)
// 	new_actives := part_1.cycle(test_base_actives)

// 	assert new_actives.size == 11
// }

// fn test_gol() {
// 	test_base_actives := part_1.parse_input(test_input)
// 	new_actives := part_1.gol(test_base_actives, 6)

// 	assert new_actives.size == 112
// }

// fn test_real() {
// 	input := os.read_file('inputs/2020/17.txt') or { panic(err) }

// 	// act_1 := part_1.parse_input(input)
// 	// res_1 := part_1.gol(act_1, 6)

// 	act_2 := part_2.parse_input(input)
// 	res_2 := part_2.gol(act_2, 6)

// 	// println(res_1.size)
// 	println(res_2.size)
// }
