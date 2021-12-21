package day19

import "core:math/linalg"

Heuristic :: int // closest neighbor distance

compute_heuristics :: proc(points: []Point) -> []Heuristic {
  heuristics := make([]Heuristic, len(points))
  for point, p in points {
    min_dist := max(int)
    for neighbor, n in points {
      if p != n {
        diff := point - neighbor
        dist := linalg.dot(diff, diff)
        min_dist = min(min_dist, dist)
      }
    }
    heuristics[p] = min_dist
  }
  return heuristics
}

equal_heuristic :: proc(a: Heuristic, b: Heuristic) -> bool {
  return a == b
}
