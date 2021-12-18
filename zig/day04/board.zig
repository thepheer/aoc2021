const std = @import("std");
const util = @import("../util.zig");
const Self = @This();

pub const Num = std.math.IntFittingRange(0, 99);
const Mask = std.meta.Int(.unsigned, SIZE * SIZE);
const Shift = std.meta.Int(.unsigned, SIZE);

const SIZE = 5;
const ROW_MASK: Mask = 0b00000_00000_00000_00000_11111;
const COL_MASK: Mask = 0b00001_00001_00001_00001_00001;

matrix: [SIZE * SIZE]Num,
marked: Mask,

pub fn parse(input: []const u8) !Self {
  var self = std.mem.zeroes(Self);
  var nums = std.mem.tokenize(u8, input, " \n\r");
  var i: usize = 0;
  while (nums.next()) |num| : (i += 1)
    self.matrix[i] = try std.fmt.parseUnsigned(Num, num, 10);
  return self;
}

pub fn mark(self: *Self, num: Num) void {
  for (self.matrix) |n, i| if (n == num) {
    self.marked |= @as(Mask, 1) << @intCast(Shift, i);
    return;
  };
}

pub fn sumUnmarked(self: Self) u32 {
  var sum: u32 = 0;
  for (self.matrix) |n, i| {
    if (self.marked & @as(Mask, 1) << @intCast(Shift, i) == 0)
      sum += n;
  }
  return sum;
}

pub fn bingo(self: Self) bool {
  var i: Shift = 0;
  while (i < SIZE) : (i += 1) {
    const row = ROW_MASK << i * SIZE;
    const col = COL_MASK << i;
    if (self.marked & row == row or self.marked & col == col)
      return true;
  }
  return false;
}
