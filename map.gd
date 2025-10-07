extends TileMapLayer

var tile_coords: Dictionary 
var DISCONNECTED := Vector2i(0, 0)

func _init() -> void:
	SignalBus.generate_maze.connect(_on_generate_maze)

func _on_generate_maze(
		maze_width: int,
		maze_height: int,
		floor_width: int,
		wall_width: int,
		branch_chance: int,
		turn_chance: int,
		seed: int) -> void:
	clear()
	for x in range(maze_width):
		for y in range(maze_height):
			set_cell(Vector2i(maze_width, maze_height), 0, )
