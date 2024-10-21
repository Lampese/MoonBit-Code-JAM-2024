enum Weapon {
  Sword(Sword)
  Slingshot(Slingshot)
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

pub fn update_weapon(self : Weapon) -> Unit {
  match self {
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

enum SwordDirection {
  Left
  Right
  Up
  Down
} derive(Show)

pub fn Sword::new() -> Sword {
  { level: 1, damage: 10, range: 3, cd: CD::new(100, 50) }
}

pub fn sword_determine_direction(
  mouse_x : Int,
  mouse_y : Int,
  pos : Position
) -> SwordDirection {
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
  self : SwordDirection,
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
    if hitbox.is_intersect(enemy.get_hitbox()) {
      enemy.damage(damage)
    }
  }
  self.cd.refersh()
}

struct Slingshot {
  level : Int
  cd : CD
}
