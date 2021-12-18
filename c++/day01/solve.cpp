#include <iostream>
#include <vector>
#include "../util.hpp"

namespace day01 {
  auto parse_depths(std::string_view input) -> std::vector<uint32_t> {
    std::vector<uint32_t> nums;
    for (auto n : util::tokenize(input))
      nums.emplace_back(std::stoul(n.data()));
    return nums;
  }

  auto count_increasing(std::vector<uint32_t>& nums, size_t step) -> size_t {
    size_t count = 0;
    for (size_t i = step; i < nums.size(); i++)
      if (nums[i] > nums[i - step])
        count += 1;
    return count;
  }

  auto solve() -> void {
    auto input = util::read_file_to_string(".input/day01");
    auto depths = parse_depths(input);

    auto part1 = count_increasing(depths, 1);
    auto part2 = count_increasing(depths, 3);

    std::cout << "day01: " << part1 << ' ' << part2 << '\n';
  }
}
