module main

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
