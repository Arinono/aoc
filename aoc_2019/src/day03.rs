use std::collections::HashSet;

#[derive(Debug, PartialEq, Eq)]
enum Direction {
    Up(u16),
    Right(u16),
    Down(u16),
    Left(u16),
}

#[derive(Debug, PartialEq, Eq, Clone, Copy, PartialOrd, Ord, Hash)]
struct Point(i32, i32, i32);

fn parse_wire(input: String) -> Vec<Direction> {
    input
        .split(",")
        .map(|s| s.split_at(1))
        .fold(vec![], |mut acc, (op, len)| {
            let direction = match op {
                "U" => Direction::Up(len.parse::<u16>().expect("to be unsigned")),
                "R" => Direction::Right(len.parse::<u16>().expect("to be unsigned")),
                "D" => Direction::Down(len.parse::<u16>().expect("to be unsigned")),
                "L" => Direction::Left(len.parse::<u16>().expect("to be unsigned")),
                _ => unreachable!(),
            };
            acc.push(direction);
            acc
        })
}

fn spread_line(from: &Point, dir: &Direction) -> (HashSet<Point>, Point) {
    let mut last = from.clone();
    match *dir {
        Direction::Up(by) => {
            let iby: i32 = by.into();
            let pts = (from.1 + 1..=from.1 + iby).fold(HashSet::new(), |mut acc, y| {
                let pt = Point(from.0, y, last.2 + 1);
                last = pt.clone();
                acc.insert(pt);
                acc
            });
            (pts, last)
        }
        Direction::Down(by) => {
            let iby: i32 = by.into();
            let pts = (from.1 - iby..from.1)
                .rev()
                .fold(HashSet::new(), |mut acc, y| {
                    let pt = Point(from.0, y, last.2 + 1);
                    last = pt.clone();
                    acc.insert(pt);
                    acc
                });
            (pts, last)
        }
        Direction::Right(by) => {
            let iby: i32 = by.into();
            let pts = (from.0 + 1..=from.0 + iby).fold(HashSet::new(), |mut acc, x| {
                let pt = Point(x, from.1, last.2 + 1);
                last = pt.clone();
                acc.insert(pt);
                acc
            });
            (pts, last)
        }
        Direction::Left(by) => {
            let iby: i32 = by.into();
            let pts = (from.0 - iby..from.0)
                .rev()
                .fold(HashSet::new(), |mut acc, x| {
                    let pt = Point(x, from.1, last.2 + 1);
                    last = pt.clone();
                    acc.insert(pt);
                    acc
                });
            (pts, last)
        }
    }
}

fn get_wire_points(line: &Vec<Direction>) -> HashSet<Point> {
    let mut prev = Point(0, 0, 0);
    line.iter().fold(HashSet::from([]), |mut acc, dir| {
        let (pts, new_prev) = spread_line(&prev, dir);
        prev = new_prev;
        for pt in pts {
            acc.insert(pt);
        }
        acc
    })
}

fn find_intersections<'a>(wires: &'a Vec<HashSet<Point>>) -> HashSet<&'a Point> {
    if wires.len() != 2 {
        todo!();
    }
    let (wire1, wire2) = wires.split_at(1);

    wire1
        .first()
        .expect("to have only one")
        .intersection(wire2.first().expect("to have only one"))
        .map(|i| {
            println!("{:?}", wire1.first().unwrap().clone().retain(|j| {
                println!("{:?}", j);
                j.0 == i.0 && j.1 == i.1
            }));
            return i;
        })
        // do smth with the instersection
        .collect::<HashSet<_>>()
}

fn calc_distance(pts: HashSet<&Point>) -> i32 {
    pts.iter()
        .map(|pt| pt.0.abs() + pt.1.abs())
        .min()
        .expect("to have a value")
}

#[cfg(test)]
mod tests {
    use crate::day03::*;

    #[test]
    fn parsing_wire() {
        let input1 = String::from("R8,U5,L5,D3");
        let input2 = String::from("U7,R6,D4,L4");

        let wire1 = parse_wire(input1);
        let wire2 = parse_wire(input2);

        assert_eq!(
            wire1,
            vec![
                Direction::Right(8u16),
                Direction::Up(5u16),
                Direction::Left(5u16),
                Direction::Down(3u16),
            ],
        );
        assert_eq!(
            wire2,
            vec![
                Direction::Up(7u16),
                Direction::Right(6u16),
                Direction::Down(4u16),
                Direction::Left(4u16),
            ],
        );
    }

