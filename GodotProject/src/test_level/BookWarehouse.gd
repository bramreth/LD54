extends Node3D

@export var fast_intro: bool = false
@onready var task_appraisal_lever: StaticBody3D = $TaskAppraisalLever
@onready var blocked_area: StaticBody3D = $BlockedArea
@onready var blocked_area_2: StaticBody3D = $BlockedArea2

func _ready() -> void:
	RoundManager.round_started.connect(round_started)
	play_intro()


func play_intro() -> void:
	if not fast_intro:
		Announcer.queue(DialogPacketDb.get_intro_dialog())
		await Announcer.announcement_over
	RoundManager.start_game()
#	task_appraisal_lever.locked = false


func round_started(round: int, _books: Array) -> void:
	match(round):
		RoundManager.TUTORIAL_ROUND_1: Announcer.queue(DialogPacketDb.get_tutorial_dialog(1))
		RoundManager.TUTORIAL_ROUND_2: Announcer.queue(DialogPacketDb.get_tutorial_dialog(2))
		RoundManager.FIRST_ALL_ONE_GENRE_ROUND: pass
		RoundManager.BLOCKED_AREA_UNVEILED: blocked_area.queue_free()
