#![deny(rust_2018_idioms)]
#![feature(array_windows)]
#![feature(box_patterns)]
#![feature(if_let_guard)]

#[macro_use]
mod helpers;

mod day01;
mod day02;
mod day03;
mod day04;
mod day05;
mod day06;
mod day10;
mod day15;
mod day18;

fn main() {
  day01::solve();
  day02::solve();
  day03::solve();
  day04::solve();
  day05::solve();
  day06::solve();
  day10::solve();
  day15::solve();
  day18::solve();
}
