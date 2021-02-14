module main

fn test_boarding_pass_validator() {
	input := 'FBFBBFFRLR'

	pass := validate_boarding_pass(input) or { panic(err) }

	assert pass.row_id == 'FBFBBFF'
	assert pass.col_id == 'RLR'
}

fn test_row_finder() {
	mut pass := validate_boarding_pass('FBFBBFFRLR') or { panic(err) }

	pass.find_row()

	assert pass.row == 44
}

fn test_col_finder() {
	mut pass := validate_boarding_pass('FBFBBFFRLR') or { panic(err) }

	pass.find_col()

	assert pass.col == 5
}
