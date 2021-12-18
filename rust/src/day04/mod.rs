mod board;
mod bingo;

pub fn solve() {
  let input = std::fs::read_to_string(".input/day04").unwrap();
  let mut bingo = bingo::Bingo::parse(&input).unwrap();

  let part1 = bingo.part1();
  let part2 = bingo.part2();

  println!("day04: {} {}", part1, part2);
}
