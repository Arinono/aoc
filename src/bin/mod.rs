extern crate aoc;

use anyhow::Result;
use clap::Parser;
use std::{fmt::Display, fs, str::FromStr};

#[derive(Parser)]
#[command(author, version)]
struct Cli {
    #[arg(short, long)]
    day: Option<Day>,

    #[arg(short, long)]
    part: Option<Part>,
}

#[derive(Debug, Clone)]
struct Day(u32);

impl FromStr for Day {
    type Err = anyhow::Error;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let day = s.parse::<u32>()?;
        if day < 1 || day > 25 {
            return Err(anyhow::anyhow!("Invalid day"));
        }
        Ok(Day(day))
    }
}

#[derive(Debug, Clone)]
struct Part(u32);

impl FromStr for Part {
    type Err = anyhow::Error;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let part = s.parse::<u32>()?;
        if part != 1 && part != 2 {
            return Err(anyhow::anyhow!("Invalid part"));
        }
        Ok(Part(part))
    }
}

impl Day {
    fn as_padded(&self) -> String {
        format!("{:0>2}", self.0)
    }
}

impl Display for Day {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.as_padded())
    }
}

trait Run {
    fn run(&self, part: Part) -> Result<String>;
}

impl Run for Day {
    fn run(&self, part: Part) -> Result<String> {
        let input = fs::read_to_string(format!("./inputs/day{}.txt", self.as_padded()))?;

        Ok(match self.0 {
            1 => match part.0 {
                1 => aoc::day01::part1::solve(&input),
                2 => aoc::day01::part2::solve(&input),
                _ => format!(
                    "{}\n\t{}",
                    aoc::day01::part1::solve(&input),
                    aoc::day01::part2::solve(&input),
                ),
            },
            2 => match part.0 {
                1 => aoc::day02::part1::solve(&input),
                2 => aoc::day02::part2::solve(&input),
                _ => format!(
                    "{}\n\t{}",
                    aoc::day02::part1::solve(&input),
                    aoc::day02::part2::solve(&input),
                ),
            },
            3 => match part.0 {
                1 => aoc::day03::part1::solve(&input),
                2 => aoc::day03::part2::solve(&input),
                _ => format!(
                    "{}\n\t{}",
                    aoc::day03::part1::solve(&input),
                    aoc::day03::part2::solve(&input),
                ),
            },
            _ => todo!(),
        })
    }
}

fn main() -> Result<()> {
    let cli = Cli::parse();

    if let Some(day) = cli.day {
        if let Some(part) = cli.part {
            println!("Day {}:", day);
            println!("\t{}", day.run(part)?);
            return Ok(());
        }

        println!("Day {}:", day);
        println!("\t{}", day.run(Part(0))?);
        return Ok(());
    }

    for day in 1..=25 {
        println!("Day {}:", Day(day));
        println!("\t{}", Day(day).run(Part(0))?);
    }

    Ok(())
}
