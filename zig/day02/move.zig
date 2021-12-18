const std = @import("std");
const fp = @import("../fp.zig");
const util = @import("../util.zig");

pub const Move = union(enum) {
  down: i32,
  forward: i32,

  pub fn parse(input: []const u8) !Move {
    var iter = std.mem.tokenize(u8, input, " ");
    const command = iter.next().?;
    const value = iter.next().?;
    const n = try std.fmt.parseInt(i32, value, 10);

    if (std.mem.eql(u8, command, "up"))
      return Move{ .down = -n };

    if (std.mem.eql(u8, command, "down"))
      return Move{ .down = n };

    if (std.mem.eql(u8, command, "forward"))
      return Move{ .forward = n };

    unreachable;
  }

  pub fn parseMany(mem: std.mem.Allocator, input: []const u8) ![]Move {
    const lines = try util.splitLines(mem, input);
    defer mem.free(lines);

    return fp.map(mem, Move.parse, lines);
  }
};
