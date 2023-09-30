extends StaticBody3D
class_name TaskAppraisalLever

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var lever_animator: AnimationPlayer = $LeverAnimator

func toggle_highlight() -> void:
	animation_player.stop()
	animation_player.play("fade_out")


func pull() -> void:
	lever_animator.play("Pull")
	RoundManager.evalutae()
