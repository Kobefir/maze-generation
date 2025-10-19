extends CanvasLayer

@export var new_maze_button: Button
@export var step_maze_button: Button
@export var maze_width_input: LineEdit
@export var maze_height_input: LineEdit
@export var floor_size_input: LineEdit
@export var wall_size_input: LineEdit
@export var branch_chance_input: LineEdit
@export var turn_chance_input: LineEdit
@export var seed_input: LineEdit
@export var normal_button: Button
@export var fast_button: Button
@export var pause_button: Button
@export var play_button: Button
@export var reset_camera_button: Button
@export var finish_maze_button: Button

func _ready() -> void:
	new_maze_button.pressed.connect(_on_new_maze_button_pressed)
	step_maze_button.pressed.connect(_on_step_maze_button_pressed)
	normal_button.pressed.connect(_on_normal_button_pressed)
	fast_button.pressed.connect(_on_fast_button_pressed)
	pause_button.pressed.connect(_on_pause_button_pressed)
	play_button.pressed.connect(_on_play_button_pressed)
	reset_camera_button.pressed.connect(_on_reset_camera_button_pressed)
	finish_maze_button.pressed.connect(_on_finish_maze_button_pressed)

func _on_new_maze_button_pressed() -> void:
	# Declare params outside of the Dictionary so we can perform
	# input validation later
	var maze_width: int = maze_width_input.text.to_int()
	var maze_height: int = maze_height_input.text.to_int()
	var floor_size: int = floor_size_input.text.to_int()
	var wall_size: int = wall_size_input.text.to_int()
	var branch_chance: int = branch_chance_input.text.to_int()
	var turn_chance: int = turn_chance_input.text.to_int()
	var maze_seed: int = seed_input.text.to_int()
	
	# Build the parameter list as a statically-typed Dictionary
	var params: Dictionary[StringName, int]
	params[&"maze_width"] = maze_width
	params[&"maze_height"] = maze_height
	params[&"floor_size"] = floor_size
	params[&"wall_size"] = wall_size
	params[&"branch_chance"] = branch_chance
	params[&"turn_chance"] = turn_chance
	params[&"maze_seed"] = maze_seed
	
	SignalBus.new_maze.emit(params)
	
	# Enable the step buttons
	play_button.disabled = false
	pause_button.disabled = false
	step_maze_button.disabled = false
	finish_maze_button.disabled = false

func _on_step_maze_button_pressed() -> void:
	SignalBus.step_maze.emit()

func _on_normal_button_pressed() -> void:
	SignalBus.speed_set_normal.emit()

func _on_fast_button_pressed() -> void:
	SignalBus.speed_set_fast.emit()

func _on_pause_button_pressed() -> void:
	SignalBus.maze_paused.emit()

func _on_play_button_pressed() -> void:
	SignalBus.maze_played.emit()

func _on_reset_camera_button_pressed() -> void:
	SignalBus.camera_reset.emit()

func _on_finish_maze_button_pressed() -> void:
	SignalBus.maze_hurried.emit()
