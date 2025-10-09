class_name CellularAutomata extends Node2D

# Maze dimensions in cell (junction) counts
@export var maze_width: int = 16 
@export var maze_height: int = 16

@export var rng_seed: int = -1
@export var initial_density: float = 0.5
@export var wall_thickness: int = 1
@export var floor_thickness: int = 1
@export var branch_probability: int = 5 # Percent chance of branching
@export var turn_probability: int = 10 # Percent chance of changing path direction

@export var update_frequency: float = 0.1 # Number of seconds between _on_progress_generation() calls


var maze: Dictionary[Vector2i, Cell]
var rng: RandomNumberGenerator
var rng_initial_state: int
var active_cell_coords: Vector2i
var seed_cells: Array[Vector2i]
var branchable_connected_cells: Array[Vector2i]
var connected_cell_count: int
var update_timer: Timer

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
	var connect_vector: int = -1	# 0-3: North, East, South, West
	var invite_vector: int = -1		# 0-3: North, East, South, West
	var neighbours: int = 0b0000	# 4 bits: North, East, South, West

func _ready() -> void:
	SignalBus.new_maze.connect(_on_new_maze)
	SignalBus.step_maze.connect(_on_step_maze)
	
	update_timer = Timer.new()
	update_timer.timeout.connect(_on_update_timer_timeout)
	update_timer.wait_time = update_frequency
	add_child(update_timer)
	
	rng = RandomNumberGenerator.new()
	
	# Set the RandomNumberGenerator's seed if one was chosen by the player
	if rng_seed != -1:
		rng.seed = rng_seed
	
	rng_initial_state = rng.state

func _on_new_maze(params: Dictionary[StringName, int]) -> void:
	# Assign the maze parameters to this node
	for prop in params.keys():
		set(prop, params[prop])
	
	clear_maze()
	pick_start_seed()
	update_timer.start()

# Create empty maze consisting only of disconnected cells
func clear_maze() -> void:
	# Reset RandomNumberGenerator for reproducibility
	rng.state = rng_initial_state
	
	var new_maze: Dictionary[Vector2i, Cell]
	for x in range(maze_width):
		for y in range(maze_height):
			new_maze[Vector2i(x, y)] = Cell.new()
	
	maze = new_maze
	connected_cell_count = 0

# Set a random cell in the maze to the seed state
func pick_start_seed() -> void:
	var rand_x: int = rng.randi_range(0, (maze_width - 1))
	var rand_y: int = rng.randi_range(0, (maze_height - 1))
	var rand_coords := Vector2i(rand_x, rand_y)
	set_cell_state(rand_coords, CellState.SEED)
	active_cell_coords = rand_coords

func set_cell_state(coords: Vector2i, new_state: CellState) -> void:
	var old_state := maze[coords].state
	match old_state:
		CellState.SEED:
			seed_cells.erase(coords)
		CellState.CONNECTED:
			connected_cell_count -= 1
	
	match new_state:
		CellState.SEED:
			seed_cells.append(coords)
		CellState.CONNECTED:
			connected_cell_count += 1
			# Stop working when the maze is complete
			if connected_cell_count == maze.size():
				SignalBus.maze_complete.emit()
				update_timer.stop()
	
	maze[coords].state = new_state
	SignalBus.update_cell.emit(coords, new_state)

