fn rolling_sum<const N: usize>(nums: &[i32]) -> Vec<i32> {
  nums.array_windows::<N>()
    .map(|w| w.iter().sum())
    .collect()
}

fn count_increasing(nums: &[i32]) -> usize {
  nums.array_windows()
    .filter(|[current, next]| next > current)
    .count()
}

pub fn solve() {
  let input = std::fs::read_to_string(".input/day01").unwrap();
  let depths = input.lines()
    .map(str::parse)
    .collect::<Result<Vec<_>, _>>()
    .unwrap();

  let part1 = count_increasing(&depths);
  let part2 = count_increasing(&rolling_sum::<3>(&depths));
  println!("day01: {} {}", part1, part2);
}
