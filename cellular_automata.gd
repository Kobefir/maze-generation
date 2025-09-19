class_name CellularAutomata extends Node2D

enum CellState {
	DISCONNECTED,
	SEED,
	INVITE,
	CONNECTED
}

class Cell:
	var state := CellState.DISCONNECTED
	var connect_vector : int
	
	# TODO: the article
	
