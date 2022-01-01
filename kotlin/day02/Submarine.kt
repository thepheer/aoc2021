package aoc.day02

internal class Submarine {
  private var hPos = 0
  private var depth = 0
  private var aim = 0

  fun part1(moves: Iterable<Move>): Int {
    for (move in moves) when (move) {
      is Move.Down -> depth += move.steps
      is Move.Forward -> hPos += move.steps
    }
    return hPos * depth
  }

  fun part2(moves: Iterable<Move>): Int {
    for (move in moves) when (move) {
      is Move.Down -> aim += move.steps
      is Move.Forward -> {
        hPos += move.steps
        depth += move.steps * aim
      }
    }
    return hPos * depth
  }
}