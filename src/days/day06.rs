#![allow(dead_code)]

use std::{collections::HashSet, iter::FromIterator};

use array_tool::vec::Shift;

pub fn find_marker_idx(str: &str) -> usize {
    let mut marker_idx: usize = 4;
    let mut m_previous_four = Vec::with_capacity(4);

    for (idx, ch) in str.chars().enumerate() {
        if m_previous_four.len() < 4 {
            m_previous_four.push(ch);
            continue;
        }

        m_previous_four.shift();
        m_previous_four.push(ch);
        let uniq: HashSet<char> = HashSet::from_iter(m_previous_four.iter().cloned());

        if uniq.len() < 4 {
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
    fn test_find_marker_idx() {
        let inputs: Vec<(&str, usize)> = vec![
            ("mjqjpqmgbljsphdztnvjfqwrcgsmlb", 7),
            ("bvwbjplbgvbhsrlpgdmjqwftvncz", 5),
            ("nppdvjthqldpwncqszvftbrmjlhg", 6),
            ("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", 10),
            ("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", 11),
        ];

        for (input, expected) in inputs.iter() {
            let marker_idx = find_marker_idx(input);

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

        let marker_idx = find_marker_idx(&input);

        assert_eq!(marker_idx, 1531);
    }
}
