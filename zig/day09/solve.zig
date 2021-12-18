const std = @import("std");
const util = @import("../util.zig");

const Scalar = u32;
const Height = std.math.IntFittingRange(0, 9);
const MAX_HEIGHT: Height = 9;

const vec2 = Vec2.new;
const Vec2 = struct {
  x: Scalar,
  y: Scalar,

  fn new(x: Scalar, y: Scalar) Vec2 {
    return .{ .x = x, .y = y };
  }

  fn neighbors(self: Vec2) [4]Vec2 {
    return .{
      new(self.x + 1, self.y), new(self.x, self.y + 1),
      new(self.x - 1, self.y), new(self.x, self.y - 1)
    };
  }
};

const HeightMap = struct {
  stack: std.ArrayList(Vec2), // used in basinSize method
  grid: std.ArrayList(Height),
  size: Vec2,

  fn init(mem: std.mem.Allocator, input: []const u8) !HeightMap {
    var grid = std.ArrayList(Height).init(mem);
    errdefer grid.deinit();

    var lines = std.mem.tokenize(u8, input, "\n");
    var height: Scalar = 0;
    while (lines.next()) |line| {
      try grid.append(MAX_HEIGHT); // padding
      for (line) |digit|
        try grid.append(@intCast(Height, digit - '0'));
      try grid.append(MAX_HEIGHT); // padding
      height += 1;
    }

    const width = @intCast(Scalar, grid.items.len) / height;
    try grid.appendNTimes(MAX_HEIGHT, 2 * width); // padding
    std.mem.rotate(Height, grid.items, grid.items.len - width);

    const size = vec2(width, height + 2);
    const stack = std.ArrayList(Vec2).init(mem);
    return HeightMap{ .grid = grid, .stack = stack, .size = size };
  }

  fn deinit(self: HeightMap) void {
    self.stack.deinit();
    self.grid.deinit();
  }

  fn indexAt(self: HeightMap, at: Vec2) usize {
    return self.size.x * at.y + at.x;
  }

  fn heightAt(self: HeightMap, at: Vec2) Height {
    return self.grid.items[self.indexAt(at)];
  }

  fn setHeightAt(self: HeightMap, at: Vec2, height: Height) void {
    self.grid.items[self.indexAt(at)] = height;
  }

  fn isLowPointAt(self: HeightMap, at: Vec2) bool {
    var min_height: Height = MAX_HEIGHT;
    for (at.neighbors()) |n|
      min_height = std.math.min(min_height, self.heightAt(n));
    return self.heightAt(at) < min_height;
  }

  fn basinSizeAt(self: *HeightMap, at: Vec2) !?Scalar {
    if (self.heightAt(at) == MAX_HEIGHT)
      return null;

    self.stack.clearRetainingCapacity();
    try self.stack.append(at);

    var size: Scalar = 0;
    while (self.stack.popOrNull()) |vec| {
      if (self.heightAt(vec) < MAX_HEIGHT) {
        size += 1;
        self.setHeightAt(vec, MAX_HEIGHT);
        try self.stack.appendSlice(vec.neighbors()[0..]);
      }
    }
    return size;
  }

  fn lowPointsRiskLevelSum(self: HeightMap) Scalar {
    var sum: Scalar = 0;
    var y: Scalar = 1;
    while (y < self.size.y - 1) : (y += 1) {
      var x: Scalar = 1;
      while (x < self.size.x - 1) : (x += 1) {
        if (self.isLowPointAt(vec2(x, y)))
          sum += self.heightAt(vec2(x, y)) + 1;
      }
    }
    return sum;
  }

  fn nLargestBasinsSizeProduct(self: *HeightMap, n: usize) !Scalar {
    var basin_sizes = std.ArrayList(Scalar).init(self.stack.allocator);
    defer basin_sizes.deinit();

    var y: Scalar = 1;
    while (y < self.size.y - 1) : (y += 1) {
      var x: Scalar = 1;
      while (x < self.size.x - 1) : (x += 1) {
        if (try self.basinSizeAt(vec2(x, y))) |size|
          try basin_sizes.append(size);
      }
    }

    const desc = comptime std.sort.desc(Scalar);
    std.sort.sort(Scalar, basin_sizes.items, {}, desc);

    var product: Scalar = 1;
    for (basin_sizes.items[0..n]) |size|
      product *= size;
    return product;
  }

  // debug view
  pub fn format(self: HeightMap, _: anytype, _: anytype, writer: anytype) !void {
    var y: Scalar = 0;
    while (y < self.size.y) : (y += 1) {
      var x: Scalar = 0;
      while (x < self.size.x) : (x += 1) {
        const height = self.heightAt(vec2(x, y));
        const style = if (height == 9) "1;30"
          else if (self.isLowPointAt(vec2(x, y))) "33"
          else "30";
        try writer.print("\x1b[{s}m{}\x1b[0m", .{ style, height });
      }
      try writer.print("\n", .{});
    }
  }
};

pub fn solve(mem: std.mem.Allocator) !void {
  const input = try util.readFileAlloc(mem, ".input/day09");
  defer mem.free(input);

  var height_map = try HeightMap.init(mem, input);
  defer height_map.deinit();

  const part1 = height_map.lowPointsRiskLevelSum();
  const part2 = try height_map.nLargestBasinsSizeProduct(3);

  std.debug.print("day09: {} {}\n", .{ part1, part2 });
}
