struct Point { x: i16, y: i16 }

impl Point {
  fn parse(input: &str) -> Option<Self> {
    let (x, y) = input.split_once(',')?;
    Some(Self { x: x.parse().ok()?, y: y.parse().ok()? })
  }
}

struct Vent(Point, Point);

impl Vent {
  fn parse(input: &str) -> Option<Self> {
    let (a, b) = input.split_once(" -> ")?;
    Some(Self(Point::parse(a)?, Point::parse(b)?))
  }
}

struct OceanFloor {
  size: usize,
  grid: Vec<u8>,
  overlaps: u32
}

impl OceanFloor {
  fn new(size: usize) -> Self {
    let grid = vec![0; size * size];
    Self { size, grid, overlaps: 0 }
  }

  fn count_overlaps(&mut self, vents: &[Vent], diagonals: bool) -> u32 {
    for Vent(a, b) in vents {
      let (dx, dy) = (b.x - a.x, b.y - a.y);
      let (sx, sy) = (dx.signum(), dy.signum());

      let is_diagonal = dx != 0 && dy != 0;
      if diagonals ^ is_diagonal {
        continue;
      }

      for i in 0..=std::cmp::max(dx.abs(), dy.abs()) {
        let x = (a.x + sx * i) as usize;
        let y = (a.y + sy * i) as usize;

        match &mut self.grid[self.size * y + x] {
          cell @ 0 => { *cell += 1; }
          cell @ 1 => { *cell += 1; self.overlaps += 1; }
          _ => {}
        }
      }
    }

    self.overlaps
  }
}

pub fn solve() {
  let input = std::fs::read_to_string(".input/day05").unwrap();
  let vents = input.lines()
    .map(Vent::parse)
    .collect::<Option<Vec<_>>>()
    .unwrap();

  let mut of = OceanFloor::new(1000);
  let part1 = of.count_overlaps(&vents, false);
  let part2 = of.count_overlaps(&vents, true);

  println!("day05: {} {}", part1, part2);
}
