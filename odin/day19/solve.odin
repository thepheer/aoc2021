package day19

import "core:fmt"
import "core:mem"
import "core:slice"
import "core:os"
import "../helpers"

find_rotation_and_translation :: proc(known: []Point, unknown: []Point) -> (Rotation, Point, bool) {
  for rot in rotations {
    count := 0
    for k in 0..<len(known) {
      for u in k + 1..<len(unknown) {
        tr1 := known[k] - rot * unknown[k]
        tr2 := known[u] - rot * unknown[u]
        if mem.simple_equal(tr1, tr2) do count += 1
        if count > 1 do return rot, tr1, true
      }
    }
  }
  return {}, {}, false
}

solve :: proc() -> (ok: bool) {
  input := os.read_entire_file(".input/day19") or_return
  defer delete(input)

  scanners := parse_scanners(string(input)) or_return
  unmatched := helpers.slice_into_dynamic(scanners)
  defer destroy_scanners(unmatched[:])

  first := unmatched[0]; unordered_remove(&unmatched, 0)
  known_points := helpers.slice_into_dynamic(first.points)
  known_heuristics := helpers.slice_into_dynamic(first.heuristics)
  defer delete(known_points)
  defer delete(known_heuristics)

  known_subset: [dynamic]Point
  unknown_subset: [dynamic]Point
  defer delete(known_subset)
  defer delete(unknown_subset)

  for len(unmatched) > 0 {
    for i := len(unmatched); i > 0; i -= 1 {
      unknown := unmatched[i - 1]

      clear(&known_subset)
      clear(&unknown_subset)
      for k, ki in known_heuristics {
        for u, ui in unknown.heuristics {
          if equal_heuristic(k, u) {
            append(&known_subset, known_points[ki])
            append(&unknown_subset, unknown.points[ui])
          }
        }
      }

      if len(known_subset) > 0 {
        if rot, tr, ok := find_rotation_and_translation(known_subset[:], unknown_subset[:]); ok {
          for i in 0..<len(unknown.points) {
            point := tr + rot * unknown.points[i]
            if _, found := slice.linear_search(known_points[:], point); !found {
              append(&known_points, point)
              append(&known_heuristics, unknown.heuristics[i])
            }
          }

          destroy_scanner(unknown)
          unordered_remove(&unmatched, i - 1)
        }
      }
    }
  }

  fmt.println("day19:", len(known_points), 0)
  return true
}
