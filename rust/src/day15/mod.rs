use dijkstra::*;
use grid::*;
use vec2::*;

mod dijkstra;
mod grid;
mod vec2;

pub fn solve() {
  let input = std::fs::read_to_string(".input/day15").unwrap();
  let grid = Grid::parse(&input).unwrap();

  let part1 = shortest_path(&grid);
  let part2 = shortest_path(&grid.expand(5));

  println!("day15: {} {}", part1, part2);
}
