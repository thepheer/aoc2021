const std = @import("std");
const util = @import("../util.zig");

const Position = std.math.IntFittingRange(1, 10);

fn GameState(comptime Score: type) type {
  return struct {
    positions: [2]Position,
    scores: [2]Score = .{ 0, 0 },
    player: u1 = 0,

    fn next(self: GameState(Score), steps: u10) GameState(Score) {
      var next_state = self;
      var player = &next_state.player;
      var position = &next_state.positions[player.*];
      var score = &next_state.scores[player.*];
      position.* = @intCast(Position, (position.* + steps - 1) % 10 + 1);
      score.* += position.*;
      player.* = player.* +% 1;
      return next_state;
    }
  };
}

const DeterministicDice = struct {
  state: u10 = 1,

  fn throw(self: *DeterministicDice) u10 {
    const saved = self.state;
    self.state = self.state % 100 + 1;
    return saved;
  }

  fn playUntilSomeoneWins(positions: [2]Position) u64 {
    var die = DeterministicDice{};
    var state = GameState(u10){ .positions = positions };
    var throws: u32 = 0;
    while (std.math.max(state.scores[0], state.scores[1]) < 1000) : (throws += 3) {
      state = state.next(die.throw() + die.throw() + die.throw());
    }
    return throws * state.scores[state.player];
  }
};

const DiracDice = struct {
  const Wins = [2]u64;
  const Score = std.math.IntFittingRange(0, 21);
  const Cache = std.AutoHashMap(GameState(Score), Wins);

  fn addWins(acc: *Wins, wins: Wins, multiplier: usize) void {
    acc[0] += wins[0] * multiplier;
    acc[1] += wins[1] * multiplier;
  }

  fn dp(cache: *Cache, state: GameState(Score)) anyerror!Wins {
    if (cache.get(state)) |wins| return wins;
    if (state.scores[0] >= 21) return Wins{ 1, 0 };
    if (state.scores[1] >= 21) return Wins{ 0, 1 };

    var acc = Wins{ 0, 0 };
    addWins(&acc, try dp(cache, state.next(3)), 1);
    addWins(&acc, try dp(cache, state.next(4)), 3);
    addWins(&acc, try dp(cache, state.next(5)), 6);
    addWins(&acc, try dp(cache, state.next(6)), 7);
    addWins(&acc, try dp(cache, state.next(7)), 6);
    addWins(&acc, try dp(cache, state.next(8)), 3);
    addWins(&acc, try dp(cache, state.next(9)), 1);

    try cache.put(state, acc);
    return acc;
  }

  fn countWinningUniverses(mem: std.mem.Allocator, positions: [2]Position) !u64 {
    var cache = Cache.init(mem);
    defer cache.deinit();

    const wins = try dp(&cache, .{ .positions = positions });
    return std.math.max(wins[0], wins[1]);
  }
};

fn parseStartingPositions(input: []const u8) ![2]Position {
  var position: [2]Position = undefined;
  var lines = std.mem.split(u8, input, "\n");
  for (position) |*p| {
    const line = lines.next().?;
    const index = std.mem.indexOfScalar(u8, line, ':').?;
    p.* = try std.fmt.parseInt(Position, line[index + 2..], 10);
  }
  return position;
}

pub fn solve(mem: std.mem.Allocator) !void {
  const input = try util.readFileAlloc(mem, ".input/day21");
  defer mem.free(input);

  const positions = try parseStartingPositions(input);
  const part1 = DeterministicDice.playUntilSomeoneWins(positions);
  const part2 = try DiracDice.countWinningUniverses(mem, positions);

  std.debug.print("day21: {} {}\n", .{ part1, part2 });
}
