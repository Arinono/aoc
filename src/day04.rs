#![allow(dead_code)]

#[derive(Eq, PartialEq, Debug)]
pub struct SegRange(usize, usize);

#[derive(Eq, PartialEq, Debug)]
pub struct Pair(SegRange, SegRange);

fn c_split(p: char) -> impl for <'a> Fn(&'a str) -> core::str::Split<'a, char> {
    move |a| a.split(p)
}

pub fn split_pairs(str: &str) -> Pair {
    let raw_pairs = str
        .split(',')
        .flat_map(c_split('-'))
        .flat_map(str::parse::<usize>)
        .collect::<Vec<usize>>();

    Pair(
        SegRange(
            raw_pairs[0],
            raw_pairs[1],
        ),
        SegRange(
            raw_pairs[2],
            raw_pairs[3],
        ),
    )
}

impl Pair {
    fn fully_overlaps(&self) -> bool {
        (self.0.0 <= self.1.0 && self.0.1 >= self.1.1)
            || (self.1.0 <= self.0.0 && self.1.1 >= self.0.1)
    }

    fn overlaps(&self) -> bool {
        !(self.0.1 < self.1.0 || self.1.1 < self.0.0)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_split_pairs() {
        assert_eq!(
            split_pairs("2-4,6-8"),
            Pair(
                SegRange(2, 4),
                SegRange(6, 8),
            ),
        );
    }

    #[test]
    fn test_fully_overlaps() {
        assert_eq!(
            Pair(
                SegRange(2, 4),
                SegRange(6, 8),
            ).fully_overlaps(),
            false,
        );

        assert_eq!(
            Pair(
                SegRange(2, 8),
                SegRange(6, 8),
            ).fully_overlaps(),
            true,
        );

        assert_eq!(
            Pair(
                SegRange(5, 7),
                SegRange(3, 8),
            ).fully_overlaps(),
            true,
        );
    }

    #[test]
    fn test_contains() {
        assert_eq!(
            Pair(
                SegRange(5, 7),
                SegRange(7, 9),
            ).overlaps(),
            true,
        );

        assert_eq!(
            Pair(
                SegRange(5, 7),
                SegRange(8, 9),
            ).overlaps(),
            false,
        );
    }
}

#[cfg(test)]
mod solutions {
    use super::*;
    use std::fs;

    #[test]
    fn part1() {
        let input = fs::read_to_string("./inputs/04.txt").expect("a file");
        let is_true = |v: &bool| *v;
        let fully_overlaps = |p: Pair| p.fully_overlaps();

        let sum = input
            .lines()
            .map(split_pairs)
            .map(fully_overlaps)
            .filter(is_true)
            .count();

        assert_eq!(sum, 485);
    }

    #[test]
    fn part2() {
        let input = fs::read_to_string("./inputs/04.txt").expect("a file");
        let is_true = |v: &bool| *v;
        let overlaps = |p: Pair| p.overlaps();

        let sum = input
            .lines()
            .map(split_pairs)
            .map(overlaps)
            .filter(is_true)
            .count();

        assert_eq!(sum, 857);
    }
}
