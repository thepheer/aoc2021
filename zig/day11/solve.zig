const std = @import("std");
const util = @import("../util.zig");

const Scalar = i32;
const Energy = std.math.IntFittingRange(0, 10);
const ENERGY_CYCLE = 10;

const vec2 = Vec2.new;
const Vec2 = struct {
  x: Scalar,
  y: Scalar,

  fn new(x: Scalar, y: Scalar) Vec2 {
    return .{ .x = x, .y = y };
  }

  fn neighbors(self: Vec2) [8]Vec2 {
    return .{
      new(self.x - 1, self.y - 1),
      new(self.x - 1, self.y + 1),
      new(self.x + 1, self.y - 1),
      new(self.x + 1, self.y + 1),
      new(self.x, self.y - 1),
      new(self.x, self.y + 1),
      new(self.x - 1, self.y),
      new(self.x + 1, self.y),
    };
  }
};

const Grid = struct {
  flashed: std.ArrayList(Vec2),
  grid: std.ArrayList(Energy),
  size: Vec2,

  fn init(mem: std.mem.Allocator, input: []const u8) !Grid {
    var grid = std.ArrayList(Energy).init(mem);
    errdefer grid.deinit();

    var lines = std.mem.tokenize(u8, input, "\n");
    var height: Scalar = 0;
    while (lines.next()) |line| {
      for (line) |digit|
        try grid.append(@intCast(Energy, digit - '0'));
      height += 1;
    }

    const area = @intCast(Scalar, grid.items.len);
    const width = @divExact(area, height);
    const size = vec2(width, height);

    const flashed = std.ArrayList(Vec2).init(mem);
    return Grid{ .flashed = flashed, .grid = grid, .size = size };
  }

  fn deinit(self: Grid) void {
    self.flashed.deinit();
    self.grid.deinit();
  }

  fn inBounds(self: Grid, at: Vec2) bool {
    const x = 0 <= at.x and at.x < self.size.x;
    const y = 0 <= at.y and at.y < self.size.y;
    return x and y;
  }

  fn index(self: Grid, at: Vec2) usize {
    return @intCast(usize, self.size.x * at.y + at.x);
  }

  fn get(self: Grid, at: Vec2) Energy {
    return self.grid.items[self.index(at)];
  }

  fn set(self: Grid, at: Vec2, energy: Energy) void {
    self.grid.items[self.index(at)] = energy;
  }

  fn inc(self: Grid, at: Vec2) Energy {
    var ptr = &self.grid.items[self.index(at)];
    ptr.* = (ptr.* + 1) % ENERGY_CYCLE;
    return ptr.*;
  }

  fn incAll(self: *Grid) !void {
    var y: Scalar = 0;
    while (y < self.size.y) : (y += 1) {
      var x: Scalar = 0;
      while (x < self.size.x) : (x += 1) {
        if (self.inc(vec2(x, y)) == 0)
          try self.flashed.append(vec2(x, y));
      }
    }
  }

  fn flashAll(self: *Grid) !u32 {
    var count: u32 = 0;
    while (self.flashed.popOrNull()) |at| {
      for (at.neighbors()) |n| {
        if (!self.inBounds(n)) continue;
        if (self.get(n) == 0) continue;
        if (self.inc(n) != 0) continue;
        try self.flashed.append(n);
      }
      count += 1;
    }
    return count;
  }

  fn steps(self: *Grid, n: u32) !u32 {
    var count: u32 = 0;
    var i: u32 = 0;
    while (i < n) : (i += 1) {
      try self.incAll();
      count += try self.flashAll();
    }
    return count;
  }

  fn stepsUntilAllFlash(self: *Grid) !u32 {
    var step: u32 = 1;
    while (true) : (step += 1) {
      const flashed = try self.steps(1);
      if (flashed == self.size.x * self.size.y)
        return step;
    }
  }
};

pub fn solve(mem: std.mem.Allocator) !void {
  const input = try util.readFileAlloc(mem, ".input/day11");
  defer mem.free(input);

  var grid = try Grid.init(mem, input);
  defer grid.deinit();

  const flashed_after_100_steps = try grid.steps(100);
  const steps_until_all_flashed = try grid.stepsUntilAllFlash();

  const part1 = flashed_after_100_steps;
  const part2 = steps_until_all_flashed + 100;

  std.debug.print("day11: {} {}\n", .{ part1, part2 });
}
