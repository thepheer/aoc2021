const std = @import("std");
const util = @import("../util.zig");

const CaveSystem = struct {
  paths: std.StringHashMap(std.ArrayList([]const u8)),

  fn init(mem: std.mem.Allocator, input: []const u8) !CaveSystem {
    var paths = std.StringHashMap(std.ArrayList([]const u8)).init(mem);
    errdefer paths.deinit();

    var self = CaveSystem{ .paths = paths };
    var lines = std.mem.tokenize(u8, input, "\n");
    while (lines.next()) |line| {
      var parts = std.mem.split(u8, line, "-");
      const lhs = parts.next().?;
      const rhs = parts.next().?;

      try self.addPath(lhs, rhs);
      try self.addPath(rhs, lhs);
    }
    return self;
  }

  fn deinit(self: *CaveSystem) void {
    var entries = self.paths.iterator();
    while (entries.next()) |entry|
      entry.value_ptr.deinit();
    self.paths.deinit();
  }

  fn addPath(self: *CaveSystem, from: []const u8, to: []const u8) !void {
    const entry = try self.paths.getOrPut(from);
    if (!entry.found_existing)
      entry.value_ptr.* = std.ArrayList([]const u8).init(self.paths.allocator);
    try entry.value_ptr.append(to);
  }
};

pub fn solve(mem: std.mem.Allocator) !void {
  const input = try util.readFileAlloc(mem, ".input/day12");
  defer mem.free(input);

  var caves = try CaveSystem.init(mem, input);
  defer caves.deinit();

  // Didn't have enough time to solve this one.

  // Even making this hashmap in zig turned out to be tricky and
  // time consuming, I wanted to encapsulate arena allocator into
  // the struct and turned out it's actually not that easy as I
  // initially anticipated.

  // Might try to come back to this problem later.

  std.debug.print("day12: - -\n", .{});
}
