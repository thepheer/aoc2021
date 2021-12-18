#include <iostream>
#include "bingo.cpp"
#include "../util.hpp"

namespace day04 {
  auto solve() -> void {
    auto input = util::read_file_to_string(".input/day04");
    auto bingo = Bingo(input);

    auto part1 = bingo.part1();
    auto part2 = bingo.part2();

    std::cout << "day04: " << part1 << ' ' << part2 << '\n';
  }
}
