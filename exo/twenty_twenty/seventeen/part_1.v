// module part_1

// import exo.utils.set

// pub struct Pos3D {
// pub:
// 	x int
// 	y int
// 	z int
// }
// pub fn new_pos_3d(x int, y int, z int) Pos3D {
// 	return Pos3D{x, y , z}
// }
// fn (p Pos3D) str() string {
// 	return '${p.x}:${p.y}:${p.z}'
// }
// fn new_pos_3d_from_str(key string) Pos3D {
// 	parts := key.split(':')
// 	return new_pos_3d(parts[0].int(), parts[1].int(), parts[2].int())
// }

// pub fn parse_input(input string) set.Set<Pos3D> {
// 	mut actives := set.Set<Pos3D>{}

// 	for y, l in input.split('\n') {
// 		if l.len == 0 {
// 			continue
// 		}
// 		for x, c in l {
// 			match c {
// 				`#` {
// 					actives.add(new_pos_3d(x, y, 0))
// 				} else {}
// 			}
// 		}
// 	}

// 	return actives
// }

// pub fn get_neighbours(p Pos3D) set.Set<Pos3D> {
// 	mut neighbours := set.Set<Pos3D>{}

// 	for d_x := p.x - 1; d_x <= p.x + 1; d_x++ {
// 		for d_y := p.y - 1; d_y <= p.y + 1; d_y++ {
// 			for d_z := p.z - 1; d_z <= p.z + 1; d_z++ {
// 				pos := new_pos_3d(d_x, d_y, d_z)
// 				if pos == p {
// 					continue
// 				}
// 				neighbours.add(pos)
// 			}	
// 		}
// 	}

// 	return neighbours
// }

// pub fn cycle(actives set.Set<Pos3D>) set.Set<Pos3D> {
// 	mut new_actives := set.Set<Pos3D>{}
// 	mut possible_activations := map[string]int{}

// 	for c in actives.values {
// 		mut active := 0
// 		neighbours := get_neighbours(c)

// 		for n in neighbours.values {
// 			if n in actives.values {
// 				active++
// 			} else {
// 				if !(n.str() in possible_activations) {
// 					possible_activations[n.str()] = 0
// 				}
// 				possible_activations[n.str()]++
// 			}
// 		}

// 		if active == 2 || active == 3 {
// 			new_actives.add(c)
// 		}
// 	}

// 	for k, v in possible_activations {
// 		if v == 3 {
// 			new_actives.add(new_pos_3d_from_str(k))
// 		}
// 	}

// 	return new_actives
// }

// pub fn gol(actives set.Set<Pos3D>, ite int) set.Set<Pos3D> {
// 	mut m_actives := actives

// 	for _ in 0 .. ite {
// 		m_actives = cycle(m_actives)		
// 	}

// 	return m_actives
// }
