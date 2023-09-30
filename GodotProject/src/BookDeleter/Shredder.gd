extends Node3D

@onready var blades: Node3D = $Blades
@onready var blades_2: Node3D = $Blades2
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	blades.rotate_x(delta * 10)
	blades_2.rotate_x(-delta * 10)


func _on_shredding() -> void:
	animation_player.play("shred", -1, 2.0)
