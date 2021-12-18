import std/[sugar, strformat, strutils, sequtils]

const BITS = 12
const MASK = (1 shl BITS) - 1

func parseBitstring(input: string): int =
  input.foldl(a shl 1 or int b != '0', 0)

func bitAt(bits: int, index: int): bool =
  (bits shr (BITS - index - 1) and 1) == 1

func mostCommonBit(nums: openArray[int], bitIndex: int): bool =
  let count = nums.countIt it.bitAt bitIndex
  2 * count >= nums.len

func gammaEpsilon(nums: openArray[int]): (int, int) =
  var gamma = 0
  for bitIndex in 0 ..< BITS:
    gamma = gamma shl 1 or int nums.mostCommonBit bitIndex
  (gamma, gamma xor MASK)

func findByCriterion(nums: openArray[int], byMostCommon: bool): int =
  var nums = nums.toSeq
  for bitIndex in 0 ..< BITS:
    let mostCommon = nums.mostCommonBit bitIndex
    let bit = mostCommon xor byMostCommon
    nums.keepIf bits => bit == bits.bitAt bitIndex
    if nums.len == 1:
      return nums[0]
  raise Exception.newException "ran out of oxygen lmao"

proc solve* =
  let nums = ".input/day03".readFile.strip.split.map parseBitstring
  let (gamma, epsilon) = nums.gammaEpsilon
  let oxygen = nums.findByCriterion true
  let co2 = nums.findByCriterion false
  let part1 = gamma * epsilon
  let part2 = oxygen * co2
  echo &"day03: {part1} {part2}"
