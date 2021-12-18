#include <array>
#include <string_view>
#include "../util.hpp"

namespace day04 {
  constexpr size_t N = 5;
  constexpr uint32_t ROW_MASK = 0b00000'00000'00000'00000'11111;
  constexpr uint32_t COL_MASK = 0b00001'00001'00001'00001'00001;

  struct Board {
    std::array<uint8_t, N * N> matrix{};
    uint32_t marked{};

    explicit Board(const std::string_view input) {
      size_t i = 0;
      for (auto& n : util::tokenize(input))
        matrix[i++] = std::stoul(n.data());
    }

    auto mark(const uint8_t num) -> void {
      for (size_t i = 0; i < matrix.size(); i += 1)
        if (matrix[i] == num)
          return void(marked |= 1 << i);
    }

    auto sum_unmarked() -> uint32_t {
      uint32_t sum = 0;
      for (size_t i = 0; i < matrix.size(); i += 1)
        if ((marked & 1 << i) == 0)
          sum += matrix[i];
      return sum;
    }

    auto bingo() const -> bool {
      for (uint32_t i = 0; i < N; i += 1) {
        const auto row = ROW_MASK << i * N;
        const auto col = COL_MASK << i;
        if ((marked & row) == row || (marked & col) == col)
          return true;
      }
      return false;
    }
  };
}
