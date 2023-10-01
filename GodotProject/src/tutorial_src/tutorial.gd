extends Node3D

@onready var book_dump_area: Area3D = $BookDumpArea

func _ready() -> void:
	book_dump_area.visible = false

func show_book_dump() -> void:
	book_dump_area.visible = true
	for body in book_dump_area.get_overlapping_bodies():
		if body is CharacterBody3D:
			end_tutorial_task()
			return
	book_dump_area.body_entered.connect(
		func(body):
			if body is CharacterBody3D:
				end_tutorial_task()
	)

func end_tutorial_task() -> void:
	UiEventBus.tutorial_book_dump.emit()
	book_dump_area.queue_free()
	Announcer._on_audio_stream_player_3d_finished()

