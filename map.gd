extends TileMapLayer

# Tile atlas coordinates
var DISCONNECTED := Vector2i(0, 0)
var SEED := Vector2i(1, 0)
var INVITE := Vector2i(0, 1)
var CONNECTED := Vector2i(1, 1)
var ARROW_NORTH := Vector2i(2, 0)
var ARROW_EAST := Vector2i(3, 0)
var ARROW_SOUTH := Vector2i(3, 1)
var ARROW_WEST := Vector2i(2, 1)

var maze_width: int
var maze_height: int

func _ready() -> void:
	SignalBus.update_cell.connect(_on_update_cell)
	SignalBus.new_maze.connect(_on_new_maze)

func _on_update_cell(cell_coords: Vector2i,
		new_state: CellularAutomata.CellState, invite_vector: int) -> void:
	var new_tile: Vector2i
	# Translate maze coordinates to map coordinates
	# (map has a space between each cell)
	var map_coords: Vector2i = cell_coords
	map_coords.x = (map_coords.x * 2) + 1
	map_coords.y = (map_coords.y * 2) + 1
	
	match new_state:
		CellularAutomata.CellState.DISCONNECTED:
			new_tile = DISCONNECTED
		
		CellularAutomata.CellState.SEED:
			new_tile = SEED
		
		CellularAutomata.CellState.INVITE:
			new_tile = INVITE
			# Draw an arrow pointing to the cell's invited child
			if invite_vector != -1:
				# Get the corresponding arrow sprite for the invite direction
				var arrow_tile: Vector2i
				var arrow_dir: Vector2i
				
				match invite_vector:
					0:
						arrow_tile = ARROW_NORTH
						arrow_dir = Vector2i.UP
					1:
						arrow_tile = ARROW_EAST
						arrow_dir = Vector2i.RIGHT
					2:
						arrow_tile = ARROW_SOUTH
						arrow_dir = Vector2i.DOWN
					3:
						arrow_tile = ARROW_WEST
						arrow_dir = Vector2i.LEFT
				
				set_cell(map_coords + arrow_dir, 0, arrow_tile)
		
		CellularAutomata.CellState.CONNECTED:
			new_tile = CONNECTED
	
	set_cell(map_coords, 0, new_tile)

# UI node most be above the Maze node in the scene tree because
# nodes execute _on_new_maze in the order they appear in the scene tree
func _on_new_maze(params) -> void:
	clear()
	# Scare down the display if it's big enough to get in the way
	if params[&"maze_width"] > 12 or params[&"maze_height"] > 12:
		scale = Vector2(0.5, 0.5)
	else:
		scale = Vector2.ONE
	
	# Create an empty map of all-disconnected cells with one cell of padding
	var cell_coords: Vector2i
	for x in range((2 * params[&"maze_width"]) + 1):
		for y in range((2 * params[&"maze_height"]) + 1):
			cell_coords.x = x
			cell_coords.y = y
			set_cell(cell_coords, 0, DISCONNECTED)
