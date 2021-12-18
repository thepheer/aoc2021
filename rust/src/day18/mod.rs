use SnailfishNumber::*;

#[derive(Clone)]
enum SnailfishNumber {
  Single(u8),
  Pair(Box<(Self, Self)>)
}

impl SnailfishNumber {
  fn parse(input: &mut impl Iterator<Item = char>) -> Option<Self> {
    match input.next()? {
      '[' => {
        let a = Self::parse(input)?; input.next()?;
        let b = Self::parse(input)?; input.next()?;
        Some(Pair((a, b).into()))
      },
      n => Some(Single(n as u8 - b'0'))
    }
  }

  fn split(&self) -> Option<Self> {
    match self.to_owned() {
      Single(n) if n > 9 => Some(Pair((Single(n / 2), Single((n + 1) / 2)).into())),
      Pair(box (a, b)) if let Some(a) = a.split() => Some(Pair((a, b).into())),
      Pair(box (a, b)) if let Some(b) = b.split() => Some(Pair((a, b).into())),
      _ => None
    }
  }

  fn explode(&self, d: usize, f: &dyn Fn(u8, u8, SnailfishNumber) -> SnailfishNumber) -> Option<Self> {
    match self.to_owned() {
      Pair(box (Single(a), Single(b))) if d > 3 => Some(f(a, b, Single(0))),
      Pair(box (a, b)) if let Some(a) = a
        .explode(d + 1, &|x, y, a| f(x, 0, Pair((a, b.add_left(y)).into()))) => Some(a),
      Pair(box (a, b)) if let Some(b) = b
        .explode(d + 1, &|x, y, b| f(0, y, Pair((a.add_right(x), b).into()))) => Some(b),
      _ => None
    }
  }

  fn add_left(&self, n: u8) -> Self {
    match self.to_owned() {
      Pair(box (a, b)) => Pair((a.add_left(n), b).into()),
      Single(m) => Single(n + m)
    }
  }

  fn add_right(&self, n: u8) -> Self {
    match self.to_owned() {
      Pair(box (a, b)) => Pair((a, b.add_right(n)).into()),
      Single(m) => Single(n + m)
    }
  }

  fn reduce_step(&self) -> Option<Self> {
    self.explode(0, &|_, _, n| n).or_else(|| self.split())
  }

  fn reduce(self) -> Self {
    std::iter::successors(Some(self), Self::reduce_step).last().unwrap()
  }

  fn add(&self, rhs: &Self) -> Self {
    Pair((self.to_owned(), rhs.to_owned()).into()).reduce()
  }

  fn magnitude(&self) -> u32 {
    match self.to_owned() {
      Pair(box (a, b)) => 3 * a.magnitude() + 2 * b.magnitude(),
      Single(n) => n as u32
    }
  }
}

pub fn solve() {
  let input = std::fs::read_to_string(".input/day18").unwrap();

  let numbers = input.lines()
    .map(|line| SnailfishNumber::parse(&mut line.chars()))
    .collect::<Option<Vec<_>>>()
    .unwrap();

  let part1 = numbers.iter()
    .cloned()
    .reduce(|a, b| a.add(&b))
    .unwrap()
    .magnitude();

  let part2 = combinations!(numbers a b)
    .flat_map(|(a, b)| [a.add(b), b.add(a)])
    .map(|n| n.magnitude())
    .max()
    .unwrap();

  println!("day18: {} {}", part1, part2);
}

//

impl std::fmt::Debug for SnailfishNumber {
  fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
    std::fmt::Display::fmt(&self, f)
  }
}

impl std::fmt::Display for SnailfishNumber {
  fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
    match self {
      Pair(box (a, b)) => f.write_fmt(format_args!("[{},{}]", a, b)),
      Single(n) => n.fmt(f)
    }
  }
}
