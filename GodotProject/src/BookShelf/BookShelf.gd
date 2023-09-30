extends Node3D
class_name BookShelf

@onready var shelf_mesh: MeshInstance3D = $MeshInstance3D
@onready var racks: Node3D = $MeshInstance3D/Racks
@onready var reset_timer: Timer = $ResetTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

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
	print(finished_racks)

	if finished_racks.size() >= 3:
		UiEventBus.score_changed.emit(total_score)
		animation_player. play("filled")
		reset_timer.start(5.0)


func reset() -> void:
	total_score = 0
	finished_racks.clear()
	for rack in racks.get_children():
		rack.reset()


func _on_reset_timer_timeout() -> void:
	reset()
