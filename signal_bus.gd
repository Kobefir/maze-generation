extends Node

var gameivercnt: int

@warning_ignore("unused_signal")
signal new_maze(params: Dictionary[StringName, int])

# TODO: make update_speed adjustable during maze generation
@warning_ignore("unused_signal")
signal step_maze()

@warning_ignore("unused_signal")
signal update_cell(cell_coords: Vector2i, new_state: CellularAutomata.CellState)

@warning_ignore("unused_signal")
signal maze_complete()
