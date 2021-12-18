const std = @import("std");
const math = @import("../math.zig");
const util = @import("../util.zig");

const N = u32;

const FuelCost = struct {
  fn part1(n: N) N { return n; }
  fn part2(n: N) N { return n * (n + 1) / 2; }
};

const Optimizer = struct {
  const CostFn = fn (n: N) N;

  nums: []const N,
  min: N,
  max: N,

  fn init(nums: []const N) Optimizer {
    const asc = comptime std.sort.asc(N);
    const min = std.sort.min(N, nums, {}, asc).?;
    const max = std.sort.max(N, nums, {}, asc).?;
    return .{ .nums = nums, .min = min, .max = max };
  }

  fn totalCost(self: Optimizer, comptime costFn: CostFn, target: N) N {
    var cost: N = 0;
    for (self.nums) |n|
      cost += costFn(math.abs_diff(n, target));
    return cost;
  }

  fn optimizeFor(self: Optimizer, comptime costFn: CostFn) N {
    var lo: N = self.min;
    var hi: N = self.max;
    while (true) {
      const mid = lo + (hi - lo) / 2;
      const n = self.totalCost(costFn, mid);
      const m = self.totalCost(costFn, mid + 1);
      if (n > m) lo = mid + 1 else hi = mid;
      if (lo == hi) return std.math.min(n, m);
    }
  }
};

pub fn solve(mem: std.mem.Allocator) !void {
  const input = try util.readFileAlloc(mem, ".input/day07");
  defer mem.free(input);

  const trimmed = std.mem.trim(u8, input, "\n");
  const positions = try util.parseNumsAlloc(mem, N, trimmed, ",");
  defer mem.free(positions);

  const optimizer = Optimizer.init(positions);
  const part1 = optimizer.optimizeFor(FuelCost.part1);
  const part2 = optimizer.optimizeFor(FuelCost.part2);

  std.debug.print("day07: {} {}\n", .{ part1, part2 });
}
