extends Node3D
class_name BookShelfRow


func get_shelf_for_genre(genre: BookRes.GENRE) -> BookShelf:
	for child in get_children():
		if child.genre == genre: return child
	return null


func reset_all() -> void:
	for child in get_children():
		child.reset()
