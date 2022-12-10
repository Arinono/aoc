#![allow(dead_code)]

use std::{collections::HashSet, iter::FromIterator};

use array_tool::vec::Shift;

pub fn find_marker_idx(str: &str, marker_size: usize) -> usize {
    let mut marker_idx: usize = marker_size;
    let mut m_previous_four = Vec::with_capacity(marker_size);

    for (idx, ch) in str.chars().enumerate() {
        if m_previous_four.len() < marker_size {
            m_previous_four.push(ch);
            continue;
        }

        m_previous_four.shift();
        m_previous_four.push(ch);
        let uniq: HashSet<char> = HashSet::from_iter(m_previous_four.iter().cloned());

        if uniq.len() < marker_size {
            continue;
        }

        marker_idx = idx;
        break;
    }

    marker_idx + 1
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_find_marker_idx_from_4() {
        let inputs: Vec<(&str, usize)> = vec![
            ("mjqjpqmgbljsphdztnvjfqwrcgsmlb", 7),
            ("bvwbjplbgvbhsrlpgdmjqwftvncz", 5),
            ("nppdvjthqldpwncqszvftbrmjlhg", 6),
            ("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", 10),
            ("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", 11),
        ];

        for (input, expected) in inputs.iter() {
            let marker_idx = find_marker_idx(input, 4);

            assert_eq!(marker_idx, *expected);
        }
    }

    #[test]
    fn test_find_marker_idx_from_14() {
        let inputs: Vec<(&str, usize)> = vec![
            ("mjqjpqmgbljsphdztnvjfqwrcgsmlb", 19),
            ("bvwbjplbgvbhsrlpgdmjqwftvncz", 23),
            ("nppdvjthqldpwncqszvftbrmjlhg", 23),
            ("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", 29),
            ("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", 26),
        ];

        for (input, expected) in inputs.iter() {
            let marker_idx = find_marker_idx(input, 14);

            assert_eq!(marker_idx, *expected);
        }
    }
}

#[cfg(test)]
mod solutions {
    use std::fs;
    use super::*;

    fn read_file() -> String {
        fs::read_to_string("./inputs/06.txt").expect("a file")
    }

    #[test]
    fn part1() {
        let input = read_file();

        let marker_idx = find_marker_idx(&input, 4);

        assert_eq!(marker_idx, 1531);
    }

    #[test]
    fn part2() {
        let input = read_file();

        let marker_idx = find_marker_idx(&input, 14);

        assert_eq!(marker_idx, 2518);
    }
}
