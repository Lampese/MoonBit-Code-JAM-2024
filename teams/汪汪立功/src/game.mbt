struct Game {
  mut level : Int
  mut stop : Bool
  player : Player
  mut current_room : Room
}

fn Game::new() -> Game {
  {
    level: 1,
    stop: false,
    player: Player::new({ x: 100, y: 100 }),
    current_room: generate_room(1),
  }
}

fn update_level(self : Player) -> Unit {
  match check_next_room(self) {
    Some(Up) => {
      game.level += 1
      game.current_room = generate_room(game.level)
      self.pos = { x: 73, y: 121 }
    }
    Some(Down) => {
      game.level += 1
      game.current_room = generate_room(game.level)
      self.pos = { x: 76, y: 30 }
    }
    Some(Left) => {
      game.level += 1
      game.current_room = generate_room(game.level)
      self.pos = { x: 126, y: 73 }
    }
    Some(Right) => {
      game.level += 1
      game.current_room = generate_room(game.level)
      self.pos = { x: 31, y: 77 }
    }
    None => ()
  }
}

fn check_next_room(self : Player) -> Direction? {
  let (x, y) = self.pos.to_wasm4_pos()
  @wasm4.trace("\{x} \{y}")
  if x > 0 && x < 160 && y > 0 && y < 160 {
    None
  } else if x <= 0 {
    Some(Left)
  } else if x >= 160 {
    Some(Right)
  } else if y <= 0 {
    Some(Up)
  } else {
    Some(Down)
  }
}
