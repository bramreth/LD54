extends Node3D

func _ready() -> void:
	play_intro()


func play_intro() -> void:
	for message in DialogPacketDb.get_intro_dialog():
		Announcer.play(message)
		await Announcer.announcement_over
	
	RoundManager.start_game()
