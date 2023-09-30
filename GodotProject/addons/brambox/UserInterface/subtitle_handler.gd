extends MarginContainer

@onready var dialogue_label: Label = $Subtitles/DialogueLabel

@onready var settings := get_tree().get_first_node_in_group("Settings")

var playing_payload := []

func _ready() -> void:
	visible = false
	Announcer.announcement.connect(play)
	Announcer.announcement_over.connect(announcement_over)

func play(packet: DialogPacket) -> void:
	visible = settings.subtitles_enabled()
	dialogue_label.text = packet.text


func announcement_over() -> void:
	dialogue_label.text = ""
	visible = false
