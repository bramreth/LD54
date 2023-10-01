extends Camera3D

@export var player: CharacterBody3D
@export var coffee: RigidBody3D
@onready var button: Button = $StartCanvas/MarginContainer/VBoxContainer/Button
@onready var start_canvas: CanvasLayer = $StartCanvas
@onready var margin_container: MarginContainer = $StartCanvas/MarginContainer

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	player.set_physics_process(false)
	button.pressed.connect(
		func():
			var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
			tween.tween_callback(
				func():
					get_parent().play_intro()
					Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
					player.visible = false
					coffee.apply_central_impulse(Vector3.UP * .1)
					coffee.get_children().back().emitting = false
			)
			tween.tween_property(margin_container, "modulate", Color.TRANSPARENT, 1.0)
			tween.tween_callback(start_canvas.queue_free)
			tween.tween_property(self, "position", position + Vector3(0.0, 0.5, 0.0), 0.5)
			tween.tween_property(self, "global_transform", player.camera_3d.global_transform, 1.0)
			tween.tween_callback(player.camera_3d.set_current.bind(true))
			tween.tween_callback(
				func():
					player.visible = true
					player.set_physics_process(true)
			)


	)
