pub fn fuel_requirement(mass: &u32) -> u32 {
    ((*mass as f32 / 3f32).floor() - 2.0) as u32
}

pub fn total_fuel_requirement(mass: &u32) -> u32 {
    let mut fuel = fuel_requirement(mass);
    let mut additional_fuel = fuel_requirement(&fuel);

    while additional_fuel > 0 {
        fuel += additional_fuel;
        additional_fuel = fuel_requirement(&additional_fuel);
    }

    fuel + additional_fuel
}

#[cfg(test)]
mod tests {
    use super::{fuel_requirement, total_fuel_requirement};

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
    fn module_and_fuel_requirement() {
        // arrange
        let module_1: u32 = 14;
        let module_2: u32 = 1969;
        let module_3: u32 = 100756;

        // act
        let total_fuel_1 = total_fuel_requirement(&module_1);
        let total_fuel_2 = total_fuel_requirement(&module_2);
        let total_fuel_3 = total_fuel_requirement(&module_3);

        // assert
        assert_eq!(total_fuel_1, 2);
        assert_eq!(total_fuel_2, 966);
        assert_eq!(total_fuel_3, 50346);
    }
}

#[cfg(test)]
mod solutions {
    use super::{fuel_requirement, total_fuel_requirement};
    use std::fs;

    fn parsing() -> Vec<u32> {
        let input = fs::read_to_string("../inputs/2019/01.txt").expect("Unable to read file");

        input
            .lines()
            .map(|l| l.parse::<u32>().expect("failed to parse number"))
            .collect::<Vec<u32>>()
    }

    #[test]
    fn day01_part1() {
        let result: u32 = parsing().iter().map(fuel_requirement).sum();

        assert_eq!(result, 3335787);
    }

    #[test]
    fn day01_part2() {
        let result: u32 = parsing().iter().map(total_fuel_requirement).sum();

        assert_eq!(result, 5000812);
    }
}
