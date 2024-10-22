struct Room {
  mut stop : Bool
  enemys : Map[UInt, Enemy]
  arrows : Map[UInt, Arrow]
  walls : HitBox
  arrow_walls : HitBox
  mut frame : HitBox
}

fn Room::new() -> Room {
  {
    stop: false,
    walls: init_wall(),
    enemys: {},
    arrows: {},
    arrow_walls: init_wall(),
    frame: HitBox::new(),
  }
}

fn patch_out(direction : Direction) -> Unit {
  set_main_color_with_transparent(LightBrown)
  match direction {
    Up => @wasm4.rect(71, 4, 15, 18)
    Down => @wasm4.rect(72, 138, 15, 18) // need to fix
    Left => @wasm4.rect(4, 72, 18, 15)
    Right => @wasm4.rect(138, 72, 18, 15)
  }
}

fn update_room(self : Room) -> Unit {
  if self.stop.not() {
    patch_out(Up)
    patch_out(Down)
    patch_out(Left)
    patch_out(Right)
    self.frame = frame()
  } else {
    self.frame = HitBox::new()
  }
  if self.enemys.is_empty() {
    self.stop = true
  }
}

fn move_hitbox(self : Room) -> HitBox {
  self.walls.merge(self.frame)
}

fn arrow_hitbox(self : Room) -> HitBox {
  self.walls.merge(self.frame)
}
