const std = @import("std");
const util = @import("../util.zig");
const Move = @import("move.zig").Move;
const Submarine = @import("submarine.zig");

pub fn solve(mem: std.mem.Allocator) !void {
  const input = try util.readFileAlloc(mem, ".input/day02");
  defer mem.free(input);

  var moves = try Move.parseMany(mem, input);
  defer mem.free(moves);

  const part1 = Submarine.part1(moves);
  const part2 = Submarine.part2(moves);

  std.debug.print("day02: {} {}\n", .{ part1, part2 });
}
