module one

fn find_multiple_2(report []int) ?int {
	for x in report {
		for y in report {
			if x + y == 2020 {
				return x * y
			}
		}
	}
	return error('2020_01 part 1 failed: Report not found.')
}

fn find_multiple_3(report []int) ?int {
	for x in report {
		for y in report {
			for z in report {
				if x + y + z == 2020 {
					return x * y * z
				}
			}
		}
	}
	return error('2020_01 part 2 failed: Report not found.')
}

fn run(input string) string {
	mut report := []int{}

	for l in input.split('\n') {
		if l.len == 0 {
			continue
		}
		report << l.int()
	}

	handle_1 := go find_multiple_2(report)
	handle_2 := go find_multiple_3(report)

	result_1 := handle_1.wait() or { return err.msg }
	result_2 := handle_2.wait() or { return err.msg }

	return '01:\n  Part 1: $result_1\n  Part 2: $result_2'
}
