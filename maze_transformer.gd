extends Node

@export var maze: Maze

# Tile atlas coords
var FLOOR := Vector2i(0, 0)
var WALL := Vector2i(1, 0)

var cells: Dictionary[Vector2i, Vector2i] # [coords, TileSet atlas coords]

func _ready() -> void:
	SignalBus.maze_complete.connect(_on_maze_complete)

# This runs after Maze's _on_maze_complete() because MazeTransformer lower in
# the scene tree
func _on_maze_complete(
		params: Dictionary[StringName, int],
		_maze: Dictionary[Vector2i, CellularAutomata.Cell]) -> void:
	# Save all of the "cells" in the TileMap, excluding the outermost walls
	var cells_width: int = (params[&"maze_width"] * params[&"wall_size"]) \
			+ (params[&"maze_width"] * params[&"floor_size"]) - params[&"wall_size"]
	var cells_height: int = (params[&"maze_height"] * params[&"wall_size"]) \
			+ (params[&"maze_height"] * params[&"floor_size"]) - params[&"wall_size"]
	var cells_origin := Vector2i(params[&"wall_size"], params[&"wall_size"])
	maze.fill_rect(cells_origin, cells_width, cells_height, FLOOR)
	for x in range(4):
		return
