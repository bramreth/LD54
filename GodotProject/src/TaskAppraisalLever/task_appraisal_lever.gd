extends StaticBody3D
class_name TaskAppraisalLever

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func toggle_highlight() -> void:
	animation_player.stop()
	animation_player.play("fade_out")


func pull() -> void:
	RoundManager.evalutae()
