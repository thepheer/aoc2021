import std/[strformat, strutils, sequtils]

func countIncreasing(nums: openArray[int], step: int): int =
  for i in step .. nums.high:
    if nums[i] > nums[i - step]:
      inc result

proc solve* =
  let depths = ".input/day01".readFile.strip.split.map parseInt
  let part1 = depths.countIncreasing 1
  let part2 = depths.countIncreasing 3
  echo &"day01: {part1} {part2}"
