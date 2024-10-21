pub fn inputer(player : Player) -> Unit {
  let gamepad = @wasm4.get_gamepad()
  let mouse = @wasm4.get_mouse()
  if gamepad.button_up {
    player.up()
  }
  if gamepad.button_down {
    player.down()
  }
  if gamepad.button_left {
    player.left()
  }
  if gamepad.button_right {
    player.right()
  }
  @wasm4.trace(player.switch_cd.check().to_string())
  if mouse.left && player.weapon.get_cd().check() {
    player.weapon.attack(player.pos, game.current_room, mouse.x, mouse.y)
  } else if mouse.right && player.switch_cd.check() {
    player.switch_weapon()
  }
}
