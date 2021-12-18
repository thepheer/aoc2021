const std = @import("std");
const util = @import("../util.zig");

const FreqAnalyzer = struct {
  freq: [7]u4,

  fn analyze(signals: []const u8) FreqAnalyzer {
    var self = std.mem.zeroes(FreqAnalyzer);
    for (signals) |segment| {
      if ('a' <= segment and segment <= 'g')
        self.freq[segment - 'a'] += 1;
    }
    return self;
  }

  fn sum(self: FreqAnalyzer, signal: []const u8) u6 {
    var acc: u6 = 0;
    for (signal) |segment|
      acc += self.freq[segment - 'a'];
    return acc;
  }
};

const Solver = struct {
  const Result = struct { number: u64, digits: [10]u4 };

  sum_to_digit: [50]u4,

  fn init(signals: []const u8, digits: [10]u4) Solver {
    const fa = FreqAnalyzer.analyze(signals);
    var iter = std.mem.split(u8, signals, " ");
    var self: Solver = undefined;
    for (digits) |digit|
      self.sum_to_digit[fa.sum(iter.next().?)] = digit;
    return self;
  }

  fn solve(self: Solver, key: []const u8, input: []const u8) Result {
    const fa = FreqAnalyzer.analyze(key);
    var res = std.mem.zeroes(Result);
    var iter = std.mem.split(u8, input, " ");
    while (iter.next()) |signal| {
      const digit = self.sum_to_digit[fa.sum(signal)];
      res.number = 10*res.number + digit;
      res.digits[digit] += 1;
    }
    return res;
  }
};

const solver = scope: {
  // an example of correct mapping from the problem description
  const signals = "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab";
  const digits = .{ 8, 5, 2, 3, 7, 9, 6, 4, 0, 1 };
  break :scope Solver.init(signals, digits);
};

pub fn solve(mem: std.mem.Allocator) !void {
  const input = try util.readFileAlloc(mem, ".input/day08");
  defer mem.free(input);

  const trimmed = std.mem.trim(u8, input, "\n");
  var lines = std.mem.split(u8, trimmed, "\n");

  var part1: u64 = 0;
  var part2: u64 = 0;

  while (lines.next()) |line| {
    var signals = std.mem.split(u8, line, " | ");
    const first10 = signals.next().?;
    const last4 = signals.next().?;

    const r = solver.solve(first10, last4);
    part1 += r.digits[1] + r.digits[4] + r.digits[7] + r.digits[8];
    part2 += r.number;
  }

  std.debug.print("day08: {} {}\n", .{ part1, part2 });
}
