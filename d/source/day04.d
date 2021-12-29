module day04;

import std;
import util;

const N = 5;
const ROW_MASK = 0b_00000_00000_00000_00000_11111;
const COL_MASK = 0b_00001_00001_00001_00001_00001;

struct Board {
  uint marked;
  ubyte[] matrix;

  static auto parse(string input) {
    return Board(0, input.splitter.map!(to!ubyte).array);
  }

  void mark(ubyte num) {
    auto shift = matrix.countUntil(num);
    if (shift != -1)
      marked |= 1 << shift;
  }

  auto sumAllUnmarked() {
    return matrix.enumerate
      .filter!(e => (marked & 1 << e.index) == 0)
      .fold!((acc, e) => acc + e.value)(0);
  }

  auto hasBingo() {
    return N.iota.any!((shift) {
      auto row = ROW_MASK << shift * N;
      auto col = COL_MASK << shift;
      return (marked & row) == row || (marked & col) == col;
    });
  }
}

struct Bingo {
  ubyte[] nums;
  Board[] boards;

  static auto parse(string input) {
    auto parts = input.splitter("\n\n");
    auto nums = parts.front.splitter(',').map!(to!ubyte).array;
    auto boards = parts.drop(1).map!(Board.parse).array;
    return Bingo(nums.reverse, boards);
  }

  void markInAllBoards(ubyte num) {
    foreach (ref board; boards)
      board.mark(num);
  }

  auto part1() {
    while (!nums.empty) {
      auto drawn = nums.back;
      nums.popBack;
      markInAllBoards(drawn);
      auto winner = boards.find!(b => b.hasBingo);
      if (!winner.empty)
        return drawn * winner.front.sumAllUnmarked;
    }
    assert(0);
  }

  auto part2() {
    while (!nums.empty) {
      auto drawn = nums.back;
      nums.popBack;
      markInAllBoards(drawn);
      switch (boards.length) {
        case 1:
          if (boards.front.hasBingo)
            return drawn * boards.front.sumAllUnmarked;
          break;
        default:
          boards.retainUnordered!(b => !b.hasBingo);
      }
    }
    assert(0);
  }
}

void solve() {
  auto input = ".input/day04".readText;
  auto bingo = Bingo.parse(input);
  auto part1 = bingo.part1;
  auto part2 = bingo.part2;
  writefln("day04: %s %s", part1, part2);
}
