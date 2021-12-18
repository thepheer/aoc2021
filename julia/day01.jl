module day01
  function solve()::Nothing
    nums = parse.(Int, eachline(".input/day01"))

    part1 = count(a < b for (a, b) in zip(nums, @view nums[2:end]))
    part2 = count(a < b for (a, b) in zip(nums, @view nums[4:end]))

    println("day01: $part1 $part2")
  end
end
