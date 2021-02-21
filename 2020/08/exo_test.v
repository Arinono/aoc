module main

fn test_parse_input() {
	input := 'nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6'

	ops := parse_input(input)

	assert ops.len == 9
	assert ops.first() is Noop
	assert ops[1] is Acc
	assert ops[2] is Jmp

	assert ops[1] as Acc == Acc(1)
	assert ops[4] as Jmp == Jmp(-3)
}

fn test_find_infinite_loop() {
	input := 'nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6'
	ops := parse_input(input)

	ops.run_program() or {
		assert err == 'Broke out of infinite loop at 5'
		return
	}
	assert true == false
}

fn test_fix_infinite_loop() {
	input := 'nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6'
	ops := parse_input(input)

	assert ops.fix_and_run_program() == 8
}
