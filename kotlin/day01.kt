package aoc.day01

fun <T : Comparable<T>> Iterable<T>.countIncreasing() =
  zipWithNext().count { it.first < it.second }

fun solve() {
  val input = java.io.File(".input", "day01")
  val depth = input.readLines().map { it.toInt() }.toList()
  val part1 = depth.countIncreasing()
  val part2 = depth.windowed(3).map { it.sum() }.countIncreasing()
  println("day01: $part1 $part2")
}
