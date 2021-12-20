const std = @import("std");
const util = @import("../util.zig");
const BitSet = std.bit_set.DynamicBitSet;

const vec2 = Vec2.new;
const Vec2 = struct {
  x: i16,
  y: i16,

  const window3x3 = [9]Vec2{
    new(-1, -1), new( 0, -1), new( 1, -1),
    new(-1,  0), new( 0,  0), new( 1,  0),
    new(-1,  1), new( 0,  1), new( 1,  1),
  };

  fn new(x: i16, y: i16) Vec2 {
    return .{ .x = x, .y = y };
  }

  fn add(a: Vec2, b: Vec2) Vec2 {
    return new(a.x + b.x, a.y + b.y);
  }
};

const BitSet2D = struct {
  bits: BitSet,
  size: Vec2,
  fill: bool = false,

  fn parse(mem: std.mem.Allocator, input: []const u8) !BitSet2D {
    const width = std.mem.indexOf(u8, input, "\n").?;
    const height = std.mem.count(u8, input, "\n") + 1;

    var bits = try BitSet.initEmpty(mem, width * height);
    errdefer bits.deinit();

    var bit_index: usize = 0;
    for (input) |char| if (char != '\n') {
      bits.setValue(bit_index, char == '#');
      bit_index += 1;
    };

    const size = vec2(@intCast(i16, width), @intCast(i16, height));
    return BitSet2D{ .bits = bits, .size = size };
  }

  fn next(self: *BitSet2D, extend: Vec2) !BitSet2D {
    const new_size = self.size.add(extend);
    return init(self.bits.allocator, new_size, !self.fill);
  }

  fn init(mem: std.mem.Allocator, size: Vec2, fill: bool) !BitSet2D {
    const BitSet_init = if (fill) BitSet.initEmpty else BitSet.initEmpty;
    const bits = try BitSet_init(mem, @intCast(usize, size.x) * @intCast(usize, size.y));
    return BitSet2D{ .bits = bits, .size = size, .fill = fill };
  }

  fn deinit(self: *BitSet2D) void {
    self.bits.deinit();
  }

  fn inBounds(self: *const BitSet2D, at: Vec2) bool {
    const x = 0 <= at.x and at.x < self.size.x;
    const y = 0 <= at.y and at.y < self.size.y;
    return x and y;
  }

  fn index(self: *const BitSet2D, at: Vec2) usize {
    return @intCast(usize, self.size.x) * @intCast(usize, at.y) + @intCast(usize, at.x);
  }

  fn get(self: *const BitSet2D, at: Vec2) bool {
    if (self.inBounds(at))
      return self.bits.isSet(self.index(at));
    return self.fill;
  }

  fn set(self: *BitSet2D, at: Vec2, value: bool) void {
    self.bits.setValue(self.index(at), value);
  }
};

const TrenchMap = struct {
  rules: BitSet,
  grid: BitSet2D,

  fn parse(mem: std.mem.Allocator, input: []const u8) !TrenchMap {
    var sections = std.mem.split(u8, input, "\n\n");

    var rules = try std.bit_set.DynamicBitSet.initEmpty(mem, 1 << 9);
    errdefer rules.deinit();

    for (sections.next().?) |char, i|
      rules.setValue(i, char == '#');

    const grid = try BitSet2D.parse(mem, sections.next().?);
    return TrenchMap{ .rules = rules, .grid = grid };
  }

  fn deinit(self: *TrenchMap) void {
    self.rules.deinit();
    self.grid.deinit();
  }

  fn step(self: *TrenchMap) !void {
    var next = try self.grid.next(vec2(2, 2));
    defer next.deinit();

    var y: i16 = 0;
    while (y < next.size.y) : (y += 1) {
      var x: i16 = 0;
      while (x < next.size.x) : (x += 1) {
        var rule: u9 = 0;
        const dst = vec2(x, y);
        const src = vec2(-1, -1).add(dst);
        for (Vec2.window3x3) |offset| {
          const bit = self.grid.get(src.add(offset));
          rule = rule << 1 | @boolToInt(bit);
        }
        next.set(dst, self.rules.isSet(rule));
      }
    }

    std.mem.swap(BitSet2D, &self.grid, &next);
  }

  fn makeNStepsAndCountLit(self: *TrenchMap, n: usize) !usize {
    var i: usize = 0;
    while (i < n) : (i += 1) try self.step();
    return self.grid.bits.count();
  }
};

pub fn solve(mem: std.mem.Allocator) !void {
  const input = try util.readFileAlloc(mem, ".input/day20");
  const trimmed = std.mem.trim(u8, input, "\n");
  defer mem.free(input);

  var map = try TrenchMap.parse(mem, trimmed);
  defer map.deinit();

  const part1 = try map.makeNStepsAndCountLit(2);
  const part2 = try map.makeNStepsAndCountLit(50 - 2);

  std.debug.print("day20: {} {}\n", .{ part1, part2 });
}
