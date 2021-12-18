const std = @import("std");
const util = @import("../util.zig");
const Bingo = @import("bingo.zig");

pub fn solve(mem: std.mem.Allocator) !void {
  const input = try util.readFileAlloc(mem, ".input/day04");
  defer mem.free(input);

  var bingo = try Bingo.parse(mem, input);
  defer bingo.deinit();

  const part1 = bingo.part1();
  const part2 = bingo.part2();

  std.debug.print("day04: {} {}\n", .{ part1, part2 });
}
