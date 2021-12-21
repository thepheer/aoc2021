package day19

import "core:slice"
import "core:mem"
import "core:math/linalg"

Heuristic :: struct { distance_to_neighbors: [1]int }

compute_heuristics :: proc(points: []Point) -> (heuristics: []Heuristic) {
  heuristics = make([]Heuristic, len(points))

  distances: [dynamic]int
  defer delete(distances)

  for point, i in points {
    clear(&distances)
    for neighbor in points {
      diff := point - neighbor
      dist := linalg.dot(diff, diff)
      append(&distances, dist)
    }
    slice.sort(distances[:])
    copy(heuristics[i].distance_to_neighbors[:], distances[1:2])
  }

  return
}

equal_heuristic :: proc(a: Heuristic, b: Heuristic) -> bool {
  return mem.simple_equal(a.distance_to_neighbors, b.distance_to_neighbors)
}
