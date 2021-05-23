module twelve

fn test_parse_input() {
	input := 'N1
S2
E3
W4
L90
R180
R270
F10
'

	actions := parse_input(input)

	assert actions.len == 8

	assert actions[0] is North
	assert (actions[0] as North).value == u16(1)

	assert actions[1] is South
	assert (actions[1] as South).value == u16(2)

	assert actions[2] is East
	assert (actions[2] as East).value == u16(3)

	assert actions[3] is West
	assert (actions[3] as West).value == u16(4)

	assert actions[4] is TurnLeft
	assert (actions[4] as TurnLeft).value is Quart

	assert actions[5] is TurnRight
	assert (actions[5] as TurnRight).value is Half

	assert actions[6] is TurnRight
	assert (actions[6] as TurnRight).value is Third

	assert actions[7] is Forward
	assert (actions[7] as Forward).value == u16(10)
}

fn test_boat_init() {
	boat := new_boat()

	assert boat.pos.x == 0
	assert boat.pos.y == 0
	assert boat.dir == .east
	assert boat.str() == '⛴ @0:0'
}

fn test_move_boat() {
	mut boat := new_boat()

	boat.move(Forward{1})
	assert boat.str() == '⛴ @1:0'

	boat.move(North{1})
	assert boat.str() == '⛴ @1:1'

	boat.move(South{2})
	assert boat.str() == '⛴ @1:-1'

	boat.move(West{2})
	assert boat.str() == '⛴ @-1:-1'

	boat.move(East{1})
	assert boat.str() == '⛴ @0:-1'
}

fn test_rotate_boat() {
	mut boat := new_boat()

	boat.move(TurnLeft{Quart{}})
	assert boat.dir == .north
	assert boat.str() == '⛴ @0:0'

	boat.move(TurnRight{Half{}})
	assert boat.dir == .south
	assert boat.str() == '⛴ @0:0'

	boat.move(TurnLeft{Third{}})
	assert boat.dir == .west
	assert boat.str() == '⛴ @0:0'

	boat.move(TurnLeft{Half{}})
	assert boat.dir == .east
	assert boat.str() == '⛴ @0:0'
}

fn test_full_moveset() {
	mut b := new_boat()

	b.move(Forward{10})
	assert b.pos.x == 10
	assert b.pos.y == 0
	assert b.dir == .east

	b.move(North{3})
	assert b.pos.x == 10
	assert b.pos.y == 3
	assert b.dir == .east

	b.move(Forward{7})
	assert b.pos.x == 17
	assert b.pos.y == 3
	assert b.dir == .east

	b.move(TurnRight{Quart{}})
	assert b.pos.x == 17
	assert b.pos.y == 3
	assert b.dir == .south

	b.move(Forward{11})
	assert b.pos.x == 17
	assert b.pos.y == -8
	assert b.dir == .south
}

fn test_calc_manhattan_distance() {
	mut b := new_boat()

	b.pos.x = 17
	b.pos.y = -8

	assert b.distance() == 25
}

fn test_move_waypoint() {
	mut boat := new_boat()

	assert boat.wp == Pos{10, 1}

	// TurnLeft Half
	boat.move_waypoint(TurnLeft{Half{}})
	assert boat.wp == Pos{-10, -1}

	boat.move_waypoint(TurnLeft{Half{}})
	assert boat.wp == Pos{10, 1}

	// TurnRight Half
	boat.move_waypoint(TurnRight{Half{}})
	assert boat.wp == Pos{-10, -1}

	boat.move_waypoint(TurnRight{Half{}})
	assert boat.wp == Pos{10, 1}

	// TurnLeft Quart
	boat.move_waypoint(TurnLeft{Quart{}})
	assert boat.wp == Pos{-1, 10}

	boat.move_waypoint(TurnLeft{Quart{}})
	assert boat.wp == Pos{-10, -1}

	boat.move_waypoint(TurnLeft{Quart{}})
	assert boat.wp == Pos{1, -10}

	boat.move_waypoint(TurnLeft{Quart{}})
	assert boat.wp == Pos{10, 1}

	boat.move_waypoint(North{3})
	assert boat.wp == Pos{10, 4}

	boat.move_waypoint(South{11})
	assert boat.wp == Pos{10, -7}

	boat.move_waypoint(West{1})
	assert boat.wp == Pos{9, -7}

	boat.move_waypoint(East{12})
	assert boat.wp == Pos{21, -7}
}

fn test_full_moveset_waypoint() {
	mut b := new_boat()

	b.move_waypoint(Forward{10})
	assert b.pos.x == 100
	assert b.pos.y == 10
	assert b.wp == Pos{10, 1}

	b.move_waypoint(North{3})
	assert b.pos.x == 100
	assert b.pos.y == 10
	assert b.wp == Pos{10, 4}

	b.move_waypoint(Forward{7})
	assert b.pos.x == 170
	assert b.pos.y == 38
	assert b.wp == Pos{10, 4}

	b.move_waypoint(TurnRight{Quart{}})
	assert b.pos.x == 170
	assert b.pos.y == 38
	assert b.wp == Pos{4, -10}

	b.move_waypoint(Forward{11})
	assert b.pos.x == 214
	assert b.pos.y == -72
	assert b.wp == Pos{4, -10}
}
