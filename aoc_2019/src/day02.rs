pub fn run_intcode(input: Vec<u32>) -> Vec<u32> {
    let mut intcodes = input.clone();
    let mut idx = 0;

    loop {
        let pos = intcodes[idx + 3] as usize;
        match intcodes[idx] {
            1 => intcodes[pos] = intcodes[intcodes[idx + 1] as usize] + intcodes[intcodes[idx + 2] as usize],
            2 => intcodes[pos] = intcodes[intcodes[idx + 1] as usize] * intcodes[intcodes[idx + 2] as usize],
            99 => {
                return intcodes;
            },
            _ => unreachable!(),
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
        let input = "1,9,10,3,2,3,11,0,99,30,40,50"
            .split(",")
            .map(|v| v.parse::<u32>().expect("to be u32"))
            .collect::<Vec<u32>>();

        // act
        let result = run_intcode(input);

        // assert
        assert_eq!(
            result
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

    fn parsing() -> Vec<u32> {
        let input = fs::read_to_string("../inputs/2019/02.txt").expect("Unable to read file");

        input
            .lines()
            .map(str::to_string)
            .collect::<Vec<String>>()
            .first()
            .expect("to be present")
            .split(",")
            .map(|v| v.parse::<u32>().expect("to be u32"))
            .collect::<Vec<u32>>()
    }

    #[test]
    fn day01_part1() {
        let mut parsed = parsing();
        parsed[1] = 12u32;
        parsed[2] = 2u32;
        let result = run_intcode(parsed);

        assert_eq!(*result.first().expect("to be present"), 3306701);
    }
}
