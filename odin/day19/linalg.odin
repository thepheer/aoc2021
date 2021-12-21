package day19

import "core:container"
import "core:intrinsics"
import "core:math/linalg"

Point :: [3]int
Direction :: [3]int
Translation :: [3]int
Rotation :: matrix[3, 3]int

DIRECTIONS := directions()
ROTATIONS := rotations()

directions :: proc() -> [6]Direction {
  k := Point{ -1, 0, 1 }
  return { k.zyy, k.yzy, k.yyz, k.xyy, k.yxy, k.yyx }
}

rotations :: proc() -> [24]Rotation {
  acc: container.Small_Array(24, Rotation)
  for x in DIRECTIONS {
    for y in DIRECTIONS {
      z := linalg.cross(x, y)
      if linalg.dot(z, z) != 0 {
        r := Rotation{ x.x, x.y, x.z, y.x, y.y, y.z, z.x, z.y, z.z }
        container.small_array_push_back(&acc, r)
      }
    }
  }
  return acc.data
}

max_manhattan :: proc(points: []Point) -> int {
  acc := 0
  for a, i in points {
    for b in points[i + 1:] {
      diff := linalg.abs(a - b)
      acc = max(acc, diff.x + diff.y + diff.z)
    }
  }
  return acc
}
