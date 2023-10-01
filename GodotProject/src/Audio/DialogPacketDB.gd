extends Node

var dialog_packets := {
	"intro": [
		preload("res://src/Audio/res/Intro_Part1.tres"),
		preload("res://src/Audio/res/Intro_Part2.tres"),
		preload("res://src/Audio/res/Intro_Part3.tres"),
		func():
			get_tree().get_first_node_in_group("tuturial_scenes").show_book_dump(),
		null
	],
	"tutorial_1": [
		preload("res://src/Audio/res/Alarm.tres"),
		preload("res://src/Audio/res/Tutorial_1_Part1.tres"),
		func(): UiEventBus.lock_lever.emit(false),
		preload("res://src/Audio/res/Tutorial_1_Part3.tres")
	],
	"tutorial_2": [
		func():
			UiEventBus.lock_lever.emit(true),
		preload("res://src/Audio/res/Alarm.tres"),
		preload("res://src/Audio/res/Tutorial_1_Part2.tres"),

		func():
			UiEventBus.lock_lever.emit(false),
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
