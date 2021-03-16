module main

fn test_parse_input() {
	input := '939
7,13,x,x,59,x,31,19'

	timestamp, busses := parse_input(input)

	mut ids := []u64{}
	for b in busses {
		if b is KnownBus {
			ids << b.id
		}
	}

	assert timestamp == 939
	assert 7 in ids
	assert 13 in ids
	assert 59 in ids
	assert 31 in ids
	assert 19 in ids
}

fn test_bus_departure_time() {
	assert get_next_departure(939, KnownBus{7}) == 945
	assert get_next_departure(939, KnownBus{13}) == 949
	assert get_next_departure(939, KnownBus{59}) == 944

	assert get_next_departure(1001171, KnownBus{17}) == 1001181
}

fn test_find_next_departing_bus() {
	busses := [
		Bus(KnownBus{7}),
		Bus(KnownBus{13}),
		Bus(KnownBus{59}),
		Bus(KnownBus{31}),
		Bus(KnownBus{19}),
	]

	ts, bus := find_next_departing_bus(939, busses)

	assert bus.id == 59
	assert ts == 944
}

fn test_parse_input_with_any_busses() {
	input := '939
7,13,x,x,59,x,31,19'

	_, busses := parse_input(input)

	assert busses.len == 8
	assert busses[0] is KnownBus
	assert (busses[0] as KnownBus).id == 7
	assert busses[2] is AnyBus
}

fn test_find_ts_where_busses_depart_one_after_the_other() {
	busses_1 := [
		Bus(KnownBus{7}),
		Bus(KnownBus{13}),
		Bus(AnyBus{}),
		Bus(AnyBus{}),
		Bus(KnownBus{59}),
		Bus(AnyBus{}),
		Bus(KnownBus{31}),
		Bus(KnownBus{19}),
	]
	busses_2 := [
		Bus(KnownBus{17}),
		Bus(AnyBus{}),
		Bus(KnownBus{13}),
		Bus(KnownBus{19}),
	]
	busses_3 := [
		Bus(KnownBus{67}),
		Bus(KnownBus{7}),
		Bus(KnownBus{59}),
		Bus(KnownBus{61}),
	]
	busses_4 := [
		Bus(KnownBus{67}),
		Bus(AnyBus{}),
		Bus(KnownBus{7}),
		Bus(KnownBus{59}),
		Bus(KnownBus{61}),
	]
	busses_5 := [
		Bus(KnownBus{67}),
		Bus(KnownBus{7}),
		Bus(AnyBus{}),
		Bus(KnownBus{59}),
		Bus(KnownBus{61}),
	]
	busses_6 := [
		Bus(KnownBus{1789}),
		Bus(KnownBus{37}),
		Bus(KnownBus{47}),
		Bus(KnownBus{1889}),
	]

	ts_1 := find_ts_where_busses_depart_one_after_the_other(busses_1)
	ts_2 := find_ts_where_busses_depart_one_after_the_other(busses_2)
	ts_3 := find_ts_where_busses_depart_one_after_the_other(busses_3)
	ts_4 := find_ts_where_busses_depart_one_after_the_other(busses_4)
	ts_5 := find_ts_where_busses_depart_one_after_the_other(busses_5)
	ts_6 := find_ts_where_busses_depart_one_after_the_other(busses_6)

	assert ts_1 == 1068781
	assert ts_2 == 3417
	assert ts_3 == 754018
	assert ts_4 == 779210
	assert ts_5 == 1261476
	assert ts_6 == 1202161486
}
