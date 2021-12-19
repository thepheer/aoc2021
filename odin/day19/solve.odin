package day19

import "core:fmt"
import "core:os"

Point :: [3]int

solve :: proc() -> (ok: bool) {
  input := os.read_entire_file(".input/day19") or_return
  defer delete(input)

  scanners := parse_scanners(string(input)) or_return
  defer destroy_scanners(scanners)

  // This day is left without a solution for now. :<

  // I wanted to use SoA features of Odin but due to a bug there's no
  // way to allocate/free `#soa[][3]int`, `make_soa` on that type just
  // gives a compilation error.

  // The cute code that I had on my mind is rendered impossible for now.
  // Pretty disappointing day.

  fmt.println("day19: - -")
  return true
}
