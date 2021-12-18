const std = @import("std");

pub fn abs(x: anytype) @TypeOf(x) {
  return if (x < 0) -x else x;
}

pub fn abs_diff(a: anytype, b: anytype) @TypeOf(a, b) {
  return if (a < b) b - a else a - b;
}

pub fn signum(n: anytype) @TypeOf(n) {
  const gt = @intCast(@TypeOf(n), @boolToInt(0 < n));
  const lt = @intCast(@TypeOf(n), @boolToInt(n < 0));
  return gt - lt;
}
