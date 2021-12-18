const std = @import("std");
const Board = @import("board.zig");
const Num = Board.Num;
const Self = @This();

nums: std.ArrayList(Num),
boards: std.ArrayList(Board),

pub fn parse(mem: std.mem.Allocator, input: []const u8) !Self {
  var parts = std.mem.split(u8, input, "\n\n");

  var nums_iter = std.mem.split(u8, parts.next().?, ",");
  var nums = std.ArrayList(Num).init(mem);
  errdefer nums.deinit();
  while (nums_iter.next()) |num|
    try nums.append(try std.fmt.parseUnsigned(Num, num, 10));

  var boards = std.ArrayList(Board).init(mem);
  errdefer boards.deinit();
  while (parts.next()) |part|
    try boards.append(try Board.parse(part));

  std.mem.reverse(Num, nums.items);
  return Self{ .nums = nums, .boards = boards };
}

pub fn deinit(self: Self) void {
  self.nums.deinit();
  self.boards.deinit();
}

pub fn part1(self: *Self) u32 {
  while (self.nums.popOrNull()) |drawn| {
    self.markInAllBoards(drawn);
    if (self.findWinner()) |winner|
      return @intCast(u32, drawn) * winner.sumUnmarked();
  }
  unreachable;
}

pub fn part2(self: *Self) u32 {
  while (self.nums.popOrNull()) |drawn| {
    self.markInAllBoards(drawn);
    switch (self.boards.items.len) {
      1 => if (self.boards.items[0].bingo()) {
        return @intCast(u32, drawn) * self.boards.items[0].sumUnmarked();
      },
      else => self.eliminateWinners()
    }
  }
  unreachable;
}

fn markInAllBoards(self: *Self, num: Num) void {
  for (self.boards.items) |*board|
    board.mark(num);
}

fn findWinner(self: Self) ?Board {
  for (self.boards.items) |board|
    if (board.bingo())
      return board;
  return null;
}

fn eliminateWinners(self: *Self) void {
  var index = self.boards.items.len;
  while (index > 0) {
    index -= 1;
    if (self.boards.items[index].bingo())
      _ = self.boards.swapRemove(index);
  }
}
