module day02;

import std;

struct Forward { int steps; }
struct Down { int steps; }
alias Move = SumType!(Forward, Down);

auto parseMove(char[] input) {
  auto parts = input.splitter(' ');
  auto name = parts.front;
  auto num = parts.drop(1).front.to!int;
  switch (name) {
    case "up": return Down(-num).Move;
    case "down": return Down(num).Move;
    case "forward": return Forward(num).Move;
    default: assert(0);
  }
}

struct Submarine {
  int hPos, depth, aim;

  auto part1(Move[] moves) {
    foreach (ref move; moves) move.match!(
      (Down down) { depth += down.steps; },
      (Forward forward) { hPos += forward.steps; }
    );
    return hPos * depth;
  }

  auto part2(Move[] moves) {
    foreach (ref move; moves) move.match!(
      (Down down) { aim += down.steps; },
      (Forward forward) {
        hPos += forward.steps;
        depth += forward.steps * aim;
      }
    );
    return hPos * depth;
  }
}

void solve() {
  auto input = ".input/day02".File;
  auto moves = input.byLine.map!parseMove.array;
  auto part1 = Submarine().part1(moves);
  auto part2 = Submarine().part2(moves);
  writefln("day02: %s %s", part1, part2);
}
