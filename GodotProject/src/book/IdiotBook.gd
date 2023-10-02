extends Book

func _ready() -> void:
	remove_from_group("Book")
	add_to_group("IdiotBook")


func destroy() -> void:
	apply_central_impulse(Vector3.UP)
