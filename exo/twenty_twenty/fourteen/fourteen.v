module fourteen

import math

fn bin_to_dec(n string) u64 {
	mut i := u64(0)
	mut res := u64(0)

	for c in n.reverse() {
		res += u64(rune(c).str().u64() * math.pow(2, i))
		i++
	}

	return res
}

fn dec_to_bin(_n u64) string {
	mut n := _n
	mut res := ''

	for n != 0 {
		rest := n % 2
		n /= 2
		res += rest.str()
	}

	for _ in res.len .. 36 {
		res += '0'
	}

	return res.reverse()
}

fn parse_mem(line string) (u64, u64) {
	arr := line.replace_once('mem[', '').split('=')
	return arr.first().u64(), arr.last().trim_space().u64()
}

fn parse_mask(line string) string {
	return line.split('=').last().trim_space()
}

fn apply_mask(value string, mask string) string {
	mut m_value := ''

	for i, k in value {
		if mask[i] == `X` {
			m_value += rune(k).str()
		} else {
			m_value += rune(mask[i]).str()
		}
	}

	return m_value
}

fn gen_all_possibilities_of(str string, m rune, tos []rune) []string {
	if str.len == 0 {
		return ['']
	}

	first_c := rune(str[0])
	rest := str[1..]
	partial := gen_all_possibilities_of(rest, m, tos)
	mut strs := []string{}

	if first_c == m {
		for to in tos {
			for s in partial {
				strs << (to.str() + s)
			}
		}
	} else {
		for s in partial {
			strs << (first_c.str() + s)
		}
	}

	return strs
}

fn apply_mask_v2(addr u64, mask string) []u64 {
	mut m_masked_addr := ''
	b_addr := dec_to_bin(addr)

	for i, k in b_addr {
		if mask[i] == `0` {
			m_masked_addr += rune(k).str()
		} else {
			m_masked_addr += rune(mask[i]).str()
		}
	}

	mut possible := []u64{}
	for str in gen_all_possibilities_of(m_masked_addr, `X`, [`0`, `1`]) {
		possible << bin_to_dec(str)
	}
	return possible
}

fn mem_sum(input string) u64 {
	mut mem := map[u64]string{}
	mut mask := ''

	for l in input.split('\n') {
		if l.len == 0 {
			continue
		}

		if l.starts_with('mask') {
			mask = parse_mask(l)
		} else {
			addr, val := parse_mem(l)
			mem[addr] = apply_mask(dec_to_bin(val), mask)
		}
	}

	mut sum := u64(0)
	for _, v in mem {
		sum += bin_to_dec(v)
	}

	return sum
}

fn mem_sum_v2(input string) u64 {
	mut mem := map[u64]u64{}
	mut mask := ''

	for l in input.split('\n') {
		if l.len == 0 {
			continue
		}

		if l.starts_with('mask') {
			mask = parse_mask(l)
		} else {
			addr, val := parse_mem(l)
			for a in apply_mask_v2(addr, mask) {
				mem[a] = val
			}
		}
	}

	mut sum := u64(0)
	for _, v in mem {
		sum += v
	}

	return sum
}

fn run(input string) string {
	handle_1 := go mem_sum(input)
	handle_2 := go mem_sum_v2(input)

	result_1 := handle_1.wait()
	result_2 := handle_2.wait()

	return '14:\n  Part 1: $result_1\n  Part 2: $result_2'
}
