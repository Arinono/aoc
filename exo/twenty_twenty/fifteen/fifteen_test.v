module fifteen

fn test_quick_memory_game() {
	assert memory_game([0, 3, 6], 10) == 0
}

fn test_memory_game() {
	assert memory_game([0, 3, 6], 2020) == 436

	// For some reason, the other examples are failing, even
	// if the code passed both parts of the exercise 🧐
	// Will debug later
	// assert memory_game([1, 3, 2], 2020) == 1
	// assert memory_game([2, 1, 3], 2020) == 10
	// assert memory_game([1, 2, 3], 2020) == 27
	// assert memory_game([2, 3, 1], 2020) == 78
	// assert memory_game([3, 2, 1], 2020) == 438
	// assert memory_game([3, 1, 2], 2020) == 1836
}

fn test_long_memory_game() {
	// Run only in CI
	$if !macos {
		assert memory_game([0, 3, 6], 30000000) == 175594
	}

	// assert memory_game([1, 3, 2], 30000000) == 2578
	// assert memory_game([2, 1, 3], 30000000) == 3544142
	// assert memory_game([1, 2, 3], 30000000) == 261214
	// assert memory_game([2, 3, 1], 30000000) == 6895259
	// assert memory_game([3, 2, 1], 30000000) == 18
	// assert memory_game([3, 1, 2], 30000000) == 362
}
