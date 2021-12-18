package day14

import "core:fmt"
import "core:os"
import "core:strings"

Pair :: [2]byte
Pairs :: map[Pair]int
Rules :: map[Pair]byte

parse_pairs :: proc(input: string) -> (pairs: Pairs) {
  for i in 1..<len(input) {
    pairs[{input[i - 1], input[i]}] += 1
  }
  return
}

parse_rules :: proc(input: []string) -> (rules: Rules) {
  for line in input {
    rules[{line[0], line[1]}] = line[6]
  }
  return
}

run_for_n_steps :: proc(pairs: ^Pairs, rules: ^Rules, n: int) -> (ok: bool) {
  for _ in 0..<n {
    next: Pairs
    for pair, count in pairs {
      middle := rules[pair] or_return
      next[{pair[0], middle}] += count
      next[{middle, pair[1]}] += count
    }
    delete(pairs^)
    pairs^ = next
  }
  return true
}

max_min_diff :: proc(pairs: ^Pairs, init: string) -> int {
  elements: map[u8]int
  defer delete(elements)

  elements[init[0]] += 1
  elements[init[len(init) - 1]] += 1
  for pair, count in pairs {
    elements[pair[0]] += count
    elements[pair[1]] += count
  }

  min_count, max_count := max(int), min(int)
  for _, count in elements {
    min_count = min(min_count, count)
    max_count = max(max_count, count)
  }
  return (max_count - min_count) / 2
}

solve :: proc() -> (ok: bool) {
  input := os.read_entire_file(".input/day14") or_return
  defer delete(input)

  trimmed := strings.trim_space(string(input))
  lines := strings.split(trimmed, "\n")
  defer delete(lines)

  pairs := parse_pairs(lines[0])
  defer delete(pairs)

  rules := parse_rules(lines[2:])
  defer delete(rules)

  run_for_n_steps(&pairs, &rules, 10) or_return
  part1 := max_min_diff(&pairs, lines[0])

  run_for_n_steps(&pairs, &rules, 30) or_return
  part2 := max_min_diff(&pairs, lines[0])

  fmt.println("day14:", part1, part2)
  return true
}
