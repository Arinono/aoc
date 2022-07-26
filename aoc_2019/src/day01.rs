mod day01 {
    pub fn fuel_requirement(mass: &u32) -> u32 {
        ((*mass as f32 / 3f32).floor() - 2.0) as u32
    }
}

#[cfg(test)]
mod tests {
    use std::fs;

    use super::day01::fuel_requirement;

    #[test]
    fn module_fuel_requirement() {
        // arrange
        let module_1: u32 = 12;
        let module_2: u32 = 14;
        let module_3: u32 = 1969;
        let module_4: u32 = 100756;

        // act
        let fuel_1 = fuel_requirement(&module_1);
        let fuel_2 = fuel_requirement(&module_2);
        let fuel_3 = fuel_requirement(&module_3);
        let fuel_4 = fuel_requirement(&module_4);

        // assert
        assert_eq!(fuel_1, 2);
        assert_eq!(fuel_2, 2);
        assert_eq!(fuel_3, 654);
        assert_eq!(fuel_4, 33583);
    }

    #[test]
    fn day01_part1() {
        let input = fs::read_to_string("../inputs/2019/01.txt").expect("Unable to read file");
        
        let result: u32 = input
            .lines()
            .map(|l| l.parse::<u32>().expect("failed to parse number"))
            .collect::<Vec<u32>>()
            .iter()
            .map(fuel_requirement)
            .collect::<Vec<u32>>()
            .iter()
            .sum();

        assert_eq!(result, 3335787);
    }
}
