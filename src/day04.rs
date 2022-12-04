#![allow(dead_code)]

#[derive(Eq, PartialEq, Debug)]
pub struct SegRange(usize, usize);

#[derive(Eq, PartialEq, Debug)]
pub struct Pair(SegRange, SegRange);

pub fn split_pairs(str: &str) -> Pair {
    let raw_pair = str
        .split_once(',')
        .expect("two pairs");

    let left_pair = raw_pair.0
        .split_once('-')
        .expect("two numbers");

    let right_pair = raw_pair.1
        .split_once('-')
        .expect("two numbers");

    Pair(
        SegRange(
            left_pair.0.parse::<usize>().expect("a number"),
            left_pair.1.parse::<usize>().expect("a number"),
        ),
        SegRange(
            right_pair.0.parse::<usize>().expect("a number"),
            right_pair.1.parse::<usize>().expect("a number"),
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

        let sum = input
            .lines()
            .map(split_pairs)
            .map(|p| p.fully_overlaps())
            .filter(|b| *b)
            .count();

        assert_eq!(sum, 485);
    }

    #[test]
    fn part2() {
        let input = fs::read_to_string("./inputs/04.txt").expect("a file");

        let sum = input
            .lines()
            .map(split_pairs)
            .map(|p| p.overlaps())
            .filter(|b| *b)
            .count();

        assert_eq!(sum, 857);
    }
}
