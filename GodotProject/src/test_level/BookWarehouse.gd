extends Node3D

@export var fast_intro: bool = false
@onready var task_appraisal_lever: StaticBody3D = $TaskAppraisalLever

func _ready() -> void:
	RoundManager.round_started.connect(round_started)


func play_intro() -> void:
	get_tree().call_group("conveyor_animator", "play", "Idle")
	get_tree().call_group("conveyor", "set_constant_linear_velocity", Vector3(-1,0,0))

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
