const std = @import("std");
const util = @import("../util.zig");

const BITS = 12;
const Bits = u12;
const BitIndex = u4;

fn parseBitstrings(mem: std.mem.Allocator, input: []const u8) ![]Bits {
  var nums = std.ArrayList(Bits).init(mem);
  errdefer nums.deinit();

  var iter = std.mem.tokenize(u8, input, "\n");
  while (iter.next()) |line| {
    const n = try std.fmt.parseUnsigned(Bits, line, 2);
    try nums.append(n);
  }

  return nums.toOwnedSlice();
}

fn bitAt(bits: Bits, index: BitIndex) u1 {
  return @intCast(u1, bits >> (BITS - index - 1) & 1);
}

fn mostCommonBit(nums: []Bits, bit_index: BitIndex) u1 {
  var count: usize = 0;
  for (nums) |n| count += bitAt(n, bit_index);
  return @boolToInt(2 * count >= nums.len);
}

fn gammaEpsilon(nums: []Bits) [2]Bits {
  var gamma: Bits = 0;
  var bit_index: BitIndex = 0;
  while (bit_index < BITS) : (bit_index += 1) {
    gamma = gamma << 1 | mostCommonBit(nums, bit_index);
  }
  return .{ gamma, ~gamma };
}

fn findByCriterion(mem: std.mem.Allocator, nums: []Bits, by_most_common: bool) !Bits {
  var state = std.ArrayList(Bits).init(mem);
  defer state.deinit();

  try state.appendSlice(nums);

  var bit_index: BitIndex = 0;
  while (bit_index < BITS) : (bit_index += 1) {
    const most_common = mostCommonBit(state.items, bit_index);
    const bit = most_common ^ @boolToInt(by_most_common);

    var index = state.items.len;
    while (index > 0) {
      index -= 1;
      if (bitAt(state.items[index], bit_index) != bit)
        _ = state.swapRemove(index);
    }

    if (state.items.len == 1)
      return state.items[0];
  }

  unreachable;
}

pub fn solve(mem: std.mem.Allocator) !void {
  const input = try util.readFileAlloc(mem, ".input/day03");
  defer mem.free(input);

  const nums = try parseBitstrings(mem, input);
  defer mem.free(nums);

  const gamma_epsilon = gammaEpsilon(nums);
  const oxygen = try findByCriterion(mem, nums, true);
  const co2 = try findByCriterion(mem, nums, false);

  const part1 = @as(u32, gamma_epsilon[0]) * @as(u32, gamma_epsilon[1]);
  const part2 = @as(u32, oxygen) * @as(u32, co2);

  std.debug.print("day03: {} {}\n", .{ part1, part2 });
}
