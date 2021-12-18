const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn Unwrap(comptime T: type) type {
  return switch (@typeInfo(T)) {
    .ErrorUnion => |u| u.payload,
    else => T
  };
}

pub fn ReturnTypeOf(comptime F: anytype) type {
  return switch (@typeInfo(@TypeOf(F))) {
    .BoundFn, .Fn => |f| f.return_type.?,
    else => @compileError("expected function")
  };
}

pub fn ArgTypeOf(comptime F: anytype, arg: usize) type {
  return switch (@typeInfo(@TypeOf(F))) {
    .BoundFn, .Fn => |f| f.args[arg].arg_type.?,
    else => @compileError("expected function")
  };
}

pub fn map(mem: Allocator, comptime F: anytype, src: []ArgTypeOf(F, 0)) ![]Unwrap(ReturnTypeOf(F)) {
  const dst = try mem.alloc(Unwrap(ReturnTypeOf(F)), src.len);
  errdefer mem.free(dst);

  for (src) |item, i| {
    dst[i] = switch (@typeInfo(ReturnTypeOf(F))) {
      .ErrorUnion => try F(item),
      else => F(item)
    };
  }

  return dst;
}
