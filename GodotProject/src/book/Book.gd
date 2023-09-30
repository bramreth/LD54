extends RigidBody3D
class_name Book

@export var book_res: BookRes

@onready var collision_shape: CollisionShape3D = $CollisionShape3D

func pick_up() -> void:
	freeze = true
	collision_shape.disabled = true


func drop(impulse: Vector3 = Vector3.ZERO) -> void:
	freeze = false
	collision_shape.disabled = false
	apply_central_impulse(impulse)
