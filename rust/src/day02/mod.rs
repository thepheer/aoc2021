pub enum Move {
  Down(i32),
  Forward(i32)
}

impl Move {
  pub fn parse(input: &str) -> Option<Self> {
    let (command, value) = input.split_once(' ')?;
    let n = value.parse::<i32>().ok()?;
    match command {
      "up" => Some(Self::Down(-n)),
      "down" => Some(Self::Down(n)),
      "forward" => Some(Self::Forward(n)),
      _ => None
    }
  }
}

#[derive(Default)]
struct Submarine {
  h_pos: i32,
  depth: i32,
  aim: i32
}

impl Submarine {
  fn part1(mut self, moves: &[Move]) -> i32 {
    for mv in moves {
      match mv {
        Move::Down(n) => self.depth += n,
        Move::Forward(n) => self.h_pos += n,
      }
    }
    self.h_pos * self.depth
  }

  fn part2(mut self, moves: &[Move]) -> i32 {
    for mv in moves {
      match mv {
        Move::Down(n) => self.aim += n,
        Move::Forward(n) => {
          self.h_pos += n;
          self.depth += n * self.aim;
        }
      }
    }
    self.h_pos * self.depth
  }
}

pub fn solve() {
  let input = std::fs::read_to_string(".input/day02").unwrap();
  let moves = input.lines()
    .map(Move::parse)
    .collect::<Option<Vec<_>>>()
    .unwrap();

  let part1 = Submarine::default().part1(&moves);
  let part2 = Submarine::default().part2(&moves);
  println!("day02: {} {}", part1, part2);
}
