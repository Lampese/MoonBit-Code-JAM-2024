struct Player {
  mut pos : Position
  mut hp : Int
  hp_max : Int
}

fn Player::new(pos : Position) -> Player {
  { pos, hp: 100, hp_max: 100 }
}

// -------------- MOVE --------------

let speed = 1

fn apply(self : Player, pos : Position) -> Unit {
  let hitbox = pos.get_hitbox_player()
  if game.current_room.walls.shape_in_box(hitbox).not() {
    self.pos = pos
  }
}

pub fn get_hitbox_player(self : Position) -> Shape {
  Circle(self.x, self.y, 5.4)
}

pub fn up(self : Player) -> Unit {
  self.apply({ x: self.pos.x, y: self.pos.y - speed.to_double() })
}

pub fn down(self : Player) -> Unit {
  self.apply({ x: self.pos.x, y: self.pos.y + speed.to_double() })
}

pub fn left(self : Player) -> Unit {
  self.apply({ x: self.pos.x - speed.to_double(), y: self.pos.y })
}

pub fn right(self : Player) -> Unit {
  self.apply({ x: self.pos.x + speed.to_double(), y: self.pos.y })
}

pub fn damage(self : Player, hp : Int) -> Unit {
  self.hp -= hp
}

// -------------- RENDER --------------

fn render_player(player : Player) -> Unit {
  player_texture.render_texture(
    (player.pos.x - 5).to_int(),
    (player.pos.y - 5).to_int(),
  )
}
