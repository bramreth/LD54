extends Node3D

@onready var blades: Node3D = $Blades
@onready var blades_2: Node3D = $Blades2
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var face_animation_player: AnimationPlayer = $CSGBox3D/CSGBox3D2/AnimatedSprite3D/FaceAnimationPlayer
@onready var voice: AudioStreamPlayer3D = $CSGBox3D/CSGBox3D2/AnimatedSprite3D/Voice
@onready var face: Sprite3D = $CSGBox3D/CSGBox3D2/AnimatedSprite3D/Face
@onready var timer: Timer = $CSGBox3D/CSGBox3D2/AnimatedSprite3D/Timer

var quotes = [
	preload("res://src/Audio/files/more_food.mp3"),
	preload("res://src/Audio/files/hungry.mp3")
]
var nomnom = preload("res://src/Audio/files/nomnom.mp3")

var hungry_face = preload("res://MashaAssets/hungry-face/Untitled_Artwork-2 3.png")
var normal_face = preload("res://MashaAssets/hungry-face/Untitled_Artwork-3 3.png")
var happy_face = preload("res://MashaAssets/hungry-face/Untitled_Artwork-4 3.png")


func _ready() -> void:
	timer.wait_time = randf_range(4.0, 15.0)
	timer.start()



func _process(delta: float) -> void:
	blades.rotate_x(delta * 10)
	blades_2.rotate_x(-delta * 10)


func _on_shredding() -> void:
	animation_player.play("shred", -1, 2.0)
	face_animation_player.play("shred")
	callout(nomnom, happy_face)
	


func callout(stream = quotes.pick_random(), face_texture = hungry_face) -> void:
	face.texture = face_texture
	voice.stream = stream
	voice.play()



func _on_voice_finished() -> void:
	face.texture = normal_face


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "shred":
		face.texture = normal_face
		face_animation_player.play("idle")


func _on_timer_timeout() -> void:
	if not voice.playing:
		callout()
	timer.wait_time = randf_range(4.0, 15.0)
