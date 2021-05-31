module fifteen

struct Mem {
pub mut:
	last_spoken        int = -1
	most_recent_spoken int = -1
	already_spoken     bool
}

fn memory_game(nbs []int, nth int) int {
	mut mem := map[int]Mem{}
	mut result := nbs.last()
	mut i := 1

	for ; i < nbs.len + 1; i++ {
		mem[nbs[i - 1]] = Mem{i, i, false}
	}
	for ; i <= nth; i++ {
		nb := mem[result]
		match nb.already_spoken {
			false {
				result = 0
				mem[0] = Mem{i, mem[0].last_spoken, true}
			}
			true {
				result = nb.last_spoken - nb.most_recent_spoken
				if result in mem {
					mem[result] = Mem{i, mem[result].last_spoken, true}
				} else {
					mem[result] = Mem{i, i, false}
				}
			}
		}
	}

	return result
}

fn run(input string) string {
	mut nbs := []int{}

	for n in input.split(',') {
		nbs << n.int()
	}

	handle_1 := go memory_game(nbs, 2020)
	handle_2 := go memory_game(nbs, 30000000)

	result_1 := handle_1.wait()
	result_2 := handle_2.wait()

	return '15:\n  Part 1: $result_1\n  Part 2: $result_2'
}
