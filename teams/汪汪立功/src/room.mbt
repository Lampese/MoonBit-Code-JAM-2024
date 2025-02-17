struct Room {
  mut stop : Bool
  enemys : Map[UInt, Enemy]
  arrows : Map[UInt, Arrow]
  walls : HitBox
  arrow_walls : HitBox
  mut frame : HitBox
  mut obstacles : Array[Obstacle]
  upgrade : Bool
  start : Bool
}

fn Room::new(upgrade : Bool, start : Bool) -> Room {
  {
    stop: false,
    walls: init_wall(),
    enemys: {},
    arrows: {},
    arrow_walls: init_wall(),
    frame: HitBox::new(),
    obstacles: [],
    upgrade,
    start,
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

fn bind_style(self : Room, style : RoomStyle) -> Unit {
  guard let RoomStyle(obstacles) = style
  self.obstacles = obstacles
  for obstacle in obstacles {
    self.walls.add(obstacle.get_obstacle_hitbox())
  }
}

fn add_enemy(self : Room, enemy : Enemy) -> Unit {
  self.enemys.set(enemy.get_id(), enemy)
}

enum RoomStyle {
  RoomStyle(Array[Obstacle])
}

let room_styles : Array[RoomStyle] = [
  RoomStyle([Jar(24, 24), Jar(24, 124), Jar(124, 124), Jar(124, 24)]),
  RoomStyle(
    [Jar(24, 24), Jar(24, 124), Jar(124, 124), Jar(124, 24), Tombstone(72, 72)],
  ),
  RoomStyle(
    [Jar(24, 24), Jar(24, 124), Jar(124, 124), Jar(124, 24), Tombstone(72, 72)],
  ),
  RoomStyle(
    [
      Tombstone(24, 24),
      Tombstone(24, 121),
      Tombstone(121, 121),
      Tombstone(121, 24),
    ],
  ),
  RoomStyle(
    [
      Tombstone(24, 24),
      Tombstone(24, 121),
      Tombstone(121, 121),
      Tombstone(121, 24),
      Jar(75, 75),
    ],
  ),
  RoomStyle([Jar(75, 75)]),
  RoomStyle([Tombstone(72, 72)]),
]

let room_style_upper_index : Int = room_styles.length() - 1

fn generate_room(level : Int) -> Room {
  if level == 1 {
    Room::new(false, true)
  } else if level % 3 == 0 {
    Room::new(true, false)
  } else {
    let room = Room::new(false, false)
    room.bind_style(room_styles[random.next(0, room_style_upper_index)])
    let enemy_count = 3 + level / 2 + level / 10 + level / 20 + level / 40
    let enemy_level = level / 8 + level / 10 + level / 15
    let mummy_count = random.next(0, enemy_count)
    let skeleton_count = random.next(0, enemy_count - mummy_count)
    let bug_count = enemy_count - mummy_count - skeleton_count
    for i = 1; i <= mummy_count; i = i + 1 {
      let id = id_pool.get_id()
      let pos = random.next_pos()
      let mummy = Mummy::new(id, pos, enemy_level)
      room.add_enemy(Mummy(mummy))
    }
    for i = 1; i <= skeleton_count; i = i + 1 {
      let id = id_pool.get_id()
      let pos = random.next_pos()
      let skeleton = Skeleton::new(id, pos, enemy_level)
      room.add_enemy(Skeleton(skeleton))
    }
    for i = 1; i <= bug_count; i = i + 1 {
      let id = id_pool.get_id()
      let pos = random.next_pos()
      let bug = Bug::new(id, pos, enemy_level)
      room.add_enemy(Bug(bug))
    }
    room
  }
}
