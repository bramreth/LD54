extends Node

signal announcement(packet: DialogPacket)
signal announcement_over()

@onready var player: AudioStreamPlayer3D = $AudioStreamPlayer3D
var current_priority := -1

func set_announcer_position(pos: Vector3) -> void:
	player.global_position = pos


func play(packet: DialogPacket, priority: int = 0) -> void:
	if priority <= current_priority: return
	current_priority = priority
	player.stream = packet.audio
	player.play()
	announcement.emit(packet)


func _on_audio_stream_player_3d_finished() -> void:
	current_priority = -1
	announcement_over.emit()
