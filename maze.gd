class_name Maze extends TileMapLayer

# Tile atlas coords
var FLOOR := Vector2i(0, 0)
var WALL := Vector2i(1, 0)

func _ready() -> void:
	SignalBus.maze_complete.connect(_on_maze_complete)
	SignalBus.new_maze.connect(_on_new_maze)

func build_maze(params: Dictionary[StringName, int],
		maze: Dictionary[Vector2i, CellularAutomata.Cell]) -> void:
	# Build a scaled TileMapLayer maze matching the layout of the CellularAutomata maze
	var cell_coords: Vector2i
	var fill_origin: Vector2i
	var connect_vector: int # 0-3: North, East, South, West, or -1 for none
	
	for x in range(params[&"maze_width"]):
		for y in range(params[&"maze_height"]):
			# Offset the floor placement using floor_width and wall_size
			fill_origin.x = (x * params[&"floor_size"]) + (x * params[&"wall_size"]) \
					+ params[&"wall_size"]
			fill_origin.y = (y * params[&"floor_size"]) + (y * params[&"wall_size"]) \
					+ params[&"wall_size"]
			
			# Fill the floor
			fill_rect(fill_origin, params[&"floor_size"], params[&"floor_size"], FLOOR)
			
			# Get the current cell's connect_vector in the CellularAutomata maze
			cell_coords.x = x
			cell_coords.y = y
			connect_vector = maze[cell_coords].connect_vector
			
			# If there's a connect_vector, fill a hallway from this cell in that direction
			if connect_vector != -1:
				match connect_vector:
					0: # North
						fill_origin.y = fill_origin.y - params[&"wall_size"]
						fill_rect(fill_origin, params[&"floor_size"], params[&"wall_size"], FLOOR)
					1: # East
						fill_origin.x = fill_origin.x + params[&"floor_size"]
						fill_rect(fill_origin, params[&"wall_size"], params[&"floor_size"], FLOOR)
					2: # South
						fill_origin.y = fill_origin.y + params[&"floor_size"]
						fill_rect(fill_origin, params[&"floor_size"], params[&"wall_size"], FLOOR)
					3: # West
						fill_origin.x = fill_origin.x - params[&"wall_size"]
						fill_rect(fill_origin, params[&"wall_size"], params[&"floor_size"], FLOOR)
	
	# Fill the walls anywhere there isn't a floor in the maze
	var walls_width = (params[&"maze_width"] * params[&"wall_size"]) \
			+ (params[&"maze_width"] * params[&"floor_size"]) + params[&"wall_size"]
	var walls_height = (params[&"maze_height"] * params[&"wall_size"]) \
			+ (params[&"maze_height"] * params[&"floor_size"]) + params[&"wall_size"]
	fill_rect(Vector2i.ZERO, walls_width, walls_height, WALL, true)

# Fill an area on the TileMapLayer using a given tile from a top-left origin
func fill_rect(from: Vector2i, width: int, height: int, tile: Vector2i,
		fill_empty_only := false) -> void:
	var coords: Vector2i
	for x in range(width):
		for y in range(height):
			coords.x = from.x + x
			coords.y = from.y + y
			
			if fill_empty_only: # Only fill empty cells
				if get_cell_source_id(coords) == -1:
					set_cell(coords, 0, tile)
			else: # Overwrite non-empty cells (also more performant)
				set_cell(coords, 0, tile)

func _on_maze_complete(params: Dictionary[StringName, int],
		maze: Dictionary[Vector2i, CellularAutomata.Cell]) -> void:
	build_maze(params, maze)

func _on_new_maze(_params: Dictionary[StringName, int]) -> void:
	clear()
