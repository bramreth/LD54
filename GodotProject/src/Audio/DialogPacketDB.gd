extends Node

const dialog_packets := {
	"intro": [
		preload("res://src/Audio/res/Intro_Part1.tres"),
		preload("res://src/Audio/res/Intro_Part2.tres"),
		preload("res://src/Audio/res/Intro_Part3.tres")
	]
}


func get_intro_dialog() -> Array:
	return dialog_packets.intro
