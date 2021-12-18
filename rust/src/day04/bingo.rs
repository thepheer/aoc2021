use super::board::*;

pub struct Bingo {
  nums: Vec<u8>,
  boards: Vec<Board>
}

impl Bingo {
  pub fn parse(input: &str) -> Option<Self> {
    let mut parts = input.split("\n\n");
    let mut nums = parts.next()?.split(',').map(str::parse).collect::<Result<Vec<_>, _>>().ok()?;
    let boards = parts.map(Board::parse).collect::<Option<_>>()?;
    nums.reverse(); // gonna .pop() numbers from the end instead
    Some(Self { nums, boards })
  }

  pub fn part1(&mut self) -> u32 {
    while let Some(drawn) = self.nums.pop() {
      self.mark_in_all_boards(drawn);
      if let Some(winner) = self.boards.iter().find(|b| b.bingo()) {
        return winner.sum_all_unmarked() * drawn as u32;
      }
    }
    unreachable!()
  }

  pub fn part2(&mut self) -> u32 {
    while let Some(drawn) = self.nums.pop() {
      self.mark_in_all_boards(drawn);
      match self.boards.len() {
        1 => if self.boards[0].bingo() {
          return self.boards[0].sum_all_unmarked() * drawn as u32;
        },
        _ => self.boards.retain(|b| !b.bingo())
      }
    }
    unreachable!()
  }

  fn mark_in_all_boards(&mut self, num: u8) {
    for board in &mut self.boards {
      board.mark(num);
    }
  }
}

// hurr durr debug view
impl std::fmt::Display for Bingo {
  fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
    use std::fmt::Write;

    let next = self.nums.last();
    if let Some(next) = next {
      f.write_fmt(format_args!("next number: {}\n", next))?;
    }
    let next = next.map_or(0xff, |&n| n);

    for boards in self.boards.chunks(10) {
      f.write_char('\n')?;
      for row in 0..N {
        for board in boards {
          let winner = board.bingo();
          if winner {
            f.write_str("\x1b[1;40m")?;
          }
          f.write_char(' ')?;
          for col in 0..N {
            let num = board.at(col, row);
            let color = if num == next { 33 }
              else if board.is_marked_at(col, row) { 34 }
              else { 30 };
            f.write_fmt(format_args!("\x1b[{}m{:2}\x1b[39m ", color, num))?;
          }
          if winner {
            f.write_str("\x1b[22;49m")?;
          }
          f.write_char(' ')?;
        }
        f.write_char('\n')?;
      }
    }

    Ok(())
  }
}
