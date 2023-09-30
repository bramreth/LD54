extends Node3D

func _ready() -> void:
	RoundManager.round_started.connect(round_started)
	play_intro()


func play_intro() -> void:
	for message in DialogPacketDb.get_intro_dialog():
		Announcer.play(message)
		await Announcer.announcement_over

	RoundManager.start_game()


func round_started(round: int, _books: Array) -> void:
	match(round):
		RoundManager.TUTORIAL_ROUND_1: pass
		RoundManager.TUTORIAL_ROUND_2: pass
		RoundManager.FIRST_ALL_ONE_GENRE_ROUND: pass
		
