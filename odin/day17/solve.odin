package day17

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

Vector :: [2]int
Point :: [2]int
Entity :: struct { pos: Point, vel: Vector }
Range :: struct { min, max: int }
Area :: struct { x, y: Range }

parse_area :: proc(input: string) -> (area: Area, ok: bool) {
  trimmed := strings.trim_space(input)
  tokens := strings.split_multi(trimmed, { ".", ",", "=" }, true)
  defer delete(tokens)

  area.x.min = strconv.parse_int(tokens[1]) or_return
  area.x.max = strconv.parse_int(tokens[2]) or_return
  area.y.min = strconv.parse_int(tokens[4]) or_return
  area.y.max = strconv.parse_int(tokens[5]) or_return
  return area, true
}

within_range :: proc(range: Range, n: int) -> bool {
  return range.min <= n && n <= range.max
}

within_area :: proc(area: Area, point: Point) -> bool {
  return within_range(area.x, point.x) && within_range(area.y, point.y)
}

missed :: proc(area: Area, point: Point) -> bool {
  return point.x > area.x.max || point.y < area.y.min
}

signum :: proc(n: $N) -> N {
  return N(0 < n) - N(n < 0)
}

solve :: proc() -> (ok: bool) {
  input := os.read_entire_file(".input/day17") or_return
  defer delete(input)

  target := parse_area(string(input)) or_return

  global_best := 0
  target_hits := 0

  for y in -100..100 {
    for x in 1..1000 {
      probe := Entity{ 0, { x, y } }
      local_best := 0

      for !missed(target, probe.pos) {
        probe.pos += probe.vel
        probe.vel -= { signum(probe.vel.x), 1 }
        local_best = max(local_best, probe.pos.y)

        if within_area(target, probe.pos) {
          global_best = max(global_best, local_best)
          target_hits += 1
          break
        }
      }
    }
  }

  part1 := global_best
  part2 := target_hits

  fmt.println("day17:", part1, part2)
  return true
}
