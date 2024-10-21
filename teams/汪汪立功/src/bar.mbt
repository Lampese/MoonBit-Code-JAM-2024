pub fn render_hp_bar(player : Player) -> Unit {
  set_draw_color(1, LightBrown)
  set_draw_color(2, Transparent)
  let progress : Double = player.hp.to_double() / player.hp_max.to_double()
  let break_point = 8 + (60.0 * progress).to_int()
  @wasm4.rect(8, 7, 60, 7)
  set_draw_color(1, Black)
  @wasm4.rect(break_point, 7, 60 - (break_point - 8), 7)
}
