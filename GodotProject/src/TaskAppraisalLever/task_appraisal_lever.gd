extends StaticBody3D
class_name TaskAppraisalLever

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var lever_animator: AnimationPlayer = $LeverAnimator
@onready var open: AnimationPlayer = $Open

var locked: bool = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_end"):
		open.play("Open")


func _ready() -> void:
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
