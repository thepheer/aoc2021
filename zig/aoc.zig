const builtin = @import("builtin");
const std = @import("std");

fn solveAll(mem: std.mem.Allocator) !void {
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
  try @import("day21/solve.zig").solve(mem);
}

pub fn main() !void {
  if (builtin.mode == .Debug or builtin.link_libc == false) {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    try solveAll(gpa.allocator());
  }
  else {
    try solveAll(std.heap.c_allocator);
  }
}
