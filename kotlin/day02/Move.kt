package aoc.day02

import aoc.utils.*

internal sealed class Move {
  class Down(val steps: Int) : Move()
  class Forward(val steps: Int) : Move()
}

internal fun String.toMove(): Move {
  val (lhs, rhs) = split(' ')
  val num = rhs.toInt()
  return when (lhs) {
    "up" -> Move.Down(-num)
    "down" -> Move.Down(num)
    "forward" -> Move.Forward(num)
    else -> unreachable()
  }
}