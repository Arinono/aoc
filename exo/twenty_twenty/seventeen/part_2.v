module part_2

import exo.utils.set

struct Pos4D {
pub:
	x int
	y int
	z int
	w int
}

fn new_pos_4d(x int, y int, z int, w int) Pos4D {
	return Pos4D{x, y, z, w}
}

fn (p Pos4D) str() string {
	return '$p.x:$p.y:$p.z:$p.w'
}

fn new_pos_4d_from_str(key string) Pos4D {
	parts := key.split(':')
	return new_pos_4d(parts[0].int(), parts[1].int(), parts[2].int(), parts[3].int())
}

pub fn parse_input(input string) set.Set<Pos4D> {
	mut actives := set.Set<Pos4D>{}

	for y, l in input.split('\n') {
		if l.len == 0 {
			continue
		}
		for x, c in l {
			match c {
				`#` {
					actives.add(new_pos_4d(x, y, 0, 0))
				}
				else {}
			}
		}
	}

	return actives
}

fn get_neighbours(p Pos4D) set.Set<Pos4D> {
	mut neighbours := set.Set<Pos4D>{}

	for d_x := p.x - 1; d_x <= p.x + 1; d_x++ {
		for d_y := p.y - 1; d_y <= p.y + 1; d_y++ {
			for d_z := p.z - 1; d_z <= p.z + 1; d_z++ {
				for d_w := p.w - 1; d_w <= p.w + 1; d_w++ {
					pos := new_pos_4d(d_x, d_y, d_z, d_w)
					if pos == p {
						continue
					}
					neighbours.add(pos)
				}
			}
		}
	}

	return neighbours
}

fn cycle(actives set.Set<Pos4D>) set.Set<Pos4D> {
	mut new_actives := set.Set<Pos4D>{}
	mut possible_activations := map[string]int{}

	for c in actives.values {
		mut active := 0
		neighbours := get_neighbours(c)

		for n in neighbours.values {
			if n in actives.values {
				active++
			} else {
				if !(n.str() in possible_activations) {
					possible_activations[n.str()] = 0
				}
				possible_activations[n.str()]++
			}
		}

		if active == 2 || active == 3 {
			new_actives.add(c)
		}
	}

	for k, v in possible_activations {
		if v == 3 {
			new_actives.add(new_pos_4d_from_str(k))
		}
	}

	return new_actives
}

pub fn gol(actives set.Set<Pos4D>, ite int) set.Set<Pos4D> {
	mut m_actives := actives

	for _ in 0 .. ite {
		m_actives = cycle(m_actives)
	}

	return m_actives
}
