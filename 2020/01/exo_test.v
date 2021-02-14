module main

fn test_find_multiple_2() {
	value := find_multiple_2([1721, 979, 366, 299, 675, 1456]) or { 0 }

	assert value == 514579
}

fn test_find_multiple_3() {
	value := find_multiple_3([1721, 979, 366, 299, 675, 1456]) or { 0 }

	assert value == 241861950
}
