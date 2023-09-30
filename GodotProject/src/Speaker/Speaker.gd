extends Node3D

@onready var animation_player: AnimationPlayer = $Speaker/AnimationPlayer

func _ready() -> void:
	Announcer.set_announcer_position(global_position)
	Announcer.announcement.connect(make_announcement)
	Announcer.announcement_over.connect(stop_announcement)


func make_announcement(_packet: DialogPacket) -> void:
	animation_player.play("Speaking")


func stop_announcement() -> void:
	animation_player.stop()
