import std/[strformat, strutils, sequtils]
import move

func part1(moves: openArray[Move]): int =
  var h_pos = 0
  var depth = 0
  for move in moves:
    case move.kind:
    of down: depth += move.down
    of forward: h_pos += move.forward
  h_pos * depth

func part2(moves: openArray[Move]): int =
  var h_pos = 0
  var depth = 0
  var aim = 0
  for move in moves:
    case move.kind:
    of down: aim += move.down
    of forward:
      h_pos += move.forward
      depth += move.forward * aim
  h_pos * depth

proc solve* =
  let moves = ".input/day02".readFile.strip.splitLines.map parseMove
  let part1 = moves.part1
  let part2 = moves.part2
  echo &"day02: {part1} {part2}"
