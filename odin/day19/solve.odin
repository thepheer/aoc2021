package day19

import "core:fmt"
import "core:os"

solve :: proc() -> (ok: bool) {
  input := os.read_entire_file(".input/day19") or_return
  defer delete(input)

  scanners := parse_scanners(string(input)) or_return
  defer delete_scanners(scanners)

  matcher: Matcher
  defer delete_matcher(matcher)

  match_all(&matcher, scanners)

  part1 := len(matcher.known_points)
  part2 := max_manhattan(matcher.known_scanners[:])

  fmt.println("day19:", part1, part2)
  return true
}
