module fourteen

fn test_parse_mem() {
	addr, val := parse_mem('mem[8] = 11')

	assert addr == 8
	assert val == 11
}

fn test_parse_mask() {
	mask := parse_mask('mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X')

	assert mask == 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X'
}

fn test_apply_mask_on_value() {
	value := '000000000000000000000000000000001011'
	mask := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X'

	assert apply_mask(value, mask) == '000000000000000000000000000001001001'
}

fn test_convert_bin_to_dec() {
	assert bin_to_dec('000000000000000000000000000000001011') == 11
	assert bin_to_dec('000000000000000000000000000001001001') == 73
	assert bin_to_dec('000000000000000000000000000001100101') == 101
	assert bin_to_dec('000000000000000000000000000001000000') == 64
	assert bin_to_dec('000000010101100101000110110011110010') == 362048754
}

fn test_convert_dec_to_bin() {
	assert dec_to_bin(11) == '000000000000000000000000000000001011'
	assert dec_to_bin(73) == '000000000000000000000000000001001001'
	assert dec_to_bin(101) == '000000000000000000000000000001100101'
	assert dec_to_bin(64) == '000000000000000000000000000001000000'
	assert dec_to_bin(362048754) == '000000010101100101000110110011110010'
}

fn test_mem_sum() {
	program := 'mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0'

	assert mem_sum(program) == 165
}

fn test_gen_all_possibilities_of() {
	strs := gen_all_possibilities_of('000000000000000000000000000000X1101X', `X`, [`0`, `1`])

	assert strs.len == 4
	assert '000000000000000000000000000000011010' in strs
	assert '000000000000000000000000000000011011' in strs
	assert '000000000000000000000000000000111010' in strs
	assert '000000000000000000000000000000111011' in strs
}

fn test_apply_mask_v2() {
	addrs := apply_mask_v2(42, '000000000000000000000000000000X1001X')

	assert addrs.len == 4
	assert 26 in addrs
	assert 27 in addrs
	assert 58 in addrs
	assert 59 in addrs

	addrs_2 := apply_mask_v2(26, '00000000000000000000000000000000X0XX')

	assert addrs_2.len == 8
	assert 16 in addrs_2
	assert 17 in addrs_2
	assert 18 in addrs_2
	assert 19 in addrs_2
	assert 24 in addrs_2
	assert 25 in addrs_2
	assert 26 in addrs_2
	assert 27 in addrs_2
}

fn test_mem_sum_v2() {
	program := 'mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1'

	assert mem_sum_v2(program) == 208
}
