enum Color {
  Color(Bool, Bool)
}

enum Color_Type {
  Black
  Brown
  LightBrown
  Grey
  Transparent
}

pub fn to_int(self : Color) -> UInt {
  match self {
    Color(false, false) => 1
    Color(true, false) => 2
    Color(false, true) => 3
    Color(true, true) => 4
  }
}

pub fn to_int(self : Color_Type) -> UInt {
  match self {
    Transparent => 0
    Black => 1
    Brown => 2
    LightBrown => 3
    Grey => 4
  }
}

pub fn set_draw_color(index : UInt, color_type : Color_Type) -> Unit {
  @wasm4.set_draw_colors(~index, color_type.to_int())
}

pub fn init_color() -> Unit {
  @wasm4.set_palette(1, @wasm4.rgb(0x040404)) // Black
  @wasm4.set_palette(2, @wasm4.rgb(0x7c7464)) // Brown
  @wasm4.set_palette(3, @wasm4.rgb(0xf4e4bc)) // LightBrown
  @wasm4.set_palette(4, @wasm4.rgb(0x34342c)) // Grey 
}
