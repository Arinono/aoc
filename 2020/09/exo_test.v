module main

fn test_invalid_value() {
	input := '35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576'

	xmas_data := parse_input(input, 5)

	error := xmas_data.find_error()

	assert error == 127
}

fn test_encryption_weekness() {
	input := '35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576'

	xmas_data := parse_input(input, 5)

	weakness := xmas_data.find_weakness()

	assert weakness == 62
}
