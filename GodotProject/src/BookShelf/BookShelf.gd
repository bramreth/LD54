extends Node3D
class_name BookShelf

@onready var racks: Node3D = $CSGBox3D/Racks
@onready var reset_timer: Timer = $ResetTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sparleticles: GPUParticles3D = $Sparleticles
@onready var shelf_mesh: CSGBox3D = $CSGBox3D

@export var genre: BookRes.GENRE = BookRes.GENRE.BESTSELLERS
@export var active_onready: bool = true

var finished_racks := []
var total_score: int = 0

func _ready() -> void:
	if not active_onready: shelf_mesh.global_position = Vector3(0, -3, 0)
	shelf_mesh.material.albedo_color = BookRes.map_color(genre)
	for rack in racks.get_children():
		rack.genre = genre



func _on_rack_full(rack: BookRack, score: int) -> void:
	if finished_racks.has(rack): return
	finished_racks.append(rack)
	total_score += score
	print(finished_racks)

	if finished_racks.size() >= 3:
		UiEventBus.score_changed.emit(total_score)
		sparleticles.emitting = true
#		reset_anim()

func reset_anim() -> void:
	animation_player. play("filled")
	reset_timer.start(5.0)


func reset() -> void:
	reset_timer.stop()
	total_score = 0
	finished_racks.clear()
	for rack in racks.get_children():
		rack.reset()
	animation_player.play("reset")


func _on_reset_timer_timeout() -> void:
	reset()
