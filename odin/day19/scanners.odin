package day19

import "core:strconv"
import "core:strings"

Scanner :: struct { points: []Point, heuristics: []Heuristic }

parse_scanner :: proc(input: string) -> (scanner: Scanner, ok: bool) {
  lines := strings.split(input, "\n")
  lines_no_header := lines[1:]
  defer delete(lines)

  scanner.points = make([]Point, len(lines_no_header))
  defer if !ok do delete_scanner(scanner)

  for line, p in &lines_no_header {
    for xyz in 0..2 {
      str := strings.split_iterator(&line, ",") or_return
      num := strconv.parse_int(str, 10) or_return
      scanner.points[p][xyz] = num
    }
  }

  scanner.heuristics = compute_heuristics(scanner.points)
  return scanner, true
}

delete_scanner :: proc(self: Scanner) {
  delete(self.points)
  delete(self.heuristics)
}

parse_scanners :: proc(input: string) -> (scanners: []Scanner, ok: bool) {
  trimmed := strings.trim_space(input)
  parts := strings.split(trimmed, "\n\n")
  defer delete(parts)

  scanners = make([]Scanner, len(parts))
  defer if !ok do delete_scanners(scanners)

  for part, i in parts {
    scanners[i] = parse_scanner(part) or_return
  }

  return scanners, true
}

delete_scanners :: proc(scanners: []Scanner) {
  for scanner in scanners do delete_scanner(scanner)
  delete(scanners)
}
