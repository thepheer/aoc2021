module day01;

import std;

auto countIncreasing(R)(R nums) if (isInputRange!R) {
  return nums.slide(2).count!(pair => pair[0] < pair[1]);
}

void solve() {
  auto input = ".input/day01".File;
  auto depth = input.byLine.map!(to!uint).array;
  auto part1 = depth.countIncreasing;
  auto part2 = depth.slide(3).map!sum.countIncreasing;
  writefln("day01: %s %s", part1, part2);
}
