package aoc.day02

fun solve() {
  val input = java.io.File(".input", "day02")
  val moves = input.useLines { it.map(String::toMove).toList() }
  val part1 = Submarine().part1(moves)
  val part2 = Submarine().part2(moves)
  println("day02: $part1 $part2")
}
