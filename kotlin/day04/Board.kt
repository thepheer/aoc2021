package aoc.day04

import aoc.utils.*

private const val N = 5
private const val ROW_MASK = 0b00000_00000_00000_00000_11111
private const val COL_MASK = 0b00001_00001_00001_00001_00001

internal class Board(private val matrix: List<Byte>, private var marked: Int = 0) {
  fun mark(num: Byte) {
    val shift = matrix.indexOfOrNull(num) ?: return
    marked = 1 shl shift or marked
  }

  fun hasBingo() = (0 until N).any {
    val row = ROW_MASK shl it * N
    val col = COL_MASK shl it
    marked and row == row || marked and col == col
  }

  fun sumAllUnmarked() = matrix.asSequence()
    .filterIndexed { shift, _ -> 1 shl shift and marked == 0 }
    .sum()
}

internal fun String.toBoard(): Board {
  val nums = splitToSequence(' ', '\n').filter { it.isNotEmpty() }.map { it.toByte() }
  return Board(nums.toList())
}