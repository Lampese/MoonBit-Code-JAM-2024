enum Texture {
  Texture(
    Array[(Int, Int, Int, Int)],
    Array[(Int, Int, Int, Int)],
    Array[(Int, Int, Int, Int)],
    Array[(Int, Int, Int, Int)],
    ~weight : Int,
    ~height : Int
  )
}

fn render_texture(self : Texture, x : Int, y : Int) -> Unit {
  guard let Texture(black, brown, light_brown, gery, ..) = self
  set_draw_color(2, Transparent)
  set_draw_color(1, Black)
  for rect in black {
    let (x1, y1, x2, y2) = rect
    @wasm4.rect(x + x1 - 1, y + y1 - 1, x2 - x1 + 1, y2 - y1 + 1)
  }
  set_draw_color(1, Brown)
  for rect in brown {
    let (x1, y1, x2, y2) = rect
    @wasm4.rect(x + x1 - 1, y + y1 - 1, x2 - x1 + 1, y2 - y1 + 1)
  }
  set_draw_color(1, LightBrown)
  for rect in light_brown {
    let (x1, y1, x2, y2) = rect
    @wasm4.rect(x + x1 - 1, y + y1 - 1, x2 - x1 + 1, y2 - y1 + 1)
  }
  set_draw_color(1, Grey)
  for rect in gery {
    let (x1, y1, x2, y2) = rect
    @wasm4.rect(x + x1 - 1, y + y1 - 1, x2 - x1 + 1, y2 - y1 + 1)
  }
}

let player_texture : Texture = Texture(
  [
    (1, 2, 1, 3),
    (2, 1, 3, 4),
    (4, 1, 4, 1),
    (5, 2, 5, 2),
    (6, 1, 6, 1),
    (7, 1, 10, 3),
    (2, 5, 2, 7),
    (4, 3, 6, 3),
    (4, 4, 4, 5),
    (6, 4, 6, 4),
    (7, 5, 7, 6),
    (9, 4, 11, 4),
    (9, 5, 9, 5),
    (11, 5, 11, 6),
    (10, 7, 10, 7),
    (3, 8, 10, 8),
    (2, 9, 2, 10),
    (3, 10, 3, 10),
    (4, 9, 4, 11),
    (6, 10, 7, 10),
    (9, 9, 9, 9),
    (9, 10, 11, 10),
    (5, 11, 9, 11),
  ],
  [(5, 9, 8, 9)],
  [
    (5, 1, 5, 1),
    (4, 2, 4, 2),
    (6, 2, 6, 2),
    (3, 5, 3, 5),
    (5, 4, 5, 5),
    (6, 5, 6, 5),
    (8, 4, 8, 5),
    (9, 5, 9, 6),
    (3, 6, 9, 7),
    (3, 9, 3, 9),
    (5, 10, 5, 10),
    (8, 10, 8, 10),
    (10, 9, 10, 9),
  ],
  [],
  weight=10,
  height=10,
)
