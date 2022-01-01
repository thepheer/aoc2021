package aoc.day04

import aoc.utils.*

internal class Bingo(private val nums: MutableList<Byte>, private val boards: MutableList<Board>) {
  private fun markInAllBoards(num: Byte) = boards.forEach { it.mark(num) }

  fun part1(): Int {
    for (drawn in generateSequence { nums.removeLastOrNull() }) {
      markInAllBoards(drawn)
      boards.find { it.hasBingo() }?.let {
        return drawn * it.sumAllUnmarked()
      }
    }
    unreachable()
  }

  fun part2(): Int {
    for (drawn in generateSequence { nums.removeLastOrNull() }) {
      markInAllBoards(drawn)
      when (boards.count()) {
        1 -> boards.first().takeIf { it.hasBingo() }?.let {
          return drawn * it.sumAllUnmarked()
        }
        else -> boards.removeAll { it.hasBingo() }
      }
    }
    unreachable()
  }
}

internal fun String.toBingo(): Bingo {
  val parts = trim().splitToSequence("\n\n")
  val nums = parts.first().splitToSequence(',').map { it.toByte() }.toMutableList()
  val boards = parts.drop(1).map { it.toBoard() }.toMutableList()
  return Bingo(nums.asReversed(), boards)
}