module main

import math
import os

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
	mut i := u64(1)
	mut res := ''

	for n != 0 {
		rest := n % 2
		n /= 2
		res += rest.str()
		i *= 10
	}

	for _ in res.len .. 36 {
		res += '0'
	}

	return res.reverse()
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

fn main() {
	input := os.read_file('input.txt') or { panic(err) }

	res_1 := mem_sum(input)

	println('Results:
  Puzzle nº1: $res_1
  Puzzle nº2: 
	')
}
