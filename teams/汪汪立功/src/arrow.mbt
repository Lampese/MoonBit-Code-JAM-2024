struct Arrow {
  id : UInt
  mut pos : Position
  speed : Double
  k : Double
  damage : Int
  direction : Bool
  vert : Bool
}

pub fn Arrow::new(
  id : UInt,
  pos : Position,
  speed : Double,
  k : Double,
  damage : Int,
  direction : Bool,
  vert : Bool
) -> Arrow {
  { id, pos, speed, k, damage, direction, vert }
}

pub fn get_hitbox(self : Arrow) -> Shape {
  Circle(self.pos.x, self.pos.y, 2.5)
}

pub fn render_arrow(arrow : Arrow) -> Unit {
  set_draw_color(1, LightBrown)
  set_draw_color(2, Brown)
  let (x, y) = arrow.pos.to_wasm4_pos()
  @wasm4.oval(x, y, 5, 5)
}

pub fn update_arrow(self : Room) -> Unit {
  let erase_list : Array[UInt] = []
  for id, arrow in self.arrows {
    let hitbox = arrow.get_hitbox()
    if game.current_room.arrow_walls.shape_in_box(hitbox) {
      erase_list.push(id)
    } else if game.player.pos.get_hitbox_player().is_intersect(hitbox) {
      game.player.damage(arrow.damage)
      erase_list.push(id)
    } else {
      arrow.ai()
    }
  }
  for id in erase_list {
    self.erase_arrow(id)
  }
}

pub fn ai(self : Arrow) -> Unit {
  let k_signum = self.k.signum()
  let direction = (if self.direction { 1.0 } else { -1.0 }) *
    (if k_signum == 0 { 1 } else { k_signum })
  self.pos = if self.vert.not() {
    let k_s = self.k * self.k
    let sin = (k_s / (k_s + 1)).sqrt()
    let cos = if self.k == 0 { 1.0 } else { sin / self.k }
    let dy = self.speed * sin * direction
    let dx = self.speed * cos * direction
    { x: self.pos.x + dx, y: self.pos.y + dy }
  } else {
    { x: self.pos.x, y: self.pos.y + self.speed * direction }
  }
}
