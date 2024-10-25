struct Game {
  mut level : Int
  mut stop : Bool
  player : Player
  current_room : Room
}

fn Game::new() -> Game {
  {
    level: 1,
    stop: false,
    player: Player::new({ x: 100, y: 100 }),
    current_room: generate_room(11),
  }
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
    // Start Room
    Room::new(false)
  } else if level % 5 == 0 {
    // Upgrade Room
    Room::new(true)
  } else {
    let room = Room::new(false)
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
