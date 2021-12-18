const std = @import("std");
const util = @import("../util.zig");
const BitBuffer = @import("BitBuffer.zig");
const Packet = @import("Packet.zig");

fn sumVersions(root: Packet) u64 {
  var acc: u64 = root.version;
  switch (root.data) {
    .operator => |op| {
      for (op.packets) |p| acc += sumVersions(p);
    },
    else => {}
  }
  return acc;
}

fn eval(root: Packet) u64 {
  switch (root.data) {
    .literal => |value| return value,
    .operator => |op| switch (op.kind) {
      .sum => {
        var acc = eval(op.packets[0]);
        for (op.packets[1..]) |p| acc += eval(p);
        return acc;
      },
      .product => {
        var acc = eval(op.packets[0]);
        for (op.packets[1..]) |p| acc *= eval(p);
        return acc;
      },
      .minimum => {
        var acc = eval(op.packets[0]);
        for (op.packets[1..]) |p| acc = std.math.min(acc, eval(p));
        return acc;
      },
      .maximum => {
        var acc = eval(op.packets[0]);
        for (op.packets[1..]) |p| acc = std.math.max(acc, eval(p));
        return acc;
      },
      .greater_than => {
        return @boolToInt(eval(op.packets[0]) > eval(op.packets[1]));
      },
      .less_than => {
        return @boolToInt(eval(op.packets[0]) < eval(op.packets[1]));
      },
      .equal_to => {
        return @boolToInt(eval(op.packets[0]) == eval(op.packets[1]));
      }
    }
  }
}

pub fn solve(mem: std.mem.Allocator) !void {
  const input = try util.readFileAlloc(mem, ".input/day16");
  const trimmed = std.mem.trim(u8, input, &std.ascii.spaces);
  defer mem.free(input);

  var buffer = try BitBuffer.fromHex(mem, trimmed);
  defer buffer.deinit(mem);

  const packet = try Packet.read(mem, &buffer);
  defer packet.deinit(mem);

  const part1 = sumVersions(packet);
  const part2 = eval(packet);

  std.debug.print("day16: {} {}\n", .{ part1, part2 });
}
