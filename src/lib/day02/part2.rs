use rayon::iter::{IntoParallelRefIterator, ParallelBridge, ParallelIterator};

pub fn solve(input: &String) -> String {
    let games = parse_games(input);
    games
        .par_iter()
        .map(find_minimum)
        .map(calc_power)
        .sum::<u32>()
        .to_string()
}

#[derive(Debug, PartialEq, Eq, PartialOrd, Ord)]
struct Game {
    id: u32,
    stacks: Vec<CubeStack>,
}

#[derive(Debug, PartialEq, Eq, PartialOrd, Ord)]
struct CubeStack {
    red: u32,
    green: u32,
    blue: u32,
}

#[derive(Debug, PartialEq)]
enum Color {
    Red,
    Green,
    Blue,
}

impl From<&str> for Color {
    fn from(s: &str) -> Self {
        match s {
            "red" => Color::Red,
            "green" => Color::Green,
            "blue" => Color::Blue,
            _ => panic!("Invalid color: {}", s),
        }
    }
}

fn parse_color(color: &str) -> (Color, u32) {
    let (num_str, color_str) = color.split_once(" ").unwrap();
    let num = num_str.parse::<u32>().unwrap();
    let color = Color::from(color_str);

    (color, num)
}

fn parse_stack(stack: &str) -> CubeStack {
    let colors = stack
        .split(", ")
        .map(parse_color)
        .collect::<Vec<(Color, u32)>>();

    let mut stack = CubeStack {
        red: 0,
        green: 0,
        blue: 0,
    };

    for (color, num) in colors {
        match color {
            Color::Red => stack.red = num,
            Color::Green => stack.green = num,
            Color::Blue => stack.blue = num,
        }
    }

    stack
}

fn parse_line(line: &str) -> Game {
    let (lhs, rhs) = line.split_once(": ").unwrap();
    let id = lhs
        .chars()
        .skip(5)
        .take_while(|c| c.is_digit(10))
        .collect::<String>()
        .parse::<u32>()
        .unwrap();

    let stacks = rhs.split("; ").map(parse_stack).collect::<Vec<CubeStack>>();

    Game { id, stacks }
}

fn parse_games(input: &str) -> Vec<Game> {
    let mut games = input
        .lines()
        .par_bridge()
        .map(parse_line)
        .collect::<Vec<Game>>();

    // not sure if I need it for the exercise, but it's better for the tests
    games.sort_by(|a, b| a.id.cmp(&b.id));

    games
}

fn find_minimum(game: &Game) -> CubeStack {
    let mut minimum = CubeStack {
        red: 0,
        green: 0,
        blue: 0,
    };

    for stack in &game.stacks {
        if stack.red >= minimum.red {
            minimum.red = stack.red;
        }

        if stack.green >= minimum.green {
            minimum.green = stack.green;
        }

        if stack.blue >= minimum.blue {
            minimum.blue = stack.blue;
        }
    }

    minimum
}

fn calc_power(stack: CubeStack) -> u32 {
    stack.red * stack.green * stack.blue
}

#[cfg(test)]
mod tests {
    use super::*;

    fn seed() -> (&'static str, Vec<Game>) {
        let input = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green";

        let game = parse_games(input);

        (input, game)
    }

    #[test]
    fn test_parse_line() {
        assert_eq!(
            parse_line("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"),
            Game {
                id: 1,
                stacks: vec![
                    CubeStack {
                        red: 4,
                        green: 0,
                        blue: 3
                    },
                    CubeStack {
                        red: 1,
                        green: 2,
                        blue: 6
                    },
                    CubeStack {
                        red: 0,
                        green: 2,
                        blue: 0
                    },
                ],
            }
        );
    }

    #[test]
    fn test_parse_games() {
        let (input, _) = seed();
        assert_eq!(
            parse_games(input),
            vec![
                Game {
                    id: 1,
                    stacks: vec![
                        CubeStack {
                            red: 4,
                            green: 0,
                            blue: 3
                        },
                        CubeStack {
                            red: 1,
                            green: 2,
                            blue: 6
                        },
                        CubeStack {
                            red: 0,
                            green: 2,
                            blue: 0
                        },
                    ],
                },
                Game {
                    id: 2,
                    stacks: vec![
                        CubeStack {
                            red: 0,
                            green: 2,
                            blue: 1
                        },
                        CubeStack {
                            red: 1,
                            green: 3,
                            blue: 4
                        },
                        CubeStack {
                            red: 0,
                            green: 1,
                            blue: 1
                        },
                    ],
                },
                Game {
                    id: 3,
                    stacks: vec![
                        CubeStack {
                            red: 20,
                            green: 8,
                            blue: 6
                        },
                        CubeStack {
                            red: 4,
                            green: 13,
                            blue: 5
                        },
                        CubeStack {
                            red: 1,
                            green: 5,
                            blue: 0
                        },
                    ],
                },
                Game {
                    id: 4,
                    stacks: vec![
                        CubeStack {
                            red: 3,
                            green: 1,
                            blue: 6
                        },
                        CubeStack {
                            red: 6,
                            green: 3,
                            blue: 0
                        },
                        CubeStack {
                            red: 14,
                            green: 3,
                            blue: 15
                        },
                    ],
                },
                Game {
                    id: 5,
                    stacks: vec![
                        CubeStack {
                            red: 6,
                            green: 3,
                            blue: 1
                        },
                        CubeStack {
                            red: 1,
                            green: 2,
                            blue: 2
                        },
                    ],
                },
            ]
        );
    }

    #[test]
    fn test_find_minimum() {
        let (_, game) = seed();
        assert_eq!(
            find_minimum(&game[0]),
            CubeStack {
                red: 4,
                green: 2,
                blue: 6,
            }
        );

        assert_eq!(
            find_minimum(&parse_line("Game 43: 15 red, 5 blue, 5 green; 15 green, 15 red, 1 blue; 4 blue, 13 green, 13 red; 3 red, 16 green; 2 red, 3 green, 2 blue")),
            CubeStack {
                red: 15,
                green: 16,
                blue: 5,
            }
        );

        assert_eq!(
            find_minimum(&parse_line("Game 5: 3 blue, 3 red, 8 green; 5 blue, 1 red; 1 green, 19 blue, 3 red; 1 red, 5 green, 3 blue; 4 green, 20 blue, 4 red; 20 blue, 4 green")),
            CubeStack {
                red: 4,
                green: 8,
                blue: 20,
            }
        );
    }

    #[test]
    fn test_calc_power() {
        assert_eq!(
            calc_power(CubeStack {
                red: 4,
                green: 2,
                blue: 6,
            }),
            48
        );
    }

    #[test]
    fn test_solve() {
        let (input, _) = seed();
        assert_eq!(solve(&input.to_string()), "2286");
    }
}
