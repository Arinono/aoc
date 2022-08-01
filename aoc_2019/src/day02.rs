#[derive(Debug)]
pub enum IntcodeError {
    FormatError
}

pub fn run_intcode(input: &str) -> Result<Vec<u32>, IntcodeError> {
    let mut intcodes = input
        .split(",")
        .map(|s| s.parse::<u32>().expect("to be an uint"))
        .collect::<Vec<u32>>();
    let mut idx = 0;

    loop {
        let pos = intcodes[idx + 3] as usize;
        match intcodes[idx] {
            1 => intcodes[pos] = intcodes[intcodes[idx + 1] as usize] + intcodes[intcodes[idx + 2] as usize],
            2 => intcodes[pos] = intcodes[intcodes[idx + 1] as usize] * intcodes[intcodes[idx + 2] as usize],
            99 => {
                return Ok(intcodes);
            },
            _ => {
                return Err(IntcodeError::FormatError);
            },
        };

        idx += 4;
    }
}

#[cfg(test)]
mod tests {
    use crate::day02::run_intcode;

    #[test]
    fn running_intcode() {
        // arrange
        let input = "1,9,10,3,2,3,11,0,99,30,40,50";

        // act
        let result = run_intcode(input);

        // assert
        assert_eq!(
            result
                .expect("to be ok")
                .into_iter()
                .map(|n| n.to_string())
                .collect::<Vec<String>>()
                .join(","),
            "3500,9,10,70,2,3,11,0,99,30,40,50"
        );
    }
}

#[cfg(test)]
mod solutions {
    use crate::day02::run_intcode;
    use std::fs;

    fn parsing() -> Vec<String> {
        let input = fs::read_to_string("../inputs/2019/02.txt").expect("Unable to read file");

        input
            .lines()
            .map(|l| l.to_string())
            .collect::<Vec<String>>()
    }

    #[test]
    fn day01_part1() {
        // this shit's dirty
        let mut parsed = parsing().first().expect("to be present").split(",").map(|s| s.to_string()).collect::<Vec<String>>();
        parsed[1] = "12".to_string();
        parsed[2] = "2".to_string();
        let result = run_intcode(parsed.join(",").as_str());

        assert_eq!(*result.expect("to be ok").first().expect("to be present"), 3306701);
    }
}
