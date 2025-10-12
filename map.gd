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
		new_state: CellularAutomata.CellState) -> void:
	var new_tile: Vector2i
	match new_state:
		CellularAutomata.CellState.DISCONNECTED:
			new_tile = DISCONNECTED
		CellularAutomata.CellState.SEED:
			new_tile = SEED
		CellularAutomata.CellState.INVITE:
			new_tile = INVITE
		CellularAutomata.CellState.CONNECTED:
			new_tile = CONNECTED
	
	set_cell(cell_coords, 0, new_tile)

# UI node most be above the Maze node in the scene tree because
# nodes execute _on_new_maze in the order they appear in the scene tree
func _on_new_maze(_params) -> void:
	clear()
	# Create an empty map of 
