use std::ops::{Index, IndexMut};

use super::*;

#[derive(Debug)]
pub struct Grid<T> {
  pub grid: Vec<T>,
  pub size: Vec2
}

impl Grid<u8> {
  pub fn parse(input: &str) -> Option<Self> {
    let mut grid = Vec::new();
    let mut height = 0;
    for line in input.lines() {
      grid.extend(line.bytes().map(|b| b - b'0'));
      height += 1;
    }
    let width = grid.len() as i32 / height;
    let size = Vec2::new(width, height);
    Some(Self { grid, size })
  }

  pub fn expand(&self, times: usize) -> Self {
    let src_w = self.size.x as usize;
    let src_h = self.size.y as usize;
    let mut src = self.grid.clone();

    let dst_w = times * src_w;
    let dst_h = times * src_h;
    let mut dst = vec![0; dst_w * dst_h];

    // https://stackoverflow.com/a/1779242/8802501
    for k in 0..2 * times - 1 {
      let z = (k + 1).saturating_sub(times);
      for (x, y) in (z..=k - z).map(|y| (k - y, y)) {
        let offset = dst_w * src_h * y + src_h * x;
        for i in 0..src_h {
          let s = src_w * i;
          let d = dst_w * i + offset;
          dst[d..d + src_w].copy_from_slice(&src[s..s + src_w]);
        }
      }
      for value in &mut src {
        *value = *value % 9 + 1;
      }
    }

    // should've read the description better
    // spent 20 minutes writing this code only to realize
    // it's not how part2 works

    // for n in 0..times {
    //   let mut copy_block = |offset| for i in 0..src_h {
    //     let (s, d) = (src_w * i, dst_w * i + offset);
    //     dst[d..d + src_w].copy_from_slice(&src[s..s + src_w]);
    //   };

    //   let offset = dst_w * src_h * n;           // #...
    //   for i in 0..=n {                          // ##..
    //     copy_block(src_h * i + offset);         // ###.
    //   }                                         // ####

    //   let offset = src_h * n;                   // .###
    //   for i in 0..n {                           // ..##
    //     copy_block(dst_w * src_h * i + offset); // ...#
    //   }                                         // ....

    //   for value in &mut src {
    //     *value = *value % 9 + 1;
    //   }
    // }

    let size = Vec2::new(dst_w as i32, dst_h as i32);
    Self { grid: dst, size }
  }
}

impl<T: Clone> Grid<T> {
  pub fn filled(size: Vec2, value: T) -> Self {
    let area = size.x * size.y;
    let grid = vec![value; area as usize];
    Self { grid, size }
  }
}

impl<T> Grid<T> {
  pub fn in_bounds(&self, at: Vec2) -> bool {
    let x = 0 <= at.x && at.x < self.size.x;
    let y = 0 <= at.y && at.y < self.size.y;
    x && y
  }
}

impl<T> Index<Vec2> for Grid<T> {
  type Output = T;

  fn index(&self, at: Vec2) -> &Self::Output {
    &self.grid[(self.size.x * at.y + at.x) as usize]
  }
}

impl<T> IndexMut<Vec2> for Grid<T> {
  fn index_mut(&mut self, at: Vec2) -> &mut Self::Output {
    &mut self.grid[(self.size.x * at.y + at.x) as usize]
  }
}

impl std::fmt::Display for Grid<u8> {
  fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
    let color = |x: u8| {
      let t = x as f32 / 9.0;
      let r = ((2.0 * t).min(1.0) * 255.0).round() as u8;
      let g = ((1.0 * t).min(1.0) * 255.0).round() as u8;
      let b = ((4.0 * t).min(1.0) * 255.0).round() as u8;
      (r, g, b)
    };
    for y in (0..self.size.y).step_by(2) {
      for x in 0..self.size.x {
        let (br, bg, bb) = color(self[Vec2::new(x, y)]);
        let (fr, fg, fb) = color(self[Vec2::new(x, y + 1)]);
        f.write_fmt(format_args!("\x1b[48;2;{};{};{};38;2;{};{};{}m▄", br, bg, bb, fr, fg, fb))?;
      }
      f.write_str("\x1b[0m\n")?;
    }
    Ok(())
  }
}
