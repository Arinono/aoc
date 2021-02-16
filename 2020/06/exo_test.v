module main

fn test_get_group_answers() {
	mut input := 'abcx
abcy
abcz'

	mut group := get_group(input)

	assert group.passengers.len == 3
	assert (`x` in group.passengers.first().yes_answers) == true
	assert (`z` in group.passengers.last().yes_answers) == true
	assert group.get_yes_answers() == 6

	input = 'abc'

	group = get_group(input)

	assert group.passengers.len == 1
	assert (`a` in group.passengers.first().yes_answers) == true
}

fn test_get_all_groups() {
	input := 'abc

a
b
c

ab
ac

a
a
a
a

b'

	groups := get_groups(input)

	assert groups.len == 5
	assert groups.first().passengers.len == 1
	assert groups[3].passengers.len == 4
}

fn test_sum_of_all_answers_in_groups() {
	input := 'abc

a
b
c

ab
ac

a
a
a
a

b'

	groups := get_groups(input)

	assert groups.get_sum_yes_answers() == 11
}

fn test_sum_of_all_common_answers_in_groups() {
	input := 'abc

a
b
c

ab
ac

a
a
a
a

b'

	groups := get_groups(input)

	assert groups.get_sum_common_yes_answers() == 6
}