    #[test]
    fn parse_wire_points() {
        let wire1 = parse_wire(String::from("R8,U5,L5,D3"));

        let points = get_wire_points(&wire1);

        assert_eq!(
            points,
            HashSet::from([
                // right by 8
                Point(1, 0, 1),
                Point(2, 0, 2),
                Point(3, 0, 3),
                Point(4, 0, 4),
                Point(5, 0, 5),
                Point(6, 0, 6),
                Point(7, 0, 7),
                Point(8, 0, 8),
                // up by 5
                Point(8, 1, 9),
                Point(8, 2, 10),
                Point(8, 3, 11),
                Point(8, 4, 12),
                Point(8, 5, 13),
                // left by 5
                Point(7, 5, 14),
                Point(6, 5, 15),
                Point(5, 5, 16),
                Point(4, 5, 17),
                Point(3, 5, 18),
                // down by 3
                Point(3, 4, 19),
                Point(3, 3, 20),
                Point(3, 2, 21),
            ])
        );
    }

    #[test]
    fn test_find_intersections() {
        let wire1 = get_wire_points(&parse_wire(String::from("R8,U5,L5,D3")));
        let wire2 = get_wire_points(&parse_wire(String::from("U7,R6,D4,L4")));
        let wires: Vec<HashSet<Point>> = vec![wire1, wire2];

        let intersections = find_intersections(&wires);

        assert_eq!(intersections, HashSet::from([&Point(3, 3, 40), &Point(6, 5, 30)]));
    }

    #[test]
    fn test_calc_distance() {
        let wires1 = vec![
            get_wire_points(&parse_wire(String::from("R8,U5,L5,D3"))),
            get_wire_points(&parse_wire(String::from("U7,R6,D4,L4"))),
        ];
        let wires2 = vec![
            get_wire_points(&parse_wire(String::from(
                "R75,D30,R83,U83,L12,D49,R71,U7,L72",
            ))),
            get_wire_points(&parse_wire(String::from("U62,R66,U55,R34,D71,R55,D58,R83"))),
        ];
        let wires3 = vec![
            get_wire_points(&parse_wire(String::from(
                "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51",
            ))),
            get_wire_points(&parse_wire(String::from(
                "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7",
            ))),
        ];

        let distance1 = calc_distance(find_intersections(&wires1));
        let distance2 = calc_distance(find_intersections(&wires2));
        let distance3 = calc_distance(find_intersections(&wires3));

        assert_eq!(distance1, 6);
        assert_eq!(distance2, 159);
        assert_eq!(distance3, 135);
    }

    #[test]
    fn test_calc_most_efficient() {
        let wires1 = vec![
            get_wire_points(&parse_wire(String::from("R8,U5,L5,D3"))),
            get_wire_points(&parse_wire(String::from("U7,R6,D4,L4"))),
        ];
        let wires2 = vec![
            get_wire_points(&parse_wire(String::from(
                "R75,D30,R83,U83,L12,D49,R71,U7,L72",
            ))),
            get_wire_points(&parse_wire(String::from("U62,R66,U55,R34,D71,R55,D58,R83"))),
        ];
        let wires3 = vec![
            get_wire_points(&parse_wire(String::from(
                "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51",
            ))),
            get_wire_points(&parse_wire(String::from(
                "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7",
            ))),
        ];

        let distance1 = calc_distance(find_intersections(&wires1));
        let distance2 = calc_distance(find_intersections(&wires2));
        let distance3 = calc_distance(find_intersections(&wires3));

        assert_eq!(distance1, 30);
        assert_eq!(distance2, 610);
        assert_eq!(distance3, 410);
    }
}

#[cfg(test)]
mod solutions {
    use std::fs;

    use super::*;

    fn parsing() -> Vec<HashSet<Point>> {
        let input = fs::read_to_string("../inputs/2019/03.txt").expect("Unable to read file");

        input
            .lines()
            .map(|l| get_wire_points(&parse_wire(String::from(l))))
            .collect()
    }

    #[test]
    fn day02_part1() {
        let wires = parsing();

        let distance = calc_distance(find_intersections(&wires));

        assert_eq!(distance, 2050);
    }
}
