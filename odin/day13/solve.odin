package day13

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

Dot :: distinct [2]int
Fold :: struct { axis: enum { x, y }, at: int }

parse_dots :: proc(input: string) -> (dots: []Dot, ok: bool) {
  lines := strings.fields(input)
  defer delete(lines)

  dots = make([]Dot, len(lines))
  defer if !ok do delete(dots)

  for line, i in lines {
    comma := strings.index_byte(line, ',')
    if comma == -1 do return

    x := strconv.parse_int(line[:comma]) or_return
    y := strconv.parse_int(line[comma + 1:]) or_return
    dots[i] = { x, y }
  }

  ok = true
  return
}

parse_folds :: proc(input: string) -> (folds: []Fold, ok: bool) {
  lines := strings.split(input, "\n")
  defer delete(lines)

  folds = make([]Fold, len(lines))
  defer if !ok do delete(folds)

  for line, i in lines {
    eq := strings.index_byte(line, '=')
    if eq == -1 do return

    at := strconv.parse_int(line[eq + 1:]) or_return
    switch line[eq - 1] {
      case 'x': folds[i] = { .x, at }
      case 'y': folds[i] = { .y, at }
      case: return
    }
  }

  ok = true
  return
}

fold_dot :: proc(fold: Fold, dot: ^Dot) {
  switch fold.axis {
    case .x: dot.x = min(2*fold.at - dot.x, dot.x)
    case .y: dot.y = min(2*fold.at - dot.y, dot.y)
  }
}

fold_dots :: proc(fold: Fold, dots: ^[]Dot) {
  for dot in dots do fold_dot(fold, &dot)
}

fold_and_count_visible :: proc(folds: []Fold, dots: ^[]Dot) -> int {
  visible: map[Dot]struct{}
  defer delete(visible)

  for fold in folds do fold_dots(fold, dots)
  for dot in dots do visible[dot] = {}
  return len(visible)
}

fold_and_print_code :: proc(folds: []Fold, dots: ^[]Dot) {
  for fold in folds do fold_dots(fold, dots)

  fmt.printf("\x1b[s")
  for dot in dots {
    fmt.printf("\x1b[u\x1b[%vB\x1b[%vC##", 1 + dot.y, 1 + 2*dot.x)
  }
  fmt.printf("\x1b[u\x1b[8B")
}

solve :: proc() -> (ok: bool) {
  input := os.read_entire_file(".input/day13") or_return
  defer delete(input)

  trimmed := strings.trim_space(string(input))
  sections := strings.split(trimmed, "\n\n")
  defer delete(sections)

  dots := parse_dots(sections[0]) or_return
  defer delete(dots)

  folds := parse_folds(sections[1]) or_return
  defer delete(folds)

  part1 := fold_and_count_visible(folds[:1], &dots)
  part2 := 0

  // fold_and_print_code(folds[1:], &dots)

  fmt.println("day13:", part1, part2)
  return true
}
