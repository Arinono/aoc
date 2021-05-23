module eight

import exo.twenty_twenty.eight.set

type Noop = int

type Acc = int

type Jmp = int

type Op = Acc | Jmp | Noop

fn (op Op) run_op(acc int) (int, int) {
	match op {
		Noop {
			return acc, 1
		}
		Acc {
			return acc + int(op), 1
		}
		Jmp {
			return acc, op
		}
	}
}

fn (op Op) switch_op() Op {
	match op {
		Noop {
			return Jmp(op)
		}
		Jmp {
			return Noop(op)
		}
		else {
			panic('switch_op can only switch Jmp or Noop ops. You tried to switch $op')
		}
	}
}

fn (ops []Op) find_last_from(idx int) int {
	mut m_idx := idx
	for ops[m_idx] is Acc {
		m_idx--
	}
	return m_idx
}

fn (ops []Op) run_program() ?int {
	mut ran_ops := set.new_set()
	mut acc := 0
	mut op_idx := 0

	for op_idx != ops.len {
		if ran_ops.has(op_idx) {
			return error('Broke out of infinite loop at $acc')
		}
		ran_ops.add(op_idx)
		new_acc, next_op := ops[op_idx].run_op(acc)
		acc = new_acc
		if op_idx + next_op < 0 || op_idx + next_op > ops.len {
			panic('program went out of bounds')
		}
		op_idx = op_idx + next_op
	}

	return acc
}

fn (ops []Op) fix_and_run_program() int {
	run_fn := fn (passed_ops []Op, idx int) int {
		mut ops_copy := passed_ops.clone()
		patch_op := passed_ops.find_last_from(idx)
		new_op := ops_copy[patch_op].switch_op()
		ops_copy[patch_op] = new_op

		acc := ops_copy.run_program() or { return -1 }
		return acc
	}

	mut try_patch := ops.len - 1
	mut acc := -1
	for acc == -1 {
		acc = run_fn(ops, try_patch)
		try_patch--
	}

	return acc
}

fn parse_input(input string) []Op {
	return input.split('\n').map(fn (l string) Op {
		if l.len == 0 {
			return Noop(0)
		}
		parts := l.split(' ')
		assert parts.len == 2

		match parts[0] {
			'nop' {
				return Noop(0)
			}
			'acc' {
				return Acc(parts[1].int())
			}
			'jmp' {
				return Jmp(parts[1].int())
			}
			else {
				panic('cannot parse parts or line')
			}
		}
	})
}

fn run_puzzle_1(ops []Op) string {
	mut res := ''
	ops.run_program() or { res = err.msg.all_after('Broke out of infinite loop at ') }
	return res
}

fn run_puzzle_2(ops []Op) int {
	return ops.fix_and_run_program()
}

fn run(input string) string {
	ops := parse_input(input)

	handle_1 := go run_puzzle_1(ops)
	handle_2 := go run_puzzle_2(ops)

	result_1 := handle_1.wait()
	result_2 := handle_2.wait()

	return '08:\n  Part 1: $result_1\n  Part 2: $result_2'
}
