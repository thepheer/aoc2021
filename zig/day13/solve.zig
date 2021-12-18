const std = @import("std");
const util = @import("../util.zig");

const Dot = struct {
  x: u32,
  y: u32,

  fn parse(input: []const u8) !Dot {
    var iter = std.mem.split(u8, input, ",");
    const x = try std.fmt.parseInt(u32, iter.next().?, 10);
    const y = try std.fmt.parseInt(u32, iter.next().?, 10);
    return Dot{ .x = x, .y = y };
  }

  fn parseMany(mem: std.mem.Allocator, input: []const u8) ![]Dot {
    var dots = std.ArrayList(Dot).init(mem);
    errdefer dots.deinit();

    var lines = std.mem.split(u8, input, "\n");
    while (lines.next()) |line|
      try dots.append(try Dot.parse(line));
    return dots.toOwnedSlice();
  }
};

const Fold = union(enum) {
  x: u32,
  y: u32,

  fn parse(input: []const u8) !Fold {
    const eq = std.mem.indexOf(u8, input, "=").?;
    const num = try std.fmt.parseInt(u32, input[eq + 1..], 10);
    return switch (input[eq - 1]) {
      'x' => Fold{ .x = num },
      'y' => Fold{ .y = num },
      else => unreachable
    };
  }

  fn parseMany(mem: std.mem.Allocator, input: []const u8) ![]Fold {
    var folds = std.ArrayList(Fold).init(mem);
    errdefer folds.deinit();

    var lines = std.mem.split(u8, input, "\n");
    while (lines.next()) |line|
      try folds.append(try Fold.parse(line));
    return folds.toOwnedSlice();
  }

  fn fold(self: Fold, dot: *Dot) void {
    return switch (self) {
      .x => |at| dot.x = std.math.min(2*at - dot.x, dot.x),
      .y => |at| dot.y = std.math.min(2*at - dot.y, dot.y)
    };
  }

  fn foldMany(self: Fold, dots: []Dot) void {
    for (dots) |*dot| self.fold(dot);
  }
};

fn foldAndCountVisible(mem: std.mem.Allocator, folds: []Fold, dots: []Dot) !u32 {
  var visible = std.AutoHashMap(Dot, void).init(mem);
  defer visible.deinit();

  for (folds) |fold| fold.foldMany(dots);
  for (dots) |dot| try visible.put(dot, {});
  return visible.count();
}

fn foldAndPrintCode(folds: []Fold, dots: []Dot) void {
  for (folds) |fold| fold.foldMany(dots);

  std.debug.print("\x1b[s", .{});
  for (dots) |dot|
    std.debug.print("\x1b[u\x1b[{}B\x1b[{}C##", .{ 1 + dot.y, 1 + 2*dot.x });
  std.debug.print("\x1b[u\x1b[8B", .{});
}

pub fn solve(mem: std.mem.Allocator) !void {
  const input = try util.readFileAlloc(mem, ".input/day13");
  const trimmed = std.mem.trim(u8, input, "\n");
  var sections = std.mem.split(u8, trimmed, "\n\n");
  defer mem.free(input);

  const dots = try Dot.parseMany(mem, sections.next().?);
  defer mem.free(dots);

  const folds = try Fold.parseMany(mem, sections.next().?);
  defer mem.free(folds);

  const part1 = foldAndCountVisible(mem, folds[0..1], dots);
  const part2 = 0;

  // foldAndPrintCode(folds[1..], dots);

  std.debug.print("day13: {} {}\n", .{ part1, part2 });
}
