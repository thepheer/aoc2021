package day09

import "core:fmt"
import "core:os"
import "core:slice"
import "core:bytes"

MAX_HEIGHT: Height = 9

Height :: u8

Vec2 :: [2]int

neighbors :: proc(at: Vec2) -> [4]Vec2 {
  x, y := Vec2{1, 0}, Vec2{0, 1}
  return {at + x, at - x, at + y, at - y}
}

Height_Map :: struct {
  grid: []Height,
  size: Vec2,
}

init :: proc(input: []u8) -> Height_Map {
  lines := bytes.fields(input)
  defer delete(lines)

  width := len(lines[0])
  height := len(lines)
  size := Vec2{width + 2, height + 2}

  padding := make([]Height, size.x)
  slice.fill(padding[:], MAX_HEIGHT)
  defer delete(padding)

  grid := make([dynamic]Height, 0, size.x * size.y)
  append(&grid, ..padding[:])
  for line in lines {
    append(&grid, MAX_HEIGHT)
    for char in line {
      append(&grid, char - '0')
    }
    append(&grid, MAX_HEIGHT)
  }
  append(&grid, ..padding[:])

  return {grid[:], size}
}

deinit :: proc(hm: ^Height_Map) {
  delete(hm.grid)
}

index_at :: proc(hm: ^Height_Map, at: Vec2) -> int {
  return hm.size.x * at.y + at.x
}

height_at :: proc(hm: ^Height_Map, at: Vec2) -> Height {
  return hm.grid[index_at(hm, at)]
}

set_height_at :: proc(hm: ^Height_Map, at: Vec2, height: Height) {
  hm.grid[index_at(hm, at)] = height
}

is_low_point_at :: proc(hm: ^Height_Map, at: Vec2) -> bool {
  min_height := MAX_HEIGHT
  for n in neighbors(at) {
    min_height = min(min_height, height_at(hm, n))
  }
  return height_at(hm, at) < min_height
}

basin_size_at :: proc(hm: ^Height_Map, at: Vec2) -> int {
  if height_at(hm, at) == MAX_HEIGHT {
    return 0
  }

  stack := [dynamic]Vec2{at}
  defer delete(stack)

  size := 0
  for len(stack) > 0 {
    vec := pop(&stack)
    if height_at(hm, vec) != MAX_HEIGHT {
      size += 1
      set_height_at(hm, vec, MAX_HEIGHT)
      ns := neighbors(vec)
      append(&stack, ..ns[:])
    }
  }
  return size
}

low_points_risk_level_sum :: proc(hm: ^Height_Map) -> int {
  sum := 0
  for y in 1 ..< hm.size.y - 1 {
    for x in 1 ..< hm.size.x - 1 {
      if is_low_point_at(hm, Vec2{x, y}) {
        sum += int(height_at(hm, Vec2{x, y})) + 1
      }
    }
  }
  return sum
}

n_largest_basins_size_product :: proc(hm: ^Height_Map, n: int) -> int {
  sizes := make([dynamic]int)
  defer delete(sizes)

  for y in 1 ..< hm.size.y - 1 {
    for x in 1 ..< hm.size.x - 1 {
      if size := basin_size_at(hm, Vec2{x, y}); size > 0 {
        append(&sizes, size)
      }
    }
  }

  slice.reverse_sort(sizes[:])

  product := 1
  for size in sizes[:n] {
    product *= size
  }
  return product
}

display :: proc(hm: ^Height_Map) {
  for y in 0 ..< hm.size.y {
    for x in 0 ..< hm.size.x {
      fmt.print(height_at(hm, Vec2{x, y}))
    }
    fmt.println()
  }
}

solve :: proc() -> (ok: bool) {
  input := os.read_entire_file(".input/day09") or_return
  defer delete(input)

  height_map := init(input)
  defer deinit(&height_map)

  part1 := low_points_risk_level_sum(&height_map)
  part2 := n_largest_basins_size_product(&height_map, 3)

  fmt.println("day09:", part1, part2)
  return true
}
