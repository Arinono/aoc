module nine

import arrays

struct XmasData {
	preambule []u64
	list      []u64
}

fn shift_preambule(preambule []u64, next_value u64) []u64 {
	mut m_preambule := preambule.clone()
	m_preambule.delete(0)
	m_preambule << next_value
	return m_preambule
}

fn (data XmasData) merged() []u64 {
	mut merged := data.preambule.clone()
	merged << data.list.clone()
	return merged
}

fn (data XmasData) find_error() u64 {
	mut m_preambule := data.preambule
	mut value_to_test_idx := 0

	check_fn := fn (m_preambule []u64, value u64) bool {
		for x in 0 .. m_preambule.len - 1 {
			inner: for y in 1 .. m_preambule.len {
				if m_preambule[x] == m_preambule[y] {
					continue inner
				}
				if m_preambule[x] + m_preambule[y] == value {
					return true
				}
			}
		}
		return false
	}

	mut valid := true
	for valid && value_to_test_idx < data.list.len {
		valid = check_fn(m_preambule, data.list[value_to_test_idx])
		m_preambule = shift_preambule(m_preambule, data.list[value_to_test_idx])
		value_to_test_idx++
	}
	return data.list[value_to_test_idx - 1]
}

fn sum_values(values []u64) u64 {
	mut sum := u64(0)

	for v in values {
		sum += v
	}

	return sum
}

// far from being optimised
// I should reuse the previous values and calc instead
// or redoing it everytime
fn calc(start int, target u64, merged []u64) u64 {
	mut values := [merged[start], merged[start + 1]]
	mut m_start := start
	mut value_idx := start + 2
	mut sum := sum_values(values)

	for sum < target {
		values << merged[value_idx]
		sum = sum_values(values)
		value_idx++
	}
	if sum > target {
		m_start++
		return calc(m_start, target, merged)
	}
	return arrays.min<u64>(values) + arrays.max<u64>(values)
}

fn (data XmasData) find_weakness() u64 {
	merged := data.merged()
	invalid := data.find_error()

	return calc(0, invalid, merged)
}

fn parse_input(input string, preambule_size u32) XmasData {
	mut preambule := []u64{}
	mut list := []u64{}

	for i, l in input.split('\n') {
		if l.len == 0 {
			continue
		}
		if i < preambule_size {
			preambule << l.u64()
		} else {
			list << l.u64()
		}
	}

	return XmasData{preambule, list}
}

fn run(input string) string {
	xmas_data := parse_input(input, 25)

	handle_1 := go xmas_data.find_error()
	handle_2 := go xmas_data.find_weakness()

	result_1 := handle_1.wait()
	result_2 := handle_2.wait()

	return '09:\n  Part 1: $result_1\n  Part 2: $result_2'
}
