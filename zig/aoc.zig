const std = @import("std");

pub fn main() !void {
  var gpa = std.heap.GeneralPurposeAllocator(.{}){};
  defer _ = gpa.deinit();

  const mem = gpa.allocator();
  try @import("day01/solve.zig").solve(mem);
  try @import("day02/solve.zig").solve(mem);
  try @import("day03/solve.zig").solve(mem);
  try @import("day04/solve.zig").solve(mem);
  try @import("day05/solve.zig").solve(mem);
  try @import("day06/solve.zig").solve(mem);
  try @import("day07/solve.zig").solve(mem);
  try @import("day08/solve.zig").solve(mem);
  try @import("day09/solve.zig").solve(mem);
  try @import("day11/solve.zig").solve(mem);
  try @import("day12/solve.zig").solve(mem);
  try @import("day13/solve.zig").solve(mem);
  try @import("day16/solve.zig").solve(mem);
  try @import("day20/solve.zig").solve(mem);
}
