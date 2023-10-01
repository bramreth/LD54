extends StaticBody3D
class_name TaskAppraisalLever

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var lever_animator: AnimationPlayer = $LeverAnimator
@onready var open: AnimationPlayer = $Open

var locked: bool = false


func _ready() -> void:
	UiEventBus.lock_lever.connect(
		func(is_locked: bool):
			locked = is_locked
			if locked:
				open.play_backwards("Open")
			else:
				open.play("Open")
	)
	RoundManager.round_started.connect(func(_x, _y): locked = false)

func toggle_highlight() -> void:
	if locked: return
	animation_player.stop()
	animation_player.play("fade_out")


func pull() -> void:
	if locked: return
	lever_animator.play("Pull")
	RoundManager.evalutae()
	locked = true