# Run cell simulation until one or more cells change state
func _on_step_maze() -> void:
	match maze[active_cell_coords].state:
		CellState.DISCONNECTED:
			return
			
		CellState.SEED:
			var neighbour_coords: Vector2i
			var found_neighbours: int = 0b0000 # 4 bits: North, East, South, West
			var candidate_directions: Array[int]
			
			# Look in each direction for neighbours in the disconnected state
			for i in range(len(DIRECTIONS)):
				neighbour_coords = active_cell_coords + DIRECTIONS[i]
				
				# Ensure coordinates are in-bounds
				if maze.has(neighbour_coords):
					if maze[neighbour_coords].state == CellState.DISCONNECTED:
						# Add the direction to the valid neighbour to the bitfield
						found_neighbours = found_neighbours | (2 ** i)
						candidate_directions.append(i)
			
			# Immediately change to the connected state if no valid neighbours were found
			if candidate_directions.is_empty():
				set_cell_state(active_cell_coords, CellState.CONNECTED)
				return
			
			# Update this seed cell's valid neighbour list
			maze[active_cell_coords].neighbours = found_neighbours
			
			# Randomly choose a direction to continue in
			var chosen_candidate: int = -1
			var parent_direction: int = maze[active_cell_coords].connect_vector
			
			# Bias towards going straight forward rather than turning
			if len(candidate_directions) > 1 and parent_direction != -1 \
					and candidate_directions.has((parent_direction + 2) % 4):
				if rng.randi_range(1, 100) > turn_probability:
					chosen_candidate = (parent_direction + 2) % 4
				else:
					candidate_directions.erase((parent_direction + 2) % 4)
			
			# We will not be going straight forward or we only have one candidate
			if chosen_candidate == -1:
				chosen_candidate = candidate_directions[
						rng.randi_range(0, (len(candidate_directions) - 1))]
			
			# Remember this neighbour, then change states
			maze[active_cell_coords].invite_vector = chosen_candidate
			set_cell_state(active_cell_coords, CellState.INVITE)
			
		CellState.INVITE:
			# Change invited cell into seed state
			var neighbour_coords := active_cell_coords + \
					DIRECTIONS[maze[active_cell_coords].invite_vector]
			set_cell_state(neighbour_coords, CellState.SEED)
			
			# Change into connected state if invited cell was the only neighbour
			var neighbour_candidates: int = maze[active_cell_coords].neighbours
			if (neighbour_candidates != 0) \
					and (neighbour_candidates & (neighbour_candidates - 1) == 0):
				set_cell_state(active_cell_coords, CellState.CONNECTED)
				return
			
			# Randomly decide whether or not to branch in another direction
			if rng.randi_range(1, 100) > branch_probability: # Change to final state
				set_cell_state(active_cell_coords, CellState.CONNECTED)
				# Remember that we may be able to branch again later if all seeds die
				branchable_connected_cells.append(active_cell_coords)
			else: # Return to seed state for another branch
				set_cell_state(active_cell_coords, CellState.SEED)
			
		CellState.CONNECTED:
			# If there's at least one live seed, give control to the oldest one
			if not seed_cells.is_empty():
				active_cell_coords = seed_cells[0]
				return
			
			# Randomly pick a new seed out of branchable connected seeds
			var new_seed_found := false
			for i in range(len(branchable_connected_cells) - 1): # Indirectly access this array so we can erase from it
				# Look in each direction for neighbours in the disconnected state
				var neighbour_coords: Vector2i
				var found_neighbours: int = 0b0000
				for j in range(len(DIRECTIONS)):
					neighbour_coords = active_cell_coords + DIRECTIONS[j]
					# Ensure coordinates are in-bounds
					if maze.has(neighbour_coords):
						if maze[neighbour_coords].state == CellState.DISCONNECTED:
							# Add the direction to the valid neighbour to the bitfield
							found_neighbours = found_neighbours | (2 ** j)
				
				# Remove this cell from the candidates if it no longer has valid neighbours
				if found_neighbours == 0:
					branchable_connected_cells.remove_at(i)
				# Randomly decide whether or not to revert to a seed again
				elif rng.randi_range(1, 100) <= branch_probability:
					set_cell_state(branchable_connected_cells[i], CellState.SEED)
					new_seed_found = true
			
			# If no new seeds were created, choose one random valid candidate
			if not new_seed_found:
				var chosen_candidate: Vector2i = branchable_connected_cells[
						randi_range(0, len(branchable_connected_cells) - 1)]
				set_cell_state(chosen_candidate, CellState.SEED)

func _on_update_timer_timeout() -> void:
	_on_step_maze()

func _on_maze_complete() -> void:
	return
