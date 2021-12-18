struct Model {
  timers: [u64; 9]
}

impl Model {
  fn init(input: &str) -> Option<Self> {
    let mut timers = [0; 9];
    for timer in input.trim().split(',') {
      timers[timer.parse::<usize>().ok()?] += 1;
    }
    Some(Self { timers })
  }

  fn simulate(&mut self, days: usize) -> u64 {
    for day in 0..days {
      self.timers[(day + 7) % 9] += self.timers[day % 9];
    }
    self.timers.rotate_left(days % 9);
    self.timers.iter().sum()
  }
}

pub fn solve() {
  let input = std::fs::read_to_string(".input/day06").unwrap();
  let mut model = Model::init(&input).unwrap();

  let part1 = model.simulate(80);
  let part2 = model.simulate(256 - 80);

  println!("day06: {} {}", part1, part2);
}
