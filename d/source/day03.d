module day03;

import std;
import util;

const BITS = 12;
const MASK = (1 << BITS) - 1;

auto bitAt(uint bits, uint index) {
  return (bits >> (BITS - index - 1) & 1) == 1;
}

auto mostCommonBit(uint[] nums, uint bitIndex) {
  auto ones = nums.count!(bits => bits.bitAt(bitIndex));
  return 2 * ones >= nums.length;
}

auto gammaEpsilon(uint[] nums) {
  auto gamma = BITS.iota
    .map!(bitIndex => nums.mostCommonBit(bitIndex))
    .fold!((bits, bit) => bits << 1 | bit);
  return tuple!("gamma", "epsilon")(gamma, gamma ^ MASK);
}

auto findByCriterion(uint[] nums, bool byMostCommon) {
  foreach (bitIndex; 0..BITS) {
    auto mostCommon = nums.mostCommonBit(bitIndex);
    auto bit = mostCommon ^ byMostCommon;
    nums.retainUnordered!(bits => bits.bitAt(bitIndex) == bit);
    if (nums.length == 1)
      return nums.front;
  }
  assert(0);
}

void solve() {
  auto input = ".input/day03".File;
  auto nums = input.byLine.map!(n => n.to!uint(2)).array;
  auto aux = nums.gammaEpsilon;
  auto oxygen = nums.dup.findByCriterion(true);
  auto co2 = nums.dup.findByCriterion(false);
  auto part1 = aux.gamma * aux.epsilon;
  auto part2 = oxygen * co2;
  writefln("day03: %s %s", part1, part2);
}
