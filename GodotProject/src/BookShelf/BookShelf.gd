extends Node3D
class_name BookShelf

signal shelf_finished()

@onready var shelf_mesh: MeshInstance3D = $MeshInstance3D

@export var genre: BookRes.GENRE = BookRes.GENRE.BESTSELLERS

var finished_racks := []

func _ready() -> void:
	shelf_mesh.material_override.albedo_color = BookRes.map_color(genre)


func _on_rack_full(rack: BookRack) -> void:
	if finished_racks.has(rack): return
	finished_racks.append(rack)
	
	if finished_racks.size() >= 3: shelf_finished.emit()
