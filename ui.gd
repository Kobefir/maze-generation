extends CanvasLayer

@export var new_maze_button: Button
@export var step_maze_button: Button
@export var maze_width_input: LineEdit
@export var maze_height_input: LineEdit
@export var floor_width_input: LineEdit
@export var wall_width_input: LineEdit
@export var branch_chance_input: LineEdit
@export var turn_chance_input: LineEdit
@export var seed_input: LineEdit
@export var update_speed_input: LineEdit
@export var pause_button: Button
@export var play_button: Button

func _ready() -> void:
	new_maze_button.pressed.connect(_on_new_maze_button_pressed)
	step_maze_button.pressed.connect(_on_step_maze_button_pressed)
	update_speed_input.text_changed.connect(_on_update_speed_changed.bind())
	pause_button.pressed.connect(_on_pause_button_pressed)
	play_button.pressed.connect(_on_play_button_pressed)

func _on_new_maze_button_pressed() -> void:
	# Declare params outside of the Dictionary so we can perform
	# input validation later
	var maze_width: int = maze_width_input.text.to_int()
	var maze_height: int = maze_height_input.text.to_int()
	var floor_width: int = floor_width_input.text.to_int()
	var wall_width: int = wall_width_input.text.to_int()
	var branch_chance: int = branch_chance_input.text.to_int()
	var turn_chance: int = turn_chance_input.text.to_int()
	var maze_seed: int = seed_input.text.to_int()
	
	# Build the parameter list as a statically-typed Dictionary
	var params: Dictionary[StringName, int]
	params[&"maze_width"] = maze_width
	params[&"maze_height"] = maze_height
	params[&"floor_width"] = floor_width
	params[&"wall_width"] = wall_width
	params[&"branch_chance"] = branch_chance
	params[&"turn_chance"] = turn_chance
	params[&"maze_seed"] = maze_seed
	
	SignalBus.new_maze.emit(params)

func _on_step_maze_button_pressed() -> void:
	SignalBus.step_maze.emit()

func _on_update_speed_changed(new_val: String) -> void:
	var parsed_val := new_val.to_float()
	if parsed_val == 0.0:
		update_speed_input.text = "0"
	
	SignalBus.update_speed_changed.emit(parsed_val)

func _on_pause_button_pressed() -> void:
	SignalBus.maze_paused.emit()

func _on_play_button_pressed() -> void:
	SignalBus.maze_played.emit()
