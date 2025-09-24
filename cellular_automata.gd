class_name CellularAutomata extends Node2D

# Maze dimensions in cell (junction) counts
@export var maze_width: int = 16 
@export var maze_height: int = 16

@export var rng_seed: int = -1
@export var initial_density: float = 0.5
@export var wall_thickness: int = 1
@export var floor_thickness: int = 1
@export var branch_probability: int = 5 # Percent chance of branching
@export var turn_probability: int = 10 # Percent chance of changing path directtionn

var maze: Dictionary[Vector2i, Cell]
var rng: RandomNumberGenerator
var rng_initial_state: int
var active_cell_coords: Vector2i
var is_maze_complete: bool = false

var DIRECTIONS: Array[Vector2i] = [
	Vector2i.UP,	# Direction 0
	Vector2i.RIGHT,	# Direction 1
	Vector2i.DOWN,	# Direction 2
	Vector2i.LEFT	# Directoin 3
]

enum CellState {
	DISCONNECTED,
	SEED,
	INVITE,
	CONNECTED
}

class Cell:
	var state := CellState.DISCONNECTED
	var connect_vector: int
	var invite_vector: int
	var neighbours: Array[bool] # 4 bits: North, East, South, West

func _init():
	rng = RandomNumberGenerator.new()
	
	# Set the RandomNumberGenerator's seed if one was chosen by the player
	if rng_seed != -1:
		rng.seed = rng_seed
	
	rng_initial_state = rng.state

func generate_maze() -> void:
	clear_maze()
	pick_start_seed()
	
	while not is_maze_complete:
		progress_generation()

# Create empty maze consisting only of disconnected cells
func clear_maze() -> void:
	# Reset RandomNumberGenerator for reproducibility
	rng.state = rng_initial_state
	
	var new_maze: Dictionary[Vector2i, Cell]
	
	for x in range(maze_width):
		for y in range(maze_height):
			new_maze[Vector2i(x, y)] = Cell.new()
	
	maze = new_maze

# Set a random cell in the maze to the seed state
func pick_start_seed() -> void:
	var rand_x: int = rng.randi_range(0, (maze_width - 1))
	var rand_y: int = rng.randi_range(0, (maze_height - 1))
	set_cell(Vector2i(rand_x, rand_y), CellState.SEED)

func set_cell(cell_coords: Vector2i, new_state: CellState) -> void:
	maze[cell_coords].state = new_state
	
	match new_state:
		CellState.DISCONNECTED:
			return
		CellState.SEED:
			# Make this cell the next one to update
			active_cell_coords = cell_coords
		CellState.INVITE:
			return
		CellState.CONNECTED:
			return

# Run cell simulation until one or more cells change state
func progress_generation() -> void:
	match maze[active_cell_coords].state:
		CellState.DISCONNECTED:
			return
			
		CellState.SEED:
			var neighbour_coords: Vector2i
			var neighbour_directions: Array[int]
			
			# Find all neighbours in the disconnected state
			for i in range(len(DIRECTIONS)):
				neighbour_coords = active_cell_coords + DIRECTIONS[i]
				
				# Ensure coordinates are in-bounds
				if maze.has(neighbour_coords):
					if maze[neighbour_coords].state == CellState.DISCONNECTED:
						# Update the bitfield 
						maze[active_cell_coords].neighbours[i] = true
						neighbour_directions.append(i)
					else:
						maze[active_cell_coords].neighbours[i] = false
				else:
					maze[active_cell_coords].neighbours[i] = false
			
			# Pick a random neighbour and change it into the seed state
			var random_direction: Vector2i = DIRECTIONS[rng.randi_range(0, len(DIRECTIONS))]
			
			
		CellState.INVITE:
			return
			
		CellState.CONNECTED:
			return
