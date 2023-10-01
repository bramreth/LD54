extends Node3D
class_name BookShelfRow


func get_shelf_for_genre(genre: BookRes.GENRE) -> Array:
	var shelves = []
	for child in get_children():
		if child.genre == genre: shelves.append(child)
	return shelves


func reset_all() -> void:
	for child in get_children():
		child.reset()
