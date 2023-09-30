extends Node3D

func _ready() -> void:
	RoundManager.round_started.connect(round_started)
	play_intro()


func play_intro() -> void:
	await play_messages(DialogPacketDb.get_intro_dialog())
	RoundManager.start_game()


func round_started(round: int, _books: Array) -> void:
	match(round):
		RoundManager.TUTORIAL_ROUND_1: play_messages(DialogPacketDb.get_tutorial_dialog(1))
		RoundManager.TUTORIAL_ROUND_2: play_messages(DialogPacketDb.get_tutorial_dialog(2))
		RoundManager.FIRST_ALL_ONE_GENRE_ROUND: pass


func play_messages(messages: Array) -> void:
	for message in messages:
		Announcer.play(message)
		await Announcer.announcement_over
