const std = @import("std");
const util = @import("../util.zig");

fn countInreasing(nums: []u32, step: usize) usize {
  var count: usize = 0;
  for (nums[step..]) |n, i| {
    if (n > nums[i])
      count += 1;
  }
  return count;
}

pub fn solve(mem: std.mem.Allocator) !void {
  const input = try util.readFileAlloc(mem, ".input/day01");
  defer mem.free(input);

  const nums = try util.parseNumsAlloc(mem, u32, input, "\n");
  defer mem.free(nums);

  const part1 = countInreasing(nums, 1);
  const part2 = countInreasing(nums, 3);

  std.debug.print("day01: {} {}\n", .{ part1, part2 });
}
