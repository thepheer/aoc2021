#![allow(clippy::self_named_constructors)]

enum Score {
  Invalid(u64),
  Incomplete(u64)
}

impl Score {
  fn score(input: &str) -> Self {
    let mut stack = Vec::new();

    for c in input.chars() {
      match c {
        '(' => stack.push(')'),
        '[' => stack.push(']'),
        '{' => stack.push('}'),
        '<' => stack.push('>'),
        ')' | ']' | '}' | '>' => {
          if stack.pop() != Some(c) {
            return Self::Invalid(Self::points_invalid(c));
          }
        },
        _ => panic!()
      }
    }

    let score = stack.into_iter().rev()
      .map(Self::points_incomplete)
      .fold(0, |score, points| 5*score + points);

    Self::Incomplete(score)
  }

  fn points_invalid(c: char) -> u64 {
    match c {
      ')' => 3,
      ']' => 57,
      '}' => 1197,
      '>' => 25137,
      _ => panic!()
    }
  }

  fn points_incomplete(c: char) -> u64 {
    match c {
      ')' => 1,
      ']' => 2,
      '}' => 3,
      '>' => 4,
      _ => panic!()
    }
  }
}

fn middle<T: Ord>(mut items: Vec<T>) -> T {
  items.sort_unstable();
  items.swap_remove(items.len() / 2)
}

pub fn solve() {
  let input = std::fs::read_to_string(".input/day10").unwrap();

  let mut invalid = 0;
  let mut incomplete = Vec::new();

  for line in input.lines() {
    match Score::score(line) {
      Score::Invalid(n) => invalid += n,
      Score::Incomplete(n) => incomplete.push(n)
    }
  }

  let part1 = invalid;
  let part2 = middle(incomplete);

  println!("day10: {} {}", part1, part2);
}
