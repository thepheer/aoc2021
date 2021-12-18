#pragma once
#include <string_view>
#include <string>
#include <vector>

namespace util {
  auto read_file_to_string(const std::string_view filename) -> std::string;
  auto split_once(const std::string_view input, const std::string_view delim) -> std::pair<std::string_view, std::string_view>;
  auto split(const std::string_view input, const std::string_view delim) -> std::vector<std::string_view>;
  auto tokenize(const std::string_view input) -> std::vector<std::string_view>;
}
