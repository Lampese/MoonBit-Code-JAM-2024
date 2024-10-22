let game : Game = Game::new()

pub fn start() -> Unit {
  init_color()
  game.current_room.enemys.set(2, Mummy(Mummy::new(2, { x: 70, y: 70 })))
  game.current_room.enemys.set(1, Skeleton(Skeleton::new(1, { x: 50, y: 50 })))
  game.current_room.enemys.set(3, Bug(Bug::new(3, { x: 50, y: 50 })))
}

pub fn update() -> Unit {
  render(game.current_room, game.player)
  if game.stop {
    render_end_ui()
  } else {
    update_room(game.current_room)
    update_player(game.player)
    update_weapon(game.player)
    update_enemy(game.current_room)
    update_arrow(game.current_room)
    inputer(game.player)
  }
}
