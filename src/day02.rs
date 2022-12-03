#![allow(dead_code)]

const WIN: usize = 6;
const DRAW: usize = 3;
const LOSE: usize = 0;

const ROCK: usize = 1;
const PAPER: usize = 2;
const SCISSORS: usize = 3;

pub enum Sign {
    Rock(usize),
    Paper(usize),
    Scissors(usize),
}

pub enum EndWith {
    Win(usize),
    Draw(usize),
    Lose(usize),
}

pub fn regular_round(rnd: &str) -> (Sign, Sign) {
    if let Some((l, r)) = rnd.split_once(' ') {
       let left_sign = match l {
           "A" => Sign::Rock(ROCK),
           "B" => Sign::Paper(PAPER),
           "C" => Sign::Scissors(SCISSORS),
           _ => panic!("invalid left hand"),
       };

       let right_sign = match r {
           "X" => Sign::Rock(ROCK),
           "Y" => Sign::Paper(PAPER),
           "Z" => Sign::Scissors(SCISSORS),
           _ => panic!("invalid right hand"),
       };

       return (left_sign, right_sign);
    }
    
    panic!("hand malformed");
}
 
pub fn predicated_round(rnd: &str) -> (Sign, EndWith) {
    if let Some((l, r)) = rnd.split_once(' ') {
       let left_sign = match l {
           "A" => Sign::Rock(ROCK),
           "B" => Sign::Paper(PAPER),
           "C" => Sign::Scissors(SCISSORS),
           _ => panic!("invalid left hand"),
       };

       let right_sign = match r {
           "X" => EndWith::Lose(LOSE),
           "Y" => EndWith::Draw(DRAW),
           "Z" => EndWith::Win(WIN),
           _ => panic!("invalid right hand"),
       };

       return (left_sign, right_sign);
    }
    
    panic!("hand malformed");
}

pub fn score_round(rnd: &str) -> usize {
    let (l, r) = regular_round(rnd);
    
    match l {
        Sign::Rock(_) => match r {
            Sign::Rock(sc) => sc + DRAW,
            Sign::Paper(sc) => sc + WIN,
            Sign::Scissors(sc) => sc + LOSE,
        },
        Sign::Paper(_) =>  match r {
            Sign::Rock(sc) => sc + LOSE,
            Sign::Paper(sc) => sc + DRAW,
            Sign::Scissors(sc) => sc + WIN,
        },
        Sign::Scissors(_) => match r {
            Sign::Rock(sc) => sc + WIN,
            Sign::Paper(sc) => sc + LOSE,
            Sign::Scissors(sc) => sc + DRAW,
        },
    }
}

pub fn predict_round(rnd: &str) -> usize {
    let (l, r) = predicated_round(rnd);
    
    match l {
        Sign::Rock(_) => match r {
            EndWith::Win(sc) => sc + PAPER,
            EndWith::Draw(sc) => sc + ROCK,
            EndWith::Lose(sc) => sc + SCISSORS,
        },
        Sign::Paper(_) =>  match r {
            EndWith::Win(sc) => sc + SCISSORS,
            EndWith::Draw(sc) => sc + PAPER,
            EndWith::Lose(sc) => sc + ROCK,
        },
        Sign::Scissors(_) => match r {
            EndWith::Win(sc) => sc + ROCK,
            EndWith::Draw(sc) => sc + SCISSORS,
            EndWith::Lose(sc) => sc + PAPER,
        },
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn score_rounds() {
        let rnd1 = "A Y";
        let rnd2 = "B X";
        let rnd3 = "C Z";

        let score1 = score_round(rnd1);
        let score2 = score_round(rnd2);
        let score3 = score_round(rnd3);

        assert_eq!(score1, 8);
        assert_eq!(score2, 1);
        assert_eq!(score3, 6);
    }

    #[test]
    fn ends_round_with() {
        let rnd1 = "A Y";
        let rnd2 = "B X";
        let rnd3 = "C Z";

        let score1 = predict_round(rnd1);
        let score2 = predict_round(rnd2);
        let score3 = predict_round(rnd3);

        assert_eq!(score1, 4);
        assert_eq!(score2, 1);
        assert_eq!(score3, 7);
    }
}

#[cfg(test)]
mod solutions {
    use std::fs;
    use super::*;

    #[test]
    fn part1() {
        let input = fs::read_to_string("./inputs/02.txt").expect("a file");

        let total_score: usize = input
            .split('\n')
            .filter(|l| !l.is_empty())
            .map(score_round)
            .sum();
            
        assert_eq!(total_score, 11873);
    }

    #[test]
    fn part2() {
        let input = fs::read_to_string("./inputs/02.txt").expect("a file");

        let total_score: usize = input
            .split('\n')
            .filter(|l| !l.is_empty())
            .map(predict_round)
            .sum();
            
        assert_eq!(total_score, 12014);
    }
}
