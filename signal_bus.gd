extends Node

signal generate_maze(
		maze_width: int,
		maze_height: int,
		floor_width: int,
		wall_width: int,
		branch_chance: int,
		turn_chance: int,
		seed: int
)
# TODO: make update_speed adjustable during maze generation
signal progress_generation()
signal update_cell(cell_coords: Vector2i, new_state: CellularAutomata.CellState)
signal maze_complete()
