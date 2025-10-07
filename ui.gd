extends CanvasLayer

@export var generate_maze_button: Button
@export var maze_width_input: LineEdit
@export var maze_height_input: LineEdit
@export var floor_width_input: LineEdit
@export var wall_width_input: LineEdit
@export var branch_chance_input: LineEdit
@export var turn_chance_input: LineEdit
@export var seed_input: LineEdit
@export var update_speed_input: LineEdit

func _on_generate_maze_button_pressed() -> void:
	var maze_width: int = maze_width_input.text.to_int()
	var maze_height: int = maze_height_input.text.to_int()
	var floor_width: int = floor_width_input.text.to_int()
	var wall_width: int = wall_width_input.text.to_int()
	var branch_chance: int = branch_chance_input.text.to_int()
	var turn_chance: int = turn_chance_input.text.to_int()
	var maze_seed: int = seed_input.text.to_int()
	SignalBus.generate_maze.emit(
		maze_width,
		maze_height,
		floor_width,
		wall_width,
		branch_chance,
		turn_chance,
		maze_seed
	)
