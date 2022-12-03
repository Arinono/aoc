pub fn run_intcode(input: Vec<u32>, noun: u32, verb: u32) -> Vec<u32> {
    let mut intcodes = input.clone();
    let mut idx = 0;

    intcodes[1] = noun;
    intcodes[2] = verb;

    loop {
        let pos = intcodes[idx + 3] as usize;
        match intcodes[idx] {
            1 => {
                intcodes[pos] =
                    intcodes[intcodes[idx + 1] as usize] + intcodes[intcodes[idx + 2] as usize]
            }
            2 => {
                intcodes[pos] =
                    intcodes[intcodes[idx + 1] as usize] * intcodes[intcodes[idx + 2] as usize]
            }
            99 => {
                return intcodes;
            }
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
        let result = run_intcode(input, 9u32, 10u32);

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
        let input = fs::read_to_string("./inputs/02.txt").expect("Unable to read file");

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
    fn day02_part1() {
        let parsed = parsing();
        let result = run_intcode(parsed, 12u32, 2u32);

        assert_eq!(*result.first().expect("to be present"), 3306701);
    }

    #[test]
    fn day02_part2() {
        let parsed = parsing();

        for noun in (0..=99).collect::<Vec<u32>>() {
            for verb in (0..=99).collect::<Vec<u32>>() {
                if run_intcode(parsed.clone(), noun, verb)[0] == 19690720 {
                    assert_eq!(noun * 100 + verb, 7621);
                    return;
                }
            }
        }
        unreachable!()
    }
}
