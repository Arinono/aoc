module sixteen

import exo.twenty_twenty.sixteen.set

struct Range {
	lo int
	hi int
}

// A world of loops. Can't be good 🥲
fn find_fields(rules map[string][]Range, tickets [][]int) map[string]int {
	assert tickets.len > 0
	mut fields := map[string]int{}
	mut cols := map[int]set.Set<string>{}

	for i := 0; i < tickets.first().len; i++ {
		cols[i] = set.Set<string>{}
		mut col := map[int]set.Set<string>{}
		for t in tickets {
			n := t[i]
			col[n] = set.Set<string>{}
			for k, v in rules {
				if (n >= v.first().lo && n <= v.first().hi)
					|| (n >= v.last().lo && n <= v.last().hi) {
					col[n].add(k)
				}
			}
		}
		mut loc_fields := map[string]int{}
		for _, s in col {
			for f in s.get_all() {
				loc_fields[f]++
			}
		}
		for k, v in loc_fields {
			if v == col.len {
				cols[i].add(k)
			}
		}
	}

	mut idx := 0
	cols_len_mem := cols.len
	for fields.len < cols_len_mem {
		for i, s in cols {
			if s.size == 1 {
				f := s.get_all()[0]
				fields[f] = i
				cols.delete(i)
				for _, mut c in cols {
					c.remove(f)
				}
			}
		}
		idx++
	}

	return fields
}

fn sum(nbs []int) int {
	mut sum := 0

	for n in nbs {
		sum += n
	}

	return sum
}

fn single_error_rate(rules map[string][]Range, ticket []int) ?int {
	mut errors := []int{cap: ticket.len}

	for v in ticket {
		mut error := 0
		for _, rs in rules {
			if (v < rs.first().lo || v > rs.first().hi) && (v < rs.last().lo || v > rs.last().hi) {
				error++
			}
		}
		if error == ticket.len {
			errors << v
		}
	}

	rate := sum(errors)
	return if rate > 0 { rate } else { none }
}

fn error_rate(rules map[string][]Range, tickets [][]int) (int, [][]int) {
	mut errors := []int{cap: tickets.len}
	mut valid_tickets := [][]int{cap: tickets.len}
	for t in tickets {
		rate := single_error_rate(rules, t) or {
			valid_tickets << t
			continue
		}
		errors << rate
	}

	return sum(errors), valid_tickets
}

fn parse_ranges(rs string) []Range {
	mut ranges := []Range{cap: 2}

	for r in rs.split(' or ') {
		n := r.split('-')
		ranges << Range{n[0].int(), n[1].int()}
	}

	return ranges
}

fn parse_rules(input string) map[string][]Range {
	mut rules := map[string][]Range{}

	for l in input.split('\n') {
		if l.len == 0 {
			continue
		}

		parts := l.split(':')
		ranges := parse_ranges(parts[1].trim_space())

		rules[parts[0]] = ranges
	}

	return rules
}

fn parse_ticket(input string) []int {
	nbs := input.split(',')
	assert nbs.len > 0
	mut ticket := []int{cap: nbs.len}

	for n in nbs {
		ticket << n.int()
	}

	return ticket
}

fn parse_tickets(input []string) [][]int {
	mut tickets := [][]int{}

	for t in input {
		ticket := parse_ticket(t)
		if ticket.len == 1 {
			continue
		}
		tickets << ticket
	}

	return tickets
}

fn parse_input(input string) (map[string][]Range, []int, [][]int) {
	parts := input.split('\n\n')

	assert parts.len == 3
	assert parts[1].split('\n').len == 2
	assert parts[2].split('\n').len > 1

	rules := parse_rules(parts[0])

	// This splitted lines thing is only to _fix_ the compilation errors when using
	// -autofree. Since the line was too long, it was doing a C thing to display the line
	// w/o breaking it (using /).
	// But then one of the flag triggered a "undeclared error" even if it is.
	your_ticket_section := parts[1].split('\n')
	your_ticket_line := your_ticket_section.last()
	your_ticket := parse_ticket(your_ticket_line)

	tickets_section := parts[2].split('\n')
	tickets_line := tickets_section[1..]
	tickets := parse_tickets(tickets_line)

	return rules, your_ticket, tickets
}

fn ticket_value(ticket []int, fields map[string]int) u64 {
	mut sum := u64(1)

	for f, pos in fields {
		if f.starts_with('departure') {
			sum *= u64(ticket[pos])
		}
	}

	return sum
}

fn run(input string) string {
	rules, your_ticket, tickets := parse_input(input)

	result_1, valid_tickets := error_rate(rules, tickets)
	fields := find_fields(rules, valid_tickets)
	result_2 := ticket_value(your_ticket, fields)

	return '16:\n  Part 1: $result_1\n  Part 2: $result_2'
}
