module main

import os
import regex

struct Passport {
mut:
	byr int
	iyr int
	eyr int
	hgt string
	hcl string
	ecl string
	pid string
	cid string
}

struct ValidBirthYear {
	bir int
}

struct ValidIssueYear {
	iyr int
}

struct ValidExpirationYear {
	eyr int
}

enum LengthSystem {
	metric
	imperial
	invalid
}

struct ValidHeight {
	value  int
	system LengthSystem
}

struct ValidHairColour {
	hcl string
}

struct ValidEyeColour {
	ecl string
}

struct ValidPassportId {
	pid string
}

struct ValidBetterPassport {
	byr ValidBirthYear
	iyr ValidIssueYear
	eyr ValidExpirationYear
	hgt ValidHeight
	hcl ValidHairColour
	ecl ValidEyeColour
	pid ValidPassportId
	cid string
}

struct ValidPassport {
	Passport
}

struct InvalidPassport {
	Passport
}

type CheckedPassport = InvalidPassport | ValidPassport

type BetterCheckedPassport = InvalidPassport | ValidBetterPassport

fn parse_passport(s string) Passport {
	mut passport := Passport{}
	pairs := s.split_by_whitespace()

	for p in pairs {
		key_pair := p.split(':')
		key := key_pair[0]
		pair := key_pair[1]

		match key {
			'byr' {
				passport.byr = pair.int()
			}
			'iyr' {
				passport.iyr = pair.int()
			}
			'eyr' {
				passport.eyr = pair.int()
			}
			'hgt' {
				passport.hgt = pair
			}
			'hcl' {
				passport.hcl = pair
			}
			'ecl' {
				passport.ecl = pair
			}
			'pid' {
				passport.pid = pair
			}
			'cid' {
				passport.cid = pair
			}
			else {}
		}
	}

	return passport
}

fn (p Passport) check_passport() CheckedPassport {
	if p.byr == 0 || p.iyr == 0 || p.eyr == 0 || p.hgt == '' || p.hcl == '' || p.ecl == ''
		|| p.pid == '' {
		return InvalidPassport{p}
	}
	return ValidPassport{p}
}

fn (passports []Passport) check_passports() []CheckedPassport {
	mut checked_passports := []CheckedPassport{}

	for p in passports {
		checked_passports << p.check_passport()
	}

	return checked_passports
}

fn (ps []CheckedPassport) count_valid() int {
	mut valid_count := 0

	for p in ps {
		if p is ValidPassport {
			valid_count++
		}
	}

	return valid_count
}

fn check_byr(byr int) ?ValidBirthYear {
	if byr >= 1920 && byr <= 2002 {
		return ValidBirthYear{byr}
	}
	return error('invalid byr')
}

fn check_iyr(iyr int) ?ValidIssueYear {
	if iyr >= 2010 && iyr <= 2020 {
		return ValidIssueYear{iyr}
	}
	return error('invalid iyr')
}

fn check_eyr(eyr int) ?ValidExpirationYear {
	if eyr >= 2020 && eyr <= 2030 {
		return ValidExpirationYear{eyr}
	}
	return error('invalid eyr')
}

fn check_hgt(hgt string) ?ValidHeight {
	value := hgt.int()
	system := if hgt.ends_with('cm') {
		LengthSystem.metric
	} else if hgt.ends_with('in') {
		LengthSystem.imperial
	} else {
		LengthSystem.invalid
	}

	match system {
		.metric {
			if value >= 150 && value <= 193 {
				return ValidHeight{value, system}
			}
			return error('invalid metric value')
		}
		.imperial {
			if value >= 59 && value <= 76 {
				return ValidHeight{value, system}
			}
			return error('invalid imperial value')
		}
		.invalid {
			return error('invalid hgt')
		}
	}
}

fn check_hcl(hcl string) ?ValidHairColour {
	mut re := regex.regex_opt(r'^#[a-f0-9]{6}$') or { panic(err) }

	start, end := re.match_string(hcl.trim(' '))

	if start == -1 && end == 0 {
		return error('invalid hcl')
	}
	return ValidHairColour{hcl}
}

fn check_ecl(ecl string) ?ValidEyeColour {
	if ecl == 'amb' || ecl == 'blu' || ecl == 'brn' || ecl == 'gry' || ecl == 'grn' || ecl == 'hzl'
		|| ecl == 'oth' {
		return ValidEyeColour{ecl}
	}
	return error('invalid ecl')
}

fn check_pid(pid string) ?ValidPassportId {
	// very weird error. if I remove the anchors, i have 1 more valid passport
	mut re := regex.regex_opt(r'^\d{9}$') or { panic(err) }

	start, end := re.match_string(pid)

	if start == -1 && end == 0 {
		return error('invalid pid')
	}
	return ValidPassportId{pid}
}

// I guess there is a better abstraction here 🤔
fn (p Passport) better_check_passport() BetterCheckedPassport {
	byr := check_byr(p.byr) or { return InvalidPassport{p} }
	iyr := check_iyr(p.iyr) or { return InvalidPassport{p} }
	eyr := check_eyr(p.eyr) or { return InvalidPassport{p} }
	hgt := check_hgt(p.hgt) or { return InvalidPassport{p} }
	hcl := check_hcl(p.hcl) or { return InvalidPassport{p} }
	ecl := check_ecl(p.ecl) or { return InvalidPassport{p} }
	pid := check_pid(p.pid) or { return InvalidPassport{p} }
	return ValidBetterPassport{byr, iyr, eyr, hgt, hcl, ecl, pid, p.cid}
}

fn (passports []Passport) better_check_passports() []BetterCheckedPassport {
	mut checked_passports := []BetterCheckedPassport{}

	for p in passports {
		checked_passports << p.better_check_passport()
	}

	return checked_passports
}

fn (ps []BetterCheckedPassport) count_valid() int {
	mut valid_count := 0

	for p in ps {
		if p is ValidBetterPassport {
			valid_count++
		}
	}

	return valid_count
}

fn parse_input(input string) []Passport {
	mut passports := []Passport{}

	for s in input.split('\n\n') {
		passports << parse_passport(s.replace('\n', ' ').trim(' '))
	}

	return passports
}

fn main() {
	input := os.read_file('input.txt') ?

	checked_passports := parse_input(input).check_passports()
	better_checked_passports := parse_input(input).better_check_passports()

	println(checked_passports.count_valid())
	println(better_checked_passports.count_valid())
}
