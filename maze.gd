extends TileMapLayer

func _ready() -> void:
	SignalBus.maze_complete.connect(_on_maze_complete)

func build_maze() -> void:
	return

func _on_maze_complete(params: Dictionary[StringName, int], maze: Dictionary[Vector2i, CellularAutomata.Cell]) -> void:
	return
	# General pseudocode:
	# For each cell:
	#   fill a square of length floor_width
	#   if connect_vector:
	#   fill an area of dimensions floor_width * wall_width in dir of connect_vector
	# Then, set a wall everywhere there isn't a floor
