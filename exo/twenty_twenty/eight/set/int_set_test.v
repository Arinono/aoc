module set

fn test_new_set() {
	set := new_set()

	assert set.size() == 0
}

fn test_add() {
	mut set := new_set()

	set.add(0)

	assert set.has(0) == true
	assert set.size() == 1
}

fn test_add_duplicate() {
	mut set := new_set()

	set.add(0)
	set.add(0)

	assert set.has(0) == true
	assert set.size() == 1
}

fn test_add_non_duplicates() {
	mut set := new_set()

	set.add(1)
	set.add(0)

	assert set.has(0) == true
	assert set.has(1) == true
	assert set.size() == 2
}

fn test_remove() {
	mut set := new_set()

	set.add(0)
	set.add(1)
	assert set.size() == 2

	set.remove(0)
	assert set.size() == 1
	assert set.has(1) == true
	assert set.has(0) == false
}

fn test_get() {
	mut set := new_set()

	set.add(0)
	set.add(1)
	set.add(3)

	val := set.get(3) or { panic(err) }
	assert val == 3
	set.get(4) or {
		assert err.msg == 'int not found'
		return
	}
	assert true == false // should not reach
}
