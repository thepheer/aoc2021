#include <array>
#include <vector>
#include "../util.hpp"

namespace day03 {
  const int BITS = 12;
  const int MASK = (1 << BITS) - 1;

  auto parse_bitstrings(std::string_view input) -> std::vector<int> {
    std::vector<int> nums;
    for (auto line : util::tokenize(input)) {
      auto bits = 0;
      for (auto bit : line)
        bits = bits << 1 | bit - '0';
      nums.emplace_back(bits);
    }
    return nums;
  }

  auto bit_at(int bits, int index) -> bool {
    return bits >> (BITS - index - 1) & 1;
  }

  auto most_common_bit(std::vector<int>& nums, int bit_index) -> bool {
    auto count = 0;
    for (auto bits : nums)
      count += bit_at(bits, bit_index);
    return 2 * count >= nums.size();
  }

  auto gamma_epsilon(std::vector<int>& nums)->std::array<int, 2> {
    auto gamma = 0;
    auto bit_index = 0;
    for (auto bit_index = 0; bit_index < BITS; bit_index += 1)
      gamma = gamma << 1 | most_common_bit(nums, bit_index);
    return { gamma, gamma ^ MASK };
  }

  auto find_by_criterion(std::vector<int> nums, bool by_most_common) -> int {
    for (auto bit_index = 0; bit_index < BITS; bit_index += 1) {
      auto most_common = most_common_bit(nums, bit_index);
      auto bit = most_common ^ by_most_common;

      for (auto index = nums.size(); index--;) {
        if (bit_at(nums[index], bit_index) != bit) {
          nums[index] = nums.back();
          nums.pop_back();
        }
      }

      if (nums.size() == 1)
        return nums[0];
    }

    throw std::runtime_error{ "bruh moment" };
  }

  auto solve() -> void {
    auto input = util::read_file_to_string(".input/day03");
    auto nums = parse_bitstrings(input);

    auto [gamma, epsilon] = gamma_epsilon(nums);
    auto oxygen = find_by_criterion(nums, true);
    auto co2 = find_by_criterion(nums, false);

    auto part1 = gamma * epsilon;
    auto part2 = oxygen * co2;

    std::cout << "day03: " << part1 << ' ' << part2 << '\n';
  }
}
