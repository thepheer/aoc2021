const BITS: usize = 12;
const MASK: u32 = (1 << BITS) - 1;

fn bit_at(bits: u32, index: usize) -> bool {
  bits >> (BITS - index - 1) & 1 == 1
}

fn most_common_bit(nums: &[u32], bit_index: usize) -> bool {
  let count = nums.iter()
    .filter(|&&bits| bit_at(bits, bit_index))
    .count();

  2 * count >= nums.len()
}

fn gamma_epsilon(nums: &[u32]) -> (u32, u32) {
  let gamma = (0..BITS)
    .map(|bit_index| most_common_bit(nums, bit_index))
    .fold(0, |bits, bit| bits << 1 | bit as u32);

  (gamma, gamma ^ MASK)
}

fn find_by_criterion(nums: &[u32], by_most_common: bool) -> u32 {
  let mut nums = nums.to_owned();

  for bit_index in 0..BITS {
    let most_common = most_common_bit(&nums, bit_index);
    let bit = most_common ^ by_most_common;
    nums.retain(|&bits| bit_at(bits, bit_index) == bit);

    if nums.len() == 1 {
      return nums[0];
    }
  }

  unreachable!()
}

pub fn solve() {
  let input = std::fs::read_to_string(".input/day03").unwrap();
  let nums = input.lines()
    .map(|bits| u32::from_str_radix(bits, 2))
    .collect::<Result<Vec<_>, _>>()
    .unwrap();

  let (gamma, epsilon) = gamma_epsilon(&nums);
  let oxygen = find_by_criterion(&nums, true);
  let co2 = find_by_criterion(&nums, false);

  let part1 = gamma * epsilon;
  let part2 = oxygen * co2;

  println!("day03: {} {}", part1, part2);
}
