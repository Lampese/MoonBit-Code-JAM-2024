struct Game {
  mut level : Int
  mut stop : Bool
  player : Player
  current_room : Room
  id_pool : ID_Pool
}

fn Game::new() -> Game {
  {
    level: 1,
    stop: false,
    player: Player::new({ x: 80, y: 80 }),
    current_room: Room::new(),
    id_pool: ID_Pool::new(),
  }
}
