module main

fn test_parse_input() {
	input := '939
7,13,x,x,59,x,31,19'

	timestamp, busses := parse_input(input)

	assert timestamp == 939
	assert 7 in busses
	assert 13 in busses
	assert 59 in busses
	assert 31 in busses
	assert 19 in busses
}

fn test_bus_departure_time() {
	assert get_next_departure(939, 7) == 945
	assert get_next_departure(939, 13) == 949
	assert get_next_departure(939, 59) == 944

	assert get_next_departure(1001171, 17) == 1001181
}

fn test_find_next_departing_bus() {
	busses := [u32(7), u32(13), u32(59), u32(31), u32(19)]

	ts, bus := find_next_departing_bus(939, busses)

	assert bus == 59
	assert ts == 944
}
