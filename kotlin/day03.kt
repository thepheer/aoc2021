package aoc

private const val BITS = 12
private const val MASK = (1 shl BITS) - 1

private fun Int.bitAt(index: Int) =
  shr (BITS - index - 1) and 1 == 1

private fun Iterable<Int>.mostCommonBit(bitIndex: Int) =
  2 * count { it.bitAt(bitIndex) } >= count()

private fun Iterable<Int>.gammaEpsilon(): Pair<Int, Int> {
  val gamma = (0 until BITS).asSequence()
    .map { bitIndex -> mostCommonBit(bitIndex).toInt() }
    .fold(0) { bits, bit -> bits shl 1 or bit }
  return Pair(gamma, gamma xor MASK)
}

private fun Iterable<Int>.findByCriterion(byMostCommon: Boolean): Int {
  val nums = toMutableList()
  for (bitIndex in 0 until BITS) {
    val mostCommon = nums.mostCommonBit(bitIndex)
    val bit = mostCommon xor byMostCommon
    nums.retainAll { it.bitAt(bitIndex) == bit }
    if (nums.count() == 1)
      return nums.first()
  }
  unreachable()
}

fun day03() {
  val input = java.io.File(".input", "day03")
  val nums = input.useLines { it.map { it.toInt(2) }.toList() }
  val (gamma, epsilon) = nums.gammaEpsilon()
  val oxygen = nums.findByCriterion(true)
  val co2 = nums.findByCriterion(false)
  val part1 = gamma * epsilon
  val part2 = oxygen * co2
  println("day03: $part1 $part2")
}
