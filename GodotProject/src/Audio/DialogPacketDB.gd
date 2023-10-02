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
		preload("res://src/Audio/res/errNews.tres"),
		func(): UiEventBus.lock_lever.emit(false),
		preload("res://src/Audio/res/Tutorial_1_Part3.tres")
	],
	"tutorial_2": [
		func():
			UiEventBus.lock_lever.emit(true),
		preload("res://src/Audio/res/Alarm.tres"),
		preload("res://src/Audio/res/PickUp.tres"),
		preload("res://src/Audio/res/thereIs.tres"),
		preload("res://src/Audio/res/RightClick.tres"),
		preload("res://src/Audio/res/MakeSure.tres"),
		func():
			UiEventBus.lock_lever.emit(false),
	],
	"tutorial_3": [
		func():
			UiEventBus.lock_lever.emit(true),
		preload("res://src/Audio/res/Alarm.tres"),
		preload("res://src/Audio/res/Implore.tres"),
		func():
			UiEventBus.lock_lever.emit(false),
	],
	"diesel": [
		func():
			UiEventBus.lock_lever.emit(true),
		preload("res://src/Audio/res/Tutorial_1_Part2.tres"),
		func():
			UiEventBus.lock_lever.emit(false),
	],
	"shredder": [
		func():
			UiEventBus.lock_lever.emit(true),
		preload("res://src/Audio/res/IfAnyEmployees.tres"),
		preload("res://src/Audio/res/any.tres"),
		preload("res://src/Audio/res/IREPEAT.tres"),
		func():
			UiEventBus.lock_lever.emit(false),
	],
	"overdue": [
		func():
			UiEventBus.lock_lever.emit(true),
		preload("res://src/Audio/res/Overdue1.tres"),
		preload("res://src/Audio/res/Overdue2.tres"),
		preload("res://src/Audio/res/Overdue3.tres"),
		func():
			UiEventBus.lock_lever.emit(false),
	],
	"unlock_hands": [
		func(): UiEventBus.lock_lever.emit(true),
		preload("res://src/Audio/res/Hands_Use_Them.tres"),
		func(): RoundManager.unlock_full_hands.emit(),
		preload("res://src/Audio/res/Hands.tres"),
		func(): UiEventBus.lock_lever.emit(false)
	],
	"scifi_round": [
		func(): UiEventBus.lock_lever.emit(true),
		preload("res://src/Audio/res/Blue.tres"),
		func(): UiEventBus.lock_lever.emit(false)
	],
	"limited": [
		func(): UiEventBus.lock_lever.emit(true),
		preload("res://src/Audio/res/limited.tres"),
		preload("res://src/Audio/res/wehavelimited.tres"),
		func(): UiEventBus.lock_lever.emit(false)
	],
	"zone_unlocked": [
		preload("res://src/Audio/res/Zone_Unlocked.tres"),
		preload("res://src/Audio/res/Zone_Unlocked_Part2.tres"),
		func():
			get_tree().get_first_node_in_group("doortut").show_book_dump(),
		null,
		func():
			get_tree().get_first_node_in_group("warehouse").new_zone(),
	],
	"day_finished": [
		func(): UiEventBus.lock_lever.emit(true),
		preload("res://src/Audio/res/Shift_Over.tres"), 
		preload("res://src/Audio/res/Shift_Over_2.tres"),
		func(): RoundManager.final_evaluation()
	]
}

var quips := {
	"bad_job": [

	],
	"good_job": [preload("res://src/Audio/res/GoodJob1.tres")],
	"too_slow": [preload("res://src/Audio/res/ProductionSpeedBad.tres")]
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
