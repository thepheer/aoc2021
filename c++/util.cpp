#include <fstream>
#include <iterator>
#include <sstream>
#include <string_view>
#include <string>
#include <vector>
#include "util.hpp"

namespace util {
  auto read_file_to_string(const std::string_view filename) -> std::string {
    if (auto ifs = std::ifstream{ filename.data() })
      return { std::istreambuf_iterator<char>{ifs}, std::istreambuf_iterator<char>{} };
    throw std::runtime_error{ "died a horrible death" };
  }

  auto split_once(const std::string_view input, const std::string_view delim) -> std::pair<std::string_view, std::string_view> {
    auto index = input.find(delim);
    if (index != std::string::npos)
      return { input.substr(0, index), input.substr(index + 1) };
    throw std::runtime_error{ "oh well it didn't work" };
  }

  auto split(const std::string_view input, const std::string_view delim) -> std::vector<std::string_view> {
    std::vector<std::string_view> parts;
    size_t lo = 0;
    for (size_t hi; (hi = input.find(delim, lo)) != std::string::npos;) {
      parts.emplace_back(input.substr(lo, hi - lo));
      lo = hi + delim.length();
    }
    parts.emplace_back(input.substr(lo));
    return parts;
  }

  auto tokenize(const std::string_view input) -> std::vector<std::string_view> {
    const auto ws = " \n\r\t";
    std::vector<std::string_view> parts;
    for (size_t lo, hi = 0; (lo = input.find_first_not_of(ws, hi)) != std::string::npos;) {
      hi = input.find_first_of(ws, lo);
      parts.emplace_back(input.substr(lo, hi - lo));
    }
    return parts;
  }
}
