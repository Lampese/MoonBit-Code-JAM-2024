struct Room {
  enemys : Map[UInt, Enemy]
  arrows : Map[UInt, Arrow]
  walls : HitBox
  arrow_walls : HitBox
}

pub fn Room::new() -> Room {
  {
    walls: init_wall(),
    enemys: {},
    arrows: {},
    arrow_walls: init_wall(),
  }
}

pub fn erase_enemy(self : Room, id : UInt) -> Unit {
  self.enemys.remove(id)
}

pub fn erase_arrow(self : Room, id : UInt) -> Unit {
  self.arrows.remove(id)
}
