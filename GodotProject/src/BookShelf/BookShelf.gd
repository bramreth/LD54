extends Node3D
class_name BookShelf

signal shelf_finished()

@onready var shelf_mesh: MeshInstance3D = $MeshInstance3D
@onready var racks: Node3D = $Racks


@export var genre: BookRes.GENRE = BookRes.GENRE.BESTSELLERS

var finished_racks := []
var total_score: int = 0

func _ready() -> void:
	shelf_mesh.material_override.albedo_color = BookRes.map_color(genre)
	for rack in racks.get_children():
		rack.genre = genre


func _on_rack_full(rack: BookRack, score: int) -> void:
	if finished_racks.has(rack): return
	finished_racks.append(rack)
	total_score += score
	
	if finished_racks.size() >= 3: shelf_finished.emit()
