package aoc.day02

sealed class Move {
  class Down(val n: Int) : Move()
  class Forward(val n: Int) : Move()
}

fun String.toMove(): Move {
  val (lhs, rhs) = split(' ')
  val num = rhs.toInt()
  return when (lhs) {
    "up" -> Move.Down(-num)
    "down" -> Move.Down(num)
    "forward" -> Move.Forward(num)
    else -> throw Exception()
  }
}

class Submarine {
  var hPos = 0
  var depth = 0
  var aim = 0

  fun part1(moves: Iterable<Move>): Int {
    for (move in moves) when (move) {
      is Move.Down -> depth += move.n
      is Move.Forward -> hPos += move.n
    }
    return hPos * depth
  }

  fun part2(moves: Iterable<Move>): Int {
    for (move in moves) when (move) {
      is Move.Down -> aim += move.n
      is Move.Forward -> {
        hPos += move.n
        depth += move.n * aim
      }
    }
    return hPos * depth
  }
}

fun solve() {
  val input = java.io.File(".input", "day02")
  val moves = input.readLines().map { it.toMove() }.toList()
  val part1 = Submarine().part1(moves)
  val part2 = Submarine().part2(moves)
  println("day02: $part1 $part2")
}
