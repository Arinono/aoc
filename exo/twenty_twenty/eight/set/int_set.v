module set

struct IntSet {
mut:
	set []int
}

fn (mut s IntSet) sort() {
	s.set.sort(a < b)
}

pub fn (s IntSet) size() u32 {
	return u32(s.set.len)
}

pub fn (mut s IntSet) add(val int) {
	if !s.has(val) {
		s.set << val
		s.sort()
	}
}

pub fn (mut s IntSet) remove(val int) {
	mut new_set := []int{}
	for i in s.set {
		if i != val {
			new_set << i
		}
	}
	s.set = new_set
	s.sort()
}

pub fn (s IntSet) get(val int) ?int {
	if s.has(val) {
		return s.set[s.set.index(val)]
	}
	return error('int not found')
}

pub fn (s IntSet) has(val int) bool {
	return val in s.set
}

pub fn new_set() IntSet {
	return IntSet{[]}
}
