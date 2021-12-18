module day02
  abstract type Move end
  struct Forward <: Move; n::Int; end
  struct Down <: Move; n::Int; end

  function parse_move(input::String)::Move
    cmd, num = split(input, " ")
    num = parse(Int, num)
    cmd == "up" && return Down(-num)
    cmd == "down" && return Down(num)
    cmd == "forward" && return Forward(num)
  end

  mutable struct Submarine
    h_pos::Int
    depth::Int
    aim::Int
    Submarine() = new(0, 0, 0)
  end

  function solve_part1(state::Submarine, moves::AbstractArray{Move})::Int
    for move in moves
      if move isa Down
        state.depth += move.n
      elseif move isa Forward
        state.h_pos += move.n
      end
    end
    state.h_pos * state.depth
  end

  function solve_part2(state::Submarine, moves::AbstractArray{Move})::Int
    for move in moves
      if move isa Down
        state.aim += move.n
      elseif move isa Forward
        state.h_pos += move.n
        state.depth += move.n * state.aim
      end
    end
    state.h_pos * state.depth
  end

  function solve()::Nothing
    moves = parse_move.(eachline(".input/day02"))

    part1 = solve_part1(Submarine(), moves)
    part2 = solve_part2(Submarine(), moves)

    println("day02: $part1 $part2")
  end
end
