const std = @import("std");
const Move = @import("move.zig").Move;
const Self = @This();

h_pos: i32,
depth: i32,
aim: i32,

pub fn part1(moves: []Move) i32 {
  var self = std.mem.zeroes(Self);
  for (moves) |move| {
    switch (move) {
      .down => |n| self.depth += n,
      .forward => |n| self.h_pos += n,
    }
  }
  return self.h_pos * self.depth;
}

pub fn part2(moves: []Move) i32 {
  var self = std.mem.zeroes(Self);
  for (moves) |move| {
    switch (move) {
      .down => |n| self.aim += n,
      .forward => |n| {
        self.h_pos += n;
        self.depth += n * self.aim;
      }
    }
  }
  return self.h_pos * self.depth;
}
