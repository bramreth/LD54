extends MarginContainer

func _ready() -> void:
	RoundManager.unlock_full_hands.connect(func(): $AnimationPlayer.play("show"))
