extends StaticBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func toggle_highlight() -> void:
	animation_player.stop()
	animation_player.play("fade_out")
