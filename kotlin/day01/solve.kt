package aoc.day01

internal fun <T : Comparable<T>> Sequence<T>.countIncreasing() =
  zipWithNext().count { it.first < it.second }

fun solve() {
  val input = java.io.File(".input", "day01")
  val depth = input.useLines { it.map(String::toInt).toList().asSequence() }
  val part1 = depth.countIncreasing()
  val part2 = depth.windowed(3).map { it.sum() }.countIncreasing()
  println("day01: $part1 $part2")
}
