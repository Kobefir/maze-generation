class_name CellularAutomata extends Node2D

@export var branch_probability: int = 5	# Percent chance of branching

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
	
