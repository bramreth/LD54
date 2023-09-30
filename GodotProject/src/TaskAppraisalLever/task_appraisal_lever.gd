extends StaticBody3D
class_name TaskAppraisalLever

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var lever_animator: AnimationPlayer = $LeverAnimator

var locked: bool = true

func toggle_highlight() -> void:
	if locked: return
	animation_player.stop()
	animation_player.play("fade_out")


func pull() -> void:
	if locked: return
	lever_animator.play("Pull")
	RoundManager.evalutae()
