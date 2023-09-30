extends Node3D

var intro_messages := [
	preload("res://src/Audio/res/Intro_Part1.tres"),
	preload("res://src/Audio/res/Intro_Part2.tres"),
	preload("res://src/Audio/res/Intro_Part3.tres")
	
]


func _ready() -> void:
	play_intro()


func play_intro() -> void:
	for message in intro_messages:
		Announcer.play(message)
		await Announcer.announcement_over
	
	RoundManager.start_game()
