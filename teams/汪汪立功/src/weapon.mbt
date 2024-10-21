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

pub fn check_cd(self:Weapon)->Bool{
  match self{
    Sword(sword)=>sword.cd.check()
    Slingshot(slingshot)=>slingshot.cd.check()
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
  cd : CD
}

enum SwordDirection {
  Left
  Right
  Up
  Down
}

pub fn Sword::new() -> Sword {
  { level: 1, damage: 10, cd: CD::new(100, 5) }
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
  pos : Position
) -> Shape {
  match self {
    Left => Rect(pos.x - 5, pos.y - 5, pos.x - 5, pos.y)
    Right => Rect(pos.x, pos.y - 5, pos.x + 5, pos.y + 5)
    Up => Rect(pos.x - 5, pos.y - 5, pos.x + 5, pos.y)
    Down => Rect(pos.x - 5, pos.y, pos.x + 5, pos.y + 5)
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
      pos,
    )
    if hitbox.is_intersect(enemy.get_hitbox()) {
      enemy.damage(damage)
    }
  }
}

struct Slingshot {
  level : Int
  cd : CD
}
