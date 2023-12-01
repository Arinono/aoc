pub fn solve(input: &String) -> String {
    let res: usize = input
        .lines()
        .into_iter()
        .map(|l| get_calibration_value(l))
        .sum();

    res.to_string()
}

fn get_calibration_value(line: &str) -> usize {
    let mut fst: Option<usize> = None;
    let mut snd: Option<usize> = None;

    for c in line.chars().into_iter() {
        if let Some(num) = c.to_digit(10) {
            fst = Some(num.try_into().unwrap());
            break;
        }
    }

    for c in line.chars().rev().into_iter() {
        if let Some(num) = c.to_digit(10) {
            snd = Some(num.try_into().unwrap());
            break;
        }
    }

   format!("{}{}", fst.unwrap(), snd.unwrap()).parse::<usize>().unwrap()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_get_calibration_value() {
        assert_eq!(get_calibration_value("1abc2"), 12);
        assert_eq!(get_calibration_value("pqr3stu8vwx"), 38);
        assert_eq!(get_calibration_value("a1b2c3d4e5f"), 15);
        assert_eq!(get_calibration_value("treb7uchet"), 77);
    }
}
