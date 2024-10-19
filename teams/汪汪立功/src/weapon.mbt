enum Weapon {
  Sword(Sword)
  Empty
}

struct Sword {
  damage : Int
  range : Int
}

pub fn Sword::new() -> Sword {
  { damage: 10, range: 3 }
}

pub fn attack(self : Weapon, pos : Position, room : Room) -> Unit {
  for _, enemy in room.enemys {
    attack_one(self, pos, enemy)
  }
}

pub fn attack_one(self : Weapon, pos : Position, other : Enemy) -> Unit {
  match self {
    Sword({ damage, range }) => {
      let hitbox = Rect(
        pos.x - 5,
        pos.y - 5 - range.to_double(),
        pos.x + 5,
        pos.y,
      )
      if hitbox.is_intersect(other.get_hitbox()) {
        other.damage(damage)
      }
    }
    Empty => ()
  }
}
