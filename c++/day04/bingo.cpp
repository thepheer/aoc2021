#include <algorithm>
#include <string_view>
#include <vector>
#include "board.cpp"
#include "../util.hpp"

namespace day04 {
  struct Bingo {
    std::vector<uint8_t> nums{};
    std::vector<Board> boards{};

    explicit Bingo(const std::string_view input) {
      const auto parts = util::split(input, "\n\n");
      for (auto& n : util::split(parts[0], ","))
        nums.emplace_back(std::stoul(n.data()));
      for (auto i = 1u; i < parts.size(); i += 1)
        boards.emplace_back(Board(parts[i]));
      std::reverse(nums.begin(), nums.end());
    }

    auto part1() -> uint32_t {
      while (!nums.empty()) {
        const auto drawn = nums.back();
        nums.pop_back();
        mark_in_all_boards(drawn);
        if (const auto winner = find_winner())
          return winner->sum_unmarked() * drawn;
      }
      throw std::runtime_error{ "bingo moment" };
    }

    auto part2() -> uint32_t {
      while (!nums.empty()) {
        const auto drawn = nums.back();
        nums.pop_back();
        mark_in_all_boards(drawn);
        if (boards.size() > 1)
          eliminate_winners();
        else if (boards[0].bingo())
          return boards[0].sum_unmarked() * drawn;
      }
      throw std::runtime_error{ "bingus moment" };
    }

    auto mark_in_all_boards(const uint8_t num) -> void {
      for (auto& board : boards)
        board.mark(num);
    }

    auto eliminate_winners() -> void {
      for (auto index = boards.size(); index--;) {
        if (boards[index].bingo()) {
          boards[index] = boards.back();
          boards.pop_back();
        }
      }
    }

    auto find_winner() -> Board* {
      for (auto& board : boards)
        if (board.bingo())
          return &board;
      return nullptr;
    }
  };
}
