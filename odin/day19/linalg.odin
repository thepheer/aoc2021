package day19

import "core:container"
import "core:math/linalg"

Point :: [3]int
Direction :: [3]int
Rotation :: matrix[3, 3]int

directions := get_directions()
rotations := get_rotations()

get_directions :: proc() -> [6]Direction {
  k := Direction{ -1, 0, 1 }
  return { k.zyy, k.yzy, k.yyz, k.xyy, k.yxy, k.yyx }
}

get_rotations :: proc() -> [24]Rotation {
  acc: container.Small_Array(24, Rotation)
  for x in directions {
    for y in directions {
      z := linalg.cross(x, y)
      if linalg.dot(z, z) != 0 {
        r := Rotation{ x.x, x.y, x.z, y.x, y.y, y.z, z.x, z.y, z.z }
        container.small_array_push_back(&acc, r)
      }
    }
  }
  return acc.data
}
