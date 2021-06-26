module set

pub struct Set<T> {
pub mut:
	values []T
	size   int
}

pub fn (s Set<T>) has(v T) bool {
	return v in s.values
}

pub fn (mut s Set<T>) add(v T) {
	if !s.has(v) {
		s.values << v
		s.size++
	}
}

pub fn (mut s Set<T>) delete(v T) {
	if s.has(v) {
		for i, x in s.values {
			if x == v {
				s.values.delete(i)
				s.size--
			}
		}
	}
}

pub fn (s Set<T>) get_at(idx int) ?T {
	if idx < 0 {
		return error('Set: index cannot be < 0.')
	}
	if idx > s.size - 1 {
		return error('Set: value at index $idx not found.')
	}

	for i, lv in s.values {
		if i == idx {
			return lv
		}
	}

	return none
}

pub fn (s Set<T>) get_all() []T {
	return s.values
}
