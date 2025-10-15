extends Camera2D

@export var speed: float = 500

func _physics_process(delta) -> void:
	var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	position += input_dir * speed * delta
