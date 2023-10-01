extends Node3D

@onready var initial_bookrow: BookShelfRow = $BookRow

func _ready() -> void:
	RoundManager.round_started.connect(round_started)


func round_started(round: int, _books: Array) -> void:
	match(round):
		RoundManager.TUTORIAL_ROUND_1: show_tutorial_shelf()
		RoundManager.TUTORIAL_ROUND_2: show_first_area()
		_: pass


func show_tutorial_shelf() -> void:
	initial_bookrow.get_shelf_for_genre(BookRes.GENRE.CLASSICS).reset()


func show_first_area() -> void:
	for row in get_tree().get_nodes_in_group("zone_1_bookrow"):
		if initial_bookrow:
			row.get_shelf_for_genre(BookRes.GENRE.SCIFI).reset()
			row.get_shelf_for_genre(BookRes.GENRE.BESTSELLERS).reset()
		else:
			row.reset_all()
