const std = @import("std");
const util = @import("../util.zig");

const Model = struct {
  timers: [9]u64,

  fn init(input: []const u8) !Model {
    const trimmed = std.mem.trim(u8, input, "\n");
    var iter = std.mem.split(u8, trimmed, ",");
    var self = std.mem.zeroes(Model);
    while (iter.next()) |timer|
      self.timers[try std.fmt.parseInt(usize, timer, 10)] += 1;
    return self;
  }

  fn simulate(self: *Model, days: usize) u64 {
    var day: usize = 0;
    while (day < days) : (day += 1)
      self.timers[(day + 7) % 9] += self.timers[day % 9];
    std.mem.rotate(u64, self.timers[0..], days % 9);
    return self.countFish();
  }

  fn countFish(self: Model) u64 {
    var fish: u64 = 0;
    for (self.timers) |n| fish += n;
    return fish;
  }
};

pub fn solve(mem: std.mem.Allocator) !void {
  const input = try util.readFileAlloc(mem, ".input/day06");
  defer mem.free(input);

  var model = try Model.init(input);

  const part1 = model.simulate(80);
  const part2 = model.simulate(256 - 80);

  std.debug.print("day06: {} {}\n", .{ part1, part2 });
}
