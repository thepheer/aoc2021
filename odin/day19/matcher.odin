package day19

import "core:mem"
import "core:slice"

MATCH_THRESHOLD :: 3

Matcher :: struct {
  known_scanners: [dynamic]Point,
  known_points: [dynamic]Point,
  known_heuristics: [dynamic]Heuristic,
}

delete_matcher :: proc(self: Matcher) {
  delete(self.known_scanners)
  delete(self.known_points)
  delete(self.known_heuristics)
}

match_all :: proc(self: ^Matcher, scanners: []Scanner) {
  unknown_scanners: [dynamic]Scanner
  append(&unknown_scanners, ..scanners[1:])
  defer delete(unknown_scanners)

  append(&self.known_scanners, Point{ 0, 0, 0 })
  append(&self.known_points, ..scanners[0].points)
  append(&self.known_heuristics, ..scanners[0].heuristics)

  known_points_subset: [dynamic]Point
  unknown_points_subset: [dynamic]Point
  defer delete(known_points_subset)
  defer delete(unknown_points_subset)

  for len(unknown_scanners) > 0 {
    for i := len(unknown_scanners); i > 0; i -= 1 {
      unknown := unknown_scanners[i - 1]

      clear(&known_points_subset)
      clear(&unknown_points_subset)
      for k, ki in self.known_heuristics {
        for u, ui in unknown.heuristics {
          if equal_heuristic(k, u) {
            append(&known_points_subset, self.known_points[ki])
            append(&unknown_points_subset, unknown.points[ui])
          }
        }
      }

      if len(known_points_subset) > 0 {
        if rotation, translation, ok := match_points(known_points_subset[:], unknown_points_subset[:]); ok {
          merge_scanner(self, unknown, rotation, translation)
          unordered_remove(&unknown_scanners, i - 1)
        }
      }
    }
  }
}

merge_scanner :: proc(self: ^Matcher, scanner: Scanner, r: Rotation, t: Translation) {
  for i in 0..<len(scanner.points) {
    point := t + r * scanner.points[i]
    if _, found := slice.linear_search(self.known_points[:], point); !found {
      append(&self.known_points, point)
      append(&self.known_heuristics, scanner.heuristics[i])
    }
  }
  append(&self.known_scanners, t)
}

match_points :: proc(known: []Point, unknown: []Point) -> (Rotation, Translation, bool) {
  for rotation in ROTATIONS {
    count := 0
    for k in 0..<len(known) {
      translation1 := known[k] - rotation * unknown[k]
      for u in k + 1..<len(unknown) {
        translation2 := known[u] - rotation * unknown[u]
        count += int(mem.simple_equal(translation1, translation2))
        if count >= MATCH_THRESHOLD {
          return rotation, translation1, true
        }
      }
    }
  }
  return {}, {}, false
}
