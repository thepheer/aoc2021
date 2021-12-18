const std = @import("std");

pub const Kind = enum {
  sum,
  product,
  minimum,
  maximum,
  greater_than,
  less_than,
  equal_to,

  pub fn fromId(id: u3) Kind {
    return switch (id) {
      0 => .sum,
      1 => .product,
      2 => .minimum,
      3 => .maximum,
      4 => unreachable, // literal
      5 => .greater_than,
      6 => .less_than,
      7 => .equal_to
    };
  }

  pub fn format(self: Kind, _: anytype, _: anytype, writer: anytype) !void {
    return switch (self) {
      .sum => writer.writeByte('+'),
      .product => writer.writeAll("×"),
      .minimum => writer.writeAll("min"),
      .maximum => writer.writeAll("max"),
      .greater_than => writer.writeByte('>'),
      .less_than => writer.writeByte('<'),
      .equal_to => writer.writeByte('='),
    };
  }
};
