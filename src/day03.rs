#![allow(dead_code)]

use array_tool::vec::Intersect;

type Item = usize;

type Rucksack = (Vec<Item>, Vec<Item>, Vec<Item>);

pub fn new_item(char: char) -> Item {
    let nums = vec![
        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
    ];

    let fd = nums
        .iter()
        .position(|&n| n == char)
        .expect("to find a char");

    fd + 1
}

pub fn new_rucksack(str: &str) -> Rucksack {
    let string = str.to_owned();

    let whole: Vec<Item> = string
        .chars()
        .map(new_item)
        .collect();

    let (left, right) = whole.split_at(str.len() / 2);

    (left.to_vec(), right.to_vec(), whole)
}

pub fn find_packing_failure(rucksack: Rucksack) -> Item {
    *rucksack.0
        .intersect(rucksack.1)
        .first()
        .expect("a match")
}

// terrible function to look at
pub fn find_badge(rucksacks: Vec<Rucksack>) -> Item {
    let one = rucksacks[0].clone();
    let two = rucksacks[1].clone();
    let three = rucksacks[2].clone();
    let mut common: Vec<usize> = vec![];
    let mut m_two = two.2;
    let mut m_three = three.2;

    for i1 in one.2.iter() {
        if let Some(pos) = m_two.iter().position(|i2| i1 == i2) {
            if let Some (pos2) = m_three.iter().position(|i3| i1 == i3) {
                common.push(*i1);
                m_two.remove(pos);
                m_three.remove(pos2);
            }
        }
    }

    return *common.first().expect("a match");
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn new_items() {
        assert_eq!(new_item('a'), 1);
        assert_eq!(new_item('z'), 26);
        assert_eq!(new_item('A'), 27);
        assert_eq!(new_item('Z'), 52);
    }

    #[test]
    fn new_rucksacks() {
        println!("{:?}", new_rucksack("vJrwpWtwJgWrhcsFMMfFFhFp"));
        assert_eq!(
            new_rucksack("vJrwpWtwJgWrhcsFMMfFFhFp"),
            (vec![
                22, 36, 18, 23, 16, 49, 20, 23, 36, 7, 49, 18,
            ], vec![
                8, 3, 19, 32, 39, 39, 6, 32, 32, 8, 32, 16,
            ], vec![
                22, 36, 18, 23, 16, 49, 20, 23, 36, 7, 49, 18,
                8, 3, 19, 32, 39, 39, 6, 32, 32, 8, 32, 16,
            ]),
        );
    }

    #[test]
    fn find_packing_failure_in_a_rucksack() {
        let rucksack = new_rucksack("vJrwpWtwJgWrhcsFMMfFFhFp");

        let item = find_packing_failure(rucksack);

        assert_eq!(item, 16);
    }

    #[test]
    fn find_packing_failures() {
        let input = r"vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw";

        let sum: usize = input
            .lines()
            .map(new_rucksack)
            .map(find_packing_failure)
            .sum();

        assert_eq!(sum, 157);
    }

    #[test]
    fn find_badges() {
        let input = r"vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg";

        let rucksacks: Vec<Rucksack> = input
            .lines()
            .map(new_rucksack)
            .collect();

        let badge = find_badge(rucksacks);

        assert_eq!(badge, 18);
    }
}

#[cfg(test)]
mod solutions {
    use std::fs;
    use super::*;

    #[test]
    fn part1() {
        let input = fs::read_to_string("./inputs/03.txt").expect("a file");

        let sum: usize = input
            .lines()
            .map(new_rucksack)
            .map(find_packing_failure)
            .sum();

        assert_eq!(sum, 7850);
    }

    #[test]
    fn part2() {
        let input = fs::read_to_string("./inputs/03.txt").expect("a file");

        let rucksacks: Vec<Rucksack> = input
            .lines()
            .map(new_rucksack)
            .collect();

        // starting from here, it diverges from the idea I had.
        // I need more time to find how to do it properly:
        // ruck.iter.take(3).map(find_badge).sum
        // kinda...
        let mut idx = 0;
        let mut sum = 0;
        let mut m_rucksacks = rucksacks.clone();

        while idx < rucksacks.len() {
            let triplet: Vec<Rucksack> = m_rucksacks.drain(..3).collect();
            sum += find_badge(triplet);
            idx += 3;
        }

        assert_eq!(sum, 2581);
    }
}
























