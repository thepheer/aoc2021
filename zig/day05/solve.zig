const std = @import("std");
const fp = @import("../fp.zig");
const math = @import("../math.zig");
const util = @import("../util.zig");

const Scalar = std.math.IntFittingRange(-1, 1000);

const Point = struct {
  x: Scalar,
  y: Scalar,

  fn parse(input: []const u8) !Point {
    var iter = std.mem.split(u8, input, ",");
    const x = try std.fmt.parseInt(Scalar, iter.next().?, 10);
    const y = try std.fmt.parseInt(Scalar, iter.next().?, 10);
    return Point{ .x = x, .y = y };
  }
};

const Vent = struct {
  a: Point,
  b: Point,

  fn parse(input: []const u8) !Vent {
    var iter = std.mem.split(u8, input, " -> ");
    const a = try Point.parse(iter.next().?);
    const b = try Point.parse(iter.next().?);
    return Vent{ .a = a, .b = b };
  }

  fn parseMany(mem: std.mem.Allocator, input: []const u8) ![]Vent {
    const lines = try util.splitLines(mem, input);
    defer mem.free(lines);

    return fp.map(mem, Vent.parse, lines);
  }
};

const OceanFloor = struct {
  const State = enum { empty, vent, overlap };

  mem: std.mem.Allocator,
  size: usize,
  grid: []State,
  overlaps: usize = 0,

  fn init(mem: std.mem.Allocator, size: usize) !OceanFloor {
    const grid = try mem.alloc(State, size * size);
    std.mem.set(State, grid, State.empty);
    return OceanFloor{ .mem = mem, .size = size, .grid = grid };
  }

  fn deinit(self: OceanFloor) void {
    self.mem.free(self.grid);
  }

  fn countOverlaps(self: *OceanFloor, vents: []const Vent, diagonals: bool) usize {
    for (vents) |vent| {
      const dx = vent.b.x - vent.a.x;
      const dy = vent.b.y - vent.a.y;

      const is_diagonal = dx != 0 and dy != 0;
      if (diagonals != is_diagonal)
        continue;

      const sx = math.signum(dx);
      const sy = math.signum(dy);
      const n = std.math.max(math.abs(dx), math.abs(dy));

      var i: Scalar = 0;
      while (i <= n) : (i += 1) {
        const x = @intCast(usize, vent.a.x + sx * i);
        const y = @intCast(usize, vent.a.y + sy * i);
        var state = &self.grid[self.size * y + x];

        if (state.* == .vent)
          self.overlaps += 1;

        state.* = switch (state.*) {
          .empty => .vent,
          .vent => .overlap,
          .overlap => .overlap
        };
      }
    }

    return self.overlaps;
  }
};

pub fn solve(mem: std.mem.Allocator) !void {
  const input = try util.readFileAlloc(mem, ".input/day05");
  defer mem.free(input);

  const vents = try Vent.parseMany(mem, input);
  defer mem.free(vents);

  var ocean_floor = try OceanFloor.init(mem, 1000);
  defer ocean_floor.deinit();

  const part1 = ocean_floor.countOverlaps(vents, false);
  const part2 = ocean_floor.countOverlaps(vents, true);

  std.debug.print("day05: {} {}\n", .{ part1, part2 });
}
