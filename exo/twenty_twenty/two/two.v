module two

import regex

type CheckedPassword = InvalidPassword | ValidPassword

struct ValidPassword {
	password Password
}

struct InvalidPassword {
	password Password
}

struct Password {
	min    int
	max    int
	policy string
	passwd string
}

type PolicyFn = fn (Password) CheckedPassword

fn get_passwds(lines []string) []Password {
	mut passwds := []Password{}
	mut re := regex.regex_opt(r'([\d]+)-([\d]+)\s([\w]):\s([\w]+)') or { panic(err) }

	for line in lines {
		re.match_string(line)

		passwds << Password{line[re.groups[0]..re.groups[1]].int(), line[re.groups[2]..re.groups[3]].int(), line[re.groups[4]..re.groups[5]], line[re.groups[6]..re.groups[7]]}
	}

	return passwds
}

fn policy_1(passwd Password) CheckedPassword {
	mut count := 0

	for c in passwd.passwd {
		if rune(c).str() == passwd.policy {
			count++
		}
	}

	if count >= passwd.min && count <= passwd.max {
		return ValidPassword{passwd}
	}
	return InvalidPassword{passwd}
}

// Flemme the rename les members de Password
fn policy_2(passwd Password) CheckedPassword {
	mut matches := 0
	if passwd.min - 1 < 0 || passwd.max - 1 < 0 {
		panic('out of bounds')
	}

	char1 := rune(passwd.passwd[passwd.min - 1]).str()
	char2 := rune(passwd.passwd[passwd.max - 1]).str()
	if char1.str() == passwd.policy {
		matches++
	}
	if char2.str() == passwd.policy {
		matches++
	}

	if matches == 1 {
		return ValidPassword{passwd}
	}
	return InvalidPassword{passwd}
}

fn check_password_policy(passwds []Password, policy PolicyFn) []CheckedPassword {
	mut checked_passwds := []CheckedPassword{}

	for passwd in passwds {
		checked_passwds << policy(passwd)
	}

	return checked_passwds
}

fn passwd_policy_checker(lines []string, policy PolicyFn) int {
	mut valid_count := 0

	passwds := get_passwds(lines)
	checked_passwds := check_password_policy(passwds, policy)

	for passwd in checked_passwds {
		match passwd {
			ValidPassword {
				valid_count++
			}
			else {}
		}
	}

	return valid_count
}

fn run(input string) string {
	mut lines := []string{}

	for l in input.split('\n') {
		if l.len == 0 {
			continue
		}
		lines << l
	}

	handle_1 := go passwd_policy_checker(lines, PolicyFn(policy_1))
	handle_2 := go passwd_policy_checker(lines, PolicyFn(policy_2))

	result_1 := handle_1.wait()
	result_2 := handle_2.wait()

	return '02:\n  Part 1: $result_1\n  Part 2: $result_2'
}
