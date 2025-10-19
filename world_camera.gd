extends Camera2D

@export var speed: float = 500

func _ready() -> void:
	SignalBus.camera_reset.connect(_on_camera_reset)

func _physics_process(delta) -> void:
	var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	position += input_dir * speed * delta

func _on_camera_reset() -> void:
	position = Vector2(0, 0)
