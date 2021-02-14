module main

fn test_policy_1() {
	value := passwd_policy_checker(['1-3 a: abcde', '1-3 b: cdefg', '2-9 c: ccccccccc'],
		policy_1)

	assert value == 2
}

fn test_policy_2() {
	value := passwd_policy_checker(['1-3 a: abcde', '1-3 b: cdefg', '2-9 c: ccccccccc'],
		policy_2)

	assert value == 1
}
