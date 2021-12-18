#include <sstream>
#include <stdexcept>
#include <string>
#include <string_view>
#include "../util.hpp"

namespace day02 {
  enum MoveKind { Forward, Down };
  struct Move {
    enum MoveKind kind;
    union {
      struct { int32_t forward; };
      struct { int32_t down; };
    };

    static auto parse(std::string_view input) -> Move {
      auto pair = util::split_once(input, " ");
      auto n = std::stoi(pair.second.data());
      if (pair.first == "up") return { Down, -n };
      if (pair.first == "down") return { Down, n };
      if (pair.first == "forward") return { Forward, n };
      throw std::runtime_error("cpp was a mistake");
    }

    static auto parse_many(std::string_view input) -> std::vector<Move> {
      std::vector<Move> moves;
      std::istringstream iss{ input.data() };
      for (std::string line; std::getline(iss, line); )
        moves.emplace_back(Move::parse(line));
      return moves;
    }
  };
}
