package aoc.day04

fun solve() {
  val input = java.io.File(".input", "day04").readText()
  val bingo = input.toBingo()
  val part1 = bingo.part1()
  val part2 = bingo.part2()
  println("day04: $part1 $part2")
}
