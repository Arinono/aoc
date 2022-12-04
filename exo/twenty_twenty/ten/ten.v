module ten

struct Diff1 {}

struct Diff2 {}

struct Diff3 {}

type Diff = Diff1 | Diff2 | Diff3

type Adapter = u16

struct AdapterChain {
	ordered_adapters []Adapter
mut:
	diffs []Diff
}

fn (mut ac AdapterChain) run_chain() {
	match_fn := fn (mut ac AdapterChain, next u16, a u16) {
		match next - a {
			1 {
				ac.diffs << Diff1{}
			}
			2 {
				ac.diffs << Diff2{}
			}
			3 {
				ac.diffs << Diff3{}
			}
			else {
				panic('Diff between $next and $a is too large.')
			}
		}
	}

	for i, a in ac.ordered_adapters {
		if i == ac.ordered_adapters.len - 1 {
			break
		}

		next := ac.ordered_adapters[i + 1]

		match_fn(mut ac, next, a)
	}

	match_fn(mut ac, ac.ordered_adapters.last() + 3, ac.ordered_adapters.last()) // from last ad to device
}

fn (ac AdapterChain) count() (u16, u16, u16) {
	mut diff1 := u16(0)
	mut diff2 := u16(0)
	mut diff3 := u16(0)

	for d in ac.diffs {
		match d {
			Diff1 {
				diff1++
			}
			Diff2 {
				diff2++
			}
			Diff3 {
				diff3++
			}
		}
	}

	return diff1, diff2, diff3
}

fn (mut ac AdapterChain) get_diffs() (u16, u16, u16) {
	ac.run_chain()

	return ac.count()
}

fn recurse(arr []Adapter, i u64, mut memo map[u64]u64) u64 {
	if i in memo {
		return memo[i]
	}

	if i == arr.len - 1 {
		return 1
	}

	mut tot := u64(0)

	if i + 1 < arr.len && arr[i + 1] - arr[i] <= 3 {
		tot += recurse(arr, i + u64(1), mut memo)
	}
	if i + 2 < arr.len && arr[i + 2] - arr[i] <= 3 {
		tot += recurse(arr, i + u64(2), mut memo)
	}
	if i + 3 < arr.len && arr[i + 3] - arr[i] <= 3 {
		tot += recurse(arr, i + u64(3), mut memo)
	}

	memo[i] = tot
	return tot
}

fn (mut ac AdapterChain) find_max_arrangements() u64 {
	mut memo := map[u64]u64{}
	return recurse(ac.ordered_adapters, 0, mut memo)
}

fn sort_adapters(a &u16, b &u16) int {
	if *a < *b {
		return -1
	}
	if *a > *b {
		return 1
	}
	return 0
}

fn parse_input(input string) AdapterChain {
	mut adapters := []Adapter{}
	lines := input.split('\n')

	for l in lines {
		adapters << l.u16()
	}
	adapters.sort_with_compare(sort_adapters)

	return AdapterChain{
		ordered_adapters: adapters
	}
}

fn run_puzzle_1(mut ac AdapterChain) u16 {
	diff1, _, diff3 := ac.get_diffs()
	return diff1 * diff3
}

fn run_puzzle_2(mut ac AdapterChain) u64 {
	return ac.find_max_arrangements()
}

fn run(input string) string {
	mut adapters := parse_input(input)

	handle_1 := go run_puzzle_1(mut &adapters)
	handle_2 := go run_puzzle_2(mut &adapters)

	result_1 := handle_1.wait()
	result_2 := handle_2.wait()

	return '10:\n  Part 1: $result_1\n  Part 2: $result_2'
}
