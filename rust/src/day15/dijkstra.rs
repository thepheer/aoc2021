// imagine opening rust stdlib documentation
// and discovering full solution for day15 lmao
// https://doc.rust-lang.org/std/collections/binary_heap/

use std::cmp::Ordering;
use std::collections::BinaryHeap;

use super::*;

#[derive(Copy, Clone, Eq, PartialEq)]
struct State {
  cost: u16,
  position: Vec2
}

impl Ord for State {
  fn cmp(&self, other: &Self) -> Ordering {
    other.cost.cmp(&self.cost)
  }
}

impl PartialOrd for State {
  fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
    Some(self.cmp(other))
  }
}

pub fn shortest_path(grid: &Grid<u8>) -> u16 {
  let start = Vec2::new(0, 0);
  let goal = Vec2::new(grid.size.x - 1, grid.size.y - 1);

  let mut dist = Grid::filled(grid.size, u16::MAX);
  let mut heap = BinaryHeap::new();

  dist[start] = 0;
  heap.push(State {
    cost: 0,
    position: start
  });

  while let Some(State { cost, position }) = heap.pop() {
    if position == goal { return cost }
    if cost > dist[position] { continue }

    for neighbor in position.neighbors() {
      if !grid.in_bounds(neighbor) { continue }

      let next = State {
        cost: cost + grid[neighbor] as u16,
        position: neighbor
      };

      if next.cost < dist[next.position] {
        heap.push(next);
        dist[next.position] = next.cost;
      }
    }
  }

  unreachable!()
}
