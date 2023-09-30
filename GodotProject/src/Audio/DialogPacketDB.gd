extends Node

const dialog_packets := {
	"intro": [
		preload("res://src/Audio/res/Intro_Part1.tres"),
		preload("res://src/Audio/res/Intro_Part2.tres"),
		preload("res://src/Audio/res/Intro_Part3.tres")
	],
	"tutorial_1": [
		preload("res://src/Audio/res/Alarm.tres"),
		preload("res://src/Audio/res/Tutorial_1_Part1.tres"),
		preload("res://src/Audio/res/Tutorial_1_Part2.tres"),
		preload("res://src/Audio/res/Tutorial_1_Part3.tres")
	],
	"tutorial_2": [
		preload("res://src/Audio/res/Alarm.tres"),
	]
}


func get_intro_dialog() -> Array:
	return dialog_packets.intro


func get_tutorial_dialog(tutorial_num: int) -> Array:
	var tutorial: String = "tutorial_" + str(tutorial_num)
	if dialog_packets.keys().has(tutorial):
		return dialog_packets[tutorial]
	else:
		print("Nonexistant: " + tutorial)
		return []
