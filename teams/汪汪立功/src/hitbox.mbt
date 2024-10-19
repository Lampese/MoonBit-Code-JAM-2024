enum Shape {
  Rect(Double, Double, Double, Double)
  Circle(Double, Double, Double)
}

struct HitBox {
  shapes : Array[Shape]
}

pub fn HitBox::new() -> HitBox {
  { shapes: [] }
}

pub fn add(self : HitBox, shape : Shape) -> Unit {
  self.shapes.push(shape)
}

pub fn is_intersect(self : Shape, other : Shape) -> Bool {
  match (self, other) {
    (Rect(x1, y1, x2, y2), Rect(x3, y3, x4, y4)) =>
      (x1 > x4 || x3 > x2 || y1 > y4 || y3 > y2).not()
    (Rect(x1, y1, x2, y2), Circle(x3, y3, r)) => {
      let closest_x = if x3 < x1 { x1 } else if x3 > x2 { x2 } else { x3 }
      let closest_y = if y3 < y1 { y1 } else if y3 > y2 { y2 } else { y3 }
      let distance_x = x3 - closest_x
      let distance_y = y3 - closest_y
      distance_x * distance_x + distance_y * distance_y < r * r
    }
    (Circle(x3, y3, r), Rect(x1, y1, x2, y2)) =>
      is_intersect(Rect(x1, y1, x2, y2), Circle(x3, y3, r))
    (Circle(x1, y1, r1), Circle(x2, y2, r2)) => {
      let distance_x = x2 - x1
      let distance_y = y2 - y1
      let distance_squared = distance_x * distance_x + distance_y * distance_y
      let radius_sum = r1 + r2
      distance_squared < radius_sum * radius_sum
    }
  }
}

pub fn init_wall() -> HitBox {
  let hitbox : HitBox = HitBox::new()
  hitbox.add(Rect(0, 0, 15, 159))
  hitbox.add(Rect(0, 0, 159, 15))
  hitbox.add(Rect(0, 143, 159, 159))
  hitbox.add(Rect(143, 0, 159, 159))
  hitbox
}

pub fn shape_in_box(self : HitBox, shape : Shape) -> Bool {
  for current_shape in self.shapes {
    if is_intersect(current_shape, shape) {
      return true
    }
  }
  false
}
