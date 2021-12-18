#include <iostream>
#include "move.cpp"
#include "../util.hpp"

namespace day02 {
  auto solve_part1(std::vector<Move>& moves) -> int32_t {
    int32_t h_pos = 0;
    int32_t depth = 0;
    for (auto move : moves) {
      switch (move.kind) {
      case Down: depth += move.down; break;
      case Forward: h_pos += move.forward; break;
      }
    }
    return h_pos * depth;
  }

  auto solve_part2(std::vector<Move>& moves) -> int32_t {
    int32_t h_pos = 0;
    int32_t depth = 0;
    int32_t aim = 0;
    for (auto move : moves) {
      switch (move.kind) {
      case Down: aim += move.down; break;
      case Forward:
        h_pos += move.forward;
        depth += move.forward * aim;
        break;
      }
    }
    return h_pos * depth;
  }

  auto solve() -> void {
    auto input = util::read_file_to_string(".input/day02");
    auto moves = Move::parse_many(input);

    auto part1 = solve_part1(moves);
    auto part2 = solve_part2(moves);

    std::cout << "day02: " << part1 << ' ' << part2 << '\n';
  }
}
