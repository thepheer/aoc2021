package day19

import "core:math/linalg"

Orientation :: struct { fwd, inv: matrix[3, 3]int }

orientations := get_all_orientations()

get_all_orientations :: proc() -> (orientations: [24]Orientation) {
  signs, o := [2]int{ -1, 1 }, 0
  for sign in signs do for xyz in 0..2 {
    x: Point; x[xyz] = sign
    for sign in signs do for xyz in 0..2 {
      y: Point; y[xyz] = sign
      z := linalg.cross(x, y)
      if linalg.dot(z, z) != 0 {
        orientations[o].fwd = { x.x, x.y, x.z, y.x, y.y, y.z, z.x, z.y, z.z }
        orientations[o].inv = { x.x, y.x, z.x, x.y, y.y, z.y, x.z, y.z, z.z }
        o += 1
      }
    }
  }
  return
}
