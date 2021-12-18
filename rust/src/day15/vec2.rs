#[derive(Debug, Clone, Copy, Eq, PartialEq)]
pub struct Vec2 {
  pub x: i32,
  pub y: i32,
}

impl Vec2 {
  pub fn new(x: i32, y: i32) -> Self {
    Self { x, y }
  }

  pub fn neighbors(&self) -> [Vec2; 4] {
    [
      Vec2::new(self.x, self.y - 1),
      Vec2::new(self.x, self.y + 1),
      Vec2::new(self.x - 1, self.y),
      Vec2::new(self.x + 1, self.y),
    ]
  }
}
