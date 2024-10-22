enum Weapon {
  Sword(Sword)
  Slingshot(Slingshot)
}

pub fn switch_weapon(self : Player) -> Unit {
  if self.weapon_type == true {
    self.weapon = Slingshot(self.slingshot)
    self.weapon_type = false
  } else {
    self.weapon = Sword(self.sword)
    self.weapon_type = true
  }
  self.switch_cd.refersh()
}

pub fn attack(
  self : Weapon,
  pos : Position,
  room : Room,
  mouse_x : Int,
  mouse_y : Int
) -> Unit {
  match self {
    Sword(sword) => sword.sword_attack(pos, room, mouse_x, mouse_y)
  }
}

pub fn get_cd(self : Weapon) -> CD {
  match self {
    Sword(sword) => sword.cd
    Slingshot(slingshot) => slingshot.cd
  }
}

pub fn update_weapon(self : Player) -> Unit {
  self.switch_cd.decrease()
  match self.weapon {
    Sword(sword) => sword.cd.decrease()
    Slingshot(slingshot) => slingshot.cd.decrease()
  }
}

struct Sword {
  level : Int
  damage : Int
  range : Int
  cd : CD
}

pub fn Sword::new() -> Sword {
  { level: 1, damage: 10, range: 3, cd: CD::new(100, 10) }
}

pub fn sword_determine_direction(
  mouse_x : Int,
  mouse_y : Int,
  pos : Position
) -> Direction {
  let dx = mouse_x.to_double() - pos.x
  let dy = mouse_y.to_double() - pos.y
  if dy < 0 && dx.abs() < dy.abs() {
    Up
  } else if dy > 0 && dx.abs() < dy.abs() {
    Down
  } else if dx < 0 && dy.abs() < dx.abs() {
    Left
  } else {
    Right
  }
}

pub fn sword_generate_attack_hitbox(
  self : Direction,
  sword : Sword,
  pos : Position
) -> Shape {
  let range = sword.range.to_double()
  match self {
    Left => Rect(pos.x - 5 - range, pos.y - 5, pos.x - 5, pos.y)
    Right => Rect(pos.x, pos.y - 5, pos.x + 5 + range, pos.y + 5)
    Up => Rect(pos.x - 5, pos.y - 5 - range, pos.x + 5, pos.y)
    Down => Rect(pos.x - 5, pos.y, pos.x + 5, pos.y + 5 + range)
  }
}

pub fn sword_attack(
  self : Sword,
  pos : Position,
  room : Room,
  mouse_x : Int,
  mouse_y : Int
) -> Unit {
  for _, enemy in room.enemys {
    let { damage, .. } = self
    let hitbox = sword_determine_direction(mouse_x, mouse_y, pos).sword_generate_attack_hitbox(
      self, pos,
    )
    if hitbox.intersect(enemy.get_hitbox()) {
      enemy.damage(damage)
    }
  }
  self.cd.refersh()
}

struct Slingshot {
  level : Int
  cd : CD
}

pub fn Slingshot::new() -> Slingshot {
  { level: 1, cd: CD::new(100, 10) }
}
