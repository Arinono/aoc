module set

fn test_set_init() {
	set := Set<string>{}

	assert set.size == 0
}

fn test_set_add_no_dupes() {
	mut set := Set<string>{}

	set.add('a')
	assert set.size == 1

	set.add('a')
	assert set.size == 1
}

fn test_set_has() {
	mut set := Set<string>{}

	set.add('a')
	assert set.has('a') == true
	assert set.has('b') == false
}

fn test_set_delete() {
	mut set := Set<string>{}

	set.add('a')
	assert set.has('a') == true

	set.delete('a')
	assert set.has('a') == false
	assert set.size == 0
	set.delete('a') // should not error
}

fn test_get_all_values() {
	mut set := Set<string>{}

	set.add('a')
	set.add('b')

	assert set.get_all() == ['a', 'b']
}

fn test_get_val_at_idx() {
	mut set := Set<string>{}

	set.add('a')
	set.add('b')

	v0 := set.get_at(0) or { panic('An unreachable instruction occured.') }
	v1 := set.get_at(1) or { panic('An unreachable instruction occured.') }
	assert v0 == 'a'
	assert v1 == 'b'

	set.get_at(-1) or { assert err.msg == 'Set: index cannot be < 0.' }
	set.get_at(2) or { assert err.msg == 'Set: value at index 2 not found.' }
}
