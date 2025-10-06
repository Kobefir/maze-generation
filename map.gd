extends TileMapLayer

func _init() -> void:
	SignalBus.generate_maze.connect(_on_generate_maze)

func clear_map() -> void:
	clear()

func _on_generate_maze() -> void:
	return
