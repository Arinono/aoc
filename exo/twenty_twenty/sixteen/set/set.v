module set

pub struct Set<T> {
mut:
	val []T
pub mut:
	size u16
}

pub fn (s Set<T>) has(v T) bool {
	for lv in s.val {
		if lv == v {
			return true
		}
	}
	return false
}

pub fn (mut s Set<T>) add(v T) {
	if !s.has(v) {
		s.val << v
		s.size++
	}
}

pub fn (mut s Set<T>) remove(v T) {
	if s.has(v) {
		mut tmp_set := new_set<T>()
		for lv in s.val {
			if lv != v {
				tmp_set.add(lv)
			}
		}
		s.val = tmp_set.get_all()
		s.size = tmp_set.size
	}
}

pub fn (s Set<T>) get_at(idx int) ?T {
	if idx < 0 {
		return error('Set: index cannot be < 0.')
	}
	if idx > s.size - 1 {
		return error('Set: value at index $idx not found.')
	}

	for i, lv in s.val {
		if i == idx {
			return lv
		}
	}

	return none
}

pub fn (s Set<T>) get_all() []T {
	return s.val
}

pub fn new_set<T>() Set<T> {
	return Set{
		val: []T{}
	}
}
