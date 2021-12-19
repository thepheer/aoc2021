package main

import "core:fmt"
import "core:mem"

import "day09"
import "day13"
import "day14"
import "day17"
import "day19"

solve_all :: proc() -> (ok: bool) {
  day09.solve() or_return
  day13.solve() or_return
  day14.solve() or_return
  day17.solve() or_return
  day19.solve() or_return
  return true
}

main :: proc() {
  when ODIN_DEBUG {
    track: mem.Tracking_Allocator
    mem.tracking_allocator_init(&track, context.allocator)
    context.allocator = mem.tracking_allocator(&track)
    defer mem.tracking_allocator_destroy(&track)

    defer for _, entry in track.allocation_map {
      loc := entry.location
      fmt.eprintf("%s:%d:%d leaked %d bytes\n", loc.file_path, loc.line, loc.column, entry.size)
    }

    defer for entry in track.bad_free_array {
      loc := entry.location
      fmt.eprintf("%s:%d:%d bad free\n", loc.file_path, loc.line, loc.column)
    }
  }

  if ok := solve_all(); !ok {
    fmt.eprintln("died a horrible death")
  }
}
