extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		var impulse := global_position.direction_to(body.global_position)
		impulse.y = 0
		body.apply_central_impulse(impulse.normalized() * 2)
