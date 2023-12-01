use rayon::iter::{ParallelBridge, ParallelIterator};

const STR_DIGITS: [&str; 9] = [
    "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
];

pub fn solve(input: &String) -> String {
    let sum = input
        .lines()
        .par_bridge()
        .map(|line| get_calibration_value(line))
        .collect::<Vec<usize>>()
        .iter()
        .sum::<usize>();

    sum.to_string()
}

fn get_calibration_value(line: &str) -> usize {
    let mut digits: Vec<usize> = vec![];
    let mut spelled_out: Vec<char> = vec![];

    for c in line.chars().into_iter() {
        if let Some(num) = c.to_digit(10) {
            digits.push(num.try_into().unwrap());
            continue;
        }

        spelled_out.push(c);
        if let Some(num) = get_number_from_spelled_out(&spelled_out) {
            digits.push(num);
            // remove all but last char
            spelled_out = spelled_out.split_off(spelled_out.len() - 1);
        }
    }

    let fst = digits.first().unwrap();
    let lst = digits.last().unwrap();
    format!("{}{}", fst, lst).parse::<usize>().unwrap()
}

fn get_number_from_spelled_out(chars: &Vec<char>) -> Option<usize> {
    let str = chars.into_iter().collect::<String>();

    for (i, s) in STR_DIGITS.into_iter().enumerate() {
        if str.contains(s) {
            return Some(i + 1);
        }
    }

    None
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_get_calibration_value() {
        assert_eq!(get_calibration_value("1abc2"), 12);
        assert_eq!(get_calibration_value("two1nine"), 29);
        assert_eq!(get_calibration_value("eightwothree"), 83);
        assert_eq!(get_calibration_value("abcone2threexyz"), 13);
        assert_eq!(get_calibration_value("xtwone3four"), 24);
        assert_eq!(get_calibration_value("4nineeightseven2"), 42);
        assert_eq!(get_calibration_value("zoneight234"), 14);
        assert_eq!(get_calibration_value("7pqrstsixteen"), 76);
        assert_eq!(get_calibration_value("1twonine"), 19);
        assert_eq!(get_calibration_value("ddgjgcrssevensix37twooneightgt"), 78);
    }

    #[test]
    fn test_solve() {
        let input = "two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen"
            .to_owned();

        assert_eq!(solve(&input), "281");
    }
}
