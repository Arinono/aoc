use rayon::iter::ParallelIterator;

use rayon::iter::IntoParallelRefIterator;

pub fn solve(input: &String) -> String {
    let (serials, symbols) = parse_input(input);
    find_adjacent(&serials, &symbols)
        .par_iter()
        // .inspect(|s| println!("{}", s))
        .sum::<u32>()
        .to_string()
}

#[derive(Debug)]
struct Serials(Vec<(u32, usize, usize, usize)>);
#[derive(Debug)]
struct Symbols(Vec<(char, usize, usize)>);

fn parse_input(input: &str) -> (Serials, Symbols) {
    let mut serials = Vec::new();
    let mut symbols = Vec::new();

    for (y, line) in input.lines().enumerate() {
        let mut serial = "".to_string();
        let mut started = false;
        let mut start = 0;

        for (x, c) in line.chars().enumerate() {
            if c.is_digit(10) {
                if !started {
                    started = true;
                    start = x;
                }
                serial.push(c);
                if x == line.len() - 1 {
                    serials.push((serial.parse::<u32>().unwrap(), y, start, x));
                    serial = "".to_string();
                    start = 0;
                    started = false;
                }
            } else {
                if started {
                    serials.push((serial.parse::<u32>().unwrap(), y, start, x - 1));
                    serial = "".to_string();
                    start = 0;
                    started = false;
                }
                if c != '.' {
                    symbols.push((c, y, x));
                }
            }
        }
    }

    (Serials(serials), Symbols(symbols))
}

fn find_adjacent(serials: &Serials, symbols: &Symbols) -> Vec<u32> {
    let mut adjacent = Vec::new();

    for (_, y, x) in &symbols.0 {
        for (serial, sy, sx, ex) in &serials.0 {
            let sx_range = *sx..=*ex;
            if (y - 1 == *sy && sx_range.contains(&(x - 1)))
                || (y - 1 == *sy && sx_range.contains(x))
                || (y - 1 == *sy && sx_range.contains(&(x + 1)))
                || (*y == *sy && sx_range.contains(&(x - 1)))
                || (*y == *sy && sx_range.contains(&(x + 1)))
                || (y + 1 == *sy && sx_range.contains(&(x - 1)))
                || (y + 1 == *sy && sx_range.contains(x))
                || (y + 1 == *sy && sx_range.contains(&(x + 1)))
            {
                adjacent.push(*serial);
            }
        }
    }

    adjacent
}

#[cfg(test)]
mod tests {
    use super::*;
    const INPUT: &str = "467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..";

    const INPUT2: &str = "...788.............................54.........501...........555.........270.................................521......893....................
..../..*963........................*..860......................*....53...../.....................52.................&....347........428*522.
............*......41..481+.......462....$..187......678.......420....-....................&115.+...........................+...............";

    #[test]
    fn test_parse_input() {
        let (serials, symbols) = parse_input(INPUT);
        assert_eq!(
            serials.0,
            vec![
                (467, 0, 0, 2),
                (114, 0, 5, 7),
                (35, 2, 2, 3),
                (633, 2, 6, 8),
                (617, 4, 0, 2),
                (58, 5, 7, 8),
                (592, 6, 2, 4),
                (755, 7, 6, 8),
                (664, 9, 1, 3),
                (598, 9, 5, 7),
            ]
        );
        assert_eq!(
            symbols.0,
            vec![
                ('*', 1, 3),
                ('#', 3, 6),
                ('*', 4, 3),
                ('+', 5, 5),
                ('$', 8, 3),
                ('*', 8, 5),
            ]
        );
    }

    #[test]
    fn test_find_adjacent() {
        let (serials, symbols) = parse_input(INPUT);

        let mut exp = vec![467, 35, 633, 617, 592, 755, 664, 598];
        let mut ajd = find_adjacent(&serials, &symbols);
        exp.sort();
        ajd.sort();

        assert_eq!(ajd, exp,);
    }

    #[test]
    fn test_solve() {
        assert_eq!(solve(&INPUT.to_string()), "4361".to_string());
        assert_eq!(solve(&INPUT2.to_string()), "7263".to_string());
    }
}
