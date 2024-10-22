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
