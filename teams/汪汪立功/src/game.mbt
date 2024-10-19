struct Game {
  player : Player
  current_room : Room
  id_pool : ID_Pool
}

pub fn Game::new() -> Game {
  {
    player: Player::new({ x: 80, y: 80 }),
    current_room: Room::new(),
    id_pool: ID_Pool::new(),
  }
}
