enum Shape {
  Rect(Double, Double, Double, Double)
  Circle(Double, Double, Double)
}

struct HitBox {
  shapes : Array[Shape]
}

fn HitBox::new() -> HitBox {
  { shapes: [] }
}

fn add(self : HitBox, shape : Shape) -> Unit {
  self.shapes.push(shape)
}

fn intersect(self : Shape, other : Shape) -> Bool {
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
    (Circle(_) as circle, Rect(_) as rect) => intersect(rect, circle)
    (Circle(x1, y1, r1), Circle(x2, y2, r2)) => {
      let distance_x = x2 - x1
      let distance_y = y2 - y1
      let distance_squared = distance_x * distance_x + distance_y * distance_y
      let radius_sum = r1 + r2
      distance_squared < radius_sum * radius_sum
    }
  }
}

fn init_wall() -> HitBox {
  let hitbox : HitBox = HitBox::new()
  hitbox.add(Rect(3, 3, 70, 20))
  hitbox.add(Rect(3, 3, 20, 71))
  hitbox.add(Rect(3, 85, 20, 154))
  hitbox.add(Rect(3, 137, 71, 154))
  hitbox.add(Rect(85, 137, 154, 154))
  hitbox.add(Rect(137, 85, 154, 154))
  hitbox.add(Rect(84, 3, 154, 20))
  hitbox.add(Rect(137, 3, 154, 71))
  hitbox
}

fn init_game_wall()->HitBox{
  let hitbox=init_wall()
  hitbox.add(Rect(3,71,20,85))
  hitbox.add(Rect(70,3,84,20))
  hitbox.add(Rect(137,71,154,85))
  hitbox.add(Rect(72,138,86,155))
  hitbox
}

fn shape_in_box(self : HitBox, shape : Shape) -> Bool {
  for current_shape in self.shapes {
    if intersect(current_shape, shape) {
      return true
    }
  }
  false
}
