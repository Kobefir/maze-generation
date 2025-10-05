extends Node

signal generate_maze()
signal progress_generation()
signal update_cell(cell_coords: Vector2i, new_state: CellularAutomata.CellState)
signal maze_complete()
