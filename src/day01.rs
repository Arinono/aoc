#![allow(dead_code)]

#[derive(Clone, Ord, PartialOrd, Eq, PartialEq, Debug)]
pub struct Inventory {
    pub items: Vec<usize>,
    pub sum: usize,
}

pub fn get_inventories(input: &str) -> Vec<Inventory> {
    input
        .split("\n\n")
        .map(|block| {
            block
                .split('\n')
                .filter(|l| !l.is_empty())
                .map(|item| item.parse::<usize>().expect("A valid number"))
                .collect::<Vec<usize>>()
        })
        .into_iter()
        .map(|b| Inventory {
            items: b.clone(),
            sum: b.into_iter().sum(),
        })
        .collect::<Vec<Inventory>>()
}

pub fn get_biggest_invs(invs: Vec<Inventory>, len: usize) -> Vec<Inventory> {
    let mut sorted_invs = invs;
    sorted_invs.sort_by_key(|i| i.sum);
    sorted_invs.reverse();

    let (biggest, _ ) = sorted_invs.split_at(len);

    biggest.to_vec()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn getting_inventories() {
        let input: &str = r"1000
2000
3000

4000

5000
6000

7000
8000
9000

10000";

        let inventories = get_inventories(input);

        assert_eq!(inventories.len(), 5);
        assert_eq!(inventories[0].items.len(), 3);
        assert_eq!(inventories[0].sum, 6000);
    }

    #[test]
    fn find_biggest_carrier() {
        let input: &str = r"1000
2000
3000

4000

5000
6000

7000
8000
9000

10000";
        let inventories = get_inventories(input);

        let biggest_one = get_biggest_invs(inventories.clone(), 1);
        let biggest_three = get_biggest_invs(inventories, 3);

        assert_eq!(biggest_one[0].sum, 24000);
        assert_eq!(
            biggest_three.iter().map(|i| i.sum).collect::<Vec<usize>>(),
            vec![24000, 11000, 10000],
        );
    }
}

#[cfg(test)]
mod solutions {
    use super::*;
    use std::fs;

    fn read_file() -> String {
        fs::read_to_string("./inputs/01.txt").expect("a file")
    }

    #[test]
    fn part1() {
        let input = read_file();
        let invs = get_inventories(&input);
        let biggest_invs = get_biggest_invs(invs, 1);

        assert_eq!(biggest_invs.first().expect("an inventory").sum, 71124);
    }

    #[test]
    fn part2() {
        let input = read_file();
        let invs = get_inventories(&input);
        let biggest_invs = get_biggest_invs(invs, 3);

        let sums: Vec<usize> = biggest_invs
            .iter()
            .map(|i| i.sum)
            .collect();

        assert_eq!(sums.into_iter().sum::<usize>(), 204639);
    }
}
