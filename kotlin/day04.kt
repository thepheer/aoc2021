package aoc.day04

import aoc.extensions.*

const val N = 5
const val ROW_MASK = 0b00000_00000_00000_00000_11111
const val COL_MASK = 0b00001_00001_00001_00001_00001

class Board(val matrix: List<Byte>, var marked: Int = 0) {
  fun mark(num: Byte) {
    val shift = matrix.indexOfOrNull(num) ?: return
    marked = 1 shl shift or marked
  }

  fun hasBingo() = (0 until N).any {
    val row = ROW_MASK shl it * N
    val col = COL_MASK shl it
    marked and row == row || marked and col == col
  }

  fun sumAllUnmarked() = matrix
    .filterIndexed { shift, _ -> 1 shl shift and marked == 0 }
    .sum()
}

class Bingo(val nums: MutableList<Byte>, val boards: MutableList<Board>) {
  fun markInAllBoards(num: Byte) = boards.forEach { it.mark(num) }

  fun part1(): Int {
    for (drawn in generateSequence { nums.removeLastOrNull() }) {
      markInAllBoards(drawn)
      boards.find { it.hasBingo() }?.let {
        return drawn * it.sumAllUnmarked()
      }
    }
    throw Exception()
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
    throw Exception()
  }
}

fun String.toBoard(): Board {
  val nums = splitToSequence(' ', '\n').filter { it.isNotEmpty() }.map { it.toByte() }
  return Board(nums.toList())
}

fun String.toBingo(): Bingo {
  val parts = splitToSequence("\n\n")
  val nums = parts.first().splitToSequence(',').map { it.toByte() }.toMutableList()
  val boards = parts.drop(1).map { it.toBoard() }.toMutableList()
  return Bingo(nums.asReversed(), boards)
}

fun solve() {
  val input = java.io.File(".input", "day04").readText().trim()
  val bingo = input.toBingo()
  val part1 = bingo.part1()
  val part2 = bingo.part2()
  println("day04: $part1 $part2")
}
