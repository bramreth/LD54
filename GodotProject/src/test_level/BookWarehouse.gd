extends Node3D

@export var fast_intro: bool = false
@onready var animation_player: AnimationPlayer = $BlockedArea/AnimationPlayer

@onready var task_appraisal_lever: StaticBody3D = $TaskAppraisalLever
@onready var blocked_area: StaticBody3D = $BlockedArea
@onready var blocked_area_2: StaticBody3D = $BlockedArea2
@onready var shredder: Node3D = $Shredder
@onready var production_speed_timer: Timer = $Timer

var production_speed_complaint := false

func _ready() -> void:
	RoundManager.round_started.connect(round_started)


func play_intro() -> void:
	get_tree().call_group("conveyor_animator", "play", "Idle")
	get_tree().call_group("conveyor_audio", "play")
	get_tree().call_group("conveyor", "set_constant_linear_velocity", Vector3(-1,0,0))

	if not fast_intro:
		Announcer.queue(DialogPacketDb.get_intro_dialog())
		await Announcer.announcement_over
	RoundManager.start_game()


func round_started(round: int, _books: Array) -> void:
	print("ROUND STARTED: " + str(round))
	start_production_speed_timer()
	match(round):
		RoundManager.TUTORIAL_ROUND_1: Announcer.queue(DialogPacketDb.get_tutorial_dialog(1))
		RoundManager.TUTORIAL_ROUND_2: Announcer.queue(DialogPacketDb.get_tutorial_dialog(2))
		RoundManager.TUTORIAL_ROUND_3: Announcer.queue(DialogPacketDb.get_tutorial_dialog(3))
		3: Announcer.queue(DialogPacketDb.dialog_packets.unlock_hands)
		4: Announcer.queue(DialogPacketDb.dialog_packets.scifi_round)
		5: Announcer.queue(DialogPacketDb.dialog_packets.limited)
		6: Announcer.queue(DialogPacketDb.dialog_packets.diesel)
		RoundManager.BLOCKED_AREA_UNVEILED:
			Announcer.queue(DialogPacketDb.dialog_packets.zone_unlocked)
		8: Announcer.queue(DialogPacketDb.dialog_packets.shredder)
		9: Announcer.queue(DialogPacketDb.dialog_packets.overdue)
		RoundManager.FINAL_ROUND: Announcer.queue(DialogPacketDb.dialog_packets.day_finished)

func _on_check_button_toggled(button_pressed: bool) -> void:
	fast_intro = button_pressed

func new_zone() -> void:
	shredder.start(
	)
	animation_player.play("Dissapear")
	$SFXAudioSmash.play()
			
func start_production_speed_timer() -> void:
	production_speed_timer.stop()
	if production_speed_complaint: return
	production_speed_timer.start(45)


func _on_timer_timeout() -> void:
	production_speed_complaint = true
	Announcer.queue(DialogPacketDb.quips.too_slow, -1)


func _on_audio_stream_player_3d_finished() -> void:
	$Music/AudioStreamPlayer3D.play()
