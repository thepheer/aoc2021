const std = @import("std");
const BitBuffer = @import("BitBuffer.zig");
const Kind = @import("PacketKind.zig").Kind;
const Self = @This();

pub const Operator = struct { kind: Kind, packets: []Self };
pub const Data = union(enum) { literal: u64, operator: Operator };

version: u3,
data: Data,

pub fn deinit(self: *const Self, mem: std.mem.Allocator) void {
  switch (self.data) {
    .operator => |op| {
      for (op.packets) |p| p.deinit(mem);
      mem.free(op.packets);
    },
    else => {}
  }
}

pub fn read(mem: std.mem.Allocator, buffer: *BitBuffer) !Self {
  if (buffer.remaining() < 8)
    @panic("unexpected bruh moment");

  const version = buffer.read(u3);
  const id = buffer.read(u3);
  const data = switch (id) {
    4 => readLiteral(buffer),
    else => try readOperator(mem, buffer, id),
  };
  return Self{ .version = version, .data = data };
}

fn readOperator(mem: std.mem.Allocator, buffer: *BitBuffer, id: u3) std.mem.Allocator.Error!Data {
  var packets = std.ArrayList(Self).init(mem);
  errdefer packets.deinit();

  switch (buffer.readBit()) {
    0 => {
      const len = buffer.read(u15);
      const end = buffer.cursor + len;
      while (buffer.cursor < end)
        try packets.append(try read(mem, buffer));
    },
    1 => {
      var n = buffer.read(u11);
      while (!@subWithOverflow(u11, n, 1, &n))
        try packets.append(try read(mem, buffer));
    },
  }

  const kind = Kind.fromId(id);
  const slice = packets.toOwnedSlice();
  return Data{ .operator = .{ .kind = kind, .packets = slice } };
}

fn readLiteral(buffer: *BitBuffer) Data {
  var acc: u64 = 0;
  while (true) {
    const last = buffer.readBit() == 0;
    const data = buffer.read(u4);
    acc = acc << 4 | data;
    if (last) break;
  }
  return .{ .literal = acc };
}

//

pub fn format(root: *const Self, _: anytype, _: anytype, writer: anytype) !void {
  return root.tree(writer);
}

pub fn tree(root: *const Self, writer: anytype) !void {
  var indent = std.BoundedArray(u8, 0x100).init(0) catch unreachable;
  return root.treeVisit(writer, &indent);
}

pub fn print(root: *const Self, writer: anytype) !void {
  return root.printVisit(writer, 0);
}

fn treeVisit(root: *const Self, writer: anytype, indent: *std.BoundedArray(u8, 0x100)) std.os.WriteError!void {
  switch (root.data) {
    .literal => |lit| try writer.print("{}\n", .{ lit }),
    .operator => |op| {
      try writer.print("{}\n", .{ op.kind });
      for (op.packets) |*packet, i| {
        const last = op.packets.len - i == 1;
        const outer = if (last) "  " else "│ ";
        const inner = if (last) "└╴" else "├╴";
        try writer.print("{s}{s}", .{ indent.slice(), inner });
        indent.appendSlice(outer) catch unreachable;
        try packet.treeVisit(writer, indent);
        indent.resize(indent.len - outer.len) catch unreachable;
      }
    }
  }
}

fn printVisit(root: *const Self, writer: anytype, indent: usize) std.os.WriteError!void {
  try writer.print("{s: >[1]}Packet {{\n", .{ "", indent });
  try writer.print("{s: >[1]}version: {2}\n", .{ "", indent + 2, root.version });
  switch (root.data) {
    .literal => |lit| {
      try writer.print("{s: >[1]}literal: {2}\n", .{ "", indent + 2, lit });
    },
    .operator => |op| {
      try writer.print("{s: >[1]}operator({2}): [\n", .{ "", indent + 2, op.kind });
      for (op.packets) |*packet|
        try packet.printVisit(writer, indent + 4);
      try writer.print("{s: >[1]}]\n", .{ "", indent + 2 });
    }
  }
  try writer.print("{s: >[1]}}}\n", .{ "", indent });
}
