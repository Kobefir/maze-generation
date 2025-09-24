class_name CellularAutomata extends Node2D

# Maze dimensions in cell (junction) counts
@export var maze_width: int = 16 
@export var maze_height: int = 16

@export var wall_thickness: int = 1
@export var floor_thickness: int = 1
@export var branch_probability: int = 5	# Percent chance of branching

var maze: Dictionary[Vector2i, Cell]

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
	var neighbours: Array[bool]	# 4 bits, one for each cardinal direction
	
	# TODO: the article
	
