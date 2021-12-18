const std = @import("std");
const Self = @This();

bytes: []const u8,
cursor: usize = 0,

pub fn fromHex(mem: std.mem.Allocator, hex: []const u8) !Self {
  var bytes = try mem.alloc(u8, hex.len / 2);
  errdefer mem.free(bytes);

  return Self{ .bytes = try std.fmt.hexToBytes(bytes, hex) };
}

pub fn deinit(self: *const Self, mem: std.mem.Allocator) void {
  mem.free(self.bytes);
}

pub fn remaining(self: *const Self) usize {
  return 8 * self.bytes.len - self.cursor;
}

pub fn readBit(self: *Self) u1 {
  const idx = self.cursor / 8;
  const shr = @truncate(u3, 7 - self.cursor % 8);
  const bit = @truncate(u1, self.bytes[idx] >> shr);
  self.cursor += 1;
  return bit;
}

pub fn read(self: *Self, comptime T: type) T {
  var acc: T = 0;
  var bits: u16 = @typeInfo(T).Int.bits;
  while (!@subWithOverflow(u16, bits, 1, &bits))
    acc = acc << 1 | self.readBit();
  return acc;
}
