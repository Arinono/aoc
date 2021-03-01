module main

fn test_passport_parser() {
	input := 'ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in
'

	passports := parse_input(input)

	assert passports.len == 4
	assert passports[0].ecl == 'gry'
	assert passports[3].eyr == 2025
}

fn test_passports_checker() {
	input := 'ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in
'

	passports := parse_input(input)
	checked_passports := passports.check_passports()

	assert checked_passports[0] is ValidPassport
	assert checked_passports[1] is InvalidPassport
	assert checked_passports[2] is ValidPassport
	assert checked_passports[3] is InvalidPassport
}

fn test_better_passports_checker() {
	input := 'eyr:1972 cid:100
hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

iyr:2019
hcl:#602927 eyr:1967 hgt:170cm
ecl:grn pid:012533040 byr:1946

hcl:dab227 iyr:2012
ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

hgt:59cm ecl:zzz
eyr:2038 hcl:74454a iyr:2023
pid:3556412378 byr:2007

pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f

eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022

iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719

hcl:#c0946f byr:1933 eyr:2025 pid:517067213 hgt:173cm
ecl:hzl
iyr:2018

iyr:2013
pid:062607211 eyr:2020
hgt:174cm
byr:1990
ecl:blu hcl:#888785

iyr:2013
pid:062607211
eyr:2025 hgt:173cm byr:1933
ecl:blu hcl:#888785
'

	passports := parse_input(input)
	better_checked_passports := passports.better_check_passports()

	mut valid_count := 0
	mut invalid_count := 0

	for p in better_checked_passports {
		match p {
			ValidBetterPassport {
				valid_count++
			}
			InvalidPassport {
				invalid_count++
			}
		}
	}

	assert valid_count == 7
	assert invalid_count == 4
}

fn test_check_byr() {
	ok_values := [1920, 2002]
	nok_values := [1919, 2003]

	for v in ok_values {
		byr := check_byr(v) or { panic(err) }
		assert byr == ValidBirthYear{v}
	}

	for v in nok_values {
		check_byr(v) or {
			assert err.str() == 'invalid byr'
			continue
		}
	}
}

fn test_check_iyr() {
	ok_values := [2010, 2020]
	nok_values := [2009, 2021]

	for v in ok_values {
		iyr := check_iyr(v) or { panic(err) }
		assert iyr == ValidIssueYear{v}
	}

	for v in nok_values {
		check_iyr(v) or {
			assert err.str() == 'invalid iyr'
			continue
		}
	}
}

fn test_check_eyr() {
	ok_values := [2020, 2030]
	nok_values := [2019, 2031]

	for v in ok_values {
		eyr := check_eyr(v) or { panic(err) }
		assert eyr == ValidExpirationYear{v}
	}

	for v in nok_values {
		check_eyr(v) or {
			assert err.str() == 'invalid eyr'
			continue
		}
	}
}

fn test_check_hgt() {
	nok_values := ['190in', '190', '149cm', '194cm', '58in', '77in', '60i', '190c']

	hgt_1 := check_hgt('60in') or { panic(err) }
	hgt_2 := check_hgt('190cm') or { panic(err) }
	assert hgt_1 == ValidHeight{60, LengthSystem.imperial}
	assert hgt_2 == ValidHeight{190, LengthSystem.metric}

	for v in nok_values {
		check_hgt(v) or {
			assert err.str().starts_with('invalid ') == true
			continue
		}
	}
}

fn test_check_hcl() {
	nok_values := ['#123abz', '123abc']

	hcl := check_hcl('#123abc') or { panic(err) }
	assert hcl == ValidHairColour{'#123abc'}

	for v in nok_values {
		check_hcl(v) or {
			assert err.str() == 'invalid hcl'
			continue
		}
	}
}

fn test_check_ecl() {
	ecl_amb := check_ecl('amb') or { panic(err) }
	ecl_blu := check_ecl('blu') or { panic(err) }
	ecl_brn := check_ecl('brn') or { panic(err) }
	ecl_gry := check_ecl('gry') or { panic(err) }
	ecl_grn := check_ecl('grn') or { panic(err) }
	ecl_hzl := check_ecl('hzl') or { panic(err) }
	ecl_oth := check_ecl('oth') or { panic(err) }

	assert ecl_amb == ValidEyeColour{'amb'}
	assert ecl_blu == ValidEyeColour{'blu'}
	assert ecl_brn == ValidEyeColour{'brn'}
	assert ecl_gry == ValidEyeColour{'gry'}
	assert ecl_grn == ValidEyeColour{'grn'}
	assert ecl_hzl == ValidEyeColour{'hzl'}
	assert ecl_oth == ValidEyeColour{'oth'}

	check_ecl('inv') or {
		assert err.str() == 'invalid ecl'
		return
	}
}

fn test_check_pid() {
	valid_pid := check_pid('000000001') or { panic(err) }

	assert valid_pid == ValidPassportId{'000000001'}

	check_pid('0123456789') or {
		assert err.str() == 'invalid pid'
		return
	}
}
