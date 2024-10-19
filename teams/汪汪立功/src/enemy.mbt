enum Enemy {
  Mummy(Mummy)
  Skeleton(Skeleton)
  TinyS(Mummy)
}

pub fn get_pos(self : Enemy) -> Position {
  match self {
    Mummy({ pos, .. }) => pos
    Skeleton({ pos, .. }) => pos
    TinyS({ pos, .. }) => pos
  }
}

pub fn get_hp(self : Enemy) -> Int {
  match self {
    Mummy({ hp, .. }) => hp
    Skeleton({ hp, .. }) => hp
    TinyS({ hp, .. }) => hp
  }
}

pub fn get_id(self : Enemy) -> UInt {
  match self {
    Mummy({ id, .. }) => id
    Skeleton({ id, .. }) => id
    TinyS({ id, .. }) => id
  }
}

pub fn get_hitbox(self : Enemy) -> Shape {
  match self {
    Mummy({ pos, .. }) => pos.get_hitbox_mummy()
    Skeleton({ pos, .. }) => pos.get_hitbox_skeleton()
    TinyS({ pos, .. }) => pos.get_hitbox_mummy()
  }
}

pub fn damage(self : Enemy, damage : Int) -> Unit {
  match self {
    Mummy(mummy) => mummy.hp -= damage
    Skeleton(skeleton) => skeleton.hp -= damage
    TinyS(mummy) => mummy.hp -= damage
  }
}

fn render_enermy(enemy : Enemy) -> Unit {
  match enemy {
    Mummy({ pos, .. }) => {
      set_draw_color(1, Black)
      set_draw_color(2, Transparent)
      let (x, y) = pos.to_wasm4_pos()
      @wasm4.oval(x - 5, y - 5, 11, 11)
    }
    Skeleton({ pos, .. }) => {
      set_draw_color(1, Grey)
      set_draw_color(2, Transparent)
      let (x, y) = pos.to_wasm4_pos()
      @wasm4.oval(x - 5, y - 5, 11, 11)
    }
    TinyS({ pos, .. }) => {
      set_draw_color(1, Transparent)
      set_draw_color(2, Black)
      let (x, y) = pos.to_wasm4_pos()
      @wasm4.oval(x - 5, y - 5, 11, 11)
    }
  }
}

fn update_enemy(self : Room) -> Unit {
  let erase_list : Array[UInt] = []
  for id, enemy in self.enemys {
    if enemy.get_hp() <= 0 {
      erase_list.push(id)
    } else {
      match enemy {
        Mummy(mummy) => mummy.ai()
        Skeleton(skeleton) => skeleton.ai()
        TinyS(mummy) => mummy.ai()
      }
    }
  }
  for id in erase_list {
    self.erase_enemy(id)
  }
}

fn set_pos(self : Enemy, pos : Position) -> Unit {
  match self {
    Mummy(mummy) => mummy.pos = pos
    Skeleton(skeleton) => skeleton.pos = pos
    TinyS(mummy) => mummy.pos = pos
  }
}

fn apply(self : Enemy, pos : Position) -> Unit {
  let hitbox = self.get_hitbox()
  if game.current_room.walls.shape_in_box(hitbox).not() &&
    game.player.pos.get_hitbox_player().is_intersect(hitbox).not() {
    self.set_pos(pos)
  }
}

// -------------- Mummy --------------
// size: 11*11
struct Mummy {
  id : UInt
  speed : Double
  mut pos : Position
  mut hp : Int
  hit : Int
  hitcd : CD
}

pub fn Mummy::new(
  id : UInt,
  hp : Int,
  speed : Double,
  hit : Int,
  pos : Position
) -> Mummy {
  { id, pos, hp, speed, hit, hitcd: CD::new(100, 2) }
}

fn get_hitbox_mummy(self : Position) -> Shape {
  Circle(self.x, self.y, 5.4)
}

pub fn ai(self : Mummy) -> Unit {
  let distance = self.pos.distance(game.player.pos)
  self.hitcd.decrease()
  if distance <= 11 && self.hitcd.check() {
    game.player.damage(self.hit)
    self.hitcd.refersh()
  } else if distance > 11 {
    let way = self.pos.find_way(game.player.pos, self.speed)
    Mummy(self).apply({ x: way.x, y: self.pos.y })
    Mummy(self).apply({ x: self.pos.x, y: way.y })
  }
}

// -------------- Skeleton --------------
// size: 11*11
struct Skeleton {
  id : UInt
  mut pos : Position
  mut hp : Int
  hitcd : CD
}

pub fn get_hitbox_skeleton(self : Position) -> Shape {
  Circle(self.x, self.y, 5.4)
}

pub fn Skeleton::new(id : UInt, pos : Position) -> Skeleton {
  { id, pos, hp: 50, hitcd: CD::new(100, 1) }
}

pub fn ai(self : Skeleton) -> Unit {
  let distance = self.pos.distance(game.player.pos)
  self.hitcd.decrease()
  let player_pos = game.player.pos
  if distance <= 40 && self.hitcd.check() {
    let id = game.id_pool.get_id()
    if self.pos.x == player_pos.x {
      game.current_room.arrows.set(
        id,
        Arrow::new(id, self.pos, 0.5, 1, 10, self.pos.y < player_pos.y, true),
      )
    } else {
      let k = (self.pos.y - player_pos.y) / (self.pos.x - player_pos.x)
      game.current_room.arrows.set(
        id,
        Arrow::new(id, self.pos, 0.5, k, 10, self.pos.x < player_pos.x, false),
      )
    }
    self.hitcd.refersh()
  } else if distance > 40 {
    let way = self.pos.find_way(game.player.pos, 0.25)
    Skeleton(self).apply({ x: way.x, y: self.pos.y })
    Skeleton(self).apply({ x: self.pos.x, y: way.y })
  }
}
