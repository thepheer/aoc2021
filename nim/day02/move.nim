import std/strscans

type
  Move* = ref MoveObj
  MoveKind* = enum forward, down
  MoveObj* = object
    case kind*: MoveKind
    of down: down*: int
    of forward: forward*: int

func parseMove*(input: string): Move =
  let (_, cmd, value) = input.scanTuple("$+ $i")
  case cmd
  of "up": Move(kind: down, down: -value)
  of "down": Move(kind: down, down: value)
  of "forward": Move(kind: forward, forward: value)
  else: nil
