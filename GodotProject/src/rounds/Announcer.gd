extends Node

signal announcement(packet: DialogPacket)
signal announcement_over()

@onready var player: AudioStreamPlayer3D = $AudioStreamPlayer3D
var current_priority := -1
var current_queue := []

func set_announcer_position(pos: Vector3) -> void:
	player.global_position = pos


func queue(packets: Array, priority: int = 0) -> void:
	if priority < current_priority: return
	if player.playing: player.stop()
	current_priority = priority
	current_queue.clear()
	current_queue += packets
	var pack = current_queue.pop_front()
	if pack is Callable:
		pack.call()
		_on_audio_stream_player_3d_finished()
	elif pack == null:
		pass
	else:
		play(pack)


func play(packet: DialogPacket) -> void:
#	if priority <= current_priority: return
#	current_priority = priority
	player.stream = packet.audio
	player.play()
	announcement.emit(packet)


func _on_audio_stream_player_3d_finished() -> void:
	if not current_queue.is_empty():
		var pack = current_queue.pop_front()
		if pack is Callable:
			pack.call()
			_on_audio_stream_player_3d_finished()
		elif pack == null:
			pass
		else:
			play(pack)
	else:
		current_priority = -1
		announcement_over.emit()
