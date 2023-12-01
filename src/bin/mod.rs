extern crate aoc;
    
use anyhow::Result;
use aoc::*;
use clap::Parser;
use std::{fs, fmt::{Display, Formatter, self}};

#[derive(Parser)]
#[command(author, version)]
struct Cli {
    #[arg(short, long)]
    day: u32,

    #[arg(short, long)]
    part: Option<u32>,
}

fn main() -> Result<()> {
    let cli = Cli::parse();
    let day = cli.day;
    let padded_day = format!("{:0>2}", day);

    let input = fs::read_to_string(format!("./inputs/day{}.txt", &padded_day))?;

    match day {
        1 => {
            match cli.part {
                Some (1) => println!("{}", day01::part1::solve(&input)),
                Some (2) => todo!(),
                None => {
                    println!("{}", day01::part1::solve(&input));
                },
                Some (_) => {
                    return Err(anyhow::anyhow!("Invalid part number"));
                },
            }
        },
        _ => todo!(),
    }

    Ok(())
}
