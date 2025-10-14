extends TileMapLayer

# Tile atlas coords
var FLOOR := Vector2i(0, 0)
var WALL := Vector2i(1, 0)

func _ready() -> void:
	SignalBus.maze_complete.connect(_on_maze_complete)

func build_maze(params: Dictionary[StringName, int],
		maze: Dictionary[Vector2i, CellularAutomata.Cell]) -> void:
	# General pseudocode:
	# For each cell:
	#   fill a square of length floor_width
	#   if connect_vector:
	#   fill an area of dimensions floor_width * wall_width in dir of connect_vector
	# Then, set a wall everywhere there isn't a floor
	
	# Build a scaled TileMapLayer maze matching the layout of the CellularAutomata maze
	for x in range(params[&"maze_width"]):
		for y in range(params[&"maze_height"]):
			# Fill a square of floor tiles in each cell position
			return

# Fill an area on the TileMapLayer using a given tile
func fill_rect(from: Vector2i, width: int, length: int, tile: Vector2i, preserve := false) -> void:
	return

func _on_maze_complete(params: Dictionary[StringName, int],
		maze: Dictionary[Vector2i, CellularAutomata.Cell]) -> void:
	build_maze(params, maze)
