module sixteen

const input = 'class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12'

fn test_parse_rules() {
	rules, _, _ := parse_input(sixteen.input)

	assert 'class' in rules && 'row' in rules && 'seat' in rules
	assert rules['class'] == [Range{1, 3}, Range{5, 7}]
	assert rules['row'] == [Range{6, 11}, Range{33, 44}]
	assert rules['seat'] == [Range{13, 40}, Range{45, 50}]
}

fn test_parse_your_ticket() {
	_, your_ticket, _ := parse_input(sixteen.input)

	assert your_ticket == [7, 1, 14]
}

fn test_parse_tickets() {
	_, _, tickets := parse_input(sixteen.input)

	assert tickets.len == 4
	assert tickets[0] == [7, 3, 47]
	assert tickets[1] == [40, 4, 50]
	assert tickets[2] == [55, 2, 20]
	assert tickets[3] == [38, 6, 12]
}

fn test_error_rate() {
	rules, _, tickets := parse_input(sixteen.input)

	rate, _ := error_rate(rules, tickets)

	assert rate == 71
}

fn test_find_fields() {
	new_input := 'class: 0-1 or 4-19
row: 0-5 or 8-19
seat: 0-13 or 16-19

your ticket:
11,12,13

nearby tickets:
3,9,18
15,1,5
5,14,9'

	rules, _, tickets := parse_input(new_input)
	_, valid_tickets := error_rate(rules, tickets)

	fields := find_fields(rules, valid_tickets)

	assert fields['row'] == 0
	assert fields['class'] == 1
	assert fields['seat'] == 2
}
