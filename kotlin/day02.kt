package aoc

private sealed class Move {
  class Down(val steps: Int) : Move()
  class Forward(val steps: Int) : Move()
}

private fun String.toMove(): Move {
  val (lhs, rhs) = split(' ')
  val num = rhs.toInt()
  return when (lhs) {
    "up" -> Move.Down(-num)
    "down" -> Move.Down(num)
    "forward" -> Move.Forward(num)
    else -> unreachable()
  }
}

private class Submarine {
  var hPos = 0
  var depth = 0
  var aim = 0

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

fun day02() {
  val input = java.io.File(".input", "day02")
  val moves = input.useLines { it.map(String::toMove).toList() }
  val part1 = Submarine().part1(moves)
  val part2 = Submarine().part2(moves)
  println("day02: $part1 $part2")
}
