pub const N: usize = 5;

const ROW_MASK: u32 = 0b_00000_00000_00000_00000_11111;
const COL_MASK: u32 = 0b_00001_00001_00001_00001_00001;

pub struct Board {
  matrix: [u8; N * N],
  marked: u32
}

impl Board {
  pub fn parse(input: &str) -> Option<Self> {
    let mut matrix = [0; N * N];
    for (num, cell) in input.split_ascii_whitespace().zip(&mut matrix) {
      *cell = num.parse().ok()?;
    }
    Some(Self { matrix, marked: 0 })
  }

  pub fn at(&self, col: usize, row: usize) -> u8 {
    self.matrix[N * row + col]
  }

  pub fn is_marked_at(&self, col: usize, row: usize) -> bool {
    self.marked & 1 << (N * row + col) != 0
  }

  pub fn mark(&mut self, num: u8) {
    if let Some(shift) = self.matrix.iter().position(|&n| n == num) {
      self.marked |= 1 << shift;
    }
  }

  pub fn sum_all_unmarked(&self) -> u32 {
    self.matrix.iter().enumerate()
      .filter(|&(shift, _)| self.marked & 1 << shift == 0)
      .fold(0, |acc, (_, &n)| acc + n as u32)
  }

  pub fn bingo(&self) -> bool {
    for i in 0..N {
      let row = ROW_MASK << i * N;
      let col = COL_MASK << i;
      if self.marked & row == row || self.marked & col == col {
        return true;
      }
    }
    false
  }
}
