module main

import cli { Command, Flag }
import os
import exo.twenty_twenty.one as exo_2020_01
import exo.twenty_twenty.two as exo_2020_02
import exo.twenty_twenty.three as exo_2020_03
import exo.twenty_twenty.four as exo_2020_04
import exo.twenty_twenty.five as exo_2020_05
import exo.twenty_twenty.six as exo_2020_06
import exo.twenty_twenty.seven as exo_2020_07
import exo.twenty_twenty.eight as exo_2020_08
import exo.twenty_twenty.nine as exo_2020_09
import exo.twenty_twenty.ten as exo_2020_10
import exo.twenty_twenty.eleven as exo_2020_11
import exo.twenty_twenty.twelve as exo_2020_12
import exo.twenty_twenty.thirteen as exo_2020_13
import exo.twenty_twenty.fourteen as exo_2020_14
import exo.twenty_twenty.fifteen as exo_2020_15

const runnables = map{
	2020: map{
		1:  Runnable{
			year: 2020
			day: 1
			file_path: 'inputs/2020/01.txt'
			run_fn: exo_2020_01.run
		}
		2:  Runnable{
			year: 2020
			day: 2
			file_path: 'inputs/2020/02.txt'
			run_fn: exo_2020_02.run
		}
		3:  Runnable{
			year: 2020
			day: 3
			file_path: 'inputs/2020/03.txt'
			run_fn: exo_2020_03.run
		}
		4:  Runnable{
			year: 2020
			day: 4
			file_path: 'inputs/2020/04.txt'
			run_fn: exo_2020_04.run
		}
		5:  Runnable{
			year: 2020
			day: 5
			file_path: 'inputs/2020/05.txt'
			run_fn: exo_2020_05.run
		}
		6:  Runnable{
			year: 2020
			day: 6
			file_path: 'inputs/2020/06.txt'
			run_fn: exo_2020_06.run
		}
		7:  Runnable{
			year: 2020
			day: 7
			file_path: 'inputs/2020/07.txt'
			run_fn: exo_2020_07.run
		}
		8:  Runnable{
			year: 2020
			day: 8
			file_path: 'inputs/2020/08.txt'
			run_fn: exo_2020_08.run
		}
		9:  Runnable{
			year: 2020
			day: 9
			file_path: 'inputs/2020/09.txt'
			run_fn: exo_2020_09.run
		}
		10: Runnable{
			year: 2020
			day: 10
			file_path: 'inputs/2020/10.txt'
			run_fn: exo_2020_10.run
		}
		11: Runnable{
			year: 2020
			day: 11
			file_path: 'inputs/2020/11.txt'
			run_fn: exo_2020_11.run
		}
		12: Runnable{
			year: 2020
			day: 12
			file_path: 'inputs/2020/12.txt'
			run_fn: exo_2020_12.run
		}
		13: Runnable{
			year: 2020
			day: 13
			file_path: 'inputs/2020/13.txt'
			run_fn: exo_2020_13.run
		}
		14: Runnable{
			year: 2020
			day: 14
			file_path: 'inputs/2020/14.txt'
			run_fn: exo_2020_14.run
		}
		15: Runnable{
			year: 2020
			day: 15
			file_path: 'inputs/2020/15.txt'
			run_fn: exo_2020_15.run
		}
	}
}

type RunFn = fn (string) string

struct Runnable {
	year      u16
	day       u16
	file_path string
	run_fn    RunFn
}

enum SupportedCommand {
	all
	year
	single
}

type CommandFn = fn (Command)

fn check_input(sc SupportedCommand) ?CommandFn {
	match sc {
		.single {
			return fn (c Command) ? {
				year := c.flags.get_int('year') or {
					panic('Unable to get value for flag \'year\': $err')
				}
				day := c.flags.get_int('day') or {
					panic('Unable to get value for flag \'day\': $err')
				}
				r := runnables[year][day] or {
					return error('\n  Unable to find a suitable exercise to run: $year ${day:02}')
				}
				if !os.exists(r.file_path) {
					return error('\n  Unable to find input file at \'$r.file_path\'')
				}
				return none
			}
		}
		.year {
			return fn (c Command) ? {
				year := c.flags.get_int('year') or {
					panic('Unable to get value for flag \'year\': $err')
				}
				if !(year in runnables) {
					return error('\n  Unable to find a suitable year to run: $year')
				}
				year_runnables := runnables[year].clone()
				for _, r in year_runnables {
					if !os.exists(r.file_path) {
						return error('\n  Unable to find input file at \'$r.file_path\'')
					}
				}
			}
		}
		.all {
			return fn (c Command) ? {
				return error('not implemented')
			}
		}
	}
}

fn run_single(r Runnable) string {
	input := os.read_file(r.file_path) or {
		panic('An unreachable error occured while running $r.year $r.day')
	}
	return r.run_fn(input)
}

fn run_multi(rs map[int]Runnable) ?[]string {
	mut ths := []thread string{}
	for _, r in rs {
		ths << go run_single(r)
	}
	return ths.wait()
}

fn run(sc SupportedCommand) ?CommandFn {
	match sc {
		.single {
			return fn (c Command) ? {
				year := c.flags.get_int('year') ?
				day := c.flags.get_int('day') ?
				input := os.read_file(runnables[year][day].file_path) ?
				result := runnables[year][day].run_fn(input)
				println('$year $result')
			}
		}
		.year {
			return fn (c Command) ? {
				year := c.flags.get_int('year') ?
				println('Running $year ...\n')
				results := run_multi(runnables[year]) ?
				for r in results {
					println(r)
				}
			}
		}
		.all {
			return fn (c Command) ? {
				return error('not implemented')
			}
		}
	}
}

fn single(mut m_cli Command) Command {
	mut single := Command{
		name: 'single'
		description: 'Run a single exercise.'
		pre_execute: check_input(.single) or { panic(err) }
		execute: run(.single) or { panic(err) }
	}
	single.add_flag(Flag{
		flag: .int
		required: true
		name: 'year'
		abbrev: 'y'
		description: 'Year of the exercise.'
	})
	single.add_flag(Flag{
		flag: .int
		required: true
		name: 'day'
		abbrev: 'd'
		description: 'Day of the exercise.'
	})

	m_cli.add_command(single)

	return m_cli
}

fn year(mut m_cli Command) Command {
	mut year := Command{
		name: 'year'
		description: 'Run a year exercise.'
		pre_execute: check_input(.year) or { panic(err) }
		execute: run(.year) or { panic(err) }
	}
	year.add_flag(Flag{
		flag: .int
		required: true
		name: 'year'
		abbrev: 'y'
		description: 'Year of the exercise.'
	})

	m_cli.add_command(year)

	return m_cli
}

fn main() {
	mut m_cli := Command{
		name: 'aoc'
		description: 'Run AdventOfCode exercises.'
		version: '0.0.1'
	}

	setup_cli(mut m_cli, single, year, setup, parse_args)
}

fn setup(mut m_cmd Command) Command {
	m_cmd.setup()
	return m_cmd
}

fn parse_args(mut m_cmd Command) Command {
	m_cmd.parse(os.args)
	return m_cmd
}

fn setup_cli(mut a Command, ab fn (mut Command) Command, bd fn (mut Command) Command, de fn (mut Command) Command, ef fn (mut Command) Command) Command {
	mut m_ab := ab(mut a)
	mut m_bd := bd(mut m_ab)
	mut m_de := de(mut m_bd)
	return ef(mut m_de)
}
