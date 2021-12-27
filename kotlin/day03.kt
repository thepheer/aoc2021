package aoc.day03

val BITS = 12
val MASK = (1 shl BITS) - 1

fun Int.bitAt(index: Int) =
  shr (BITS - index - 1) and 1 == 1

fun Iterable<Int>.mostCommonBit(bitIndex: Int) =
  2 * filter { it.bitAt(bitIndex) }.count() >= count()

fun Iterable<Int>.gammaEpsilon(): Pair<Int, Int> {
  val gamma = (0 until BITS)
    .map { bitIndex -> mostCommonBit(bitIndex).compareTo(false) }
    .fold(0) { bits, bit -> bits shl 1 or bit }
  return Pair(gamma, gamma xor MASK)
}

fun Iterable<Int>.findByCriterion(byMostCommon: Boolean): Int {
  val nums = toMutableList()
  for (bitIndex in 0 until BITS) {
    val mostCommon = nums.mostCommonBit(bitIndex)
    val bit = mostCommon xor byMostCommon
    nums.retainAll { it.bitAt(bitIndex) == bit }
    if (nums.count() == 1) return nums[0]
  }
  throw Exception()
}

fun solve() {
  val input = java.io.File(".input", "day03")
  val nums = input.readLines().map { it.toInt(2) }
  val (gamma, epsilon) = nums.gammaEpsilon()
  val oxygen = nums.findByCriterion(true)
  val co2 = nums.findByCriterion(false)
  val part1 = gamma * epsilon
  val part2 = oxygen * co2
  println("day03: $part1 $part2")
}
