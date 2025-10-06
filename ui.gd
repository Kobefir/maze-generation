extends CanvasLayer

@export var generate_maze_button: Button
@export var maze_width_input: LineEdit
@export var maze_height_input: LineEdit
@export var floor_width_input: LineEdit
@export var wall_width_input: LineEdit

func _init() -> void:
	generate_maze_button.pressed.connect(_on_generate_maze_button_pressed)

func _on_generate_maze_button_pressed() -> void:
	var maze_width: int = maze_width_input.text.to_int()
	var maze_height: int = maze_height_input.text.to_int()
	var floor_width: int = floor_width_input.text.to_int()
	var wall_width: int = wall_width_input.text.to_int()
