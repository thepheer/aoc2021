const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn readFileAlloc(mem: Allocator, path: []const u8) ![]u8 {
  return std.fs.cwd().readFileAlloc(mem, path, std.math.maxInt(usize));
}

pub fn splitLines(mem: Allocator, input: []const u8) ![][]const u8 {
  var lines = std.ArrayList([]const u8).init(mem);
  errdefer lines.deinit();

  const trimmed = std.mem.trim(u8, input, "\n");
  var iter = std.mem.split(u8, trimmed, "\n");
  while (iter.next()) |line|
    try lines.append(line);

  return lines.toOwnedSlice();
}

pub fn parseNumsAlloc(mem: Allocator, comptime T: type, input: []const u8, delim: []const u8) ![]T {
  var nums = std.ArrayList(T).init(mem);
  errdefer nums.deinit();

  var iter = std.mem.tokenize(u8, input, delim);
  while (iter.next()) |n|
    try nums.append(try parseNum(T, n));

  return nums.toOwnedSlice();
}

pub fn parseNum(comptime T: type, input: []const u8) !T {
  return switch (@typeInfo(T)) {
    .Float => std.fmt.parseFloat(T, input),
    .Int => |int| switch (int.signedness) {
      .signed => std.fmt.parseInt(T, input, 10),
      .unsigned => std.fmt.parseUnsigned(T, input, 10),
    },
    else => @compileError("unsupported type: " ++ @typeName(T))
  };
}
