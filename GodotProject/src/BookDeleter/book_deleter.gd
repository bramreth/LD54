extends Area3D


func _on_body_entered(body):
	if body is Book:
		print(body.name)
		body.queue_free()

