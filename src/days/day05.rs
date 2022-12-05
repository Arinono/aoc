#![allow(dead_code)]

type Stack = Vec<char>;

#[derive(Debug, Eq, PartialEq)]
pub struct Stacks(Vec<Stack>);

#[derive(Debug, Eq, PartialEq)]
pub struct Move {
    ct: usize,
    fr: usize,
    to: usize,
}

impl Stacks {
    fn perform_moves(&self, moves: Vec<Move>) -> Stacks {
        let mut m_stacks_cpy = self.0.clone();

        for m in moves.iter() {
            for _ in 0..m.ct {
                if let Some(crat) = m_stacks_cpy[m.fr - 1].pop() {
                    m_stacks_cpy[m.to - 1].push(crat);
                }
            }
        }

        Stacks(m_stacks_cpy)
    }

    fn perform_moves_in_order(&self, moves: Vec<Move>) -> Stacks {
        let mut m_stacks_cpy = self.0.clone();

        for m in moves.iter() {
            let mut crates: Vec<char>= vec![];
            for _ in 0..m.ct {
                if let Some(crat) = m_stacks_cpy[m.fr - 1].pop() {
                    crates.push(crat);
                }
            }
            for c in crates.into_iter().rev() {
                m_stacks_cpy[m.to - 1].push(c);
            }
        }

        Stacks(m_stacks_cpy)
    }

    fn get_top_crates(&self) -> String {
        let mut str: String = String::new();

        for mut s in self.0.clone().into_iter() {
            if let Some(ch) = s.pop() {
                str.push(ch);
            }
        }

        str
    }
}

pub fn parse_stacks(str: &str) -> Stacks {
    let stack_nb: usize = str
        .lines()
        .last()
        .expect("a line")
        .split_whitespace()
        .flat_map(str::parse::<usize>)
        .last()
        .expect("a number");

    let mut stacks: Vec<Stack> = Vec::with_capacity(stack_nb);
    for _ in 0..stack_nb {
        stacks.push(Vec::new());
    }

    for l in str.lines().rev().skip(1) {
        let mut i = 1;
        for s in stacks.iter_mut().take(stack_nb) {
            if let Some(c) = l.chars().nth(i) {
                if c != ' ' {
                    s.push(c);
                }
            }
            i += 4;
        }
    }

    Stacks(stacks)
}

pub fn parse_moves(str: &str) -> Vec<Move> {
    str.lines()
        .map(|l| {
            l.split_whitespace()
                .flat_map(str::parse::<usize>)
                .collect::<Vec<usize>>()
        })
        .map(|v: Vec<usize>| Move {
            ct: v[0],
            fr: v[1],
            to: v[2],
        })
        .collect::<Vec<Move>>()
}

pub fn parse_all(str: &str) -> (Stacks, Vec<Move>) {
    let (head, tail) = str.split_once("\n\n").expect("blocks");

    (parse_stacks(head), parse_moves(tail))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_stack_parsing() {
        let input = r"    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3";

        let stacks = parse_stacks(input);

        assert_eq!(
            stacks,
            Stacks(vec![vec!['Z', 'N'], vec!['M', 'C', 'D'], vec!['P'],]),
        );
    }

    #[test]
    fn test_parse_moves() {
        let input = r"move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2";

        let moves = parse_moves(input);

        assert_eq!(
            moves,
            vec![
                Move {
                    ct: 1,
                    fr: 2,
                    to: 1,
                },
                Move {
                    ct: 3,
                    fr: 1,
                    to: 3,
                },
                Move {
                    ct: 2,
                    fr: 2,
                    to: 1,
                },
                Move {
                    ct: 1,
                    fr: 1,
                    to: 2,
                },
            ],
        );
    }

    #[test]
    fn test_parse_all() {
        let input = r"    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2";

        let (stacks, moves) = parse_all(input);

        assert_eq!(
            stacks,
            Stacks(vec![vec!['Z', 'N'], vec!['M', 'C', 'D'], vec!['P'],]),
        );

        assert_eq!(
            moves,
            vec![
                Move {
                    ct: 1,
                    fr: 2,
                    to: 1,
                },
                Move {
                    ct: 3,
                    fr: 1,
                    to: 3,
                },
                Move {
                    ct: 2,
                    fr: 2,
                    to: 1,
                },
                Move {
                    ct: 1,
                    fr: 1,
                    to: 2,
                },
            ],
        );
    }

    #[test]
    fn test_perform_moves() {
        let input = r"    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2";
        let (stacks, moves) = parse_all(input);

        let stacks = stacks.perform_moves(moves);

        assert_eq!(
            stacks,
            Stacks(vec![
                   vec!['C'],
                   vec!['M'],
                   vec!['P', 'D', 'N', 'Z'],
            ]),
        );
    }

    #[test]
    fn test_perform_moves_in_order() {
        let input = r"    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2";
        let (stacks, moves) = parse_all(input);

        let stacks = stacks.perform_moves_in_order(moves);

        assert_eq!(
            stacks,
            Stacks(vec![
                   vec!['M'],
                   vec!['C'],
                   vec!['P', 'Z', 'N', 'D'],
            ]),
        );
    }

    #[test]
    fn test_get_top_crates() {
        let input = r"    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2";
        let (pstacks, moves) = parse_all(input.as_ref());
        let stacks = pstacks.perform_moves(moves);

        let crates = stacks.get_top_crates();

        assert_eq!(crates, "CMZ");
    }
}

#[cfg(test)]
mod solutions {
    use super::*;
    use std::fs;

    #[test]
    fn part1() {
        let input = fs::read_to_string("./inputs/05.txt").expect("a file");

        let (pstacks, moves) = parse_all(input.as_ref());

        let stacks = pstacks.perform_moves(moves);
        let crates = stacks.get_top_crates();

        assert_eq!(crates, "LBLVVTVLP");
    }

    #[test]
    fn part2() {
        let input = fs::read_to_string("./inputs/05.txt").expect("a file");

        let (pstacks, moves) = parse_all(input.as_ref());

        let stacks = pstacks.perform_moves_in_order(moves);
        let crates = stacks.get_top_crates();

        assert_eq!(crates, "TPFFBDRJD");
    }
}
