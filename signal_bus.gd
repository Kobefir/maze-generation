extends Node

@warning_ignore("unused_signal")
signal new_maze(params: Dictionary[StringName, int])

@warning_ignore("unused_signal")
signal step_maze()

@warning_ignore("unused_signal")
signal update_speed_changed(new_speed: float)

@warning_ignore("unused_signal")
signal update_cell(cell_coords: Vector2i,
		new_state: CellularAutomata.CellState, invite_vector: int)

@warning_ignore("unused_signal")
signal maze_complete()

@warning_ignore("unused_signal")
signal maze_paused()

@warning_ignore("unused_signal")
signal maze_played()
